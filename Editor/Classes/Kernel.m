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
- (void)dealloc
{
    [m_OperationIndex OnlyReleaseMemory:pFStringZero->pChildString];
    pFStringZero->pChildString=0;
    [pFStringZero release];
    [super dealloc];
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
-(int)CreateUIntByIndex:(int)iIndex withData:(unsigned int)DataValue{
    
    unsigned int *TmpLink=(unsigned int *)ArrayPoints->pData+iIndex;
    *TmpLink=DataValue;
    (*(ArrayPoints->pType+iIndex))=DATA_U_INT;
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
    
    [ArrayPoints->pCurrenContPar SetDefaultVertex:indexParticle];
    [m_pContainer->m_OperationIndex OnlyAddData:iIndex
                        WithData:ArrayPoints->pCurrenContPar->pIndexParticles];
    
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
    
    float iIndexTex=[ArrayPoints->pCurrenContPar->pTexRes CreateResTexture:DataValue];
    [m_pContainer->m_OperationIndex OnlyAddData:iIndex
                WithData:ArrayPoints->pCurrenContPar->pTexRes->pIndexRes];

    float *TmpLink=ArrayPoints->pData+iIndex;
    *TmpLink=iIndexTex;

    (*(ArrayPoints->pType+iIndex))=DATA_TEXTURE;
    return iIndex;
}
//------------------------------------------------------------------------------------------------------
-(int)CreateSoundByIndex:(int)iIndex withData:(NSMutableString *)DataValue{
    
    float iIndexSound=[ArrayPoints->pCurrenContPar->pSoundRes CreateResSound:DataValue];
    [m_pContainer->m_OperationIndex OnlyAddData:iIndex
                            WithData:ArrayPoints->pCurrenContPar->pSoundRes->pIndexRes];
    
    float *TmpLink=ArrayPoints->pData+iIndex;
    *TmpLink=iIndexSound;
    
    (*(ArrayPoints->pType+iIndex))=DATA_SOUND;
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
-(void)setPairEn:(int)iEnt Ex:(int)iEx matr:(MATRIXcell *)pMatr{
    
    int iArray=*(*pMatr->pValueCopy+SIZE_INFO_STRUCT+1);
    int ** ppAray=[m_pContainer->ArrayPoints GetArrayAtIndex:iArray];
    
    [m_pContainer->m_OperationIndex OnlyAddData:iEnt WithData:ppAray];
    [m_pContainer->m_OperationIndex OnlyAddData:iEx WithData:ppAray];
}
//------------------------------------------------------------------------------------------------------
-(void)setPairParOb:(MATRIXcell *)pMatr arrayEn:(NSArray *)pArrayEn arrayEx:(NSArray *)pArrayEx{
    
    int iIndexMatrix=*(*pMatr->pValueCopy+SIZE_INFO_STRUCT+2);
    MATRIXcell *pMartValues=[ArrayPoints GetMatrixAtIndex:iIndexMatrix];
    
    [ArrayPoints CreateArrayByIndex:iCurrentIndArrayMode withType:DATA_INT];
    [m_OperationIndex AddData:iCurrentIndArrayMode WithData:pMartValues->pValueCopy];
    int ** ppAray=[m_pContainer->ArrayPoints GetArrayAtIndex:iCurrentIndArrayMode];
    iCurrentIndArrayMode++;

    for(NSNumber *pNum in pArrayEn)
    {
        int iValue=[pNum intValue];
        [m_pContainer->m_OperationIndex OnlyAddData:iValue WithData:ppAray];
    }
    
    iIndexMatrix=*(*pMatr->pValueCopy+SIZE_INFO_STRUCT+3);
    pMartValues=[ArrayPoints GetMatrixAtIndex:iIndexMatrix];
    
    [ArrayPoints CreateArrayByIndex:iCurrentIndArrayMode withType:DATA_INT];
    [m_OperationIndex AddData:iCurrentIndArrayMode WithData:pMartValues->pValueCopy];
    ppAray=[m_pContainer->ArrayPoints GetArrayAtIndex:iCurrentIndArrayMode];
    iCurrentIndArrayMode++;
    
    for(NSNumber *pNum in pArrayEx)
    {
        int iValue=[pNum intValue];
        [m_pContainer->m_OperationIndex OnlyAddData:iValue WithData:ppAray];
    }
}
//------------------------------------------------------------------------------------------------------
-(int)SetEnter:(int)iIndexPar NameIcon:(NSString *)pName matr:(MATRIXcell *)pMatr
           icon:(int *)pIndIcon iPar:(int *)pIndPar{

    [m_OperationIndex AddData:iIndexPar WithData:pMatr->pValueCopy];
    [m_OperationIndex OnlyAddData:iIndexPar  WithData:pMatr->pEnters];

    if(pIndPar!=0)(*pIndPar)++;
    
    int iIndIconName=(*pIndIcon);
    NSMutableString *NameTexture=[NSMutableString stringWithString:pName];
    [self CreateStringByIndex:*pIndIcon withData:NameTexture];
    (*pIndIcon)++;
    [m_OperationIndex AddData:iIndIconName WithData:pMatr->pValueCopy];
    InfoArrayValue *pInfo = (InfoArrayValue *)*pMatr->pEnters;
    
    return pInfo->mCount-1;
}
//------------------------------------------------------------------------------------------------------
-(int)SetExit:(int)iIndexPar NameIcon:(NSString *)pName matr:(MATRIXcell *)pMatr
    icon:(int *)pIndIcon iPar:(int *)pIndPar{
    
    [m_OperationIndex AddData:iIndexPar WithData:pMatr->pValueCopy];
    [m_OperationIndex OnlyAddData:iIndexPar  WithData:pMatr->pExits];
    
    if(pIndPar!=0)(*pIndPar)++;
    
    int iIndIconName=(*pIndIcon);
    NSMutableString *NameTexture=[NSMutableString stringWithString:pName];
    [self CreateStringByIndex:*pIndIcon withData:NameTexture];
    (*pIndIcon)++;
    [m_OperationIndex AddData:iIndIconName WithData:pMatr->pValueCopy];
    InfoArrayValue *pInfo = (InfoArrayValue *)*pMatr->pExits;
    
    return pInfo->mCount-1;
}
//------------------------------------------------------------------------------------------------------
-(void)CreateModeIcons:(MATRIXcell *)pMatrPar withIndIcon:(int *)pIndIcon array:(NSArray *)pArray{

    int IndexMatrMode = *((*pMatrPar->pValueCopy)+SIZE_INFO_STRUCT);
    MATRIXcell *pMatrMode=[ArrayPoints GetMatrixAtIndex:IndexMatrMode];
    
    int iArray=iCurrentIndArrayMode;
    iCurrentIndArrayMode++;
    [ArrayPoints CreateArrayByIndex:iArray withType:DATA_STRING];
    [m_OperationIndex AddData:iArray WithData:pMatrMode->pValueCopy];
    int **ppCurArray=[ArrayPoints GetArrayAtIndex:iArray];
    
    for (NSString *pStr in pArray) {
        int iIndexTmpData=*pIndIcon;
        NSMutableString *Name=[NSMutableString stringWithString:pStr];
        [self CreateStringByIndex:iIndexTmpData withData:Name];
        [m_OperationIndex AddData:iIndexTmpData WithData:ppCurArray];
        (*(pIndIcon))++;
    }
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
    //добавляем иконку операции
    [m_OperationIndex AddData:iIndIconName WithData:pMatrPar->pValueCopy];

    //матрица для режимов действия операции(не используется)
    [self CreateMatrByIndex:iCurrentIndMode];
    MATRIXcell *pMatrMode=[ArrayPoints GetMatrixAtIndex:iCurrentIndMode];
    [m_OperationIndex AddData:pMatrMode->iIndexSelf WithData:pMatr->pValueCopy];

    iCurrentIndMode++;
    
    //добавляем массив для пар индексов, которые связаны. (для одинаковых входа/выхода)
    [ArrayPoints CreateArrayByIndex:iCurrentIndArrayMode withType:DATA_INT];
    [m_OperationIndex AddData:iCurrentIndArrayMode WithData:pMatr->pValueCopy];
    iCurrentIndArrayMode++;

    //добавляем матрицу для пар индексов, которые связаны. (для объектов c одинаковой матрицей)
    [self CreateMatrByIndex:iCurrentIndMatrix];//матрица для входов
    [m_OperationIndex AddData:iCurrentIndMatrix WithData:pMatr->pValueCopy];
    iCurrentIndMatrix++;

    [self CreateMatrByIndex:iCurrentIndMatrix];//матрица для выходов
    [m_OperationIndex AddData:iCurrentIndMatrix WithData:pMatr->pValueCopy];
    iCurrentIndMatrix++;

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
    NSMutableString *NameSound;
    int iMatr;
    int iCurrentIndIcon=300000;
    int iCurrentIndPar=400000;
    iCurrentIndMode=500000;
    iCurrentIndArrayMode=600000;
    iCurrentIndMatrix=700000;
    
    [self SetZeroKernel];
    MATRIXcell *pMatrZero=[ArrayPoints GetMatrixAtIndex:pFStringZero->m_iIndex];
    
    [self CreateMatrByIndex:1];//матрица в которой хранятся временные переменные
    MATRIXcell *pMatrTmpData=[ArrayPoints GetMatrixAtIndex:1];
    [m_OperationIndex AddData:pMatrTmpData->iIndexSelf WithData:pMatrZero->pValueCopy];
//---------------------------------------------------------------------------------------------
    int iIndexTmpData;
    
//Empty float-------------------------------------------------------------------------
    int iZeroPointFloatArray=150000;
    [ArrayPoints CreateArrayByIndex:iZeroPointFloatArray withType:DATA_FLOAT];

    iIndexTmpData=150001;
    [self CreateFloatByIndex:iIndexTmpData withData:0];
    int **ppCurArray=[ArrayPoints GetArrayAtIndex:iZeroPointFloatArray];
    [m_OperationIndex AddData:iIndexTmpData WithData:ppCurArray];
    
    [self SetData:iZeroPointFloatArray withNameIcon:@"Button_Float.png" withMatr:pMatrTmpData
      withIndIcon:&iCurrentIndIcon];
//------------------------------------------------------------------------------------
    int iZeroPointIntArray=150002;//int
    [ArrayPoints CreateArrayByIndex:iZeroPointIntArray withType:DATA_INT];

    iIndexTmpData=150003;
    [self CreateIntByIndex:iIndexTmpData withData:0];
    ppCurArray=[ArrayPoints GetArrayAtIndex:iZeroPointIntArray];
    [m_OperationIndex AddData:iIndexTmpData WithData:ppCurArray];
    
    [self SetData:iZeroPointIntArray withNameIcon:@"Button_Int.png" withMatr:pMatrTmpData
      withIndIcon:&iCurrentIndIcon];
//------------------------------------------------------------------------------------
    int iZeroPointTextureArray=150004;//texture
    [ArrayPoints CreateArrayByIndex:iZeroPointTextureArray withType:DATA_TEXTURE];

    iIndexTmpData=150005;
    NameTexture=[NSMutableString stringWithString:@"0.png"];
    [self CreateTextureByIndex:iIndexTmpData withData:NameTexture];
    ppCurArray=[ArrayPoints GetArrayAtIndex:iZeroPointTextureArray];
    [m_OperationIndex AddData:iIndexTmpData WithData:ppCurArray];
    
    [self SetData:iZeroPointTextureArray withNameIcon:@"Button_Texture.png" withMatr:pMatrTmpData
      withIndIcon:&iCurrentIndIcon];
//------------------------------------------------------------------------------------
    int iZeroPointSpriteArray=150006;//sprite
    [ArrayPoints CreateArrayByIndex:iZeroPointSpriteArray withType:DATA_SPRITE];
    
    iIndexTmpData=150007;
    [self CreateSpriteByIndex:iIndexTmpData];
    ppCurArray=[ArrayPoints GetArrayAtIndex:iZeroPointSpriteArray];
    [m_OperationIndex AddData:iIndexTmpData WithData:ppCurArray];
    
    [self SetData:iZeroPointSpriteArray withNameIcon:@"Button_Sprite.png" withMatr:pMatrTmpData
      withIndIcon:&iCurrentIndIcon];
//------------------------------------------------------------------------------------
    int iZeroPointObArray=150008;//Ob Array
    [ArrayPoints CreateArrayByIndex:iZeroPointObArray withType:DATA_U_INT];

//    iIndexTmpData=150009;
  //  [self CreateUIntByIndex:iIndexTmpData withData:0];
    ppCurArray=[ArrayPoints GetArrayAtIndex:iZeroPointObArray];
    [m_OperationIndex OnlyAddData:0 WithData:ppCurArray];

    [self SetData:iZeroPointObArray withNameIcon:@"Button_Objects.png" withMatr:pMatrTmpData
                withIndIcon:&iCurrentIndIcon];
//------------------------------------------------------------------------------------
    int iZeroPointMatrix=150010;//zero matrix
    [ArrayPoints CreateArrayByIndex:iZeroPointMatrix withType:DATA_P_MATR];
    
    //iIndexTmpData=150009;
    //[self CreateUIntByIndex:iIndexTmpData withData:0];
    ppCurArray=[ArrayPoints GetArrayAtIndex:iZeroPointMatrix];
    [m_OperationIndex OnlyAddData:0 WithData:ppCurArray];
    
    [self SetData:iZeroPointMatrix withNameIcon:@"_M.png" withMatr:pMatrTmpData
      withIndIcon:&iCurrentIndIcon];
//------------------------------------------------------------------------------------
    int iZeroPointSoundArray=150011;//Sound
    [ArrayPoints CreateArrayByIndex:iZeroPointSoundArray withType:DATA_SOUND];
    
    iIndexTmpData=150012;
    NameSound=[NSMutableString stringWithString:@"0.wav"];
    [self CreateSoundByIndex:iIndexTmpData withData:NameSound];
    ppCurArray=[ArrayPoints GetArrayAtIndex:iZeroPointTextureArray];
    [m_OperationIndex AddData:iIndexTmpData WithData:ppCurArray];
    
    [self SetData:iZeroPointSoundArray withNameIcon:@"_S.png" withMatr:pMatrTmpData
      withIndIcon:&iCurrentIndIcon];
//-------------------------------------------------------------------------------------------------
//дополнительные данные----------------------------------------------------------------------------
    int iOnePointFloatArray=151000;//единица
    [ArrayPoints CreateArrayByIndex:iOnePointFloatArray withType:DATA_FLOAT];
    
    iIndexTmpData=151001;
    [self CreateFloatByIndex:iIndexTmpData withData:1];
    ppCurArray=[ArrayPoints GetArrayAtIndex:iOnePointFloatArray];
    [m_OperationIndex AddData:iIndexTmpData WithData:ppCurArray];
    
    [self SetData:iZeroPointFloatArray withNameIcon:@"_F.png" withMatr:pMatrTmpData
      withIndIcon:&iCurrentIndIcon];
//-------------------------------------------------------------------------------------------------
    int i100PointFloatArray=151002;//сто
    [ArrayPoints CreateArrayByIndex:i100PointFloatArray withType:DATA_FLOAT];
    
    iIndexTmpData=151003;
    [self CreateFloatByIndex:iIndexTmpData withData:100];
    ppCurArray=[ArrayPoints GetArrayAtIndex:iOnePointFloatArray];
    [m_OperationIndex AddData:iIndexTmpData WithData:ppCurArray];
    
    [self SetData:iZeroPointFloatArray withNameIcon:@"_F.png" withMatr:pMatrTmpData
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
    //Empty float (для добалления)
    int iZeroPointFloat=100000;
    [self CreateFloatByIndex:iZeroPointFloat withData:0];
    [self SetData:iZeroPointFloat withNameIcon:@"Button_Float.png" withMatr:pMatrDataEmpty
                withIndIcon:&iCurrentIndIcon];

    //Empty int
    int iIndexIntZero = 100001;
    [self CreateIntByIndex:iIndexIntZero withData:0];
    [self SetData:iIndexIntZero withNameIcon:@"Button_Int.png" withMatr:pMatrDataEmpty
      withIndIcon:&iCurrentIndIcon];

//    //Empty Name
//    int iIndexNameZero = 100002;
//    NameTexture=[NSMutableString stringWithString:@"0"];
//    [self CreateStringByIndex:iIndexNameZero withData:NameTexture];
//    [self SetData:iIndexNameZero withNameIcon:@"_N.png" withMatr:pMatrDataEmpty
//      withIndIcon:&iCurrentIndIcon];

    //Empty Texture
    int iIndexTextureZero = 100003;
    NameTexture=[NSMutableString stringWithString:@"0.png"];
    [self CreateTextureByIndex:iIndexTextureZero withData:NameTexture];
    [self SetData:iIndexTextureZero withNameIcon:@"Button_Texture.png" withMatr:pMatrDataEmpty
      withIndIcon:&iCurrentIndIcon];

    //Empty Sprite
    int iIndexSpriteZero = 100004;
    [self CreateSpriteByIndex:iIndexSpriteZero];
    [self SetData:iIndexSpriteZero withNameIcon:@"Button_Sprite.png" withMatr:pMatrDataEmpty
      withIndIcon:&iCurrentIndIcon];
    
    //Empty unsigned unsigned int
    int iIndexUIntZero = 100005;
    [self CreateUIntByIndex:iIndexUIntZero withData:0];
    [self SetData:iIndexUIntZero withNameIcon:@"Button_Objects.png" withMatr:pMatrDataEmpty
      withIndIcon:&iCurrentIndIcon];

    //Empty Texture
    int iIndexSoundZero = 100006;
    NameSound=[NSMutableString stringWithString:@"0.wav"];
    [self CreateSoundByIndex:iIndexSoundZero withData:NameSound];
    [self SetData:iIndexSoundZero withNameIcon:@"Button_Sound.png" withMatr:pMatrDataEmpty
      withIndIcon:&iCurrentIndIcon];
//---------------------------------------------------------------------------------------------
    //системные константы 
    //DeltaT
    int iIndexDeltaT = Ind_DELTATIME;
    [self CreateFloatByIndex:iIndexDeltaT withData:0];
    [self SetData:iIndexDeltaT withNameIcon:@"Button_Delta_T.png" withMatr:pMatrDataSys
     withIndIcon:&iCurrentIndIcon];

    int iIndexW_EM = Ind_W_EMULATOR;
    [self CreateFloatByIndex:iIndexW_EM withData:768];
    [self SetData:iIndexW_EM withNameIcon:@"Button_W.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexH_EM = Ind_H_EMULATOR;
    [self CreateFloatByIndex:iIndexH_EM withData:1024];
    [self SetData:iIndexH_EM withNameIcon:@"Button_H.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexAng_EM = Ind_ANG_EMULATOR;
    [self CreateFloatByIndex:iIndexAng_EM withData:0];
    [self SetData:iIndexAng_EM withNameIcon:@"Button_Angle.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexScale_EM = Ind_SCALE_EMULATOR;
    [self CreateFloatByIndex:iIndexScale_EM withData:100];
    [self SetData:iIndexScale_EM withNameIcon:@"Button_Scale.png" withMatr:pMatrDataSys 
      withIndIcon:&iCurrentIndIcon];

    int iIndexDx_EM = Ind_dX_EMULATOR;
    [self CreateFloatByIndex:iIndexDx_EM withData:0];
    [self SetData:iIndexDx_EM withNameIcon:@"Button_Offset_X.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexDy_EM = Ind_dY_EMULATOR;
    [self CreateFloatByIndex:iIndexDy_EM withData:0];
    [self SetData:iIndexDy_EM withNameIcon:@"Button_Offset_Y.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexScale_X_EM = Ind_SCALE_X_EMULATOR;
    [self CreateFloatByIndex:iIndexScale_X_EM withData:100];
    [self SetData:iIndexScale_X_EM withNameIcon:@"Button_Scale_X.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexScale_Y_EM = Ind_SCALE_Y_EMULATOR;
    [self CreateFloatByIndex:iIndexScale_Y_EM withData:100];
    [self SetData:iIndexScale_Y_EM withNameIcon:@"Button_Scale_Y.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexMode_EM = Ind_MODE_EMULATOR;
    [self CreateIntByIndex:iIndexMode_EM withData:0];
    [self SetData:iIndexMode_EM withNameIcon:@"Button_Mode.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexTopX = Ind_TOP_X;
    [self CreateFloatByIndex:iIndexTopX withData:0];
    [self SetData:iIndexTopX withNameIcon:@"Button_Max_X.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexTopY = Ind_TOP_Y;
    [self CreateFloatByIndex:iIndexTopY withData:0];
    [self SetData:iIndexTopY withNameIcon:@"Button_Max_Y.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexIsIpad = Ind_IS_IPAD;
    [self CreateIntByIndex:iIndexIsIpad withData:0];
    [self SetData:iIndexIsIpad withNameIcon:@"Button_Is_Ipad.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexDataY = Ind_DATA_Y;
    [self CreateIntByIndex:iIndexDataY withData:0];
    [self SetData:iIndexDataY withNameIcon:@"Button_year.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexDataM = Ind_DATA_M;
    [self CreateIntByIndex:iIndexDataM withData:0];
    [self SetData:iIndexDataM withNameIcon:@"Button_Month.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexDataDay = Ind_DATA_DAY;
    [self CreateIntByIndex:iIndexDataDay withData:0];
    [self SetData:iIndexDataDay withNameIcon:@"Button_day.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexDataH = Ind_DATA_H;
    [self CreateIntByIndex:iIndexDataH withData:0];
    [self SetData:iIndexDataH withNameIcon:@"Button_hour.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexDataMin = Ind_DATA_MIN;
    [self CreateIntByIndex:iIndexDataMin withData:0];
    [self SetData:iIndexDataMin withNameIcon:@"Button_min.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexDataS = Ind_DATA_S;
    [self CreateIntByIndex:iIndexDataS withData:0];
    [self SetData:iIndexDataS withNameIcon:@"Button_sec.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];
    
    int iIndexPause = Ind_PAUSE;
    [self CreateIntByIndex:iIndexPause withData:0];
    [self SetData:iIndexPause withNameIcon:@"Button_pause.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexV1 = Ind_V1;
    [self CreateIntByIndex:iIndexV1 withData:0];
    [self SetData:iIndexV1 withNameIcon:@"V1.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexV2 = Ind_V2;
    [self CreateIntByIndex:iIndexV2 withData:0];
    [self SetData:iIndexV2 withNameIcon:@"V2.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];

    int iIndexV3 = Ind_V3;
    [self CreateIntByIndex:iIndexV3 withData:0];
    [self SetData:iIndexV3 withNameIcon:@"V3.png" withMatr:pMatrDataSys
      withIndIcon:&iCurrentIndIcon];
//операции-----------------------------------------------------------------------------------------
    int *pStartDataListMatr=(*pMatrOperations->pValueCopy)+SIZE_INFO_STRUCT;
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
{//операция "Touch Begun"---------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Touch_Beg.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_TOUCH_BEG
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

    [self SetEnter:iZeroPointIntArray NameIcon:@"_L.png" matr:pMatr
        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];//lock touch

    int iPar0=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];//старт array

    int iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_X.png" matr:pMatr
                  icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
                            arrayEx:[NSArray arrayWithObjects:nil]];

    iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_Y.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_W.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"4.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_H.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"5.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"6.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    int iPar3=[self SetExit:iZeroPointObArray NameIcon:@"_Yes.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar4=[self SetExit:iZeroPointObArray NameIcon:@"_No.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar5=[self SetExit:iZeroPointIntArray NameIcon:@"_T.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    int iPar6=[self SetExit:iZeroPointIntArray NameIcon:@"_X.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar7=[self SetExit:iZeroPointIntArray NameIcon:@"_Y.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar0],nil]
                           arrayEx:[NSArray arrayWithObjects:
                                    [NSNumber numberWithInt:iPar3],
                                    [NSNumber numberWithInt:iPar4],
                                    [NSNumber numberWithInt:iPar6],
                                    [NSNumber numberWithInt:iPar7],
                                    [NSNumber numberWithInt:iPar5],nil]];

    
    int iPar8=[self SetExit:iZeroPointObArray NameIcon:@"_Yes.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar9=[self SetExit:iZeroPointObArray NameIcon:@"_No.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar10=[self SetExit:iZeroPointIntArray NameIcon:@"_T.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iPar11=[self SetExit:iZeroPointIntArray NameIcon:@"_X.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar12=[self SetExit:iZeroPointIntArray NameIcon:@"_Y.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar13=[self SetExit:iZeroPointObArray NameIcon:@"_A.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iPar8],
                        [NSNumber numberWithInt:iPar9],
                        [NSNumber numberWithInt:iPar10],
                        [NSNumber numberWithInt:iPar11],
                        [NSNumber numberWithInt:iPar12],
                        [NSNumber numberWithInt:iPar13],nil]];
}
{//операция "Touch Move"---------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Touch_Move.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_TOUCH_MOVE
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
        
    int iPar0=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];//старт array
    
    int iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_X.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_Y.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_W.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"4.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_H.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"5.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"6.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    int iPar5=[self SetEnter:iZeroPointIntArray NameIcon:@"_T.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    int iPar3=[self SetExit:iZeroPointObArray NameIcon:@"_Yes.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar4=[self SetExit:iZeroPointObArray NameIcon:@"_No.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iPar6=[self SetExit:iZeroPointIntArray NameIcon:@"_X.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar7=[self SetExit:iZeroPointIntArray NameIcon:@"_Y.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar0],
                                      [NSNumber numberWithInt:iPar5],nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iPar3],
                        [NSNumber numberWithInt:iPar6],
                        [NSNumber numberWithInt:iPar7],
                        [NSNumber numberWithInt:iPar4],nil]];
}
{//операция "Touch End"---------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Touch_End.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_TOUCH_END
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iPar0=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];//старт array
    
    int iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_X.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_Y.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_W.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"4.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_H.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"5.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"6.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    int iPar5=[self SetEnter:iZeroPointIntArray NameIcon:@"_T.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iPar3=[self SetExit:iZeroPointObArray NameIcon:@"_Yes.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar4=[self SetExit:iZeroPointObArray NameIcon:@"_No.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iPar6=[self SetExit:iZeroPointIntArray NameIcon:@"_X.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar7=[self SetExit:iZeroPointIntArray NameIcon:@"_Y.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar0],
                                      [NSNumber numberWithInt:iPar5],nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iPar3],
                        [NSNumber numberWithInt:iPar6],
                        [NSNumber numberWithInt:iPar7],
                        [NSNumber numberWithInt:iPar4],nil]];
}
{//операция "add"-----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Add.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_ADD_DATA
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    
//    [self CreateModeIcons:pMatr withIndIcon:&iCurrentIndIcon array:[NSArray arrayWithObjects:
//                                                       @"m_DelSrc.png",
//                                                       @"m_NothingSrc.png",nil]];
        
    [self SetEnter:iZeroPointIntArray NameIcon:@"_C.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
//    int iPar1=[self SetEnter:iZeroPointMatrix NameIcon:@"_M.png" matr:pMatr
//              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"_A.png" matr:pMatr
             icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    int iPar3=[self SetExit:iZeroPointObArray NameIcon:@"_O.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar4=[self SetExit:iZeroPointObArray NameIcon:@"_N.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                  //    [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
                                arrayEx:[NSArray arrayWithObjects:
                                        [NSNumber numberWithInt:iPar3],
                                        [NSNumber numberWithInt:iPar4],nil]];
}
{//операция "move"----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Move.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_MOVE_DATA
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

//    [self CreateModeIcons:pMatr withIndIcon:&iCurrentIndIcon array:[NSArray arrayWithObjects:
//                                                        @"_F.png",
//                                                        @"_I.png",
//                                                        @"_S.png",
//                                                        @"_T.png",nil]];
//    [self CreateModeIcons:pMatr withIndIcon:&iCurrentIndIcon array:[NSArray arrayWithObjects:
//                                                        @"m_OneElem.png",
//                                                        @"m_AllElem.png",
//                                                        @"m_GroupElem.png",nil]];
//    [self CreateModeIcons:pMatr withIndIcon:&iCurrentIndIcon array:[NSArray arrayWithObjects:
//                                                       @"m_DelSrc.png",
//                                                       @"m_NothingSrc.png",nil]];
//    [self CreateModeIcons:pMatr withIndIcon:&iCurrentIndIcon array:[NSArray arrayWithObjects:
//                                                        @"m_add.png",
//                                                        @"m_Insert.png",
//                                                        @"m_Replace.png",nil]];
    
//    [self SetEnter:iZeroPointIntArray NameIcon:@"_I.png" matr:pMatr
//             icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
//    [self SetEnter:iZeroPointIntArray NameIcon:@"_J.png" matr:pMatr
//             icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
//    [self SetEnter:iZeroPointIntArray NameIcon:@"_C.png" matr:pMatr
//             icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
//    [self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
//              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    int iPar1=[self SetEnter:iZeroPointMatrix NameIcon:@"_S.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"_S.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                        [NSNumber numberWithInt:iPar1],
                                        [NSNumber numberWithInt:iPar2],nil]
                                arrayEx:[NSArray arrayWithObjects:nil]];

    int iPar3=[self SetExit:iZeroPointMatrix NameIcon:@"_D.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar4=[self SetExit:iZeroPointObArray NameIcon:@"_S.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
                               arrayEx:[NSArray arrayWithObjects:
                                        [NSNumber numberWithInt:iPar3],
                                        [NSNumber numberWithInt:iPar4],nil]];
    
    [self setPairEn:iPar1 Ex:iPar3 matr:pMatr];
}
{//операция "copy"----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Copy.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_COPY_DATA
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
//    [self CreateModeIcons:pMatr withIndIcon:&iCurrentIndIcon array:[NSArray arrayWithObjects:
//                                                            @"_F.png",
//                                                            @"_I.png",
//                                                            @"_S.png",
//                                                            @"_T.png",nil]];
//    
//    [self CreateModeIcons:pMatr withIndIcon:&iCurrentIndIcon array:[NSArray arrayWithObjects:
//                                                            @"m_OneElem.png",
//                                                            @"m_AllElem.png",
//                                                            @"m_GroupElem.png",nil]];
//    
//    [self CreateModeIcons:pMatr withIndIcon:&iCurrentIndIcon array:[NSArray arrayWithObjects:
//                                                            @"m_DelSrc.png",
//                                                            @"m_NothingSrc.png",nil]];
//    
//    [self CreateModeIcons:pMatr withIndIcon:&iCurrentIndIcon array:[NSArray arrayWithObjects:
//                                                            @"m_add.png",
//                                                            @"m_Insert.png",
//                                                            @"m_Replace.png",nil]];

    int iPar1=[self SetEnter:iZeroPointMatrix NameIcon:@"_S.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"_S.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                        [NSNumber numberWithInt:iPar1],
                                        [NSNumber numberWithInt:iPar2],nil]
                               arrayEx:[NSArray arrayWithObjects:nil]];
    
    int iPar3=[self SetExit:iZeroPointMatrix NameIcon:@"_D.png" matr:pMatr
             icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar4=[self SetExit:iZeroPointObArray NameIcon:@"_S.png" matr:pMatr
             icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
                             arrayEx:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar3],
                                      [NSNumber numberWithInt:iPar4],nil]];
    
    [self setPairEn:iPar1 Ex:iPar3 matr:pMatr];
}
{//операция "Inv"----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Inv.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_INV
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

    [self SetEnter:iZeroPointObArray NameIcon:@"_A.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
}
{//операция "Del"----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Delete.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_DEL_DATA
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    [self SetEnter:iZeroPointObArray NameIcon:@"_A.png" matr:pMatr
             icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    
//    [self CreateModeIcons:pMatr withIndIcon:&iCurrentIndIcon array:[NSArray arrayWithObjects:
//                                                            @"m_OneElem.png",
//                                                            @"m_AllElem.png",
//                                                            @"m_GroupElem.png",nil]];
//    
//    [self SetEnter:iZeroPointIntArray NameIcon:@"_I.png" matr:pMatr
//              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
//    [self SetEnter:iZeroPointIntArray NameIcon:@"_C.png" matr:pMatr
//              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
//    
//    [self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
//              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
}
{//операция "Jmp"----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Jmp.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_JMP
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

    int iPar1=[self SetEnter:iZeroPointObArray NameIcon:@"0.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    int iPar2=[self SetExit:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                        [NSNumber numberWithInt:iPar1],nil]
                             arrayEx:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar2],nil]];
}
{//операция "Jmp Ex"----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Jmp_ex.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_JMP_EX
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
        
    int iPar1=[self SetEnter:iZeroPointObArray NameIcon:@"_S.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iPar3=[self SetEnter:iZeroPointFloatArray NameIcon:@"_P.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar4=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    

    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar3],
                                      [NSNumber numberWithInt:iPar4],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    int iPar5=[self SetEnter:iZeroPointFloatArray NameIcon:@"_C.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iPar6=[self SetEnter:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar5],
                                      [NSNumber numberWithInt:iPar6],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    int iPar2=[self SetExit:iZeroPointObArray NameIcon:@"_D.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iPar2],nil]];

}
{//операция "Jmp cycle"----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Jmp_cycle.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_JMP_CYCLE
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iPar1=[self SetEnter:iZeroPointObArray NameIcon:@"0.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self SetEnter:iZeroPointIntArray NameIcon:@"_C.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    int iPar2=[self SetExit:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iPar2],nil]];

}
{//операция "MullPlaces"-----------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_MullPlaces.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_MUL_PLACE
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

    [self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self SetEnter:iZeroPointFloatArray NameIcon:@"_C.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
}
{//операция "MoreMirror"-----------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Mirror.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_MIRROR
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
             icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                        [NSNumber numberWithInt:iPar1],
                                        [NSNumber numberWithInt:iPar2],nil]
                            arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "INC"-----------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Inc.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_INC
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "DEC"-----------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Dec.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_DEC
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "abs"-----------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Abs.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_ABS
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "POW"-----------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Pow.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_POW
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_X.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iPar1=[self SetEnter:iOnePointFloatArray NameIcon:@"_N.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iPar1=[self SetExit:iOnePointFloatArray NameIcon:@"_R.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iPar2=[self SetExit:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
                            arrayEx:[NSArray arrayWithObjects:
                                    [NSNumber numberWithInt:iPar1],
                                    [NSNumber numberWithInt:iPar2],nil]];
}
{//операция "MoreEqual"-----------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_MoreEqual.png"
                    listMatr:GM_DEFAULT nameOperation:NAME_O_MORE_EQUAL
                    withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
//    [self CreateModeIcons:pMatr withIndIcon:&iCurrentIndIcon array:[NSArray arrayWithObjects:
//                                                                    @"m_NothingSrc.png",
//                                                                    @"m_DelSrc.png",nil]];

    int iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar2=[self SetEnter:iZeroPointFloatArray NameIcon:@"_B.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iPar3=[self SetEnter:iZeroPointObArray NameIcon:@"_A.png" matr:pMatr
             icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar4=[self SetEnter:iZeroPointObArray NameIcon:@"_B.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    int iPar5=[self SetExit:iZeroPointObArray NameIcon:@"_Yes.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    int iPar6=[self SetExit:iZeroPointObArray NameIcon:@"_No.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
        
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                        [NSNumber numberWithInt:iPar1],
                                        [NSNumber numberWithInt:iPar3],nil]
                             arrayEx:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar5],
                                      [NSNumber numberWithInt:iPar6],nil]];

    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                    [NSNumber numberWithInt:iPar2],
                                    [NSNumber numberWithInt:iPar4],nil]
                            arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "Less"-----------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_LessEqual.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_LESS_EQUAL
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
//    [self CreateModeIcons:pMatr withIndIcon:&iCurrentIndIcon array:[NSArray arrayWithObjects:
//                                                                    @"m_NothingSrc.png",
//                                                                    @"m_DelSrc.png",nil]];
    
    int iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar2=[self SetEnter:iZeroPointFloatArray NameIcon:@"_B.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
        
    int iPar3=[self SetEnter:iZeroPointObArray NameIcon:@"_A.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar4=[self SetEnter:iZeroPointObArray NameIcon:@"_B.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
        
    int iPar5=[self SetExit:iZeroPointObArray NameIcon:@"_Yes.png" matr:pMatr
             icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iPar6=[self SetExit:iZeroPointObArray NameIcon:@"_No.png" matr:pMatr
             icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                        [NSNumber numberWithInt:iPar1],
                                        [NSNumber numberWithInt:iPar3],nil]
                             arrayEx:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar5],
                                      [NSNumber numberWithInt:iPar6],nil]];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar2],
                                      [NSNumber numberWithInt:iPar4],nil]
                            arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "More"-----------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_More.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_MORE
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
        
    int iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar2=[self SetEnter:iZeroPointFloatArray NameIcon:@"_B.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iPar3=[self SetEnter:iZeroPointObArray NameIcon:@"_A.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar4=[self SetEnter:iZeroPointObArray NameIcon:@"_B.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iPar5=[self SetExit:iZeroPointObArray NameIcon:@"_Yes.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iPar6=[self SetExit:iZeroPointObArray NameIcon:@"_No.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar3],nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iPar5],
                        [NSNumber numberWithInt:iPar6],nil]];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar2],
                                      [NSNumber numberWithInt:iPar4],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "Less"-----------------------------------------------------------------------------
        MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Less.png"
                                          listMatr:GM_DEFAULT nameOperation:NAME_O_LESS
                                          withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
        
        int iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                            icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
        int iPar2=[self SetEnter:iZeroPointFloatArray NameIcon:@"_B.png" matr:pMatr
                            icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
        
        int iPar3=[self SetEnter:iZeroPointObArray NameIcon:@"_A.png" matr:pMatr
                            icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
        int iPar4=[self SetEnter:iZeroPointObArray NameIcon:@"_B.png" matr:pMatr
                            icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
        
        int iPar5=[self SetExit:iZeroPointObArray NameIcon:@"_Yes.png" matr:pMatr
                           icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
        
        int iPar6=[self SetExit:iZeroPointObArray NameIcon:@"_No.png" matr:pMatr
                           icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
        
        [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                          [NSNumber numberWithInt:iPar1],
                                          [NSNumber numberWithInt:iPar3],nil]
                   arrayEx:[NSArray arrayWithObjects:
                            [NSNumber numberWithInt:iPar5],
                            [NSNumber numberWithInt:iPar6],nil]];
        
        [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                          [NSNumber numberWithInt:iPar2],
                                          [NSNumber numberWithInt:iPar4],nil]
                   arrayEx:[NSArray arrayWithObjects:nil]];
    }
{//операция "Equal"-----------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Equal.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_EQUAL
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
        
    int iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar2=[self SetEnter:iZeroPointFloatArray NameIcon:@"_B.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iPar3=[self SetEnter:iZeroPointObArray NameIcon:@"_A.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar4=[self SetEnter:iZeroPointObArray NameIcon:@"_B.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iPar5=[self SetExit:iZeroPointObArray NameIcon:@"_Yes.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iPar6=[self SetExit:iZeroPointObArray NameIcon:@"_No.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar3],nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iPar5],
                        [NSNumber numberWithInt:iPar6],nil]];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar2],
                                      [NSNumber numberWithInt:iPar4],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "Not Equal"-----------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_NotEqual.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_NOT_EQUAL
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar2=[self SetEnter:iZeroPointFloatArray NameIcon:@"_B.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iPar3=[self SetEnter:iZeroPointObArray NameIcon:@"_A.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar4=[self SetEnter:iZeroPointObArray NameIcon:@"_B.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iPar5=[self SetExit:iZeroPointObArray NameIcon:@"_Yes.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iPar6=[self SetExit:iZeroPointObArray NameIcon:@"_No.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar3],nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iPar5],
                        [NSNumber numberWithInt:iPar6],nil]];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar2],
                                      [NSNumber numberWithInt:iPar4],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "Switch"-----------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Switch.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_SWITCH
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"_B.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    int iPar3=[self SetExit:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar4=[self SetExit:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar5=[self SetExit:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar6=[self SetExit:iZeroPointObArray NameIcon:@"4.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar7=[self SetExit:iZeroPointObArray NameIcon:@"5.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar8=[self SetExit:iZeroPointObArray NameIcon:@"6.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar9=[self SetExit:iZeroPointObArray NameIcon:@"7.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar10=[self SetExit:iZeroPointObArray NameIcon:@"8.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar11=[self SetExit:iZeroPointObArray NameIcon:@"9.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar12=[self SetExit:iZeroPointObArray NameIcon:@"0.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
                               arrayEx:[NSArray arrayWithObjects:
                                        [NSNumber numberWithInt:iPar3],
                                        [NSNumber numberWithInt:iPar4],
                                        [NSNumber numberWithInt:iPar5],
                                        [NSNumber numberWithInt:iPar6],
                                        [NSNumber numberWithInt:iPar7],
                                        [NSNumber numberWithInt:iPar8],
                                        [NSNumber numberWithInt:iPar9],
                                        [NSNumber numberWithInt:iPar10],
                                        [NSNumber numberWithInt:iPar11],
                                        [NSNumber numberWithInt:iPar12],nil]];
}
{//операция "find"----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Find.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_FIND
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

    int iPar1=[self SetEnter:iZeroPointObArray NameIcon:@"D.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"F.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    int iPar3=[self SetExit:iZeroPointObArray NameIcon:@"_Yes.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iPar4=[self SetExit:iZeroPointObArray NameIcon:@"_No.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    int iPar5=[self SetExit:iZeroPointIntArray NameIcon:@"P.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
                           arrayEx:[NSArray arrayWithObjects:
                                    [NSNumber numberWithInt:iPar3],
                                    [NSNumber numberWithInt:iPar4],
                                    [NSNumber numberWithInt:iPar5],nil]];
}
{//операция "kx+c"----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_kx_plus_c.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_KX_PLUS_C
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_K.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_X.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_C.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    
    iEnd1=[self SetExit:iZeroPointFloatArray NameIcon:@"Y.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetExit:iZeroPointObArray NameIcon:@"4.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iEnd1],
                        [NSNumber numberWithInt:iExd1],nil]];
}
{//операция "плюс"----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"o_plus.png"
                    listMatr:GM_DEFAULT nameOperation:NAME_O_PLUS
                    withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                        [NSNumber numberWithInt:iEnd1],
                                        [NSNumber numberWithInt:iExd1],nil]
                                arrayEx:[NSArray arrayWithObjects:nil]];

    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_B.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                        [NSNumber numberWithInt:iEnd1],
                                        [NSNumber numberWithInt:iExd1],nil]
                                arrayEx:[NSArray arrayWithObjects:nil]];


    iEnd1=[self SetExit:iZeroPointFloatArray NameIcon:@"_C.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetExit:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
                             arrayEx:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]];
}
{//операция "минус"----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Minus.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_MINUS
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_B.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    
    iEnd1=[self SetExit:iZeroPointFloatArray NameIcon:@"_C.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetExit:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iEnd1],
                        [NSNumber numberWithInt:iExd1],nil]];
}
{//операция "умножение"----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Mull.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_MULL
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_B.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    
    iEnd1=[self SetExit:iZeroPointFloatArray NameIcon:@"_C.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetExit:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iEnd1],
                        [NSNumber numberWithInt:iExd1],nil]];
}
{//операция "деления"----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Div.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_DIV
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_B.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    
    iEnd1=[self SetExit:iZeroPointFloatArray NameIcon:@"_C.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetExit:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iEnd1],
                        [NSNumber numberWithInt:iExd1],nil]];
}
{//операция "деления"----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Ostatok.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_DIV_OST
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iEnd1=[self SetEnter:iZeroPointIntArray NameIcon:@"_A.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetEnter:iZeroPointIntArray NameIcon:@"_B.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    
    iEnd1=[self SetExit:iZeroPointIntArray NameIcon:@"_C.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetExit:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iEnd1],
                        [NSNumber numberWithInt:iExd1],nil]];
}
{//операция "+="----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_PlusEqual.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_PLUS_EQUAL
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
                           arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetExit:iZeroPointFloatArray NameIcon:@"_B.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetExit:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
                           arrayEx:[NSArray arrayWithObjects:
                                    [NSNumber numberWithInt:iEnd1],
                                    [NSNumber numberWithInt:iExd1],nil]];
}
{//операция "-="----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_MinusEqual.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_MINUS_EQUAL
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetExit:iZeroPointFloatArray NameIcon:@"_B.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetExit:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iEnd1],
                        [NSNumber numberWithInt:iExd1],nil]];
}
{//операция "*="----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_MullEqual.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_MUL_EQUAL
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetExit:iZeroPointFloatArray NameIcon:@"_B.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetExit:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iEnd1],
                        [NSNumber numberWithInt:iExd1],nil]];
}
{//операция "/="----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_DivEqual.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_DIV_EQUAL
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetExit:iZeroPointFloatArray NameIcon:@"_B.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetExit:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iEnd1],
                        [NSNumber numberWithInt:iExd1],nil]];
}
{//операция "%="----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_OstatokEqual.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_DIV_OST_EQUAL
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetExit:iZeroPointFloatArray NameIcon:@"_B.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetExit:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iEnd1],
                        [NSNumber numberWithInt:iExd1],nil]];
}
{//операция "dist"----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Dist.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_DIST
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

    int iEnt1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_X.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iEnt2=[self SetEnter:iZeroPointObArray NameIcon:@"_S.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnt1],
                                      [NSNumber numberWithInt:iEnt2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    
    iEnt1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_Y.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iEnt2=[self SetEnter:iZeroPointObArray NameIcon:@"_S.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnt1],
                                      [NSNumber numberWithInt:iEnt2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];


    iEnt1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_X.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iEnt2=[self SetEnter:iZeroPointObArray NameIcon:@"_F.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnt1],
                                      [NSNumber numberWithInt:iEnt2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    

    iEnt1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_Y.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iEnt2=[self SetEnter:iZeroPointObArray NameIcon:@"_F.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnt1],
                                      [NSNumber numberWithInt:iEnt2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    

    int iExt1=[self SetExit:iZeroPointFloatArray NameIcon:@"_R.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iExt2=[self SetExit:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iExt1],
                        [NSNumber numberWithInt:iExt2],nil]];
}
{//операция "Mull Scalar"------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_MullScalar.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_MUL_SCALAR
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

    int iEnt1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_X.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iEnt2=[self SetEnter:iZeroPointObArray NameIcon:@"_S.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnt1],
                                      [NSNumber numberWithInt:iEnt2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    
    iEnt1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_Y.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iEnt2=[self SetEnter:iZeroPointObArray NameIcon:@"_S.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnt1],
                                      [NSNumber numberWithInt:iEnt2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    
    iEnt1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_X.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iEnt2=[self SetEnter:iZeroPointObArray NameIcon:@"_F.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnt1],
                                      [NSNumber numberWithInt:iEnt2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    
    iEnt1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_Y.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iEnt2=[self SetEnter:iZeroPointObArray NameIcon:@"_F.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnt1],
                                      [NSNumber numberWithInt:iEnt2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    
    iEnt1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_X.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iEnt2=[self SetEnter:iZeroPointObArray NameIcon:@"_S.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnt1],
                                      [NSNumber numberWithInt:iEnt2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    
    iEnt1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_Y.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iEnt2=[self SetEnter:iZeroPointObArray NameIcon:@"_S.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnt1],
                                      [NSNumber numberWithInt:iEnt2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    
    iEnt1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_X.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iEnt2=[self SetEnter:iZeroPointObArray NameIcon:@"_F.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnt1],
                                      [NSNumber numberWithInt:iEnt2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    
    iEnt1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_Y.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iEnt2=[self SetEnter:iZeroPointObArray NameIcon:@"_F.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnt1],
                                      [NSNumber numberWithInt:iEnt2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    
    int iExt1=[self SetExit:iZeroPointFloatArray NameIcon:@"_R.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iExt2=[self SetExit:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iExt1],
                        [NSNumber numberWithInt:iExt2],nil]];
}
{//операция "Angle vectors"---------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Angle.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_ANGLE
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iEnt1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_X.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iEnt2=[self SetEnter:iZeroPointObArray NameIcon:@"_S.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnt1],
                                      [NSNumber numberWithInt:iEnt2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    
    iEnt1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_Y.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iEnt2=[self SetEnter:iZeroPointObArray NameIcon:@"_S.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnt1],
                                      [NSNumber numberWithInt:iEnt2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    
    iEnt1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_X.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iEnt2=[self SetEnter:iZeroPointObArray NameIcon:@"_F.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnt1],
                                      [NSNumber numberWithInt:iEnt2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    
    iEnt1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_Y.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iEnt2=[self SetEnter:iZeroPointObArray NameIcon:@"_F.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnt1],
                                      [NSNumber numberWithInt:iEnt2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    
    iEnt1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_X.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iEnt2=[self SetEnter:iZeroPointObArray NameIcon:@"_S.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnt1],
                                      [NSNumber numberWithInt:iEnt2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    
    iEnt1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_Y.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iEnt2=[self SetEnter:iZeroPointObArray NameIcon:@"_S.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnt1],
                                      [NSNumber numberWithInt:iEnt2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    
    iEnt1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_X.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iEnt2=[self SetEnter:iZeroPointObArray NameIcon:@"_F.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnt1],
                                      [NSNumber numberWithInt:iEnt2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    
    iEnt1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_Y.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iEnt2=[self SetEnter:iZeroPointObArray NameIcon:@"_F.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnt1],
                                      [NSNumber numberWithInt:iEnt2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    
    int iExt1=[self SetExit:iZeroPointFloatArray NameIcon:@"_R.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iExt2=[self SetExit:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iExt1],
                        [NSNumber numberWithInt:iExt2],nil]];
}
{//операция "update DL"--------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Set_DL_point.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_DL_XY
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_X.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_Y.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    
    iEnd1=[self SetEnter:iZeroPointSpriteArray NameIcon:@"_S.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:0];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "update DR"--------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Set_DR_point.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_DR_XY
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_X.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_Y.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    iEnd1=[self SetEnter:iZeroPointSpriteArray NameIcon:@"_S.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:0];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "update UL"--------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Set_UL_point.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_UL_XY
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_X.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_Y.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    
    iEnd1=[self SetEnter:iZeroPointSpriteArray NameIcon:@"_S.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:0];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "update UR"--------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Set_UR_point.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_UR_XY
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_X.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_Y.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    
    iEnd1=[self SetEnter:iZeroPointSpriteArray NameIcon:@"_S.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:0];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "update UL tex"--------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Set_UL_texture.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_UL_UV_TEX
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_X.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_Y.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    
    iEnd1=[self SetEnter:iZeroPointSpriteArray NameIcon:@"_S.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:0];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "update UR tex"--------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Set_UR_texture.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_UR_UV_TEX
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_X.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_Y.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    
    iEnd1=[self SetEnter:iZeroPointSpriteArray NameIcon:@"_S.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:0];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "update DL tex"--------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Set_DL_texture.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_DL_UV_TEX
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_X.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_Y.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    
    iEnd1=[self SetEnter:iZeroPointSpriteArray NameIcon:@"_S.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:0];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "update DR tex"--------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Set_DR_texture.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_DR_UV_TEX
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_X.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_Y.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    
    iEnd1=[self SetEnter:iZeroPointSpriteArray NameIcon:@"_S.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:0];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "update"--------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_updateSprite.png"
                    listMatr:GM_DEFAULT nameOperation:NAME_O_UPDATE_XY
                    withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_X.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
                               arrayEx:[NSArray arrayWithObjects:nil]];

    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_Y.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_W.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_H.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"4.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"5.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    iEnd1=[self SetEnter:iZeroPointSpriteArray NameIcon:@"_S.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:0];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"6.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "updateColor"--------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Color.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_UPDATE_COLOR
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iEnd1=[self SetEnter:iOnePointFloatArray NameIcon:@"_R.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetEnter:iOnePointFloatArray NameIcon:@"_G.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetEnter:iOnePointFloatArray NameIcon:@"_B.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetEnter:iOnePointFloatArray NameIcon:@"_A.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"4.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
        
    iEnd1=[self SetEnter:iZeroPointSpriteArray NameIcon:@"_S.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:0];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"5.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "Sin"--------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Sin.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_SIN
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_P.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    iEnd1=[self SetEnter:iOnePointFloatArray NameIcon:@"_M.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    iEnd1=[self SetEnter:iOnePointFloatArray NameIcon:@"_A.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_O.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"4.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetExit:iZeroPointFloatArray NameIcon:@"_R.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetExit:iZeroPointObArray NameIcon:@"5.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iEnd1],
                        [NSNumber numberWithInt:iExd1],nil]];
}
{//операция "Cos"--------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Cos.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_COS
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_P.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetEnter:iOnePointFloatArray NameIcon:@"_M.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    iEnd1=[self SetEnter:iOnePointFloatArray NameIcon:@"_A.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_O.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"4.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetExit:iZeroPointFloatArray NameIcon:@"_R.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetExit:iZeroPointObArray NameIcon:@"5.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iEnd1],
                        [NSNumber numberWithInt:iExd1],nil]];
}
{//операция "tg"--------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Tg.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_TG
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_P.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetEnter:iOnePointFloatArray NameIcon:@"_M.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetEnter:iOnePointFloatArray NameIcon:@"_A.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_O.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"4.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetExit:iZeroPointFloatArray NameIcon:@"_R.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetExit:iZeroPointObArray NameIcon:@"5.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iEnd1],
                        [NSNumber numberWithInt:iExd1],nil]];
}
{//операция "aSin"--------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_aSin.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_ASIN
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_S.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iEnd2=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iEnd2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    int iExd1=[self SetExit:iZeroPointFloatArray NameIcon:@"_R.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iExd2=[self SetExit:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iExd1],
                                      [NSNumber numberWithInt:iExd2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "aCos"--------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_aCos.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_ACOS
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_S.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iEnd2=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iEnd2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    int iExd1=[self SetExit:iZeroPointFloatArray NameIcon:@"_R.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iExd2=[self SetExit:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iExd1],
                                      [NSNumber numberWithInt:iExd2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "aTan"--------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_aTan.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_ATAN
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_S.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iEnd2=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iEnd2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    int iExd1=[self SetExit:iZeroPointFloatArray NameIcon:@"_R.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iExd2=[self SetExit:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iExd1],
                                      [NSNumber numberWithInt:iExd2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
}
//{//операция "draw Ex"----------------------------------------------------------------------------------
//    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Draw_ex.png"
//                                      listMatr:GM_DEFAULT nameOperation:NAME_O_DRAW_EX
//                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
//    
//    int iEnd1=[self SetEnter:iZeroPointTextureArray NameIcon:@"_T.png" matr:pMatr
//                        icon:&iCurrentIndIcon iPar:0];
////    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
////                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
////    
////    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
////                                      [NSNumber numberWithInt:iEnd1],
////                                      [NSNumber numberWithInt:iExd1],nil]
////               arrayEx:[NSArray arrayWithObjects:nil]];
//    
//    iEnd1=[self SetEnter:iZeroPointSpriteArray NameIcon:@"_S.png" matr:pMatr
//                    icon:&iCurrentIndIcon iPar:0];
//    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
//                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
//    
//    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
//                                      [NSNumber numberWithInt:iEnd1],
//                                      [NSNumber numberWithInt:iExd1],nil]
//               arrayEx:[NSArray arrayWithObjects:nil]];
//}
{//операция "draw"----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_draw.png"
                    listMatr:GM_DEFAULT nameOperation:NAME_O_DRAW
                    withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

    int iEnd1=[self SetEnter:iZeroPointTextureArray NameIcon:@"_T.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:0];
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
             icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    iEnd1=[self SetEnter:iZeroPointSpriteArray NameIcon:@"_S.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:0];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
             icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "Прямолинейное движение"----------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_DeltaT.png"
                    listMatr:GM_DEFAULT nameOperation:NAME_O_DELTA_T
                    withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

    int iEnd1=[self SetEnter:iOnePointFloatArray NameIcon:@"_V.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
             icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    iEnd1=[self SetEnter:iOnePointFloatArray NameIcon:@"_M.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    iEnd1=[self SetExit:iZeroPointFloatArray NameIcon:@"_R.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    iExd1=[self SetExit:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
             icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
                           arrayEx:[NSArray arrayWithObjects:
                                    [NSNumber numberWithInt:iEnd1],
                                    [NSNumber numberWithInt:iExd1],nil]];
}
{//операция "size"---------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Size.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_SIZE
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

    [self SetEnter:iZeroPointMatrix NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self SetExit:iZeroPointFloatArray NameIcon:@"_R.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
}
{//операция "size"---------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Sum.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_SUMMA
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"1.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iEnd2=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iEnd2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    [self SetExit:iZeroPointFloatArray NameIcon:@"_R.png" matr:pMatr
             icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
}
{//операция "clear space"---------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Clear.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_CLEAR_SPACE
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iEnd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iExd1=[self SetExit:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],nil]
                            arrayEx:[NSArray arrayWithObjects:
                                     [NSNumber numberWithInt:iExd1],nil]];
}
{//операция "i to space"---------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_I_to_space.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_I_TO_PL
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

    int iEnd1=[self SetEnter:iZeroPointIntArray NameIcon:@"_I.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self SetExit:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
                                arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "space to i"---------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_space_to_i.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_PL_TO_I
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    [self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iEnd1=[self SetExit:iZeroPointIntArray NameIcon:@"_I.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    int iExd1=[self SetExit:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                       icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iEnd1],
                        [NSNumber numberWithInt:iExd1],nil]];
}
{//операция "string"-------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_String.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_STRING
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    
    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_B.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_C.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_D.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"4.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_X.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"5.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetExit:iZeroPointFloatArray NameIcon:@"_Y.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetExit:iZeroPointObArray NameIcon:@"6.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iEnd1],
                        [NSNumber numberWithInt:iExd1],nil]];
}
{//операция "spline"-------------------------------------------------------------------------------
        MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_spline.png"
                                          listMatr:GM_DEFAULT nameOperation:NAME_O_SPLINE
                                          withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
        
        int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                            icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
        
        int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"_X.png" matr:pMatr
                            icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
        
        [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                          [NSNumber numberWithInt:iEnd1],
                                          [NSNumber numberWithInt:iExd1],nil]
                   arrayEx:[NSArray arrayWithObjects:nil]];

        iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                            icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
        
        iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"_Y.png" matr:pMatr
                            icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
        
        [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                          [NSNumber numberWithInt:iEnd1],
                                          [NSNumber numberWithInt:iExd1],nil]
                   arrayEx:[NSArray arrayWithObjects:nil]];

    
        iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_B.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
        
        iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"_X.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
        
        [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                          [NSNumber numberWithInt:iEnd1],
                                          [NSNumber numberWithInt:iExd1],nil]
                   arrayEx:[NSArray arrayWithObjects:nil]];

        iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_B.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
        
        iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"_Y.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
        
        [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                          [NSNumber numberWithInt:iEnd1],
                                          [NSNumber numberWithInt:iExd1],nil]
                   arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_C.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"_X.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_C.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"_Y.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    
    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_D.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"_X.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_D.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"_Y.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];


    iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_T.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"0.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
//-------------------------------------------------------------------------------------------------
    iEnd1=[self SetExit:iZeroPointFloatArray NameIcon:@"_R.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetExit:iZeroPointObArray NameIcon:@"_X.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iEnd1],
                        [NSNumber numberWithInt:iExd1],nil]];

    iEnd1=[self SetExit:iZeroPointFloatArray NameIcon:@"_R.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetExit:iZeroPointObArray NameIcon:@"_Y.png" matr:pMatr
                   icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
               arrayEx:[NSArray arrayWithObjects:
                        [NSNumber numberWithInt:iEnd1],
                        [NSNumber numberWithInt:iExd1],nil]];
}
{//операция "RND"----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Rnd.png"
                    listMatr:GM_DEFAULT nameOperation:NAME_O_RND
                    withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_S.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    iEnd1=[self SetEnter:i100PointFloatArray NameIcon:@"_F.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    iEnd1=[self SetEnter:iOnePointFloatArray NameIcon:@"_S.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"3.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    iEnd1=[self SetExit:iZeroPointFloatArray NameIcon:@"_R.png" matr:pMatr
              icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iExd1=[self SetExit:iZeroPointObArray NameIcon:@"4.png" matr:pMatr
             icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:nil]
                           arrayEx:[NSArray arrayWithObjects:
                                    [NSNumber numberWithInt:iEnd1],
                                    [NSNumber numberWithInt:iExd1],nil]];

}
{//операция "Rnd Minus"-----------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Rnd_minus.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_RND_MINUS
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iPar1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "Rnd Queue"-----------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Rnd_Queue.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_RND_QUEUE
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    [self SetEnter:iZeroPointFloatArray NameIcon:@"_C.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"_S.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    int iPar3=[self SetExit:iZeroPointObArray NameIcon:@"_D.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];

    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar2],nil]
                            arrayEx:[NSArray arrayWithObjects:
                                        [NSNumber numberWithInt:iPar3],nil]];
}
{//операция "%="----------------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Number.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_NUMBER
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];

    int iEnd1=[self SetEnter:iZeroPointFloatArray NameIcon:@"_A.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iExd1=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iEnd1],
                                      [NSNumber numberWithInt:iExd1],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "Play Sound"-----------------------------------------------------------------------------
    MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Sound.png"
                                      listMatr:GM_DEFAULT nameOperation:NAME_O_PLAY_SOUND
                                      withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
    
    int iPar1=[self SetEnter:iZeroPointSoundArray NameIcon:@"_A.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    int iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"0.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
    
    iPar1=[self SetEnter:iOnePointFloatArray NameIcon:@"_P.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"1.png" matr:pMatr
                        icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];

    iPar1=[self SetEnter:iOnePointFloatArray NameIcon:@"_V.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    iPar2=[self SetEnter:iZeroPointObArray NameIcon:@"2.png" matr:pMatr
                    icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
    
    [self setPairParOb:pMatr arrayEn:[NSArray arrayWithObjects:
                                      [NSNumber numberWithInt:iPar1],
                                      [NSNumber numberWithInt:iPar2],nil]
               arrayEx:[NSArray arrayWithObjects:nil]];
}
{//операция "Procedure"-----------------------------------------------------------------------------
        MATRIXcell *pMatr=[self SetOperationMatrix:pStartDataListMatr nameTex:@"_Proc.png"
                                          listMatr:GM_DEFAULT nameOperation:NAME_O_PROCEDURE
                                          withMatr:pMatrOperations withIndIcon:&iCurrentIndIcon];
        
        [self SetEnter:iZeroPointIntArray NameIcon:@"1.png" matr:pMatr
                            icon:&iCurrentIndIcon iPar:&iCurrentIndPar];
}
//=================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////
}
//------------------------------------------------------------------------------------------------------
@end
