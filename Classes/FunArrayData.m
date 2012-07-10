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

        m_bValue=NO;
        iCountInc=5;
        iCountInArray=0;
        iCount=iCopasity;
        iType=4;

        pData = malloc(iType*iCount);
    }
    
    return self;
}

- (void)Reserv:(int)NewSize{
    iCount=NewSize;

    if(iCount<iCountInArray)iCountInArray=iCount;
    pData = realloc(pData, iType*iCount);
}

- (void *)AddData:(void *)pDataValue{
    if(iCount==iCountInArray){
        
        iCount+=iCountInc;
        pData=realloc(pData,iCount*iType);
    }

    float *TmpLink;
    if(m_bValue){
        TmpLink=(float *)malloc(iType);
        *TmpLink=*(float *)pDataValue;
    }
    else TmpLink=pDataValue;
    
    memcpy((float *)(pData+iCountInArray*4),&TmpLink, 4);

    float **fRet=(float **)(pData+iCountInArray*4);
    iCountInArray++;    

    return *fRet;
}

- (void)RemoveDataAtIndex:(int)iIndex{
    
    if(m_bValue==YES){

        float **TmpLink=(float **)(pData+iIndex*4);
        float *TmpLink2=*TmpLink;
        free(TmpLink2);
    }

    iCountInArray--;
    memcpy((float *)(pData+iIndex*4), (float *)(pData+iCountInArray*4), 4);
}

- (void *)GetDataAtIndex:(int)iIndex{
    if(iIndex>iCountInArray)return 0;
    
    float **fRet=((float **)(pData+iCountInArray));

    return *fRet;
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
