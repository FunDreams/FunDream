//
//  Processor.mm
//  FunDreams
//
//  Created by Konstantin on 04.12.10.
//  Copyright 2010 FunDreams. All rights reserved.
//

#import "Processor_ex.h"
//-------------------------------------------------------------------------------------------
@implementation ProcStage_ex
- (id)InitWithParent_ex:(Processor_ex *)ProcParent{
	pParent=ProcParent;
	return self;
}
//-------------------------------------------------------------------------------------------
- (void)SetDelay{
    
    m_pTime=(float)((RND%m_pTimeRnd)+m_pTimeBase)*0.001f;
    
    NSString *Str = NSStringFromSelector(m_selector);
    
    if(![Str isEqualToString:@"SelfTimer:"]){
        m_selectorSecond=m_selector;
        m_selector=NSSelectorFromString(@"SelfTimer:");
    }

}
//-------------------------------------------------------------------------------------------
- (void)Prepare {
    
    if(m_pTimeBase!=0){        
        [self SetDelay];
    }
    
    NSString *TmpStrSelPrepare=[NSString stringWithFormat:@"Prepare%@",
                             NSStringFromSelector(m_selector)];
    
    SEL InitSel=NSSelectorFromString(TmpStrSelPrepare);
    
    if([pParent->m_pObject respondsToSelector:InitSel]){
        [pParent->m_pObject performSelector:InitSel withObject:self];
    }
}
//-------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//-------------------------------------------------------------------------------------------
@end
//-------------------------------------------------------------------------------------------
@implementation Processor_ex
//-------------------------------------------------------------------------------------------
- (id)InitWithName:(NSString *)strName WithParent:(id)pParent{

	pDicStages = [[NSMutableDictionary alloc] init];
	
	m_pObject=pParent;
	m_pNameProcessor=[NSString stringWithString:strName];
	
	return self;
}
//-------------------------------------------------------------------------------------------
- (void)Delay_Stage:(NSString *)NameStage Time:(int)iTime TimeRnd:(int)iTimeRnd{
    
    ProcStage_ex *CurrStageTmp = (ProcStage_ex *)[pDicStages objectForKey:NameStage];
    
    if (CurrStageTmp!=nil){
        
        CurrStageTmp->m_pTimeRnd=iTimeRnd;
        CurrStageTmp->m_pTimeBase=iTime;
        
        [CurrStageTmp SetDelay];
    }
}
//-------------------------------------------------------------------------------------------
- (void)Remove_Stage:(NSString *)NameStage{
    ProcStage_ex *CurrStageTmp = (ProcStage_ex *)[pDicStages objectForKey:NameStage];

    if (CurrStageTmp!=nil){
        
        if(CurrStageTmp->StageNext!=nil){
            CurrStageTmp->StageNext->StagePrev=CurrStageTmp->StagePrev;
        }
        else{
            m_LastStage=CurrStageTmp->StagePrev;
        }

        if(CurrStageTmp->StagePrev!=nil){
            CurrStageTmp->StagePrev->StageNext=CurrStageTmp->StageNext;
        }
        else{
            m_FirstStage=CurrStageTmp->StageNext;
        }

        [pDicStages removeObjectForKey:NameStage];
        [CurrStageTmp release];
    }
}
//-------------------------------------------------------------------------------------------
- (void)SetParams:(NSString *)NameStage WithParams:(NSArray *)Parametrs{
    
    ProcStage_ex *CurrStage = (ProcStage_ex *)[pDicStages objectForKey:NameStage ];

    if (CurrStage!=nil){
        
        for (int i=0; i<[Parametrs count]; i++) {
            
            UniCell* pParams = (UniCell*)[Parametrs objectAtIndex:i];
            
            NSString *TmpStr=[NSString stringWithFormat:@"%@%@%@%@",
                              m_pObject->m_strName,m_pNameProcessor,NameStage,pParams->mpName];
            pParams->mpName=[NSString stringWithString:TmpStr];
            [m_pObject->m_pObjMng->pMegaTree SetCell:pParams];
        }
        
        NSString *TmpStrSelInit=[NSString stringWithFormat:@"Init%@",
                                 NSStringFromSelector(CurrStage->m_selector)];
        
        SEL InitSel=NSSelectorFromString(TmpStrSelInit);
        
        if([m_pObject respondsToSelector:InitSel]){
            [m_pObject performSelector:InitSel withObject:CurrStage];
        }
    }
}
//-------------------------------------------------------------------------------------------
- (void)Insert_Stage:(NSString *)NameStage WithSel:(NSString *)NameSel
          afterStage:(NSString *)afretName WithParams:(NSArray *)Parametrs{
    
    ProcStage_ex *CurrStageTmp = (ProcStage_ex *)[pDicStages objectForKey:afretName ];
    if (CurrStageTmp==nil){
        
        if(afretName==nil){
            
            ProcStage_ex *CurrStageInsert = [[ProcStage_ex alloc] InitWithParent_ex:self];
            CurrStageInsert->m_selector=NSSelectorFromString ( NameSel);
            CurrStageInsert->NameStage=[NSString stringWithString:NameStage];
            
            CurrStageInsert->StageNext=m_FirstStage;
            m_FirstStage->StagePrev=CurrStageInsert;
            m_FirstStage=CurrStageInsert;
            
            [self SetParams:CurrStageInsert->NameStage WithParams:Parametrs];
        }
        else [self Assign_Stage:NameStage WithSel:NameSel WithParams:Parametrs];
    }
    else{
        
        ProcStage_ex *CurrStageInsert = [[ProcStage_ex alloc] InitWithParent_ex:self];
        CurrStageInsert->m_selector=NSSelectorFromString ( NameSel);
        CurrStageInsert->NameStage=[NSString stringWithString:NameStage];

        CurrStageInsert->StagePrev = CurrStageTmp;
        
        if(CurrStageTmp->StageNext !=nil){
            CurrStageTmp->StageNext->StagePrev=CurrStageInsert;
            CurrStageInsert->StageNext=CurrStageTmp->StageNext;
        }
        
        CurrStageTmp->StageNext=CurrStageInsert;
        [pDicStages setObject:CurrStageInsert forKey:NameStage];
        
        [self SetParams:CurrStageInsert->NameStage WithParams:Parametrs];
    }
}
//-------------------------------------------------------------------------------------------
- (void)Assign_Stage:(NSString *)NameStage WithSel:(NSString *)NameSel WithParams:(NSArray *)Parametrs{
    
    ProcStage_ex *CurrStageTmp= (ProcStage_ex *)[pDicStages objectForKey:NameStage ];
    
	if (CurrStageTmp==nil){
		CurrStageTmp = [[ProcStage_ex alloc] InitWithParent_ex:self];
		[pDicStages setObject:CurrStageTmp forKey:NameStage];
        
        if(m_LastStage!=nil){
            m_LastStage->StageNext=CurrStageTmp;
            CurrStageTmp->StagePrev=m_LastStage;
        }
        
        m_LastStage=CurrStageTmp;
	}

    CurrStageTmp->m_selector=NSSelectorFromString ( NameSel);
    CurrStageTmp->NameStage=[NSString stringWithString:NameStage];
    
    if(m_FirstStage==nil){
        m_FirstStage=CurrStageTmp;
    }
    
    [self SetParams:CurrStageTmp->NameStage WithParams:Parametrs];    
}
//-------------------------------------------------------------------------------------------
- (void)SetStage:(NSString *)Stage{
    
    ProcStage_ex *CurrStageTmp = (ProcStage_ex *)[pDicStages objectForKey:Stage];

    if(CurrStageTmp!=nil){
        
        m_CurStage=CurrStageTmp;
        [m_CurStage Prepare];
    }
}
//-------------------------------------------------------------------------------------------
- (void)NextStage{
    
    if(m_CurStage!=nil){
        
        ProcStage_ex *CurrStageNext = m_CurStage->StageNext;
        
        if(CurrStageNext!=nil){m_CurStage=CurrStageNext;}
        else {m_CurStage=m_FirstStage;}
        
        [m_CurStage Prepare];            
    }
}
//-------------------------------------------------------------------------------------------
- (void)dealloc {

	NSEnumerator *enumerator = [pDicStages objectEnumerator];
	id value;
	
	while ((value = [enumerator nextObject])) {[value release];}
	
	[pDicStages release];
	
	[super dealloc];
}
//-------------------------------------------------------------------------------------------
@end