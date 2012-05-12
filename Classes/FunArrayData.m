//
//  FunArrayData.m
//  FunDreams
//
//  Created by Konstantin Maximov on 24.04.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import "FunArrayData.h"

@implementation FunArrayData

-(id)initWithCopasity:(int)iCopasity CountByte:(int)i_Type{

    self = [super init];

    if(self){

        iCountInArray=0;
        iCount=iCopasity;
        iType=i_Type;

        pData = malloc(iType*iCount);
    }
    
    return self;
}

- (void)Reserv:(int)NewSize{
    iCount=NewSize;

    if(iCount>iCountInArray)iCountInArray=iCount;
    pData = realloc(pData, iType*iCount);
}

- (void)AddData:(void *)pDataValue{
    if(iCount==iCountInArray){
        iCount+=5;
        pData = realloc(pData, (iType*iCount));
    }

    iCountInArray++;
    memcpy(pData+(iCountInArray*iType), pDataValue, iType);
}

- (void)RemoveDataAtIndex:(int)iIndex{
    memcpy(pData+(iIndex*iType), pData+(iCountInArray*iType), iType);
    iCountInArray--;
}

- (void *)GetDataAtIndex:(int)iIndex{
    if(iIndex>iCountInArray)return 0;
    
    void *fRet=pData+(iCountInArray*iType);

    return fRet;
}

- (void)Reset{
    iCountInArray=0;
}

- (void)dealloc
{
    free(pData);
    [super dealloc];
}
@end
