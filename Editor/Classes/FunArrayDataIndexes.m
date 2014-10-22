//
//  FunArrayData.m
//  FunDreams
//
//  Created by Konstantin Maximov on 24.04.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import "FunArrayDataIndexes.h"
@implementation FunArrayDataIndexes
//------------------------------------------------------------------------------------------
-(id)init{
    
    self = [super init];
    return self;
}
//------------------------------------------------------------------------------------------------------
- (void)InitStructure:(int **)pData{
    
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);
    
    InfoStr->mGroup=0;
    InfoStr->mFlags=0;
    InfoStr->mType=0;
    InfoStr->mCount=0;
    InfoStr->mCopasity=0;
    InfoStr->mCountAdd=1;
    InfoStr->UnParentMatrix.ParentMatrix=0;
}
//------------------------------------------------------------------------------------------------------
- (int **)InitMemory{

    int ** pData = (int **)malloc(sizeof(int));
    *pData = (int *)malloc(sizeof(InfoArrayValue));
    [self InitStructure:pData];
//    [self SetCopasity:50 WithData:pData];
    return pData;
}
//------------------------------------------------------------------------------------------------------
- (void)OnlyReleaseMemory:(int **)pData{
    
    if(pData!=0)
    {
        if(*pData!=0)free(*pData);
        free(pData);
    }
}
//------------------------------------------------------------------------------------------------------
- (void)ClearArray:(int **)pData{
    
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);
    
    if((InfoStr->mFlags & F_DATA) && InfoStr->mType!=DATA_U_INT)
    {
        int iCount=InfoStr->mCount;
        for(int i=0;i<iCount;i++){
            
            int index=(*pData+SIZE_INFO_STRUCT)[i];
            [m_pParent->ArrayPoints DecDataAtIndex:index];
        }
    }

    InfoStr->mCount=0;
}
//------------------------------------------------------------------------------------------------------
- (void)ReleaseMemory:(int **)pData{

    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);

    if((InfoStr->mFlags & F_DATA) && InfoStr->mType!=DATA_U_INT)
    {
        int iCount=InfoStr->mCount;
        for(int i=0;i<iCount;i++){
            
            int index=(*pData+SIZE_INFO_STRUCT)[i];
            [m_pParent->ArrayPoints DecDataAtIndex:index];
        }
    }
    
    free(*pData);
    free(pData);
}
//------------------------------------------------------------------------------------------
-(void)SetCopasity:(int)icopasity WithData:(int **)pData{
    
    if(icopasity<0)return;
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);
    
    InfoStr->mCopasity=icopasity;
    
    if(InfoStr->mCount>icopasity)
        InfoStr->mCount=icopasity;
    
    int FullSize=InfoStr->mCopasity*sizeof(int)+sizeof(InfoArrayValue);
    *pData = (int *)realloc(*pData,FullSize);
}
//------------------------------------------------------------------------------------------
- (void)Extend:(int **)pData{
    
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);

    if(InfoStr->mCopasity==InfoStr->mCount){
        InfoStr->mCopasity+=InfoStr->mCountAdd;
                
        [self SetCopasity:InfoStr->mCopasity WithData:pData];        
    }
}
//------------------------------------------------------------------------------------------
- (void)CopyDataFrom:(int **)pSourceData To:(int **)pDestData{
    
    InfoArrayValue *InfoStrSource=(InfoArrayValue *)(*pSourceData);
    InfoArrayValue *InfoStrDest=(InfoArrayValue *)(*pDestData);
        
    if(InfoStrSource->mCount>0)
    {    
        *InfoStrDest=*InfoStrSource;

        [self SetCopasity:InfoStrSource->mCopasity WithData:pDestData];
        
        int *StartDataSource=((*pSourceData)+SIZE_INFO_STRUCT);
        int *StartDataDest=((*pDestData)+SIZE_INFO_STRUCT);
        
        memcpy(StartDataDest, StartDataSource, sizeof(int)*(InfoStrSource->mCount));
    }
}
//------------------------------------------------------------------------------------------
- (int)FindIndex:(int)IndexValue WithData:(int **)pData{
    int iRet=-1;
    
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);
    int *StartData=((*pData)+SIZE_INFO_STRUCT);

    for (int i=0; i<InfoStr->mCount; i++) {
        int iTmpIndex=StartData[i];
        if(iTmpIndex==IndexValue){
            iRet=i;
            break;
        }
    }
    
    return iRet;
}
//------------------------------------------------------------------------------------------
- (void)SetParentMatrix:(int)IndexValue WithData:(int **)pData{
    
    InfoArrayValue *pInfo=(InfoArrayValue *)*pData;
    int iIndexMatrix=pInfo->UnParentMatrix.ParentMatrix->iIndexSelf;
    MATRIXcell *TmpMatr=0;
    
    if(m_pParent->m_bInDropBox==NO)
    {
        TmpMatr=*((MATRIXcell **)(m_pParent->ArrayPoints->pData+IndexValue));
    }
    else
    {
        TmpMatr=*((MATRIXcell **)(m_pParent->ArrayPoints->pDataSrc+IndexValue));
    }

    if(TmpMatr!=0)
    {
        [self OnlyAddData:iIndexMatrix WithData:TmpMatr->pLinks];
    }
}
//------------------------------------------------------------------------------------------
- (void)OnlyAddData:(int)IndexValue WithData:(int **)pData{
    
    [self Extend:pData];
    
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);
    int *StartData=((*pData)+SIZE_INFO_STRUCT);
    
    StartData[InfoStr->mCount]=IndexValue;
    InfoStr->mCount++;
}
//------------------------------------------------------------------------------------------
- (void)OnlyInsert:(int)iDataValue index:(int)iIndex WithData:(int **)pData{
    [self Extend:pData];
    
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);
    int *StartData=((*pData)+SIZE_INFO_STRUCT);
    
    memcpy(StartData+iIndex+1, StartData+iIndex, sizeof(int)*(InfoStr->mCount-(iIndex)));
    StartData[iIndex]=iDataValue;
    
    InfoStr->mCount++;
}
//------------------------------------------------------------------------------------------
- (void)AddData:(int)IndexValue WithData:(int **)pData{
        
    [self Extend:pData];
    
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);
    
    int *StartData=((*pData)+SIZE_INFO_STRUCT);
    
    StartData[InfoStr->mCount]=IndexValue;
    
    int iType=0;
    
    if(IndexValue>=RESERV_KERNEL)
        iType=*(m_pParent->ArrayPoints->pType+IndexValue);
    else iType=*(m_pParent->ArrayPoints->pTypeSrc+IndexValue);
    
    if(iType==DATA_MATRIX && m_pParent->m_bInDropBox==NO){
        [self SetParentMatrix:IndexValue WithData:pData];
    }

    if((InfoStr->mFlags & F_SYS) && InfoStr->UnParentMatrix.ParentMatrix!=0){
        //добавляем пустое место в queue
        MATRIXcell *pMatrPar = InfoStr->UnParentMatrix.ParentMatrix;
        
        [self Extend:pMatrPar->pQueue];
        InfoArrayValue *InfoQueue=(InfoArrayValue *)(*pMatrPar->pQueue);
        int *StartDataQueue=((*pMatrPar->pQueue)+SIZE_INFO_STRUCT);
        
        //инициализация heart
        HeartMatr *pNewHeart=0;

        if(iType==DATA_MATRIX)
        {
            pNewHeart=(HeartMatr *)malloc(sizeof(HeartMatr));
            [m_pParent->ArrayPoints InitMemoryHeart:pNewHeart parent:pMatrPar];
            
            MATRIXcell *pMatrParCurr = [m_pParent->ArrayPoints GetMatrixAtIndex:IndexValue];
//инициализируем сердце (делаем копию пап индексов)=================================================
            InfoArrayValue *InfoEnters=(InfoArrayValue *)(*pMatrParCurr->pEnters);
            [m_pParent->m_OperationIndex SetCopasity:InfoEnters->mCount WithData:pNewHeart->pEnPairPar];
            [m_pParent->m_OperationIndex SetCopasity:InfoEnters->mCount WithData:pNewHeart->pEnPairChi];
            InfoArrayValue *InfoEnPar=(InfoArrayValue *)(*pNewHeart->pEnPairPar);
            InfoArrayValue *InfoEnChi=(InfoArrayValue *)(*pNewHeart->pEnPairChi);
            InfoEnPar->mCount=InfoEnters->mCount;
            InfoEnChi->mCount=InfoEnters->mCount;
            
            for (int i=0; i<InfoEnters->mCount; i++) {
                int iIndexTmp=(*pMatrParCurr->pEnters+SIZE_INFO_STRUCT)[i];
                (*pNewHeart->pEnPairPar+SIZE_INFO_STRUCT)[i]=iIndexTmp;
                (*pNewHeart->pEnPairChi+SIZE_INFO_STRUCT)[i]=iIndexTmp;
            }
            
            InfoArrayValue *InfoExit=(InfoArrayValue *)(*pMatrParCurr->pExits);
            [m_pParent->m_OperationIndex SetCopasity:InfoExit->mCount WithData:pNewHeart->pExPairPar];
            [m_pParent->m_OperationIndex SetCopasity:InfoExit->mCount WithData:pNewHeart->pExPairChi];
            InfoArrayValue *InfoExPar=(InfoArrayValue *)(*pNewHeart->pExPairPar);
            InfoArrayValue *InfoExChi=(InfoArrayValue *)(*pNewHeart->pExPairChi);
            InfoExPar->mCount=InfoExit->mCount;
            InfoExChi->mCount=InfoExit->mCount;
            
            for (int i=0; i<InfoExit->mCount; i++) {
                
                int iIndexTmp=(*pMatrParCurr->pExits+SIZE_INFO_STRUCT)[i];
                (*pNewHeart->pExPairPar+SIZE_INFO_STRUCT)[i]=iIndexTmp;
                (*pNewHeart->pExPairChi+SIZE_INFO_STRUCT)[i]=iIndexTmp;
            }
            
            InfoArrayValue *pValueCopyInfo=(InfoArrayValue *)(*pMatrParCurr->pValueCopy);
            
            if(pMatrParCurr->TypeInformation==STR_OPERATION && pValueCopyInfo->mCount>2){//инициализируем режимы
                
                int iIndexMatrMode= *((*pMatrParCurr->pValueCopy)+SIZE_INFO_STRUCT);
                MATRIXcell *pMatrMode = [m_pParent->ArrayPoints GetMatrixAtIndex:iIndexMatrMode];
                InfoArrayValue *pInfoMode=(InfoArrayValue *)(*pMatrMode->pValueCopy);
                
                if(pInfoMode->mCount>0){
                    [m_pParent->m_OperationIndex SetCopasity:pInfoMode->mCount WithData:pNewHeart->pModes];
                    
                    for (int i=0; i<pInfoMode->mCount; i++) {
                        (*pNewHeart->pModes+SIZE_INFO_STRUCT)[i]=0;
                    }
                }
            }
//===================================================================================================
        }
        
        //копирование в массив
        HeartMatr **TmpHeart=(HeartMatr **)(StartDataQueue+InfoQueue->mCount);
        *TmpHeart=pNewHeart;
        
        InfoQueue->mCount++;
    }
    
    InfoStr->mCount++;
    [m_pParent->ArrayPoints IncDataAtIndex:IndexValue];
}
//------------------------------------------------------------------------------------------
- (void)RemoveAllConnections:(NSMutableDictionary *)DataLoops
             RootMatr:(MATRIXcell *)pRootMatr SearchCurIndex:(int)iIndex{
    
    InfoArrayValue *InfoStr;
    HeartMatr *pHeart;
    int **ppArray=[m_pParent->ArrayPoints GetArrayAtIndex:iIndex];
    if(ppArray==0)return;
    
    InfoStr=(InfoArrayValue *)(*pRootMatr->pValueCopy);
    int *StartData=((*pRootMatr->pValueCopy)+SIZE_INFO_STRUCT);
    int *StartDataQueue=((*pRootMatr->pQueue)+SIZE_INFO_STRUCT);
    
    for (int i=0; i<InfoStr->mCount; i++) {
        
        int iTmpIndex=StartData[i];
        pHeart=(HeartMatr *)(StartDataQueue[i]);

        int iType=0;
        if(m_pParent->ArrayPoints->m_bSaveKernel==YES)
            iType=*(m_pParent->ArrayPoints->pTypeSrc+iTmpIndex);
        else iType=*(m_pParent->ArrayPoints->pType+iTmpIndex);

        if(iType==DATA_MATRIX){
///////////////////////////////////////////////////////////////////////////////////////////////////////
            //удаляем связи
            int *SDataEnetesPar=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT);
            int *SDataEnetesChi=((*pHeart->pEnPairChi)+SIZE_INFO_STRUCT);
            InfoArrayValue *InfoStrEnter=(InfoArrayValue *)(*pHeart->pEnPairPar);
            
            int *SDataExitsPar=((*pHeart->pExPairPar)+SIZE_INFO_STRUCT);
            int *SDataExitsChi=((*pHeart->pExPairChi)+SIZE_INFO_STRUCT);
            InfoArrayValue *InfoStrExits=(InfoArrayValue *)(*pHeart->pExPairPar);

            for (int j=0; j<InfoStrEnter->mCount; j++) {
                int TmpInd=SDataEnetesPar[j];

                if(TmpInd==iIndex)
                {
                    SDataEnetesPar[j]=SDataEnetesChi[j];
                    
                    //удаляем связанные пространства объектов
                    MATRIXcell *pMatr=[m_pParent->ArrayPoints GetMatrixAtIndex:iTmpIndex];

                    if(pMatr!=nil && pMatr->TypeInformation==STR_OPERATION)
                    {
                        int iIndexMatrLink=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[2];
                        MATRIXcell *pMatrLink=[m_pParent->ArrayPoints GetMatrixAtIndex:iIndexMatrLink];
                        InfoArrayValue *pInfoEnter=(InfoArrayValue *)*pMatrLink->pValueCopy;

                        int iIndexMatrLink2=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[3];
                        MATRIXcell *pMatrLink2=[m_pParent->ArrayPoints GetMatrixAtIndex:iIndexMatrLink2];

                        for (int k=0; k<pInfoEnter->mCount; k++)
                        {
                            int iIndexArrayLink=(*pMatrLink->pValueCopy+SIZE_INFO_STRUCT)[k];
                            int **ArrayLink=[m_pParent->ArrayPoints GetArrayAtIndex:iIndexArrayLink];
                                                        
                            int iRez=[self FindIndex:j WithData:ArrayLink];

                            if(iRez!=-1)
                            {
                                InfoArrayValue *pInfoTmpLinkInside=(InfoArrayValue *)*ArrayLink;
                                for (int m=0; m<pInfoTmpLinkInside->mCount; m++)
                                {
                                    int iTmpPlace=(*ArrayLink+SIZE_INFO_STRUCT)[m];
                                    SDataEnetesPar[iTmpPlace]=SDataEnetesChi[iTmpPlace];
                                }
                                
                                int iIndexArrayLink2=(*pMatrLink2->pValueCopy+SIZE_INFO_STRUCT)[k];
                                int **ArrayLink2=[m_pParent->ArrayPoints GetArrayAtIndex:iIndexArrayLink2];

                                pInfoTmpLinkInside=(InfoArrayValue *)*ArrayLink2;
                                for (int m=0; m<pInfoTmpLinkInside->mCount; m++)
                                {
                                    int iTmpPlace=(*ArrayLink2+SIZE_INFO_STRUCT)[m];
                                    SDataExitsPar[iTmpPlace]=SDataExitsChi[iTmpPlace];
                                }

                                goto Exit;
                            }
                        }
                    }
                }
            }

            for (int j=0; j<InfoStrExits->mCount; j++) {
                int TmpInd=SDataExitsPar[j];

                if(TmpInd==iIndex)
                {
                    SDataExitsPar[j]=SDataExitsChi[j];
                    
                    //удаляем связанные пространства объектов
                    MATRIXcell *pMatr=[m_pParent->ArrayPoints GetMatrixAtIndex:iTmpIndex];
                    
                    if(pMatr!=nil && pMatr->TypeInformation==STR_OPERATION)
                    {
                        int iIndexMatrLink=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[3];
                        MATRIXcell *pMatrLink=[m_pParent->ArrayPoints GetMatrixAtIndex:iIndexMatrLink];
                        InfoArrayValue *pInfoEnter=(InfoArrayValue *)*pMatrLink->pValueCopy;
                        
                        int iIndexMatrLink2=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[2];
                        MATRIXcell *pMatrLink2=[m_pParent->ArrayPoints GetMatrixAtIndex:iIndexMatrLink2];
                        
                        for (int k=0; k<pInfoEnter->mCount; k++)
                        {
                            int iIndexArrayLink=(*pMatrLink->pValueCopy+SIZE_INFO_STRUCT)[k];
                            int **ArrayLink=[m_pParent->ArrayPoints GetArrayAtIndex:iIndexArrayLink];
                            
                            int iRez=[self FindIndex:j WithData:ArrayLink];
                            
                            if(iRez!=-1)
                            {
                                InfoArrayValue *pInfoTmpLinkInside=(InfoArrayValue *)*ArrayLink;
                                for (int m=0; m<pInfoTmpLinkInside->mCount; m++)
                                {
                                    int iTmpPlace=(*ArrayLink+SIZE_INFO_STRUCT)[m];
                                    SDataExitsPar[iTmpPlace]=SDataExitsChi[iTmpPlace];
                                }
                                
                                int iIndexArrayLink2=(*pMatrLink2->pValueCopy+SIZE_INFO_STRUCT)[k];
                                int **ArrayLink2=[m_pParent->ArrayPoints GetArrayAtIndex:iIndexArrayLink2];
                                
                                pInfoTmpLinkInside=(InfoArrayValue *)*ArrayLink2;
                                for (int m=0; m<pInfoTmpLinkInside->mCount; m++)
                                {
                                    int iTmpPlace=(*ArrayLink2+SIZE_INFO_STRUCT)[m];
                                    SDataEnetesPar[iTmpPlace]=SDataEnetesChi[iTmpPlace];
                                }
                                
                                goto Exit;
                            }
                        }
                    }
                }
            }
Exit:
///////////////////////////////////////////////////////////////////////////////////////////////////////
            if(DataLoops!=nil)
            {
                NSNumber *pNum=[NSNumber numberWithInt:iTmpIndex];
                NSNumber *TmpNum=[DataLoops objectForKey:pNum];

                if(TmpNum==nil)
                {
                    MATRIXcell *pMatrDeep=[m_pParent->ArrayPoints GetMatrixAtIndex:iTmpIndex];
                    [DataLoops setObject:pNum forKey:pNum];
                    [self RemoveAllConnections:DataLoops RootMatr:pMatrDeep SearchCurIndex:iIndex];
                }
            }
        }
    }
}
//------------------------------------------------------------------------------------------
- (bool)CheckHierarhy:(NSMutableDictionary *)DataLoops
             RootMatr:(MATRIXcell *)pRootMatr SearchCurIndex:(int)iIndex{
    
    bool bRez=NO;
    InfoArrayValue *InfoStr;
    int *StartData;
    
    InfoStr=(InfoArrayValue *)(*pRootMatr->pValueCopy);
    StartData=((*pRootMatr->pValueCopy)+SIZE_INFO_STRUCT);

    for (int i=0; i<InfoStr->mCount; i++) {
        
        int iTmpIndex=StartData[i];
        
        if(iIndex==iTmpIndex){
            bRez=YES;
            break;
        }

        int iType=0;
        if(m_pParent->ArrayPoints->m_bSaveKernel==YES)
            iType=*(m_pParent->ArrayPoints->pTypeSrc+iTmpIndex);
        else iType=*(m_pParent->ArrayPoints->pType+iTmpIndex);
        
        if(iType==DATA_MATRIX){

            NSNumber *pNum=[NSNumber numberWithInt:iTmpIndex];
            NSNumber *TmpNum=[DataLoops objectForKey:pNum];

            if(TmpNum==nil)
            {
                MATRIXcell *pMatrDeep=[m_pParent->ArrayPoints GetMatrixAtIndex:iTmpIndex];
                [DataLoops setObject:pNum forKey:pNum];
                bRez=[self CheckHierarhy:DataLoops RootMatr:pMatrDeep SearchCurIndex:iIndex];
                if(bRez==YES)break;
            }
        }
    }
    
    return bRez;
}
//------------------------------------------------------------------------------------------
- (void)OnlyRemoveDataAtPlaceSort:(int)iPlace WithData:(int **)pData{
    
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);
    
    if(InfoStr->mCount>0)
    {
        int *StartData=((*pData)+SIZE_INFO_STRUCT);
        
        if(iPlace+1<InfoStr->mCount)
            memcpy(StartData+iPlace, StartData+iPlace+1, sizeof(int)*(InfoStr->mCount-(iPlace+1)));
        
        InfoStr->mCount--;
        [self SetCopasity:InfoStr->mCount WithData:pData];
    }
}
//------------------------------------------------------------------------------------------
- (void)OnlyRemoveDataAtPlace:(int)iPlace WithData:(int **)pData{
    
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);
    
    if(InfoStr->mCount>0)
    {
        int *StartData=((*pData)+SIZE_INFO_STRUCT);
        
        if(iPlace+1<InfoStr->mCount)
            memcpy(StartData+iPlace, StartData+(InfoStr->mCount-1), sizeof(int));
        
        InfoStr->mCount--;
        [self SetCopasity:InfoStr->mCount WithData:pData];
    }
}
//------------------------------------------------------------------------------------------
- (void)OnlyRemoveDataAtIndex:(int)iIndex WithData:(int **)pData{
    
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);
    
    if(InfoStr->mCount>0)
    {
        int *StartData=((*pData)+SIZE_INFO_STRUCT);
        
        for (int i=0; i<InfoStr->mCount; i++) {
            int itmpIndex = StartData[i];
            
            if(itmpIndex==iIndex){
                
                if(i+1<InfoStr->mCount)
                    memcpy(StartData+i, StartData+i+1, sizeof(int)*(InfoStr->mCount-(i+1)));
                
                InfoStr->mCount--;
                [self SetCopasity:InfoStr->mCount WithData:pData];

                return;
            }
        }
    }
}
//------------------------------------------------------------------------------------------
- (void)EditEnterPoint:(int)iPlace matr:(MATRIXcell *)pCurrentMatrix{
    //редактируем точку входа
    
    InfoArrayValue *InfoStr=(InfoArrayValue*)*pCurrentMatrix->pQueue;
    int *TmpPlace=(*pCurrentMatrix->ppStartPlaces+SIZE_INFO_STRUCT);
    
    if(*TmpPlace==iPlace){
        *TmpPlace=-1;
    }
    
    if(*TmpPlace==(InfoStr->mCount-1)){
        *TmpPlace=iPlace;
    }
}
//------------------------------------------------------------------------------------------
- (void)RemoveDataAtPlace:(int)iPlace WithData:(int **)pData{
    
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);
    if(iPlace+1>InfoStr->mCount)return;
    if(InfoStr->mCount==0)return;
    
    int *StartData=((*pData)+SIZE_INFO_STRUCT);
    
    int iTmpIndex=StartData[iPlace];
