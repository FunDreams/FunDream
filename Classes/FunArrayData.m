//
//  FunArrayData.m
//  FunDreams
//
//  Created by Konstantin Maximov on 24.04.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import "FunArrayData.h"
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
        
        [self Increase:iCopasity];
    }
    
    return self;
}
//------------------------------------------------------------------------------------------
- (void)Increase:(int)CountInc{
    
    int FirstIndex=iCount;
    iCount+=CountInc;
    pData=realloc(pData,iCount*sizeof(float));
    pDataInt=realloc(pDataInt,iCount*sizeof(int));
    
    for (int i=0; i<CountInc; i++) {
        
        int Index=FirstIndex+i;

        NSNumber *pNum=[NSNumber numberWithInt:Index];
        [pFreeArray addObject:pNum];
    }
}
//------------------------------------------------------------------------------------------
- (void)Reserv:(int)iCountTmp{
    iCount=iCountTmp;
    
    pData=realloc(pData,iCountTmp*sizeof(float));
    pDataInt=realloc(pDataInt,iCountTmp*sizeof(int));
}
//------------------------------------------------------------------------------------------
- (int)GetFree{
    
    if([pFreeArray count]==0){
        [self Increase:iCountInc];
    }
    
    NSNumber *pNum=[pFreeArray objectAtIndex:0];
    [pFreeArray removeObjectAtIndex:0];
    int IndexFree=[pNum intValue];
    return IndexFree;
}
//------------------------------------------------------------------------------------------
- (int)SetData:(float)DataValue{

    int iIndex=[self GetFree];
    
    float *TmpLink=pData+iIndex;
    
    memcpy(TmpLink,&DataValue, sizeof(float));
    (*((int *)pDataInt+iIndex))++;
    iCountInArray++;
    
    return iIndex;
}
//------------------------------------------------------------------------------------------
- (void)IncDataAtIndex:(int)iIndex{
    
    int *TmpInc=(pDataInt+iIndex);

    if(*TmpInc>0)(*TmpInc)++;
}
//------------------------------------------------------------------------------------------
- (void)DecDataAtIndex:(int)iIndex{
    
    int *TmpIndex=((int *)pDataInt+iIndex);
    
    (*TmpIndex)--;
    if(*TmpIndex==0)
    {
        iCountInArray--;
        NSNumber *pNum=[NSNumber numberWithInt:*TmpIndex];
        [pFreeArray addObject:pNum];
    }
}
//------------------------------------------------------------------------------------------
- (float *)GetDataAtIndex:(int)iIndex{
    if(iIndex>iCount)return 0;
    
    float *fRet=((float *)(pData+iIndex));
    
    return fRet;
}
//------------------------------------------------------------------------------------------
-(void)selfSave:(NSMutableData *)m_pData{
    
    [m_pData appendBytes:&iCount length:sizeof(int)];
    [m_pData appendBytes:&iCountInArray length:sizeof(int)];
    [m_pData appendBytes:&iCountInc length:sizeof(int)];
    
    [m_pData appendBytes:pData length:iCount*sizeof(float)];
    [m_pData appendBytes:pDataInt length:iCount*sizeof(int)];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:pFreeArray];
    int iLen=[data length];
    
    [m_pData appendBytes:&iLen length:sizeof(int)];
    [m_pData appendData:data];
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

    int iLen;
    [m_pData getBytes:&iLen range:NSMakeRange( *iCurReadingPos, sizeof(int))];
    *iCurReadingPos += sizeof(int);

    NSData *iv = [m_pData subdataWithRange:NSMakeRange(*iCurReadingPos, iLen)];
    
    if(pFreeArray!=nil)[pFreeArray release];
    pFreeArray = [[NSKeyedUnarchiver unarchiveObjectWithData:iv] retain];
}
//------------------------------------------------------------------------------------------
- (void)dealloc
{
    free(pData);
    free(pDataInt);
    [pFreeArray release];

    [super dealloc];
}
//------------------------------------------------------------------------------------------
@end
