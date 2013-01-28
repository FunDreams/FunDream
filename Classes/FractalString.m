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
- (void)SetParent:(FractalString *)Parent{
    
    if(Parent!=nil){
        
        pParent=Parent;
        m_iIndex=[m_pContainer->ArrayPoints SetOb:self];
        
        [m_pContainer->m_OperationIndex AddData:m_iIndex WithData:Parent->pChildString];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)InitMemory{
    
    if(m_pContainer==nil)return;
    
    //переменные-точки
    pValueCopy = [m_pContainer->m_OperationIndex InitMemory];
    pValueLink = [m_pContainer->m_OperationIndex InitMemory];

    //дочерние струны
    pChildString=[m_pContainer->m_OperationIndex InitMemory];
 //   pPointLink=[m_pContainer->m_OperationIndex InitMemory];

    //связи
    pEnters = [m_pContainer->m_OperationIndex InitMemory];
    pExits = [m_pContainer->m_OperationIndex InitMemory];
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{

    [self SetFlag:ONLY_IN_MEM];
    [self SetNameIcon:@"none"];

    X=-440;
    Y=170;
}
//------------------------------------------------------------------------------------------------------
- (id)init:(StringContainer *)pContainer{
    
    self = [super init];
	if (self != nil)
    {
        m_pContainer=pContainer;

        [self InitMemory];
        [self SetDefault];
    }
    return self;
}
//------------------------------------------------------------------------------------------------------
- (id)initAsCopy:(FractalString *)pStrSource WithParent:(FractalString *)Parent
   WithContainer:(StringContainer *)pContainer WithLink:(bool)bLink{
    
    self = [super init];
	if (self != nil)
    {
        m_pContainer=pContainer;

        [self InitMemory];
        [self SetDefault];
        
        TypeInformation=pStrSource->TypeInformation;
        NameInformation=pStrSource->NameInformation;

        X=pStrSource->X;
        Y=pStrSource->Y;

        if(bLink==YES)
            m_iFlags&=LINK;
        else m_iFlags&=~LINK;
        
        strUID = [pContainer GetRndName];
        [self SetParent:Parent];
        
        [self SetNameIcon:pStrSource->sNameIcon];

        [pContainer->DicStrings setObject:self forKey:strUID];
        
        InfoArrayValue *InfoStr=(InfoArrayValue *)(*pStrSource->pChildString);

        for (int i=0; i<InfoStr->mCount; i++) {
            
            int index=((*pStrSource->pChildString)+SIZE_INFO_STRUCT)[i];
            FractalString *TmpStr=[pContainer->ArrayPoints GetIdAtIndex:index];
                        
//            [pContainer->m_OperationIndex CopyDataFrom:pStrSource->pPointLink To:pPointLink];

            bool LocalLink = TmpStr->m_iFlags&LINK;
            [[FractalString alloc] initAsCopy:TmpStr WithParent:self
                    WithContainer:pContainer WithLink:(bool)LocalLink];
        }
    }
    
    return self;
}
//------------------------------------------------------------------------------------------------------
- (id)initWithName:(NSString *)NameString WithParent:(FractalString *)Parent
        WithContainer:(StringContainer *)pContainer WithLink:(bool)bLink{

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
        //      [self SetParent:Parent WithLink:m_iFlags&LINK];
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
    
    //тип струны.
    Range = NSMakeRange( *iCurReadingPos, sizeof(BYTE));
    [pData getBytes:&TypeInformation range:Range];
    *iCurReadingPos += sizeof(BYTE);
    
    //Имя-число струны.
    Range = NSMakeRange( *iCurReadingPos, sizeof(short));
    [pData getBytes:&NameInformation range:Range];
    *iCurReadingPos += sizeof(short);
    
    //индекс
    Range = NSMakeRange( *iCurReadingPos, sizeof(int));
    [pData getBytes:&m_iIndex range:Range];
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
    
    free(ucBuff);
    //------------------------------------------------------------------------------------------------------
    //float value
    [pData appendBytes:&X length:sizeof(float)];
    [pData appendBytes:&Y length:sizeof(float)];
    //флаги
    [pData appendBytes:&m_iFlags length:sizeof(m_iFlags)];
    //тип струны.
    [pData appendBytes:&TypeInformation length:sizeof(BYTE)];
    //Имя-число струны.
    [pData appendBytes:&NameInformation length:sizeof(short)];
    //индекс
    [pData appendBytes:&m_iIndex length:sizeof(int)];
}
//------------------------------------------------------------------------------------------------------
-(void)selfLoad:(NSMutableData *)pData ReadPos:(int *)iCurReadingPos
  WithContainer:(StringContainer *)pContainer{
    
    [self LoadData:pData ReadPos:iCurReadingPos];
    
    //сохраняем матрицу струны
    [m_pContainer->m_OperationIndex selfLoad:pData rpos:iCurReadingPos WithData:pValueCopy];
    [m_pContainer->m_OperationIndex selfLoad:pData rpos:iCurReadingPos WithData:pValueLink];
    [m_pContainer->m_OperationIndex selfLoad:pData rpos:iCurReadingPos WithData:pEnters];
    [m_pContainer->m_OperationIndex selfLoad:pData rpos:iCurReadingPos WithData:pExits];
    [m_pContainer->m_OperationIndex selfLoad:pData rpos:iCurReadingPos WithData:pChildString];
    
    //child string
    NSRange Range = NSMakeRange( *iCurReadingPos, sizeof(int));
    int iCount=0;
    [pData getBytes:&iCount range:Range];
    *iCurReadingPos += sizeof(int);
    
    for (int i=0; i<iCount; i++) {
        
        /*FractalString *FChild=*/[[FractalString alloc] initWithData:pData
                    WithCurRead:iCurReadingPos WithParent:self WithContainer:pContainer];

//        int m=0;
 //       int iIndex=[pContainer->ArrayPoints SetOb:FChild];
        
//        if(m_iFlags&LINK)
//            [pContainer->m_OperationIndex AddData:iIndex WithData:pPointLink];
//        else
  //          [pContainer->m_OperationIndex AddData:iIndex WithData:pPointCopy];
    }
//======================================================================================
}
//------------------------------------------------------------------------------------------------------
-(void)selfSave:(NSMutableData *)m_pData WithVer:(int)iVersion
{
    switch (iVersion) {
        case 1:
        {
            [self SaveData:m_pData];

            //сохраняем матрицу струны
            [m_pContainer->m_OperationIndex selfSave:m_pData WithData:pValueCopy];
            [m_pContainer->m_OperationIndex selfSave:m_pData WithData:pValueLink];
            [m_pContainer->m_OperationIndex selfSave:m_pData WithData:pEnters];
            [m_pContainer->m_OperationIndex selfSave:m_pData WithData:pExits];
            [m_pContainer->m_OperationIndex selfSave:m_pData WithData:pChildString];
            
            //child string
            InfoArrayValue *InfoStr=(InfoArrayValue *)*pChildString;
            int *StartIndex=(*pChildString)+SIZE_INFO_STRUCT;
            int iCount=InfoStr->mCount;
            
            [m_pData appendBytes:&iCount length:sizeof(int)];
            
            for (int i=0; i<iCount; i++) {
                
                int index=(StartIndex)[i];
                FractalString *FChild=[m_pContainer->ArrayPoints GetIdAtIndex:index];

                [FChild selfSave:m_pData WithVer:iVersion];
            }
            
//            InfoStr=(InfoArrayValue *)pPointLink;
//            StartIndex=(*pPointLink)+sizeof(InfoArrayValue);
//            iCount=InfoStr->mCount;
//            
//            [m_pData appendBytes:&iCount length:sizeof(int)];
//            
//            for (int i=0; i<iCount; i++) {
//                FractalString *FChild=(id)[m_pContainer->ArrayPoints GetDataAtIndex:*StartIndex];
//                
//                [FChild selfSave:m_pData WithVer:iVersion];
//            }
        }
        break;
            
        default:
        break;
    }    
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc
{
    [sNameIcon release];
    
    [strUID release];

    [m_pContainer->m_OperationIndex ReleaseMemory:pValueCopy];
    [m_pContainer->m_OperationIndex ReleaseMemory:pValueLink];
    [m_pContainer->m_OperationIndex ReleaseMemory:pChildString];
//    [m_pContainer->m_OperationIndex ReleaseMemory:pPointLink];
    [m_pContainer->m_OperationIndex ReleaseMemory:pEnters];
    [m_pContainer->m_OperationIndex ReleaseMemory:pExits];
    
    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
@end
