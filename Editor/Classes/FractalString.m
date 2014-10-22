//
//  FractalString.m
//  FunDreams
//
//  Created by Konstantin Maximov on 28.04.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import "FractalString.h"

@implementation FractalString
//------------------------------------------------------------------------------------------------------
- (void)SetNameIcon:(NSString *)Name{
    
    if(sNameIcon!=nil){
        
        [sNameIcon release];
        sNameIcon=nil;
    }
    sNameIcon=[[NSString alloc] initWithString:Name];
}
//------------------------------------------------------------------------------------------------------
- (void)SetNameIcon2:(NSString *)Name{
    
    if(sNameIcon2!=nil){
        [sNameIcon2 release];
        sNameIcon2=nil;
    }
    sNameIcon2=[[NSString alloc] initWithString:Name];
}
//------------------------------------------------------------------------------------------------------
- (void)SetNameIcon3:(NSString *)Name{
    
    if(sNameIcon3!=nil){
        [sNameIcon3 release];
        sNameIcon3=nil;
    }
    sNameIcon3=[[NSString alloc] initWithString:Name];
}
//------------------------------------------------------------------------------------------------------
- (void)SetParent:(FractalString *)Parent{
    
    if(Parent!=nil){
        
        pParent=Parent;
        m_iIndexSelf=[m_pContainer->ArrayPoints SetOb:self];
        [m_pContainer->m_OperationIndex AddData:m_iIndexSelf WithData:Parent->pChildString];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)InitMemory{
    
    if(m_pContainer==nil)return;

    //фрактальная структура, необходима для представления информации из матрицы
    pChildString=[m_pContainer->m_OperationIndex InitMemory];
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{

    bAlradySave=NO;
    bAlradyPrepare=NO;
    [self SetFlag:ONLY_IN_MEM];
    [self SetNameIcon:@"0.png"];
    [self SetNameIcon2:@"0.png"];
    [self SetNameIcon3:@"0.png"];
    m_iIndex=1;//zero
    m_iAdditionalType=ADIT_TYPE_SIMPLE;

    X=-440;
    Y=170;
}
//------------------------------------------------------------------------------------------------------
- (void)CopyChild:(int)iNewCopy WithDic:(NSMutableDictionary *)pDicRename
       WithParent:(FractalString *)Parent WithSourceContainer:(StringContainer *)pSrcContainer
        WithModel:(FractalString *)pModel{
    
    MATRIXcell *pMatr=[m_pContainer->ArrayPoints GetMatrixAtIndex:iNewCopy];
    InfoArrayValue *InfoStrNewCopy=(InfoArrayValue *)(*pMatr->pValueCopy);

//    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pModel->pChildString);
    for (int i=0; i<InfoStrNewCopy->mCount; i++)
    {
        int indexExistingString=((*pModel->pChildString)+SIZE_INFO_STRUCT)[i];
        int indexDoNotConnect=((*pMatr->pValueCopy)+SIZE_INFO_STRUCT)[i];
        
        FractalString *TmpSource=[pSrcContainer->ArrayPoints GetIdAtIndex:indexExistingString];
        
        FractalString *pFStringChild=[[FractalString alloc]
                        initWithName:pModel->strUID
                        WithParent:Parent
                        WithContainer:m_pContainer];

        pFStringChild->m_iAdditionalType=TmpSource->m_iAdditionalType;
        pFStringChild->X=TmpSource->X;
        pFStringChild->Y=TmpSource->Y;
        [pFStringChild SetNameIcon:TmpSource->sNameIcon];
        [pFStringChild SetNameIcon2:TmpSource->sNameIcon2];
        [pFStringChild SetNameIcon3:TmpSource->sNameIcon3];
        pFStringChild->m_iIndex=indexDoNotConnect;
        
        int iType=[m_pContainer->ArrayPoints GetTypeAtIndex:pFStringChild->m_iIndex];
        if(iType==DATA_MATRIX){
            MATRIXcell *pMatrInside=[m_pContainer->ArrayPoints GetMatrixAtIndex:pFStringChild->m_iIndex];
            pMatrInside->iIndexString=pFStringChild->m_iIndexSelf;
        }
        
        NSNumber *pNum = [NSNumber numberWithInt:pFStringChild->m_iIndex];
        FractalString *pTmpString = [pDicRename objectForKey:pNum];
        
        if(pTmpString==0)
        {
            [pDicRename setObject:pFStringChild forKey:pNum];
            
            int iType=[m_pContainer->ArrayPoints GetTypeAtIndex:indexDoNotConnect];
            if(iType==DATA_MATRIX)
            {
                MATRIXcell *pMatrInside=[m_pContainer->ArrayPoints GetMatrixAtIndex:indexDoNotConnect];
                
                if(pMatrInside->TypeInformation==STR_COMPLEX){
                
                [self CopyChild:indexDoNotConnect WithDic:pDicRename
                     WithParent:pFStringChild
                      WithSourceContainer:pSrcContainer
                      WithModel:TmpSource];
                }
            }
        }
        else
        {
            NSNumber *pNumSelf=[NSNumber numberWithInt:pFStringChild->m_iIndexSelf];

            //создаём ассоциации
            if(pTmpString->pAssotiation==nil)
            {
                pFStringChild->pAssotiation=[[NSMutableDictionary alloc] init];
                pTmpString->pAssotiation=[pFStringChild->pAssotiation retain];
                
                NSNumber *pNumSource=[NSNumber numberWithInt:pTmpString->m_iIndexSelf];
                
                [pFStringChild->pAssotiation setObject:pNumSelf forKey:pNumSelf];
                [pFStringChild->pAssotiation setObject:pNumSource forKey:pNumSource];
                
                NSString *pKey = [NSString stringWithFormat:@"%p",pFStringChild->pAssotiation];
                [m_pContainer->ArrayPoints->DicAllAssociations
                        setObject:pFStringChild->pAssotiation forKey:pKey];
            }
            else
            {
                pFStringChild->pAssotiation=[pTmpString->pAssotiation retain];
                [pFStringChild->pAssotiation setObject:pNumSelf forKey:pNumSelf];
            }
            
            //для ссылок используем один и тот же массив
            [m_pContainer->m_OperationIndex ReleaseMemory:pFStringChild->pChildString];
            pFStringChild->pChildString=pTmpString->pChildString;
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (id)initAsCopy:(FractalString *)pStrSource WithParent:(FractalString *)Parent
   WithContainer:(StringContainer *)pContainer WithSourceContainer:(StringContainer *)pSrcContainer
        WithLink:(bool)bLink{

    self = [super init];
	if (self != nil)
    {
        m_pContainer=pContainer;

        [self InitMemory];
        [self SetDefault];
        
        NSString *StrRndName = [m_pContainer GetRndName];
        id TmpId=[m_pContainer->DicStrings objectForKey:pStrSource->strUID];
        
        if(TmpId==nil)
        {
            strUID = [[NSString alloc] initWithString:pStrSource->strUID];
        }
        else
        {
            strUID = [[NSString alloc] initWithString:StrRndName];
        }
        
        X=pStrSource->X;
        Y=pStrSource->Y;
        [self SetNameIcon:pStrSource->sNameIcon];
        [self SetNameIcon2:pStrSource->sNameIcon2];
        [self SetNameIcon3:pStrSource->sNameIcon3];
        [m_pContainer->DicStrings setObject:self forKey:strUID];
        m_iAdditionalType=pStrSource->m_iAdditionalType;
        [self SetParent:Parent];
        
        if(bLink==YES || pStrSource->m_iIndex<=m_pContainer->iIndexMaxSys){
            
            m_iIndex=[m_pContainer->ArrayPoints LinkDataAtIndex:pStrSource->m_iIndex];

            if(Parent!=nil){
                int iType=[m_pContainer->ArrayPoints GetTypeAtIndex:Parent->m_iIndex];
                if(iType==DATA_MATRIX){
                    
                    MATRIXcell *pMatr=[m_pContainer->ArrayPoints GetMatrixAtIndex:Parent->m_iIndex];
                    [m_pContainer->m_OperationIndex AddData:m_iIndex WithData:pMatr->pValueCopy];
                }
            }
            NSNumber *pNumSelf=[NSNumber numberWithInt:m_iIndexSelf];
            
            //создаём ассоциации
            if(pStrSource->pAssotiation==nil)
            {
                pAssotiation=[[NSMutableDictionary alloc] init];
                pStrSource->pAssotiation=[pAssotiation retain];

                NSNumber *pNumSource=[NSNumber numberWithInt:pStrSource->m_iIndexSelf];

                [pAssotiation setObject:pNumSelf forKey:pNumSelf];
                [pAssotiation setObject:pNumSource forKey:pNumSource];

                NSString *pKey = [NSString stringWithFormat:@"%p",pAssotiation];
                [m_pContainer->ArrayPoints->DicAllAssociations setObject:pAssotiation forKey:pKey];
            }
            else
            {
                pAssotiation=[pStrSource->pAssotiation retain];
                [pAssotiation setObject:pNumSelf forKey:pNumSelf];
            }

            //для ссылок используем один и тот же массив
            [m_pContainer->m_OperationIndex ReleaseMemory:pChildString];
            pChildString=pStrSource->pChildString;
        }
        else
        {
            [m_pContainer->ArrayPoints SetSrc:pSrcContainer->ArrayPoints];
            [m_pContainer->ArrayPoints->pDicRename removeAllObjects];

            m_iIndex=[m_pContainer->ArrayPoints CopyDataAtIndex:pStrSource->m_iIndex];

            [m_pContainer->ArrayPoints SetSrc:m_pContainer->ArrayPoints];
    
            int iType=[pSrcContainer->ArrayPoints GetTypeAtIndex:pStrSource->m_iIndex];

            if(iType==DATA_MATRIX){

                NSMutableDictionary *pDicRename=[[NSMutableDictionary alloc] init];
                
                NSNumber *pNum = [NSNumber numberWithInt:self->m_iIndex];
                [pDicRename setObject:self forKey:pNum];
                
                MATRIXcell *pMatrInside=[pSrcContainer->ArrayPoints GetMatrixAtIndex:pStrSource->m_iIndex];
                if(pMatrInside->TypeInformation==STR_COMPLEX){

                    [self CopyChild:m_iIndex WithDic:pDicRename WithParent:self
                          WithSourceContainer:pSrcContainer WithModel:pStrSource];
                }
                
                [pDicRename release];
            }

            iType=[m_pContainer->ArrayPoints GetTypeAtIndex:m_iIndex];
            if(iType==DATA_MATRIX){
                MATRIXcell *pMatrInside=[m_pContainer->ArrayPoints GetMatrixAtIndex:m_iIndex];
                pMatrInside->iIndexString=m_iIndexSelf;
                
//---------------------------------------------------------------------------------------------------
                //добавляем новые матрицы данных если их небыло
                InfoArrayValue *pInfoList=(InfoArrayValue *)*m_pContainer->ArrayPoints->ppListMatrix;
                for (int j=0; j<pInfoList->mCount/2; j++) {
                    
                    int OldInd=(*m_pContainer->ArrayPoints->ppListMatrix+SIZE_INFO_STRUCT)[j];
                    int NewInd=(*m_pContainer->ArrayPoints->ppListMatrix+SIZE_INFO_STRUCT)[j+1];
                    
                    MATRIXcell *pMatrOld=[pSrcContainer->ArrayPoints
                                          GetMatrixAtIndex:OldInd];
                    
                    FractalString *pOldString=[pSrcContainer->ArrayPoints
                                               GetIdAtIndex:pMatrOld->iIndexString];
                    
                    FractalString *pNewString =[[FractalString alloc]
                                                initWithName:@"EmptyOb" WithParent:self
                                                WithContainer:m_pContainer];
                    
                    pNewString->X=-430;
                    pNewString->Y=246;
                    pNewString->m_iIndex=NewInd;
                    [pNewString SetNameIcon:pOldString->sNameIcon];
                    
                    MATRIXcell *pMatrNew=[m_pContainer->ArrayPoints
                                          GetMatrixAtIndex:pNewString->m_iIndex];
                    [m_pContainer->m_OperationIndex AddData:pNewString->m_iIndex
                                                   WithData:pMatrInside->pValueCopy];
                    
                    pMatrNew->TypeInformation=STR_COMPLEX;
                    pMatrNew->NameInformation=STR_SIMPLE;
                    pMatrNew->iIndexString=pNewString->m_iIndexSelf;
                }
                
                [m_pContainer->m_OperationIndex SetCopasity:0
                                    WithData:m_pContainer->ArrayPoints->ppListMatrix];
//---------------------------------------------------------------------------------------------------
            }

            if(Parent!=nil){
                MATRIXcell *pMatr=[m_pContainer->ArrayPoints GetMatrixAtIndex:Parent->m_iIndex];
                [m_pContainer->m_OperationIndex AddData:m_iIndex WithData:pMatr->pValueCopy];
                
                if(iType==DATA_ARRAY)
                {
                    int ** ppArray=[m_pContainer->ArrayPoints GetArrayAtIndex:m_iIndex];
                    InfoArrayValue *pInfo=(InfoArrayValue *)*ppArray;
                    
                    if(pInfo->mFlags & F_EN)
                        [m_pContainer->m_OperationIndex OnlyAddData:m_iIndex WithData:pMatr->pEnters];
                 
                    if(pInfo->mFlags & F_EX)
                        [m_pContainer->m_OperationIndex OnlyAddData:m_iIndex WithData:pMatr->pExits];
                }
            }
        }
    }
    
    return self;
}
//------------------------------------------------------------------------------------------------------
- (id)initWithName:(NSString *)NameString WithParent:(FractalString *)Parent
        WithContainer:(StringContainer *)pContainer{

	self = [super init];
	if (self != nil)
    {
        m_pContainer=pContainer;

        [self InitMemory];
        [self SetDefault];

        NSString *StrRndName = [m_pContainer GetRndName];
        id TmpId=[m_pContainer->DicStrings objectForKey:NameString];
        
        if(TmpId==nil)
        {
            strUID = [[NSString alloc] initWithString:NameString];
        }
        else
        {
            strUID = [[NSString alloc] initWithString:StrRndName];
        }

        [self SetParent:Parent];
        [m_pContainer->DicStrings setObject:self forKey:strUID];
    }

    return self;
}
//------------------------------------------------------------------------------------------------------
- (id)init:(StringContainer *)pContainer{
    
    self = [super init];
	if (self != nil)
    {
        m_pContainer=pContainer;
        
        [self InitMemory];
        [self SetDefault];
        strUID = [[NSString alloc] initWithString:[m_pContainer GetRndName]];

    }
    return self;
}
//------------------------------------------------------------------------------------------------------
-(void)SetFlag:(int)iFlag{
    m_iFlags &=~(DEAD_STRING|SYNH_AND_HEAD|SYNH_AND_LOAD|ONLY_IN_MEM);
    m_iFlags|=iFlag;
}
//------------------------------------------------------------------------------------------------------
-(void)LoadData:(NSMutableData *)pData ReadPos:(int *)iCurReadingPos{
    //Name-----------------------------------------------------------------------------
    unichar* ucBuff = (unichar*)calloc(512, sizeof(unichar));
    int iLen;
    //---------------------------------------------------------------------------------
    NSRange Range = { *iCurReadingPos, sizeof(int)};
    [pData getBytes:&iLen range:Range];
    *iCurReadingPos += sizeof(int);
    Range = NSMakeRange( *iCurReadingPos, iLen*sizeof(unichar));
    
    [pData getBytes:ucBuff range:Range];
    
    *iCurReadingPos += iLen*sizeof(unichar);
    
    NSString *sValue = [NSString stringWithCharacters:ucBuff length:iLen];
    strUID = [[NSString alloc] initWithString:sValue];
    //---------------------------------------------------------------------------------
    Range = NSMakeRange( *iCurReadingPos, sizeof(int));
    [pData getBytes:&iLen range:Range];
    *iCurReadingPos += sizeof(int);
    Range = NSMakeRange( *iCurReadingPos, iLen*sizeof(unichar));
    
    [pData getBytes:ucBuff range:Range];
    
    *iCurReadingPos += iLen*sizeof(unichar);
    
    sValue = [NSString stringWithCharacters:ucBuff length:iLen];
    sNameIcon = [[NSString alloc] initWithString:sValue];
    //---------------------------------------------------------------------------------
    Range = NSMakeRange( *iCurReadingPos, sizeof(int));
    [pData getBytes:&iLen range:Range];
    *iCurReadingPos += sizeof(int);
    Range = NSMakeRange( *iCurReadingPos, iLen*sizeof(unichar));
    
    [pData getBytes:ucBuff range:Range];
    
    *iCurReadingPos += iLen*sizeof(unichar);
    
    sValue = [NSString stringWithCharacters:ucBuff length:iLen];
    sNameIcon2 = [[NSString alloc] initWithString:sValue];
    //---------------------------------------------------------------------------------
    Range = NSMakeRange( *iCurReadingPos, sizeof(int));
    [pData getBytes:&iLen range:Range];
    *iCurReadingPos += sizeof(int);
    Range = NSMakeRange( *iCurReadingPos, iLen*sizeof(unichar));
    
    [pData getBytes:ucBuff range:Range];
    
    *iCurReadingPos += iLen*sizeof(unichar);
    
    sValue = [NSString stringWithCharacters:ucBuff length:iLen];
    sNameIcon3 = [[NSString alloc] initWithString:sValue];
    //---------------------------------------------------------------------------------
    free(ucBuff);
    
    //float value
    Range = NSMakeRange( *iCurReadingPos, sizeof(float));
    [pData getBytes:&X range:Range];
    *iCurReadingPos += sizeof(float);
    
    Range = NSMakeRange( *iCurReadingPos, sizeof(float));
    [pData getBytes:&Y range:Range];
    *iCurReadingPos += sizeof(float);
    
    Range = NSMakeRange( *iCurReadingPos, sizeof(int));
    [pData getBytes:&m_iFlags range:Range];
    *iCurReadingPos += sizeof(int);
        
    //индексы
    Range = NSMakeRange( *iCurReadingPos, sizeof(int));
    [pData getBytes:&m_iIndex range:Range];
    *iCurReadingPos += sizeof(int);

    Range = NSMakeRange( *iCurReadingPos, sizeof(int));
    [pData getBytes:&m_iIndexSelf range:Range];
    *iCurReadingPos += sizeof(int);

    //дополнительныей тип
    Range = NSMakeRange( *iCurReadingPos, sizeof(short));
    [pData getBytes:&m_iAdditionalType range:Range];
    *iCurReadingPos += sizeof(short);

    //состояние массива (номер)
    Range = NSMakeRange( *iCurReadingPos, sizeof(int));
    [pData getBytes:&m_iCurState range:Range];
    *iCurReadingPos += sizeof(int);
//------------------------------------------------------------------------------------
}
//------------------------------------------------------------------------------------------------------
-(void)SaveData:(NSMutableData *)pData{
    
    //Name
    unichar* ucBuff = (unichar*)calloc(512, sizeof(unichar));
    
    [strUID getCharacters:ucBuff];
    int Len=[strUID length];
    [pData appendBytes:&Len length:sizeof(int)];
    [pData appendBytes:ucBuff length:Len*sizeof(unichar)];
    
    [sNameIcon getCharacters:ucBuff];
    Len=[sNameIcon length];
    [pData appendBytes:&Len length:sizeof(int)];
    [pData appendBytes:ucBuff length:Len*sizeof(unichar)];

    [sNameIcon2 getCharacters:ucBuff];
    Len=[sNameIcon2 length];
    [pData appendBytes:&Len length:sizeof(int)];
    [pData appendBytes:ucBuff length:Len*sizeof(unichar)];

    [sNameIcon3 getCharacters:ucBuff];
    Len=[sNameIcon3 length];
    [pData appendBytes:&Len length:sizeof(int)];
    [pData appendBytes:ucBuff length:Len*sizeof(unichar)];

    free(ucBuff);
//--------------------------------------------------------------------------------------------------
    //float value
    [pData appendBytes:&X length:sizeof(float)];
    [pData appendBytes:&Y length:sizeof(float)];
    //флаги
    [pData appendBytes:&m_iFlags length:sizeof(m_iFlags)];
    //индексы
    [pData appendBytes:&m_iIndex length:sizeof(int)];
    [pData appendBytes:&m_iIndexSelf length:sizeof(int)];

    [pData appendBytes:&m_iAdditionalType length:sizeof(short)];
    [pData appendBytes:&m_iCurState length:sizeof(int)];
}
//------------------------------------------------------------------------------------------------------
- (id)initWithData:(NSMutableData *)pData WithCurRead:(int *)iCurReadingPos
        WithParent:(FractalString *)Parent WithContainer:(StringContainer *)pContainer{
    
    self = [super init];
	if (self != nil)
    {
        m_pContainer=pContainer;
        [self InitMemory];
        [self SetDefault];
        
        [self selfLoad:pData ReadPos:iCurReadingPos WithContainer:pContainer];
        [pContainer->DicStrings setObject:self forKey:strUID];
        
        pParent=Parent;
    }
    
    return self;
}
//------------------------------------------------------------------------------------------------------
-(void)PrepareMatrix:(StringContainer *)pContainer WithStartString:(FractalString *)pString
{
    if(pString->bAlradyPrepare==YES)return;
    else pString->bAlradyPrepare=YES;

    int iType=[pContainer->ArrayPoints GetTypeAtIndex:pString->m_iIndex];

    if(iType==DATA_MATRIX){
        MATRIXcell *pMatrInside=[pContainer->ArrayPoints GetMatrixAtIndex:pString->m_iIndex];
        int iCount=[pContainer->ArrayPoints GetCountAtIndex:pString->m_iIndex];
        
        if(iCount>0)
            pMatrInside->iIndexString=pString->m_iIndexSelf;
    }

    int *pStart = *pString->pChildString+SIZE_INFO_STRUCT;
    InfoArrayValue *pInfo=(InfoArrayValue *)(*pString->pChildString);
    
    for (int i=0; i<pInfo->mCount; i++) {
        int iIndex=pStart[i];
        
        FractalString *fStringChild = [pContainer->ArrayPoints GetIdAtIndex:iIndex];
        [self PrepareMatrix:pContainer WithStartString:fStringChild];
    }
}
//------------------------------------------------------------------------------------------------------
-(void)selfLoad:(NSMutableData *)pData ReadPos:(int *)iCurReadingPos
        WithContainer:(StringContainer *)pContainer{
    
    [self LoadData:pData ReadPos:iCurReadingPos];
    
    //загружаем матрицу струны
    [m_pContainer->m_OperationIndex selfLoad:pData rpos:iCurReadingPos WithData:pChildString];
    
    //child string
    NSRange Range = NSMakeRange( *iCurReadingPos, sizeof(int));
    int iCount=0;
    [pData getBytes:&iCount range:Range];
    *iCurReadingPos += sizeof(int);
    
    for (int i=0; i<iCount; i++) {
        
        [[FractalString alloc] initWithData:pData
            WithCurRead:iCurReadingPos WithParent:self WithContainer:pContainer];
    }
}
//------------------------------------------------------------------------------------------------------
-(void)selfSave:(NSMutableData *)m_pData WithVer:(int)iVersion
{
    switch (iVersion) {
        case 1:
        {
            [self SaveData:m_pData];

            //сохраняем матрицу струны
            [m_pContainer->m_OperationIndex selfSave:m_pData WithData:pChildString];
            
            //child string
            InfoArrayValue *InfoStr=(InfoArrayValue *)*pChildString;
            int *StartIndex=(*pChildString)+SIZE_INFO_STRUCT;
            int iCount=InfoStr->mCount;
            
            if(bAlradySave==NO){
                bAlradySave=YES;
                if(pAssotiation!=nil){
                    
                    id array = [pAssotiation allKeys];
                    
                    for (int i=0; i<[array count]; i++) {
                        
                        int pIndexCurrentAss=[[array objectAtIndex:i] intValue];
                        
                        if(pIndexCurrentAss!=m_iIndexSelf)
                        {
                            FractalString *FAssoc=[m_pContainer->ArrayPoints
                                                   GetIdAtIndex:pIndexCurrentAss];
                            FAssoc->bAlradySave=YES;
                        }
                    }
                }
                
                [m_pData appendBytes:&iCount length:sizeof(int)];
                
                for (int i=0; i<iCount; i++) {
                    
                    int index=(StartIndex)[i];
                    FractalString *FChild=[m_pContainer->ArrayPoints GetIdAtIndex:index];
                    
                    [FChild selfSave:m_pData WithVer:iVersion];
                }                
            }
            else
            {
                iCount=0;
                [m_pData appendBytes:&iCount length:sizeof(int)];
            }
        }
        break;
            
        default:
        break;
    }    
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc
{
    int TypeDel=[m_pContainer->ArrayPoints GetTypeAtIndex:m_iIndex];
    if(TypeDel==DATA_MATRIX)
    {
        if(pAssotiation==nil)
        {
            if(pChildString!=0)
            {
                [m_pContainer DelChilds:self];
                [m_pContainer->m_OperationIndex OnlyReleaseMemory:pChildString];
                pChildString=0;
            }
        }
        else
        {
            [pAssotiation release];
            pAssotiation=nil;
        }
    }
    else
    {
        if(pAssotiation==nil)
        {
            if(pChildString!=0)
            {
                [m_pContainer->m_OperationIndex OnlyReleaseMemory:pChildString];
                pChildString=0;
            }
        }
        else
        {
            [pAssotiation release];
            pAssotiation=nil;
        }
    }

    [sNameIcon release];
    [sNameIcon2 release];
    [sNameIcon3 release];
    
    [strUID release];

    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
@end
