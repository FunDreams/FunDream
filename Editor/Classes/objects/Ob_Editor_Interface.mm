//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_Editor_Interface.h"
#import "StringContainer.h"
#import "ObjectButton.h"
#import "Ob_ParticleCont_ForStr.h"
#import "Ob_B_Slayder.h"
#import "Ob_Slayder.h"
#import "ObjectButton.h"
#import "Ob_EmtyPlace.h"
#import "Ob_Editor_Num.h"
#import "Ob_Selection.h"
#import "Ob_SelectionPar.h"
#import "Ob_AddNewData.h"
#import "Ob_BigWheel.h"
#import "ObjectB_Ob.h"

@implementation Ob_Editor_Interface
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];        
    
	if (self != nil)
    {
        m_iLayer = layerTemplet;
        m_iLayerTouch=layerTouch_0;//слой касания
        m_bHiden=YES;
        
        aProp = [[NSMutableArray alloc] init];
        aObjects = [[NSMutableArray alloc] init];
        aObSliders = [[NSMutableArray alloc] init];
        aObPoints = [[NSMutableArray alloc] init];
        pArrayToDel = [[NSMutableArray alloc] init];
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
//    Processor_ex* pProc = [self START_QUEUE:@"Proc"];
//        ASSIGN_STAGE(@"UPDATE",@"Proc:",nil);
//    [self END_QUEUE:pProc name:@"Proc"];
    
//====//различные параметры=============================================================================
   [m_pObjMng->pMegaTree SetCell:(LINK_INT_V(m_iMode,@"m_iMode"))];
    
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    [m_pObjMng->pMegaTree SetCell:(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"))];
}
//------------------------------------------------------------------------------------------------------
- (void)CreateButtons{
    
    RectView = UNFROZE_OBJECT(@"Ob_RectView",@"RectView",nil);

    float fXtash;
    if(m_iMode!=M_DROP_BOX)
    {
        
        if(m_iMode!=M_TRANSLATE && m_iMode!=M_EDIT_EN_EX)
        {
        BDropPlus = UNFROZE_OBJECT(@"ObjectButton",@"ButtonPlus",
                        SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                        SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                        SET_STRING_V(@"ButtonPlus.png",@"m_DOWN"),
                        SET_STRING_V(@"ButtonPlus.png",@"m_UP"),
                        SET_FLOAT_V(46,@"mWidth"),
                        SET_FLOAT_V(46,@"mHeight"),
                        SET_BOOL_V(YES,@"m_bLookTouch"),
                        SET_INT_V(bSimple,@"m_iType"),
    //                  SET_BOOL_V(YES,@"m_bBack"),
                        SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                        SET_STRING_V(@"AddNewData",@"m_strNameStage"),
                        SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                        SET_VECTOR_V(Vector3DMake(-485,245,0),@"m_pCurPosition"));
        }
        else
        {

        }
        
        BigWheel = UNFROZE_OBJECT(@"Ob_BigWheel",@"BigWheel",nil);
        
        Sl3=UNFROZE_OBJECT(@"StaticObject",@"Sl3",
                           SET_STRING_V(@"Line.png",@"m_pNameTexture"),
                           SET_FLOAT_V(669,@"mWidth"),
                           SET_FLOAT_V(5,@"mHeight"),
                           SET_VECTOR_V(Vector3DMake(-458,-49.5f,0),@"m_pCurPosition"),
                           SET_VECTOR_V(Vector3DMake(0,0,90),@"m_pCurAngle"),
                           SET_INT_V(layerInterfaceSpace1,@"m_iLayer"));
        
        fXtash=-433;
    }
    else{
        
        BDropPlus=0;
        BigWheel=0;
        Sl3=0;
        fXtash=-490;
    }

    
    BTash=UNFROZE_OBJECT(@"ObjectButton",@"ButtonTach",
                   SET_STRING_V(@"ButtonTash.png",@"m_DOWN"),
                   SET_STRING_V(@"ButtonTash.png",@"m_UP"),
                   SET_FLOAT_V(44,@"mWidth"),
                   SET_FLOAT_V(44,@"mHeight"),
                   SET_BOOL_V(YES,@"m_bLookTouch"),
                   SET_BOOL_V(YES,@"m_bNotPush"),
                   SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                   SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                   SET_INT_V(bSimple,@"m_iType"),
                   SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                   SET_VECTOR_V(Vector3DMake(fXtash,-363,0),@"m_pCurPosition"));
    
    BDropBox = UNFROZE_OBJECT(@"ObjectButton",@"ButtonDropBox",
                  SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                  SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                  SET_STRING_V(@"b_dropbox.png",@"m_DOWN"),
                  SET_STRING_V(@"b_dropbox.png",@"m_UP"),
                  SET_FLOAT_V(40,@"mWidth"),
                  SET_FLOAT_V(40,@"mHeight"),
                  SET_BOOL_V(YES,@"m_bLookTouch"),
                  SET_BOOL_V((m_iMode==M_DROP_BOX)?YES:NO,@"m_bIsPush"),
                  SET_INT_V(bRadioBox,@"m_iType"),
                  SET_BOOL_V(YES,@"m_bBack"),
                  SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                  SET_STRING_V(@"SetDropBox",@"m_strNameStage"),
                  SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                  SET_VECTOR_V(Vector3DMake(-488,360,0),@"m_pCurPosition"));

    BMove=UNFROZE_OBJECT(@"ObjectButton",@"ButtonMove",
                   SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                   SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                   SET_STRING_V(@"b_move.png",@"m_DOWN"),
                   SET_STRING_V(@"b_move.png",@"m_UP"),
                   SET_FLOAT_V(44,@"mWidth"),
                   SET_FLOAT_V(44,@"mHeight"),
                   SET_BOOL_V(YES,@"m_bLookTouch"),
                   SET_BOOL_V((m_iMode==M_MOVE)?YES:NO,@"m_bIsPush"),
                   SET_INT_V(bRadioBox,@"m_iType"),
                   SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                   SET_STRING_V(@"CheckMove",@"m_strNameStage"),
                   SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                   SET_VECTOR_V(Vector3DMake(-440,360,0),@"m_pCurPosition"));

    BCopy=UNFROZE_OBJECT(@"ObjectButton",@"ButtonCopy",
                   SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                   SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                   SET_STRING_V(@"b_copy.png",@"m_DOWN"),
                   SET_STRING_V(@"b_copy.png",@"m_UP"),
                   SET_FLOAT_V(44,@"mWidth"),
                   SET_FLOAT_V(44,@"mHeight"),
                   SET_BOOL_V(YES,@"m_bLookTouch"),
                   SET_BOOL_V((m_iMode==M_COPY)?YES:NO,@"m_bIsPush"),
                   SET_INT_V(bRadioBox,@"m_iType"),
                   SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                   SET_STRING_V(@"CheckCopy",@"m_strNameStage"),
                   SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                   SET_VECTOR_V(Vector3DMake(-394,360,0),@"m_pCurPosition"));

    BLink=UNFROZE_OBJECT(@"ObjectButton",@"ButtonLink",
                   SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                   SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                   SET_STRING_V(@"b_link.png",@"m_DOWN"),
                   SET_STRING_V(@"b_link.png",@"m_UP"),
                   SET_FLOAT_V(44,@"mWidth"),
                   SET_FLOAT_V(44,@"mHeight"),
                   SET_BOOL_V(YES,@"m_bLookTouch"),
                   SET_BOOL_V((m_iMode==M_LINK)?YES:NO,@"m_bIsPush"),
                   SET_INT_V(bRadioBox,@"m_iType"),
                   SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                   SET_STRING_V(@"CheckLink",@"m_strNameStage"),
                   SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                   SET_VECTOR_V(Vector3DMake(-348,360,0),@"m_pCurPosition"));

    BConnect=UNFROZE_OBJECT(@"ObjectButton",@"ButtonConnect",
                     SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                     SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                     SET_STRING_V(@"b_connect.png",@"m_DOWN"),
                     SET_STRING_V(@"b_connect.png",@"m_UP"),
                     SET_FLOAT_V(44,@"mWidth"),
                     SET_FLOAT_V(44,@"mHeight"),
                     SET_BOOL_V(YES,@"m_bLookTouch"),
                     SET_BOOL_V((m_iMode==M_CONNECT)?YES:NO,@"m_bIsPush"),
                     SET_INT_V(bRadioBox,@"m_iType"),
                     SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                     SET_STRING_V(@"CheckConnection",@"m_strNameStage"),
                     SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                     SET_VECTOR_V(Vector3DMake(-302,360,0),@"m_pCurPosition"));

    BDebug=UNFROZE_OBJECT(@"ObjectButton",@"ButtonDebug",
                   SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                   SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                   SET_STRING_V(@"b_debug.png",@"m_DOWN"),
                   SET_STRING_V(@"b_debug.png",@"m_UP"),
                   SET_FLOAT_V(44,@"mWidth"),
                   SET_FLOAT_V(44,@"mHeight"),
                   SET_BOOL_V(YES,@"m_bLookTouch"),
                   SET_BOOL_V((m_iMode==M_DEBUG)?YES:NO,@"m_bIsPush"),
                   SET_INT_V(bRadioBox,@"m_iType"),
                   SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                   SET_STRING_V(@"CheckDebug",@"m_strNameStage"),
                   SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                   SET_VECTOR_V(Vector3DMake(-256,360,0),@"m_pCurPosition"));
    
    BTranslate=UNFROZE_OBJECT(@"ObjectButton",@"ButtonTranslate",
                          SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                          SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                          SET_STRING_V(@"b_translate.png",@"m_DOWN"),
                          SET_STRING_V(@"b_translate.png",@"m_UP"),
                          SET_FLOAT_V(44,@"mWidth"),
                          SET_FLOAT_V(44,@"mHeight"),
                          SET_BOOL_V(YES,@"m_bLookTouch"),
                          SET_BOOL_V((m_iMode==M_TRANSLATE)?YES:NO,@"m_bIsPush"),
                          SET_INT_V(bRadioBox,@"m_iType"),
                          SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                          SET_STRING_V(@"SetTranslate",@"m_strNameStage"),
                          SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                          SET_VECTOR_V(Vector3DMake(-210,360,0),@"m_pCurPosition"));

    BEnEx=UNFROZE_OBJECT(@"ObjectButton",@"ButtonEnEx",
                               SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                               SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                               SET_STRING_V(@"Enter.png",@"m_DOWN"),
                               SET_STRING_V(@"Enter.png",@"m_UP"),
                               SET_FLOAT_V(44,@"mWidth"),
                               SET_FLOAT_V(44,@"mHeight"),
                               SET_BOOL_V(YES,@"m_bLookTouch"),
                               SET_BOOL_V((m_iMode==M_EDIT_EN_EX)?YES:NO,@"m_bIsPush"),
                               SET_INT_V(bRadioBox,@"m_iType"),
                               SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                               SET_STRING_V(@"CheckSetProp",@"m_strNameStage"),
                               SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                               SET_VECTOR_V(Vector3DMake(-164,360,0),@"m_pCurPosition"));

    BFullScreen=UNFROZE_OBJECT(@"ObjectButton",@"ButtonFullScreen",
                    SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                    SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                    SET_STRING_V(@"b_fullScreen.png",@"m_DOWN"),
                    SET_STRING_V(@"b_fullScreen.png",@"m_UP"),
                    SET_FLOAT_V(44,@"mWidth"),
                    SET_FLOAT_V(44,@"mHeight"),
                    SET_BOOL_V(YES,@"m_bLookTouch"),
                    SET_BOOL_V((m_iMode==M_FULL_SCREEN)?YES:NO,@"m_bIsPush"),
                    SET_INT_V(bRadioBox,@"m_iType"),
                    SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                    SET_STRING_V(@"CheckFullScreen",@"m_strNameStage"),
                    SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                    SET_VECTOR_V(Vector3DMake(-118,360,0),@"m_pCurPosition"));
    
    BLevelUp=UNFROZE_OBJECT(@"ObjectButton",@"ButtonLevelUp",
                            SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                            SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                            SET_STRING_V(@"Level_up.png",@"m_DOWN"),
                            SET_STRING_V(@"Level_up.png",@"m_UP"),
                            SET_FLOAT_V(44,@"mWidth"),
                            SET_FLOAT_V(44,@"mHeight"),
                            SET_BOOL_V(YES,@"m_bLookTouch"),
//                            SET_BOOL_V((m_iMode==M_FULL_SCREEN)?YES:NO,@"m_bIsPush"),
                            SET_INT_V(bSimple,@"m_iType"),
                            SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                            SET_STRING_V(@"SetLevelUp",@"m_strNameStage"),
                            SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                            SET_VECTOR_V(Vector3DMake(-30,360,0),@"m_pCurPosition"));
}
//------------------------------------------------------------------------------------------------------
- (void)SetBAssUp{
    
    if(StringSelect!=nil && StringSelect->pAssotiation!=nil)
    {
        NSMutableArray *values = [NSMutableArray
                                  arrayWithArray:[StringSelect->pAssotiation allValues]];
        
        for(int i=0;i<[values count];i++)
        {
            NSNumber * Index=[values objectAtIndex:i];
            if([Index intValue]==StringSelect->m_iIndexSelf)
            {
                NSNumber * IndexTmp;
                if(i==[values count]-1)
                {
                    IndexTmp=[values objectAtIndex:0];
                }
                else
                {
                    IndexTmp=[values objectAtIndex:i+1];
                }
                
                FractalString *Fstring=(FractalString *)[m_pObjMng->pStringContainer->ArrayPoints
                                    GetIdAtIndex:[IndexTmp intValue]];
                
                int *FChelf=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                                    GetDataAtIndex:iIndexChelf];

                FractalString *pParent=Fstring->pParent;
                Ob_EmtyPlace *pEmtyPlace=[Eplace->m_pChildrenbjectsArr objectAtIndex:*FChelf];
                [pEmtyPlace SetNameStr:pParent];
                [self UpdateB];
                break;
            }
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetBAssDown{
    if(StringSelect!=nil && StringSelect->pAssotiation!=nil)
    {
        NSMutableArray *values = [NSMutableArray
                                  arrayWithArray:[StringSelect->pAssotiation allValues]];
        
        for(int i=0;i<[values count];i++)
        {
            NSNumber * Index=[values objectAtIndex:i];
            if([Index intValue]==StringSelect->m_iIndexSelf)
            {
                NSNumber * IndexTmp;
                if(i==0)
                {
                    IndexTmp=[values objectAtIndex:[values count]-1];
                }
                else
                {
                    IndexTmp=[values objectAtIndex:i-1];
                }
                
                FractalString *Fstring=(FractalString *)[m_pObjMng->pStringContainer->ArrayPoints
                                                         GetIdAtIndex:[IndexTmp intValue]];
                
                int *FChelf=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                                    GetDataAtIndex:iIndexChelf];
                
                FractalString *pParent=Fstring->pParent;
                Ob_EmtyPlace *pEmtyPlace=[Eplace->m_pChildrenbjectsArr objectAtIndex:*FChelf];
                [pEmtyPlace SetNameStr:pParent];
                [self UpdateB];
                break;
            }
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetLevelUp{
    
    FractalString *pParent=ButtonGroup->pInsideString->pParent;
    
    if(![ButtonGroup->pInsideString->strUID isEqualToString:@"Objects"])
    {
    //    ButtonGroup->pInsideString=pParent;
        
        int *FChelf=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                            GetDataAtIndex:iIndexChelf];
        
        Ob_EmtyPlace *pEmtyPlace=[Eplace->m_pChildrenbjectsArr objectAtIndex:*FChelf];
        
        [pEmtyPlace SetNameStr:pParent];
    //    [ButtonGroup SetString:pParent];
    }

    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)SetEn{
    StringSelect->m_iAdditionalType=ADIT_TYPE_ENTER;
    
    if(StringSelect->pAssotiation!=nil){
        
        id array = [StringSelect->pAssotiation allKeys];
        
        for (int i=0; i<[array count]; i++) {
            
            int pIndexCurrentAss=[[array objectAtIndex:i] intValue];
            
            if(pIndexCurrentAss!=StringSelect->m_iIndexSelf)
            {
                FractalString *FAssoc=[StringSelect->m_pContainer->ArrayPoints
                                       GetIdAtIndex:pIndexCurrentAss];
                
                FAssoc->m_iAdditionalType=ADIT_TYPE_ENTER;
            }
        }
    }
    
    [self DelAnyWhere];
    
    MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints
                       GetMatrixAtIndex:StringSelect->pParent->m_iIndex];
    
    if(pMatr!=0){
        
        [m_pObjMng->pStringContainer->m_OperationIndex
         OnlyAddData:StringSelect->m_iIndex WithData:pMatr->pEnters];
    }
    
    int **ppArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:StringSelect->m_iIndex];
    if(ppArray!=nil)
    {
        InfoArrayValue *pInfo=(InfoArrayValue *)*ppArray;
        if(pInfo->mGroup==0)
        {
            pInfo->mGroup=1;
        }
        pInfo->mFlags|=(F_EN);
    }
}
//------------------------------------------------------------------------------------------------------
- (void)DelAnyWhere{
    MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints
                       GetMatrixAtIndex:StringSelect->pParent->m_iIndex];
    
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
                            
                            if(TmpIndexInLink==StringSelect->m_iIndex){
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
                            
                            if(TmpIndexInLink==StringSelect->m_iIndex){
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
         OnlyRemoveDataAtIndex:StringSelect->m_iIndex WithData:pMatr->pEnters];
        
        [m_pObjMng->pStringContainer->m_OperationIndex
         OnlyRemoveDataAtIndex:StringSelect->m_iIndex WithData:pMatr->pExits];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetEx{
    
    StringSelect->m_iAdditionalType=ADIT_TYPE_EXIT;
    
    if(StringSelect->pAssotiation!=nil){
        
        id array = [StringSelect->pAssotiation allKeys];
        
        for (int i=0; i<[array count]; i++) {
            
            int pIndexCurrentAss=[[array objectAtIndex:i] intValue];
            
            if(pIndexCurrentAss!=StringSelect->m_iIndexSelf)
            {
                FractalString *FAssoc=[StringSelect->m_pContainer->ArrayPoints
                                       GetIdAtIndex:pIndexCurrentAss];
                
                FAssoc->m_iAdditionalType=ADIT_TYPE_EXIT;
            }
        }
    }
    
    [self DelAnyWhere];
    
    MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints
                       GetMatrixAtIndex:StringSelect->pParent->m_iIndex];
    
    if(pMatr!=0){
        [m_pObjMng->pStringContainer->m_OperationIndex
         OnlyAddData:StringSelect->m_iIndex WithData:pMatr->pExits];
    }
    
    int **ppArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:StringSelect->m_iIndex];
    if(ppArray!=nil)
    {
        InfoArrayValue *pInfo=(InfoArrayValue *)*ppArray;
        
        if(pInfo->mGroup==0)
        {
            pInfo->mGroup=1;
        }
        pInfo->mFlags|=(F_EX);
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetSimple{
    
    StringSelect->m_iAdditionalType=ADIT_TYPE_SIMPLE;
    
    if(StringSelect->pAssotiation!=nil){
        
        id array = [StringSelect->pAssotiation allKeys];
        
        for (int i=0; i<[array count]; i++) {
            
            int pIndexCurrentAss=[[array objectAtIndex:i] intValue];
            
            if(pIndexCurrentAss!=StringSelect->m_iIndexSelf)
            {
                FractalString *FAssoc=[StringSelect->m_pContainer->ArrayPoints
                                       GetIdAtIndex:pIndexCurrentAss];
                
                FAssoc->m_iAdditionalType=ADIT_TYPE_SIMPLE;
            }
        }
    }
    
    [self DelAnyWhere];
    
    int **ppArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:StringSelect->m_iIndex];
    if(ppArray!=nil)
    {
        InfoArrayValue *pInfo=(InfoArrayValue *)*ppArray;
        pInfo->mGroup=0;
        
        pInfo->mFlags&=~(F_EN|F_EX);
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetGroupUp{
    
    if(StringSelect->m_iAdditionalType==ADIT_TYPE_EXIT || StringSelect->m_iAdditionalType==ADIT_TYPE_ENTER)
    {
        int **ppArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:StringSelect->m_iIndex];
        if(ppArray!=nil)
        {
            InfoArrayValue *pInfo=(InfoArrayValue *)*ppArray;
            
            if(pInfo->mGroup==255)pInfo->mGroup=1;
            else pInfo->mGroup++;
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetGrouDown{
    
    if(StringSelect->m_iAdditionalType==ADIT_TYPE_EXIT || StringSelect->m_iAdditionalType==ADIT_TYPE_ENTER)
    {
        int **ppArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:StringSelect->m_iIndex];
        if(ppArray!=nil)
        {
            InfoArrayValue *pInfo=(InfoArrayValue *)*ppArray;

            if(pInfo->mGroup==1)pInfo->mGroup=255;
            else pInfo->mGroup--;
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)RemButtonEdit{
        
    for (int i=0; i<[pArrayToDel count]; i++) {
        GObject *pOb=[pArrayToDel objectAtIndex:i];
        DESTROY_OBJECT(pOb);
    }
    
    [pArrayToDel removeAllObjects];
}
//------------------------------------------------------------------------------------------------------
- (void)RemoveTmpButton{
    if(BSetActivity!=nil){
        [pArrayToDel addObject:BSetActivity];
        BSetActivity=nil;
    }
    if(BSetProp!=nil){
        [pArrayToDel addObject:BSetProp];
        BSetProp=nil;
    }
    if(BMoveObUp!=nil){
        [pArrayToDel addObject:BMoveObUp];
        BMoveObUp=nil;
    }
    if(BMoveObDown!=nil){
        [pArrayToDel addObject:BMoveObDown];
        BMoveObDown=nil;
    }

    if(SetMatrix!=nil){
        [pArrayToDel addObject:SetMatrix];
        SetMatrix=nil;
    }

    if(BTIn!=nil){
        [pArrayToDel addObject:BTIn];
        BTIn=nil;
    }

    if(BTOut!=nil){
        [pArrayToDel addObject:BTOut];
        BTOut=nil;
    }

    if(BTIn2!=nil){
        [pArrayToDel addObject:BTIn2];
        BTIn2=nil;
    }
    
    if(BTOut2!=nil){
        [pArrayToDel addObject:BTOut2];
        BTOut2=nil;
    }

    if(BTSetZero!=nil){
        [pArrayToDel addObject:BTSetZero];
        BTSetZero=nil;
    }

    if(BAssUp!=nil){
        [pArrayToDel addObject:BAssUp];
        BAssUp=nil;
    }

    if(BAssDown!=nil){
        [pArrayToDel addObject:BAssDown];
        BAssDown=nil;
    }

    
    if(BEn!=nil){
        [pArrayToDel addObject:BEn];
        BEn=nil;
    }

    if(BEx!=nil){
        [pArrayToDel addObject:BEx];
        BEx=nil;
    }

    if(BSimple!=nil){
        [pArrayToDel addObject:BSimple];
        BSimple=nil;
    }

    if(BGroupUp!=nil){
        [pArrayToDel addObject:BGroupUp];
        BGroupUp=nil;
    }

    if(BGroupDown!=nil){
        [pArrayToDel addObject:BGroupDown];
        BGroupDown=nil;
    }

    [self RemButtonEdit];
}
//------------------------------------------------------------------------------------------------------
- (void)SetButtonEnEx{
    [self RemoveTmpButton];
    
    int *Data=(*ButtonGroup->pInsideString->pChildString);
    InfoArrayValue *InfoStr=(InfoArrayValue *)(Data);
    int iCountPush=0;
    
    for(int i=0;i<InfoStr->mCount;i++){
        
        int index=(Data+SIZE_INFO_STRUCT)[i];
        int iType=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:index];
        
        if(iType==DATA_ID){
            FractalString *pFrStr=[m_pObjMng->pStringContainer->ArrayPoints
                                   GetIdAtIndex:index];
            
            ObjectB_Ob *pOb=[ButtonGroup->m_pChildrenbjectsArr objectAtIndex:i];
            
            int iType2=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:pFrStr->m_iIndex];
            
            if(pOb->m_bPush==YES && iType2==DATA_ARRAY)
            {
                int **ppArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:pFrStr->m_iIndex];
                InfoArrayValue *pInfo=(InfoArrayValue*)(*ppArray);

                if(pInfo->mType==DATA_FLOAT || pInfo->mType==DATA_INT || pInfo->mType==DATA_TEXTURE
                   || pInfo->mType==DATA_SOUND || pInfo->mType==DATA_SPRITE || pInfo->mType==DATA_U_INT)
                {
                    iCountPush++;
                    break;
                }
            }
        }
    }
    
    
    if(iCountPush>0)
    {
        BEn = UNFROZE_OBJECT(@"ObjectButton",@"BEn",
                              SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                              SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                              SET_STRING_V(@"Enter.png",@"m_DOWN"),
                              SET_STRING_V(@"Enter.png",@"m_UP"),
                              SET_FLOAT_V(46,@"mWidth"),
                              SET_FLOAT_V(46,@"mHeight"),
                              SET_BOOL_V(YES,@"m_bLookTouch"),
                              SET_INT_V(bSimple,@"m_iType"),
                              SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                              SET_STRING_V(@"SetEn",@"m_strNameStage"),
                              SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                              SET_VECTOR_V(Vector3DMake(-485,245,0),@"m_pCurPosition"));

        BEx = UNFROZE_OBJECT(@"ObjectButton",@"BEx",
                               SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                               SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                               SET_STRING_V(@"Exit.png",@"m_DOWN"),
                               SET_STRING_V(@"Exit.png",@"m_UP"),
                               SET_FLOAT_V(46,@"mWidth"),
                               SET_FLOAT_V(46,@"mHeight"),
                               SET_BOOL_V(YES,@"m_bLookTouch"),
                               SET_INT_V(bSimple,@"m_iType"),
                               SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                               SET_STRING_V(@"SetEx",@"m_strNameStage"),
                               SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                               SET_VECTOR_V(Vector3DMake(-485,190,0),@"m_pCurPosition"));

        BSimple = UNFROZE_OBJECT(@"ObjectButton",@"BSimple",
                             SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                             SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                             SET_STRING_V(@"S.png",@"m_DOWN"),
                             SET_STRING_V(@"S.png",@"m_UP"),
                             SET_FLOAT_V(46,@"mWidth"),
                             SET_FLOAT_V(46,@"mHeight"),
                             SET_BOOL_V(YES,@"m_bLookTouch"),
                             SET_INT_V(bSimple,@"m_iType"),
                             SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                             SET_STRING_V(@"SetSimple",@"m_strNameStage"),
                             SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                             SET_VECTOR_V(Vector3DMake(-485,135,0),@"m_pCurPosition"));
        
        BGroupUp=UNFROZE_OBJECT(@"ObjectButton",@"ButtonGroupUp",
                              SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                              SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                              SET_STRING_V(@"Associate_up.png",@"m_DOWN"),
                              SET_STRING_V(@"Associate_up.png",@"m_UP"),
                              SET_FLOAT_V(44,@"mWidth"),
                              SET_FLOAT_V(44,@"mHeight"),
                              SET_BOOL_V(YES,@"m_bLookTouch"),
                              SET_INT_V(bSimple,@"m_iType"),
                              SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                              SET_STRING_V(@"SetGroupUp",@"m_strNameStage"),
                              SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                              SET_VECTOR_V(Vector3DMake(-485,40,0),@"m_pCurPosition"));
        
        BGroupDown=UNFROZE_OBJECT(@"ObjectButton",@"ButtonGroupDown",
                                SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                                SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                                SET_STRING_V(@"Associate_down.png",@"m_DOWN"),
                                SET_STRING_V(@"Associate_down.png",@"m_UP"),
                                SET_FLOAT_V(44,@"mWidth"),
                                SET_FLOAT_V(44,@"mHeight"),
                                SET_BOOL_V(YES,@"m_bLookTouch"),
                                SET_INT_V(bSimple,@"m_iType"),
                                SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                                SET_STRING_V(@"SetGrouDown",@"m_strNameStage"),
                                SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                                SET_VECTOR_V(Vector3DMake(-485,-20,0),@"m_pCurPosition"));
}
}
//------------------------------------------------------------------------------------------------------
- (void)SetButtonInOut{
    [self RemoveTmpButton];
    
    NSMutableArray *pTmpArray=[[NSMutableArray alloc] init];
    int *Data=(*ButtonGroup->pInsideString->pChildString);
    InfoArrayValue *InfoStr=(InfoArrayValue *)(Data);
    int iCountPush=0;
    
    for(int i=0;i<InfoStr->mCount;i++){
        
        int index=(Data+SIZE_INFO_STRUCT)[i];
        int iType=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:index];
        
        if(iType==DATA_ID){
//            FractalString *pFrStr=[m_pObjMng->pStringContainer->ArrayPoints
//                                   GetIdAtIndex:index];
            
            ObjectB_Ob *pOb=[ButtonGroup->m_pChildrenbjectsArr objectAtIndex:i];
            
            if(pOb->m_bPush==YES)
            {
                iCountPush++;
                
                [pTmpArray addObject:pOb->pString];
            }
        }
    }

    if(iCountPush>0)
    {
        BTIn = UNFROZE_OBJECT(@"ObjectButton",@"BTIn",
                              SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                              SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                              SET_STRING_V(@"b_In.png",@"m_DOWN"),
                              SET_STRING_V(@"b_In.png",@"m_UP"),
                              SET_FLOAT_V(46,@"mWidth"),
                              SET_FLOAT_V(46,@"mHeight"),
                              SET_BOOL_V(YES,@"m_bLookTouch"),
                              SET_INT_V(bSimple,@"m_iType"),
                              SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                              SET_STRING_V(@"PushIn",@"m_strNameStage"),
                              SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                              SET_VECTOR_V(Vector3DMake(-485,245,0),@"m_pCurPosition"));

        BTIn2 = UNFROZE_OBJECT(@"ObjectButton",@"BTIn",
                              SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                              SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                              SET_STRING_V(@"b_In2.png",@"m_DOWN"),
                              SET_STRING_V(@"b_In2.png",@"m_UP"),
                              SET_FLOAT_V(46,@"mWidth"),
                              SET_FLOAT_V(46,@"mHeight"),
                              SET_BOOL_V(YES,@"m_bLookTouch"),
                              SET_INT_V(bSimple,@"m_iType"),
                              SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                              SET_STRING_V(@"PushIn2",@"m_strNameStage"),
                              SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                              SET_VECTOR_V(Vector3DMake(-485,190,0),@"m_pCurPosition"));

        if(iCountPush==1)
        {
            FractalString *TmpStr=[pTmpArray objectAtIndex:0];
            MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:TmpStr->m_iIndex];

            if(pMatr!=nil && pMatr->TypeInformation==STR_COMPLEX)
            {
                BTOut = UNFROZE_OBJECT(@"ObjectButton",@"BTOut",
                                   SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                                   SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                                   SET_STRING_V(@"b_Out.png",@"m_DOWN"),
                                   SET_STRING_V(@"b_Out.png",@"m_UP"),
                                   SET_FLOAT_V(46,@"mWidth"),
                                   SET_FLOAT_V(46,@"mHeight"),
                                   SET_BOOL_V(YES,@"m_bLookTouch"),
                                   SET_INT_V(bSimple,@"m_iType"),
                                   SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                                   SET_STRING_V(@"PushOut",@"m_strNameStage"),
                                   SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                                   SET_VECTOR_V(Vector3DMake(-485,135,0),@"m_pCurPosition"));

                BTOut2 = UNFROZE_OBJECT(@"ObjectButton",@"BTOut",
                                       SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                                       SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                                       SET_STRING_V(@"b_Out2.png",@"m_DOWN"),
                                       SET_STRING_V(@"b_Out2.png",@"m_UP"),
                                       SET_FLOAT_V(46,@"mWidth"),
                                       SET_FLOAT_V(46,@"mHeight"),
                                       SET_BOOL_V(YES,@"m_bLookTouch"),
                                       SET_INT_V(bSimple,@"m_iType"),
                                       SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                                       SET_STRING_V(@"PushOut2",@"m_strNameStage"),
                                       SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                                       SET_VECTOR_V(Vector3DMake(-485,80,0),@"m_pCurPosition"));
            }
        }
    }
    
    [pTmpArray release];
}
//------------------------------------------------------------------------------------------------------
- (void)PushIn2{
    
    NSMutableArray *pTmpArray=[[NSMutableArray alloc] init];
    int *Data=(*ButtonGroup->pInsideString->pChildString);
    InfoArrayValue *InfoStr=(InfoArrayValue *)(Data);
    int iCountPush=0;
    
    for(int i=0;i<InfoStr->mCount;i++){
        
        int index=(Data+SIZE_INFO_STRUCT)[i];
        int iType=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:index];
        
        if(iType==DATA_ID){
            
            ObjectB_Ob *pOb=[ButtonGroup->m_pChildrenbjectsArr objectAtIndex:i];
            
            if(pOb->m_bPush==YES)
            {
                iCountPush++;
                
                NSNumber *pNum=[NSNumber numberWithInt:i];
                [pTmpArray addObject:pNum];
            }
        }
    }
    
    FractalString *pNewString =[[FractalString alloc]
                                initWithName:@"EmptyOb" WithParent:ButtonGroup->pInsideString
                                WithContainer:m_pObjMng->pStringContainer];
    
    MATRIXcell *pMatrPar=[m_pObjMng->pStringContainer->ArrayPoints
                          GetMatrixAtIndex:ButtonGroup->pInsideString->m_iIndex];
    
    pNewString->m_iIndex=[m_pObjMng->pStringContainer->ArrayPoints SetMatrix:0];
    [m_pObjMng->pStringContainer->m_OperationIndex AddData:pNewString->m_iIndex
                                                  WithData:pMatrPar->pValueCopy];
    
    MATRIXcell *pMatrNew=[m_pObjMng->pStringContainer->ArrayPoints
                          GetMatrixAtIndex:pNewString->m_iIndex];
    
    pMatrNew->TypeInformation=STR_COMPLEX;
    pMatrNew->NameInformation=STR_SIMPLE;
    pMatrNew->iIndexString=pNewString->m_iIndexSelf;
    
    pNewString->X=-430;
    pNewString->Y=246;
    
    FractalString *pFparent=pNewString;
    
    [m_pObjMng->pStringContainer ReplaceStringIn2:pFparent strscr:ButtonGroup->pInsideString
                                         strings:pTmpArray];
    [pTmpArray release];
    
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)PushOut2{
    
    FractalString *pFparent=0;
    
    int *Data=(*ButtonGroup->pInsideString->pChildString);
    InfoArrayValue *InfoStr=(InfoArrayValue *)(Data);
    
    for(int i=0;i<InfoStr->mCount;i++){
        
        int index=(Data+SIZE_INFO_STRUCT)[i];
        int iType=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:index];
        
        if(iType==DATA_ID){
            
            ObjectB_Ob *pOb=[ButtonGroup->m_pChildrenbjectsArr objectAtIndex:i];
            
            if(pOb->m_bPush==YES)
                pFparent=pOb->pString;
        }
    }
    
    NSMutableArray *pTmpArray=[[NSMutableArray alloc] init];
    Data=(*pFparent->pChildString);
    InfoStr=(InfoArrayValue *)(Data);
    
    for(int i=0;i<InfoStr->mCount;i++){
        NSNumber *pNum=[NSNumber numberWithInt:i];
        [pTmpArray addObject:pNum];
    }
    
    
    if(pFparent!=0)
        [m_pObjMng->pStringContainer ReplaceStringOut2:ButtonGroup->pInsideString strscr:pFparent
                                              strings:pTmpArray];
    
    [pTmpArray release];
    
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)PushZero{
    
    MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints
                       GetMatrixAtIndex:ButtonGroup->pInsideString->m_iIndex];
    
    if(pMatr!=nil)
    {
        int TmpIndexSel=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[ButtonGroup->m_iCurrentSelect];
        int **ppArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:TmpIndexSel];
        InfoArrayValue *pInfoTmp=(InfoArrayValue *)*ppArray;
        int iIndex=0;
        float *pfValue=0;
        
        switch (pInfoTmp->mType) {
            case DATA_FLOAT:
                iIndex=(*ppArray+SIZE_INFO_STRUCT)[0];
                pfValue=(float *)[m_pObjMng->pStringContainer->ArrayPoints GetDataAtIndex:iIndex];
                *pfValue=0;
                break;
            case DATA_INT:
                iIndex=(*ppArray+SIZE_INFO_STRUCT)[0];
                pfValue=(float *)[m_pObjMng->pStringContainer->ArrayPoints GetDataAtIndex:iIndex];
                *pfValue=0;
                break;
            case DATA_U_INT:
                [m_pObjMng->pStringContainer->m_OperationIndex SetCopasity:0 WithData:ppArray];
                break;
                
            default:
                break;
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)PushIn{
    
    NSMutableArray *pTmpArray=[[NSMutableArray alloc] init];
    int *Data=(*ButtonGroup->pInsideString->pChildString);
    InfoArrayValue *InfoStr=(InfoArrayValue *)(Data);
    int iCountPush=0;
    
    for(int i=0;i<InfoStr->mCount;i++){
        
        int index=(Data+SIZE_INFO_STRUCT)[i];
        int iType=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:index];
        
        if(iType==DATA_ID){
            
            ObjectB_Ob *pOb=[ButtonGroup->m_pChildrenbjectsArr objectAtIndex:i];
            
            if(pOb->m_bPush==YES)
            {
                iCountPush++;
                
                NSNumber *pNum=[NSNumber numberWithInt:i];
                [pTmpArray addObject:pNum];
            }
        }
    }

    FractalString *pNewString =[[FractalString alloc]
                                initWithName:@"EmptyOb" WithParent:ButtonGroup->pInsideString
                                WithContainer:m_pObjMng->pStringContainer];
    
    MATRIXcell *pMatrPar=[m_pObjMng->pStringContainer->ArrayPoints
                          GetMatrixAtIndex:ButtonGroup->pInsideString->m_iIndex];
    
    pNewString->m_iIndex=[m_pObjMng->pStringContainer->ArrayPoints SetMatrix:0];
    [m_pObjMng->pStringContainer->m_OperationIndex AddData:pNewString->m_iIndex
                                                  WithData:pMatrPar->pValueCopy];
    
    MATRIXcell *pMatrNew=[m_pObjMng->pStringContainer->ArrayPoints
                          GetMatrixAtIndex:pNewString->m_iIndex];
    
    pMatrNew->TypeInformation=STR_COMPLEX;
    pMatrNew->NameInformation=STR_SIMPLE;
    pMatrNew->iIndexString=pNewString->m_iIndexSelf;
    
    pNewString->X=-430;
    pNewString->Y=246;
    
    FractalString *pFparent=pNewString;
    
    [m_pObjMng->pStringContainer ReplaceStringIn:pFparent strscr:ButtonGroup->pInsideString
                                       strings:pTmpArray];
    [pTmpArray release];

    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)PushOut{
    
    FractalString *pFparent=0;

    int *Data=(*ButtonGroup->pInsideString->pChildString);
    InfoArrayValue *InfoStr=(InfoArrayValue *)(Data);
    
    for(int i=0;i<InfoStr->mCount;i++){
        
        int index=(Data+SIZE_INFO_STRUCT)[i];
        int iType=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:index];
        
        if(iType==DATA_ID){
            
            ObjectB_Ob *pOb=[ButtonGroup->m_pChildrenbjectsArr objectAtIndex:i];
            
            if(pOb->m_bPush==YES)
                pFparent=pOb->pString;
        }
    }

    NSMutableArray *pTmpArray=[[NSMutableArray alloc] init];
    Data=(*pFparent->pChildString);
    InfoStr=(InfoArrayValue *)(Data);

    for(int i=0;i<InfoStr->mCount;i++){
        NSNumber *pNum=[NSNumber numberWithInt:i];
        [pTmpArray addObject:pNum];
    }

    
    if(pFparent!=0)
        [m_pObjMng->pStringContainer ReplaceStringOut:ButtonGroup->pInsideString strscr:pFparent
                                       strings:pTmpArray];
    
    [pTmpArray release];
    
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)SetButtonEdit{

    [self RemoveTmpButton];

    SetMatrix=UNFROZE_OBJECT(@"ObjectButton",@"SetMatrix",
                            SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                            SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                            SET_STRING_V(@"m_AllElem.png",@"m_DOWN"),
                            SET_STRING_V(@"m_AllElem.png",@"m_UP"),
                            SET_FLOAT_V(44,@"mWidth"),
                            SET_FLOAT_V(44,@"mHeight"),
                            SET_INT_V(bSimple,@"m_iType"),
                            SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                            SET_STRING_V(@"SetCurMatrix",@"m_strNameStage"),
                            SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                            SET_VECTOR_V(Vector3DMake(-485,190,0),@"m_pCurPosition"));

    MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints
                       GetMatrixAtIndex:ButtonGroup->pInsideString->m_iIndex];
    
    float Yadd=0;
    if(pMatr!=nil)
    {
        int TmpIndexSel=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[ButtonGroup->m_iCurrentSelect];
        int **ppArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:TmpIndexSel];
        InfoArrayValue *pInfoTmp=(InfoArrayValue *)*ppArray;
        
        if(pInfoTmp->mType==DATA_U_INT)
        {
            BSetActivity=UNFROZE_OBJECT(@"ObjectButton",@"ButtonActivity",
                                        SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                                        SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                                        SET_STRING_V(@"StartActivity.png",@"m_DOWN"),
                                        SET_STRING_V(@"StartActivity.png",@"m_UP"),
                                        SET_FLOAT_V(44,@"mWidth"),
                                        SET_FLOAT_V(44,@"mHeight"),
                                        SET_INT_V(bSimple,@"m_iType"),
                                        SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                                        SET_STRING_V(@"SetActivSpace",@"m_strNameStage"),
                                        SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                                        SET_VECTOR_V(Vector3DMake(-485,140,0),@"m_pCurPosition"));
            
            Yadd+=50;
        }
        
        if(pInfoTmp->mType==DATA_U_INT || pInfoTmp->mType==DATA_INT || pInfoTmp->mType==DATA_FLOAT)
        {
            BTSetZero=UNFROZE_OBJECT(@"ObjectButton",@"ButtonZero",
                                     SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                                     SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                                     SET_STRING_V(@"0.png",@"m_DOWN"),
                                     SET_STRING_V(@"0.png",@"m_UP"),
                                     SET_FLOAT_V(44,@"mWidth"),
                                     SET_FLOAT_V(44,@"mHeight"),
                                     SET_INT_V(bSimple,@"m_iType"),
                                     SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                                     SET_STRING_V(@"PushZero",@"m_strNameStage"),
                                     SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                                     SET_VECTOR_V(Vector3DMake(-485,140-Yadd,0),@"m_pCurPosition"));
        }
    }

    

}
//------------------------------------------------------------------------------------------------------
- (void)SetButtonAssociate{
    if(m_iMode==M_MOVE || m_iMode==M_COPY || m_iMode==M_LINK
       || m_iMode==M_CONNECT || m_iMode==M_DEBUG || m_iMode==M_TRANSLATE){
        
        BAssUp=UNFROZE_OBJECT(@"ObjectButton",@"BAssUp",
                              SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                              SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                              SET_STRING_V(@"Associate_up.png",@"m_DOWN"),
                              SET_STRING_V(@"Associate_up.png",@"m_UP"),
                              SET_FLOAT_V(44,@"mWidth"),
                              SET_FLOAT_V(44,@"mHeight"),
                              SET_BOOL_V(YES,@"m_bLookTouch"),
                              SET_INT_V(bSimple,@"m_iType"),
                              SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                              SET_STRING_V(@"SetBAssUp",@"m_strNameStage"),
                              SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                              SET_VECTOR_V(Vector3DMake(-485,40,0),@"m_pCurPosition"));
        
        BAssDown=UNFROZE_OBJECT(@"ObjectButton",@"BAssDown",
                                SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                                SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                                SET_STRING_V(@"Associate_down.png",@"m_DOWN"),
                                SET_STRING_V(@"Associate_down.png",@"m_UP"),
                                SET_FLOAT_V(44,@"mWidth"),
                                SET_FLOAT_V(44,@"mHeight"),
                                SET_BOOL_V(YES,@"m_bLookTouch"),
                                SET_INT_V(bSimple,@"m_iType"),
                                SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                                SET_STRING_V(@"SetBAssDown",@"m_strNameStage"),
                                SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                                SET_VECTOR_V(Vector3DMake(-485,-20,0),@"m_pCurPosition"));
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetButtonEnterPoint{

    [self RemoveTmpButton];
    
    if(m_iMode==M_MOVE || m_iMode==M_COPY || m_iMode==M_LINK
       || m_iMode==M_CONNECT || m_iMode==M_DEBUG || m_iMode==M_TRANSLATE){

        BSetActivity=UNFROZE_OBJECT(@"ObjectButton",@"ButtonActivity",
                                SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                                SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                                SET_STRING_V(@"StartActivity.png",@"m_DOWN"),
                                SET_STRING_V(@"StartActivity.png",@"m_UP"),
                                SET_FLOAT_V(44,@"mWidth"),
                                SET_FLOAT_V(44,@"mHeight"),
                                SET_INT_V(bSimple,@"m_iType"),
                                SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                                SET_STRING_V(@"SetActivFirstOperation",@"m_strNameStage"),
                                SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                                SET_VECTOR_V(Vector3DMake(-485,190,0),@"m_pCurPosition"));
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetCurMatrix
{
    MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints
                       GetMatrixAtIndex:ButtonGroup->pInsideString->m_iIndex];

    if(pMatr!=0)
    {
        int iIndex=*(*pMatr->pValueCopy+SIZE_INFO_STRUCT+ButtonGroup->m_iCurrentSelect);
        int iType=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:iIndex];
        
        if(iType==DATA_ARRAY)
        {
            int **ppArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:iIndex];
            InfoArrayValue *pInfo=(InfoArrayValue *)*ppArray;
            
            MATRIXcell *pMatrData=0;
            
            if(pInfo->UnParentMatrix.indexMatrix==0)
            {
                pMatrData=pMatr;
            }
            else
            {
                pMatrData=[m_pObjMng->pStringContainer->ArrayPoints
                           GetMatrixAtIndex:pInfo->UnParentMatrix.indexMatrix];
            }
            
            if(pInfo->UnParentMatrix.indexMatrix!=0)
            {//делаем нулевую матрицу
                
                if(pInfo->mType==DATA_U_INT)
                {
                    [m_pObjMng->pStringContainer->m_OperationIndex SetCopasity:0 WithData:ppArray];
                }
                else
                {
//--------------------------------------------------------------------------------------------------
                    MATRIXcell *pMatrZero=[m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:0];
                    NSMutableDictionary *DataLoops = [[NSMutableDictionary alloc] init];
                    
                    [m_pObjMng->pStringContainer->m_OperationIndex
                     RemoveAllConnections:DataLoops RootMatr:pMatrZero SearchCurIndex:iIndex];
                    [DataLoops release];
//--------------------------------------------------------------------------------------------------
                    int iCount=pInfo->mCount-1;
                    
                    if(iCount>0)
                    {
                        for (int i=0; i<iCount; i++)
                        {
                            [m_pObjMng->pStringContainer->m_OperationIndex
                                    RemoveDataAtPlace:1 WithData:ppArray];
                        }
                    }
                }

                pInfo=(InfoArrayValue *)*ppArray;
                pInfo->UnParentMatrix.indexMatrix=0;
//                return;

                [m_pObjMng->pStringContainer->m_OperationIndex
                        OnlyRemoveDataAtIndex:iIndex WithData:pMatrData->ppDataMartix];
                
                InfoArrayValue *pInfoData=(InfoArrayValue *)*pMatrData->ppDataMartix;
                if(pInfoData->mCount==0)
                    pMatrData->iDimMatrix=1;
            }
            else
            {
                InfoArrayValue *pInfoDataMatrix=(InfoArrayValue *)*pMatrData->ppDataMartix;

                int place=[m_pObjMng->pStringContainer->m_OperationIndex
                            FindIndex:iIndex WithData:pMatrData->ppDataMartix];
                
                if(place==-1)//добавляем в матрицу
                {                    
                    int SizeMatrix=pMatrData->iDimMatrix;
                                                            
                    if(pInfo->mType==DATA_U_INT)
                    {
                        [m_pObjMng->pStringContainer->m_OperationIndex SetCopasity:0 WithData:ppArray];
                    }
                    else
                    {
                        if(SizeMatrix>pInfo->mCount)
                        {
                            int iCount=SizeMatrix-pInfo->mCount;
                            
                            for (int i=0; i<iCount; i++)
                            {
                                int iNewInd=0;
                                
                                switch (pInfo->mType)
                                {
                                    case DATA_FLOAT:
                                        iNewInd=[m_pObjMng->pStringContainer->ArrayPoints SetFloat:0];
                                        break;
                                        
                                    case DATA_INT:
                                        iNewInd=[m_pObjMng->pStringContainer->ArrayPoints SetInt:0];
                                        break;
                                        
                                    case DATA_TEXTURE:
                                    {
                                        iNewInd=[m_pObjMng->pStringContainer->ArrayPoints SetTexture:0];
                                    }
                                        break;
                                        
                                    case DATA_SPRITE:
                                        iNewInd=[m_pObjMng->pStringContainer->ArrayPoints SetSprite:0];
                                        break;
                                        
                                    default:
                                        [NSException raise:@"Invalid type value" format:@"type of %d is invalid", pInfo->mType];
                                        break;
                                }

                                [m_pObjMng->pStringContainer->m_OperationIndex
                                        AddData:iNewInd WithData:ppArray];
                                pInfo=(InfoArrayValue *)*ppArray;
                            }
                        }
                        else if(SizeMatrix<pInfo->mCount)
                        {
                            int iCount=pInfo->mCount-SizeMatrix;
                            
                            for (int i=0; i<iCount; i++)
                            {
                                [m_pObjMng->pStringContainer->m_OperationIndex
                                    RemoveDataAtPlace:SizeMatrix-1 WithData:ppArray];
                            }
                        }
                    }
                    
                    pInfo=(InfoArrayValue *)*ppArray;
                    pInfoDataMatrix=(InfoArrayValue *)*pMatrData->ppDataMartix;
                    pInfo->UnParentMatrix.indexMatrix=ButtonGroup->pInsideString->m_iIndex;
                    
                    [m_pObjMng->pStringContainer->m_OperationIndex
                     OnlyAddData:iIndex WithData:pMatrData->ppDataMartix];
                }
            }
        }
    }
    
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)UpSpace
{
    MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints
                       GetMatrixAtIndex:ButtonGroup->pInsideString->m_iIndex];
    
    if(pMatr!=nil)
    {
        int iIndex=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[ButtonGroup->m_iCurrentSelect];

        int Place=[m_pObjMng->pStringContainer->m_OperationIndex
                   FindIndex:iIndex
                   WithData:pMatr->ppActivitySpace];
        
        InfoArrayValue *pInfo=(InfoArrayValue *)*pMatr->ppStartPlaces;
        int *pStartActiv=*pMatr->ppActivitySpace+SIZE_INFO_STRUCT;
        
        if(Place!=-1 && (Place+1)<pInfo->mCount)
        {
            
            int TmpActiv=pStartActiv[Place+1];
            pStartActiv[Place+1]=pStartActiv[Place];
            pStartActiv[Place]=TmpActiv;
        }
    }
    
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)DownSpace
{
    MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints
                       GetMatrixAtIndex:ButtonGroup->pInsideString->m_iIndex];
    
    if(pMatr!=nil)
    {
        int iIndex=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[ButtonGroup->m_iCurrentSelect];
        
        int Place=[m_pObjMng->pStringContainer->m_OperationIndex
                   FindIndex:iIndex
                   WithData:pMatr->ppActivitySpace];
        
        int *pStartActiv=*pMatr->ppActivitySpace+SIZE_INFO_STRUCT;
        
        if(Place!=-1 && Place>0)
        {            
            int TmpActiv=pStartActiv[Place-1];
            pStartActiv[Place-1]=pStartActiv[Place];
            pStartActiv[Place]=TmpActiv;
        }
    }
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)UpQueue
{
//    MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints
//                       GetMatrixAtIndex:ButtonGroup->pInsideString->m_iIndex];
//    
//    if(pMatr!=nil)
//    {
//        int Place=[m_pObjMng->pStringContainer->m_OperationIndex
//                   FindIndex:ButtonGroup->m_iCurrentSelect
//                   WithData:pMatr->ppStartPlaces];
//        
//        InfoArrayValue *pInfo=(InfoArrayValue *)*pMatr->ppStartPlaces;
//        int *pStartPlace=*pMatr->ppStartPlaces+SIZE_INFO_STRUCT;
//        int *pStartActiv=*pMatr->ppActivitySpace+SIZE_INFO_STRUCT;
//        
//        if(Place!=-1 && (Place+1)<pInfo->mCount)
//        {
//            int TmpPlace=pStartPlace[Place+1];
//            pStartPlace[Place+1]=pStartPlace[Place];
//            pStartPlace[Place]=TmpPlace;
//            
//            int TmpActiv=pStartActiv[Place+1];
//            pStartActiv[Place+1]=pStartActiv[Place];
//            pStartActiv[Place]=TmpActiv;
//        }
//    }
//    
//    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)DownQueue
{
//    MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints
//                       GetMatrixAtIndex:ButtonGroup->pInsideString->m_iIndex];
//    
//    if(pMatr!=nil)
//    {
//        int Place=[m_pObjMng->pStringContainer->m_OperationIndex
//                   FindIndex:ButtonGroup->m_iCurrentSelect
//                   WithData:pMatr->ppStartPlaces];
//        
//        int *pStartPlace=*pMatr->ppStartPlaces+SIZE_INFO_STRUCT;
//        int *pStartActiv=*pMatr->ppActivitySpace+SIZE_INFO_STRUCT;
//        
//        if(Place!=-1 && Place>0)
//        {
//            int TmpPlace=pStartPlace[Place-1];
//            pStartPlace[Place-1]=pStartPlace[Place];
//            pStartPlace[Place]=TmpPlace;
//
//            int TmpActiv=pStartActiv[Place-1];
//            pStartActiv[Place-1]=pStartActiv[Place];
//            pStartActiv[Place]=TmpActiv;
//}
//    }
//    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (HeartMatr *)GetLastHeart:(HeartMatr *)pStartHeart WithMatr:(MATRIXcell *)pMatr{
    
    HeartMatr *pHeart=pStartHeart;

    while (pHeart->pNextPlace>=0) {

        int INextPlace=pHeart->pNextPlace;
        pHeart=(HeartMatr *)((*pMatr->pQueue+SIZE_INFO_STRUCT)[INextPlace]);
    }

    return pHeart;
}
//------------------------------------------------------------------------------------------------------
- (void)SetActivSpace
{
    MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints
                       GetMatrixAtIndex:ButtonGroup->pInsideString->m_iIndex];

    if(pMatr!=nil)
    {
        int TmpIndexSel=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[ButtonGroup->m_iCurrentSelect];

        int *iCurValue=*pMatr->ppActivitySpace+SIZE_INFO_STRUCT;
        
        if(*iCurValue==TmpIndexSel)
            *iCurValue=-1;
        else
            *iCurValue=TmpIndexSel;
        
        [self UpdateB];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetActivFirstOperation
{
    MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints
                       GetMatrixAtIndex:ButtonGroup->pInsideString->m_iIndex];
    
    if(pMatr!=nil)
    {
        
        int *iCurValue=(*pMatr->ppStartPlaces+SIZE_INFO_STRUCT);
        
        if(*iCurValue==ButtonGroup->m_iCurrentSelect)
            *iCurValue=-1;
        else
            *iCurValue=ButtonGroup->m_iCurrentSelect;

        [self UpdateB];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)removeFundInt{
    
    DESTROY_OBJECT(Back);
    Back=nil;

    DESTROY_OBJECT(Sl1);
    Sl1=nil;

    DESTROY_OBJECT(Sl2);
    Sl2=nil;
}
//------------------------------------------------------------------------------------------------------
- (void)CreateFundInt{
    
    Back = UNFROZE_OBJECT(@"StaticObject",@"Back",
                          //     SET_STRING_V(@"Line.png",@"m_pNameTexture"),
                          SET_COLOR_V(Color3DMake(0.2f,0.2f,0.2f,1),@"mColor"),
                          SET_FLOAT_V(512,@"mWidth"),
                          SET_FLOAT_V(768,@"mHeight"),
                          SET_VECTOR_V(Vector3DMake(-256,0,0),@"m_pCurPosition"),
                          SET_INT_V(layerBackground,@"m_iLayer"));
    
    Sl1 = UNFROZE_OBJECT(@"StaticObject",@"Sl1",
                         SET_STRING_V(@"Line.png",@"m_pNameTexture"),
                         SET_FLOAT_V(512,@"mWidth"),
                         SET_FLOAT_V(5,@"mHeight"),
                         SET_VECTOR_V(Vector3DMake(-256,285,0),@"m_pCurPosition"),
                         SET_INT_V(layerInterfaceSpace1,@"m_iLayer"));
    
    Sl2 = UNFROZE_OBJECT(@"StaticObject",@"Sl2",
                         SET_STRING_V(@"Line.png",@"m_pNameTexture"),
                         SET_FLOAT_V(768,@"mWidth"),
                         SET_FLOAT_V(5,@"mHeight"),
                         SET_VECTOR_V(Vector3DMake(0,0,0),@"m_pCurPosition"),
                         SET_VECTOR_V(Vector3DMake(0,0,90),@"m_pCurAngle"),
                         SET_INT_V(layerInterfaceSpace1,@"m_iLayer"));
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

    [self Load];

    pTouchV=UNFROZE_OBJECT(@"Ob_TouchView",@"TouchView",
                            SET_VECTOR_V(Vector3DMake(256,0,0),@"m_pCurPosition"));

    pInfoFile=UNFROZE_OBJECT(@"DropBoxMng",@"DropBox",
                             SET_VECTOR_V(Vector3DMake(-240, -60, 0),@"m_pCurPosition"));

    //создаём ресурсы по порядку
    pResTexture=UNFROZE_OBJECT(@"Ob_ResourceMng",@"TextureMng",
                            SET_INT_V(R_TEXTURE,@"m_iTypeRes"),
                            SET_VECTOR_V(Vector3DMake(-256, -49.9f, 0),@"m_pCurPosition"));

    pResSound=UNFROZE_OBJECT(@"Ob_ResourceMng",@"SoundMng",
                               SET_INT_V(R_SOUND,@"m_iTypeRes"),
                               SET_VECTOR_V(Vector3DMake(-256, -49.9f, 0),@"m_pCurPosition"));

    [m_pObjMng->pStringContainer->ArrayPoints->pCurrenContPar->pTexRes PrepareResTexture];
    [m_pObjMng->pStringContainer->ArrayPoints->pCurrenContPar->pSoundRes PrepareResSound];
//===============================режими==============================================

	[super Start];
    
//////////////////подготовка параметров
    FractalString *pStrCheck = [m_pObjMng->pStringContainer GetString:@"CurrentCheck"];
    
    if(pStrCheck!=nil){
        
        MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:pStrCheck->
                           m_iIndex];
        
        iIndexCheck=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[0];
        
         int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                       GetDataAtIndex:iIndexCheck];
        
        if(ICheck)
        {
            if(*ICheck==M_EDIT_PROP || *ICheck==M_EDIT_NUM || *ICheck==M_EDIT_EN_EX
               || *ICheck==M_CONNECT_IND || *ICheck==M_SEL_TEXTURE || *ICheck==M_SEL_SOUND
               || *ICheck==M_ADD_NEW_DATA || *ICheck==M_TRANSLATE
               || *ICheck==M_FULL_SCREEN || *ICheck==M_DEBUG)*ICheck=0;
            m_iMode=(int)(*ICheck);
        }
        
        iIndexChelf=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[1];
    }
//////////////////
    [self CreateFundInt];
//save/load
    
    ButtonGroup = UNFROZE_OBJECT(@"Ob_GroupButtons",@"GroupButtons",
                   SET_VECTOR_V(Vector3DMake(-450,-60,0),@"m_pCurPosition"),
                   SET_FLOAT_V(520,@"mHeight"));

    int *FChelf=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexChelf];
    
    Eplace = UNFROZE_OBJECT(@"Ob_GroupEmptyPlace",@"GroupPlaces",
                   SET_INT_V(*FChelf,@"m_iCurrentSelect"),
                   SET_VECTOR_V(Vector3DMake(-216,310,0),@"m_pCurPosition"));
    
