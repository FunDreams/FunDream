//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_BigWheel.h"
#import "Ob_Editor_Interface.h"

@implementation Ob_BigWheel
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerInterfaceSpace11;
        m_iLayerTouch=layerTouch_2N;//слой касания
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
    
    //   GET_DIM_FROM_TEXTURE(@"");
    m_bHiden=NO;
	mWidth  = 50;
	mHeight = 250;
    
    m_pCurPosition.x=-485;
    m_pCurPosition.y=-260;

	[super Start];

    [self SetTouch:YES];//интерактивность
    GET_TEXTURE(mTextureId, @"EditParam.png");

    //[m_pObjMng AddToGroup:@"NameGroup" Object:self];//группировка
    //[self SelfOffsetVert:Vector3DMake(0,1,0)];//cдвиг
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
- (void)dealloc{[super dealloc];}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
- (void)touchesBeganOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    StartPoint=Point;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    StartPoint=Point;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    StartPoint=Point;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    LOCK_TOUCH;

    int iDelta;
    float fDelta=(Point.y-StartPoint.y);
    
    StartPoint=Point;

    Ob_Editor_Interface *pInterface=(Ob_Editor_Interface *)[m_pObjMng
                                        GetObjectByName:@"Ob_Editor_Interface"];

    
    if(pInterface->StringSelect!=0)
    {
        int iType = [m_pObjMng->pStringContainer->ArrayPoints
                    GetTypeAtIndex:pInterface->StringSelect->m_iIndex];
        
        switch (iType) {
            case DATA_ARRAY:
            {
                int **ppArray=[m_pObjMng->pStringContainer->ArrayPoints
                               GetArrayAtIndex:pInterface->StringSelect->m_iIndex];
                
                InfoArrayValue *pInfo=(InfoArrayValue *)(*ppArray);
                int *pStartData=(*ppArray)+SIZE_INFO_STRUCT;

                switch (pInfo->mType) {

                    case DATA_FLOAT:
                    {
                        if(fabs(fDelta)>40)
                            fDelta=fDelta*2.0;
                        else if(fabs(fDelta)>10)
                            fDelta=fDelta*0.5;
                        else fDelta=fDelta*.05f;

                        float *pValue = (float *)[m_pObjMng->pStringContainer->ArrayPoints
                                                   GetDataAtIndex:pStartData[0]];

                        *pValue+=fDelta;
                    }
                    break;

                    case DATA_INT:
                    {
                        if(fabs(fDelta)>10)
                        {
                            float *pValue = (float *)[m_pObjMng->pStringContainer->ArrayPoints
                                                   GetDataAtIndex:pStartData[0]];

                            if(fDelta>0)iDelta=1;
                            if(fDelta<0)iDelta=-1;

                            *pValue=(int)(*pValue+iDelta);
                        }
                    }
                    break;

                default:
                    break;
                }
            }
        }
    }
    else{
        
        if(pInterface->IndexSelect!=-1)
        {
            int iType=[m_pObjMng->pStringContainer->ArrayPoints
                       GetTypeAtIndex:pInterface->IndexSelect];
            
            switch (iType) {

                case DATA_FLOAT:
                {
                    if(fabs(fDelta)>40)
                        fDelta=fDelta*2.0;
                    else if(fabs(fDelta)>10)
                        fDelta=fDelta*0.5;
                    else fDelta=fDelta*.05f;

                    float *pValue = (float *)[m_pObjMng->pStringContainer->ArrayPoints
                                              GetDataAtIndex:pInterface->IndexSelect];

                    *pValue+=fDelta;
                }
                break;

                case DATA_INT:
                {
                    if(fabs(fDelta)>10)
                    {
                        float *pValue = (float *)[m_pObjMng->pStringContainer->ArrayPoints
                                              GetDataAtIndex:pInterface->IndexSelect];
                        
                        if(fDelta>0)iDelta=1;
                        if(fDelta<0)iDelta=-1;
                        
                        *pValue=(int)(*pValue+iDelta);
                    }
                }
                break;
                    
                default:
                    break;
            }
        }
    }
}
//------------------------------------------------------------------------------------------------------
@end