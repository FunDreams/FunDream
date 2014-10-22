//
//  Processor.mm
//  FunDreams
//
//  Created by Konstantin on 04.12.10.
//  Copyright 2010 FunDreams. All rights reserved.
//

#import "Processor_ex.h"
#import "UniCell.h"

//-------------------------------------------------------------------------------------------
@implementation ProcStage_ex
- (id)InitWithParent_ex:(Processor_ex *)ProcParent{
    self = [super init];
    if (self != nil)
    {
        pParent=ProcParent;
    }
    
	return self;
}
//-------------------------------------------------------------------------------------------
- (void)SetTimer{
    
    int m_pTimeBase;
    int m_pTimeRnd;
    
    if(m_pTimeRnd_Timer!=0)m_pTimeRnd=*m_pTimeRnd_Timer;
    else m_pTimeRnd=1;
    
    if(m_pTimeBase_Timer!=0)m_pTimeBase=*m_pTimeBase_Timer;
    else m_pTimeBase=0;
    
    if(m_pTimeRnd==0)m_pTimeRnd=1;

    m_pTime=(float)((RND%m_pTimeRnd)+m_pTimeBase)*0.001f;
    
    NSString *Str = NSStringFromSelector(m_selector);

    if(![Str isEqualToString:@"SelfTimerProc:"] && m_pTime!=0){
        m_selector=NSSelectorFromString(@"SelfTimerProc:");
    }
}
//-------------------------------------------------------------------------------------------
- (void)SetDelay{
    
    int m_pTimeBase;
    int m_pTimeRnd;
    
    if(m_pTimeBase_Delay!=0)m_pTimeBase=*m_pTimeBase_Delay;
    else m_pTimeBase=0;
    
    if(m_pTimeRnd_Delay!=0)m_pTimeRnd=*m_pTimeRnd_Delay;
    else m_pTimeRnd=1;
    
    if(m_pTimeRnd==0)m_pTimeRnd=1;
    
    m_pTime=(float)((RND%m_pTimeRnd)+m_pTimeBase)*0.001f;
    
    NSString *Str = NSStringFromSelector(m_selector);
    
    if(![Str isEqualToString:@"SelfTimer:"] && m_pTime!=0){
        m_selector=NSSelectorFromString(@"SelfTimer:");
    }
}
//-------------------------------------------------------------------------------------------
- (void)Prepare{
    
    bool bDelay=false;
    if(m_pTimeBase_Delay!=0 || m_pTimeRnd_Delay!=0){
        bDelay=YES;
        
        [self SetDelay];
    }
    else{

        if(m_pTimeBase_Timer!=0 || m_pTimeRnd_Timer!=0){
            [self SetTimer];
        }
    }

    if(m_selectorPrepare!=nil && bDelay==false){
        [pParent->m_pObject performSelector:m_selectorPrepare withObject:self];
    }
}
@end
//-------------------------------------------------------------------------------------------
@implementation Processor_ex

