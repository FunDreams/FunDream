//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_GroupButtons.h"
#import "ObjectB_Ob.h"
#import "ObjectB_Ob_Array.h"
#import "Ob_Editor_Interface.h"
#import "Ob_Connectors.h"
#import "Ob_MinIcons.h"
#import "FunArrayData.h"

@implementation Ob_GroupButtons
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerInterfaceSpace9;
        m_iLayerTouch=layerTouch_0;//слой касания
        m_bHiden=NO;
        mHeight=30;
        m_iNumButton=9;
        
        m_pChildrenbjectsArrConn = [[NSMutableArray alloc] init];
        m_pChildrenbjectsMinIcon = [[NSMutableArray alloc] init];
        m_fTimerCheckFlick=0;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
//- (void)SetDefault{}
//- (void)PostSetParams{}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];

//====//различные параметры=============================================================================
//   [m_pObjMng->pMegaTree SetCell:(LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY"));
    
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    [m_pObjMng->pMegaTree SetCell:(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"))];

    [m_pObjMng->pMegaTree SetCell:(LINK_INT_V(m_iNumButton,m_strName,@"m_iNumButton"))];
}
//------------------------------------------------------------------------------------------------------
- (void)CheckArray{
    
    id pObTmp = GET_ID_V(@"ObCheckObArray");
    
    int i=0;
    if(pObTmp!=nil){
        for (GObject *pOb in m_pChildrenbjectsArr)
        {
            if(pOb==pObTmp){
                m_iCurrentSelect=i;
                
                ObjectB_Ob_Array *pOb = [m_pChildrenbjectsArr objectAtIndex:m_iCurrentSelect];
                Ob_Editor_Interface *pInterface=(Ob_Editor_Interface *)[m_pObjMng
                                                GetObjectByName:@"Ob_Editor_Interface"];
                pInterface->IndexSelect=pOb->m_iIndexArray;


                continue;
            }
            else{
                OBJECT_PERFORM_SEL(pOb->m_strName, @"SetUnPush");
            }
            i++;
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Check{
    
    int *pMode=GET_INT_V(@"m_iMode");
    id pObTmp = GET_ID_V(@"ObCheckOb");
    
    int i=0;
    if(pObTmp!=nil){
        for (GObject *pOb in m_pChildrenbjectsArr)
        {
            if(pOb==pObTmp){
                m_iCurrentSelect=i;
                continue;
            }
            else{
                if(*pMode!=M_TRANSLATE)
                    OBJECT_PERFORM_SEL(pOb->m_strName, @"SetUnPush");
            }
            i++;
        }
    }
    
    [self SetButton];
}
//------------------------------------------------------------------------------------------------------
- (void)SetButton{
    
    if([m_pChildrenbjectsArr count]>0){
        
        int *pMode=GET_INT_V(@"m_iMode");
        if(m_iCurrentSelect+1>[m_pChildrenbjectsArr count])m_iCurrentSelect=0;
        
        ObjectB_Ob *pOb = [m_pChildrenbjectsArr objectAtIndex:m_iCurrentSelect];
        int iType=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:pOb->pString->m_iIndex];

        if(*pMode==M_EDIT_EN_EX)
        {
            OBJECT_PERFORM_SEL(@"Ob_Editor_Interface", @"SetButtonEnEx");
        }
        else if(*pMode==M_TRANSLATE)
        {
            OBJECT_PERFORM_SEL(@"Ob_Editor_Interface", @"SetButtonInOut");
        }
        else
        {
            if(iType==DATA_ARRAY)
            {
                OBJECT_PERFORM_SEL(@"Ob_Editor_Interface", @"SetButtonEdit");
                OBJECT_PERFORM_SEL(@"Ob_Editor_Interface", @"SetButtonAssociate");
            }
            else if(iType==DATA_MATRIX)
            {
                OBJECT_PERFORM_SEL(@"Ob_Editor_Interface", @"SetButtonEnterPoint");
                OBJECT_PERFORM_SEL(@"Ob_Editor_Interface", @"SetButtonAssociate");
            }
            else
            {
                OBJECT_PERFORM_SEL(@"Ob_Editor_Interface", @"RemButtonEdit");
            }
        }
        
        Ob_Editor_Interface *pInterface=(Ob_Editor_Interface *)[m_pObjMng
                                GetObjectByName:@"Ob_Editor_Interface"];
        
        pInterface->StringSelect=pOb->pString;

        DEL_CELL(@"ObCheckOb");
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Hide{

    for (ObjectB_Ob *pOb in m_pChildrenbjectsArr) {
        DESTROY_OBJECT(pOb);
    }
    [m_pChildrenbjectsArr removeAllObjects];

    for (Ob_Connectors *pOb in m_pChildrenbjectsArrConn) {
        DESTROY_OBJECT(pOb);
    }
    [m_pChildrenbjectsArrConn removeAllObjects];
    
    for (Ob_MinIcons *pOb in m_pChildrenbjectsMinIcon) {
        DESTROY_OBJECT(pOb);
    }
    [m_pChildrenbjectsMinIcon removeAllObjects];
}
//------------------------------------------------------------------------------------------------------
- (void)Show{

    for (ObjectB_Ob *pOb in m_pChildrenbjectsArr) {
        [pOb SetTouch:YES];
        [pOb AddToDraw];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)CreateObArrayUI:(int)pIndexData Index:(int)iCurIndex{
    
    Color3D ColorTmp = Color3DMake(1, 1, 1, 1);
    bool bFlick=NO;
    float Width=44;
    float Height=44;

    ColorTmp = Color3DMake(1,0.5,0,1);
    
    float X=-420+(iCurIndex%8)*54;
    float Y=240-(iCurIndex/8)*60;
    
    ObjectB_Ob *pOb=UNFROZE_OBJECT(@"ObjectB_Ob_Array",@"Object",
                                   SET_INT_V(iCurIndex,@"m_iNum"),
                                   SET_INT_V(DATA_U_INT,@"m_iTypeStr"),
                                   SET_STRING_V(@"ButtonOb.png",@"m_DOWN"),
                                   SET_STRING_V(@"ButtonOb.png",@"m_UP"),
                                   SET_FLOAT_V(Width,@"mWidth"),
                                   SET_FLOAT_V(Height,@"mHeight"),
                                   //SET_BOOL_V(YES,@"m_bLookTouch"),
                                   SET_STRING_V(NAME(self),@"m_strNameObject"),
                                   SET_STRING_V(@"CheckArray",@"m_strNameStage"),
                                   SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                                   SET_BOOL_V(YES,@"m_bDrag"),
                                   SET_COLOR_V(ColorTmp,@"mColorBack"),
                                   SET_BOOL_V(bFlick,@"m_bFlicker"),
                                   SET_VECTOR_V(Vector3DMake(X,Y,0),@"m_pCurPosition"));
    
    //  GET_TEXTURE(pOb->mTextureId, pFrStr->sNameIcon);
    pOb->m_iIndexArray=iCurIndex;
    pOb->m_iTypeStr=DATA_U_INT;
    pOb->pString=pInsideString;
    
    [m_pChildrenbjectsArr addObject:pOb];
}
//------------------------------------------------------------------------------------------------------
- (void)CreateObArray:(int)pIndexData Index:(int)iCurIndex{
    
    Color3D ColorTmp = Color3DMake(1, 1, 1, 1);
    bool bFlick=NO;
    float Width=44;
    float Height=44;
    
    int iType=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:pIndexData];
    
    switch (iType)
    {
        case DATA_SPRITE:
            ColorTmp = Color3DMake(1,0,0,1);
            break;
        case DATA_TEXTURE:
            ColorTmp = Color3DMake(1,1,1,1);
            break;
        case DATA_FLOAT:
            ColorTmp = Color3DMake(0,0,1,1);
            break;
        case DATA_INT:
            ColorTmp = Color3DMake(1,1,0,1);
            break;
        case DATA_U_INT:
            ColorTmp = Color3DMake(1,0.5,0,1);
            break;
        case DATA_SOUND:
            ColorTmp = Color3DMake(0,1,1,1);
            break;

        case DATA_MATRIX:
        {
            MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:pIndexData];
            
            switch (pMatr->TypeInformation) {
                    
                case STR_OPERATION:
                    ColorTmp = Color3DMake(1,.4f,1,1);
                    break;
                    
                case STR_CONTAINER:
                    ColorTmp = Color3DMake(0,0,0,1);
                    //             if(pMatr->NameInformation==NAME_K_START)
                    //               bFlick=YES;
                    
                    break;
                    
                case STR_COMPLEX:
                    ColorTmp = Color3DMake(0, 1, 0, 1);
                    break;
                    
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    //iCurIndex
    
    float X=-425+(iCurIndex%10)*44;
    float Y=240-(iCurIndex/10)*44;
    
    ObjectB_Ob *pOb=UNFROZE_OBJECT(@"ObjectB_Ob_Array",@"Object",
                                   SET_INT_V(iCurIndex,@"m_iNum"),
                                   SET_INT_V(iType,@"m_iTypeStr"),
                                   SET_STRING_V(@"ButtonOb.png",@"m_DOWN"),
                                   SET_STRING_V(@"ButtonOb.png",@"m_UP"),
                                   SET_FLOAT_V(Width,@"mWidth"),
                                   SET_FLOAT_V(Height,@"mHeight"),
                                   //SET_BOOL_V(YES,@"m_bLookTouch"),
                                   SET_STRING_V(NAME(self),@"m_strNameObject"),
                                   SET_STRING_V(@"CheckArray",@"m_strNameStage"),
                                   SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                                   SET_BOOL_V(YES,@"m_bDrag"),
                                   SET_COLOR_V(ColorTmp,@"mColorBack"),
                                   SET_BOOL_V(bFlick,@"m_bFlicker"),
                                   SET_VECTOR_V(Vector3DMake(X,Y,0),@"m_pCurPosition"));
    
//  GET_TEXTURE(pOb->mTextureId, pFrStr->sNameIcon);
    pOb->m_iIndexArray=pIndexData;
    pOb->pString=pInsideString;
    pOb->m_iIndexPlace=iCurIndex;
    pOb->m_iTypeStr=iType;
    
    [m_pChildrenbjectsArr addObject:pOb];
}
//------------------------------------------------------------------------------------------------------
- (void)CreateOb:(FractalString *)pFrStr{
    
    Color3D ColorTmp = Color3DMake(1, 1, 1, 1);
    bool bFlick=NO;
    float Width=44;
    float Height=44;
    
    int iType=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:pFrStr->m_iIndex];
    
    switch (iType)
    {
        case DATA_ARRAY:
        {
            int **ppArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:pFrStr->m_iIndex];
            if(ppArray==0)return;
            InfoArrayValue *pInfo=(InfoArrayValue *)(*ppArray);
            switch (pInfo->mType) {
                case DATA_SPRITE:
                    ColorTmp = Color3DMake(1,0,0,1);
                    break;
                    
                case DATA_TEXTURE:
                    ColorTmp = Color3DMake(1,1,1,1);
                    break;

                case DATA_SOUND:
                    ColorTmp = Color3DMake(0,1,1,1);
                    break;

                case DATA_FLOAT:
                    ColorTmp = Color3DMake(0,0,1,1);
                    break;
                case DATA_INT:
                    ColorTmp = Color3DMake(1,1,0,1);
                    break;
                case DATA_U_INT:
                    ColorTmp = Color3DMake(1,0.5f,0,1);
                    break;
                    
                default:
                    break;
            }
        }
            break;
            

        case DATA_MATRIX:
        {
            MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:pFrStr->m_iIndex];

            switch (pMatr->TypeInformation) {
                    
                case STR_OPERATION:
                    ColorTmp = Color3DMake(1, .4, 1, 1);
                    break;
                    
                case STR_CONTAINER:
                    ColorTmp = Color3DMake(0, 0, 0, 1);
       //             if(pMatr->NameInformation==NAME_K_START)
         //               bFlick=YES;
                    
                    break;

                case STR_COMPLEX:
                    ColorTmp = Color3DMake(0, 1, 0, 1);                    
                    break;
                    
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    
    
    ObjectB_Ob *pOb=UNFROZE_OBJECT(@"ObjectB_Ob",@"Object",
                           SET_INT_V(iType,@"m_iTypeStr"),
                           SET_STRING_V(@"ButtonOb.png",@"m_DOWN"),
                           SET_STRING_V(@"ButtonOb.png",@"m_UP"),
                           SET_FLOAT_V(Width,@"mWidth"),
                           SET_FLOAT_V(Height,@"mHeight"),
                           //SET_BOOL_V(YES,@"m_bLookTouch"),
                           SET_STRING_V(NAME(self),@"m_strNameObject"),
                           SET_STRING_V(@"Check",@"m_strNameStage"),
                           SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                           SET_BOOL_V(YES,@"m_bDrag"),
                           SET_COLOR_V(ColorTmp,@"mColorBack"),
                           SET_BOOL_V(bFlick,@"m_bFlicker"),
                           SET_VECTOR_V(Vector3DMake(pFrStr->X,pFrStr->Y,0),@"m_pCurPosition"));
    
    GET_TEXTURE(pOb->mTextureId, pFrStr->sNameIcon);
    pOb->pString=pFrStr;
    pOb->m_iTypeStr=iType;
    
    [m_pChildrenbjectsArr addObject:pOb];
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateButt{
    
    if(pInsideString==nil)return;
    
    Ob_Editor_Interface *pInterface=(Ob_Editor_Interface *)[m_pObjMng
                            GetObjectByName:@"Ob_Editor_Interface"];
    
    pInterface->StringSelect=0;
    
    for (ObjectB_Ob *pOb in m_pChildrenbjectsArr) {
        DESTROY_OBJECT(pOb);
    }
    [m_pChildrenbjectsArr removeAllObjects];

    for (Ob_Connectors *pOb in m_pChildrenbjectsArrConn) {
        DESTROY_OBJECT(pOb);
    }
    [m_pChildrenbjectsArrConn removeAllObjects];
    
    for (Ob_MinIcons *pOb in m_pChildrenbjectsMinIcon) {
        DESTROY_OBJECT(pOb);
    }
    [m_pChildrenbjectsMinIcon removeAllObjects];
//------------------------------------------------------------------------------------------------------
    int *Data=(*pInsideString->pChildString);
    InfoArrayValue *InfoStr=(InfoArrayValue *)(Data);

    for(int i=0;i<InfoStr->mCount;i++){
        
        int index=(Data+SIZE_INFO_STRUCT)[i];
        int iType=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:index];

        if(iType==DATA_ID){
            FractalString *pFrStr=[m_pObjMng->pStringContainer->ArrayPoints
                           GetIdAtIndex:index];

            [self CreateOb:pFrStr];
        }
    }

    MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:pInsideString->m_iIndex];
    if(pMatr!=0 && pMatr->TypeInformation!=STR_OPERATION){
        
        //делаем цифры на очередь
//        InfoArrayValue *InfoStrPlaces=(InfoArrayValue *)(*pMatr->ppStartPlaces);
//        int *StartDataPl=(*pMatr->ppStartPlaces)+SIZE_INFO_STRUCT;
//
//        for (int i=0; i<InfoStrPlaces->mCount; i++)
//        {
//            int iPlace=StartDataPl[i];
//
//            if(iPlace==-1)continue;
//            
//            ObjectB_Ob *pOb=[m_pChildrenbjectsArr objectAtIndex:iPlace];
//            
//            NSString * StrValue=[NSString stringWithFormat:@"%d",i+1];
//            
//            int iFontSize=14;
//            pOb->TexIndicatrorQueue=[self CreateText:StrValue al:UITextAlignmentLeft
//                                         Tex:pOb->TexIndicatrorQueue fSize:iFontSize
//                                         dimensions:CGSizeMake(mWidth-10, iFontSize+4)
//                                         fontName:@"Gill Sans"];
//        }
//
//        //делаем цифры на активные пространства
//        InfoStrPlaces=(InfoArrayValue *)(*pMatr->ppActivitySpace);
//        StartDataPl=(*pMatr->ppActivitySpace)+SIZE_INFO_STRUCT;
//        
//        for (int i=0; i<InfoStrPlaces->mCount; i++)
//        {
//            int iPindex=StartDataPl[i];
//            
//            if(iPindex==-1)continue;
//            
//            int iPlace =[m_pObjMng->pStringContainer->m_OperationIndex
//                         FindIndex:iPindex WithData:pMatr->pValueCopy];
//            
//            if(iPlace==-1)continue;
//            
//            ObjectB_Ob *pOb=[m_pChildrenbjectsArr objectAtIndex:iPlace];
//            
//            NSString * StrValue=[NSString stringWithFormat:@"%d",i+1];
//            
//            int iFontSize=14;
//            pOb->TexIndicatrorQueue=[self CreateText:StrValue al:UITextAlignmentLeft
//                                                 Tex:pOb->TexIndicatrorQueue fSize:iFontSize
//                                          dimensions:CGSizeMake(mWidth-10, iFontSize+4)
//                                            fontName:@"Gill Sans"];
//        }

        
        
        
        InfoArrayValue *InfoStrQueue=(InfoArrayValue *)(*pMatr->pQueue);
        int *StartDataQ=(*pMatr->pQueue)+SIZE_INFO_STRUCT;
        
        for (int i=0; i<InfoStrQueue->mCount; i++) {
            HeartMatr *pHeart=(HeartMatr *)StartDataQ[i];
            
            if(pHeart!=nil){
                
                int  iCurIndexMatr=((*pMatr->pValueCopy)+SIZE_INFO_STRUCT)[i];
                MATRIXcell *pMatrChild=[m_pObjMng->pStringContainer->ArrayPoints
                                   GetMatrixAtIndex:iCurIndexMatr];
                int *StartChild=*pMatrChild->pValueCopy+SIZE_INFO_STRUCT;
                InfoArrayValue *InfoEnter=(InfoArrayValue *)*pMatrChild->pEnters;

                int  iCurIndexChildStr=((*pInsideString->pChildString)+SIZE_INFO_STRUCT)[i];
                FractalString *pStringTmp=(FractalString *)[m_pObjMng->pStringContainer->ArrayPoints
                                                         GetIdAtIndex:iCurIndexChildStr];

                InfoArrayValue *InfoChildString=(InfoArrayValue *)*pStringTmp->pChildString;
                int *StartChildString=*pStringTmp->pChildString+SIZE_INFO_STRUCT;

    //            InfoArrayValue *InfoStrNext=(InfoArrayValue *)(*pHeart-//>pNextPlaces);
  //              int *StartDataNext=(*pHeart->pNextPlaces)+SIZE_INFO_STRUCT;
                
//                for (int j=0; j<InfoStrNext->mCount; j++) {

//                    int indexFirst=(Data+SIZE_INFO_STRUCT)[i];
//                    FractalString *pFrStrFirst=[m_pObjMng->pStringContainer->ArrayPoints
//                                                 GetIdAtIndex:indexFirst];

                int Place=pHeart->pNextPlace;
                
                if(Place!=-1){
//                    int indexSecond=(Data+SIZE_INFO_STRUCT)[Place];
//                    FractalString *pFrStrSecond=[m_pObjMng->pStringContainer->ArrayPoints
//                                           GetIdAtIndex:indexSecond];

                    ObjectB_Ob *pObFirst=[m_pChildrenbjectsArr objectAtIndex:i];
                    ObjectB_Ob *pObSecond=[m_pChildrenbjectsArr objectAtIndex:Place];

                    Ob_Connectors *pObConn=UNFROZE_OBJECT(@"Ob_Connectors",@"Connectors",
                                                SET_STRING_V(@"LineDirect.png",@"m_pNameTexture"),
                                                SET_COLOR_V(Color3DMake(1, 0, 1, 0.7f),@"mColor"));
                    pObConn->Start=&pObFirst->m_pCurPosition;
                    pObConn->End=&pObSecond->m_pCurPosition;
                    [m_pChildrenbjectsArrConn addObject:pObConn];
                }
  //              }
                
                //инициализируем связи для параметров
                InfoArrayValue *InfoStrEnterPar=(InfoArrayValue *)(*pHeart->pEnPairPar);
                int *StartEnterPar=(*pHeart->pEnPairPar)+SIZE_INFO_STRUCT;

                for (int j=0; j<InfoStrEnterPar->mCount; j++) {
                    
                    int iCurIndex=StartEnterPar[j];
                    ObjectB_Ob *pObFirst=0;
                    
                    for (int k=0; k<[m_pChildrenbjectsArr count]; k++) {
                        ObjectB_Ob *pObTmp=[m_pChildrenbjectsArr objectAtIndex:k];
                        
                        if(iCurIndex==pObTmp->pString->m_iIndex)
                            pObFirst=pObTmp;
                        
                    }
                    if(pObFirst==nil)continue;
        
                    ObjectB_Ob *pObSecond=[m_pChildrenbjectsArr objectAtIndex:i];

                    Ob_Connectors *pObConn=UNFROZE_OBJECT(@"Ob_Connectors",@"Connectors",
                                                SET_STRING_V(@"LineWhite.png",@"m_pNameTexture"),
                                                SET_COLOR_V(Color3DMake(0, 0.5f, 1, 0.7f),@"mColor"));
                    
                    pObConn->Start=&pObFirst->m_pCurPosition;
                    pObConn->End=&pObSecond->m_pCurPosition;
                    [m_pChildrenbjectsArrConn addObject:pObConn];
//--------------------------------------------------------------------------------------------------
                    NSMutableString *pNameIcon=[NSMutableString stringWithString:@""];
                    if(pMatrChild->TypeInformation==STR_COMPLEX){
                        
                        for (int k=0; k<InfoChildString->mCount; k++) {
                            int iTmpIndex=StartChildString[k];
                            FractalString *pString=(FractalString *)[m_pObjMng->pStringContainer->ArrayPoints
                                                                     GetIdAtIndex:iTmpIndex];
                            
                            if(pString->m_iIndex==iCurIndex){
                                [pNameIcon setString:pString->sNameIcon];
                                break;
                            }
                        }
                    }
                    else
                    {
                        int CurretnOffset=j*2+2;
                        int index=StartChild[CurretnOffset];
                        
                        NSMutableString *TmpStr=(NSMutableString *)[m_pObjMng->pStringContainer->ArrayPoints
                                                                    GetIdAtIndex:index];
                        
                        if(TmpStr!=nil)
                            [pNameIcon setString:TmpStr];
                    }
                    
                    Ob_MinIcons *pObMinIcon=UNFROZE_OBJECT(@"Ob_MinIcons",@"MinIcon",
                                                SET_STRING_V(pNameIcon,@"m_pNameTexture"));
                    
                    pObMinIcon->Start=&pObFirst->m_pCurPosition;
                    pObMinIcon->End=&pObSecond->m_pCurPosition;
                    [m_pChildrenbjectsMinIcon addObject:pObMinIcon];
//--------------------------------------------------------------------------------------------------
                }
                
                InfoArrayValue *InfoStrExitPar=(InfoArrayValue *)(*pHeart->pExPairPar);
                int *StartExitPar=(*pHeart->pExPairPar)+SIZE_INFO_STRUCT;
                
                for (int j=0; j<InfoStrExitPar->mCount; j++) {
                    
                    int iCurIndex=StartExitPar[j];
                    ObjectB_Ob *pObFirst=0;
                    
                    for (int k=0; k<[m_pChildrenbjectsArr count]; k++) {
                        ObjectB_Ob *pObTmp=[m_pChildrenbjectsArr objectAtIndex:k];
                        
                        if(iCurIndex==pObTmp->pString->m_iIndex)
                            pObFirst=pObTmp;
                        
                    }
                    if(pObFirst==nil)continue;
                    
                    ObjectB_Ob *pObSecond=[m_pChildrenbjectsArr objectAtIndex:i];
                    
                    Ob_Connectors *pObConn=UNFROZE_OBJECT(@"Ob_Connectors",@"Connectors",
                                            SET_STRING_V(@"LineWhite.png",@"m_pNameTexture"),
                                            SET_COLOR_V(Color3DMake(1, 0.5f, 0, 0.7f),@"mColor"));
                    
                    pObConn->Start=&pObFirst->m_pCurPosition;
                    pObConn->End=&pObSecond->m_pCurPosition;
                    [m_pChildrenbjectsArrConn addObject:pObConn];
//--------------------------------------------------------------------------------------------------
                    NSMutableString *pNameIcon=[NSMutableString stringWithString:@""];
                    if(pMatrChild->TypeInformation==STR_COMPLEX){
                        
                        for (int k=0; k<InfoChildString->mCount; k++) {
                            int iTmpIndex=StartChildString[k];
                            FractalString *pString=(FractalString *)[m_pObjMng->pStringContainer->ArrayPoints
                                                                     GetIdAtIndex:iTmpIndex];
                            
                            if(pString->m_iIndex==iCurIndex){
                                [pNameIcon setString:pString->sNameIcon];
                                break;
                            }
                        }
                    }
                    else
                    {
                        int CurretnOffset=j*2+2+InfoEnter->mCount*2;
                        int index=StartChild[CurretnOffset];
                        
                        NSMutableString *TmpStr=(NSMutableString *)[m_pObjMng->pStringContainer->ArrayPoints
                                                                    GetIdAtIndex:index];
                        
                        if(TmpStr!=nil)
                            [pNameIcon setString:TmpStr];
                    }

                    Ob_MinIcons *pObMinIcon=UNFROZE_OBJECT(@"Ob_MinIcons",@"MinIcon",
                                                SET_STRING_V(pNameIcon,@"m_pNameTexture"));
                    
                    pObMinIcon->Start=&pObFirst->m_pCurPosition;
                    pObMinIcon->End=&pObSecond->m_pCurPosition;
                    [m_pChildrenbjectsMinIcon addObject:pObMinIcon];
//--------------------------------------------------------------------------------------------------
                }
            }
        }
    }
    
    int **pArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:pInsideString->m_iIndex];
    if(pArray!=0){
        
        int *Data=(*pArray);
        InfoArrayValue *InfoStr=(InfoArrayValue *)(Data);
        
        int iCount=InfoStr->mCount;
        if(iCount>150)iCount=150;
        
        for(int i=0;i<iCount;i++){
            
            int index=(Data+SIZE_INFO_STRUCT)[i];
            
            if(InfoStr->mType==DATA_U_INT){
                [self CreateObArrayUI:index Index:i];
            }
            else {
                
                [self CreateObArray:index Index:i];
            }
        }
    }
    
//    m_fTimerCheckFlick-=DELTA;
    m_fTimerCheckFlick=-1;
    int itype=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:pInsideString->m_iIndex];
    if(m_fTimerCheckFlick<0 && itype==DATA_MATRIX)
    {
        //        for (int k=0; k<[m_pChildrenbjectsArr count]; k++) {
        //            ObjectB_Ob *pOb=[m_pChildrenbjectsArr objectAtIndex:k];
        //
        //            [pOb setUnFlick];
        //        }
        
        m_fTimerCheckFlick=1;
        bool bFlick=[self CheckFlick:pInsideString];
        
        if(bFlick==YES)
        {
            MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints
                               GetMatrixAtIndex:pInsideString->m_iIndex];
            
            int iPlace=*(*pMatr->ppStartPlaces+SIZE_INFO_STRUCT);
            if(iPlace!=-1)
            {
                int iCount=0;
                
                HeartMatr *pTmpHeart=(HeartMatr *)(*pMatr->pQueue+SIZE_INFO_STRUCT)[iPlace];
                
                InfoArrayValue *pInfoQueue=(InfoArrayValue*)*pMatr->pQueue;
                int iCurPlace=iPlace;
                
                while (iCurPlace!=-1 && iCount<pInfoQueue->mCount)
                {
                    iCount++;
                    
                    int iIndexTmp=(*pInsideString->pChildString+SIZE_INFO_STRUCT)[iCurPlace];
                    
                    for (int k=0; k<[m_pChildrenbjectsArr count]; k++) {
                        ObjectB_Ob *pOb=[m_pChildrenbjectsArr objectAtIndex:k];
                        
                        if(pOb->pString->m_iIndexSelf==iIndexTmp)
                        {
                            [pOb setFlick];
                            break;
                        }
                    }
                    
                    pTmpHeart=(HeartMatr *)(*pMatr->pQueue+SIZE_INFO_STRUCT)[iCurPlace];
                    iCurPlace=pTmpHeart->pNextPlace;
                }
            }
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetString:(FractalString *)Str{
    
    FractalString *pStr = Str;

    if(pStr!=nil)
        pInsideString=pStr;
    else
        pInsideString=[m_pObjMng->pStringContainer GetString:@"Objects"];

    [m_pObjMng->pMegaTree SetCell:LINK_ID_V(pInsideString,@"ParentString")];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

    mWidth=20;
    mHeight=20;

	[super Start];

    GET_TEXTURE(mTextureId, @"StartActivity.png");

    pInsideString = [m_pObjMng->pStringContainer GetString:@"Objects"];
    [m_pObjMng->pMegaTree SetCell:LINK_ID_V(pInsideString,@"ParentString")];

 //   [self UpdateButt];
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    for (ObjectB_Ob *pOb in m_pChildrenbjectsArr) {
        DESTROY_OBJECT(pOb);
    }
    [m_pChildrenbjectsArr removeAllObjects];

    for (Ob_Connectors *pOb in m_pChildrenbjectsArrConn) {
        DESTROY_OBJECT(pOb);
    }
    [m_pChildrenbjectsArrConn removeAllObjects];

    for (Ob_MinIcons *pOb in m_pChildrenbjectsMinIcon) {
        DESTROY_OBJECT(pOb);
    }
    [m_pChildrenbjectsMinIcon removeAllObjects];

    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
- (bool)CheckFlick:(FractalString *)pString{
    
    FractalString *pFparent=pString->pParent;
    
    if([pString->strUID isEqualToString:@"Objects"])
        return YES;
    
    MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:pFparent->m_iIndex];
    MATRIXcell *pMatrCur=[m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:pString->m_iIndex];

    if(pMatr==0)
    {
        return NO;
    }
    else
    {
        if(pMatrCur!=0)
        {
            int iPlace=*(*pMatrCur->ppStartPlaces+SIZE_INFO_STRUCT);
            if(iPlace==-1)
                    return NO;
            
            iPlace=*(*pMatr->ppStartPlaces+SIZE_INFO_STRUCT);
            
            if([self CheckFlick:pFparent]==YES)
            {
                int iCount=0;
                
                HeartMatr *pTmpHeart=(HeartMatr *)(*pMatr->pQueue+SIZE_INFO_STRUCT)[iPlace];
                InfoArrayValue *pInfoQueue=(InfoArrayValue*)*pMatr->pQueue;
                int iCurPlace=iPlace;
                
                while (iCurPlace!=-1 && iCount<pInfoQueue->mCount)
                {
                    iCount++;
                    
                    int iIndex=(*pFparent->pChildString+SIZE_INFO_STRUCT)[iCurPlace];
                    
                    if(pString->m_iIndexSelf==iIndex)
                        return YES;
                    
                    pTmpHeart=(HeartMatr *)(*pMatr->pQueue+SIZE_INFO_STRUCT)[iCurPlace];
                    iCurPlace=pTmpHeart->pNextPlace;
                }
            }
        }
    }
    
    return NO;
}
//------------------------------------------------------------------------------------------------------
- (void)SelfDrawOffset{

    Ob_Editor_Interface *Interface=(Ob_Editor_Interface *)
            [m_pObjMng GetObjectByName:@"Ob_Editor_Interface"];
    
    if(Interface!=nil && (Interface->m_iMode==M_MOVE || Interface->m_iMode==M_COPY ||
                          Interface->m_iMode==M_DEBUG || Interface->m_iMode==M_TRANSLATE ||
                          Interface->m_iMode==M_LINK || Interface->m_iMode==M_CONNECT
                          || Interface->m_iMode==M_EDIT_EN_EX))
    {
        MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints
                           GetMatrixAtIndex:pInsideString->m_iIndex];
        
        if(pMatr!=nil)
        {
            InfoArrayValue *pInfo = (InfoArrayValue *)*pMatr->ppStartPlaces;
            
            if(pInfo->mCount>0){

                for (int i=0; i<pInfo->mCount; i++) {
                    
                    glLoadIdentity();
                    glRotatef(m_pObjMng->fCurrentAngleRotateOffset, 0, 0, 1);

                    int *StartDataPlaces=*pMatr->ppStartPlaces+SIZE_INFO_STRUCT;
                    int Place=StartDataPlaces[i];
                    if(Place==-1)continue;
                    
                    int IndexString=*(*pInsideString->pChildString+SIZE_INFO_STRUCT+Place);
                                        
                    FractalString *pStr=[m_pObjMng->pStringContainer->ArrayPoints
                                         GetIdAtIndex:IndexString];
                    
                    m_pCurPosition.x=pStr->X-17;
                    m_pCurPosition.y=pStr->Y+17;
                    
                    [self SetColor:mColor];
                    
                    glVertexPointer(3, GL_FLOAT, 0, vertices);
                    glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
                    glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
                    
                    glBindTexture(GL_TEXTURE_2D, mTextureId);
                    
                    glTranslatef(m_pCurPosition.x+m_pObjMng->m_pParent->m_vOffset.x*m_fScaleOffset,
                                 m_pCurPosition.y+m_pObjMng->m_pParent->m_vOffset.y*m_fScaleOffset,
                                 m_pCurPosition.z);
                    
                    glRotatef(m_pCurAngle.z, 0, 0, 1);
                    glScalef(m_pCurScale.x,m_pCurScale.y,m_pCurScale.z);
                    
                    glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
                }
            }
            
            pInfo = (InfoArrayValue *)*pMatr->ppActivitySpace;
            
            if(pInfo->mCount>0){
                
                for (int i=0; i<pInfo->mCount; i++) {

                    glLoadIdentity();
                    glRotatef(m_pObjMng->fCurrentAngleRotateOffset, 0, 0, 1);
                    
                    int *StartDataPlaces=*pMatr->ppActivitySpace+SIZE_INFO_STRUCT;
                    int iIndexSpace=StartDataPlaces[i];
                    
                    if(iIndexSpace==-1)continue;
                    
                    int Place = [m_pObjMng->pStringContainer->m_OperationIndex
                                        FindIndex:iIndexSpace WithData:pMatr->pValueCopy];
                    
                    int IndexString=*(*pInsideString->pChildString+SIZE_INFO_STRUCT+Place);
                    
                    FractalString *pStr=[m_pObjMng->pStringContainer->ArrayPoints
                                         GetIdAtIndex:IndexString];
                    
                    m_pCurPosition.x=pStr->X-17;
                    m_pCurPosition.y=pStr->Y+17;
                    
                    [self SetColor:mColor];
                    
                    glVertexPointer(3, GL_FLOAT, 0, vertices);
                    glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
                    glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
                    
                    glBindTexture(GL_TEXTURE_2D, mTextureId);
                    
                    glTranslatef(m_pCurPosition.x+m_pObjMng->m_pParent->m_vOffset.x*m_fScaleOffset,
                                 m_pCurPosition.y+m_pObjMng->m_pParent->m_vOffset.y*m_fScaleOffset,
                                 m_pCurPosition.z);
                    
                    glRotatef(m_pCurAngle.z, 0, 0, 1);
                    glScalef(m_pCurScale.x,m_pCurScale.y,m_pCurScale.z);
                    
                    glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
                }
            }
        }
        else
        {
            int **ppArray=[m_pObjMng->pStringContainer->ArrayPoints
                               GetArrayAtIndex:pInsideString->m_iIndex];
            
            if(ppArray!=nil)
            {
                InfoArrayValue *pInfoTmp=(InfoArrayValue*)*ppArray;
                
                if(pInfoTmp->mCount!=[m_pChildrenbjectsArr count])
                    [self UpdateButt];
            }
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc
{
    [m_pChildrenbjectsMinIcon release];
    [m_pChildrenbjectsArrConn release];
    [super dealloc];
}
@end