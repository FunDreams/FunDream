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
-(id)initWithCopasity:(int)iCopasity{
    
    self = [super init];
    
    if(self){
        
        iCoundAdd=5;
        iCountInArray=0;
        m_iCopasity=iCopasity;
        
        pData = (int *)malloc(sizeof(int)*m_iCopasity);
    }
    
    return self;
}
//------------------------------------------------------------------------------------------
- (void)AddData:(int)iDataValue{
    if(m_iCopasity==iCountInArray){
        m_iCopasity+=iCoundAdd;
        pData = realloc(pData, (sizeof(int)*m_iCopasity));
    }
    
    iCountInArray++;
    memcpy(pData+iCountInArray, &iDataValue, sizeof(int));
}
//------------------------------------------------------------------------------------------
- (void)RemoveDataAtIndex:(int)iIndex{
    memcpy(pData+iIndex, pData+iCountInArray, sizeof(int));
    iCountInArray--;
}
//------------------------------------------------------------------------------------------
- (int)GetDataAtIndex:(int)iIndex{
    if(iIndex>iCountInArray)return 0;
    
    int *iRet=pData+iIndex;
    
    return *iRet;
}
//------------------------------------------------------------------------------------------
- (void)dealloc
{
    free(pData);
    [super dealloc];
}
//------------------------------------------------------------------------------------------
@end
