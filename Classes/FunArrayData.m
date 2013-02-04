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
        pMartixDic = [[NSMutableDictionary alloc] init];
        pDicRename = [[NSMutableDictionary alloc] init];
        
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
- (int)LinkDataAtIndex:(int)iIndex{
    
    [self IncDataAtIndex:iIndex];
    return iIndex;
}
//------------------------------------------------------------------------------------------
- (int)CopyDataAtIndex:(int)iIndex{
    BYTE bType=(*(pType+iIndex));
    float *pDataTmp=(pData+iIndex);

    int iRetIndex=0;
    
    switch (bType) {
        case DATA_ID:
            iRetIndex = [self SetOb:*((FractalString **)pDataTmp)];
            break;
            
        case DATA_MATRIX:
        {
            [pDicRename removeAllObjects];
            iRetIndex = [self SetMatrix:*((MATRIXcell **)pDataTmp)];
        }
        break;

        case DATA_FLOAT:
            iRetIndex = [self SetFloat:*pDataTmp];
            break;

        case DATA_INT:
            iRetIndex = [self SetInt:*((int *)pDataTmp)];
            break;

        case DATA_STRING:
            iRetIndex = [self SetName:*((NSMutableString **)pDataTmp)];
            break;

        default:
            break;
    }
    return iRetIndex;
}
//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
- (int)SetFloat:(float)DataValue{

    int iIndex=[self GetFree];
    
    float *TmpLink=pData+iIndex;
    
    *TmpLink=DataValue;

    (*(pType+iIndex))=DATA_FLOAT;

    return iIndex;
}
//------------------------------------------------------------------------------------------
- (int)SetInt:(int)DataValue{
    
    int iIndex=[self GetFree];
    
    int *TmpLink=(int *)pData+iIndex;
    
    *TmpLink=DataValue;
    
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

    (*(pType+iIndex))=DATA_ID;
    DataValue->m_iIndex=iIndex;

    return iIndex;
}
//------------------------------------------------------------------------------------------
- (void)InitMemoryMatrix:(MATRIXcell *)pMatr{
    
    if(pParent==nil)return;
    
    //переменные-точки
    pMatr->pValueCopy = [pParent->m_OperationIndex InitMemory];
    pMatr->pValueLink = [pParent->m_OperationIndex InitMemory];
    
    //связи
    pMatr->pQueue = [pParent->m_OperationIndex InitMemory];
    
    pMatr->TypeInformation=0;
    pMatr->NameInformation=0;
}
//------------------------------------------------------------------------------------------------------
- (int)SetMatrix:(MATRIXcell *)DataMatrix{

    int iIndex=[self GetFree];

    MATRIXcell *pNewMatr=(MATRIXcell *)malloc(sizeof(MATRIXcell));
    [self InitMemoryMatrix:pNewMatr];

    MATRIXcell **TmpLink=(MATRIXcell **)(pData+iIndex);
    *TmpLink=pNewMatr;
    
    (*(pType+iIndex))=DATA_MATRIX;
    pNewMatr->iIndexSelf=iIndex;
    
    if(DataMatrix!=0){
//copy matrix ========================================================================
        pNewMatr->NameInformation=DataMatrix->NameInformation;
        pNewMatr->TypeInformation=DataMatrix->TypeInformation;
                
        //копируем link
        [pParent->m_OperationIndex CopyDataFrom:DataMatrix->pValueLink To:pNewMatr->pValueLink];
        
        //копируем copy
        InfoArrayValue *InfoStr=(InfoArrayValue *)(*DataMatrix->pValueCopy);
        int *StartData=((*DataMatrix->pValueCopy)+SIZE_INFO_STRUCT);

        for (int i=0; i<InfoStr->mCount; i++) {
            int iTmpIndex=StartData[i];
            
            NSNumber *pOldNum = [NSNumber numberWithInt:iTmpIndex];
            NSNumber *pNewNum = [pDicRename objectForKey:pOldNum];
            
            if(pNewNum==nil){
                int iNewIndex=[self CopyDataAtIndex:iTmpIndex];
                
                NSNumber *pNumTmp=[NSNumber numberWithInt:iNewIndex];
                [pDicRename setObject:pNumTmp forKey:pOldNum];
                
                [pParent->m_OperationIndex AddData:iNewIndex WithData:pNewMatr->pValueCopy];
            }
            else
            {
                int IncIndex = [pNewNum intValue];
                [pParent->m_OperationIndex AddData:IncIndex WithData:pNewMatr->pValueCopy];
            }
        }
        
        //pNewMatr->pQueue// copy queue
//===================================================================================
    }
    
    NSValue *pObj = [NSValue value:pNewMatr withObjCType:@encode(MATRIXcell)];
    NSNumber *pVal = [NSNumber numberWithInt:iIndex];
    [pMartixDic setObject:pObj forKey:pVal];

    return iIndex;
}
//------------------------------------------------------------------------------------------
- (MATRIXcell *)GetMatrixAtIndex:(int)iIndex{
    if(iIndex>iCount)return 0;
    
    BYTE iType=(*(pType+iIndex));
    
    MATRIXcell **fRet=0;
    
    if(iType==DATA_MATRIX){
        fRet=(MATRIXcell **)(pData+iIndex);
        return *fRet;
    }
    else return 0;
}
//------------------------------------------------------------------------------------------
- (void *)GetDataAtIndex:(int)iIndex{
    if(iIndex>iCount)return 0;
    
    BYTE iType=(*(pType+iIndex));

    void *fRet=0;
    if(iType!=DATA_MATRIX && iType!=DATA_ID)
        fRet=(pData+iIndex);
    
    return fRet;
}
//------------------------------------------------------------------------------------------
- (id)GetIdAtIndex:(int)iIndex{
    if(iIndex>iCount)return 0;
    
    BYTE iType=(*(pType+iIndex));

    id *fRet=0;
    if(iType==DATA_ID || iType==DATA_STRING){
        fRet=(id *)(pData+iIndex);
        return *fRet;
    }
    else return 0;
}
//------------------------------------------------------------------------------------------
- (int)GetIncAtIndex:(int)iIndex{
    int iRet=(*(pDataInt+iIndex));
    return iRet;
}
//------------------------------------------------------------------------------------------
- (unsigned char)GetTypeAtIndex:(int)iIndex{
    BYTE iRet=(*(pType+iIndex));
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
    
    if(*TmpIndex>0){
        
        (*TmpIndex)--;
        if(*TmpIndex==0)
        {
            unsigned char uType = (*(pType+iIndex));

            NSString *pKey = [NSString stringWithFormat:@"%d",iIndex];

            switch (uType) {
                case DATA_ID:
                {
                    NSString * pName = [pNamesOb objectForKey:pKey];
                    FractalString *pFStr = [pParent->DicStrings objectForKey:pName];
                    
                    [pFStr release];
                    
                    [pNamesOb removeObjectForKey:pKey];
                }
                break;

                case DATA_MATRIX:
                {
                    MATRIXcell *pMatr=[pParent->ArrayPoints GetMatrixAtIndex:iIndex];
                    
                    [pParent->m_OperationIndex ReleaseMemory:pMatr->pValueCopy];
                    [pParent->m_OperationIndex ReleaseMemory:pMatr->pValueLink];
                    
                    NSNumber *pVal = [NSNumber numberWithInt:pMatr->iIndexSelf];
                    [pMartixDic removeObjectForKey:pVal];

                    free(pMatr);
                }
                break;

                case DATA_STRING:
                    [pNamesValue removeObjectForKey:pKey];
                
                    break;

                default:
                    break;
            }

            iCountInArray--;
            NSNumber *pNum=[NSNumber numberWithInt:iIndex];
            [pFreeArray addObject:pNum];
        }
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
    iLen = [pMartixDic count];
    [m_pData appendBytes:&iLen length:sizeof(int)];

    //сохраняем матрицы
    NSEnumerator *Matr_enumerator = [pMartixDic objectEnumerator];
    NSValue *pValueMatr;
    
    while ((pValueMatr = [Matr_enumerator nextObject])){
        
        MATRIXcell pMatr;
        [pValueMatr getValue:&pMatr];
        [self SaveMatrix:m_pData WithMatr:&pMatr];
    }
}
//--------------------------------------------------------------------------------
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
    
    *iCurReadingPos += iLen;
//--------------------------------------------------------------------------------
    [pMartixDic removeAllObjects];
    [m_pData getBytes:&iLen range:NSMakeRange( *iCurReadingPos, sizeof(int))];
    *iCurReadingPos += sizeof(int);

    for (int i=0; i<iLen; i++) {
        
        MATRIXcell *pMatr=(MATRIXcell *)malloc(sizeof(MATRIXcell));
        [self InitMemoryMatrix:pMatr];

        [self LoadMatrix:m_pData rpos:iCurReadingPos WithMatr:pMatr];
        
        NSValue *pObj = [NSValue value:pMatr withObjCType:@encode(MATRIXcell)];
        NSNumber *pVal = [NSNumber numberWithInt:pMatr->iIndexSelf];
        [pMartixDic setObject:pObj forKey:pVal];
        
        MATRIXcell **TmpLinkMatr=(MATRIXcell **)(pData+pMatr->iIndexSelf);
        *TmpLinkMatr=pMatr;
    }
//--------------------------------------------------------------------------------
    [self PrepareLoadData];
}
//------------------------------------------------------------------------------------------
- (void)LoadMatrix:(NSMutableData *)pMutData rpos:(int *)iCurReadingPos WithMatr:(MATRIXcell *)pMatr{
    
    [pParent->m_OperationIndex selfLoad:pMutData rpos:iCurReadingPos WithData:pMatr->pValueCopy];
    [pParent->m_OperationIndex selfLoad:pMutData rpos:iCurReadingPos WithData:pMatr->pValueLink];
    [pParent->m_OperationIndex selfLoad:pMutData rpos:iCurReadingPos WithData:pMatr->pQueue];

    //тип струны.
    NSRange Range = NSMakeRange( *iCurReadingPos, sizeof(BYTE));
    [pMutData getBytes:&pMatr->TypeInformation range:Range];
    *iCurReadingPos += sizeof(BYTE);
    
    //Имя-число струны.
    Range = NSMakeRange( *iCurReadingPos, sizeof(short));
    [pMutData getBytes:&pMatr->NameInformation range:Range];
    *iCurReadingPos += sizeof(short);

    //индекс струны.
    Range = NSMakeRange( *iCurReadingPos, sizeof(int));
    [pMutData getBytes:&pMatr->iIndexSelf range:Range];
    *iCurReadingPos += sizeof(int);
}
//------------------------------------------------------------------------------------------
- (void)SaveMatrix:(NSMutableData *)pMutData WithMatr:(MATRIXcell *)pMatr{
    
    [pParent->m_OperationIndex selfSave:pMutData WithData:pMatr->pValueCopy];
    [pParent->m_OperationIndex selfSave:pMutData WithData:pMatr->pValueLink];
    [pParent->m_OperationIndex selfSave:pMutData WithData:pMatr->pQueue];

    //тип струны.
    [pMutData appendBytes:&pMatr->TypeInformation length:sizeof(BYTE)];
    //Имя-число струны.
    [pMutData appendBytes:&pMatr->NameInformation length:sizeof(short)];
    //Индекс струны.
    [pMutData appendBytes:&pMatr->iIndexSelf length:sizeof(int)];
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
    [pMartixDic release];
    [pDicRename release];

    [super dealloc];
}
//------------------------------------------------------------------------------------------
@end
