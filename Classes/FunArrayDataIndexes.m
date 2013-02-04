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

    for(int i=0;i<InfoStr->mCount;i++){
        
        int index=(*pData+SIZE_INFO_STRUCT)[i];
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

    memcpy(StartData+iIndex+1, StartData+iIndex, sizeof(int)*(InfoStr->mCount-(iIndex+1)));
    memcpy(StartData+iIndex, &iDataValue, sizeof(int));
    InfoStr->mCount++;
    [m_pParent->ArrayPoints IncDataAtIndex:iIndex];
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

    for (int i=0; i<InfoStrDest->mCount; i++) {
        
        int iIndex=StartDataDest[i];
        [m_pParent->ArrayPoints IncDataAtIndex:iIndex];
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
- (void)AddData:(int)IndexValue WithData:(int **)pData{
    
    [self Extend:pData];
    
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);

    int *StartData=((*pData)+SIZE_INFO_STRUCT);

    StartData[InfoStr->mCount]=IndexValue;
    InfoStr->mCount++;
    [m_pParent->ArrayPoints IncDataAtIndex:IndexValue];
}
//------------------------------------------------------------------------------------------
- (void)RemoveDataAtIndex:(int)iIndex WithData:(int **)pData{
    
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);
    if(iIndex+1>InfoStr->mCount)return;
    
    int *StartData=((*pData)+SIZE_INFO_STRUCT);

    if(InfoStr->mFlags && F_ORDER)
    {
        if(iIndex+1<InfoStr->mCount)
            memcpy(StartData+iIndex, StartData+iIndex+1, sizeof(int)*(InfoStr->mCount-(iIndex+1)));
    }
    else
    {
        if(iIndex+1<InfoStr->mCount)
            memcpy(StartData+iIndex, StartData+(InfoStr->mCount-1), sizeof(int));
    }
    
    InfoStr->mCount--;
    [m_pParent->ArrayPoints DecDataAtIndex:iIndex];
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
