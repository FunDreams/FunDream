//
//  Kernel.m
//  FunDreams
//
//  Created by Konstantin on 19.03.13.
//  Copyright (c) 2013 FunDreams. All rights reserved.
//

#import "Kernel.h"
#import "Ob_ParticleCont_ForStr.h"

@implementation Kernel
//------------------------------------------------------------------------------------------------------
-(id)init:(id)Parent{
    
    self = [super init];
    
    if(self)
    {
        m_pContainer=Parent;
        m_pContainer->iIndexMaxSys=RESERV_KERNEL;
        ArrayPoints=m_pContainer->ArrayPoints;
        m_OperationIndex=m_pContainer->m_OperationIndex;
    }
    return self;
}
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
-(int)CreateObByIndex:(int)iIndex withData:(FractalString *)DataValue{
    
    NSString *pKey = [NSString stringWithFormat:@"%d",iIndex];
    [ArrayPoints->pNamesOb setValue:DataValue->strUID forKey:pKey];
    
    id *TmpLink=(id *)(ArrayPoints->pData+iIndex);
    *(TmpLink)=DataValue;
    
    (*(ArrayPoints->pType+iIndex))=DATA_ID;
    return iIndex;
}
//------------------------------------------------------------------------------------------------------
-(int)CreateMatrByIndex:(int)iIndex{
        
    MATRIXcell *pNewMatr=(MATRIXcell *)malloc(sizeof(MATRIXcell));
    [ArrayPoints InitMemoryMatrix:pNewMatr];
    
    MATRIXcell **TmpLink=(MATRIXcell **)(ArrayPoints->pData+iIndex);
    *TmpLink=pNewMatr;
    
    (*(ArrayPoints->pType+iIndex))=DATA_MATRIX;
    pNewMatr->iIndexSelf=iIndex;

    NSNumber *pVal = [NSNumber numberWithInt:iIndex];
    [ArrayPoints->pMartixDic setObject:pVal forKey:pVal];
    
    return iIndex;
}
//------------------------------------------------------------------------------------------------------
-(int)CreateIntByIndex:(int)iIndex withData:(int)DataValue{
    
    int *TmpLink=(int *)ArrayPoints->pData+iIndex;
    *TmpLink=DataValue;
    (*(ArrayPoints->pType+iIndex))=DATA_INT;
    return iIndex;
}
//------------------------------------------------------------------------------------------------------
-(int)CreateFloatByIndex:(int)iIndex withData:(float)DataValue{
    
    float *TmpLink=ArrayPoints->pData+iIndex;
    *TmpLink=DataValue;
    (*(ArrayPoints->pType+iIndex))=DATA_FLOAT;
    return iIndex;
}
//------------------------------------------------------------------------------------------------------
-(int)CreateSpriteByIndex:(int)iIndex{
    
    int *TmpLink=(int *)ArrayPoints->pData+iIndex;
    int indexParticle=0;
    
    indexParticle=[ArrayPoints->pCurrenContPar CreateParticle];
            [m_pContainer->m_OperationIndex OnlyAddData:iIndex
            WithData:ArrayPoints->pCurrenContPar->pIndexParticles];
    
    [ArrayPoints->pCurrenContPar SetDefaultVertex:indexParticle];
    
    *TmpLink=indexParticle;
    (*(ArrayPoints->pType+iIndex))=DATA_SPRITE;
    
    return iIndex;
}
//------------------------------------------------------------------------------------------------------
-(int)CreateStringByIndex:(int)iIndex withData:(NSMutableString *)DataValue{
    
    NSString *pKey = [NSString stringWithFormat:@"%d",iIndex];
    [ArrayPoints->pNamesValue setValue:DataValue forKey:pKey];
    
    id *TmpLink=(id *)(ArrayPoints->pData+iIndex);
    *(TmpLink)=DataValue;
    
    (*(ArrayPoints->pType+iIndex))=DATA_STRING;
    return iIndex;
}
//------------------------------------------------------------------------------------------------------
-(int)CreateTextureByIndex:(int)iIndex withData:(NSMutableString *)DataValue{
    
    NSString *pKey = [NSString stringWithFormat:@"%d",iIndex];
    [ArrayPoints->pNamesValue setValue:DataValue forKey:pKey];
    
    id *TmpLink=(id *)(ArrayPoints->pData+iIndex);
    *(TmpLink)=DataValue;
    
    (*(ArrayPoints->pType+iIndex))=DATA_TEXTURE;
    return iIndex;
}
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
-(int)SetData:(int)iIndexPar withNameIcon:(NSString *)pName
     withMatr:(MATRIXcell *)pMatr withIndIcon:(int *)pIndIcon{
    
    [m_OperationIndex AddData:iIndexPar WithData:pMatr->pValueCopy];

    int iIndIconName=(*pIndIcon);
    NSMutableString *NameTexture=[NSMutableString stringWithString:pName];
    [self CreateStringByIndex:*pIndIcon withData:NameTexture];
    (*pIndIcon)++;
    [m_OperationIndex AddData:iIndIconName WithData:pMatr->pValueCopy];
    
    return iIndexPar;
}
//------------------------------------------------------------------------------------------------------
-(void)SetEnter:(int)iIndexPar NameIcon:(NSString *)pName matr:(MATRIXcell *)pMatr
           icon:(int *)pIndIcon iPar:(int *)pIndPar{

    
    [m_OperationIndex AddData:iIndexPar WithData:pMatr->pValueCopy];
    [m_OperationIndex OnlyAddData:iIndexPar  WithData:pMatr->pEnters];

    if(pIndPar!=0)(*pIndPar)++;
    
    int iIndIconName=(*pIndIcon);
    NSMutableString *NameTexture=[NSMutableString stringWithString:pName];
    [self CreateStringByIndex:*pIndIcon withData:NameTexture];
    (*pIndIcon)++;
    [m_OperationIndex AddData:iIndIconName WithData:pMatr->pValueCopy];
}
//------------------------------------------------------------------------------------------------------
-(void)SetExit:(int)iIndexPar NameIcon:(NSString *)pName matr:(MATRIXcell *)pMatr
    icon:(int *)pIndIcon iPar:(int *)pIndPar{
    
    [m_OperationIndex AddData:iIndexPar WithData:pMatr->pValueCopy];
    [m_OperationIndex OnlyAddData:iIndexPar  WithData:pMatr->pExits];
    
    if(pIndPar!=0)(*pIndPar)++;
    
    int iIndIconName=(*pIndIcon);
    NSMutableString *NameTexture=[NSMutableString stringWithString:pName];
    [self CreateStringByIndex:*pIndIcon withData:NameTexture];
    (*pIndIcon)++;
    [m_OperationIndex AddData:iIndIconName WithData:pMatr->pValueCopy];
}
//------------------------------------------------------------------------------------------------------
-(MATRIXcell *)SetOperationMatrix:(int *)pStartDataListMatr nameTex:(NSString*)NameTex
        listMatr:(int)iType nameOperation:(int)iName withMatr:(MATRIXcell *)pMatrPar
        withIndIcon:(int *)pIndIcon{

    int IndexMatr=iName;
    [self CreateMatrByIndex:IndexMatr];

    MATRIXcell *pMatr=[ArrayPoints GetMatrixAtIndex:IndexMatr];
    pMatr->TypeInformation=STR_OPERATION;
    pMatr->NameInformation=iName;
    
    [m_OperationIndex AddData:pMatr->iIndexSelf WithData:pMatrPar->pValueCopy];
    
    int iIndIconName=(*pIndIcon);
    NSMutableString *NameTexture=[NSMutableString stringWithString:NameTex];
    [self CreateStringByIndex:*pIndIcon withData:NameTexture];
    (*pIndIcon)++;
    [m_OperationIndex AddData:iIndIconName WithData:pMatrPar->pValueCopy];
//    [m_OperationIndex AddData:iIndIconName WithData:pMatr->pValueCopy];

    
    return pMatr;
}
//------------------------------------------------------------------------------------------------
-(void)SetZeroKernel{//пустое ядро
    
    if(m_pContainer->ArrayPoints->m_bSaveKernel==NO)
        [m_pContainer->ArrayPoints Reserv:RESERV_KERNEL];
    
    pFStringZero=[[FractalString alloc]
                                 initWithName:@"Zero" WithParent:nil WithContainer:m_pContainer];
    pFStringZero->m_iIndex=Ind_ZERO;
    [self CreateMatrByIndex:pFStringZero->m_iIndex];
    [ArrayPoints IncDataAtIndex:pFStringZero->m_iIndex];
}
//------------------------------------------------------------------------------------------------
-(void)SetKernel{//устанавливаем константы для ядра (эти индексы не переименовываются)
    
    NSMutableString *NameTexture;
    int iMatr;
    int iCurrentIndIcon=300000;
    int iCurrentIndPar=400000;
    
    [self SetZeroKernel];
    MATRIXcell *pMatrZero=[ArrayPoints GetMatrixAtIndex:pFStringZero->m_iIndex];
    
    [self CreateMatrByIndex:1];//матрица в которой хранятся временные переменные
    MATRIXcell *pMatrTmpData=[ArrayPoints GetMatrixAtIndex:1];
    [m_OperationIndex AddData:pMatrTmpData->iIndexSelf WithData:pMatrZero->pValueCopy];
    //---------------------------------------------------------------------------------------------
    //Empty float
    int iZeroPointFloatTmp=150000;
    [self CreateFloatByIndex:iZeroPointFloatTmp withData:0];
    [self SetData:iZeroPointFloatTmp withNameIcon:@"_F.png" withMatr:pMatrTmpData
      withIndIcon:&iCurrentIndIcon];
    
    //Empty int
    int iIndexIntZeroTmp = 150001;
    [self CreateIntByIndex:iIndexIntZeroTmp withData:0];
    [self SetData:iIndexIntZeroTmp withNameIcon:@"_I.png" withMatr:pMatrTmpData
      withIndIcon:&iCurrentIndIcon];
    
    //Empty Name
    int iIndexNameZeroTmp = 150002;
    NameTexture=[NSMutableString stringWithString:@"0"];
    [self CreateStringByIndex:iIndexNameZeroTmp withData:NameTexture];
    [self SetData:iIndexNameZeroTmp withNameIcon:@"_N.png" withMatr:pMatrTmpData
      withIndIcon:&iCurrentIndIcon];
    
    //Empty Texture
    int iIndexTextureZeroTmp = 150003;
    NameTexture=[NSMutableString stringWithString:@"0"];
    [self CreateTextureByIndex:iIndexTextureZeroTmp withData:NameTexture];
    
    [self SetData:iIndexTextureZeroTmp withNameIcon:@"_T.png" withMatr:pMatrTmpData
      withIndIcon:&iCurrentIndIcon];
    
    //Empty Sprite
    int iIndexSpriteZeroTmp = 150004;
    [self CreateSpriteByIndex:iIndexSpriteZeroTmp];
    [self SetData:iIndexSpriteZeroTmp withNameIcon:@"_S.png" withMatr:pMatrTmpData
      withIndIcon:&iCurrentIndIcon];
//данные------------------------------------------------------------------------------------------
    [self CreateMatrByIndex:IND_MAIN_DATA_MATRIX];//главная матрица для всех данных.
    MATRIXcell *pMatrAllData=[ArrayPoints GetMatrixAtIndex:IND_MAIN_DATA_MATRIX];
    [m_OperationIndex AddData:pMatrAllData->iIndexSelf WithData:pMatrZero->pValueCopy];
    
    iMatr=IND_DATA_MATRIX_EMPTY;
    [self CreateMatrByIndex:iMatr];
    MATRIXcell *pMatrDataEmpty=[ArrayPoints GetMatrixAtIndex:iMatr];
    [self SetData:iMatr withNameIcon:@"_D.png" withMatr:pMatrAllData withIndIcon:&iCurrentIndIcon];

    iMatr=IND_DATA_MATRIX_SYS;
    [self CreateMatrByIndex:iMatr];
    MATRIXcell *pMatrDataSys=[ArrayPoints GetMatrixAtIndex:iMatr];
    [self SetData:iMatr withNameIcon:@"_S.png" withMatr:pMatrAllData withIndIcon:&iCurrentIndIcon];

    iMatr=IND_DATA_MATRIX_OPER;
    [self CreateMatrByIndex:iMatr];
    MATRIXcell *pMatrOperations=[ArrayPoints GetMatrixAtIndex:iMatr];
    [self SetData:iMatr withNameIcon:@"_O.png" withMatr:pMatrAllData withIndIcon:&iCurrentIndIcon];
//---------------------------------------------------------------------------------------------
    //Empty float
    int iZeroPointFloat=100000;
    [self CreateFloatByIndex:iZeroPointFloat withData:0];
    [self SetData:iZeroPointFloat withNameIcon:@"_F.png" withMatr:pMatrDataEmpty
                withIndIcon:&iCurrentIndIcon];
    
    //Empty int
    int iIndexIntZero = 100001;
    [self CreateIntByIndex:iIndexIntZero withData:0];
    [self SetData:iIndexIntZero withNameIcon:@"_I.png" withMatr:pMatrDataEmpty
      withIndIcon:&iCurrentIndIcon];

//    //Empty Name
//    int iIndexNameZero = 100002;
//    NameTexture=[NSMutableString stringWithString:@"0"];
//    [self CreateStringByIndex:iIndexNameZero withData:NameTexture];
//    [self SetData:iIndexNameZero withNameIcon:@"_N.png" withMatr:pMatrDataEmpty
//      withIndIcon:&iCurrentIndIcon];

    //Empty Texture
    int iIndexTextureZero = 100003;
    NameTexture=[NSMutableString stringWithString:@"0"];
    [self CreateTextureByIndex:iIndexTextureZero withData:NameTexture];
    [self SetData:iIndexTextureZero withNameIcon:@"_T.png" withMatr:pMatrDataEmpty
      withIndIcon:&iCurrentIndIcon];

    //Empty Sprite
    int iIndexSpriteZero = 100004;
    [self CreateSpriteByIndex:iIndexSpriteZero];
    [self SetData:iIndexSpriteZero withNameIcon:@"_S.png" withMatr:pMatrDataEmpty
      withIndIcon:&iCurrentIndIcon];
//---------------------------------------------------------------------------------------------
    //системные константы 
    //DeltaT
    int iIndexDeltaT = Ind_DELTATIME;
    [self CreateFloatByIndex:iIndexDeltaT withData:0];
    [self SetData:iIndexDeltaT withNameIcon:@"_T.png" withMatr:pMatrDataSys
     withIndIcon:&iCurrentIndIcon];
    
    int iIndexW_EM = Ind_W_EMULATOR;
    [self CreateFloatByIndex:iIndexW_EM withData:768];
    [self SetData:iIndexW_EM withNameIcon:@"_W.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexH_EM = Ind_H_EMULATOR;
    [self CreateFloatByIndex:iIndexH_EM withData:1024];
    [self SetData:iIndexH_EM withNameIcon:@"_H.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexAng_EM = Ind_ANG_EMULATOR;
    [self CreateFloatByIndex:iIndexAng_EM withData:0];
    [self SetData:iIndexAng_EM withNameIcon:@"_A.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexScale_EM = Ind_SCALE_EMULATOR;
    [self CreateFloatByIndex:iIndexScale_EM withData:100];
    [self SetData:iIndexScale_EM withNameIcon:@"_S.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexDx_EM = Ind_dX_EMULATOR;
    [self CreateFloatByIndex:iIndexDx_EM withData:0];
    [self SetData:iIndexDx_EM withNameIcon:@"_X.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexDy_EM = Ind_dY_EMULATOR;
    [self CreateFloatByIndex:iIndexDy_EM withData:0];
    [self SetData:iIndexDy_EM withNameIcon:@"_Y.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];
    
    int iIndexScale_X_EM = Ind_SCALE_X_EMULATOR;
    [self CreateFloatByIndex:iIndexScale_X_EM withData:100];
    [self SetData:iIndexScale_X_EM withNameIcon:@"_S.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexScale_Y_EM = Ind_SCALE_Y_EMULATOR;
    [self CreateFloatByIndex:iIndexScale_Y_EM withData:100];
    [self SetData:iIndexScale_Y_EM withNameIcon:@"_S.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexMode_EM = Ind_MODE_EMULATOR;
    [self CreateIntByIndex:iIndexMode_EM withData:0];
    [self SetData:iIndexMode_EM withNameIcon:@"_M.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];
//операции -----------------------------------------------------------------------------------------
    int *pStartDataListMatr=(*pMatrOperations->pValueCopy)+SIZE_INFO_STRUCT;
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
{//операция "плюс"----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"o_plus.png"
                    listMatr:GM_DEFAULT nameOperation:NAME_O_PLUS
                    withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

    [self CreateFloatByIndex:iCurrentIndPar withData:0];
    [self SetEnter:iCurrentIndPar NameIcon:@"_A.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self CreateFloatByIndex:iCurrentIndPar withData:0];
    [self SetEnter:iCurrentIndPar NameIcon:@"_B.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self CreateFloatByIndex:iCurrentIndPar withData:0];
    [self SetExit:iCurrentIndPar NameIcon:@"_R.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
}
{//операция "update"--------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_updateSprite.png"
                    listMatr:GM_DEFAULT nameOperation:NAME_O_UPDATE_XY
                    withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

    [self CreateFloatByIndex:iCurrentIndPar withData:0];
    [self SetEnter:iCurrentIndPar NameIcon:@"_X.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self CreateFloatByIndex:iCurrentIndPar withData:0];
    [self SetEnter:iCurrentIndPar NameIcon:@"_Y.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self CreateFloatByIndex:iCurrentIndPar withData:30];
    [self SetEnter:iCurrentIndPar NameIcon:@"_W.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self CreateFloatByIndex:iCurrentIndPar withData:30];
    [self SetEnter:iCurrentIndPar NameIcon:@"_H.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self SetEnter:iIndexSpriteZeroTmp NameIcon:@"_S.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:0];
}
{//операция "draw"----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_draw.png"
                    listMatr:GM_DEFAULT nameOperation:NAME_O_DRAW
                    withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

    [self SetEnter:iIndexTextureZeroTmp NameIcon:@"_T.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:0];

    [self SetEnter:iIndexSpriteZeroTmp NameIcon:@"_S.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:0];
}
{//операция "Прямолинейное движение"----------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_MoveLine.png"
                    listMatr:GM_DEFAULT nameOperation:NAME_O_MOVE
                    withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

    [self CreateFloatByIndex:iCurrentIndPar withData:1];
    [self SetEnter:iCurrentIndPar NameIcon:@"_V.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self CreateFloatByIndex:iCurrentIndPar withData:0];
    [self SetExit:iCurrentIndPar NameIcon:@"_R.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
}
{//операция "движение по окружности"----------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_MoveOrbit.png"
                    listMatr:GM_DEFAULT nameOperation:NAME_O_MOVE_ORBIT
                    withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

    [self CreateFloatByIndex:iCurrentIndPar withData:0];
    [self SetEnter:iCurrentIndPar NameIcon:@"_X.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self CreateFloatByIndex:iCurrentIndPar withData:0];
    [self SetEnter:iCurrentIndPar NameIcon:@"_Y.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self CreateFloatByIndex:iCurrentIndPar withData:30];
    [self SetEnter:iCurrentIndPar NameIcon:@"_R.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self CreateFloatByIndex:iCurrentIndPar withData:0];
    [self SetEnter:iCurrentIndPar NameIcon:@"_A.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self CreateFloatByIndex:iCurrentIndPar withData:0];
    [self SetExit:iCurrentIndPar NameIcon:@"_X.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self CreateFloatByIndex:iCurrentIndPar withData:0];
    [self SetExit:iCurrentIndPar NameIcon:@"_Y.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
}
{//операция "сложение векторов"---------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_peXY.png"
                    listMatr:GM_DEFAULT nameOperation:NAME_O_PLUS_VECTOR
                    withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

    [self CreateFloatByIndex:iCurrentIndPar withData:0];
    [self SetEnter:iCurrentIndPar NameIcon:@"_X.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self CreateFloatByIndex:iCurrentIndPar withData:0];
    [self SetEnter:iCurrentIndPar NameIcon:@"_Y.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self CreateFloatByIndex:iCurrentIndPar withData:0];
    [self SetExit:iCurrentIndPar NameIcon:@"_X.png" matr:pMatr
             icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self CreateFloatByIndex:iCurrentIndPar withData:0];
    [self SetExit:iCurrentIndPar NameIcon:@"_Y.png" matr:pMatr
             icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
}//=================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////
}
//------------------------------------------------------------------------------------------------------
@end