- (id)InitWithName:(NSString *)strName WithParent:(id)pParent{
    self = [super init];
    if (self != nil)
    {
        pDicStages = [[NSMutableDictionary alloc] init];
        
        m_pObject=pParent;
        m_pNameProcessor=[NSString stringWithString:strName];
	}
    
	return self;
}
////-------------------------------------------------------------------------------------------
//- (void)Delay_Stage:(NSString *)NameStage Time:(int)iTime TimeRnd:(int)iTimeRnd{
//    
//    return;
//    
//    ProcStage_ex *CurrStageTmp = (ProcStage_ex *)[pDicStages objectForKey:NameStage];
//    
//    if (CurrStageTmp!=nil){
//        
//        CurrStageTmp->m_pTimeRnd=iTimeRnd;
//        CurrStageTmp->m_pTimeBase=iTime;
//        
//        [CurrStageTmp SetDelay];
//    }
//}
//-------------------------------------------------------------------------------------------
- (NSString *)GetNameStage{
    if(m_CurStage!=nil)return m_CurStage->NameStage;
    else return nil;
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

/////////////////////////////////////
        NSString *StrNameSelInit=[NSString stringWithFormat:@"%@%@%@%@",
                          m_pObject->m_strName,m_pNameProcessor,NameStage,@"SelectorInit"];
        
        NSMutableString *str_SelInit = [m_pObject->m_pObjMng->pMegaTree GetIdValue:StrNameSelInit,nil];
        NSString *TmpStrSelInit=nil;
        
        if(str_SelInit!=nil){
            TmpStrSelInit=[NSString stringWithString:str_SelInit];
        }
        else{
            TmpStrSelInit=[NSString stringWithFormat:@"Init%@",
                                     NSStringFromSelector(CurrStage->m_selector)];
        }
        
        CurrStage->m_selectorInit=nil;
        SEL InitSel=NSSelectorFromString(TmpStrSelInit);
        
        if([m_pObject respondsToSelector:InitSel]){
            CurrStage->m_selectorInit=InitSel;
            [m_pObject performSelector:InitSel withObject:CurrStage];
        }
        
/////////////////////////////////////
        NSString *StrNameSelPrepare=[NSString stringWithFormat:@"%@%@%@%@",
                                  m_pObject->m_strName,m_pNameProcessor,NameStage,@"SelectorPrepare"];
        
        NSMutableString *str_SelPrepare = 
        [m_pObject->m_pObjMng->pMegaTree GetIdValue:StrNameSelPrepare,nil];
        
        NSString *TmpStrSelPrepare=nil;
        
        if(str_SelPrepare!=nil){
            TmpStrSelPrepare=[NSString stringWithString:str_SelPrepare];
        }
        else{
            TmpStrSelPrepare=[NSString stringWithFormat:@"Prepare%@",
                           NSStringFromSelector(CurrStage->m_selector)];
        }
        
        CurrStage->m_selectorPrepare=nil;
        SEL PrepareSel=NSSelectorFromString(TmpStrSelPrepare);
        
        if([m_pObject respondsToSelector:PrepareSel]){
            CurrStage->m_selectorPrepare=PrepareSel;
        }
        
////////////////////////////////////////////////////
        //линкуем параметры для времени. Таймер и задержка
        NSString *TmpStr=[NSString stringWithFormat:@"%@%@%@",
                          m_pObject->m_strName,m_pNameProcessor,NameStage];
        
        NSString *NameParam=[NSString stringWithFormat:@"%@TimeRndDelay",TmpStr];
        CurrStage->m_pTimeRnd_Delay=[m_pObject->m_pObjMng->pMegaTree GetIntValue:NameParam,nil];

        NameParam=[NSString stringWithFormat:@"%@TimeBaseDelay",TmpStr];
        CurrStage->m_pTimeBase_Delay=[m_pObject->m_pObjMng->pMegaTree GetIntValue:NameParam,nil];

        NameParam=[NSString stringWithFormat:@"%@TimeRndTimer",TmpStr];
        CurrStage->m_pTimeRnd_Timer=[m_pObject->m_pObjMng->pMegaTree GetIntValue:NameParam,nil];

        NameParam=[NSString stringWithFormat:@"%@TimeBaseTimer",TmpStr];
        CurrStage->m_pTimeBase_Timer=[m_pObject->m_pObjMng->pMegaTree GetIntValue:NameParam,nil];
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
        CurrStageTmp->m_selectorStage=CurrStageInsert->m_selector;

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
    
    ProcStage_ex *CurrStageTmp=(ProcStage_ex *)[pDicStages objectForKey:NameStage];
    
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
    CurrStageTmp->m_selectorStage=CurrStageTmp->m_selector;

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
	[pDicStages release];
	
	[super dealloc];
}
//-------------------------------------------------------------------------------------------
@end