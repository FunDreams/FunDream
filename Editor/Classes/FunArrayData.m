//
//  FunArrayData.m
//  FunDreams
//
//  Created by Konstantin Maximov on 24.04.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import "FunArrayData.h"
#import "Ob_ParticleCont_ForStr.h"
#import "Kernel.h"
#import "MainCycle.h"
#import "Ob_Cont_Res.h"
//------------------------------------------------------------------------------------------
@implementation FunArrayData
//------------------------------------------------------------------------------------------
-(id)initWithCopasity:(int)iCopasity{

    self = [super init];

    if(self){

        m_bFirstMatrix=NO;
        m_bSaveKernel=NO;
        
        pFreeArray = [[NSMutableArray alloc] init];
        
        iCountInc=1000;
        iCount=0;
        iCountInArray=0;
        pDataSrc=0;
        pTypeSrc=0;
        
        pNamesOb = [[NSMutableDictionary alloc] init];
        pNamesValue = [[NSMutableDictionary alloc] init];
        pMartixDic = [[NSMutableDictionary alloc] init];
        pDicRename = [[NSMutableDictionary alloc] init];
        DicAllAssociations = [[NSMutableDictionary alloc] init];
        
        ppAllArrays =[[NSMutableDictionary alloc] init];
        
        if(iCopasity>0)
            [self Increase:iCopasity];
    }
    
    return self;
}
//------------------------------------------------------------------------------------------
-(void)PostInit:(StringContainer*)PContainer{
    iCountInc=100;
    pParent=PContainer;

    ppHelpData=[pParent->m_OperationIndex InitMemory];
    ppListMatrix=[pParent->m_OperationIndex InitMemory];
    
    ppIndexNeedDelTex=[pParent->m_OperationIndex InitMemory];
    ppIndexNeedDelSound=[pParent->m_OperationIndex InitMemory];
    ppIndexNeedDelPar=[pParent->m_OperationIndex InitMemory];
    ppFreeArrayEx = [pParent->m_OperationIndex InitMemory];

}
//------------------------------------------------------------------------------------------
- (void)SetSrc:(FunArrayData *)pSourceData{
    pDataSrc=pSourceData->pData;
    pTypeSrc=pSourceData->pType;
    pDataIntSrc=pSourceData->pDataInt;
    pCurrenContParSrc=pSourceData->pCurrenContPar;
}
//------------------------------------------------------------------------------------------
- (void)Increase:(int)CountInc{
    
    int FirstIndex=iCount;
    iCount+=CountInc;
    
    float *TmpData=pData;
    pData=realloc(pData,iCount*sizeof(float));
    pDataInt=realloc(pDataInt,iCount*sizeof(int));
    pType=realloc(pType,iCount*sizeof(unsigned char));
    
    if(pDataSrc==TmpData){
        pDataSrc=pData;
        pTypeSrc=pType;
        pDataIntSrc=pDataInt;
        
        pParent->pMainCycle->pppData=(int ***)pData;
        pParent->pMainCycle->pDataLocal=pData;
        pParent->pMainCycle->pIDataLocal=(int *)pData;
    }
    
    for (int i=0; i<CountInc; i++) {
        
        int Index=FirstIndex+i;

        NSNumber *pNum=[NSNumber numberWithInt:Index];
        [pFreeArray addObject:pNum];
        
        [pParent->m_OperationIndex OnlyAddData:Index WithData:ppFreeArrayEx];
        
        *(pDataInt+FirstIndex+i)=0;
        *(pData+FirstIndex+i)=0;
        *(pType+FirstIndex+i)=0;
    }
}
//------------------------------------------------------------------------------------------
- (void)Reserv:(int)iCountTmp{
    iCount=iCountTmp;
    
    float *TmpData=pData;
    pData=malloc(iCountTmp*sizeof(float));
    pDataInt=malloc(iCountTmp*sizeof(int));
    pType=malloc(iCountTmp*sizeof(unsigned char));

    if(pDataSrc==TmpData){
        pDataSrc=pData;
        pTypeSrc=pType;
        pDataIntSrc=pDataInt;
        
        pParent->pMainCycle->pppData=(int ***)pData;
        pParent->pMainCycle->pDataLocal=pData;
        pParent->pMainCycle->pIDataLocal=(int *)pData;
    }

    memset(pData, 0, iCountTmp*sizeof(float));
    memset(pDataInt, 0, iCountTmp*sizeof(int));
    memset(pType, 0, iCountTmp*sizeof(unsigned char));
}
//------------------------------------------------------------------------------------------
- (int)GetFree{
    
    InfoArrayValue *pInfo=(InfoArrayValue *)(*ppFreeArrayEx);
    int *Sdata=((*ppFreeArrayEx)+SIZE_INFO_STRUCT);

    if(pInfo->mCount==0)
    {
        [self Increase:iCountInc];
    }
    
    pInfo=(InfoArrayValue *)(*ppFreeArrayEx);
    Sdata=((*ppFreeArrayEx)+SIZE_INFO_STRUCT);

    int IndexFree2=Sdata[pInfo->mCount-1];
    pInfo->mCount--;
    return IndexFree2;
    
//    if([pFreeArray count]==0){
//        [self Increase:iCountInc];
//    }
//    
//    NSNumber *pNum=[pFreeArray objectAtIndex:0];
//    int IndexFree=[pNum intValue];
//    [pFreeArray removeObjectAtIndex:0];
//    return IndexFree;
}
//------------------------------------------------------------------------------------------
- (int)LinkDataAtIndex:(int)iIndex{
    
 //   [self IncDataAtIndex:iIndex];

    return iIndex;
}
//------------------------------------------------------------------------------------------
- (int)CopyDataAtIndex:(int)iIndex{
    BYTE bType=(*(pTypeSrc+iIndex));
    float *pDataTmp=(pDataSrc+iIndex);

    int iRetIndex=0;
    
    if(iIndex<=pParent->iIndexMaxSys)//если индекс-константа то её переименовывать не надо
    {
        iRetIndex=iIndex;
    }
    else {
        switch (bType) {
            case DATA_ID:                
                iRetIndex = [self SetOb:*((id *)pDataTmp)];
            break;

            case DATA_ARRAY:
                iRetIndex = [self SetArray:*((int ***)pDataTmp)];
            break;
                
//            case DATA_INDEX_OB:
//                iRetIndex = [self SetIndexOb:*((int ***)pDataTmp)];
//                break;

            case DATA_MATRIX:
                iRetIndex = [self SetMatrix:*((MATRIXcell **)pDataTmp)];
            break;

            case DATA_FLOAT:
                iRetIndex = [self SetFloat:*pDataTmp];
                break;

            case DATA_INT:
                iRetIndex = [self SetInt:*((int *)pDataTmp)];
                break;

//            case DATA_U_INT:
//                iRetIndex = [self SetUInt:*((unsigned int *)pDataTmp)];
//                break;

            case DATA_STRING:
            {
                NSMutableString *TmpString=[[NSMutableString alloc]
                                            initWithString:*((NSMutableString **)pDataTmp)];

                iRetIndex = [self SetName:TmpString];
            }
                break;

            case DATA_SPRITE:
                iRetIndex = [self SetSprite:iIndex];
                break;
                
            case DATA_TEXTURE:
            {                
                iRetIndex = [self SetTexture:iIndex];
            }
            break;

            case DATA_SOUND:
            {
                iRetIndex = [self SetSound:iIndex];
            }
            break;

            default:
                break;
        }
    }
        
    return iRetIndex;
}
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
- (int)SetFloat:(float)DataValue{

    int iIndex=[self GetFree];
    
    float *TmpLink=pData+iIndex;
    
    *TmpLink=DataValue;

    (*(pType+iIndex))=DATA_FLOAT;

    return iIndex;
}
//------------------------------------------------------------------------------------------
- (int)SetInt:(int)DataValue{
    
    int iIndex=[self GetFree];
    
    int *TmpLink=(int *)pData+iIndex;
    
    *TmpLink=DataValue;
    
    (*(pType+iIndex))=DATA_INT;
    
    return iIndex;
}
//------------------------------------------------------------------------------------------
- (int)SetIndexOb:(int **)DataArray{
    int iIndex=[self GetFree];
        
//    int **ppArray =[pParent->m_OperationIndex InitMemory];
//    [pParent->m_OperationIndex InitStructure:ppArray];
//    InfoArrayValue *InfoStr=(InfoArrayValue *)(*ppArray);
//    InfoStr->mFlags&=F_ORDER;
//    
//    int *TmpLink=(int *)(pData+iIndex);
//    *TmpLink=ppArray;
//    (*(pType+iIndex))=DATA_ARRAY;
//    
//    NSNumber *pVal = [NSNumber numberWithInt:iIndex];
//    [ppAllArrays setObject:pVal forKey:pVal];
//    
//    InfoStr->mType=DATA_U_INT;
//    (*(pType+iIndex))=DATA_INDEX_OB;
    
    return iIndex;
}
//------------------------------------------------------------------------------------------
- (int)SetSprite:(int)IndexSprite{
    
    int iIndex=[self GetFree];
    
    int *TmpLink=(int *)pData+iIndex;
    int indexParticle=0;
    
    indexParticle=[pCurrenContPar CreateParticle];
    [pParent->m_OperationIndex OnlyAddData:iIndex WithData:pCurrenContPar->pIndexParticles];

    if(IndexSprite==0)
    {
        [pCurrenContPar SetDefaultVertex:indexParticle];
    }
    else
    {
        int TmpSrcPlace=*((int *)pDataSrc+IndexSprite);
        [pCurrenContPar CopySprite:indexParticle source:TmpSrcPlace];
    }
    
    *TmpLink=indexParticle;
    (*(pType+iIndex))=DATA_SPRITE;
    
    return iIndex;
}
//------------------------------------------------------------------------------------------
- (int)SetTexture:(int)IndexTexture{
    
    int iIndex=[self GetFree];
    
    float *TmpLink=pData+iIndex;
    float indexTextureTmp=0;
    
    if(IndexTexture==0)
    {
        indexTextureTmp=[pCurrenContParSrc->pTexRes CreateResTexture:@"0.png"];
    }
    else
    {
        float TmpSrcPlace=*(pDataSrc+IndexTexture);
        ResourceCell *pTmpCell=pCurrenContParSrc->pTexRes->pCells+(int)TmpSrcPlace;

        if(pTmpCell!=0)
            indexTextureTmp=[pCurrenContPar->pTexRes CreateResTexture:pTmpCell->sName];
        else indexTextureTmp=[pCurrenContPar->pTexRes CreateResTexture:@"0.png"];
    }
    
    [pParent->m_OperationIndex OnlyAddData:iIndex WithData:pCurrenContPar->pTexRes->pIndexRes];
    *TmpLink=indexTextureTmp;
    (*(pType+iIndex))=DATA_TEXTURE;
    
    return iIndex;
}
//------------------------------------------------------------------------------------------
- (int)SetSound:(int)IndexSound{
    
    int iIndex=[self GetFree];
    
    float *TmpLink=pData+iIndex;
    float indexTextureTmp=0;
    
    if(IndexSound==0)
    {
        indexTextureTmp=[pCurrenContParSrc->pSoundRes CreateResSound:@"0.wav"];
    }
    else
    {
        float TmpSrcPlace=*(pDataSrc+IndexSound);
        ResourceCell *pTmpCell=pCurrenContParSrc->pSoundRes->pCells+(int)TmpSrcPlace;
        
        if(pTmpCell!=0)
            indexTextureTmp=[pCurrenContPar->pSoundRes CreateResSound:pTmpCell->sName];
        else indexTextureTmp=[pCurrenContPar->pSoundRes CreateResSound:@"0.wav"];
        
    }
    
    [pParent->m_OperationIndex OnlyAddData:iIndex WithData:pCurrenContPar->pSoundRes->pIndexRes];
    *TmpLink=indexTextureTmp;
    (*(pType+iIndex))=DATA_SOUND;
    
    return iIndex;
}
//------------------------------------------------------------------------------------------
- (int)SetName:(NSMutableString *)DataValue{
    
    int iIndex=[self GetFree];
        
    NSString *pKey = [NSString stringWithFormat:@"%d",iIndex];
    [pNamesValue setValue:DataValue forKey:pKey];
    
    id *TmpLink=(id *)(pData+iIndex);
    *(TmpLink)=DataValue;
        
    (*(pType+iIndex))=DATA_STRING;
    
    return iIndex;
}
//------------------------------------------------------------------------------------------
-(int)CreateArrayByIndex:(int)iIndex withType:(unsigned char)iTypeArray{
        
    int **ppArray =[pParent->m_OperationIndex InitMemory];    
    [pParent->m_OperationIndex InitStructure:ppArray];
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*ppArray);
    InfoStr->mType=iTypeArray;
    InfoStr->mFlags|=(F_ORDER|F_DATA);
    
    int *TmpLink=(int *)(pData+iIndex);
    *TmpLink=ppArray;
    (*(pType+iIndex))=DATA_ARRAY;
    
    NSNumber *pVal = [NSNumber numberWithInt:iIndex];
    [ppAllArrays setObject:pVal forKey:pVal];
    
    return iIndex;
}
//------------------------------------------------------------------------------------------
- (int)SetOb:(FractalString *)DataValue{
    
    int iIndex=[self GetFree];
    
    NSString *pKey = [NSString stringWithFormat:@"%d",iIndex];
    [pNamesOb setValue:DataValue->strUID forKey:pKey];

    id *TmpLink=(id *)(pData+iIndex);
    *(TmpLink)=DataValue;

    (*(pType+iIndex))=DATA_ID;

    return iIndex;
}
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
- (void)ReleaseMemoryHeart:(HeartMatr *)pHeart{
    
    free(*pHeart->pEnPairPar);
    free(pHeart->pEnPairPar);

    free(*pHeart->pEnPairChi);
    free(pHeart->pEnPairChi);

    free(*pHeart->pExPairPar);
    free(pHeart->pExPairPar);

    free(*pHeart->pExPairChi);
    free(pHeart->pExPairChi);

    free(*pHeart->pModes);
    free(pHeart->pModes);
}
//------------------------------------------------------------------------------------------
- (void)InitMemoryHeart:(HeartMatr *)pHeart parent:(MATRIXcell *)pMatr{
    if(pParent==nil)return;
        
    pHeart->pEnPairPar = [pParent->m_OperationIndex InitMemory];
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pHeart->pEnPairPar);
    InfoStr->UnParentMatrix.ParentMatrix=pMatr;
    InfoStr->mFlags|=F_SYS;

    pHeart->pEnPairChi = [pParent->m_OperationIndex InitMemory];
    InfoStr=(InfoArrayValue *)(*pHeart->pEnPairChi);
    InfoStr->UnParentMatrix.ParentMatrix=pMatr;
    InfoStr->mFlags|=F_SYS;

    pHeart->pExPairPar = [pParent->m_OperationIndex InitMemory];
    InfoStr=(InfoArrayValue *)(*pHeart->pExPairPar);
    InfoStr->UnParentMatrix.ParentMatrix=pMatr;
    InfoStr->mFlags|=F_SYS;

    pHeart->pExPairChi = [pParent->m_OperationIndex InitMemory];
    InfoStr=(InfoArrayValue *)(*pHeart->pExPairChi);
    InfoStr->UnParentMatrix.ParentMatrix=pMatr;
    InfoStr->mFlags|=F_SYS;

    pHeart->pModes = [pParent->m_OperationIndex InitMemory];
    InfoStr=(InfoArrayValue *)(*pHeart->pModes);
    InfoStr->UnParentMatrix.ParentMatrix=pMatr;
    InfoStr->mFlags|=F_SYS;
    
    pHeart->pNextPlace=-1;
}
//------------------------------------------------------------------------------------------
- (void)InitMemoryMatrix:(MATRIXcell *)pMatr{
    
    if(pParent==nil)return;
    
    //паренты
    pMatr->pLinks = [pParent->m_OperationIndex InitMemory];
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pMatr->pLinks);
    InfoStr->UnParentMatrix.ParentMatrix=pMatr;
    InfoStr->mFlags|=F_SYS;

    //чилды
    pMatr->pValueCopy = [pParent->m_OperationIndex InitMemory];
    InfoStr=(InfoArrayValue *)(*pMatr->pValueCopy);
    InfoStr->UnParentMatrix.ParentMatrix=pMatr;
    InfoStr->mFlags|=F_SYS;

    //входные параметны
    pMatr->pEnters = [pParent->m_OperationIndex InitMemory];
    InfoStr=(InfoArrayValue *)(*pMatr->pEnters);
    InfoStr->UnParentMatrix.ParentMatrix=pMatr;
    InfoStr->mFlags|=F_SYS;

    //выходные параметны
    pMatr->pExits = [pParent->m_OperationIndex InitMemory];
    InfoStr=(InfoArrayValue *)(*pMatr->pExits);
    InfoStr->UnParentMatrix.ParentMatrix=pMatr;
    InfoStr->mFlags|=F_SYS;

    //связи
    pMatr->pQueue = [pParent->m_OperationIndex InitMemory];
    InfoStr=(InfoArrayValue *)(*pMatr->pQueue);
    InfoStr->UnParentMatrix.ParentMatrix=pMatr;
    InfoStr->mFlags|=F_SYS;

    //точки входа
    pMatr->ppStartPlaces = [pParent->m_OperationIndex InitMemory];
    InfoStr=(InfoArrayValue *)(*pMatr->ppStartPlaces);
    InfoStr->UnParentMatrix.ParentMatrix=pMatr;
    InfoStr->mFlags|=F_SYS;

    //активные пространства
    pMatr->ppActivitySpace = [pParent->m_OperationIndex InitMemory];
    InfoStr=(InfoArrayValue *)(*pMatr->ppActivitySpace);
    InfoStr->UnParentMatrix.ParentMatrix=pMatr;
    InfoStr->mFlags|=F_SYS;

    //матрица данных
    pMatr->ppDataMartix = [pParent->m_OperationIndex InitMemory];
    InfoStr=(InfoArrayValue *)(*pMatr->ppDataMartix);
    InfoStr->UnParentMatrix.ParentMatrix=pMatr;
    InfoStr->mFlags|=F_SYS;
    
    [pParent->m_OperationIndex OnlyAddData:(-1) WithData:pMatr->ppStartPlaces];
    [pParent->m_OperationIndex OnlyAddData:(-1) WithData:pMatr->ppActivitySpace];
    
    pMatr->TypeInformation=STR_COMPLEX;
    pMatr->NameInformation=0;
    pMatr->iIndexSelf=0;
    pMatr->iDimMatrix=1;
}
//------------------------------------------------------------------------------------------------------
-(void)CopyHeartData:(HeartMatr *)pHeartSelf from:(HeartMatr *)pHeartData{
    
    [pParent->m_OperationIndex CopyDataFrom:pHeartData->pEnPairPar To:pHeartSelf->pEnPairPar];
    [pParent->m_OperationIndex CopyDataFrom:pHeartData->pEnPairChi To:pHeartSelf->pEnPairChi];
    
    [pParent->m_OperationIndex CopyDataFrom:pHeartData->pExPairPar To:pHeartSelf->pExPairPar];
    [pParent->m_OperationIndex CopyDataFrom:pHeartData->pExPairChi To:pHeartSelf->pExPairChi];
    
    [pParent->m_OperationIndex CopyDataFrom:pHeartData->pModes To:pHeartSelf->pModes];
    
    pHeartSelf->pNextPlace=pHeartData->pNextPlace;
}
//------------------------------------------------------------------------------------------------------
-(void)CopyAndRenameHeartData:(HeartMatr *)pHeartSelf from:(HeartMatr *)pHeartData
                          Dic:(NSMutableDictionary *)pDic{
    
    [pParent->m_OperationIndex CopyDataFrom:pHeartData->pEnPairPar To:pHeartSelf->pEnPairPar];
    [self RenameIndexData:pHeartSelf->pEnPairPar Dic:pDicRename];

    [pParent->m_OperationIndex CopyDataFrom:pHeartData->pEnPairChi To:pHeartSelf->pEnPairChi];
    [self RenameIndexData:pHeartSelf->pEnPairChi Dic:pDicRename];


    [pParent->m_OperationIndex CopyDataFrom:pHeartData->pExPairPar To:pHeartSelf->pExPairPar];
    [self RenameIndexData:pHeartSelf->pExPairPar Dic:pDicRename];

    [pParent->m_OperationIndex CopyDataFrom:pHeartData->pExPairChi To:pHeartSelf->pExPairChi];
    [self RenameIndexData:pHeartSelf->pExPairChi Dic:pDicRename];

    [pParent->m_OperationIndex CopyDataFrom:pHeartData->pModes To:pHeartSelf->pModes];

    pHeartSelf->pNextPlace=pHeartData->pNextPlace;
}
//------------------------------------------------------------------------------------------------------
- (void)RenameIndexData:(int **)Data Dic:(NSMutableDictionary *)pDic{
    
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*Data);
    int *StartData=((*Data)+SIZE_INFO_STRUCT);
    
    for (int i=0; i<InfoStr->mCount; i++) {//копируем все дочерние объекты
        int iTmpIndex=StartData[i];
        
        if(iTmpIndex<pParent->iIndexMaxSys)//если индекс-константа то её переименовывать не надо
            continue;

        NSNumber *pOldNum = [NSNumber numberWithInt:iTmpIndex];
        NSNumber *pNewNum = [pDicRename objectForKey:pOldNum];
        
        if(pNewNum!=nil)
            StartData[i]=[pNewNum intValue];
    }
}
//------------------------------------------------------------------------------------------------------
- (int)SetArray:(int **)DataArray{

    int iIndex=[self GetFree];
    
    int **ppArray =[pParent->m_OperationIndex InitMemory];
    [pParent->m_OperationIndex InitStructure:ppArray];
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*ppArray);
    InfoStr->mFlags|=(F_DATA|F_ORDER);
    
    int *TmpLink=(int *)(pData+iIndex);
    *TmpLink=ppArray;
    (*(pType+iIndex))=DATA_ARRAY;
    
    NSNumber *pVal = [NSNumber numberWithInt:iIndex];
    [ppAllArrays setObject:pVal forKey:pVal];

    if(DataArray==0)
        InfoStr->mType=DATA_FLOAT;
    else
    {
        InfoArrayValue *InfoStrSource=(InfoArrayValue *)(*DataArray);
        
        InfoStr->mType=InfoStrSource->mType;
        InfoStr->UnParentMatrix=InfoStrSource->UnParentMatrix;
        InfoStr->mGroup=InfoStrSource->mGroup;
        InfoStr->mFlags=InfoStrSource->mFlags;
        
        if(InfoStr->UnParentMatrix.indexMatrix!=0 && (InfoStr->mFlags & F_DATA) && m_bFirstMatrix==NO)
        {
            MATRIXcell *pMatr=[self GetMatrixAtIndex:InfoStr->UnParentMatrix.indexMatrix];
            
            if(pMatr!=0)
                [pParent->m_OperationIndex OnlyAddData:iIndex WithData:pMatr->ppDataMartix];
        }
        
        [pParent->m_OperationIndex SetCopasity:InfoStrSource->mCopasity WithData:ppArray];
        
        int *StartData=((*DataArray)+SIZE_INFO_STRUCT);
//        NSMutableDictionary *pDicRenameTmp = [[NSMutableDictionary alloc] init];
        
        
        if(InfoStrSource->mType==DATA_U_INT)
        {
            [pParent->m_OperationIndex CopyDataFrom:DataArray To:ppArray];
            
//            NSString *Name=[NSString stringWithFormat:@"%d",iIndex];
//            [pParent LogDataPoint:DataArray Name:Name];
        }
        else
        {
            for (int i=0; i<InfoStrSource->mCount; i++) {//копируем все дочерние объекты
                int iTmpIndex=StartData[i];
                
                if(iTmpIndex<pParent->iIndexMaxSys)
                {//если индекс-константа то её переименовывать не надо
                    
                    [pParent->m_OperationIndex AddData:iTmpIndex WithData:ppArray];
                }
                else
                {
                    NSNumber *pOldNum = [NSNumber numberWithInt:iTmpIndex];
                    NSNumber *pNewNum = [pDicRename objectForKey:pOldNum];
                    
                    if(pNewNum==nil){
                        
                        int iNewIndex=[self CopyDataAtIndex:iTmpIndex];
                        
                        NSNumber *pNumFutureNewIndex=[NSNumber numberWithInt:iNewIndex];
                        [pDicRename setObject:pNumFutureNewIndex forKey:pOldNum];
                        
                        [pParent->m_OperationIndex AddData:iNewIndex WithData:ppArray];
                    }
                    else
                    {
                        int IncIndex = [pNewNum intValue];
                        [pParent->m_OperationIndex AddData:IncIndex WithData:ppArray];
                    }
                }

            }
            
   //         [pDicRenameTmp release];
        }
    }

    return iIndex;
}
//------------------------------------------------------------------------------------------------------
- (int)SetMatrix:(MATRIXcell *)DataMatrix{
    
    int iIndex=[self GetFree];

    MATRIXcell *pNewMatr=(MATRIXcell *)malloc(sizeof(MATRIXcell));
    [self InitMemoryMatrix:pNewMatr];

    MATRIXcell **TmpLink=(MATRIXcell **)(pData+iIndex);
    *TmpLink=pNewMatr;
    
    (*(pType+iIndex))=DATA_MATRIX;
    pNewMatr->iIndexSelf=iIndex;
    
    if(DataMatrix!=0){

        NSNumber *pCurMatr = [NSNumber numberWithInt:DataMatrix->iIndexSelf];
        NSNumber *pCurMatrNew = [NSNumber numberWithInt:iIndex];
        [pDicRename setObject:pCurMatrNew forKey:pCurMatr];

        if(m_bFirstMatrix==NO)
        {
            m_iCurIndex=iIndex;
            m_bFirstMatrix=YES;                        
        }
//copy matrix ========================================================================
        pNewMatr->NameInformation=DataMatrix->NameInformation;
        pNewMatr->TypeInformation=DataMatrix->TypeInformation;
        pNewMatr->iDimMatrix=DataMatrix->iDimMatrix;
        
        [pParent->m_OperationIndex CopyDataFrom:DataMatrix->ppStartPlaces To:pNewMatr->ppStartPlaces];

        //копируем copy
        InfoArrayValue *InfoStr=(InfoArrayValue *)(*DataMatrix->pValueCopy);
        int *StartData=((*DataMatrix->pValueCopy)+SIZE_INFO_STRUCT);

        for (int i=0; i<InfoStr->mCount; i++) {//копируем все дочерние объекты
            int iTmpIndex=StartData[i];
            
            if(iTmpIndex<RESERV_KERNEL)
            {//если индекс-константа то её переименовывать не надо
                
                [pParent->m_OperationIndex AddData:iTmpIndex WithData:pNewMatr->pValueCopy];
            }
            else
            {
                NSNumber *pOldNum = [NSNumber numberWithInt:iTmpIndex];
                NSNumber *pNewNum = [pDicRename objectForKey:pOldNum];

                if(pNewNum==nil){

                    if(DataMatrix->iIndexSelf==iTmpIndex)
                    {
                        NSNumber *pNumFutureNewIndex=[NSNumber numberWithInt:pNewMatr->iIndexSelf];
                        [pDicRename setObject:pNumFutureNewIndex forKey:pOldNum];

                        [pParent->m_OperationIndex AddData:pNewMatr->iIndexSelf
                                                    WithData:pNewMatr->pValueCopy];
                    }
                    else
                    {
                        int iNewIndex=[self CopyDataAtIndex:iTmpIndex];
                        
                        NSNumber *pNumFutureNewIndex=[NSNumber numberWithInt:iNewIndex];
                        [pDicRename setObject:pNumFutureNewIndex forKey:pOldNum];
                        
                        [pParent->m_OperationIndex AddData:iNewIndex
                                                  WithData:pNewMatr->pValueCopy];
                        
                        int iTypeCopy=[self GetTypeAtIndex:iNewIndex];
                        
                        if(iTypeCopy==DATA_ARRAY)
                        {
                            int **ppTmpArray = [self GetArrayAtIndex:iNewIndex];
                            InfoArrayValue *pValueInfo=(InfoArrayValue *)*ppTmpArray;
                            
                            if(pValueInfo->UnParentMatrix.indexMatrix!=0)
                                [pParent->m_OperationIndex OnlyAddData:iNewIndex WithData:ppHelpData];
                            
                            if(pValueInfo->mFlags & F_EN)
                                [pParent->m_OperationIndex OnlyAddData:iNewIndex WithData:pNewMatr->pEnters];
                            
                            if(pValueInfo->mFlags & F_EX)
                                [pParent->m_OperationIndex OnlyAddData:iNewIndex WithData:pNewMatr->pExits];
                        }
                    }
                }
                else
                {
                    int IncIndex = [pNewNum intValue];
                    [pParent->m_OperationIndex AddData:IncIndex WithData:pNewMatr->pValueCopy];
                }
            }
        }
        
        //копируем индексы для параметров выхода/входа
        [pParent->m_OperationIndex CopyDataFrom:DataMatrix->pEnters To:pNewMatr->pEnters];
        [self RenameIndexData:pNewMatr->pEnters Dic:pDicRename];
        [pParent->m_OperationIndex CopyDataFrom:DataMatrix->pExits To:pNewMatr->pExits];
        [self RenameIndexData:pNewMatr->pExits Dic:pDicRename];

        //копируем индексы активных пространств
        [pParent->m_OperationIndex CopyDataFrom:DataMatrix->ppActivitySpace To:pNewMatr->ppActivitySpace];
        [self RenameIndexData:pNewMatr->ppActivitySpace Dic:pDicRename];

        //pNewMatr->pQueue// copy queue
        InfoArrayValue *InfoStrQueueSelf=(InfoArrayValue *)(*pNewMatr->pQueue);
        int *StartDataQueueSelf=((*pNewMatr->pQueue)+SIZE_INFO_STRUCT);

        int *StartDataQueue=((*DataMatrix->pQueue)+SIZE_INFO_STRUCT);
        
        for (int i=0; i<InfoStrQueueSelf->mCount; i++){
            HeartMatr *pHeartSelf=(HeartMatr *)StartDataQueueSelf[i];
            HeartMatr *pHeartData=(HeartMatr *)StartDataQueue[i];
            
            if(pHeartSelf!=nil && pHeartData!=nil)
                [self CopyAndRenameHeartData:pHeartSelf from:pHeartData Dic:pDicRename];
        }
//===================================================================================
        if(iIndex==m_iCurIndex)//pDicRename
        {            
            InfoArrayValue *InfoStr=(InfoArrayValue *)(*ppHelpData);
            int *StartData=((*ppHelpData)+SIZE_INFO_STRUCT);
            [pParent->m_OperationIndex SetCopasity:0 WithData:ppListMatrix];
            
            for (int i=0; i<InfoStr->mCount; i++)
            {
                int iTmpIndex=StartData[i];

                int **ppTmpArray = [self GetArrayAtIndex:iTmpIndex];
                InfoArrayValue *pValueInfo=(InfoArrayValue *)*ppTmpArray;
                
                NSNumber *pOldNum = [NSNumber numberWithInt:pValueInfo->UnParentMatrix.indexMatrix];
                NSNumber *pNewNum = [pDicRename objectForKey:pOldNum];
                
                if(pNewNum==nil)
                {
                    int iNewMatrixTmp=[self SetMatrix:0];
                    pNewNum=[NSNumber numberWithInt:iNewMatrixTmp];
                    [pDicRename setObject:pNewNum forKey:pOldNum];

                    [pParent->m_OperationIndex OnlyAddData:[pOldNum integerValue] WithData:ppListMatrix];
                    [pParent->m_OperationIndex OnlyAddData:iNewMatrixTmp WithData:ppListMatrix];
                }
                
                pValueInfo->UnParentMatrix.indexMatrix=[pNewNum integerValue];
                
                MATRIXcell *pMatr=[self GetMatrixAtIndex:pValueInfo->UnParentMatrix.indexMatrix];
                
                if(pMatr!=0)
                    [pParent->m_OperationIndex OnlyAddData:iTmpIndex WithData:pMatr->ppDataMartix];
            }
            
            [pParent->m_OperationIndex SetCopasity:0 WithData:ppHelpData];
            m_iCurIndex=-1;
            m_bFirstMatrix=NO;
        }
    }
    
    NSNumber *pVal = [NSNumber numberWithInt:iIndex];
    [pMartixDic setObject:pVal forKey:pVal];

    return iIndex;
}
//------------------------------------------------------------------------------------------
- (MATRIXcell *)GetMatrixAtIndex:(int)iIndex{
    if(iIndex>iCount || iIndex<0)return 0;
    MATRIXcell **fRet=0;
        
    if(iIndex>=RESERV_KERNEL){
        
        int iType=(*(pType+iIndex));
        
        MATRIXcell **fRet=0;
        
        if(iType==DATA_MATRIX){
            fRet=(MATRIXcell **)(pData+iIndex);
            return *fRet;
        }
    }
    else
    {
        int iType=(*(pTypeSrc+iIndex));
        
        if(iType==DATA_MATRIX){

            fRet=(MATRIXcell **)(pDataSrc+iIndex);
            return *fRet;
        }
    }
    
    return 0;
}
//------------------------------------------------------------------------------------------
- (int **)GetArrayAtIndex:(int)iIndex{
    if(iIndex>iCount || iIndex<0)return 0;
    int ***fRet=0;
    
    if(iIndex>=RESERV_KERNEL){
        
        int iType=(*(pType+iIndex));
        
        if(iType==DATA_ARRAY){
            
            fRet=(int ***)(pData+iIndex);
            return *fRet;
        }
    }
    else
    {
        int iType=(*(pTypeSrc+iIndex));
        
        if(iType==DATA_ARRAY){
            fRet=(int ***)(pDataSrc+iIndex);
            return *fRet;
        }
    }

    return 0;
}
//------------------------------------------------------------------------------------------
- (void *)GetDataAtIndex:(int)iIndex{
    if(iIndex>iCount || iIndex<0)return 0;
    
    if(iIndex>=RESERV_KERNEL){
        int iType=(*(pType+iIndex));
        
        void *fRet=0;
        if(iType!=DATA_MATRIX && iType!=DATA_ID)
            fRet=(pData+iIndex);
        
        return fRet;
    }
    else{
        
        int iType=(*(pTypeSrc+iIndex));

        void *fRet=0;
        if(iType!=DATA_MATRIX && iType!=DATA_ID)
            fRet=(pDataSrc+iIndex);
        
        return fRet;
    }
    
    return 0;
}
//------------------------------------------------------------------------------------------
- (int)GetResAtIndex:(int)iIndex{
    if(iIndex>iCount || iIndex<0)return 0;
    
    if(iIndex>=RESERV_KERNEL){
        
        BYTE iType=(*(pType+iIndex));
        
        if(iType==DATA_TEXTURE || iType==DATA_SOUND){
            
            float *I1=(pData+iIndex);//Texture
            ResourceCell *TmpCell=pCurrenContPar->pTexRes->pCells+(int)*I1;
            return TmpCell->iName;
        }
    }
    else
    {
        BYTE iType=(*(pTypeSrc+iIndex));
        
        if(iType==DATA_TEXTURE || iType==DATA_SOUND){
            
            float *I1=(pData+iIndex);//Texture
            ResourceCell *TmpCell=pCurrenContParSrc->pTexRes->pCells+(int)*I1;
            return TmpCell->iName;
        }
    }
    
    return 0;
}
//------------------------------------------------------------------------------------------
- (id)GetIdAtIndex:(int)iIndex{
    if(iIndex>iCount || iIndex<0)return 0;
    
    if(iIndex>=RESERV_KERNEL){

        BYTE iType=(*(pType+iIndex));

        id *fRet=0;
        if(iType==DATA_ID || iType==DATA_STRING){
            fRet=(id *)(pData+iIndex);
            return *fRet;
        }
    }
    else
    {
        BYTE iType=(*(pTypeSrc+iIndex));
        
        id *fRet=0;
        if(iType==DATA_ID || iType==DATA_STRING){
            fRet=(id *)(pDataSrc+iIndex);
            return *fRet;
        }
    }
    
    return 0;
}
//------------------------------------------------------------------------------------------
- (int)GetCountAtIndex:(int)iIndex{
    if(iIndex>iCount || iIndex<0)return 0;

    int iRet=0;
    if(iIndex>=RESERV_KERNEL)
        iRet=(*(pDataInt+iIndex));
    else iRet=(*(pDataIntSrc+iIndex));
    
    return iRet;
}
//------------------------------------------------------------------------------------------
- (unsigned char)GetTypeAtIndex:(int)iIndex{
    if(iIndex>iCount || iIndex<0)return 0;

    BYTE iRet=0;
    if(iIndex>=RESERV_KERNEL)
        iRet=(*(pType+iIndex));
    else iRet=(*(pTypeSrc+iIndex));
    
    return iRet;
}
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
- (void)IncDataAtIndex:(int)iIndex{
    
    int *TmpInc=(pDataInt+iIndex);
    (*TmpInc)++;
}
//------------------------------------------------------------------------------------------
- (void)SetCellFreeAtIndex:(int)iIndex{
    
//    int *TmpIndex=((int *)pDataInt+iIndex);
//    
//    (*TmpIndex)=0;
//    
//    iCountInArray--;
//    NSNumber *pNum=[NSNumber numberWithInt:iIndex];
//    [pFreeArray addObject:pNum];
}
//------------------------------------------------------------------------------------------
- (void)DecDataAtIndex:(int)iIndex{
    
    int *TmpCount=((int *)pDataInt+iIndex);
    
    if(*TmpCount>0){
        
        (*TmpCount)--;
        if(*TmpCount==0)
        {
            unsigned char uType = (*(pType+iIndex));

            switch (uType) {
                case DATA_ID:{}
                break;

                case DATA_MATRIX:
                {
                    MATRIXcell *pMatr=[pParent->ArrayPoints GetMatrixAtIndex:iIndex];
                    
                    if(pMatr!=0)
                    {
                        InfoArrayValue *InfoStr=(InfoArrayValue *)(*pMatr->pValueCopy);
                        int iCountTmp=InfoStr->mCount;
                        
                        for(int i=0;i<iCountTmp;i++){
                            
                            [pParent->m_OperationIndex RemoveDataAtPlace:0 WithData:pMatr->pValueCopy];
                        }
                        
                        //вычищаем последовательность
                        InfoArrayValue *pInfoQueue=(InfoArrayValue *)(*pMatr->pQueue);
                        int *pStartQueue=*pMatr->pQueue+SIZE_INFO_STRUCT;
                        
                        for (int i=0; i<pInfoQueue->mCount; i++) {
                            HeartMatr *pHeart=(HeartMatr *)pStartQueue[i];
                            
                            if(pHeart!=0){
                                [self ReleaseMemoryHeart:pHeart];
                                free(pHeart);
                            }
                        }
///////////очищаем матрицу данных если есть////////////////////////////////////////////////////////////
                        InfoArrayValue *pInfoData=(InfoArrayValue *)*pMatr->ppDataMartix;
                        
                        for (int i=0; i<pInfoData->mCount; i++) {
                            
                            int iIndexData=(*pMatr->ppDataMartix+SIZE_INFO_STRUCT)[i];
                            int **ppArray=[self GetArrayAtIndex:iIndexData];
                            InfoArrayValue *pInfo=(InfoArrayValue *)*ppArray;
                            
                            if(pInfo->mType==DATA_U_INT)
                            {
                                [pParent->m_OperationIndex SetCopasity:0 WithData:ppArray];
                            }
                            else
                            {
                                int iCount2=pInfo->mCount-1;
                                
                                if(iCount2>0)
                                {
                                    for (int i=0; i<iCount2; i++)
                                        [pParent->m_OperationIndex RemoveDataAtPlace:1 WithData:ppArray];
                                }
                            }
                            
                            pInfo=(InfoArrayValue *)*ppArray;
                            pInfo->UnParentMatrix.indexMatrix=0;
                            
                        }

                        
                        
                        free(*pMatr->pValueCopy);
                        free(pMatr->pValueCopy);

                        free(*pMatr->pLinks);
                        free(pMatr->pLinks);

                        free(*pMatr->pEnters);
                        free(pMatr->pEnters);

                        free(*pMatr->pExits);
                        free(pMatr->pExits);
                                            
                        free(*pMatr->pQueue);
                        free(pMatr->pQueue);

                        free(*pMatr->ppStartPlaces);
                        free(pMatr->ppStartPlaces);

                        free(*pMatr->ppActivitySpace);
                        free(pMatr->ppActivitySpace);

                        free(*pMatr->ppDataMartix);
                        free(pMatr->ppDataMartix);
                        
                        NSNumber *pVal = [NSNumber numberWithInt:pMatr->iIndexSelf];
                        [pMartixDic removeObjectForKey:pVal];
                        
                        free(pMatr);
                    }
                }
                break;

                case DATA_STRING:
                    break;

                case DATA_TEXTURE:
                    
                    [pParent->m_OperationIndex OnlyAddData:iIndex WithData:ppIndexNeedDelTex];
//                    [pCurrenContPar->pTexRes RemoveRes:iIndex];
                    break;
                    
                case DATA_SOUND:
                    [pParent->m_OperationIndex OnlyAddData:iIndex WithData:ppIndexNeedDelSound];
//                    [pCurrenContPar->pSoundRes RemoveRes:iIndex];
                    break;
                    
                case DATA_SPRITE:
                    [pParent->m_OperationIndex OnlyAddData:iIndex WithData:ppIndexNeedDelPar];
//                    [pCurrenContPar RemoveParticle:iIndex];
                break;
                    
                case DATA_ARRAY:
                {
                    int **ppArray=[pParent->ArrayPoints GetArrayAtIndex:iIndex];
                    
                    if(ppArray!=0)
                    {
                        [pParent->m_OperationIndex ReleaseMemory:ppArray];
                        
                        NSNumber *pVal = [NSNumber numberWithInt: iIndex];
                        [ppAllArrays removeObjectForKey:pVal];
                    }
                }
                break;
                    
                default:
                    break;
            }

            *(pData+iIndex)=0;
            iCountInArray--;
            
            if(uType!=DATA_SPRITE && uType!=DATA_TEXTURE && uType!=DATA_SOUND)
            {
                NSNumber *pNum=[NSNumber numberWithInt:iIndex];
                [pFreeArray addObject:pNum];
                
                [pParent->m_OperationIndex OnlyAddData:iIndex WithData:ppFreeArrayEx];

            }
        }
    }
}
//------------------------------------------------------------------------------------------
-(void)delResource{
    
    InfoArrayValue *pInfoTex=(InfoArrayValue*)*ppIndexNeedDelTex;
    
    for (int i=0; i<pInfoTex->mCount; i++) {
        int iIndex=(*ppIndexNeedDelTex+SIZE_INFO_STRUCT)[i];
        [pCurrenContPar->pTexRes RemoveRes:iIndex];
        NSNumber *pNum=[NSNumber numberWithInt:iIndex];
        [pFreeArray addObject:pNum];
        
        [pParent->m_OperationIndex OnlyAddData:iIndex WithData:ppFreeArrayEx];
    }
    
    pInfoTex->mCount=0;

    InfoArrayValue *pInfoSound=(InfoArrayValue*)*ppIndexNeedDelSound;
    
    for (int i=0; i<pInfoSound->mCount; i++) {
        int iIndex=(*ppIndexNeedDelSound+SIZE_INFO_STRUCT)[i];
        [pCurrenContPar->pSoundRes RemoveRes:iIndex];
        NSNumber *pNum=[NSNumber numberWithInt:iIndex];
        [pFreeArray addObject:pNum];
        
        [pParent->m_OperationIndex OnlyAddData:iIndex WithData:ppFreeArrayEx];
    }
    
    pInfoSound->mCount=0;

    InfoArrayValue *pInfoPar=(InfoArrayValue*)*ppIndexNeedDelPar;
    
    for (int i=0; i<pInfoPar->mCount; i++) {
        int iIndex=(*ppIndexNeedDelPar+SIZE_INFO_STRUCT)[i];
        [pCurrenContPar RemoveParticle:iIndex];
        NSNumber *pNum=[NSNumber numberWithInt:iIndex];
        [pFreeArray addObject:pNum];
        
        [pParent->m_OperationIndex OnlyAddData:iIndex WithData:ppFreeArrayEx];
    }
    
    pInfoPar->mCount=0;
}
//------------------------------------------------------------------------------------------
-(void)selfSave:(NSMutableData *)m_pData{
    
    int iOffset=0;
    if(m_bSaveKernel==YES)iOffset=RESERV_KERNEL;
    
    if(m_bSaveKernel==YES){
        int mCurentCount=iCount-iOffset;
        [m_pData appendBytes:&mCurentCount length:sizeof(int)];
    }
    else [m_pData appendBytes:&iCount length:sizeof(int)];
    
    [m_pData appendBytes:&iCountInArray length:sizeof(int)];
    [m_pData appendBytes:&iCountInc length:sizeof(int)];
    
    [m_pData appendBytes:pData+iOffset length:(iCount-iOffset)*sizeof(float)];
    [m_pData appendBytes:pDataInt+iOffset length:(iCount-iOffset)*sizeof(int)];
    [m_pData appendBytes:pType+iOffset length:(iCount-iOffset)*sizeof(unsigned char)];
//сохраняем свободные ячейки------------------------------------------------------
    
    [pParent->m_OperationIndex selfSave:m_pData WithData:ppFreeArrayEx];

//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:pFreeArray];
//    int iLen=[data length];
//    
//    [m_pData appendBytes:&iLen length:sizeof(int)];
//    [m_pData appendData:data];
//--------------------------------------------------------------------------------
    NSData *data=[NSKeyedArchiver archivedDataWithRootObject:pNamesOb];
    int iLen=[data length];
    
    [m_pData appendBytes:&iLen length:sizeof(int)];
    [m_pData appendData:data];
//--------------------------------------------------------------------------------
    data=[NSKeyedArchiver archivedDataWithRootObject:pNamesValue];
    iLen=[data length];
    
    [m_pData appendBytes:&iLen length:sizeof(int)];
    [m_pData appendData:data];
//--------------------------------------------------------------------------------
//    data=[NSKeyedArchiver archivedDataWithRootObject:ppAllArrays];
//    iLen=[data length];
//    
//    [m_pData appendBytes:&iLen length:sizeof(int)];
//    [m_pData appendData:data];
//--------------------------------------------------------------------------------
    iLen = [DicAllAssociations count];
    [m_pData appendBytes:&iLen length:sizeof(int)];

    NSEnumerator *Key_enumerator = [DicAllAssociations keyEnumerator];
    NSString *pNameKey;
    
    while ((pNameKey = [Key_enumerator nextObject])) {
        
        NSMutableDictionary * pGroupsLinks = [DicAllAssociations objectForKey:pNameKey];
        data=[NSKeyedArchiver archivedDataWithRootObject:pGroupsLinks];
        iLen=[data length];
        
        [m_pData appendBytes:&iLen length:sizeof(int)];
        [m_pData appendData:data];
    }
//===================================================================
    //сохраняем массивы
    iLen = [ppAllArrays count];
    [m_pData appendBytes:&iLen length:sizeof(int)];

    NSEnumerator *Array_enumerator = [ppAllArrays objectEnumerator];
    NSNumber *pValueArray;
    
    while ((pValueArray = [Array_enumerator nextObject])){
        
        int iIndex=[pValueArray intValue];
        [m_pData appendBytes:&iIndex length:sizeof(int)];
        int **ppArr = [self GetArrayAtIndex:iIndex];
        [pParent->m_OperationIndex selfSave:m_pData WithData:ppArr];
    }
//--------------------------------------------------------------------------------
    NSArray *keys = [pMartixDic allKeys];

    for (int i=0; i<[keys count]; i++) {
        id key = [keys objectAtIndex:i];
        NSNumber *pValueMatr=[pMartixDic objectForKey:key];
        int iCountTmp=[self GetCountAtIndex:[pValueMatr intValue]];
        
        if(iCountTmp==0){
            [pMartixDic removeObjectForKey:key];
            keys = [pMartixDic allKeys];
            i=0;
        }
    }
    
    iLen = [pMartixDic count];
    [m_pData appendBytes:&iLen length:sizeof(int)];

    //сохраняем матрицы
    NSEnumerator *Matr_enumerator = [pMartixDic objectEnumerator];
    NSNumber *pValueMatr;
    
    while ((pValueMatr = [Matr_enumerator nextObject])){
        MATRIXcell *pMatr = [self GetMatrixAtIndex:[pValueMatr intValue]];
        [self SaveMatrix:m_pData WithMatr:pMatr];
    }
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    [pCurrenContPar selfSave:m_pData];//сохраняем спрайты
}
//--------------------------------------------------------------------------------
-(void)PrepareLoadData{
    
    NSEnumerator *Key_enumerator = [pNamesOb keyEnumerator];
    NSString *pNameKey;

    while ((pNameKey = [Key_enumerator nextObject])) {

        NSString * pName = [pNamesOb objectForKey:pNameKey];
        FractalString *pFStr = [pParent->DicStrings objectForKey:pName];

        int iKey=[pNameKey intValue];
        id *fRet=((id *)(pData+iKey));

        if(pFStr!=0)*fRet=pFStr;
    }

    Key_enumerator = [pNamesValue keyEnumerator];
    
    while ((pNameKey = [Key_enumerator nextObject])) {
        
        NSString * pName = [pNamesValue objectForKey:pNameKey];

        int iKey=[pNameKey intValue];
        id *fRet=((id *)(pData+iKey));
        
        *fRet=pName;
    }

    Key_enumerator = [DicAllAssociations keyEnumerator];
    
    while ((pNameKey = [Key_enumerator nextObject])) {
        
        NSMutableDictionary * pGroupsLinks = [DicAllAssociations objectForKey:pNameKey];
        [pGroupsLinks retain];

        if(pGroupsLinks!=nil){
            NSEnumerator *pTmpEnumerator = [pGroupsLinks objectEnumerator];

            NSNumber *pNum=nil;
            
            bool bFirst=YES;
            int **TmpChild=0;
            
            while ((pNum = [pTmpEnumerator nextObject])) {
                int iIndex=[pNum integerValue];
                
                FractalString *TmpString = [self GetIdAtIndex:iIndex];
                
                if(TmpString!=0){
                    TmpString->pAssotiation=[pGroupsLinks retain];
                    
                    if(TmpString!=0){
                        if(bFirst==YES){
                            bFirst=NO;
                            TmpChild=TmpString->pChildString;
                        }
                        else {
                            
                            [pParent->m_OperationIndex OnlyReleaseMemory:TmpString->pChildString];
                            TmpString->pChildString=TmpChild;
                        }
                    }
                }
            }
        }
    }
}
//------------------------------------------------------------------------------------------
-(void)selfLoad:(NSMutableData *)m_pData rpos:(int *)iCurReadingPos{
    
    [m_pData getBytes:&iCount range:NSMakeRange( *iCurReadingPos, sizeof(int))];
    *iCurReadingPos += sizeof(int);
    int iOffset=0;
    if(m_bSaveKernel==YES)iOffset=RESERV_KERNEL;

    [self Reserv:iCount+iOffset];
    if(m_bSaveKernel==YES)[self->pParent->pKernel SetKernel];
    
    [m_pData getBytes:&iCountInArray range:NSMakeRange( *iCurReadingPos, sizeof(int))];
    *iCurReadingPos += sizeof(int);

    [m_pData getBytes:&iCountInc range:NSMakeRange( *iCurReadingPos, sizeof(int))];
    *iCurReadingPos += sizeof(int);

    [m_pData getBytes:pData+iOffset range:NSMakeRange( *iCurReadingPos, (iCount-iOffset)*sizeof(float))];
    *iCurReadingPos += (iCount-iOffset)*sizeof(float);
    
    [m_pData getBytes:pDataInt+iOffset range:NSMakeRange( *iCurReadingPos, (iCount-iOffset)*sizeof(int))];
    *iCurReadingPos += (iCount-iOffset)*sizeof(int);

    [m_pData getBytes:pType+iOffset range:NSMakeRange(*iCurReadingPos,
                                                      (iCount-iOffset)*sizeof(unsigned char))];
    
    *iCurReadingPos += (iCount-iOffset)*sizeof(unsigned char);
//--------------------------------------------------------------------------------
    [pParent->m_OperationIndex selfLoad:m_pData rpos:iCurReadingPos WithData:ppFreeArrayEx];

    int iLen;
//    [m_pData getBytes:&iLen range:NSMakeRange( *iCurReadingPos, sizeof(int))];
//    *iCurReadingPos += sizeof(int);
//
//    NSData *iv = [m_pData subdataWithRange:NSMakeRange(*iCurReadingPos, iLen)];
//    
//    if(pFreeArray!=nil)[pFreeArray release];
//    pFreeArray = [[NSKeyedUnarchiver unarchiveObjectWithData:iv] retain];
//    
//    
//    for(int i=0;i<[pFreeArray count];i++)
//    {
//        NSNumber *pNum=[pFreeArray objectAtIndex:i];
//        int sdfs=[pNum intValue];
//        [pParent->m_OperationIndex OnlyAddData:sdfs WithData:ppFreeArrayEx];
//    }
//
//    
//    *iCurReadingPos += iLen;
//--------------------------------------------------------------------------------
    [m_pData getBytes:&iLen range:NSMakeRange( *iCurReadingPos, sizeof(int))];
    *iCurReadingPos += sizeof(int);
    
    NSData *iv = [m_pData subdataWithRange:NSMakeRange(*iCurReadingPos, iLen)];
    
    if(pNamesOb!=nil)[pNamesOb release];
    pNamesOb = [[NSKeyedUnarchiver unarchiveObjectWithData:iv] retain];
    
    *iCurReadingPos += iLen;
//--------------------------------------------------------------------------------
    [m_pData getBytes:&iLen range:NSMakeRange( *iCurReadingPos, sizeof(int))];
    *iCurReadingPos += sizeof(int);
    
    iv = [m_pData subdataWithRange:NSMakeRange(*iCurReadingPos, iLen)];
    
    if(pNamesValue!=nil)[pNamesValue release];
    pNamesValue = [[NSKeyedUnarchiver unarchiveObjectWithData:iv]retain];
    *iCurReadingPos += iLen;
//--------------------------------------------------------------------------------
//    [m_pData getBytes:&iLen range:NSMakeRange( *iCurReadingPos, sizeof(int))];
//    *iCurReadingPos += sizeof(int);
//    
//    iv = [m_pData subdataWithRange:NSMakeRange(*iCurReadingPos, iLen)];
//    
//    if(ppAllArrays!=nil)[ppAllArrays release];
//    ppAllArrays = [[NSKeyedUnarchiver unarchiveObjectWithData:iv] retain];
//    *iCurReadingPos += iLen;
//--------------------------------------------------------------------------------

    int Count=0;
    [m_pData getBytes:&Count range:NSMakeRange( *iCurReadingPos, sizeof(int))];
    *iCurReadingPos += sizeof(int);
    
    if(m_bSaveKernel==NO)
        [DicAllAssociations removeAllObjects];
    
    for(int i=0;i<Count;i++){
        
        [m_pData getBytes:&iLen range:NSMakeRange( *iCurReadingPos, sizeof(int))];
        *iCurReadingPos += sizeof(int);
        
        iv = [m_pData subdataWithRange:NSMakeRange(*iCurReadingPos, iLen)];
        
        NSMutableDictionary *TmpDic = [NSKeyedUnarchiver unarchiveObjectWithData:iv];
        
        if(TmpDic!=nil){
            NSString *pKey = [NSString stringWithFormat:@"%p",TmpDic];
            [DicAllAssociations setObject:TmpDic forKey:pKey];
            [TmpDic release];
        }
        
        *iCurReadingPos += iLen;
    }    
//загружаем все массивы
//--------------------------------------------------------------------------------
    if(m_bSaveKernel==NO)
        [ppAllArrays removeAllObjects];
    
    [m_pData getBytes:&iLen range:NSMakeRange( *iCurReadingPos, sizeof(int))];
    *iCurReadingPos += sizeof(int);

    for (int i=0; i<iLen; i++) {

        int iIndexTmp;
        [m_pData getBytes:&iIndexTmp range:NSMakeRange( *iCurReadingPos, sizeof(int))];
        *iCurReadingPos += sizeof(int);

        int **ppArray = [pParent->m_OperationIndex InitMemory];
        [pParent->m_OperationIndex selfLoad:m_pData rpos:iCurReadingPos WithData:ppArray];
        
        int *TmpLink=(int *)pData+iIndexTmp;
        *TmpLink=ppArray;
                
        NSNumber *pVal = [NSNumber numberWithInt:iIndexTmp];
        [ppAllArrays setObject:pVal forKey:pVal];
    }
    
//загружаем матрицы
//--------------------------------------------------------------------------------
    if(m_bSaveKernel==NO)
        [pMartixDic removeAllObjects];
    
    [m_pData getBytes:&iLen range:NSMakeRange( *iCurReadingPos, sizeof(int))];
    *iCurReadingPos += sizeof(int);

    for (int i=0; i<iLen; i++) {
        
        MATRIXcell *pMatr=(MATRIXcell *)malloc(sizeof(MATRIXcell));
        [self InitMemoryMatrix:pMatr];

        [self LoadMatrix:m_pData rpos:iCurReadingPos WithMatr:pMatr];
        
        NSNumber *pVal = [NSNumber numberWithInt:pMatr->iIndexSelf];
        [pMartixDic setObject:pVal forKey:pVal];
        
        MATRIXcell **TmpLinkMatr=(MATRIXcell **)(pData+pMatr->iIndexSelf);
        *TmpLinkMatr=pMatr;
    }
//--------------------------------------------------------------------------------
    [pCurrenContPar selfLoad:m_pData rpos:iCurReadingPos];//загружаем спрайты

    [self PrepareLoadData];
}
//------------------------------------------------------------------------------------------
- (void)LoadHeart:(NSMutableData *)pMutData rpos:(int *)iCurReadingPos
         WithHeat:(HeartMatr *)pHeart WithMatr:(MATRIXcell *)pMatr{
    
    [pParent->m_OperationIndex selfLoad:pMutData rpos:iCurReadingPos WithData:pHeart->pEnPairPar];
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pHeart->pEnPairChi);
    InfoStr->UnParentMatrix.ParentMatrix=pMatr;

    [pParent->m_OperationIndex selfLoad:pMutData rpos:iCurReadingPos WithData:pHeart->pEnPairChi];
    InfoStr=(InfoArrayValue *)(*pHeart->pEnPairChi);
    InfoStr->UnParentMatrix.ParentMatrix=pMatr;

    [pParent->m_OperationIndex selfLoad:pMutData rpos:iCurReadingPos WithData:pHeart->pExPairPar];
    InfoStr=(InfoArrayValue *)(*pHeart->pExPairPar);
    InfoStr->UnParentMatrix.ParentMatrix=pMatr;

    [pParent->m_OperationIndex selfLoad:pMutData rpos:iCurReadingPos WithData:pHeart->pExPairChi];
    InfoStr=(InfoArrayValue *)(*pHeart->pExPairChi);
    InfoStr->UnParentMatrix.ParentMatrix=pMatr;

    [pParent->m_OperationIndex selfLoad:pMutData rpos:iCurReadingPos WithData:pHeart->pModes];
    InfoStr=(InfoArrayValue *)(*pHeart->pModes);
    InfoStr->UnParentMatrix.ParentMatrix=pMatr;
    
    NSRange Range = NSMakeRange( *iCurReadingPos, sizeof(int));
    [pMutData getBytes:&pHeart->pNextPlace range:Range];
    *iCurReadingPos += sizeof(int);
}
//------------------------------------------------------------------------------------------
- (void)LoadMatrix:(NSMutableData *)pMutData rpos:(int *)iCurReadingPos WithMatr:(MATRIXcell *)pMatr{
    
    [pParent->m_OperationIndex selfLoad:pMutData rpos:iCurReadingPos WithData:pMatr->pValueCopy];
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pMatr->pValueCopy);
    InfoStr->UnParentMatrix.ParentMatrix=pMatr;

    [pParent->m_OperationIndex selfLoad:pMutData rpos:iCurReadingPos WithData:pMatr->pLinks];
    InfoStr=(InfoArrayValue *)(*pMatr->pLinks);
    InfoStr->UnParentMatrix.ParentMatrix=pMatr;

    [pParent->m_OperationIndex selfLoad:pMutData rpos:iCurReadingPos WithData:pMatr->pEnters];
    InfoStr=(InfoArrayValue *)(*pMatr->pEnters);
    InfoStr->UnParentMatrix.ParentMatrix=pMatr;

    [pParent->m_OperationIndex selfLoad:pMutData rpos:iCurReadingPos WithData:pMatr->pExits];
    InfoStr=(InfoArrayValue *)(*pMatr->pExits);
    InfoStr->UnParentMatrix.ParentMatrix=pMatr;

    [pParent->m_OperationIndex selfLoad:pMutData rpos:iCurReadingPos WithData:pMatr->ppStartPlaces];
    InfoStr=(InfoArrayValue *)(*pMatr->ppStartPlaces);
    InfoStr->UnParentMatrix.ParentMatrix=pMatr;

    [pParent->m_OperationIndex selfLoad:pMutData rpos:iCurReadingPos WithData:pMatr->ppActivitySpace];
    InfoStr=(InfoArrayValue *)(*pMatr->ppActivitySpace);
    InfoStr->UnParentMatrix.ParentMatrix=pMatr;

    [pParent->m_OperationIndex selfLoad:pMutData rpos:iCurReadingPos WithData:pMatr->ppDataMartix];
    InfoStr=(InfoArrayValue *)(*pMatr->ppDataMartix);
    InfoStr->UnParentMatrix.ParentMatrix=pMatr;

    //тип струны.
    NSRange Range = NSMakeRange( *iCurReadingPos, sizeof(BYTE));
    [pMutData getBytes:&pMatr->TypeInformation range:Range];
    *iCurReadingPos += sizeof(BYTE);
    
    //Имя-число струны.
    Range = NSMakeRange( *iCurReadingPos, sizeof(short));
    [pMutData getBytes:&pMatr->NameInformation range:Range];
    *iCurReadingPos += sizeof(short);

    //индекс струны.
    Range = NSMakeRange( *iCurReadingPos, sizeof(int));
    [pMutData getBytes:&pMatr->iIndexSelf range:Range];
    *iCurReadingPos += sizeof(int);
    
    //размерность матрицы.
    Range = NSMakeRange( *iCurReadingPos, sizeof(int));
    [pMutData getBytes:&pMatr->iDimMatrix range:Range];
    *iCurReadingPos += sizeof(int);

    //количество сердец.
    short sCountHearts=0;
    Range = NSMakeRange( *iCurReadingPos, sizeof(short));
    [pMutData getBytes:&sCountHearts range:Range];
    *iCurReadingPos += sizeof(short);
        
    InfoArrayValue *InfoQueue=(InfoArrayValue *)(*pMatr->pQueue);
    int *StartDataQueue=((*pMatr->pQueue)+SIZE_INFO_STRUCT);
    int *StartDataCopy=((*pMatr->pValueCopy)+SIZE_INFO_STRUCT);
    
    for (int i=0; i<sCountHearts; i++) {
        
        int iIndexValue=StartDataCopy[i];
        int iType=[self GetTypeAtIndex:iIndexValue];
        
        iType=*(pType+iIndexValue);
        
        [pParent->m_OperationIndex Extend:pMatr->pQueue];
        InfoQueue=(InfoArrayValue *)(*pMatr->pQueue);
        StartDataQueue=((*pMatr->pQueue)+SIZE_INFO_STRUCT);
        
        HeartMatr *pNewHeart=0;
        if(iType==DATA_MATRIX){
            pNewHeart=(HeartMatr *)malloc(sizeof(HeartMatr));
            [self InitMemoryHeart:pNewHeart parent:pMatr];
            [self LoadHeart:pMutData rpos:iCurReadingPos WithHeat:pNewHeart WithMatr:pMatr];
        }
        
        HeartMatr **TmpHeart=(HeartMatr **)(StartDataQueue+InfoQueue->mCount);
        *TmpHeart=pNewHeart;
        
        InfoQueue->mCount++;
    }
}
//------------------------------------------------------------------------------------------
- (void)SaveHeart:(NSMutableData *)pMutData WithMatr:(HeartMatr *)pHeart{

    [pParent->m_OperationIndex selfSave:pMutData WithData:pHeart->pEnPairPar];
    [pParent->m_OperationIndex selfSave:pMutData WithData:pHeart->pEnPairChi];

    [pParent->m_OperationIndex selfSave:pMutData WithData:pHeart->pExPairPar];
    [pParent->m_OperationIndex selfSave:pMutData WithData:pHeart->pExPairChi];

    [pParent->m_OperationIndex selfSave:pMutData WithData:pHeart->pModes];
        
    [pMutData appendBytes:&pHeart->pNextPlace length:sizeof(int)];
}
//------------------------------------------------------------------------------------------
- (void)SaveMatrix:(NSMutableData *)pMutData WithMatr:(MATRIXcell *)pMatr{
    
    [pParent->m_OperationIndex selfSave:pMutData WithData:pMatr->pValueCopy];
    [pParent->m_OperationIndex selfSave:pMutData WithData:pMatr->pLinks];

    [pParent->m_OperationIndex selfSave:pMutData WithData:pMatr->pEnters];
    [pParent->m_OperationIndex selfSave:pMutData WithData:pMatr->pExits];

    [pParent->m_OperationIndex selfSave:pMutData WithData:pMatr->ppStartPlaces];
    [pParent->m_OperationIndex selfSave:pMutData WithData:pMatr->ppActivitySpace];
    [pParent->m_OperationIndex selfSave:pMutData WithData:pMatr->ppDataMartix];

    //тип струны.
    [pMutData appendBytes:&pMatr->TypeInformation length:sizeof(BYTE)];
    //Имя-число струны.
    [pMutData appendBytes:&pMatr->NameInformation length:sizeof(short)];
    //Индекс струны.
    [pMutData appendBytes:&pMatr->iIndexSelf length:sizeof(int)];
    //размерность матрицы
    [pMutData appendBytes:&pMatr->iDimMatrix length:sizeof(int)];


    InfoArrayValue *InfoStrQueue=(InfoArrayValue *)(*pMatr->pQueue);
    int *StartDataQueue=(*pMatr->pQueue+SIZE_INFO_STRUCT);
    [pMutData appendBytes:&InfoStrQueue->mCount length:sizeof(short)];
    
    for (int i=0; i<InfoStrQueue->mCount; i++) {
        HeartMatr *pHeatr=(HeartMatr *)StartDataQueue[i];
        
        if(pHeatr!=nil)
            [self SaveHeart:pMutData WithMatr:pHeatr];
    }
}
//------------------------------------------------------------------------------------------
- (int)CreateZeroByType:(int)iType{
    int iRetInd=0;
    
    switch (iType) {
        case DATA_FLOAT:
            iRetInd=[self SetFloat:0];
            break;
            
        case DATA_INT:
            iRetInd=[self SetInt:0];
            break;
            
        case DATA_TEXTURE:
        {
            NSMutableString *pName=[NSMutableString stringWithString:@"0.png"];
            iRetInd=[self SetTexture:pName];
        }
            break;
            
        case DATA_SPRITE:
            iRetInd=[self SetSprite:0];
            break;
            
        default:
            [NSException raise:@"Invalid type value" format:@"type of %d is invalid", iType];
            break;
    }
    
    return iRetInd;
}
//------------------------------------------------------------------------------------------
- (int)GetZeroByType:(int)iType{
    int iRetInd=0;
    
    switch (iType) {
        case DATA_FLOAT:
            iRetInd=150001;
            break;

        case DATA_INT:
            iRetInd=150003;
            break;

        case DATA_TEXTURE:
            iRetInd=150005;
            break;

        case DATA_SPRITE:
            iRetInd=150007;
            break;

        default:
            [NSException raise:@"Invalid type value" format:@"type of %d is invalid", iType];
            break;
    }

    return iRetInd;
}
//------------------------------------------------------------------------------------------
- (void)dealloc
{
    NSEnumerator *Key_enumerator = [pMartixDic keyEnumerator];
    NSString *pNameKey;
    
    while ((pNameKey = [Key_enumerator nextObject])) {
        
        NSNumber *pVal = [pMartixDic objectForKey:pNameKey];
        
        MATRIXcell *pMatr=[self GetMatrixAtIndex:[pVal intValue]];
        
        InfoArrayValue *pQueue=(InfoArrayValue *)*pMatr->pQueue;
        
        for (int i=0; i<pQueue->mCount; i++) {
            HeartMatr *pHeat=(*pMatr->pQueue+SIZE_INFO_STRUCT)[i];
            if(pHeat!=0)
            {
                [self ReleaseMemoryHeart:pHeat];
                free(pHeat);
            }
        }
        
        free(*pMatr->pValueCopy);
        free(pMatr->pValueCopy);
        
        free(*pMatr->pLinks);
        free(pMatr->pLinks);
        
        free(*pMatr->pEnters);
        free(pMatr->pEnters);
        
        free(*pMatr->pExits);
        free(pMatr->pExits);
        
        free(*pMatr->pQueue);
        free(pMatr->pQueue);
        
        free(*pMatr->ppStartPlaces);
        free(pMatr->ppStartPlaces);
        
        free(*pMatr->ppActivitySpace);
        free(pMatr->ppActivitySpace);
        
        free(*pMatr->ppDataMartix);
        free(pMatr->ppDataMartix);
        
        free(pMatr);
    }

    Key_enumerator = [ppAllArrays keyEnumerator];
    NSNumber *pIndexArray;
    
    while ((pIndexArray = [Key_enumerator nextObject])) {
        
        NSNumber *pVal = [ppAllArrays objectForKey:pIndexArray];
        
        int **ppArray=[self GetArrayAtIndex:[pVal intValue]];
        
        free(*ppArray);
        free(ppArray);
    }

    Key_enumerator = [pNamesOb keyEnumerator];
    NSNumber *pVal;
    
    while (pVal = [Key_enumerator nextObject]) {
        
        FractalString *pFractalString = [self GetIdAtIndex:[pVal intValue]];
        
        if(pFractalString->pAssotiation!=0)
        {
            if(pFractalString->pChildString!=0)
            {
                [pParent->m_OperationIndex OnlyReleaseMemory:pFractalString->pChildString];
                pFractalString->pChildString=0;
                
                NSEnumerator *Key_enumeratorTmp = [pFractalString->pAssotiation keyEnumerator];
                NSNumber *pValTmpAss;
                
                while (pValTmpAss = [Key_enumeratorTmp nextObject])
                {
                    FractalString *pFractalStringTmp = [self GetIdAtIndex:[pValTmpAss intValue]];
                    
                    if(pFractalStringTmp!=pFractalString)
                    {
                        [pFractalStringTmp->pAssotiation release];
                        pFractalStringTmp->pAssotiation=nil;
                        pFractalStringTmp->pChildString=0;
                    }
                }
                
                NSString *pKey = [NSString stringWithFormat:@"%p",pFractalString->pAssotiation];
                [DicAllAssociations removeObjectForKey:pKey];

      //          int iRetain=[pFractalString->pAssotiation retainCount];
                [pFractalString->pAssotiation release];
                pFractalString->pAssotiation=nil;
            }
        }
        else
        {
            [pParent->m_OperationIndex OnlyReleaseMemory:pFractalString->pChildString];
            pFractalString->pChildString=0;
        }
        
        [pFractalString release];
    }
    
    free(*ppIndexNeedDelTex);
    free(ppIndexNeedDelTex);
    free(*ppIndexNeedDelSound);
    free(ppIndexNeedDelSound);
    free(*ppIndexNeedDelPar);
    free(ppIndexNeedDelPar);

    free(*ppHelpData);
    free(ppHelpData);

    free(*ppListMatrix);
    free(ppListMatrix);

    free(pData);
    free(pDataInt);
    free(pType);
    [pFreeArray release];
    
    [pParent->m_OperationIndex OnlyReleaseMemory:ppFreeArrayEx];

    
    [pNamesOb release];
    [pNamesValue release];
    [pMartixDic release];
    [pDicRename release];
    [DicAllAssociations release];
    [ppAllArrays release];

    [pParent->m_pObjMng DestroyObject:pCurrenContPar];
    
    [super dealloc];
}
//------------------------------------------------------------------------------------------
@end
