//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_AddNewData.h"
#import "Ob_Editor_Interface.h"
#import "FunArrayData.h"
#import "Ob_ParticleCont_ForStr.h"

@implementation Ob_AddNewData
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerInterfaceSpace8;
        m_iLayerTouch=layerTouch_0;//слой касания
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{
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
                               SET_VECTOR_V(Vector3DMake(-30,360,0),@"m_pCurPosition"));

    pObBtnUp=UNFROZE_OBJECT(@"ObjectButton",@"ButtonUp",
                               SET_STRING_V(@"Button_From_box_Up.png",@"m_DOWN"),
                               SET_STRING_V(@"Button_From_box_Up.png",@"m_UP"),
                               SET_FLOAT_V(44,@"mWidth"),
                               SET_FLOAT_V(44,@"mHeight"),
                               SET_BOOL_V(YES,@"m_bLookTouch"),
                               SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                               SET_INT_V(layerTouch_2N,@"m_iLayerTouch"),
                               SET_STRING_V(NAME(self),@"m_strNameObject"),
                               SET_STRING_V(@"Up",@"m_strNameStage"),
                               SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                               SET_VECTOR_V(Vector3DMake(-490,360,0),@"m_pCurPosition"));
    
    pMatr=[m_pObjMng->pStringContainer->ArrayPoints
                              GetMatrixAtIndex:IND_MAIN_DATA_MATRIX];
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateTmp{
    
    [self DestroyAllButton];
    
    InfoArrayValue *pInfoChild=(InfoArrayValue *)(*pMatr->pValueCopy);
    int *StartChild=*pMatr->pValueCopy+SIZE_INFO_STRUCT;

    for (int i=0; i<pInfoChild->mCount/2; i++) {
        
        int iIndexNameIcon=StartChild[i*2+1];
        
        NSMutableString *TmpStr=(NSMutableString *)[m_pObjMng->pStringContainer->ArrayPoints
                                                    GetIdAtIndex:iIndexNameIcon];

        float X=-480+(i%9)*54;
        float Y=250-(i/9)*54;

        NSString *TmpName=[NSString stringWithFormat:@"%d",i];
        GObject *pOb=UNFROZE_OBJECT(@"ObjectButton",TmpName,
                                SET_INT_V(bSimple,@"m_iType"),
                                SET_STRING_V(TmpStr,@"m_DOWN"),
                                SET_STRING_V(TmpStr,@"m_UP"),
                                SET_FLOAT_V(54,@"mWidth"),
                                SET_FLOAT_V(54,@"mHeight"),
                                SET_BOOL_V(NO,@"m_bLookTouch"),
                                SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                                SET_INT_V(layerTouch_2N,@"m_iLayerTouch"),
                                SET_STRING_V(NAME(self),@"m_strNameObject"),
                                SET_STRING_V(@"Down",@"m_strNameStage"),
                                SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                                SET_INT_V(i,@"m_iNum"),
                                SET_VECTOR_V(Vector3DMake(X,Y,0),@"m_pCurPosition"));

        [m_pChildrenbjectsArr addObject:pOb];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)DestroyAllButton{
    
    for (GObject *pOb in m_pChildrenbjectsArr)
        DESTROY_OBJECT(pOb);
    
    [m_pChildrenbjectsArr removeAllObjects];
}
//------------------------------------------------------------------------------------------------------
- (void)Up{

    if(pMatr->iIndexSelf!=IND_MAIN_DATA_MATRIX)
    {
        int iIndexTmp=IND_MAIN_DATA_MATRIX;
        pMatr = [m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:iIndexTmp];
        [self UpdateTmp];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Down{
    ObjectButton *pButtonPush=GET_ID_V(@"ButtonPush");
    
//    InfoArrayValue *pInfoChild=(InfoArrayValue *)(*pMatr->pValueCopy);
    int *StartChild=*pMatr->pValueCopy+SIZE_INFO_STRUCT;
    
    float fX=-430,fY=246;
    
    if(pMatr->iIndexSelf==IND_MAIN_DATA_MATRIX)//операции
    {
        int iIndexTmp=StartChild[pButtonPush->m_iNum*2];
        pMatr = [m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:iIndexTmp];
        [self UpdateTmp];
    }
    else
    {
        Ob_GroupButtons *pObGroup = (Ob_GroupButtons *)[m_pObjMng GetObjectByName:@"GroupButtons"];
        MATRIXcell *pMatrPar=[m_pObjMng->pStringContainer->ArrayPoints
                              GetMatrixAtIndex:pObGroup->pInsideString->m_iIndex];

        if(pMatr->iIndexSelf==IND_DATA_MATRIX_OPER)
        {            
            int iIndexIcon=StartChild[pButtonPush->m_iNum*2+1];
            NSMutableString *strIcon = [m_pObjMng->pStringContainer->ArrayPoints GetIdAtIndex:iIndexIcon];
            int iIndexMatr=StartChild[pButtonPush->m_iNum*2];
            pMatr = [m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:iIndexMatr];

            FractalString *pNewString =[[FractalString alloc]
                                    initWithName:@"NewOperation" WithParent:pObGroup->pInsideString
                                    WithContainer:m_pObjMng->pStringContainer];
            
            [pNewString SetNameIcon:strIcon];

            pNewString->m_iIndex=pMatr->iIndexSelf;

            [m_pObjMng->pStringContainer->m_OperationIndex AddData:pNewString->m_iIndex
                             WithData:pMatrPar->pValueCopy];
            
            pNewString->X=fX;
            pNewString->Y=fY;
        }
        else if(pMatr->iIndexSelf==IND_DATA_MATRIX_EMPTY)//новые данные
        {
            int iNewIndex;
            int iIndexData=StartChild[pButtonPush->m_iNum*2];
            int iType=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:iIndexData];
            
            iNewIndex = [m_pObjMng->pStringContainer->ArrayPoints GetFree];
            int iNewIndexDATA=0;

            switch (iType) {
                case DATA_FLOAT:{
                    
                    [m_pObjMng->pStringContainer->ArrayPoints
                     CreateArrayByIndex:iNewIndex withType:DATA_FLOAT];
                    
                    iNewIndexDATA=[m_pObjMng->pStringContainer->ArrayPoints SetFloat:0.0];
                }
                break;

                case DATA_INT:{
                    [m_pObjMng->pStringContainer->ArrayPoints
                     CreateArrayByIndex:iNewIndex withType:DATA_INT];
                    iNewIndexDATA=[m_pObjMng->pStringContainer->ArrayPoints SetInt:0];
                }
                break;

                case DATA_TEXTURE:{
                    [m_pObjMng->pStringContainer->ArrayPoints
                     CreateArrayByIndex:iNewIndex withType:DATA_TEXTURE];
                    
                    iNewIndexDATA=[m_pObjMng->pStringContainer->ArrayPoints SetTexture:0];
                }
                break;
                    
                case DATA_SPRITE:{
                    [m_pObjMng->pStringContainer->ArrayPoints
                     CreateArrayByIndex:iNewIndex withType:DATA_SPRITE];

                    iNewIndexDATA=[m_pObjMng->pStringContainer->ArrayPoints SetSprite:0];
                }
                break;
                    
                case DATA_SOUND:{
                    [m_pObjMng->pStringContainer->ArrayPoints
                     CreateArrayByIndex:iNewIndex withType:DATA_SOUND];
                    
                    iNewIndexDATA=[m_pObjMng->pStringContainer->ArrayPoints SetSound:0];
                }
                break;

                case DATA_U_INT:{
                    [m_pObjMng->pStringContainer->ArrayPoints
                     CreateArrayByIndex:iNewIndex withType:DATA_U_INT];
                    
                    int **ppCurArray=[m_pObjMng->pStringContainer->ArrayPoints
                                      GetArrayAtIndex:iNewIndex];

                    [m_pObjMng->pStringContainer->m_OperationIndex
                                    OnlyAddData:0 WithData:ppCurArray];
                                        
      //              iNewIndexDATA=[m_pObjMng->pStringContainer->ArrayPoints SetUInt:0];
                }
                break;

//                case DATA_STRING:{
//                    NSMutableString *pName=[NSMutableString stringWithString:@""];
//                    iNewIndexDATA=[m_pObjMng->pStringContainer->ArrayPoints SetName:pName];
//                }
//                break;

                default:
                    [self Close];
                    return;
                    break;
            }
            
            if(iType!=DATA_U_INT) {

                int **ppCurArray=[m_pObjMng->pStringContainer->ArrayPoints
                                  GetArrayAtIndex:iNewIndex];
                
                [m_pObjMng->pStringContainer->m_OperationIndex
                 AddData:iNewIndexDATA WithData:ppCurArray];
                    
            }
            
            FractalString *pNewString =[[FractalString alloc]
                                        initWithName:@"NewOperation" WithParent:pObGroup->pInsideString
                                        WithContainer:m_pObjMng->pStringContainer];

            if(iType==DATA_TEXTURE)
            {
                float *TmpTexture=m_pObjMng->pStringContainer->ArrayPoints->pData+iNewIndexDATA;

                ResourceCell *rCell=m_pObjMng->pStringContainer->ArrayPoints->
                            pCurrenContPar->pTexRes->pCells+(int)*TmpTexture;
                [pNewString SetNameIcon:rCell->sName];
            }
            else
            {
                int iIndexIcon=StartChild[pButtonPush->m_iNum*2+1];
                NSMutableString *strIcon = [m_pObjMng->pStringContainer->ArrayPoints GetIdAtIndex:iIndexIcon];

                [pNewString SetNameIcon:strIcon];
            }
            
            pNewString->m_iIndex=iNewIndex;
            
            [m_pObjMng->pStringContainer->m_OperationIndex
                    AddData:pNewString->m_iIndex WithData:pMatrPar->pValueCopy];
            
            pNewString->X=fX;
            pNewString->Y=fY;
        }
        else if(pMatr->iIndexSelf==IND_DATA_MATRIX_SYS)//системные переменные
        {
            int iNewIndex;
            int iIndexData=StartChild[pButtonPush->m_iNum*2];
            iNewIndex=iIndexData;
            
            int itype=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:iNewIndex];
            int iNewIndexArray = [m_pObjMng->pStringContainer->ArrayPoints GetFree];
            [m_pObjMng->pStringContainer->ArrayPoints
                            CreateArrayByIndex:iNewIndexArray withType:itype];

            int **ppCurArray=[m_pObjMng->pStringContainer->ArrayPoints
                              GetArrayAtIndex:iNewIndexArray];
            
            [m_pObjMng->pStringContainer->m_OperationIndex
             AddData:iIndexData WithData:ppCurArray];
            
            int iIndexIcon=StartChild[pButtonPush->m_iNum*2+1];
            NSMutableString *strIcon = [m_pObjMng->pStringContainer->ArrayPoints GetIdAtIndex:iIndexIcon];
                        
            FractalString *pNewString =[[FractalString alloc]
                                        initWithName:@"NewSys" WithParent:pObGroup->pInsideString
                                        WithContainer:m_pObjMng->pStringContainer];
            
            [pNewString SetNameIcon:strIcon];
            pNewString->m_iIndex=iNewIndexArray;
            
            [m_pObjMng->pStringContainer->m_OperationIndex
             AddData:pNewString->m_iIndex WithData:pMatrPar->pValueCopy];
            
            pNewString->X=fX;
            pNewString->Y=fY;
        }
        
        [self Close];
    }

    
 //   int *StartEnter=*EndHeart->pEnPairPar+SIZE_INFO_STRUCT;
   // StartEnter[pButtonPush->m_iNum]=m_iIndexStart;
}
//------------------------------------------------------------------------------------------------------
- (void)Close{
    
    [self DestroyAllButton];
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


    Ob_Editor_Interface *pInterface = (Ob_Editor_Interface *)[m_pObjMng
                GetObjectByName:@"Ob_Editor_Interface"];
    
    pInterface->EditorAddNewData=nil;
    [pInterface SetMode:OldInterfaceMode];

    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
@end