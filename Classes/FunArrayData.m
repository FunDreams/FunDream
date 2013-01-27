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
        
        pNamesOb = [[NSMutableDictionary alloc] init];
        pNamesValue = [[NSMutableDictionary alloc] init];
        
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
    pType=realloc(pType,iCount*sizeof(unsigned char));
    
    for (int i=0; i<CountInc; i++) {
        
        int Index=FirstIndex+i;

        NSNumber *pNum=[NSNumber numberWithInt:Index];
        [pFreeArray addObject:pNum];
        
        *(pDataInt+FirstIndex+i)=0;
        *(pData+FirstIndex+i)=0;
        *(pType+FirstIndex+i)=0;
    }
}
//------------------------------------------------------------------------------------------
- (void)Reserv:(int)iCountTmp{
    iCount=iCountTmp;
    
    pData=malloc(iCountTmp*sizeof(float));
    pDataInt=malloc(iCountTmp*sizeof(int));
    pType=malloc(iCountTmp*sizeof(unsigned char));
    
    memset(pData, 0, sizeof(float));
    memset(pDataInt, 0, sizeof(int));
    memset(pType, 0, sizeof(unsigned char));
}
//------------------------------------------------------------------------------------------
- (int)GetFree{
    
    if([pFreeArray count]==0){
        [self Increase:iCountInc];
    }
    
    NSNumber *pNum=[pFreeArray objectAtIndex:0];
    int IndexFree=[pNum intValue];
    [pFreeArray removeObjectAtIndex:0];
    return IndexFree;
}
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
- (int)SetFloat:(float)DataValue{

    int iIndex=[self GetFree];
    
    float *TmpLink=pData+iIndex;
    
    *TmpLink=DataValue;
//    (*((int *)pDataInt+iIndex))++;
//    iCountInArray++;

    (*(pType+iIndex))=DATA_FLOAT;

    return iIndex;
}
//------------------------------------------------------------------------------------------
- (int)SetInt:(int)DataValue{
    
    int iIndex=[self GetFree];
    
    int *TmpLink=(int *)pData+iIndex;
    
    *TmpLink=DataValue;
//    (*((int *)pDataInt+iIndex))++;
//    iCountInArray++;
    
    (*(pType+iIndex))=DATA_INT;
    
    return iIndex;
}
//------------------------------------------------------------------------------------------
- (int)SetName:(NSMutableString *)DataValue{
    
    int iIndex=[self GetFree];
        
    NSString *pKey = [NSString stringWithFormat:@"%d",iIndex];
    [pNamesValue setValue:DataValue forKey:pKey];
    
    id *TmpLink=(id *)(pData+iIndex);
    *(TmpLink)=DataValue;
    
//    (*((int *)pDataInt+iIndex))++;
//    iCountInArray++;
    
    (*(pType+iIndex))=DATA_STRING;
    
    return iIndex;
}
//------------------------------------------------------------------------------------------
- (int)SetOb:(FractalString *)DataValue{
    
    int iIndex=[self GetFree];
    
    NSString *pKey = [NSString stringWithFormat:@"%d",iIndex];
    [pNamesOb setValue:DataValue->strUID forKey:pKey];

    id *TmpLink=(id *)(pData+iIndex);
    *(TmpLink)=DataValue;

//    (*((int *)pDataInt+iIndex))++;
//    iCountInArray++;

    (*(pType+iIndex))=DATA_ID;
    DataValue->m_iIndex=iIndex;

    return iIndex;
}
//------------------------------------------------------------------------------------------
- (void *)GetDataAtIndex:(int)iIndex{
    if(iIndex>iCount)return 0;
    
    void *fRet=(pData+iIndex);
    
    return fRet;
}
//------------------------------------------------------------------------------------------
- (id)GetIdAtIndex:(int)iIndex{
    if(iIndex>iCount)return 0;
    
    id *fRet=(id *)(pData+iIndex);
    return *fRet;
}
//------------------------------------------------------------------------------------------
- (int)GetIncAtIndex:(int)iIndex{
    int iRet=(*(pDataInt+iIndex));
    return iRet;
}
//------------------------------------------------------------------------------------------
- (unsigned char)GetTypeAtIndex:(int)iIndex{
    unsigned char iRet=(*(pType+iIndex));
    return iRet;
}
//------------------------------------------------------------------------------------------
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
        unsigned char uType = (*(pType+iIndex));

        NSString *pKey = [NSString stringWithFormat:@"%d",iIndex];

        if(uType==DATA_ID){
            NSString * pName = [pNamesOb objectForKey:pKey];
            FractalString *pFStr = [pParent->DicStrings objectForKey:pName];
            [pFStr release];

            [pNamesOb removeObjectForKey:pKey];
        }
        else if(uType==DATA_STRING){
            [pNamesValue removeObjectForKey:pKey];
//            [pNamesValue release];
        }

        iCountInArray--;
        NSNumber *pNum=[NSNumber numberWithInt:iIndex];
        [pFreeArray addObject:pNum];
    }
}
//------------------------------------------------------------------------------------------
-(void)selfSave:(NSMutableData *)m_pData{
    
    [m_pData appendBytes:&iCount length:sizeof(int)];
    [m_pData appendBytes:&iCountInArray length:sizeof(int)];
    [m_pData appendBytes:&iCountInc length:sizeof(int)];
    
    [m_pData appendBytes:pData length:iCount*sizeof(float)];
    [m_pData appendBytes:pDataInt length:iCount*sizeof(int)];
    [m_pData appendBytes:pType length:iCount*sizeof(unsigned char)];

//сохраняем свободные ячейки------------------------------------------------------
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:pFreeArray];
    int iLen=[data length];
    
    [m_pData appendBytes:&iLen length:sizeof(int)];
    [m_pData appendData:data];