//проверяем вложеные сслылки на удаляемую матрицу================================================
    int iType=0;
    if(m_pParent->ArrayPoints->m_bSaveKernel==YES)
        iType=*(m_pParent->ArrayPoints->pType+iTmpIndex);
    else iType=*(m_pParent->ArrayPoints->pType+iTmpIndex);

    if(iType==DATA_MATRIX){

        MATRIXcell *pCurrentMatrixPar=InfoStr->UnParentMatrix.ParentMatrix;
        int iIndexCurrentMatr=pCurrentMatrixPar->iIndexSelf;
        
        InfoArrayValue *InfoQueue=(InfoArrayValue *)(*InfoStr->UnParentMatrix.ParentMatrix->pQueue);
        int *StartDataQueue=((*pCurrentMatrixPar->pQueue)+SIZE_INFO_STRUCT);
        
        MATRIXcell *TmpMatrForDel=[m_pParent->ArrayPoints GetMatrixAtIndex:iTmpIndex];
        InfoArrayValue *InfoStrLinks=(InfoArrayValue *)(*TmpMatrForDel->pLinks);
        int *StartDataLink=((*TmpMatrForDel->pLinks)+SIZE_INFO_STRUCT);
        
//удаляем пару
        [self EditEnterPoint:iPlace matr:pCurrentMatrixPar];
                
        //удаляем место в queue
        HeartMatr *pHeart=*((HeartMatr **)(StartDataQueue+iPlace));
//удаляем из меток=================================================================================
        if(pHeart!=0){//удаляем ссылки на текущий

            for (int i=0; i<InfoQueue->mCount; i++) {
                HeartMatr *pHeartTmp=(HeartMatr *)StartDataQueue[i];
                
                if(pHeartTmp!=0){
                    
                    if(pHeartTmp->pNextPlace==iPlace)
                        pHeartTmp->pNextPlace=-1;
                }
            }
            
            for (int i=0; i<InfoQueue->mCount; i++) {//переименовываем
                HeartMatr *pHeart=(HeartMatr *)StartDataQueue[i];

                if(pHeart!=0){
                   
                    if(pHeart->pNextPlace==(InfoQueue->mCount-1))
                        pHeart->pNextPlace=iPlace;
                }
            }

            
            [m_pParent->ArrayPoints ReleaseMemoryHeart:pHeart];
            free(pHeart);
        }
        
        //удаление индека с матрицы парента
        memcpy(StartData+iPlace, StartData+(InfoStr->mCount-1), sizeof(int));
        InfoStr->mCount--;
        [self SetCopasity:InfoStr->mCount WithData:pCurrentMatrixPar->pValueCopy];
        
        memcpy(StartDataQueue+iPlace, StartDataQueue+(InfoQueue->mCount-1), sizeof(int));
        InfoQueue->mCount--;
        [self SetCopasity:InfoQueue->mCount WithData:pCurrentMatrixPar->pQueue];

//////////////////////////////////////////////////////////////////////////////////////////////////////
        if(InfoStrLinks->mCount>0){
            
            for (int i=0; i<InfoStrLinks->mCount; i++) {
                int itmpIndexLink = StartDataLink[i];
                
                if(itmpIndexLink==iIndexCurrentMatr)
                {
                    memcpy(StartDataLink+i, StartDataLink+(InfoStrLinks->mCount-1), sizeof(int));
                    InfoStrLinks->mCount--;
                    [self SetCopasity:InfoStrLinks->mCount WithData:TmpMatrForDel->pLinks];
                    InfoStrLinks=(InfoArrayValue *)(*TmpMatrForDel->pLinks);
                    StartDataLink=((*TmpMatrForDel->pLinks)+SIZE_INFO_STRUCT);
                    break;
                }
            }

            if(InfoStrLinks->mCount>0)
            {
                MATRIXcell *pMatrZero=[m_pParent->ArrayPoints GetMatrixAtIndex:0];
                
                NSMutableDictionary *DataLoops = [[NSMutableDictionary alloc] init];
                bool Rez=[self CheckHierarhy:DataLoops RootMatr:pMatrZero SearchCurIndex:iTmpIndex];
                [DataLoops release];
                
                if(Rez==NO){//удалаем все ссылки на данную струну из матрицы
                    
                    int iCount=InfoStrLinks->mCount;
                    InfoStrLinks->mCount=0;
                    for (int i=0; i<iCount; i++) {
                        int iInsideIndex = StartDataLink[i];//индекс матрицы парента
                        
                        MATRIXcell *pMatrParLink=[m_pParent->ArrayPoints GetMatrixAtIndex:iInsideIndex];
                        int iCountTmp=[m_pParent->ArrayPoints GetCountAtIndex:iInsideIndex];

                        if(pMatrParLink!=0 && iCountTmp>0)
                        {
                            int iRet=-1;
                            iRet=[self FindIndex:iTmpIndex WithData:pMatrParLink->pValueCopy];
                            if(iRet>-1)[self RemoveDataAtPlace:iRet WithData:pMatrParLink->pValueCopy];
                        }
                    }
                    
                    [self SetCopasity:0 WithData:TmpMatrForDel->pLinks];
                    InfoStrLinks=(InfoArrayValue *)(*TmpMatrForDel->pLinks);
                    StartDataLink=((*TmpMatrForDel->pLinks)+SIZE_INFO_STRUCT);
                }
            }
        }
        [m_pParent->ArrayPoints DecDataAtIndex:iTmpIndex];
    }
