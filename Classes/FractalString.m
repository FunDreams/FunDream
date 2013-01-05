//
//  FractalString.m
//  FunDreams
//
//  Created by Konstantin Maximov on 28.04.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import "FractalString.h"

#define COUNT_RESERV 100

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
- (void)InitMemory{
    
    pPointCopy=(int **)malloc(sizeof(int));
    pPointLink=(int **)malloc(sizeof(int));
    
    *pPointCopy=(int *)malloc(sizeof(StringValue));
    *pPointLink=(int *)malloc(sizeof(StringValue));
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{

    [self SetFlag:ONLY_IN_MEM];
    
    aStrings = [[NSMutableArray alloc] init];
    ArrayLinks = [[NSMutableArray alloc] init];
    
    ArrayPoints = [[FunArrayDataIndexes alloc] initWithCopasity:10];
    
    [self SetNameIcon:@"none"];

    X=-440;
    Y=170;
}
//------------------------------------------------------------------------------------------------------
- (id)init{
    
    self = [super init];
	if (self != nil)
    {
        [self SetDefault];
    }
    return self;
}
//------------------------------------------------------------------------------------------------------
- (id)initAsCopy:(FractalString *)pStrSource WithParent:(FractalString *)Parent
    WithContainer:(StringContainer *)pContainer WithLevel:(int)iCurLevel WithMaxDeep:(int)iDeep{
    
    self = [super init];
	if (self != nil)
    {
        pParent=Parent;
        if(pParent!=nil){
            [pParent->aStrings addObject:self];
        }
        
        [self InitMemory];
        [self SetDefault];
        
        strUID = [pContainer GetRndName];
        
        [pContainer->DicStrings setObject:self forKey:strUID];
        
        [self SetNameIcon:pStrSource->sNameIcon];
        
        if(iCurLevel<=iDeep){
            
            int iCurLevelTmp=iCurLevel+1;
            
            for (int i=0; i<[pStrSource->aStrings count]; i++) {
                
                FractalString *TmpStr=[pStrSource->aStrings objectAtIndex:i];
                
                [[FractalString alloc] initAsCopy:TmpStr
                        WithParent:self WithContainer:pContainer
                        WithLevel:iCurLevelTmp WithMaxDeep:iDeep];
            }
        }
    }
    
    return self;
}
//------------------------------------------------------------------------------------------------------
- (id)initAsCopy:(FractalString *)pStrSource WithParent:(FractalString *)Parent
   WithContainer:(StringContainer *)pContainer{
    
    self = [super init];
	if (self != nil)
    {
        pParent=Parent;
        if(pParent!=nil){
            [pParent->aStrings addObject:self];
        }

        [self InitMemory];
        [self SetDefault];
        
        strUID = [pContainer GetRndName];
        
        [self SetNameIcon:pStrSource->sNameIcon];

        [pContainer->DicStrings setObject:self forKey:strUID];
        
        for (int i=0; i<[pStrSource->aStrings count]; i++) {
            
            FractalString *TmpStr=[pStrSource->aStrings objectAtIndex:i];
            [[FractalString alloc] initAsCopy:TmpStr 
                WithParent:self WithContainer:pContainer];
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
        pParent=Parent;      
        if(pParent!=nil){
            [pParent->aStrings addObject:self];
        }
        
        NSString *StrRndName = [pContainer GetRndName];
        id TmpId=[pContainer->DicStrings objectForKey:NameString];
        
        if(TmpId==nil){
            strUID = [[NSString alloc] initWithString:NameString];
        }
        else
        {
            strUID = [[NSString alloc] initWithString:StrRndName];
        }

        [self InitMemory];
        [self SetDefault];
                
        [pContainer->DicStrings setObject:self forKey:strUID];
    }

    return self;
}
//------------------------------------------------------------------------------------------------------
- (id)initWithDataAndMerge:(NSMutableData *)pData WithCurRead:(int *)iCurReadingPos
                WithParent:(FractalString *)Parent WithContainer:(StringContainer *)pContainer{

    self = [super init];
	if (self != nil)
    {
        [self InitMemory];
        [self SetDefault];
        
        [self selfLoad:pData ReadPos:iCurReadingPos WithContainer:pContainer];
        
        FractalString *TmpStr=[pContainer->DicStrings objectForKey:strUID];
        
        if(TmpStr!=nil)
            [pContainer DelString:TmpStr];
        
        pParent=Parent;
        if(pParent!=nil){
            [pParent->aStrings addObject:self];
        }

        [pContainer->DicStrings setObject:self forKey:strUID];        
    }
    
    return self;
}
//------------------------------------------------------------------------------------------------------
- (id)initWithData:(NSMutableData *)pData WithCurRead:(int *)iCurReadingPos 
        WithParent:(FractalString *)Parent WithContainer:(StringContainer *)pContainer{
    
    self = [super init];
	if (self != nil)
    {        
        [self InitMemory];
        [self SetDefault];
        
        pParent=Parent;
        [self selfLoad:pData ReadPos:iCurReadingPos WithContainer:pContainer];
        
        [pContainer->DicStrings setObject:self forKey:strUID];
    }
    
    return self;
}
//------------------------------------------------------------------------------------------------------
-(void)SetFlag:(int)iFlag{
    m_iFlagsDropBox &= ~(DEAD_STRING|SYNH_AND_HEAD|SYNH_AND_LOAD|ONLY_IN_MEM);
    m_iFlagsDropBox|=iFlag;
}
//------------------------------------------------------------------------------------------------------
-(void)selfLoadOnlyStructure:(NSMutableData *)pData ReadPos:(int *)iCurReadingPos{
    
    if([pData length]==0)return;
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
    [pData getBytes:&m_iFlagsDropBox range:Range];
    *iCurReadingPos += sizeof(int);
    
    //child string
    Range = NSMakeRange( *iCurReadingPos, sizeof(int));
    int iCount=0;
    [pData getBytes:&iCount range:Range];
    *iCurReadingPos += sizeof(int);
    
    for (int i=0; i<iCount; i++) {
        
        FractalString *FChild=[[FractalString alloc] init];
                               
        [FChild selfLoadOnlyStructure:pData ReadPos:iCurReadingPos];
        FChild->pParent = self;
        
        [aStrings addObject:FChild];
    }
    
//======================================================================================
}
//------------------------------------------------------------------------------------------------------
-(void)selfLoad:(NSMutableData *)pData ReadPos:(int *)iCurReadingPos 
            WithContainer:(StringContainer *)pContainer{
    
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
    //float value
    Range = NSMakeRange( *iCurReadingPos, sizeof(float));
    [pData getBytes:&X range:Range];
    *iCurReadingPos += sizeof(float);
    
    Range = NSMakeRange( *iCurReadingPos, sizeof(float));
    [pData getBytes:&Y range:Range];
    *iCurReadingPos += sizeof(float);

    Range = NSMakeRange( *iCurReadingPos, sizeof(int));
    [pData getBytes:&m_iFlagsDropBox range:Range];
    *iCurReadingPos += sizeof(int);
    
    //Load link string
    Range = NSMakeRange( *iCurReadingPos, sizeof(int));
    int iCountLink=0;
    [pData getBytes:&iCountLink range:Range];
    *iCurReadingPos += sizeof(int);
    
    for (int i=0; i<iCountLink; i++) {
        
        NSRange Range = { *iCurReadingPos, sizeof(int)};
        [pData getBytes:&iLen range:Range];
        *iCurReadingPos += sizeof(int);

        Range = NSMakeRange( *iCurReadingPos, iLen*sizeof(unichar));
        [pData getBytes:ucBuff range:Range];
        *iCurReadingPos += iLen*sizeof(unichar);
        
        sValue = [NSString stringWithCharacters:ucBuff length:iLen];
        NSMutableString *StringInArray = [NSMutableString stringWithString:sValue];
        
        [ArrayLinks addObject:StringInArray];
    }
    
    free(ucBuff);
    
    int ArrayResern[COUNT_RESERV];
    Range = NSMakeRange( *iCurReadingPos, sizeof(ArrayResern));
    [pData getBytes:ArrayResern range:Range];
    *iCurReadingPos += sizeof(ArrayResern);

    //child string
    Range = NSMakeRange( *iCurReadingPos, sizeof(int));
    int iCount=0;
    [pData getBytes:&iCount range:Range];
    *iCurReadingPos += sizeof(int);
    
    for (int i=0; i<iCount; i++) {
        
        FractalString *FChild=[[FractalString alloc] initWithData:pData
                WithCurRead:iCurReadingPos WithParent:self WithContainer:pContainer];
        
        [aStrings addObject:FChild];
    }
    
//======================================================================================
    [ArrayPoints selfLoad:pData rpos:iCurReadingPos];
}
//------------------------------------------------------------------------------------------------------
-(void)selfSaveOnlyStructure:(NSMutableData *)m_pData WithVer:(int)iVersion
    Deep:(int)iDeep MaxDeep:(int)iMaxDeep{
    
    switch (iVersion) {
        case 1:
        {
            //Name
            unichar* ucBuff = (unichar*)calloc(512, sizeof(unichar));
            
            [strUID getCharacters:ucBuff];
            int Len=[strUID length];
            [m_pData appendBytes:&Len length:sizeof(int)];
            [m_pData appendBytes:ucBuff length:Len*sizeof(unichar)];
            
            [sNameIcon getCharacters:ucBuff];
            Len=[sNameIcon length];
            [m_pData appendBytes:&Len length:sizeof(int)];
            [m_pData appendBytes:ucBuff length:Len*sizeof(unichar)];

            free(ucBuff);
            
            //float value
            [m_pData appendBytes:&X length:sizeof(float)];
            [m_pData appendBytes:&Y length:sizeof(float)];
            
            //флаги
            [m_pData appendBytes:&m_iFlagsDropBox length:sizeof(m_iFlagsDropBox)];

            int iCurDeep=iDeep+1;

            //child string
            int iCount=[aStrings count];
            if(iCurDeep>iMaxDeep)iCount=0;

            [m_pData appendBytes:&iCount length:sizeof(int)];
                        
            if(iCurDeep<=iMaxDeep){
                for (int i=0; i<iCount; i++) {
                    FractalString *FChild=[aStrings objectAtIndex:i];
                    [FChild selfSaveOnlyStructure:m_pData WithVer:iVersion
                     Deep:iCurDeep MaxDeep:iMaxDeep];
                }
            }
        }
        break;
            
        default:
            break;
    }
}
//------------------------------------------------------------------------------------------------------
-(void)selfSave:(NSMutableData *)m_pData WithVer:(int)iVersion
{
    switch (iVersion) {
        case 1:
        {
            //Name
            unichar* ucBuff = (unichar*)calloc(512, sizeof(unichar));
            
            [strUID getCharacters:ucBuff];
            int Len=[strUID length];
            [m_pData appendBytes:&Len length:sizeof(int)];
            [m_pData appendBytes:ucBuff length:Len*sizeof(unichar)];

            [sNameIcon getCharacters:ucBuff];
            Len=[sNameIcon length];
            [m_pData appendBytes:&Len length:sizeof(int)];
            [m_pData appendBytes:ucBuff length:Len*sizeof(unichar)];

            //float value
            [m_pData appendBytes:&X length:sizeof(float)];
            [m_pData appendBytes:&Y length:sizeof(float)];

            //флаги
            [m_pData appendBytes:&m_iFlagsDropBox length:sizeof(m_iFlagsDropBox)];

            //link string
            int iCountLink=[ArrayLinks count];
            [m_pData appendBytes:&iCountLink length:sizeof(int)];

            for (int i=0; i<iCountLink; i++) {

                NSMutableString *pString=(NSMutableString *)[ArrayLinks objectAtIndex:i];

                [pString getCharacters:ucBuff];
                Len=[pString length];
                [m_pData appendBytes:&Len length:sizeof(int)];
                [m_pData appendBytes:ucBuff length:Len*sizeof(unichar)];
            }

            free(ucBuff);

            int ArrayResern[COUNT_RESERV];
            [m_pData appendBytes:ArrayResern length:sizeof(ArrayResern)];

            //child string
            int iCount=[aStrings count];
            [m_pData appendBytes:&iCount length:sizeof(int)];

            for (int i=0; i<iCount; i++) {
                FractalString *FChild=[aStrings objectAtIndex:i];
                [FChild selfSave:m_pData WithVer:iVersion];
            }
            
            //сохраняем данные струны
            [ArrayPoints selfSave:m_pData];
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
    [aStrings release];
    [ArrayLinks release];
    [ArrayPoints release];
    
    [strUID release];
    
    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
@end