//--------------------------------------------------------------------------------
    data=[NSKeyedArchiver archivedDataWithRootObject:pNamesOb];
    iLen=[data length];
    
    [m_pData appendBytes:&iLen length:sizeof(int)];
    [m_pData appendData:data];
//--------------------------------------------------------------------------------
    data=[NSKeyedArchiver archivedDataWithRootObject:pNamesValue];
    iLen=[data length];
    
    [m_pData appendBytes:&iLen length:sizeof(int)];
    [m_pData appendData:data];
//--------------------------------------------------------------------------------
}
//------------------------------------------------------------------------------------------
-(void)PrepareLoadData{
    
    NSEnumerator *Key_enumerator = [pNamesOb keyEnumerator];
    NSString *pNameKey;
    
    while ((pNameKey = [Key_enumerator nextObject])) {
        
        NSString * pName = [pNamesOb objectForKey:pNameKey];
        
        FractalString *pFStr = [pParent->DicStrings objectForKey:pName];

        int iKey=[pNameKey intValue];
        id *fRet=((id *)(pData+iKey));

        if(pFStr==0)*fRet=0;
        else *fRet=pFStr;
    }

    Key_enumerator = [pNamesValue keyEnumerator];
    
    while ((pNameKey = [Key_enumerator nextObject])) {
        
        NSString * pName = [pNamesValue objectForKey:pNameKey];
        
        int iKey=[pNameKey intValue];
        id *fRet=((id *)(pData+iKey));
        
        *fRet=pName;
    }
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

    [m_pData getBytes:pType range:NSMakeRange( *iCurReadingPos, iCount*sizeof(unsigned char))];
    *iCurReadingPos += iCount*sizeof(unsigned char);
//--------------------------------------------------------------------------------
    int iLen;
    [m_pData getBytes:&iLen range:NSMakeRange( *iCurReadingPos, sizeof(int))];
    *iCurReadingPos += sizeof(int);

    NSData *iv = [m_pData subdataWithRange:NSMakeRange(*iCurReadingPos, iLen)];
    
    if(pFreeArray!=nil)[pFreeArray release];
    pFreeArray = [[NSKeyedUnarchiver unarchiveObjectWithData:iv] retain];
    
    *iCurReadingPos += iLen;
//--------------------------------------------------------------------------------
    [m_pData getBytes:&iLen range:NSMakeRange( *iCurReadingPos, sizeof(int))];
    *iCurReadingPos += sizeof(int);
    
    iv = [m_pData subdataWithRange:NSMakeRange(*iCurReadingPos, iLen)];
    
    if(pNamesOb!=nil)[pNamesOb release];
    pNamesOb = [[NSKeyedUnarchiver unarchiveObjectWithData:iv] retain];
    
    *iCurReadingPos += iLen;
//--------------------------------------------------------------------------------
    [m_pData getBytes:&iLen range:NSMakeRange( *iCurReadingPos, sizeof(int))];
    *iCurReadingPos += sizeof(int);
    
    iv = [m_pData subdataWithRange:NSMakeRange(*iCurReadingPos, iLen)];
    
    if(pNamesValue!=nil)[pNamesValue release];
    pNamesValue = [[NSKeyedUnarchiver unarchiveObjectWithData:iv] retain];
//--------------------------------------------------------------------------------
    [self PrepareLoadData];
}
//------------------------------------------------------------------------------------------
- (void)dealloc
{
    free(pData);
    free(pDataInt);
    free(pType);
    [pFreeArray release];
    
    [pNamesOb release];
    [pNamesValue release];

    [super dealloc];
}
//------------------------------------------------------------------------------------------
@end