//===================================================================================
    [self UpdateB];

    if([Eplace->m_pChildrenbjectsArr count]>0){

        int *FChelf=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                            GetDataAtIndex:iIndexChelf];

        Ob_EmtyPlace *pEmtyPlace=[Eplace->m_pChildrenbjectsArr objectAtIndex:*FChelf];

        pEmtyPlace->m_bPush=YES;

        pEmtyPlace->mColor.red=1;
        pEmtyPlace->mColor.green=0;
        pEmtyPlace->mColor.blue=0;

        [ButtonGroup SetString:pEmtyPlace->pStrInside];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetMode:(int)iModeTmp{

    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];
    
    OldInterfaceMode=m_iMode;
    m_iMode=iModeTmp;//move
    *ICheck=m_iMode;
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)CheckMove{
    
    OBJECT_PERFORM_SEL(NAME(BCopy),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BLink),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BDropBox),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BConnect),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BFullScreen),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BDebug),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BTranslate),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BEnEx),@"SetUnPush");

    
    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];

    m_iMode=M_MOVE;//move
    *ICheck=m_iMode;
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)CheckCopy{

    OBJECT_PERFORM_SEL(NAME(BMove),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BLink),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BDropBox),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BConnect),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BFullScreen),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BDebug),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BTranslate),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BEnEx),@"SetUnPush");
    
    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];

    m_iMode=M_COPY;//copy
    *ICheck=m_iMode;
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)CheckLink{

    OBJECT_PERFORM_SEL(NAME(BMove),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BCopy),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BDropBox),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BConnect),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BFullScreen),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BDebug),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BTranslate),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BEnEx),@"SetUnPush");
    
    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];

    m_iMode=M_LINK;//link
    *ICheck=m_iMode;
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)SetTranslate{
    
    OBJECT_PERFORM_SEL(NAME(BMove),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BCopy),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BLink),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BConnect),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BFullScreen),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BDebug),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BDropBox),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BEnEx),@"SetUnPush");
    
    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];
    
    m_iMode=M_TRANSLATE;//Translate
    *ICheck=m_iMode;
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)SetDropBox{

    OBJECT_PERFORM_SEL(NAME(BMove),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BCopy),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BLink),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BConnect),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BFullScreen),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BDebug),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BTranslate),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BEnEx),@"SetUnPush");

    OBJECT_PERFORM_SEL(@"DropBox",@"DownLoadInfoFile");
    
    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];

    m_iMode=M_DROP_BOX;//DropBox
    *ICheck=m_iMode;
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)CheckConnection{
    
    OBJECT_PERFORM_SEL(NAME(BMove),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BCopy),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BLink),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BDropBox),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BFullScreen),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BDebug),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BTranslate),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BEnEx),@"SetUnPush");

    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];

    m_iMode=M_CONNECT;//Connection
    *ICheck=m_iMode;
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)CheckFullScreen{

    [m_pObjMng->pStringContainer->ArrayPoints->pCurrenContPar SetFullScreen];

    UNFROZE_OBJECT(@"Ob_Ret_From_Full",@"Ret_From_Full",nil);

    OBJECT_PERFORM_SEL(NAME(BMove),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BCopy),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BLink),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BDropBox),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BConnect),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BDebug),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BTranslate),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BEnEx),@"SetUnPush");

    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];
    
    OldInterfaceMode=m_iMode;
    m_iMode=M_FULL_SCREEN;//Full Screen
    *ICheck=m_iMode;
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)CheckDebug{
        
    OBJECT_PERFORM_SEL(NAME(BDropBox),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BMove),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BCopy),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BLink),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BConnect),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BFullScreen),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BTranslate),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BEnEx),@"SetUnPush");

    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];
    
    OldInterfaceMode=m_iMode;
    m_iMode=M_DEBUG;//Full Screen
    *ICheck=m_iMode;
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)CheckSetProp{
    
    OBJECT_PERFORM_SEL(NAME(BDropBox),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BMove),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BCopy),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BLink),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BConnect),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BDebug),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BTranslate),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BFullScreen),@"SetUnPush");

    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];
    
    OldInterfaceMode=m_iMode;
    m_iMode=M_EDIT_EN_EX;//prop
    *ICheck=m_iMode;
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)SelSound{
    
    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];
    
    pResTexture->OldInterfaceMode=m_iMode;
    OldInterfaceMode=m_iMode;
    m_iMode=M_SEL_SOUND;//sel sound
    OldCheck=*ICheck;
    *ICheck=m_iMode;
    
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)SelTexture{
    
    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];
    
    pResSound->OldInterfaceMode=m_iMode;
    OldInterfaceMode=m_iMode;
    m_iMode=M_SEL_TEXTURE;//sel texture
    OldCheck=*ICheck;
    *ICheck=m_iMode;
    
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (int)GetMatrixSize:(MATRIXcell *)pMatr{
    
    return pMatr->iDimMatrix;
}
//------------------------------------------------------------------------------------------------------
- (void)AddNewData{
    
    int iType=[m_pObjMng->pStringContainer->ArrayPoints
               GetTypeAtIndex:ButtonGroup->pInsideString->m_iIndex];
    
    if(iType==DATA_ARRAY)
    {
        int **ppArray=[m_pObjMng->pStringContainer->ArrayPoints
                       GetArrayAtIndex:ButtonGroup->pInsideString->m_iIndex];
        
        InfoArrayValue *pInfoArray=(InfoArrayValue *)*ppArray;
                
        if((pInfoArray->mFlags & F_DATA) && pInfoArray->UnParentMatrix.indexMatrix!=0)
        {
            MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints
                               GetMatrixAtIndex:pInfoArray->UnParentMatrix.indexMatrix];
            
            int SizeMatrix=[self GetMatrixSize:pMatr];//узнаем размерность матрицы

            if(pInfoArray->mType==DATA_U_INT)
            {
                int iCurid=0;
                
                for (int i=0; i<SizeMatrix; i++)
                {
                    iCurid=i;

                    int iPlace=[m_pObjMng->pStringContainer->m_OperationIndex
                                                    FindIndex:iCurid WithData:ppArray];
                    
                    if(iPlace==-1)
                        break;                    
                }
                
                [m_pObjMng->pStringContainer->m_OperationIndex OnlyAddData:iCurid WithData:ppArray];
            }
            else
            {
                InfoArrayValue *pInfoArrayDataMatr=(InfoArrayValue *)*pMatr->ppDataMartix;
                pMatr->iDimMatrix++;
                
                

                for (int i=0; i<pInfoArrayDataMatr->mCount; i++)
                {
                    int iIndexArray=(*pMatr->ppDataMartix+SIZE_INFO_STRUCT)[i];
                    int **ppArrayTmpArray = [m_pObjMng->pStringContainer->ArrayPoints
                                                    GetArrayAtIndex:iIndexArray];
                    InfoArrayValue *pInfoTmpArray=(InfoArrayValue *)*ppArrayTmpArray;
                    
                    int iNewIndexData;
                    
                    switch (pInfoTmpArray->mType)
                    {
                        case DATA_INT:
                            iNewIndexData=[m_pObjMng->pStringContainer->ArrayPoints SetInt:0];
                            break;
                        case DATA_FLOAT:
                            iNewIndexData=[m_pObjMng->pStringContainer->ArrayPoints SetFloat:0];
                            break;
                        case DATA_SPRITE:
                            iNewIndexData=[m_pObjMng->pStringContainer->ArrayPoints SetSprite:0];
                            break;
                        case DATA_TEXTURE:
                            iNewIndexData=[m_pObjMng->pStringContainer->ArrayPoints SetTexture:0];
                            break;
                        case DATA_SOUND:
                            iNewIndexData=[m_pObjMng->pStringContainer->ArrayPoints SetSound:0];
                            break;
                            
                        default:
                            continue;
                            break;
                    }
                    
                    [m_pObjMng->pStringContainer->m_OperationIndex
                                AddData:iNewIndexData WithData:ppArrayTmpArray];
                }
            }
        }
        else  if(pInfoArray->mType==DATA_U_INT && pInfoArray->UnParentMatrix.indexMatrix==0)
        {
            [m_pObjMng->pStringContainer->m_OperationIndex OnlyAddData:0 WithData:ppArray];
        }
    }
    else
    {
        int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                            GetDataAtIndex:iIndexCheck];
        
        pResTexture->OldInterfaceMode=m_iMode;
        OldInterfaceMode=m_iMode;
        m_iMode=M_ADD_NEW_DATA;//select texture
        OldCheck=*ICheck;
        *ICheck=m_iMode;
    }
    
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)DoubleTouchObject{
    
    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];

    pResTexture->OldInterfaceMode=m_iMode;
    OldInterfaceMode=m_iMode;
    m_iMode=M_EDIT_PROP;//prop
    OldCheck=*ICheck;
    *ICheck=m_iMode;
    
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)CloseChoseIcon{
    
    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];

    *ICheck=OldCheck;
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)DownLoad{
    [m_pObjMng->pStringContainer->pDataCurManagerTmp DownLoad];
    [self Load];
}
//------------------------------------------------------------------------------------------------------
- (void)UpLoad{
    
    [self Save];
    [m_pObjMng->pStringContainer->pDataCurManagerTmp UpLoad];
}
//------------------------------------------------------------------------------------------------------
- (void)Load{

    bool bLoad = [m_pObjMng->pStringContainer LoadContainer];

    if(bLoad==NO)[m_pObjMng->pStringContainer SetEditor];
    
    OBJECT_PERFORM_SEL(@"GroupPlaces",@"ReLinkEmptyPlace");
    
    [ButtonGroup SetString:[m_pObjMng->pStringContainer GetString:@"Objects"]];
    OBJECT_PERFORM_SEL(@"GroupButtons",@"UpdateButt");
}
//------------------------------------------------------------------------------------------------------
- (void)Save{
//    [m_pObjMng->pStringContainer SaveContainer];
}
//------------------------------------------------------------------------------------------------------
- (void)SetStatusBar{
    if(PrBar==nil)
        PrBar =  CREATE_NEW_OBJECT(@"Ob_ProgressBar",@"Progress",nil);
}
//------------------------------------------------------------------------------------------------------
- (void)DelStatusBar{
    
    if(PrBar!=nil)
    {
        DESTROY_OBJECT(PrBar);
        PrBar=nil;
    }
}                 
//------------------------------------------------------------------------------------------------------
- (void)SynhDropBox{
    
    [pInfoFile Synhronization];
    pInfoFile->bNeedUpload=NO;
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)ClearInterface{
    
    [pResTexture Hide];
    [pResSound Hide];
    [pInfoFile Hide];
    [ButtonGroup Hide];
    [Eplace Hide];

    DESTROY_OBJECT(RectView);
    RectView=nil;

    DESTROY_OBJECT(Sl3);
    Sl3=nil;

    DESTROY_OBJECT(BigWheel);
    BigWheel=nil;

    DESTROY_OBJECT(PrSyn);
    PrSyn=nil;

    DESTROY_OBJECT(BTash);
    BTash=nil;
    
    DESTROY_OBJECT(BDropBox);
    BDropBox=nil;

    DESTROY_OBJECT(BTranslate);
    BTranslate=nil;

    DESTROY_OBJECT(BMove);
    BMove=nil;
    
    DESTROY_OBJECT(BCopy);
    BCopy=nil;
    
    DESTROY_OBJECT(BLink);
    BLink=nil;
    
    DESTROY_OBJECT(BTIn);
    BTIn=nil;

    DESTROY_OBJECT(BTOut);
    BTOut=nil;

    DESTROY_OBJECT(BTIn2);
    BTIn2=nil;
    
    DESTROY_OBJECT(BTOut2);
    BTOut2=nil;

    DESTROY_OBJECT(BFullScreen);
    BFullScreen=nil;

    DESTROY_OBJECT(BDebug);
    BDebug=nil;

    DESTROY_OBJECT(BConnect);
    BConnect=nil;

    DESTROY_OBJECT(BSetProp);
    BSetProp=nil;

    DESTROY_OBJECT(BDropPlus);
    BDropPlus=nil;
    
    DESTROY_OBJECT(BLevelUp);
    BLevelUp=nil;

    DESTROY_OBJECT(BEnEx);
    BEnEx=nil;
    
    DEL_CELL(@"DropBoxString");
    DEL_CELL(@"DragObject");
    DEL_CELL(@"EmptyOb");
    DEL_CELL(@"StartConnection");
 //   DEL_CELL(@"DoubleTouchFractalString");
    DEL_CELL(@"ObCheckOb");
    
    [self RemoveTmpButton];
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateB{

    IndexSelect=-1;
//    FractalString *pStrOb = [m_pObjMng->pStringContainer GetString:@"Objects"];
//    [m_pObjMng->pStringContainer LogString:pStrOb];
    
    FractalString *pStrCheck = [m_pObjMng->pStringContainer GetString:@"CurrentCheck"];
    
    MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:pStrCheck->m_iIndex];

        int *TmpICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                       GetDataAtIndex:(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[0]];

    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints GetDataAtIndex:iIndexCheck];

    ICheck=TmpICheck;
    
    if(ICheck!=0){
        [self ClearInterface];

        switch (*ICheck) {

//            case M_TRANSLATE:
//                break;
            case M_EDIT_PROP:
                pResTexture->m_bIcon=YES;
                [pResTexture Show];
                break;

            case M_SEL_TEXTURE:
                pResTexture->m_bIcon=NO;
                [pResTexture Show];
                break;

            case M_SEL_SOUND:
                [pResSound Show];
                break;

            case M_ADD_NEW_DATA:
            {
                if(EditorAddNewData==nil)
                {
                    EditorAddNewData =  UNFROZE_OBJECT(@"Ob_AddNewData",@"EditorAddNewData",
                                            SET_FLOAT_V(54,@"mWidth"),
                                            SET_FLOAT_V(54,@"mHeight"),
                                            SET_VECTOR_V(Vector3DMake(-250,-30,0),@"m_pCurPosition"));
                    
                    ((Ob_AddNewData *)EditorAddNewData)->OldInterfaceMode=OldInterfaceMode;
                    OBJECT_PERFORM_SEL(NAME(EditorAddNewData), @"UpdateTmp");
                }
            }
            break;
                
            case M_CONNECT_IND:
            {
                if(EditorSelectPar==nil)
                {
                    EditorSelectPar =  UNFROZE_OBJECT(@"Ob_SelectionPar",@"SelectionPar",
                                            SET_FLOAT_V(54,@"mWidth"),
                                            SET_FLOAT_V(54,@"mHeight"),
                                            SET_VECTOR_V(Vector3DMake(-250,-30,0),@"m_pCurPosition"));

                    ((Ob_SelectionPar *)EditorSelectPar)->OldInterfaceMode=OldInterfaceMode;
                    ((Ob_SelectionPar *)EditorSelectPar)->EndHeart=EndHeart;
                    ((Ob_SelectionPar *)EditorSelectPar)->m_iIndexStart=m_iIndexStart;
                    ((Ob_SelectionPar *)EditorSelectPar)->pMatr=pMatrTmp;
                    ((Ob_SelectionPar *)EditorSelectPar)->pConnString=pConnString;

                    OBJECT_PERFORM_SEL(NAME(EditorSelectPar), @"UpdateTmp");
                }
            }
            break;
                
            case M_EDIT_NUM:
            {
                if(EditorNum==nil){
                    
                    int iTypeInd= [m_pObjMng->pStringContainer->ArrayPoints
                                     GetTypeAtIndex:ButtonGroup->pInsideString->m_iIndex];
                    
                    if(iTypeInd==DATA_MATRIX)
                    {
//                        int **ppArray=[m_pObjMng->pStringContainer->ArrayPoints
//                                       GetArrayAtIndex:StringSelect->m_iIndex];
//                        int *pStartData=(*ppArray)+SIZE_INFO_STRUCT;
//
//                        iIndexForNum=pStartData[0];

                        EditorNum =  UNFROZE_OBJECT(@"Ob_Editor_Num",@"Editor_Num",
                                        SET_INT_V(StringSelect->m_iIndex,@"iIndexArray"),
                                        SET_INT_V(iIndexForNum,@"iIndex"));
                        ((Ob_Editor_Num *)EditorNum)->OldInterfaceMode=OldInterfaceMode;
                        OBJECT_PERFORM_SEL(NAME(EditorNum), @"UpdateNum");
                    }
                    else
                    {
                        EditorNum =  UNFROZE_OBJECT(@"Ob_Editor_Num",@"Editor_Num",
                                        SET_INT_V(ButtonGroup->pInsideString->m_iIndex,@"iIndexArray"),
                                        SET_INT_V(iIndexForNum,@"iIndex"));
                        ((Ob_Editor_Num *)EditorNum)->OldInterfaceMode=OldInterfaceMode;
                        OBJECT_PERFORM_SEL(NAME(EditorNum), @"UpdateNum");
                    }
                }
            }
            break;

//            case M_EDIT_EN_EX:
//            {
//                if(EditorSelect==nil){
//
//                    EditorSelect =  UNFROZE_OBJECT(@"Ob_Selection",@"Selection",
//                                       SET_FLOAT_V(54,@"mWidth"),
//                                       SET_FLOAT_V(54,@"mHeight"),
//                                       SET_VECTOR_V(Vector3DMake(-250,-30,0),@"m_pCurPosition"));
//                    
//                    ((Ob_Selection *)EditorSelect)->OldInterfaceMode=OldInterfaceMode;
//                    ((Ob_Selection *)EditorSelect)->CurrentStr=StringSelect;
//                    
//                    OBJECT_PERFORM_SEL(NAME(EditorSelect), @"UpdateTmp");
//                }
 //           }
   //         break;
                
            case M_FULL_SCREEN:
            {
                [self removeFundInt];
            }
            break;
                
            default:
            {
                [self CreateButtons];
                int *pMode=GET_INT_V(@"m_iMode");
                
                if(pMode!=0 && *pMode==M_DROP_BOX)
                {
                    if(pInfoFile->bNeedUpload==YES && pInfoFile->bDropBoxWork==NO)
                        PrSyn=UNFROZE_OBJECT(@"ObjectButton",@"ButtonSynh",
                                             SET_STRING_V(@"Button_Synh.png",@"m_DOWN"),
                                             SET_STRING_V(@"Button_Synh.png",@"m_UP"),
                                             SET_FLOAT_V(44,@"mWidth"),
                                             SET_FLOAT_V(44,@"mHeight"),
                                             SET_BOOL_V(YES,@"m_bLookTouch"),
                                             SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                                             SET_STRING_V(@"SynhDropBox",@"m_strNameStage"),
                                             SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                                             SET_VECTOR_V(Vector3DMake(-73,360,0),@"m_pCurPosition"));
                }
                
                OBJECT_PERFORM_SEL(@"GroupPlaces", @"UpdateButt");
                
                if(((ObjectButton *)BDropBox)->m_bPush==YES){
                    
                    if(pInfoFile->bDropBoxWork==YES){
                        [self SetStatusBar];
                    }
                    else{
                        [self DelStatusBar];
                        [pInfoFile UpdateButt];
                    }
                }
                else
                {
                    [self DelStatusBar];
                    [ButtonGroup UpdateButt];
                }

            }
                break;
        }
    }
    StringSelect=0;
}
//------------------------------------------------------------------------------------------------------
//- (void)InitProc:(ProcStage_ex *)pStage{}
////----------------------------------------------------------------------------------------------------
//- (void)PrepareProc:(ProcStage_ex *)pStage{}
////----------------------------------------------------------------------------------------------------
//- (void)Proc:(Processor_ex *)pProc{}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
-(void) dealloc
{
    [pArrayToDel release];
    [pInfoFile release];
    [aObPoints release];
    [aObSliders release];
    [aObjects release];
    [aProp release];
    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
@end