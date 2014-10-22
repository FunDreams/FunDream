//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_SelectionPar.h"
#import "Ob_Editor_Interface.h"
#import "OB_StaticStringInfo.h"

@implementation Ob_SelectionPar
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerTemplet;
        m_iLayerTouch=layerTouch_0;//слой касания
        
        pArrayEnter = [[NSMutableArray alloc] init];
        pArrayExit = [[NSMutableArray alloc] init];
        pArrayMode = [[NSMutableArray alloc] init];
        pArrayIcons = [[NSMutableArray alloc] init];

        pArrayEnterIcon = [[NSMutableArray alloc] init];
        pArrayExitIcon = [[NSMutableArray alloc] init];

        pArrayEnterUse = [[NSMutableArray alloc] init];
        pArrayExitUse = [[NSMutableArray alloc] init];

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
//    Processor_ex* pProc = [self START_QUEUE:@"Proc"];
//  //      ASSIGN_STAGE(@"IDLE",@"Idle:",nil);
//        ASSIGN_STAGE(@"PROC",@"Proc:",nil);
//    [self END_QUEUE:pProc name:@"Proc"];
    
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
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateTmp{
    [self ClearInterface];
    
  //  if(iModeSelParams==0){
        pObBtnClose=UNFROZE_OBJECT(@"ObjectButton",@"ButtonClose",
                                   SET_STRING_V(@"Close.png",@"m_DOWN"),
                                   SET_STRING_V(@"Close.png",@"m_UP"),
                                   SET_FLOAT_V(64,@"mWidth"),
                                   SET_FLOAT_V(64,@"mHeight"),
                                   SET_BOOL_V(YES,@"m_bLookTouch"),
                                   SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                                   SET_INT_V(layerTouch_2N,@"m_iLayerTouch"),
                                   SET_STRING_V(NAME(self),@"m_strNameObject"),
                                   SET_STRING_V(@"Close",@"m_strNameStage"),
                                   SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                                   SET_VECTOR_V(Vector3DMake(-40,330,0),@"m_pCurPosition"));
        
        IconEnters=UNFROZE_OBJECT(@"StaticObject",@"Enter",
                                  SET_STRING_V(@"In.png",@"m_pNameTexture"),
                                  SET_FLOAT_V(64,@"mWidth"),
                                  SET_FLOAT_V(64,@"mHeight"),
                                  SET_VECTOR_V(Vector3DMake(-390,230,0),@"m_pCurPosition"),
                                  SET_INT_V(layerInterfaceSpace6,@"m_iLayer"));
        
        IconExits=UNFROZE_OBJECT(@"StaticObject",@"Exit",
                                 SET_STRING_V(@"Out.png",@"m_pNameTexture"),
                                 SET_FLOAT_V(64,@"mWidth"),
                                 SET_FLOAT_V(64,@"mHeight"),
                                 SET_VECTOR_V(Vector3DMake(-130,230,0),@"m_pCurPosition"),
                                 SET_INT_V(layerInterfaceSpace6,@"m_iLayer"));

        Line=UNFROZE_OBJECT(@"StaticObject",@"Sl5",
                            SET_STRING_V(@"Line.png",@"m_pNameTexture"),
                            SET_FLOAT_V(669,@"mWidth"),
                            SET_FLOAT_V(5,@"mHeight"),
                            SET_VECTOR_V(Vector3DMake(-256,-49.9,0),@"m_pCurPosition"),
                            SET_VECTOR_V(Vector3DMake(0,0,90),@"m_pCurAngle"),
                            SET_INT_V(layerInterfaceSpace6,@"m_iLayer"));

        [self SetParams];
//    }
//    else if(iModeSelParams==1){
//        pObBtnClose=UNFROZE_OBJECT(@"ObjectButton",@"ButtonClose",
//                                   SET_STRING_V(@"Close.png",@"m_DOWN"),
//                                   SET_STRING_V(@"Close.png",@"m_UP"),
//                                   SET_FLOAT_V(64,@"mWidth"),
//                                   SET_FLOAT_V(64,@"mHeight"),
//                                   SET_BOOL_V(YES,@"m_bLookTouch"),
//                                   SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
//                                   SET_INT_V(layerTouch_2N,@"m_iLayerTouch"),
//                                   SET_STRING_V(NAME(self),@"m_strNameObject"),
//                                   SET_STRING_V(@"CloseMode",@"m_strNameStage"),
//                                   SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
//                                   SET_VECTOR_V(Vector3DMake(-40,330,0),@"m_pCurPosition"));
//        
//        [self SetButtonMode];
//    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetButtonMode{
    
    InfoArrayValue *pValueCopyInfo=(InfoArrayValue *)(*pMatr->pValueCopy);
    
    if(pMatr->TypeInformation==STR_OPERATION && pValueCopyInfo->mCount>2)
    {//инициализируем режимы
        int iIndexMatrMode= *((*pMatr->pValueCopy)+SIZE_INFO_STRUCT);
        MATRIXcell *pMatrMode = [m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:iIndexMatrMode];
        InfoArrayValue *pInfoMode=(InfoArrayValue *)(*pMatrMode->pValueCopy);
        
        if(pInfoMode->mCount>0){
            
       //     for (int i=0; i<pInfoMode->mCount; i++) {
                
                int iIndexArray=*(*pMatrMode->pValueCopy+SIZE_INFO_STRUCT+iCurMode);
                int **ppArray = [m_pObjMng->pStringContainer->ArrayPoints
                                 GetArrayAtIndex:iIndexArray];
                InfoArrayValue *pInfoArray=(InfoArrayValue *)(*ppArray);

                for (int j=0; j<pInfoArray->mCount; j++) {
                    
                    int iIndexIcon=*(*ppArray+SIZE_INFO_STRUCT+j);
                    NSMutableString *pNameIcon = [m_pObjMng->pStringContainer->ArrayPoints
                                                  GetIdAtIndex:iIndexIcon];
                    
                    float X=-480+j*50;
                    float Y=250;
                    
                    GObject *pOb = UNFROZE_OBJECT(@"ObjectButton",@"Button",
                                                  SET_BOOL_V(NO,@"m_Disable"),
                                                  SET_INT_V(j,@"m_iNum"),
                                                  SET_INT_V(bSimple,@"m_iType"),
                                                  SET_STRING_V(pNameIcon,@"m_DOWN"),
                                                  SET_BOOL_V(NO,@"m_bBack"),
                                                  SET_STRING_V(pNameIcon,@"m_UP"),
                                                  SET_FLOAT_V(44,@"mWidth"),
                                                  SET_FLOAT_V(44,@"mHeight"),
                                                  SET_BOOL_V(YES,@"m_bLookTouch"),
                                                  SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                                                  SET_STRING_V(NAME(self),@"m_strNameObject"),
                                                  SET_STRING_V(@"ClickIcon",@"m_strNameStage"),
                                                  SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                                                  SET_VECTOR_V(Vector3DMake(X,Y,0),@"m_pCurPosition"));
                    
                    [pArrayIcons addObject:pOb];
                }
        //    }
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (Color3D)GetColor:(int)iIndex{
    
    Color3D mColorBack=Color3DMake(1,1,1,1);
    int iType=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:iIndex];
    
    switch (iType)
    {
        case DATA_ARRAY:
        {
            int **ppArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:iIndex];
            if(ppArray==0)return mColorBack;
            InfoArrayValue *pInfo=(InfoArrayValue *)(*ppArray);
            switch (pInfo->mType) {
                case DATA_SPRITE:
                    mColorBack = Color3DMake(1,0,0,1);
                    break;
                    
                case DATA_TEXTURE:
                    mColorBack = Color3DMake(1,1,1,1);
                    break;
                    
                case DATA_SOUND:
                    mColorBack = Color3DMake(0,1,1,1);
                    break;
                    
                case DATA_FLOAT:
                    mColorBack = Color3DMake(0,0,1,1);
                    break;
                case DATA_INT:
                    mColorBack = Color3DMake(1,1,0,1);
                    break;
                case DATA_U_INT:
                    mColorBack = Color3DMake(1,0.5f,0,1);
                    break;
                    
                default:
                    break;
            }
        }
        break;
    }

    return mColorBack;
}
//------------------------------------------------------------------------------------------------------
- (void)SetParams{
    
    int **ppArray=[m_pObjMng->pStringContainer->ArrayPoints
                   GetArrayAtIndex:m_iIndexStart];
    
    InfoArrayValue *pInfo=(InfoArrayValue *)(*ppArray);
    int iType=pInfo->mType;
    
    InfoArrayValue *InfoChildString=(InfoArrayValue *)*pConnString->pChildString;
    int *StartChildString=*pConnString->pChildString+SIZE_INFO_STRUCT;

 //   InfoArrayValue *InfoChild=(InfoArrayValue *)*pMatr->pValueCopy;
    int *StartChild=*pMatr->pValueCopy+SIZE_INFO_STRUCT;

    InfoArrayValue *InfoEnter=(InfoArrayValue *)*pMatr->pEnters;
    int *StartEnter=*pMatr->pEnters+SIZE_INFO_STRUCT;
    InfoArrayValue *InfoExit=(InfoArrayValue *)*pMatr->pExits;
    int *StartExit=*pMatr->pExits+SIZE_INFO_STRUCT;
    
    int **ArrayStart=[m_pObjMng->pStringContainer->ArrayPoints
                      GetArrayAtIndex:m_iIndexStart];
    
    InfoArrayValue *pInfoStart=(InfoArrayValue *)*ArrayStart;

    for (int i=0;i<InfoEnter->mCount;i++) {
        int iIndex=StartEnter[i];
        
        NSMutableString *pNameIcon=[NSMutableString stringWithString:@""];
        if(pMatr->TypeInformation==STR_COMPLEX){
            
            for (int j=0; j<InfoChildString->mCount; j++) {
                int iTmpIndex=StartChildString[j];
                FractalString *pString=(FractalString *)[m_pObjMng->pStringContainer->ArrayPoints
                                                GetIdAtIndex:iTmpIndex];
                
                if(pString->m_iIndex==iIndex){
                    [pNameIcon setString:pString->sNameIcon];
                    break;
                }
            }
        }
        else
        {
            int CurretnOffset=i*2+4+1;
            int index=StartChild[CurretnOffset];
            
            NSMutableString *TmpStr=(NSMutableString *)[m_pObjMng->pStringContainer->ArrayPoints
                                                        GetIdAtIndex:index];
            
            [pNameIcon setString:TmpStr];
        }
        
        float X,Y;
        
        X=-470+(i%4)*54;
        Y=70-(i/4)*100;
        
        bool bBack=NO;
        
        int *StartPairPar=*EndHeart->pEnPairPar+SIZE_INFO_STRUCT;
        int *StartPairChild=*EndHeart->pEnPairChi+SIZE_INFO_STRUCT;

        int iIndexPairPar=StartPairPar[i];
        int iIndexPairChi=StartPairChild[i];
        
        if(iIndexPairPar!=iIndexPairChi)bBack=YES;
        
        int **ppArrayTmp=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:iIndex];
        
        InfoArrayValue *pInfoLink=(InfoArrayValue *)(*ppArrayTmp);
        int iTypeLink=pInfoLink->mType;

        bool m_Disable=false;
        
        if(pMatr->TypeInformation==STR_OPERATION)
        {
            if(iType==DATA_U_INT)
            {
                //проверяем на связку пары  параметр/объект
                int iIndexMatrLink=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[2];
                MATRIXcell *pMatrLink=[m_pObjMng->pStringContainer->ArrayPoints
                                       GetMatrixAtIndex:iIndexMatrLink];
                
                int iIndexMatrLink2=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[3];
                MATRIXcell *pMatrLink2=[m_pObjMng->pStringContainer->ArrayPoints
                                        GetMatrixAtIndex:iIndexMatrLink2];
                
                InfoArrayValue *pInfoTmpLink=(InfoArrayValue *)*pMatrLink->pValueCopy;
                
                for (int k=0; k<pInfoTmpLink->mCount; k++)
                {
                    int iIndexArrayLink=(*pMatrLink->pValueCopy+SIZE_INFO_STRUCT)[k];
                    int **ArrayLink=[m_pObjMng->pStringContainer->ArrayPoints
                                     GetArrayAtIndex:iIndexArrayLink];
                    
                    InfoArrayValue *pInfoTmpLinkInside=(InfoArrayValue *)*ArrayLink;
                    
                    int iRez=[m_pObjMng->pStringContainer->m_OperationIndex
                              FindIndex:i WithData:ArrayLink];
                    
                    if(iRez!=-1)
                    {
                        bool bNeedDis=YES;
                        bool bOnlyUint=YES;
                        for (int m=0; m<pInfoTmpLinkInside->mCount; m++)
                        {
                            int iIndSecond=(*ArrayLink+SIZE_INFO_STRUCT)[m];
                            int iIndexNeed=(*EndHeart->pEnPairPar+SIZE_INFO_STRUCT)[iIndSecond];
                            
                            int **ArrayLinkInside=[m_pObjMng->pStringContainer->ArrayPoints
                                                   GetArrayAtIndex:iIndexNeed];
                            InfoArrayValue *pCurInfoArray=(InfoArrayValue *)*ArrayLinkInside;
                            if(pCurInfoArray->mType!=DATA_U_INT)
                                bOnlyUint=NO;
                            
                            if(iIndexNeed>RESERV_KERNEL && pCurInfoArray->mType!=DATA_U_INT)
                            {
                                bNeedDis=NO;
                                break;
                            }
                        }
                        
                        int iIndexArrayLink=(*pMatrLink2->pValueCopy+SIZE_INFO_STRUCT)[k];
                        int **ArrayLink2=[m_pObjMng->pStringContainer->ArrayPoints
                                          GetArrayAtIndex:iIndexArrayLink];
                        InfoArrayValue *pInfoTmpLinkInside2=(InfoArrayValue *)*ArrayLink2;

                        for (int m=0; m<pInfoTmpLinkInside2->mCount; m++)
                        {
                            int iIndSecond=(*ArrayLink2+SIZE_INFO_STRUCT)[m];
                            int iIndexNeed=(*EndHeart->pExPairPar+SIZE_INFO_STRUCT)[iIndSecond];

                            int **ArrayLinkInside=[m_pObjMng->pStringContainer->ArrayPoints
                                                   GetArrayAtIndex:iIndexNeed];
                            InfoArrayValue *pCurInfoArray=(InfoArrayValue *)*ArrayLinkInside;
                            
                            if(pCurInfoArray->mType!=DATA_U_INT)
                                bOnlyUint=NO;

                            if(iIndexNeed>RESERV_KERNEL && pCurInfoArray->mType!=DATA_U_INT)
                            {
                                bNeedDis=NO;
                                break;
                            }
                        }

                        if(bNeedDis==YES && bOnlyUint==NO)
                            m_Disable=YES;
                        goto good;
                    }
                }
            }
good:
//            if(iTypeLink==DATA_P_MATR)
//            {
//                //проверяем индекс пару жёстко связаную. Типы должны быть одинаковые
//                int iIndexArrayLink=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[1];
//                int **ArrayLink=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:iIndexArrayLink];
//                
//                int iRez=[m_pObjMng->pStringContainer->m_OperationIndex
//                          FindIndex:i WithData:ArrayLink];
//                
//                if(iRez!=-1)
//                {
//                    //находим второй индекс пару
//                    int iIndSecond=0;
//                    if(iRez%2==0)
//                        iIndSecond=(*ArrayLink+SIZE_INFO_STRUCT)[iRez+1];
//                    else iIndSecond=(*ArrayLink+SIZE_INFO_STRUCT)[iRez-1];
//                    
//                    int iIndexNeed=(*EndHeart->pExPairPar+SIZE_INFO_STRUCT)[iIndSecond];
//                    
//                    if(iIndexNeed>RESERV_KERNEL)
//                    {
//                        int **ArrayLink=[m_pObjMng->pStringContainer->ArrayPoints
//                                         GetArrayAtIndex:iIndexNeed];
//                        
//                        InfoArrayValue *pInfoTmpValue=(InfoArrayValue *)*ArrayLink;
//                        
//                        if(pInfoTmpValue->mType!=pInfoStart->mType)
//                        {
//                            if((pInfoTmpValue->mType==DATA_INT && pInfoStart->mType==DATA_FLOAT) ||
//                               (pInfoTmpValue->mType==DATA_FLOAT && pInfoStart->mType==DATA_INT)){}
//                            else m_Disable=YES;
//                        }
//                    }
//                    
//                    iIndexNeed=(*EndHeart->pEnPairPar+SIZE_INFO_STRUCT)[iIndSecond];
//                    
//                    if(iIndexNeed>RESERV_KERNEL)
//                    {
//                        int **ArrayLink=[m_pObjMng->pStringContainer->ArrayPoints
//                                         GetArrayAtIndex:iIndexNeed];
//                        
//                        InfoArrayValue *pInfoTmpValue=(InfoArrayValue *)*ArrayLink;
//                        
//                        if(pInfoTmpValue->mType!=pInfoStart->mType)
//                        {
//                            if((pInfoTmpValue->mType==DATA_INT && pInfoStart->mType==DATA_FLOAT) ||
//                               (pInfoTmpValue->mType==DATA_FLOAT && pInfoStart->mType==DATA_INT)){}
//                            else m_Disable=YES;
//                        }
//                    }
//                }
//                
//                if(/*pInfo->UnParentMatrix.indexMatrix==0 || */iType==DATA_U_INT)
//                    m_Disable=YES;
//            }
//            else
            if(iType!=iTypeLink)
            {
                if((iType==DATA_INT && iTypeLink==DATA_FLOAT)
                   || (iType==DATA_FLOAT && iTypeLink==DATA_INT)){}
                else m_Disable=YES;
            }
            
            //проверяем на связку пары  параметр/объект
            int iIndexMatrLink=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[2];
            MATRIXcell *pMatrLink=[m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:iIndexMatrLink];
            int iIndexMatrLink2=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[3];
            MATRIXcell *pMatrLink2=[m_pObjMng->pStringContainer->ArrayPoints
                                    GetMatrixAtIndex:iIndexMatrLink2];
            
            InfoArrayValue *pInfoTmpLink=(InfoArrayValue *)*pMatrLink->pValueCopy;

            for (int k=0; k<pInfoTmpLink->mCount; k++) {
                int iIndexArrayLink=(*pMatrLink->pValueCopy+SIZE_INFO_STRUCT)[k];
                int **ArrayLink=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:iIndexArrayLink];
                InfoArrayValue *pInfoTmpLinkInside=(InfoArrayValue *)*ArrayLink;
                
                int iRez=[m_pObjMng->pStringContainer->m_OperationIndex
                          FindIndex:i WithData:ArrayLink];
                
                if(iRez!=-1)
                {
                    for (int m=0; m<pInfoTmpLinkInside->mCount; m++)
                    {
                        int iIndSecond=(*ArrayLink+SIZE_INFO_STRUCT)[m];
                 //       if(iIndSecond==i)continue;
                        
                        int iIndexNeed=(*EndHeart->pEnPairPar+SIZE_INFO_STRUCT)[iIndSecond];
                        
                        if(iIndexNeed>RESERV_KERNEL)
                        {
                            int **ArrayLink=[m_pObjMng->pStringContainer->ArrayPoints
                                             GetArrayAtIndex:iIndexNeed];
                            
                            InfoArrayValue *pInfoTmpValue=(InfoArrayValue *)*ArrayLink;
                            
                            if(pInfoTmpValue->UnParentMatrix.indexMatrix!=
                               pInfoStart->UnParentMatrix.indexMatrix)
                            {
                                m_Disable=YES;
                                goto exit1;
                            }
                        }
                    }
                    
                    int iIndexArrayLink=(*pMatrLink2->pValueCopy+SIZE_INFO_STRUCT)[k];
                    int **ArrayLink2=[m_pObjMng->pStringContainer->ArrayPoints
                                      GetArrayAtIndex:iIndexArrayLink];
                    InfoArrayValue *pInfoTmpLinkInside2=(InfoArrayValue *)*ArrayLink2;

                    for (int m=0; m<pInfoTmpLinkInside2->mCount; m++)
                    {
                        int iIndSecond=(*ArrayLink2+SIZE_INFO_STRUCT)[m];
                     //   if(iIndSecond==i)continue;
                        
                        int iIndexNeed=(*EndHeart->pExPairPar+SIZE_INFO_STRUCT)[iIndSecond];
                        
                        if(iIndexNeed>RESERV_KERNEL)
                        {
                            int **ArrayLink=[m_pObjMng->pStringContainer->ArrayPoints
                                             GetArrayAtIndex:iIndexNeed];
                            
                            InfoArrayValue *pInfoTmpValue=(InfoArrayValue *)*ArrayLink;
                            
                            if(pInfoTmpValue->UnParentMatrix.indexMatrix!=
                               pInfoStart->UnParentMatrix.indexMatrix)
                            {
                                m_Disable=YES;
                                goto exit1;
                            }
                        }
                    }
                }
            }
        }
        else
        {
            
        }
        
exit1:

        Color3D TmpColor=[self GetColor:iIndexPairChi];
        GObject *pOb = UNFROZE_OBJECT(@"ObjectButton",@"Button",
                                      SET_COLOR_V(TmpColor,@"mColorBack"),
                                     SET_BOOL_V(m_Disable,@"m_Disable"),
                                     SET_INT_V(i,@"m_iNum"),
                                     SET_INT_V(bSimple,@"m_iType"),
                                     SET_STRING_V(pNameIcon,@"m_DOWN"),
                                     SET_STRING_V(pNameIcon,@"m_UP"),
                                     SET_BOOL_V(YES,@"m_bBack"),
                                     SET_FLOAT_V(44,@"mWidth"),
                                     SET_FLOAT_V(44,@"mHeight"),
                                     SET_BOOL_V(YES,@"m_bLookTouch"),
                                     SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                                     SET_STRING_V(NAME(self),@"m_strNameObject"),
                                     SET_STRING_V(@"SetPairEnter",@"m_strNameStage"),
                                     SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                                     SET_VECTOR_V(Vector3DMake(X,Y,0),@"m_pCurPosition"));

        [pArrayEnter addObject:pOb];
        
        
        int iIndexMatrixTmp=-1;
        int **pArrayChild=pConnString->pParent->pChildString;
        InfoArrayValue *pInfoTmp=(InfoArrayValue *)*pArrayChild;
        
        for (int j=0; j<pInfoTmp->mCount; j++) {
            int iIndexFString=(*pArrayChild+SIZE_INFO_STRUCT)[j];
            FractalString *Fstr=[m_pObjMng->pStringContainer->ArrayPoints GetIdAtIndex:iIndexFString];
            
            if(Fstr->m_iIndex==iIndexPairPar)
            {
                iIndexMatrixTmp=Fstr->m_iIndexSelf;
                break;
            }
        }
        
        pOb = UNFROZE_OBJECT(@"OB_StaticStringInfo",@"StaticStringInfo",
                             SET_INT_V(iIndexMatrixTmp,@"iIndexString"),
                             SET_VECTOR_V(Vector3DMake(X,Y+50,0),@"m_pCurPosition"));
        [pArrayEnterIcon addObject:pOb];
    }

    for (int i=0;i<InfoExit->mCount;i++){
        int iIndex=StartExit[i];
        
        NSMutableString *pNameIcon=[NSMutableString stringWithString:@""];
        if(pMatr->TypeInformation==STR_COMPLEX){
            
            for (int j=0; j<InfoChildString->mCount; j++) {
                int iTmpIndex=StartChildString[j];
                FractalString *pString=(FractalString *)[m_pObjMng->pStringContainer->ArrayPoints
                                                         GetIdAtIndex:iTmpIndex];

                if(pString->m_iIndex==iIndex){
                    [pNameIcon setString:pString->sNameIcon];
                    break;
                }
            }
        }
        else
        {
            int CurretnOffset=i*2+4+1+InfoEnter->mCount*2;
            int index=StartChild[CurretnOffset];
            
            NSMutableString *TmpStr=(NSMutableString *)[m_pObjMng->pStringContainer->ArrayPoints
                                                        GetIdAtIndex:index];
            
            [pNameIcon setString:TmpStr];
        }

        float X,Y;
        
        X=-210+(i%4)*54;
        Y=70-(i/4)*120;

        bool bBack=NO;
        
//        InfoArrayValue *InfoPairChild=(InfoArrayValue *)*EndHeart->pExPairChi;
//        int *StartPairChild=*EndHeart->pExPairChi+SIZE_INFO_STRUCT;
//        
//        for (int k=0; k<InfoPairChild->mCount; k++) {
//            int iIndexPair=StartPairChild[k];
//            
//            if(iIndex==iIndexPair)
//                bBack=YES;
//        }
        
        int *StartPairPar=*EndHeart->pExPairPar+SIZE_INFO_STRUCT;
        int *StartPairChild=*EndHeart->pExPairChi+SIZE_INFO_STRUCT;

        int iIndexPairPar=StartPairPar[i];
        int iIndexPairChi=StartPairChild[i];
        
        if(iIndexPairPar!=iIndexPairChi)
            bBack=YES;
        
        int **ppArrayTmp=[m_pObjMng->pStringContainer->ArrayPoints
                          GetArrayAtIndex:iIndex];
        
        InfoArrayValue *pInfoLink=(InfoArrayValue *)(*ppArrayTmp);
        int iTypeLink=pInfoLink->mType;
        
        bool m_Disable=false;
        
        if(pMatr->TypeInformation==STR_OPERATION)
        {
            if(iType==DATA_U_INT)
            {
                //проверяем на связку пары  параметр/объект
                int iIndexMatrLink=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[3];
                MATRIXcell *pMatrLink=[m_pObjMng->pStringContainer->ArrayPoints
                                       GetMatrixAtIndex:iIndexMatrLink];
                
                int iIndexMatrLink2=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[2];
                MATRIXcell *pMatrLink2=[m_pObjMng->pStringContainer->ArrayPoints
                                        GetMatrixAtIndex:iIndexMatrLink2];
                
                InfoArrayValue *pInfoTmpLink=(InfoArrayValue *)*pMatrLink->pValueCopy;
                
                for (int k=0; k<pInfoTmpLink->mCount; k++)
                {
                    int iIndexArrayLink=(*pMatrLink->pValueCopy+SIZE_INFO_STRUCT)[k];
                    int **ArrayLink=[m_pObjMng->pStringContainer->ArrayPoints
                                     GetArrayAtIndex:iIndexArrayLink];
                    
                    InfoArrayValue *pInfoTmpLinkInside=(InfoArrayValue *)*ArrayLink;
                    
                    int iRez=[m_pObjMng->pStringContainer->m_OperationIndex
                              FindIndex:i WithData:ArrayLink];
                    
                    if(iRez!=-1)
                    {
                        bool bNeedDis=YES;
                        bool bOnlyUint=YES;
                        for (int m=0; m<pInfoTmpLinkInside->mCount; m++)
                        {
                            int iIndSecond=(*ArrayLink+SIZE_INFO_STRUCT)[m];
                            int iIndexNeed=(*EndHeart->pExPairPar+SIZE_INFO_STRUCT)[iIndSecond];
                            
                            int **ArrayLinkInside=[m_pObjMng->pStringContainer->ArrayPoints
                                             GetArrayAtIndex:iIndexNeed];
                            InfoArrayValue *pCurInfoArray=(InfoArrayValue *)*ArrayLinkInside;
                            
                            if(pCurInfoArray->mType!=DATA_U_INT)
                                bOnlyUint=NO;

                            if(iIndexNeed>RESERV_KERNEL && pCurInfoArray->mType!=DATA_U_INT)
                            {
                                bNeedDis=NO;
                                break;
                            }
                        }
                        
                        int iIndexArrayLink=(*pMatrLink2->pValueCopy+SIZE_INFO_STRUCT)[k];
                        int **ArrayLink2=[m_pObjMng->pStringContainer->ArrayPoints
                                          GetArrayAtIndex:iIndexArrayLink];
                        InfoArrayValue *pInfoTmpLinkInside2=(InfoArrayValue *)*ArrayLink2;
                        
                        for (int m=0; m<pInfoTmpLinkInside2->mCount; m++)
                        {
                            int iIndSecond=(*ArrayLink2+SIZE_INFO_STRUCT)[m];
                            int iIndexNeed=(*EndHeart->pEnPairPar+SIZE_INFO_STRUCT)[iIndSecond];
                            
                            int **ArrayLinkInside=[m_pObjMng->pStringContainer->ArrayPoints
                                                   GetArrayAtIndex:iIndexNeed];
                            InfoArrayValue *pCurInfoArray=(InfoArrayValue *)*ArrayLinkInside;

                            if(pCurInfoArray->mType!=DATA_U_INT)
                                bOnlyUint=NO;

                            if(iIndexNeed>RESERV_KERNEL && pCurInfoArray->mType!=DATA_U_INT)
                            {
                                bNeedDis=NO;
                                break;
                            }
                        }
                        
                        if(bNeedDis==YES && bOnlyUint==NO)
                            m_Disable=YES;
                        goto good1;
                    }
                }
            }
good1:

//            if(iTypeLink==DATA_P_MATR)
//            {
//                //проверяем индекс пару жёстко связаную. Типы должны быть одинаковые
//                int iIndexArrayLink=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[1];
//                int **ArrayLink=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:iIndexArrayLink];
//                
//                int iRez=[m_pObjMng->pStringContainer->m_OperationIndex
//                          FindIndex:i WithData:ArrayLink];
//                
//                if(iRez!=-1)
//                {
//                    //находим второй индекс пару
//                    int iIndSecond=0;
//                    if(iRez%2==0)
//                        iIndSecond=(*ArrayLink+SIZE_INFO_STRUCT)[iRez+1];
//                    else iIndSecond=(*ArrayLink+SIZE_INFO_STRUCT)[iRez-1];
//                    
//                    int iIndexNeed=(*EndHeart->pEnPairPar+SIZE_INFO_STRUCT)[iIndSecond];
//                    if(iIndexNeed>RESERV_KERNEL)
//                    {
//                        int **ArrayLink=[m_pObjMng->pStringContainer->ArrayPoints
//                                         GetArrayAtIndex:iIndexNeed];
//                        
//                        InfoArrayValue *pInfoTmpValue=(InfoArrayValue *)*ArrayLink;
//                        
//                        if(pInfoTmpValue->mType!=pInfoStart->mType)
//                        {
//                            if((pInfoTmpValue->mType==DATA_INT && pInfoStart->mType==DATA_FLOAT) ||
//                               (pInfoTmpValue->mType==DATA_FLOAT && pInfoStart->mType==DATA_INT)){}
//                            else m_Disable=YES;
//                        }
//                    }
//                    
//                    iIndexNeed=(*EndHeart->pExPairPar+SIZE_INFO_STRUCT)[iIndSecond];
//                    
//                    if(iIndexNeed>RESERV_KERNEL)
//                    {
//                        int **ArrayLink=[m_pObjMng->pStringContainer->ArrayPoints
//                                         GetArrayAtIndex:iIndexNeed];
//                        
//                        InfoArrayValue *pInfoTmpValue=(InfoArrayValue *)*ArrayLink;
//                        
//                        if(pInfoTmpValue->mType!=pInfoStart->mType)
//                        {
//                            if((pInfoTmpValue->mType==DATA_INT && pInfoStart->mType==DATA_FLOAT) ||
//                               (pInfoTmpValue->mType==DATA_FLOAT && pInfoStart->mType==DATA_INT)){}
//                            else m_Disable=YES;
//                        }
//                    }
//                }
//                
//                if(/*pInfo->UnParentMatrix.indexMatrix==0 || */iType==DATA_U_INT)
//                    m_Disable=YES;
//            }
//            else
            if(iType!=iTypeLink)
            {
                if((iType==DATA_INT && iTypeLink==DATA_FLOAT) ||
                   (iType==DATA_FLOAT && iTypeLink==DATA_INT)){}
                else m_Disable=YES;
            }
            
            //проверяем на связку пары  параметр/объект
            int iIndexMatrLink=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[3];
            MATRIXcell *pMatrLink=[m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:iIndexMatrLink];
            int iIndexMatrLink2=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[2];
            MATRIXcell *pMatrLink2=[m_pObjMng->pStringContainer->ArrayPoints
                                    GetMatrixAtIndex:iIndexMatrLink2];
            
            InfoArrayValue *pInfoTmpLink=(InfoArrayValue *)*pMatrLink->pValueCopy;
            
            for (int k=0; k<pInfoTmpLink->mCount; k++)
            {
                int iIndexArrayLink=(*pMatrLink->pValueCopy+SIZE_INFO_STRUCT)[k];
                int **ArrayLink=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:iIndexArrayLink];
                InfoArrayValue *pInfoTmpLinkInside=(InfoArrayValue *)*ArrayLink;
                
                int iRez=[m_pObjMng->pStringContainer->m_OperationIndex
                          FindIndex:i WithData:ArrayLink];
                
                if(iRez!=-1)
                {
                    for (int m=0; m<pInfoTmpLinkInside->mCount; m++)
                    {
                        int iIndSecond=(*ArrayLink+SIZE_INFO_STRUCT)[m];
                        //       if(iIndSecond==i)continue;
                        
                        int iIndexNeed=(*EndHeart->pExPairPar+SIZE_INFO_STRUCT)[iIndSecond];
                        
                        if(iIndexNeed>RESERV_KERNEL)
                        {
                            int **ArrayLink=[m_pObjMng->pStringContainer->ArrayPoints
                                             GetArrayAtIndex:iIndexNeed];
                            
                            InfoArrayValue *pInfoTmpValue=(InfoArrayValue *)*ArrayLink;
                            
                            if(pInfoTmpValue->UnParentMatrix.indexMatrix!=
                               pInfoStart->UnParentMatrix.indexMatrix)
                            {
                                m_Disable=YES;
                                goto exit2;
                            }
                        }
                    }
                    
                    int iIndexArrayLink=(*pMatrLink2->pValueCopy+SIZE_INFO_STRUCT)[k];
                    int **ArrayLink2=[m_pObjMng->pStringContainer->ArrayPoints
                                      GetArrayAtIndex:iIndexArrayLink];
                    InfoArrayValue *pInfoTmpLinkInside2=(InfoArrayValue *)*ArrayLink2;
                    
                    for (int m=0; m<pInfoTmpLinkInside2->mCount; m++)
                    {
                        int iIndSecond=(*ArrayLink2+SIZE_INFO_STRUCT)[m];
                        //   if(iIndSecond==i)continue;
                        
                        int iIndexNeed=(*EndHeart->pEnPairPar+SIZE_INFO_STRUCT)[iIndSecond];
                        
                        if(iIndexNeed>RESERV_KERNEL)
                        {
                            int **ArrayLink=[m_pObjMng->pStringContainer->ArrayPoints
                                             GetArrayAtIndex:iIndexNeed];
                            
                            InfoArrayValue *pInfoTmpValue=(InfoArrayValue *)*ArrayLink;
                            
                            if(pInfoTmpValue->UnParentMatrix.indexMatrix!=
                               pInfoStart->UnParentMatrix.indexMatrix)
                            {
                                m_Disable=YES;
                                goto exit2;
                            }
                        }
                    }
                }
            }
        }

