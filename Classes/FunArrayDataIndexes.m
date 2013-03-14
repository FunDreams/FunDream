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
    
    InfoStr->mFlags=0;
    InfoStr->mCount=0;
    InfoStr->mCopasity=0;
    InfoStr->mCountAdd=1;
    InfoStr->ParentMatrix=0;
    InfoStr->ParentMatrix=0;
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
    free(*pData);
    free(pData);
}
//------------------------------------------------------------------------------------------------------
- (void)ReleaseMemory:(int **)pData{

    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);
    int iCount=InfoStr->mCount;

    for(int i=0;i<iCount;i++){
        
        int index=(*pData+SIZE_INFO_STRUCT)[0];
        int **pCurnData=InfoStr->ParentMatrix->pValueCopy;
        
        int iRet=[m_pParent->m_OperationIndex FindIndex:index WithData:pCurnData];
        if(iRet>-1)[m_pParent->m_OperationIndex RemoveDataAtPlace:iRet WithData:pCurnData];
    }
    
    free(*pData);
    free(pData);
}
//------------------------------------------------------------------------------------------
-(void)SetCopasity:(int)icopasity WithData:(int **)pData{
    
    if(icopasity<0)return;
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);
    
    InfoStr->mCopasity=icopasity;
    
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

    *InfoStrDest=*InfoStrSource;

    [self SetCopasity:InfoStrSource->mCopasity WithData:pDestData];
    
    int *StartDataSource=((*pSourceData)+SIZE_INFO_STRUCT);
    int *StartDataDest=((*pDestData)+SIZE_INFO_STRUCT);
    
    memcpy(StartDataDest, StartDataSource, sizeof(int)*(InfoStrSource->mCount));
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
    
    MATRIXcell *TmpMatr=[m_pParent->ArrayPoints GetMatrixAtIndex:IndexValue];
    [self Extend:TmpMatr->pLinks];
    
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);
    InfoArrayValue *InfoStrLinks=(InfoArrayValue *)(*TmpMatr->pLinks);
    
    int *StartDataLinks=((*TmpMatr->pLinks)+SIZE_INFO_STRUCT);
    StartDataLinks[InfoStrLinks->mCount]=InfoStr->ParentMatrix->iIndexSelf;
    InfoStrLinks->mCount++;
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
- (void)Insert:(int)iDataValue index:(int)iIndex WithData:(int **)pData{
    
    if(iIndex<0)return;
    [self Extend:pData];
    
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);
    
    if(iIndex+1>InfoStr->mCount){
        
        [self AddData:iDataValue WithData:pData];
        return;
    }
    
    int *StartData=((*pData)+SIZE_INFO_STRUCT);
    
    int iType=[m_pParent->ArrayPoints GetTypeAtIndex:iDataValue];
    if(iType==DATA_MATRIX){
        [self SetParentMatrix:iDataValue WithData:pData];        
    }
    
    if(InfoStr->ParentMatrix!=0){
        //добавляем пустое место в queue
        MATRIXcell *pMatrPar = InfoStr->ParentMatrix;
        
        [self Extend:pMatrPar->pQueue];
        InfoArrayValue *InfoQueue=(InfoArrayValue *)(*pMatrPar->pQueue);
        int *StartDataQueue=((*pMatrPar->pQueue)+SIZE_INFO_STRUCT);
        
        memcpy(StartDataQueue+iIndex+1, StartDataQueue+iIndex, sizeof(int)*(InfoQueue->mCount-(iIndex)));
        
        //инициализация heart
        HeartMatr *pNewHeart=(HeartMatr *)malloc(sizeof(HeartMatr));
        [m_pParent->ArrayPoints InitMemoryHeart:pNewHeart parent:pMatrPar];
        
        //копирование в массив
        HeartMatr **TmpHeart=(HeartMatr **)(StartDataQueue+iIndex);
        *TmpHeart=pNewHeart;
        
        InfoQueue->mCount++;
    }
    
    memcpy(StartData+iIndex+1, StartData+iIndex, sizeof(int)*(InfoStr->mCount-(iIndex+1)));
    memcpy(StartData+iIndex, &iDataValue, sizeof(int));
    InfoStr->mCount++;
    [m_pParent->ArrayPoints IncDataAtIndex:iIndex];
}
//------------------------------------------------------------------------------------------
- (void)AddData:(int)IndexValue WithData:(int **)pData{
        
    [self Extend:pData];
    
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);

    int *StartData=((*pData)+SIZE_INFO_STRUCT);

    StartData[InfoStr->mCount]=IndexValue;
    
    int iType=[m_pParent->ArrayPoints GetTypeAtIndex:IndexValue];
    if(iType==DATA_MATRIX){
        [self SetParentMatrix:IndexValue WithData:pData];        
    }
    
    if(InfoStr->ParentMatrix!=0){
        //добавляем пустое место в queue
        MATRIXcell *pMatrPar = InfoStr->ParentMatrix;
        
        [self Extend:pMatrPar->pQueue];
        InfoArrayValue *InfoQueue=(InfoArrayValue *)(*pMatrPar->pQueue);
        int *StartDataQueue=((*pMatrPar->pQueue)+SIZE_INFO_STRUCT);
        
        //инициализация heart
        HeartMatr *pNewHeart=0;
        
        if(iType==DATA_MATRIX){
            pNewHeart=(HeartMatr *)malloc(sizeof(HeartMatr));
            [m_pParent->ArrayPoints InitMemoryHeart:pNewHeart parent:pMatrPar];
            
            MATRIXcell *pMatrParCurr = [m_pParent->ArrayPoints GetMatrixAtIndex:IndexValue];
            
            //инициализируем сердце
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
- (bool)CheckHierarhy:(NSMutableDictionary *)DataLoops
             RootMatr:(MATRIXcell *)pRootMatr SearchCurIndex:(int)iIndex{
    
    bool bRez=NO;
    InfoArrayValue *InfoStr;
    int *StartData;
    
//    for (int k=0; k<2; k++) {
    
//        if(k==0)
//        {
            InfoStr=(InfoArrayValue *)(*pRootMatr->pValueCopy);
            StartData=((*pRootMatr->pValueCopy)+SIZE_INFO_STRUCT);
//        }
//        else
//        {
//            InfoStr=(InfoArrayValue *)(*pRootMatr->pValueLink);
//            StartData=((*pRootMatr->pValueLink)+SIZE_INFO_STRUCT);
//        }

        for (int i=0; i<InfoStr->mCount; i++) {
            
            int iTmpIndex=StartData[i];
            
            if(iIndex==iTmpIndex){
                bRez=YES;
                break;
            }

            int iType=[m_pParent->ArrayPoints GetTypeAtIndex:iTmpIndex];
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
//    }
    
    return bRez;
}
//------------------------------------------------------------------------------------------
- (void)OnlyRemoveDataAtPlace:(int)iPlace WithData:(int **)pData{
    
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);
    int *StartData=((*pData)+SIZE_INFO_STRUCT);
    
    if(iPlace+1<InfoStr->mCount)
        memcpy(StartData+iPlace, StartData+(InfoStr->mCount-1), sizeof(int));
    
    InfoStr->mCount--;
    [self SetCopasity:InfoStr->mCount WithData:pData];
}
//------------------------------------------------------------------------------------------
- (void)OnlyRemoveDataAtIndex:(int)iIndex WithData:(int **)pData{
    
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);
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
//------------------------------------------------------------------------------------------
- (void)RemoveDataAtPlace:(int)iPlace WithData:(int **)pData{
    
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);
    if(iPlace+1>InfoStr->mCount)return;
    
    int *StartData=((*pData)+SIZE_INFO_STRUCT);
    
    int iTmpIndex=StartData[iPlace];
//проверяем вложеные сслылки на удаляемую матрицу================================================
    int iType=[m_pParent->ArrayPoints GetTypeAtIndex:iTmpIndex];
    if(iType==DATA_MATRIX){

        MATRIXcell *pCurrentMatrix=InfoStr->ParentMatrix;
        int iIndexCurrentMatr=pCurrentMatrix->iIndexSelf;
        
        InfoArrayValue *InfoQueue=(InfoArrayValue *)(*InfoStr->ParentMatrix->pQueue);
        int *StartDataQueue=((*InfoStr->ParentMatrix->pQueue)+SIZE_INFO_STRUCT);
        
        MATRIXcell *TmpMatrForDel=[m_pParent->ArrayPoints GetMatrixAtIndex:iTmpIndex];
        InfoArrayValue *InfoStrLinks=(InfoArrayValue *)(*TmpMatrForDel->pLinks);
        int *StartDataLink=((*TmpMatrForDel->pLinks)+SIZE_INFO_STRUCT);
        
        for (int i=0; i<InfoStr->mCount; i++) {
            int itmpIndex = StartDataLink[i];
            
            if(itmpIndex==iIndexCurrentMatr)
            {
                memcpy(StartDataLink+i, StartDataLink+(InfoStrLinks->mCount-1), sizeof(int));
                InfoStrLinks->mCount--;
                break;
            }
        }
//удаляем пару
        
        if(InfoStr->mFlags && F_ORDER)
        {
//            if(iPlace+1<InfoStr->mCount){
//                memcpy(StartData+iPlace, StartData+iPlace+1, sizeof(int)*(InfoStr->mCount-(iPlace+1)));
//                
//                //удаляем место в queue
//                MATRIXcell *Parrent=InfoStr->ParentMatrix;
//                InfoArrayValue *InfoQueue=(InfoArrayValue *)(*Parrent->pQueue);
//                int *StartDataQueue=((*Parrent->pQueue)+SIZE_INFO_STRUCT);
//                HeartMatr *pHeart=*((HeartMatr **)(StartDataQueue+iPlace));
//                
//                if(pHeart!=0){
//                    int m=0;
//                }
//                memcpy(StartDataQueue+iPlace, StartDataQueue+iPlace+1,
//                       sizeof(int)*(InfoQueue->mCount-(iPlace+1)));
//
//                InfoQueue->mCount--;
//                [self SetCopasity:InfoQueue->mCount WithData:Parrent->pQueue];
//
//            }
        }
        else
        {
            //редактируем точку входа
            if(pCurrentMatrix->sStartPlace==iPlace){
                pCurrentMatrix->sStartPlace=-1;
            }

            if(pCurrentMatrix->sStartPlace==(InfoStr->mCount-1)){
                pCurrentMatrix->sStartPlace=iPlace;
            }
            
            //удаление индека с матрицы парента
            memcpy(StartData+iPlace, StartData+(InfoStr->mCount-1), sizeof(int));
            
            //удаляем место в queue
            MATRIXcell *Parrent=InfoStr->ParentMatrix;
            InfoArrayValue *InfoQueue=(InfoArrayValue *)(*Parrent->pQueue);
            int *StartDataQueue=((*Parrent->pQueue)+SIZE_INFO_STRUCT);
            HeartMatr *pHeart=*((HeartMatr **)(StartDataQueue+iPlace));

            if(pHeart!=0){//удаляем ссылки на текущий

                for (int i=0; i<InfoQueue->mCount; i++) {
                    HeartMatr *pHeart=(HeartMatr *)StartDataQueue[i];
                    
                    if(pHeart!=0){
                        
                        InfoArrayValue *InfoNext=(InfoArrayValue *)(*pHeart->pNextPlaces);
                        int *StartDataNext=((*pHeart->pNextPlaces)+SIZE_INFO_STRUCT);
                        
                        for (int j=0; j<InfoNext->mCount; j++)
                        {
                            int iTmpPlace=StartDataNext[j];
                            if(iTmpPlace==iPlace){
                                [self OnlyRemoveDataAtPlace:i WithData:pHeart->pNextPlaces];
                                j--;
                            }
                        }
                        [self SetCopasity:InfoNext->mCount WithData:pHeart->pNextPlaces];
                    }
                }
                
                for (int i=0; i<InfoQueue->mCount; i++) {//переименовываем
                    HeartMatr *pHeart=(HeartMatr *)StartDataQueue[i];

                    if(pHeart!=0){
                        
                        InfoArrayValue *InfoNext=(InfoArrayValue *)(*pHeart->pNextPlaces);
                        int *StartDataNext=((*pHeart->pNextPlaces)+SIZE_INFO_STRUCT);
                        
                        for (int j=0; j<InfoNext->mCount; j++)
                        {
                            int iTmpPlace=StartDataNext[j];
                            if(iTmpPlace==(InfoQueue->mCount-1)){
                                StartDataNext[j]=iPlace;
                            }
                        }
                    }
                }

                
                [m_pParent->ArrayPoints ReleaseMemoryHeart:pHeart];
                free(pHeart);
            }            
        }
        InfoStr->mCount--;
///////////////////////////////////////////////////
        if(InfoStrLinks->mCount>0){
            
            MATRIXcell *pMatrZero=[m_pParent->ArrayPoints GetMatrixAtIndex:0];
            
            NSMutableDictionary *DataLoops = [[NSMutableDictionary alloc] init];
            bool Rez=[self CheckHierarhy:DataLoops RootMatr:pMatrZero SearchCurIndex:iTmpIndex];
            [DataLoops release];
            
            if(Rez==NO){//удалаем все ссылки на данную струну из матрицы
                
                for (int i=0; i<InfoStrLinks->mCount; i++) {
                    int iInsideIndex = StartDataLink[i];//индекс матрицы парента
                    
                    MATRIXcell *pMatr=[m_pParent->ArrayPoints GetMatrixAtIndex:iInsideIndex];

                    int iRet=-1;
                    iRet=[self FindIndex:iTmpIndex WithData:pMatr->pValueCopy];
                    if(iRet>-1)[self RemoveDataAtPlace:iRet WithData:pMatr->pValueCopy];
                }
            }
        }
        
        memcpy(StartDataQueue+iPlace, StartDataQueue+(InfoQueue->mCount-1), sizeof(int));
        InfoQueue->mCount--;
        [self SetCopasity:InfoQueue->mCount WithData:InfoStr->ParentMatrix->pQueue];

        [m_pParent->ArrayPoints DecDataAtIndex:iTmpIndex];
    }
//================================================================================================
    else
    {//удаление из связей (сначала в текущей матрице)
        
        if(iType==DATA_FLOAT || iType==DATA_INT || iType==DATA_SPRITE || iType==DATA_TEXTURE){
            [self OnlyRemoveDataAtIndex:iTmpIndex WithData:InfoStr->ParentMatrix->pEnters];
            [self OnlyRemoveDataAtIndex:iTmpIndex WithData:InfoStr->ParentMatrix->pExits];
            
            MATRIXcell *pCurrentMatrix=InfoStr->ParentMatrix;

            //редактируем точку входа
            if(pCurrentMatrix->sStartPlace==iPlace){
                pCurrentMatrix->sStartPlace=-1;
            }
            
            if(pCurrentMatrix->sStartPlace==(InfoStr->mCount-1)){
                pCurrentMatrix->sStartPlace=iPlace;
            }

            
            InfoArrayValue *InfoQueue=(InfoArrayValue *)(*InfoStr->ParentMatrix->pQueue);
            int *StartDataQueue=((*InfoStr->ParentMatrix->pQueue)+SIZE_INFO_STRUCT);

            for (int i=0; i<InfoQueue->mCount; i++) {
                HeartMatr *pHeart=(HeartMatr *)StartDataQueue[i];
                
                if(pHeart!=nil){
                    
                    InfoArrayValue *InfoEntersH=(InfoArrayValue *)(*pHeart->pEnPairPar);
                    int *StartDataParEnter=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT);
                    
                    for (int j=0; j<InfoEntersH->mCount; j++) {
                        int TmpIndexInLink=StartDataParEnter[j];
                        
                        if(TmpIndexInLink==iTmpIndex){
                            int iIndexChild=(*pHeart->pEnPairChi+SIZE_INFO_STRUCT)[j];
                            (*pHeart->pEnPairPar+SIZE_INFO_STRUCT)[j]=iIndexChild;

//                            [self OnlyRemoveDataAtPlace:j WithData:pHeart->pEnPairPar];
//                            [self OnlyRemoveDataAtPlace:j WithData:pHeart->pEnPairChi];
                            break;
                        }
                    }

                    InfoArrayValue *InfoExitrH=(InfoArrayValue *)(*pHeart->pExPairPar);
                    int *StartDataParExit=((*pHeart->pExPairPar)+SIZE_INFO_STRUCT);
                    for (int j=0; j<InfoExitrH->mCount; j++) {
                        int TmpIndexInLink=StartDataParExit[j];
                        
                        if(TmpIndexInLink==iTmpIndex){
                            int iIndexChild=(*pHeart->pExPairChi+SIZE_INFO_STRUCT)[j];
                            (*pHeart->pExPairPar+SIZE_INFO_STRUCT)[j]=iIndexChild;

//                            [self OnlyRemoveDataAtPlace:j WithData:pHeart->pExPairPar];
//                            [self OnlyRemoveDataAtPlace:j WithData:pHeart->pExPairChi];
                            break;
                        }
                    }
                }
            }
            
            //удаляем связи из все парентов для данной матрицы
            InfoArrayValue *InfoStrLinks=(InfoArrayValue *)(*InfoStr->ParentMatrix->pLinks);
            int *StartDataLink=((*InfoStr->ParentMatrix->pLinks)+SIZE_INFO_STRUCT);
            
            for (int i=0; i<InfoStrLinks->mCount; i++) {
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
            
            for (int i=0; i<InfoQueue->mCount; i++) {//переименовываем
                HeartMatr *pHeart=(HeartMatr *)StartDataQueue[i];
                
                if(pHeart!=0){
                    
                    InfoArrayValue *InfoNext=(InfoArrayValue *)(*pHeart->pNextPlaces);
                    int *StartDataNext=((*pHeart->pNextPlaces)+SIZE_INFO_STRUCT);
                    
                    for (int j=0; j<InfoNext->mCount; j++)
                    {
                        int iTmpPlace=StartDataNext[j];
                        if(iTmpPlace==(InfoQueue->mCount-1)){
                            StartDataNext[j]=iPlace;
                        }
                    }
                }
            }
            
            memcpy(StartDataQueue+iPlace, StartDataQueue+(InfoQueue->mCount-1), sizeof(int));
            InfoQueue->mCount--;
            [self SetCopasity:InfoQueue->mCount WithData:InfoStr->ParentMatrix->pQueue];
        }

        if(InfoStr->mFlags && F_ORDER)
        {
            if(iPlace+1<InfoStr->mCount)
                memcpy(StartData+iPlace, StartData+iPlace+1, sizeof(int)*(InfoStr->mCount-(iPlace+1)));
        }
        else
        {
            if(iPlace+1<InfoStr->mCount)
                memcpy(StartData+iPlace, StartData+(InfoStr->mCount-1), sizeof(int));
        }
        
        InfoStr->mCount--;
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
