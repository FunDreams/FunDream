//
//  FunArrayData.m
//  FunDreams
//
//  Created by Konstantin Maximov on 24.04.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import "FunArrayData.h"
#import "Ob_ParticleCont_ForStr.h"
//------------------------------------------------------------------------------------------
@implementation FunArrayData
//------------------------------------------------------------------------------------------
-(id)initWithCopasity:(int)iCopasity{

    self = [super init];

    if(self){

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
        
        [self Increase:iCopasity];
    }
    
    return self;
}
//------------------------------------------------------------------------------------------
- (void)SetSrc:(FunArrayData *)pSourceData{
    pDataSrc=pSourceData->pData;
    pTypeSrc=pSourceData->pType;
    pDataIntSrc=pSourceData->pDataIntSrc;
    pCurrenContParSrc=pSourceData->pCurrenContPar;
}
//------------------------------------------------------------------------------------------
- (void)Increase:(int)CountInc{
    
    int FirstIndex=iCount;
    iCount+=CountInc;
    pData=realloc(pData,iCount*sizeof(float));
    pDataInt=realloc(pDataInt,iCount*sizeof(int));
    pType=realloc(pType,iCount*sizeof(unsigned char));
    
    pDataSrc=pData;
    pTypeSrc=pType;
    pDataIntSrc=pDataInt;
    
    for (int i=0; i<CountInc; i++) {
        
        int Index=FirstIndex+i;

        NSNumber *pNum=[NSNumber numberWithInt:Index];
        [pFreeArray addObject:pNum];
        
        *(pDataInt+FirstIndex+i)=0;
        *(pData+FirstIndex+i)=0;
        *(pType+FirstIndex+i)=0;
    }
}
//------------------------------------------------------------------------------------------
- (void)Reserv:(int)iCountTmp{
    iCount=iCountTmp;
    
    pData=malloc(iCountTmp*sizeof(float));
    pDataInt=malloc(iCountTmp*sizeof(int));
    pType=malloc(iCountTmp*sizeof(unsigned char));

    pDataSrc=pData;
    pTypeSrc=pType;
    pDataIntSrc=pDataInt;

    memset(pData, 0, sizeof(float));
    memset(pDataInt, 0, sizeof(int));
    memset(pType, 0, sizeof(unsigned char));
}
//------------------------------------------------------------------------------------------
- (int)GetFree{
    
    if([pFreeArray count]==0){
        [self Increase:iCountInc];
    }
    
    NSNumber *pNum=[pFreeArray objectAtIndex:0];
    int IndexFree=[pNum intValue];
    [pFreeArray removeObjectAtIndex:0];
    return IndexFree;
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
                iRetIndex = [self SetOb:*((FractalString **)pDataTmp)];
                break;
                
            case DATA_MATRIX:
            {
                iRetIndex = [self SetMatrix:*((MATRIXcell **)pDataTmp)];
            }
            break;

            case DATA_FLOAT:
                iRetIndex = [self SetFloat:*pDataTmp];
                break;

            case DATA_INT:
                iRetIndex = [self SetInt:*((int *)pDataTmp)];
                break;

            case DATA_STRING:
                iRetIndex = [self SetName:*((NSMutableString **)pDataTmp)];
                break;

            case DATA_SPRITE:
                iRetIndex = [self SetSprite:*pDataTmp AddParticle:YES];
                break;

            case DATA_TEXTURE:
                iRetIndex = [self SetTexture:*((NSMutableString **)pDataTmp)];
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
- (int)SetSprite:(int)IndexSprite AddParticle:(bool)bPar{
    
    int iIndex=[self GetFree];
    
    int *TmpLink=(int *)pData+iIndex;
    int indexParticle=0;
    
    if(bPar==YES)
    {
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
    }
    
    *TmpLink=indexParticle;
    (*(pType+iIndex))=DATA_SPRITE;
    
    return iIndex;
}
//------------------------------------------------------------------------------------------
- (int)SetTexture:(NSMutableString *)DataValue{
    
    int iIndex=[self GetFree];
    
    NSString *pKey = [NSString stringWithFormat:@"%d",iIndex];
    [pNamesValue setValue:DataValue forKey:pKey];
    
    id *TmpLink=(id *)(pData+iIndex);
    *(TmpLink)=DataValue;
    
    (*(pType+iIndex))=DATA_TEXTURE;
    
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

    free(*pHeart->pNextPlaces);
    free(pHeart->pNextPlaces);
}
//------------------------------------------------------------------------------------------
- (void)InitMemoryHeart:(HeartMatr *)pHeart parent:(MATRIXcell *)pMatr{
    if(pParent==nil)return;
        
    pHeart->pEnPairPar = [pParent->m_OperationIndex InitMemory];
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pHeart->pEnPairPar);
    InfoStr->ParentMatrix=pMatr;

    pHeart->pEnPairChi = [pParent->m_OperationIndex InitMemory];
    InfoStr=(InfoArrayValue *)(*pHeart->pEnPairChi);
    InfoStr->ParentMatrix=pMatr;

    pHeart->pExPairPar = [pParent->m_OperationIndex InitMemory];
    InfoStr=(InfoArrayValue *)(*pHeart->pExPairPar);
    InfoStr->ParentMatrix=pMatr;

    pHeart->pExPairChi = [pParent->m_OperationIndex InitMemory];
    InfoStr=(InfoArrayValue *)(*pHeart->pExPairChi);
    InfoStr->ParentMatrix=pMatr;

    pHeart->pNextPlaces = [pParent->m_OperationIndex InitMemory];
    InfoStr=(InfoArrayValue *)(*pHeart->pNextPlaces);
    InfoStr->ParentMatrix=pMatr;
}
//------------------------------------------------------------------------------------------
- (void)InitMemoryMatrix:(MATRIXcell *)pMatr{
    
    if(pParent==nil)return;
    
    //паренты
    pMatr->pLinks = [pParent->m_OperationIndex InitMemory];
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pMatr->pLinks);
    InfoStr->ParentMatrix=pMatr;

    //чилды
    pMatr->pValueCopy = [pParent->m_OperationIndex InitMemory];
    InfoStr=(InfoArrayValue *)(*pMatr->pValueCopy);
    InfoStr->ParentMatrix=pMatr;

    //входные параметны
    pMatr->pEnters = [pParent->m_OperationIndex InitMemory];
    InfoStr=(InfoArrayValue *)(*pMatr->pEnters);
    InfoStr->ParentMatrix=pMatr;
