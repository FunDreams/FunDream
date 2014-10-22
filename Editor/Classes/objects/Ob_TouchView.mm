//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_TouchView.h"
#import "Ob_ParticleCont_ForStr.h"

@implementation Ob_TouchView
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerTemplet;
        m_iLayerTouch=layerTouch_0;//слой касания
        pDic= [[NSMutableDictionary alloc] init];
        
        pCycle=m_pObjMng->pStringContainer->pMainCycle;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
//- (void)SetDefault{}
//- (void)PostSetParams{}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
//====//процессоры для объекта==========================================================================
    Processor_ex* pProc = [self START_QUEUE:@"Proc"];
  //      ASSIGN_STAGE(@"IDLE",@"Idle:",nil);
        ASSIGN_STAGE(@"PROC",@"Proc:",nil);
    [self END_QUEUE:pProc name:@"Proc"];
    
//====//различные параметры=============================================================================
//   [m_pObjMng->pMegaTree SetCell:(LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY"))];
    
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    [m_pObjMng->pMegaTree SetCell:(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"))];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
    m_bHiden=YES;

    //   GET_DIM_FROM_TEXTURE(@"");
	mWidth  = 512;
	mHeight = 768;

	[super Start];

    [self SetTouch:YES];//интерактивность
    mColor=Color3DMake(1,0,0,0.3f);
    
    Ob_ParticleCont_ForStr *TmpOb = (Ob_ParticleCont_ForStr *)[m_pObjMng GetObjectByName:@"SpriteContainer"];
    TmpOb->pTouchOb=self;
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
//------------------------------------------------------------------------------------------------------
- (void)InitProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)PrepareProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{
    
//    PLAY_SOUND(@"");
//    STOP_SOUND(@"");
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{
    [pDic release];
    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
- (void)ConvertPoint:(CGPoint *)pPoint
{
    Ob_ParticleCont_ForStr *pObTmp=(Ob_ParticleCont_ForStr*)[m_pObjMng GetObjectByName:@"SpriteContainer"];
    if(pObTmp!=nil)
    {
        pPoint->x-=(m_pCurPosition.x);//offset 256
        
        Vector3D TmpPoint=Vector3DMake(pPoint->x,pPoint->y, 0);
    
        Vector3D TmpRotate=Vector3DRotateZ2D(TmpPoint,-pObTmp->m_pCurAngle.x);
        
        pPoint->x=TmpRotate.x;
        pPoint->y=TmpRotate.y;
        
        pPoint->x/=pObTmp->m_pCurScale.x;
        pPoint->y/=pObTmp->m_pCurScale.y;
        
        pPoint->x-=pObTmp->m_pCurPosition.x;
        pPoint->y-=pObTmp->m_pCurPosition.y;
    }
}
//------------------------------------------------------------------------------------------------------
int TmpArray[10];
//------------------------------------------------------------------------------------------------------
- (void)ZeroMemory{

    TmpArray[0]=0;
    TmpArray[1]=0;
    TmpArray[2]=0;
    TmpArray[3]=0;
    TmpArray[4]=0;
    TmpArray[5]=0;
    TmpArray[6]=0;
    TmpArray[7]=0;
    TmpArray[8]=0;
    TmpArray[9]=0;
    
    [pDic removeAllObjects];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{

    NSNumber *pNum=[NSNumber numberWithInt:(int)CurrentTouch];
    NSNumber *Prez = [pDic objectForKey:pNum];

    if(Prez==nil)
    {
        if([pDic count]>=10)return;
        memset(TmpArray, 0, sizeof(TmpArray));
        
        NSEnumerator *Ob_enumerator = [pDic objectEnumerator];
        NSNumber *pOb;
        
        while ((pOb = [Ob_enumerator nextObject])) {
            TmpArray[[pOb intValue]]=1;
        }
        
        for (int i=0; i<10; i++) {
            if(TmpArray[i]==0)
            {
                NSNumber *pNumNew=[NSNumber numberWithInt:i];
                [pDic setObject:pNumNew forKey:pNum];
                [m_pObjMng->pStringContainer->m_OperationIndex
                 OnlyAddData:i WithData:pCycle->ppNumtouchBegin];

     //           [m_pObjMng->pStringContainer LogDataPoint:pCycle->ppNumtouchBegin Name:@"ppNumtouchBegin"];
                
                [self ConvertPoint:&Point];
                [m_pObjMng->pStringContainer->m_OperationIndex
                 OnlyAddData:Point.x WithData:pCycle->ppXtouchBegin];
                [m_pObjMng->pStringContainer->m_OperationIndex
                 OnlyAddData:Point.y WithData:pCycle->ppYtouchBegin];

                break;
            }
        }        
    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesBeganOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    NSNumber *pNum=[NSNumber numberWithInt:(int)CurrentTouch];
    NSNumber *Prez = [pDic objectForKey:pNum];
    
    if(Prez!=nil)
    {
        [m_pObjMng->pStringContainer->m_OperationIndex
                OnlyAddData:[Prez intValue] WithData:pCycle->ppNumtouchMove];
        
    //    [m_pObjMng->pStringContainer LogDataPoint:pCycle->ppNumtouchMove Name:@"ppNumtouchMove"];

        [self ConvertPoint:&Point];
        [m_pObjMng->pStringContainer->m_OperationIndex OnlyAddData:Point.x WithData:pCycle->ppXtouchMove];
        [m_pObjMng->pStringContainer->m_OperationIndex OnlyAddData:Point.y WithData:pCycle->ppYtouchMove];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    NSNumber *pNum=[NSNumber numberWithInt:(int)CurrentTouch];
    NSNumber *Prez = [pDic objectForKey:pNum];
    
    if(Prez!=nil)
    {
        [m_pObjMng->pStringContainer->m_OperationIndex
         OnlyAddData:[Prez intValue] WithData:pCycle->ppNumtouchEnd];
        
 //       [m_pObjMng->pStringContainer LogDataPoint:pCycle->ppNumtouchEnd Name:@"ppNumtouchEnd"];
        
        [self ConvertPoint:&Point];
        [m_pObjMng->pStringContainer->m_OperationIndex OnlyAddData:Point.x WithData:pCycle->ppXtouchEnd];
        [m_pObjMng->pStringContainer->m_OperationIndex OnlyAddData:Point.y WithData:pCycle->ppYtouchEnd];
        
        TmpArray[[Prez intValue]]=0;
        [pDic removeObjectForKey:pNum];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEndedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    NSNumber *pNum=[NSNumber numberWithInt:(int)CurrentTouch];
    NSNumber *Prez = [pDic objectForKey:pNum];
    
    if(Prez!=nil)
    {
        [m_pObjMng->pStringContainer->m_OperationIndex
         OnlyAddData:[Prez intValue] WithData:pCycle->ppNumtouchEnd];
        
  //      [m_pObjMng->pStringContainer LogDataPoint:pCycle->ppNumtouchEnd Name:@"ppNumtouchEnd"];
        
        [self ConvertPoint:&Point];
        [m_pObjMng->pStringContainer->m_OperationIndex OnlyAddData:Point.x WithData:pCycle->ppXtouchEnd];
        [m_pObjMng->pStringContainer->m_OperationIndex OnlyAddData:Point.y WithData:pCycle->ppYtouchEnd];
        
        TmpArray[[Prez intValue]]=0;
        [pDic removeObjectForKey:pNum];
    }
}
//------------------------------------------------------------------------------------------------------
@end