//================================================================================================
    else
    {//удаление из связей (сначала в текущей матрице)

        if(iType==DATA_ARRAY){//удалаем массив из матрицы данных
            
            int **ppDataArray=[m_pParent->ArrayPoints GetArrayAtIndex:iTmpIndex];
            InfoArrayValue *pInfoArray=(InfoArrayValue *)*ppDataArray;
            if(ppDataArray!=0 && (pInfoArray->mFlags & F_DATA) && pInfoArray->UnParentMatrix.indexMatrix!=0)
            {
                MATRIXcell *pDataMatrix=[m_pParent->ArrayPoints
                                    GetMatrixAtIndex:pInfoArray->UnParentMatrix.indexMatrix];
                
                int iCountTmp=[m_pParent->ArrayPoints GetCountAtIndex:iTmpIndex];
                if(pDataMatrix!=0 && iCountTmp==1)
                {
                    [self OnlyRemoveDataAtIndex:iTmpIndex WithData:pDataMatrix->ppDataMartix];
                }
            }

            [self OnlyRemoveDataAtIndex:iTmpIndex WithData:InfoStr->UnParentMatrix.ParentMatrix->pEnters];
            [self OnlyRemoveDataAtIndex:iTmpIndex WithData:InfoStr->UnParentMatrix.ParentMatrix->pExits];
            
            MATRIXcell *pCurrentMatrix=InfoStr->UnParentMatrix.ParentMatrix;
//удаляем из меток=================================================================================
            int *StartActivSpace=(*pCurrentMatrix->ppActivitySpace+SIZE_INFO_STRUCT);
            
            if(StartActivSpace[0]==iTmpIndex)
                StartActivSpace[0]=-1;
//==================================================================================================

            [self EditEnterPoint:iPlace matr:pCurrentMatrix];
            
            InfoArrayValue *InfoQueue=(InfoArrayValue *)(*InfoStr->UnParentMatrix.ParentMatrix->pQueue);
            int *StartDataQueue=((*InfoStr->UnParentMatrix.ParentMatrix->pQueue)+SIZE_INFO_STRUCT);

            //удалаем связи в текущей матрице
            for (int i=0; i<InfoQueue->mCount; i++) {
                HeartMatr *pHeart=(HeartMatr *)StartDataQueue[i];
                
                if(pHeart!=nil){
                    
                    InfoArrayValue *InfoEntersH=(InfoArrayValue *)(*pHeart->pEnPairPar);
                    int *StartDataParEnter=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT);

                    for (int j=0; j<InfoEntersH->mCount; j++) {
                        int TmpIndexInLink=StartDataParEnter[j];
                        
                        if(TmpIndexInLink==iTmpIndex){
                            
                            MATRIXcell *pMatrZero=InfoStr->UnParentMatrix.ParentMatrix;
                            [self RemoveAllConnections:nil RootMatr:pMatrZero
                                        SearchCurIndex:iTmpIndex];
                            
//                            int iIndexChild=(*pHeart->pEnPairChi+SIZE_INFO_STRUCT)[j];
//                            StartDataParEnter[j]=iIndexChild;

                            continue;
                        }
                    }

                    InfoArrayValue *InfoExitrH=(InfoArrayValue *)(*pHeart->pExPairPar);
                    int *StartDataParExit=((*pHeart->pExPairPar)+SIZE_INFO_STRUCT);
                    for (int j=0; j<InfoExitrH->mCount; j++) {
                        int TmpIndexInLink=StartDataParExit[j];
                        
                        if(TmpIndexInLink==iTmpIndex){
                            
                            MATRIXcell *pMatrZero=InfoStr->UnParentMatrix.ParentMatrix;
                            [self RemoveAllConnections:nil RootMatr:pMatrZero
                                        SearchCurIndex:iTmpIndex];

//                            int iIndexChild=(*pHeart->pExPairChi+SIZE_INFO_STRUCT)[j];
//                            StartDataParExit[j]=iIndexChild;

                            continue;
                        }
                    }
                }
            }
            
            
            int iNumAssoc=[m_pParent->ArrayPoints GetCountAtIndex:iTmpIndex];
            
            if(iNumAssoc==1)
            {
                //удаляем связи из всеx родителей для данной матрицы
                InfoArrayValue *InfoStrLinks=(InfoArrayValue *)
                                (*InfoStr->UnParentMatrix.ParentMatrix->pLinks);
                int *StartDataLink=((*InfoStr->UnParentMatrix.ParentMatrix->pLinks)+SIZE_INFO_STRUCT);
                
                for (int i=0; i<InfoStrLinks->mCount; i++){
                    int iMatrIndex = StartDataLink[i];
                    MATRIXcell *TmpMatrInLinks=[m_pParent->ArrayPoints GetMatrixAtIndex:iMatrIndex];
                    
                    if(TmpMatrInLinks!=nil){
                        
                        InfoArrayValue *InfoQueue=(InfoArrayValue *)(*TmpMatrInLinks->pQueue);
                        int *StartDataQueue=((*TmpMatrInLinks->pQueue)+SIZE_INFO_STRUCT);
                        
                        for (int i=0; i<InfoQueue->mCount; i++) {
                            HeartMatr *pHeart=(HeartMatr *)StartDataQueue[i];
                            
                            if(pHeart!=nil){
                                
                                InfoArrayValue *InfoEntersH=(InfoArrayValue *)(*pHeart->pEnPairChi);
                                int *StartDataParEnter=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT);
                                
                                for (int j=0; j<InfoEntersH->mCount; j++) {
                                    int TmpIndexInLink=StartDataParEnter[j];
                                    
                                    if(TmpIndexInLink==iTmpIndex){
                                        [self OnlyRemoveDataAtPlace:j WithData:pHeart->pEnPairPar];
                                        [self OnlyRemoveDataAtPlace:j WithData:pHeart->pEnPairChi];
                                        break;
                                    }
                                }
                                
                                InfoArrayValue *InfoExitrH=(InfoArrayValue *)(*pHeart->pExPairChi);
                                int *StartDataParExit=((*pHeart->pExPairPar)+SIZE_INFO_STRUCT);
                                for (int j=0; j<InfoExitrH->mCount; j++) {
                                    int TmpIndexInLink=StartDataParExit[j];
                                    
                                    if(TmpIndexInLink==iTmpIndex){
                                        [self OnlyRemoveDataAtPlace:j WithData:pHeart->pExPairPar];
                                        [self OnlyRemoveDataAtPlace:j WithData:pHeart->pExPairChi];
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            for (int i=0; i<InfoQueue->mCount; i++) {//переименовываем переходы
                HeartMatr *pHeart=(HeartMatr *)StartDataQueue[i];
                
                if(pHeart!=0)
                {
                    if(pHeart->pNextPlace==(InfoQueue->mCount-1))
                        pHeart->pNextPlace=iPlace;
                }
            }

            memcpy(StartDataQueue+iPlace, StartDataQueue+(InfoQueue->mCount-1), sizeof(int));
            InfoQueue->mCount--;
            [self SetCopasity:InfoQueue->mCount WithData:InfoStr->UnParentMatrix.ParentMatrix->pQueue];
        }

        memcpy(StartData+iPlace, StartData+(InfoStr->mCount-1), sizeof(int));
        InfoStr->mCount--;
        [self SetCopasity:InfoStr->mCount WithData:pData];

//        memcpy(StartData+iPlace, StartData+(InfoStr->mCount-1), sizeof(int));
//        InfoStr->mCount--;
        
        [m_pParent->ArrayPoints DecDataAtIndex:iTmpIndex];
    }    
}
//------------------------------------------------------------------------------------------
-(void)selfSave:(NSMutableData *)m_pData WithData:(int **)pData{
    
    InfoArrayValue *InfoStr=(InfoArrayValue *)*pData;

    int Size=InfoStr->mCopasity*sizeof(int)+sizeof(InfoArrayValue);
    [m_pData appendBytes:*pData length:Size];
}
//------------------------------------------------------------------------------------------
-(void)selfLoad:(NSMutableData *)m_pData rpos:(int *)iCurReadingPos WithData:(int **)pData{
    
    InfoArrayValue InfoStr;

    int iReadSize=sizeof(InfoArrayValue);
    [m_pData getBytes:&InfoStr range:NSMakeRange( *iCurReadingPos, iReadSize)];
    *iCurReadingPos += iReadSize;    
    
    [self SetCopasity:InfoStr.mCopasity WithData:pData];
    
    iReadSize=InfoStr.mCopasity*sizeof(int);

    int *StartData=(*pData)+SIZE_INFO_STRUCT;

    [m_pData getBytes:StartData range:NSMakeRange( *iCurReadingPos, iReadSize)];
    *iCurReadingPos += iReadSize;
    InfoArrayValue *pInfoStr=(InfoArrayValue *)*pData;
    memcpy(pInfoStr, &InfoStr, sizeof(InfoArrayValue));
//    pInfoStr->mReserv=0;
}
//------------------------------------------------------------------------------------------
- (int)GetDataAtIndex:(int)iIndex WithData:(int **)pData{
    
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);

    if(iIndex>InfoStr->mCount)return 0;
    
    int *StartData=(*pData)+SIZE_INFO_STRUCT;
    int *iRet=StartData+iIndex;
    return *iRet;
}
//------------------------------------------------------------------------------------------
- (void)dealloc
{
    [super dealloc];
}
//------------------------------------------------------------------------------------------
@end
