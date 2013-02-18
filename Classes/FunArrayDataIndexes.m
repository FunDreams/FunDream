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
- (void)ReleaseMemory:(int **)pData{

    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);
    int iCount=InfoStr->mCount;

    for(int i=0;i<iCount;i++){
        
        int index=(*pData+SIZE_INFO_STRUCT)[0];
        int **pCurnData=InfoStr->ParentMatrix->pValueCopy;
        
        int iRet=[m_pParent->m_OperationIndex FindIndex:index WithData:pCurnData];
        if(iRet>-1)[m_pParent->m_OperationIndex RemoveDataAtPlace:iRet WithData:pCurnData];

        [m_pParent->ArrayPoints DecDataAtIndex:index];
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

    memcpy(StartData+iIndex+1, StartData+iIndex, sizeof(int)*(InfoStr->mCount-(iIndex+1)));
    memcpy(StartData+iIndex, &iDataValue, sizeof(int));
    InfoStr->mCount++;
    [m_pParent->ArrayPoints IncDataAtIndex:iIndex];
}
//------------------------------------------------------------------------------------------
//- (void)CopyDataFrom:(int **)pSourceData To:(int **)pDestData{
//    
//    InfoArrayValue *InfoStrSource=(InfoArrayValue *)(*pSourceData);
//    InfoArrayValue *InfoStrDest=(InfoArrayValue *)(*pDestData);
//
//    *InfoStrDest=*InfoStrSource;
//
//    [self SetCopasity:InfoStrSource->mCopasity WithData:pDestData];
//    
//    int *StartDataSource=((*pSourceData)+SIZE_INFO_STRUCT);
//    int *StartDataDest=((*pDestData)+SIZE_INFO_STRUCT);
//    
//    memcpy(StartDataDest, StartDataSource, sizeof(int)*(InfoStrSource->mCount));
//
//    for (int i=0; i<InfoStrDest->mCount; i++) {
//        
//        int iIndex=StartDataDest[i];
//        [m_pParent->ArrayPoints IncDataAtIndex:iIndex];
//    }
//}
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
- (void)AddData:(int)IndexValue WithData:(int **)pData{
        
    [self Extend:pData];
    
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);

    int *StartData=((*pData)+SIZE_INFO_STRUCT);

    StartData[InfoStr->mCount]=IndexValue;
    
    int iType=[m_pParent->ArrayPoints GetTypeAtIndex:IndexValue];
    if(iType==DATA_MATRIX){
        [self SetParentMatrix:IndexValue WithData:pData];
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
            if(iPlace+1<InfoStr->mCount)
                memcpy(StartData+iPlace, StartData+iPlace+1, sizeof(int)*(InfoStr->mCount-(iPlace+1)));
        }
        else
        {
            if(iPlace+1<InfoStr->mCount)
                memcpy(StartData+iPlace, StartData+(InfoStr->mCount-1), sizeof(int));
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
//                    iRet=[self FindIndex:iTmpIndex WithData:pMatr->pValueLink];
//                    if(iRet>-1)[self RemoveDataAtPlace:iRet WithData:pMatr->pValueLink];
                    iRet=[self FindIndex:iTmpIndex WithData:pMatr->pValueCopy];
                    if(iRet>-1)[self RemoveDataAtPlace:iRet WithData:pMatr->pValueCopy];
                }
            }
        }
        
        [m_pParent->ArrayPoints DecDataAtIndex:iTmpIndex];
    }
//================================================================================================
    else
    {
        [m_pParent->ArrayPoints DecDataAtIndex:iTmpIndex];

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
