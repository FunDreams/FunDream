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
    
    bOrder=NO;
    
    if(self){
        
        iCoundAdd=5;
        iCountInArray=0;
        m_iCopasity=iCopasity;
        
        pData = (int *)malloc(sizeof(int)*m_iCopasity);
    }
    
    return self;
}
//------------------------------------------------------------------------------------------
- (void)Extend{
    if(m_iCopasity==iCountInArray){
        m_iCopasity+=iCoundAdd;
        pData = realloc(pData, (sizeof(int)*m_iCopasity));
    }
}
//------------------------------------------------------------------------------------------
- (void)Reserv:(int)iCount{
    pData = realloc(pData, (sizeof(int)*iCount));
}
//------------------------------------------------------------------------------------------
- (void)Insert:(int)iDataValue index:(int)iIndex{
    
    if(iIndex<0)return;
    
    if(iIndex+1>iCountInArray){
        
        [self AddData:iDataValue];
        return;
    }
    
    [self Extend];
    
    memcpy(pData+iIndex+1, pData+iIndex, sizeof(int)*(iCountInArray-(iIndex+1)));
    memcpy(pData+iIndex, &iDataValue, sizeof(int));
    iCountInArray++;
}
//------------------------------------------------------------------------------------------
- (void)AddData:(int)iDataValue{
    
    [self Extend];
    memcpy(pData+iCountInArray, &iDataValue, sizeof(int));
    iCountInArray++;
}
//------------------------------------------------------------------------------------------
- (void)RemoveDataAtIndex:(int)iIndex{
    
    if(iIndex+1>iCountInArray)return;
        
    if(bOrder==YES){
        
        if(iIndex+1<iCountInArray)
            memcpy(pData+iIndex, pData+iIndex+1, sizeof(int)*(iCountInArray-(iIndex+1)));
    }
    else{
        memcpy(pData+iIndex, pData+iCountInArray, sizeof(int));
    }
    
    iCountInArray--;
}
//------------------------------------------------------------------------------------------
-(void)selfSave:(NSMutableData *)m_pData{    

    [m_pData appendBytes:&m_iCopasity length:sizeof(int)];
    [m_pData appendBytes:&iCountInArray length:sizeof(int)];
    [m_pData appendBytes:&iCoundAdd length:sizeof(int)];
    [m_pData appendBytes:&bOrder length:sizeof(bool)];

    [m_pData appendBytes:pData length:m_iCopasity*sizeof(int)];
}
//------------------------------------------------------------------------------------------
-(void)selfLoad:(NSMutableData *)m_pData rpos:(int *)iCurReadingPos{
    
    [m_pData getBytes:&m_iCopasity range:NSMakeRange( *iCurReadingPos, sizeof(int))];
    *iCurReadingPos += sizeof(int);
    
    [m_pData getBytes:&iCountInArray range:NSMakeRange( *iCurReadingPos, sizeof(int))];
    *iCurReadingPos += sizeof(int);

    [m_pData getBytes:&iCoundAdd range:NSMakeRange( *iCurReadingPos, sizeof(int))];
    *iCurReadingPos += sizeof(int);
    
    [m_pData getBytes:&bOrder range:NSMakeRange( *iCurReadingPos, sizeof(bool))];
    *iCurReadingPos += sizeof(bool);
    
    [m_pData getBytes:pData range:NSMakeRange( *iCurReadingPos, m_iCopasity*sizeof(float))];
    *iCurReadingPos += m_iCopasity*sizeof(float);
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
