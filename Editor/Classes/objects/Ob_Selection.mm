//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_Selection.h"
#import "Ob_Editor_Interface.h"

@implementation Ob_Selection
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerTemplet;
        m_iLayerTouch=layerTouch_0;//слой касания
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{
    CurrentStr=0;
    m_bHiden=YES;
}
//------------------------------------------------------------------------------------------------------
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
    
    //GET_DIM_FROM_TEXTURE(@"");
	mWidth  = 50;
	mHeight = 50;

	[super Start];

    //   [self SetTouch:YES];//интерактивность
    GET_TEXTURE(mTextureId, m_pNameTexture);

    //[m_pObjMng AddToGroup:@"NameGroup" Object:self];//группировка
    //[self SelfOffsetVert:Vector3DMake(0,1,0)];//cдвиг
    
    pObBtnClose=UNFROZE_OBJECT(@"ObjectButton",@"ButtonClose",
                               SET_STRING_V(@"Close.png",@"m_DOWN"),
                               SET_STRING_V(@"Close.png",@"m_UP"),
                               SET_FLOAT_V(44,@"mWidth"),
                               SET_FLOAT_V(44,@"mHeight"),
                               SET_BOOL_V(YES,@"m_bLookTouch"),
                               SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                               SET_INT_V(layerTouch_2N,@"m_iLayerTouch"),
                               SET_STRING_V(NAME(self),@"m_strNameObject"),
                               SET_STRING_V(@"Close",@"m_strNameStage"),
                               SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                               SET_VECTOR_V(Vector3DMake(-26,360,0),@"m_pCurPosition"));

