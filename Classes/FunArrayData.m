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

        iCountInc=1000;
        iCount=0;
        
        m_iSize=sizeof(float);

        [self Increase:iCopasity];
    }
    
    return self;
}
//------------------------------------------------------------------------------------------
- (void)Increase:(int)CountInc{
    
    int FirstIndex=iCount;
    iCount+=CountInc;
    pData=realloc(pData,iCount*m_iSize);
    pDataInt=realloc(pDataInt,iCount*sizeof(int));
    
    for (int i=0; i<CountInc; i++) {
        NSNumber *pNum=[NSNumber numberWithInt:FirstIndex+i];
        [pFreeArray addObject:pNum];
    }
}
//------------------------------------------------------------------------------------------
- (int)GetFree{
    
    if([pFreeArray count]==0){
        [self Increase:iCountInc];
    }
    
    NSNumber *pNum=[pFreeArray objectAtIndex:0];
    int IndexFree=[pNum intValue];
    return IndexFree;    
}
//------------------------------------------------------------------------------------------
- (int)SetData:(float)DataValue{

    int iIndex=[self GetFree];
    
    float *TmpLink=malloc(sizeof(float));
    
    memcpy(TmpLink,&DataValue, m_iSize);
    memcpy(pData+iIndex,&TmpLink, m_iSize);
    
    return iIndex;
}
//------------------------------------------------------------------------------------------
- (void)IncDataAtIndex:(int)iIndex{
    
    (*((int *)pDataInt+iIndex))++;
}
//------------------------------------------------------------------------------------------
- (void)DecDataAtIndex:(int)iIndex{
    
    int *TmpIndex=((int *)pDataInt+iIndex);
    
    (*TmpIndex)--;
    if(*TmpIndex==0)
    {
        NSNumber *pNum=[NSNumber numberWithInt:*TmpIndex];
        [pFreeArray addObject:pNum];
    }
}
//------------------------------------------------------------------------------------------
- (float *)GetDataAtIndex:(int)iIndex{
    if(iIndex>iCount)return 0;
    
    float **fRet=((float **)(pData+iIndex));
    
    return *fRet;
}
//------------------------------------------------------------------------------------------
- (void)dealloc
{
    free(pData);
    free(pDataInt);

    [super dealloc];
}
//------------------------------------------------------------------------------------------
@end