exit2:

        Color3D TmpColor=[self GetColor:iIndexPairChi];
        GObject *pOb = UNFROZE_OBJECT(@"ObjectButton",@"Button",
                                      SET_COLOR_V(TmpColor,@"mColorBack"),
                                      SET_BOOL_V(m_Disable,@"m_Disable"),
                                     SET_INT_V(i,@"m_iNum"),
                                     SET_INT_V(bSimple,@"m_iType"),
                                     SET_STRING_V(pNameIcon,@"m_DOWN"),
                                     SET_BOOL_V(YES,@"m_bBack"),
                                     SET_STRING_V(pNameIcon,@"m_UP"),
                                     SET_FLOAT_V(44,@"mWidth"),
                                     SET_FLOAT_V(44,@"mHeight"),
                                     SET_BOOL_V(YES,@"m_bLookTouch"),
                                     SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                                     SET_STRING_V(NAME(self),@"m_strNameObject"),
                                     SET_STRING_V(@"SetPairExit",@"m_strNameStage"),
                                     SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                                     SET_VECTOR_V(Vector3DMake(X,Y,0),@"m_pCurPosition"));
        
        [pArrayEnter addObject:pOb];
        
        int iIndexMatrixTmp=-1;
        int **pArrayChild=pConnString->pParent->pChildString;
        InfoArrayValue *pInfoTmp=(InfoArrayValue *)*pArrayChild;
        
        for (int j=0; j<pInfoTmp->mCount; j++) {
            int iIndexFString=(*pArrayChild+SIZE_INFO_STRUCT)[j];
            FractalString *Fstr=[m_pObjMng->pStringContainer->ArrayPoints GetIdAtIndex:iIndexFString];
            
            if(Fstr->m_iIndex==iIndexPairPar)
            {
                iIndexMatrixTmp=Fstr->m_iIndexSelf;
                break;
            }
        }

        pOb = UNFROZE_OBJECT(@"OB_StaticStringInfo",@"StaticStringInfo",
                             SET_INT_V(iIndexMatrixTmp,@"iIndexString"),
                             SET_VECTOR_V(Vector3DMake(X,Y+50,0),@"m_pCurPosition"));

        [pArrayExitIcon addObject:pOb];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)ClickIcon{
    
    ObjectButton *pButtonPush=GET_ID_V(@"ButtonPush");    
    
    InfoArrayValue *pValueCopyInfo=(InfoArrayValue *)(*pMatr->pValueCopy);
    
    if(pMatr->TypeInformation==STR_OPERATION && pValueCopyInfo->mCount>2)
    {//инициализируем режимы
        int iIndexMatrMode= *((*pMatr->pValueCopy)+SIZE_INFO_STRUCT);
        MATRIXcell *pMatrMode = [m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:iIndexMatrMode];
        InfoArrayValue *pInfoMode=(InfoArrayValue *)(*pMatrMode->pValueCopy);
        
        if(pInfoMode->mCount>0){
            
            int *iCurModeTmp=(*EndHeart->pModes+SIZE_INFO_STRUCT+iCurMode);
            *iCurModeTmp=pButtonPush->m_iNum;            
        }
    }
    [self CloseMode];
}
//------------------------------------------------------------------------------------------------------
- (void)ClickMode{
    
    ObjectButton *pButtonPush=GET_ID_V(@"ButtonPush");
    
    iModeSelParams=1;
    iCurMode=pButtonPush->m_iNum;
    [self UpdateTmp];
}
//------------------------------------------------------------------------------------------------------
- (void)SetPairEnter{
    
    ObjectButton *pButtonPush=GET_ID_V(@"ButtonPush");
    
    int *StartEnter=*EndHeart->pEnPairPar+SIZE_INFO_STRUCT;
    int *StartEnterChild=*EndHeart->pEnPairChi+SIZE_INFO_STRUCT;
    
    int TmpIndex=StartEnter[pButtonPush->m_iNum];
    
    if(TmpIndex==m_iIndexStart)
    {
        int **ppArrayTmp=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:TmpIndex];
        InfoArrayValue *pArrayTmp=(InfoArrayValue *)*ppArrayTmp;

        if(pMatr->TypeInformation==STR_OPERATION && pArrayTmp->mType!=DATA_U_INT)
        {
            int iIndexMatrLink=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[2];
            MATRIXcell *pMatrLink=[m_pObjMng->pStringContainer->ArrayPoints
                                   GetMatrixAtIndex:iIndexMatrLink];
            InfoArrayValue *pInfoEnter=(InfoArrayValue *)*pMatrLink->pValueCopy;

            int iIndexMatrLink2=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[3];
        MATRIXcell *pMatrLink2=[m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:iIndexMatrLink2];

            for (int p=0; p<pInfoEnter->mCount; p++)
            {
                int iIndexArrayLink=(*pMatrLink->pValueCopy+SIZE_INFO_STRUCT)[p];
                int **ArrayLink=[m_pObjMng->pStringContainer->ArrayPoints
                                 GetArrayAtIndex:iIndexArrayLink];

                int iRez=[m_pObjMng->pStringContainer->m_OperationIndex
                          FindIndex:pButtonPush->m_iNum WithData:ArrayLink];

                if(iRez!=-1)
                {
                    InfoArrayValue *pInfoTmpLinkInside=(InfoArrayValue *)*ArrayLink;
                    for (int m=0; m<pInfoTmpLinkInside->mCount; m++)
                    {
                        int iTmpPlace=(*ArrayLink+SIZE_INFO_STRUCT)[m];

                        int iIndexChild=(*EndHeart->pEnPairChi+SIZE_INFO_STRUCT)[iTmpPlace];
                        (*EndHeart->pEnPairPar+SIZE_INFO_STRUCT)[iTmpPlace]=iIndexChild;
                    }

                    int iIndexArrayLink2=(*pMatrLink2->pValueCopy+SIZE_INFO_STRUCT)[p];
                    int **ArrayLink2=[m_pObjMng->pStringContainer->ArrayPoints
                                      GetArrayAtIndex:iIndexArrayLink2];

                    pInfoTmpLinkInside=(InfoArrayValue *)*ArrayLink2;
                    for (int m=0; m<pInfoTmpLinkInside->mCount; m++)
                    {
                        int iTmpPlace=(*ArrayLink2+SIZE_INFO_STRUCT)[m];

                        int iIndexChild=(*EndHeart->pExPairChi+SIZE_INFO_STRUCT)[iTmpPlace];
                        (*EndHeart->pExPairPar+SIZE_INFO_STRUCT)[iTmpPlace]=iIndexChild;
                    }
                break;
                }
            }
        }
        StartEnter[pButtonPush->m_iNum]=StartEnterChild[pButtonPush->m_iNum];//возвращаем назад индекс
    }
    else StartEnter[pButtonPush->m_iNum]=m_iIndexStart;
    
    [self UpdateTmp];

 //   DESTROY_OBJECT(self);
}
//------------------------------------------------------------------------------------------------------
- (void)SetPairExit{
    
    ObjectButton *pButtonPush=GET_ID_V(@"ButtonPush");
    
    int *StartExits=*EndHeart->pExPairPar+SIZE_INFO_STRUCT;
    int *StartExitsChild=*EndHeart->pExPairChi+SIZE_INFO_STRUCT;
    
    int TmpIndex=StartExits[pButtonPush->m_iNum];
    
    if(TmpIndex==m_iIndexStart)
    {
        int **ppArrayTmp=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:TmpIndex];
        InfoArrayValue *pArrayTmp=(InfoArrayValue *)*ppArrayTmp;
        
        if(pMatr->TypeInformation==STR_OPERATION && pArrayTmp->mType!=DATA_U_INT)
        {
            int iIndexMatrLink=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[3];
            MATRIXcell *pMatrLink=[m_pObjMng->pStringContainer->ArrayPoints
                                   GetMatrixAtIndex:iIndexMatrLink];
            InfoArrayValue *pInfoEnter=(InfoArrayValue *)*pMatrLink->pValueCopy;
            
            int iIndexMatrLink2=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[2];
        MATRIXcell *pMatrLink2=[m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:iIndexMatrLink2];
            
            for (int p=0; p<pInfoEnter->mCount; p++)
            {
                int iIndexArrayLink=(*pMatrLink->pValueCopy+SIZE_INFO_STRUCT)[p];
                int **ArrayLink=[m_pObjMng->pStringContainer->ArrayPoints
                                 GetArrayAtIndex:iIndexArrayLink];
                
                int iRez=[m_pObjMng->pStringContainer->m_OperationIndex
                          FindIndex:pButtonPush->m_iNum WithData:ArrayLink];
                
                if(iRez!=-1)
                {
                    InfoArrayValue *pInfoTmpLinkInside=(InfoArrayValue *)*ArrayLink;
                    for (int m=0; m<pInfoTmpLinkInside->mCount; m++)
                    {
                        int iTmpPlace=(*ArrayLink+SIZE_INFO_STRUCT)[m];
                        
                        int iIndexChild=(*EndHeart->pExPairChi+SIZE_INFO_STRUCT)[iTmpPlace];
                        (*EndHeart->pExPairPar+SIZE_INFO_STRUCT)[iTmpPlace]=iIndexChild;
                    }
                    
                    int iIndexArrayLink2=(*pMatrLink2->pValueCopy+SIZE_INFO_STRUCT)[p];
                    int **ArrayLink2=[m_pObjMng->pStringContainer->ArrayPoints
                                      GetArrayAtIndex:iIndexArrayLink2];
                    
                    pInfoTmpLinkInside=(InfoArrayValue *)*ArrayLink2;
                    for (int m=0; m<pInfoTmpLinkInside->mCount; m++)
                    {
                        int iTmpPlace=(*ArrayLink2+SIZE_INFO_STRUCT)[m];
                        
                        int iIndexChild=(*EndHeart->pEnPairChi+SIZE_INFO_STRUCT)[iTmpPlace];
                        (*EndHeart->pEnPairPar+SIZE_INFO_STRUCT)[iTmpPlace]=iIndexChild;
                        
                    }
                    
                    break;
                }
            }
        }
        StartExits[pButtonPush->m_iNum]=StartExitsChild[pButtonPush->m_iNum];
    }
    else StartExits[pButtonPush->m_iNum]=m_iIndexStart;
    
    [self UpdateTmp];

 //   DESTROY_OBJECT(self);
}
//------------------------------------------------------------------------------------------------------
- (void)CloseMode{
    iModeSelParams=0;
    [self UpdateTmp];
}
//------------------------------------------------------------------------------------------------------
- (void)Close{
    
    DESTROY_OBJECT(self);
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{
    
    [pArrayEnter release];
    [pArrayExit release];
    
    [pArrayEnterUse release];
    [pArrayExitUse release];

    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
- (void)ClearInterface{
    for (GObject *pOb in pArrayEnter) {
        DESTROY_OBJECT(pOb);
        pOb=0;
    }
    [pArrayEnter removeAllObjects];
    
    for (GObject *pOb in pArrayExit) {
        DESTROY_OBJECT(pOb);
        pOb=0;
    }
    [pArrayExit removeAllObjects];
    
    for (GObject *pOb in pArrayEnterUse) {
        DESTROY_OBJECT(pOb);
        pOb=0;
    }
    [pArrayEnterUse removeAllObjects];
    
    for (GObject *pOb in pArrayExitUse) {
        DESTROY_OBJECT(pOb);
        pOb=0;
    }
    [pArrayExitUse removeAllObjects];
    
    for (GObject *pOb in pArrayMode) {
        DESTROY_OBJECT(pOb);
        pOb=0;
    }
    [pArrayMode removeAllObjects];

    for (GObject *pOb in pArrayIcons) {
        DESTROY_OBJECT(pOb);
        pOb=0;
    }
    [pArrayIcons removeAllObjects];

    for (GObject *pOb in pArrayEnterIcon) {
        DESTROY_OBJECT(pOb);
        pOb=0;
    }
    [pArrayEnterIcon removeAllObjects];
    
    for (GObject *pOb in pArrayExitIcon) {
        DESTROY_OBJECT(pOb);
        pOb=0;
    }
    [pArrayExitIcon removeAllObjects];

    
    DESTROY_OBJECT(pObBtnClose);
    pObBtnClose=0;
    DESTROY_OBJECT(IconEnters);
    IconEnters=0;
    DESTROY_OBJECT(IconExits);
    IconExits=0;
    DESTROY_OBJECT(Line);
    Line=0;
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    
    [self ClearInterface];
    
    Ob_Editor_Interface *pInterface = (Ob_Editor_Interface *)[m_pObjMng
                GetObjectByName:@"Ob_Editor_Interface"];
    
    pInterface->EditorSelectPar=nil;

    [super Destroy];
    [pInterface SetMode:OldInterfaceMode];
}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
@end