//    pObBtnUp=UNFROZE_OBJECT(@"ObjectButton",@"ButtonUp",
//                               SET_STRING_V(@"Button_From_box_Up.png",@"m_DOWN"),
//                               SET_STRING_V(@"Button_From_box_Up.png",@"m_UP"),
//                               SET_FLOAT_V(64,@"mWidth"),
//                               SET_FLOAT_V(64,@"mHeight"),
//                               SET_BOOL_V(YES,@"m_bLookTouch"),
//                               SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
//                               SET_INT_V(layerTouch_2N,@"m_iLayerTouch"),
//                               SET_STRING_V(NAME(self),@"m_strNameObject"),
//                               SET_STRING_V(@"Up",@"m_strNameStage"),
//                               SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
//                               SET_VECTOR_V(Vector3DMake(-300,100,0),@"m_pCurPosition"));
//
//    pObBtnDown=UNFROZE_OBJECT(@"ObjectButton",@"ButtonDown",
//                               SET_STRING_V(@"Button_To_box_Up.png",@"m_DOWN"),
//                               SET_STRING_V(@"Button_To_box_Up.png",@"m_UP"),
//                               SET_FLOAT_V(64,@"mWidth"),
//                               SET_FLOAT_V(64,@"mHeight"),
//                               SET_BOOL_V(YES,@"m_bLookTouch"),
//                               SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
//                               SET_INT_V(layerTouch_2N,@"m_iLayerTouch"),
//                               SET_STRING_V(NAME(self),@"m_strNameObject"),
//                               SET_STRING_V(@"Down",@"m_strNameStage"),
//                               SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
//                               SET_VECTOR_V(Vector3DMake(-230,100,0),@"m_pCurPosition"));
    
    pObBtnSetSimple=UNFROZE_OBJECT(@"ObjectButton",@"SetSimple",
                              SET_INT_V(bRadioBox,@"m_iType"),
                              SET_STRING_V(@"Simple.png",@"m_DOWN"),
                              SET_STRING_V(@"Simple.png",@"m_UP"),
                              SET_FLOAT_V(64,@"mWidth"),
                              SET_FLOAT_V(64,@"mHeight"),
                              SET_BOOL_V(YES,@"m_bLookTouch"),
                              SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                              SET_INT_V(layerTouch_2N,@"m_iLayerTouch"),
                              SET_STRING_V(NAME(self),@"m_strNameObject"),
                              SET_STRING_V(@"SetSimple",@"m_strNameStage"),
                              SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                              SET_VECTOR_V(Vector3DMake(-320,0,0),@"m_pCurPosition"));
    pObBtnSetEnter=UNFROZE_OBJECT(@"ObjectButton",@"SetEnter",
                              SET_INT_V(bRadioBox,@"m_iType"),
                              SET_STRING_V(@"Enter.png",@"m_DOWN"),
                              SET_STRING_V(@"Enter.png",@"m_UP"),
                              SET_FLOAT_V(64,@"mWidth"),
                              SET_FLOAT_V(64,@"mHeight"),
                              SET_BOOL_V(YES,@"m_bLookTouch"),
                              SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                              SET_INT_V(layerTouch_2N,@"m_iLayerTouch"),
                              SET_STRING_V(NAME(self),@"m_strNameObject"),
                              SET_STRING_V(@"SetEnter",@"m_strNameStage"),
                              SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                              SET_VECTOR_V(Vector3DMake(-250,0,0),@"m_pCurPosition"));
    pObBtnSetExit=UNFROZE_OBJECT(@"ObjectButton",@"SetExit",
                              SET_INT_V(bRadioBox,@"m_iType"),
                              SET_STRING_V(@"Exit.png",@"m_DOWN"),
                              SET_STRING_V(@"Exit.png",@"m_UP"),
                              SET_FLOAT_V(64,@"mWidth"),
                              SET_FLOAT_V(64,@"mHeight"),
                              SET_BOOL_V(YES,@"m_bLookTouch"),
                              SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                              SET_INT_V(layerTouch_2N,@"m_iLayerTouch"),
                              SET_STRING_V(NAME(self),@"m_strNameObject"),
                              SET_STRING_V(@"SetExit",@"m_strNameStage"),
                              SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                              SET_VECTOR_V(Vector3DMake(-180,0,0),@"m_pCurPosition"));
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateTmp{
    return;
    switch (CurrentStr->m_iAdditionalType) {
        case ADIT_TYPE_SIMPLE:
            OBJECT_PERFORM_SEL(NAME(pObBtnSetSimple),  @"SetPush");
            break;
            
        case ADIT_TYPE_ENTER:
            OBJECT_PERFORM_SEL(NAME(pObBtnSetEnter),  @"SetPush");
            break;
            
        case ADIT_TYPE_EXIT:
            OBJECT_PERFORM_SEL(NAME(pObBtnSetExit),  @"SetPush");
            break;
            
        default:
            break;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)DelAnyWhere{
    MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints
                       GetMatrixAtIndex:CurrentStr->pParent->m_iIndex];
    
    if(pMatr!=0){
        
        InfoArrayValue *InfoStrLinks=(InfoArrayValue *)(*pMatr->pLinks);
        int *StartDataLink=((*pMatr->pLinks)+SIZE_INFO_STRUCT);
        
        for (int i=0; i<InfoStrLinks->mCount; i++)
        {
            int iMatrIndex = StartDataLink[i];
            MATRIXcell *TmpMatrInLinks=[m_pObjMng->pStringContainer->ArrayPoints
                                        GetMatrixAtIndex:iMatrIndex];
            
            if(TmpMatrInLinks!=nil)
            {
                
                InfoArrayValue *InfoQueue=(InfoArrayValue *)(*TmpMatrInLinks->pQueue);
                int *StartDataQueue=((*TmpMatrInLinks->pQueue)+SIZE_INFO_STRUCT);
                
                for (int i=0; i<InfoQueue->mCount; i++)
                {
                    HeartMatr *pHeart=(HeartMatr *)StartDataQueue[i];
                    
                    if(pHeart!=nil){
                        
                        InfoArrayValue *InfoEntersH=(InfoArrayValue *)(*pHeart->pEnPairChi);
                        int *StartDataParEnter=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT);
                        
                        for (int j=0; j<InfoEntersH->mCount; j++) {
                            int TmpIndexInLink=StartDataParEnter[j];
                            
                            if(TmpIndexInLink==CurrentStr->m_iIndex){
                                [m_pObjMng->pStringContainer->m_OperationIndex
                                 OnlyRemoveDataAtPlace:j WithData:pHeart->pEnPairPar];
                                [m_pObjMng->pStringContainer->m_OperationIndex
                                 OnlyRemoveDataAtPlace:j WithData:pHeart->pEnPairChi];
                                break;
                            }
                        }
                        
                        InfoArrayValue *InfoExitrH=(InfoArrayValue *)(*pHeart->pExPairChi);
                        int *StartDataParExit=((*pHeart->pExPairPar)+SIZE_INFO_STRUCT);
                        for (int j=0; j<InfoExitrH->mCount; j++) {
                            int TmpIndexInLink=StartDataParExit[j];
                            
                            if(TmpIndexInLink==CurrentStr->m_iIndex){
                                [m_pObjMng->pStringContainer->m_OperationIndex
                                 OnlyRemoveDataAtPlace:j WithData:pHeart->pExPairPar];
                                [m_pObjMng->pStringContainer->m_OperationIndex
                                 OnlyRemoveDataAtPlace:j WithData:pHeart->pExPairChi];
                                break;
                            }
                        }
                    }
                }
            }
        }

        [m_pObjMng->pStringContainer->m_OperationIndex
         OnlyRemoveDataAtIndex:CurrentStr->m_iIndex WithData:pMatr->pEnters];

        [m_pObjMng->pStringContainer->m_OperationIndex
         OnlyRemoveDataAtIndex:CurrentStr->m_iIndex WithData:pMatr->pExits];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetSimple{
    OBJECT_PERFORM_SEL(NAME(pObBtnSetEnter),  @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(pObBtnSetExit),   @"SetUnPush");
    
    CurrentStr->m_iAdditionalType=ADIT_TYPE_SIMPLE;
    
    if(CurrentStr->pAssotiation!=nil){
        
        id array = [CurrentStr->pAssotiation allKeys];
        
        for (int i=0; i<[array count]; i++) {
            
            int pIndexCurrentAss=[[array objectAtIndex:i] intValue];
            
            if(pIndexCurrentAss!=CurrentStr->m_iIndexSelf)
            {
                FractalString *FAssoc=[CurrentStr->m_pContainer->ArrayPoints
                                        GetIdAtIndex:pIndexCurrentAss];
                
                FAssoc->m_iAdditionalType=ADIT_TYPE_SIMPLE;
            }
        }
    }
    
    [self DelAnyWhere];
}
//------------------------------------------------------------------------------------------------------
- (void)SetEnter{
    OBJECT_PERFORM_SEL(NAME(pObBtnSetSimple), @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(pObBtnSetExit),   @"SetUnPush");
    
    CurrentStr->m_iAdditionalType=ADIT_TYPE_ENTER;
    
    if(CurrentStr->pAssotiation!=nil){
        
        id array = [CurrentStr->pAssotiation allKeys];
        
        for (int i=0; i<[array count]; i++) {
            
            int pIndexCurrentAss=[[array objectAtIndex:i] intValue];
            
            if(pIndexCurrentAss!=CurrentStr->m_iIndexSelf)
            {
                FractalString *FAssoc=[CurrentStr->m_pContainer->ArrayPoints
                                       GetIdAtIndex:pIndexCurrentAss];
                
                FAssoc->m_iAdditionalType=ADIT_TYPE_ENTER;
            }
        }
    }

    [self DelAnyWhere];

    MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints
                       GetMatrixAtIndex:CurrentStr->pParent->m_iIndex];
    
    if(pMatr!=0){
     
        [m_pObjMng->pStringContainer->m_OperationIndex
         OnlyAddData:CurrentStr->m_iIndex WithData:pMatr->pEnters];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetExit{
    OBJECT_PERFORM_SEL(NAME(pObBtnSetSimple), @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(pObBtnSetEnter),  @"SetUnPush");
    
    CurrentStr->m_iAdditionalType=ADIT_TYPE_EXIT;
    
    if(CurrentStr->pAssotiation!=nil){
        
        id array = [CurrentStr->pAssotiation allKeys];
        
        for (int i=0; i<[array count]; i++) {
            
            int pIndexCurrentAss=[[array objectAtIndex:i] intValue];
            
            if(pIndexCurrentAss!=CurrentStr->m_iIndexSelf)
            {
                FractalString *FAssoc=[CurrentStr->m_pContainer->ArrayPoints
                                       GetIdAtIndex:pIndexCurrentAss];
                
                FAssoc->m_iAdditionalType=ADIT_TYPE_EXIT;
            }
        }
    }

    [self DelAnyWhere];

    MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints
                       GetMatrixAtIndex:CurrentStr->pParent->m_iIndex];
    
    if(pMatr!=0){
        [m_pObjMng->pStringContainer->m_OperationIndex
         OnlyAddData:CurrentStr->m_iIndex WithData:pMatr->pExits];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Up{}
//------------------------------------------------------------------------------------------------------
- (void)Down{}
//------------------------------------------------------------------------------------------------------
- (void)Close{
    
    OBJECT_PERFORM_SEL(@"Ob_Editor_Interface", @"Update");
    DESTROY_OBJECT(self);
}
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
- (void)Destroy{
    
    DESTROY_OBJECT(pObBtnClose);
    
    DESTROY_OBJECT(pObBtnUp);
    DESTROY_OBJECT(pObBtnDown);
    
    DESTROY_OBJECT(pObBtnSetSimple);
    DESTROY_OBJECT(pObBtnSetEnter);
    DESTROY_OBJECT(pObBtnSetExit);    

    Ob_Editor_Interface *pInterface = (Ob_Editor_Interface *)[m_pObjMng
                GetObjectByName:@"Ob_Editor_Interface"];
    
    pInterface->EditorSelect=nil;
    [pInterface SetMode:OldInterfaceMode];

    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
@end