//    InfoStr->mFlags&=F_ORDER;

    //выходные параметны
    pMatr->pExits = [pParent->m_OperationIndex InitMemory];
    InfoStr=(InfoArrayValue *)(*pMatr->pExits);
    InfoStr->ParentMatrix=pMatr;
//    InfoStr->mFlags&=F_ORDER;

    //связи
    pMatr->pQueue = [pParent->m_OperationIndex InitMemory];
    InfoStr=(InfoArrayValue *)(*pMatr->pQueue);
    InfoStr->ParentMatrix=pMatr;


    pMatr->TypeInformation=STR_COMPLEX;
    pMatr->NameInformation=0;
    pMatr->iIndexSelf=0;
    pMatr->sStartPlace=-1;
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

    [pParent->m_OperationIndex CopyDataFrom:pHeartData->pNextPlaces To:pHeartSelf->pNextPlaces];
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
- (int)SetMatrix:(MATRIXcell *)DataMatrix{

    int iIndex=[self GetFree];

    MATRIXcell *pNewMatr=(MATRIXcell *)malloc(sizeof(MATRIXcell));
    [self InitMemoryMatrix:pNewMatr];

    MATRIXcell **TmpLink=(MATRIXcell **)(pData+iIndex);
    *TmpLink=pNewMatr;
    
    (*(pType+iIndex))=DATA_MATRIX;
    pNewMatr->iIndexSelf=iIndex;
    
    if(DataMatrix!=0){
//copy matrix ========================================================================
        pNewMatr->NameInformation=DataMatrix->NameInformation;
        pNewMatr->TypeInformation=DataMatrix->TypeInformation;
        pNewMatr->sStartPlace=DataMatrix->sStartPlace;

        //копируем copy
        InfoArrayValue *InfoStr=(InfoArrayValue *)(*DataMatrix->pValueCopy);
        int *StartData=((*DataMatrix->pValueCopy)+SIZE_INFO_STRUCT);

        for (int i=0; i<InfoStr->mCount; i++) {//копируем все дочерние объекты
            int iTmpIndex=StartData[i];
            
            if(iTmpIndex<pParent->iIndexMaxSys)//если индекс-константа то её переименовывать не надо
            {
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
        
        //copy enters/exit
//        InfoArrayValue *InfoStrEnters=(InfoArrayValue *)(*DataMatrix->pEnters);
//        int *StartDataEnters=((*DataMatrix->pEnters)+SIZE_INFO_STRUCT);
//        
//        for (int i=0; i<InfoStrEnters->mCount; i++) {//
//            int iTmpIndex=StartDataEnters[i];
//            
//            NSNumber *pOldNum = [NSNumber numberWithInt:iTmpIndex];
//            NSNumber *pNewNum = [pDicRename objectForKey:pOldNum];
//        }
//
//        InfoArrayValue *InfoStrExit=(InfoArrayValue *)(*DataMatrix->pExits);
//        int *StartDataExit=((*DataMatrix->pExits)+SIZE_INFO_STRUCT);
        
        //pNewMatr->pQueue// copy queue
        InfoArrayValue *InfoStrQueueSelf=(InfoArrayValue *)(*pNewMatr->pQueue);
        int *StartDataQueueSelf=((*pNewMatr->pQueue)+SIZE_INFO_STRUCT);

//        InfoArrayValue *InfoStrQueue=(InfoArrayValue *)(*DataMatrix->pQueue);
        int *StartDataQueue=((*DataMatrix->pQueue)+SIZE_INFO_STRUCT);
        
        for (int i=0; i<InfoStrQueueSelf->mCount; i++) {//
            HeartMatr *pHeartSelf=(HeartMatr *)StartDataQueueSelf[i];
            HeartMatr *pHeartData=(HeartMatr *)StartDataQueue[i];
            
            if(pHeartSelf!=nil && pHeartData!=nil)
                [self CopyAndRenameHeartData:pHeartSelf from:pHeartData Dic:pDicRename];
        }
//===================================================================================
    }
    
    NSNumber *pVal = [NSNumber numberWithInt:iIndex];
    [pMartixDic setObject:pVal forKey:pVal];

    return iIndex;
}
//------------------------------------------------------------------------------------------
- (MATRIXcell *)GetMatrixAtIndex:(int)iIndex{
    if(iIndex>iCount)return 0;
    
    BYTE iType=(*(pType+iIndex));
    
    MATRIXcell **fRet=0;
    
    if(iType==DATA_MATRIX){
        fRet=(MATRIXcell **)(pData+iIndex);
        return *fRet;
    }
    else return 0;
}
//------------------------------------------------------------------------------------------
- (void *)GetDataAtIndex:(int)iIndex{
    if(iIndex>iCount)return 0;
    
    BYTE iType=(*(pType+iIndex));

    void *fRet=0;
    if(iType!=DATA_MATRIX && iType!=DATA_ID)
        fRet=(pData+iIndex);
    
    return fRet;
}
//------------------------------------------------------------------------------------------
- (id)GetIdAtIndex:(int)iIndex{
    if(iIndex>iCount)return 0;
    
    BYTE iType=(*(pType+iIndex));

    id *fRet=0;
    if(iType==DATA_ID || iType==DATA_STRING || iType==DATA_TEXTURE){
        fRet=(id *)(pData+iIndex);
        return *fRet;
    }
    else return 0;
}
//------------------------------------------------------------------------------------------
- (int)GetIncAtIndex:(int)iIndex{
    int iRet=(*(pDataInt+iIndex));
    return iRet;
}
//------------------------------------------------------------------------------------------
- (int)GetCountAtIndex:(int)iIndex{
    int iRet=(*(pDataInt+iIndex));
    return iRet;
}
//------------------------------------------------------------------------------------------
- (unsigned char)GetTypeAtIndex:(int)iIndex{
    BYTE iRet=(*(pType+iIndex));
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
    
    int *TmpIndex=((int *)pDataInt+iIndex);
    
    (*TmpIndex)=0;
    
    iCountInArray--;
    NSNumber *pNum=[NSNumber numberWithInt:iIndex];
    [pFreeArray addObject:pNum];
}
//------------------------------------------------------------------------------------------
- (void)DecDataAtIndex:(int)iIndex{
    
    int *TmpIndex=((int *)pDataInt+iIndex);
    
    if(*TmpIndex>0){
        
        (*TmpIndex)--;
        if(*TmpIndex==0)
        {
            unsigned char uType = (*(pType+iIndex));

            NSString *pKey = [NSString stringWithFormat:@"%d",iIndex];

            switch (uType) {
                case DATA_ID:
                {
                    [pNamesOb removeObjectForKey:pKey];
                }
                break;

                case DATA_MATRIX:
                {
                    MATRIXcell *pMatr=[pParent->ArrayPoints GetMatrixAtIndex:iIndex];
                    
                    [pParent->m_OperationIndex ReleaseMemory:pMatr->pValueCopy];

                    free(*pMatr->pLinks);
                    free(pMatr->pLinks);

                    free(*pMatr->pEnters);
                    free(pMatr->pEnters);

                    free(*pMatr->pExits);
                    free(pMatr->pExits);

                    NSNumber *pVal = [NSNumber numberWithInt:pMatr->iIndexSelf];
                    [pMartixDic removeObjectForKey:pVal];

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
                    
                    free(*pMatr->pQueue);
                    free(pMatr->pQueue);

                    free(pMatr);
                }
                break;

                case DATA_STRING:
                    [pNamesValue removeObjectForKey:pKey];
                
                    break;

                default:
                    break;
                    
                case DATA_SPRITE:
                {
                    [pCurrenContPar RemoveParticle:iIndex];
                }
            }

            iCountInArray--;
            NSNumber *pNum=[NSNumber numberWithInt:iIndex];
            [pFreeArray addObject:pNum];
        }
    }
}
//------------------------------------------------------------------------------------------
-(void)selfSave:(NSMutableData *)m_pData{
    
    [m_pData appendBytes:&iCount length:sizeof(int)];
    [m_pData appendBytes:&iCountInArray length:sizeof(int)];
    [m_pData appendBytes:&iCountInc length:sizeof(int)];
    
    [m_pData appendBytes:pData length:iCount*sizeof(float)];
    [m_pData appendBytes:pDataInt length:iCount*sizeof(int)];
    [m_pData appendBytes:pType length:iCount*sizeof(unsigned char)];

//сохраняем свободные ячейки------------------------------------------------------
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:pFreeArray];
    int iLen=[data length];
    
    [m_pData appendBytes:&iLen length:sizeof(int)];
    [m_pData appendData:data];
//--------------------------------------------------------------------------------
    data=[NSKeyedArchiver archivedDataWithRootObject:pNamesOb];
    iLen=[data length];
    
    [m_pData appendBytes:&iLen length:sizeof(int)];
    [m_pData appendData:data];
//--------------------------------------------------------------------------------
    data=[NSKeyedArchiver archivedDataWithRootObject:pNamesValue];
    iLen=[data length];
    
    [m_pData appendBytes:&iLen length:sizeof(int)];
    [m_pData appendData:data];
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
//--------------------------------------------------------------------------------
    iLen = [pMartixDic count];
    [m_pData appendBytes:&iLen length:sizeof(int)];

    //сохраняем матрицы
    NSEnumerator *Matr_enumerator = [pMartixDic objectEnumerator];
    NSNumber *pValueMatr;
    
    while ((pValueMatr = [Matr_enumerator nextObject])){
        
        MATRIXcell *pMatr = [self GetMatrixAtIndex:[pValueMatr intValue]];
        [self SaveMatrix:m_pData WithMatr:pMatr];
    }
    
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

        if(pFStr==0)*fRet=0;
        else *fRet=pFStr;
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
                            
                            free(*TmpString->pChildString);
                            free(TmpString->pChildString);
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
    [self Reserv:iCount];
    
    [m_pData getBytes:&iCountInArray range:NSMakeRange( *iCurReadingPos, sizeof(int))];
    *iCurReadingPos += sizeof(int);

    [m_pData getBytes:&iCountInc range:NSMakeRange( *iCurReadingPos, sizeof(int))];
    *iCurReadingPos += sizeof(int);

    [m_pData getBytes:pData range:NSMakeRange( *iCurReadingPos, iCount*sizeof(float))];
    *iCurReadingPos += iCount*sizeof(float);
    
    [m_pData getBytes:pDataInt range:NSMakeRange( *iCurReadingPos, iCount*sizeof(int))];
    *iCurReadingPos += iCount*sizeof(int);

    [m_pData getBytes:pType range:NSMakeRange( *iCurReadingPos, iCount*sizeof(unsigned char))];
    *iCurReadingPos += iCount*sizeof(unsigned char);
//--------------------------------------------------------------------------------
    int iLen;
    [m_pData getBytes:&iLen range:NSMakeRange( *iCurReadingPos, sizeof(int))];
    *iCurReadingPos += sizeof(int);

    NSData *iv = [m_pData subdataWithRange:NSMakeRange(*iCurReadingPos, iLen)];
    
    if(pFreeArray!=nil)[pFreeArray release];
    pFreeArray = [[NSKeyedUnarchiver unarchiveObjectWithData:iv] retain];
    
    *iCurReadingPos += iLen;
//--------------------------------------------------------------------------------
    [m_pData getBytes:&iLen range:NSMakeRange( *iCurReadingPos, sizeof(int))];
    *iCurReadingPos += sizeof(int);
    
    iv = [m_pData subdataWithRange:NSMakeRange(*iCurReadingPos, iLen)];
    
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

    int Count=0;
    [m_pData getBytes:&Count range:NSMakeRange( *iCurReadingPos, sizeof(int))];
    *iCurReadingPos += sizeof(int);
    
    [DicAllAssociations removeAllObjects];
    
    for(int i=0;i<Count;i++){
        
        [m_pData getBytes:&iLen range:NSMakeRange( *iCurReadingPos, sizeof(int))];
        *iCurReadingPos += sizeof(int);
        
        iv = [m_pData subdataWithRange:NSMakeRange(*iCurReadingPos, iLen)];
        
        NSMutableDictionary *TmpDic = [[NSKeyedUnarchiver unarchiveObjectWithData:iv] retain];
        
        if(TmpDic!=nil){
            NSString *pKey = [NSString stringWithFormat:@"%p",TmpDic];
            [DicAllAssociations setObject:TmpDic forKey:pKey];
            [TmpDic release];
        }
        
        *iCurReadingPos += iLen;
    }
//--------------------------------------------------------------------------------
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
    InfoStr->ParentMatrix=pMatr;

    [pParent->m_OperationIndex selfLoad:pMutData rpos:iCurReadingPos WithData:pHeart->pEnPairChi];
    InfoStr=(InfoArrayValue *)(*pHeart->pEnPairChi);
    InfoStr->ParentMatrix=pMatr;

    [pParent->m_OperationIndex selfLoad:pMutData rpos:iCurReadingPos WithData:pHeart->pExPairPar];
    InfoStr=(InfoArrayValue *)(*pHeart->pExPairPar);
    InfoStr->ParentMatrix=pMatr;

    [pParent->m_OperationIndex selfLoad:pMutData rpos:iCurReadingPos WithData:pHeart->pExPairChi];
    InfoStr=(InfoArrayValue *)(*pHeart->pExPairChi);
    InfoStr->ParentMatrix=pMatr;

    [pParent->m_OperationIndex selfLoad:pMutData rpos:iCurReadingPos WithData:pHeart->pNextPlaces];
    InfoStr=(InfoArrayValue *)(*pHeart->pNextPlaces);
    InfoStr->ParentMatrix=pMatr;
}
//------------------------------------------------------------------------------------------
- (void)LoadMatrix:(NSMutableData *)pMutData rpos:(int *)iCurReadingPos WithMatr:(MATRIXcell *)pMatr{
    
    [pParent->m_OperationIndex selfLoad:pMutData rpos:iCurReadingPos WithData:pMatr->pValueCopy];
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pMatr->pValueCopy);
    InfoStr->ParentMatrix=pMatr;

    [pParent->m_OperationIndex selfLoad:pMutData rpos:iCurReadingPos WithData:pMatr->pLinks];
    InfoStr=(InfoArrayValue *)(*pMatr->pLinks);
    InfoStr->ParentMatrix=pMatr;

    [pParent->m_OperationIndex selfLoad:pMutData rpos:iCurReadingPos WithData:pMatr->pEnters];
    InfoStr=(InfoArrayValue *)(*pMatr->pEnters);
    InfoStr->ParentMatrix=pMatr;

    [pParent->m_OperationIndex selfLoad:pMutData rpos:iCurReadingPos WithData:pMatr->pExits];
    InfoStr=(InfoArrayValue *)(*pMatr->pExits);
    InfoStr->ParentMatrix=pMatr;
    
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
    
    //точка входа.
    Range = NSMakeRange( *iCurReadingPos, sizeof(short));
    [pMutData getBytes:&pMatr->sStartPlace range:Range];
    *iCurReadingPos += sizeof(short);

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

    [pParent->m_OperationIndex selfSave:pMutData WithData:pHeart->pNextPlaces];
}
//------------------------------------------------------------------------------------------
- (void)SaveMatrix:(NSMutableData *)pMutData WithMatr:(MATRIXcell *)pMatr{
    
    [pParent->m_OperationIndex selfSave:pMutData WithData:pMatr->pValueCopy];
    [pParent->m_OperationIndex selfSave:pMutData WithData:pMatr->pLinks];

    [pParent->m_OperationIndex selfSave:pMutData WithData:pMatr->pEnters];
    [pParent->m_OperationIndex selfSave:pMutData WithData:pMatr->pExits];

    //тип струны.
    [pMutData appendBytes:&pMatr->TypeInformation length:sizeof(BYTE)];
    //Имя-число струны.
    [pMutData appendBytes:&pMatr->NameInformation length:sizeof(short)];
    //Индекс струны.
    [pMutData appendBytes:&pMatr->iIndexSelf length:sizeof(int)];
    //точка входа.
    [pMutData appendBytes:&pMatr->sStartPlace length:sizeof(short)];

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
- (void)dealloc
{
    free(pData);
    free(pDataInt);
    free(pType);
    [pFreeArray release];
    
    [pNamesOb release];
    [pNamesValue release];
    [pMartixDic release];
    [pDicRename release];
    [DicAllAssociations release];

    [super dealloc];
}
//------------------------------------------------------------------------------------------
@end
