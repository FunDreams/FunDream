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
- (void)SetDefault{
    
    aStrings = [[NSMutableArray alloc] init];
    aStages = [[NSMutableArray alloc] init];
    
    ArrayPoints = [[FunArrayDataIndexes alloc] initWithCopasity:1000];

    X=-440;
    Y=170;
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

        [self SetDefault];
        [self SetLimmitStringS:pStrSource->S F:pStrSource->F];
                
        strUID = [[NSString alloc] initWithString:[pContainer GetRndName]];
        strName = [[NSString alloc] initWithString:pStrSource->strName];

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
     WithContainer:(StringContainer *)pContainer S:(int)iS F:(int)iF{

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
            strName = [[NSString alloc] initWithString:NameString];
            strUID = [[NSString alloc] initWithString:NameString];
        }
        else
        {
            strName = [[NSString alloc] initWithString:StrRndName];
            strUID = [[NSString alloc] initWithString:StrRndName];
        }

        [self SetDefault];
        [self SetLimmitStringS:iS F:iF];
                
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
        pParent=Parent;
        
        [self SetDefault];
        
        [self selfLoad:pData ReadPos:iCurReadingPos WithContainer:pContainer];
        [pContainer->DicStrings setObject:self forKey:strUID];
    }
    
    return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetLimmitStringS:(int)iS F:(int)iF{
    
    S=iS;
    F=iF;
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
    strName = [[NSString alloc] initWithString:sValue];
//---------------------------------------------------------------------------------
    free(ucBuff);
    
    //float value
    Range = NSMakeRange( *iCurReadingPos, sizeof(int));
    [pData getBytes:&S range:Range];
    *iCurReadingPos += sizeof(int);

    Range = NSMakeRange( *iCurReadingPos, sizeof(int));
    [pData getBytes:&F range:Range];
    *iCurReadingPos += sizeof(int);

    Range = NSMakeRange( *iCurReadingPos, sizeof(int));
    [pData getBytes:&iIndexIcon range:Range];
    *iCurReadingPos += sizeof(int);

    Range = NSMakeRange( *iCurReadingPos, sizeof(int));
    [pData getBytes:&m_iDeep range:Range];
    *iCurReadingPos += sizeof(int);

    Range = NSMakeRange( *iCurReadingPos, sizeof(float));
    [pData getBytes:&X range:Range];
    *iCurReadingPos += sizeof(float);
    
    Range = NSMakeRange( *iCurReadingPos, sizeof(float));
    [pData getBytes:&Y range:Range];
    *iCurReadingPos += sizeof(float);

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

            [strName getCharacters:ucBuff];
            Len=[strName length];
            [m_pData appendBytes:&Len length:sizeof(int)];
            [m_pData appendBytes:ucBuff length:Len*sizeof(unichar)];

            free(ucBuff);

            //float value
            [m_pData appendBytes:&S length:sizeof(int)];
            [m_pData appendBytes:&F length:sizeof(int)];

            [m_pData appendBytes:&iIndexIcon length:sizeof(int)];
            [m_pData appendBytes:&m_iDeep length:sizeof(int)];

            [m_pData appendBytes:&X length:sizeof(float)];
            [m_pData appendBytes:&Y length:sizeof(float)];
            
            //child string
            int iCount=[aStrings count];
            [m_pData appendBytes:&iCount length:sizeof(int)];
            
            for (int i=0; i<iCount; i++) {
                FractalString *FChild=[aStrings objectAtIndex:i];
                [FChild selfSave:m_pData WithVer:iVersion];
            }
        }
        break;
            
        default:
        break;
    }    
}
//------------------------------------------------------------------------------------------------------
-(void)UpDate:(float)fDelta{
    
//    switch (m_iType) {
//        case tLine:
//            
            for (FractalString *pFStringChild in aStrings){
                [pFStringChild UpDate:fDelta];
            
            ////mirror
            }
//
//            break;
//            
//        default:
//            break;
//    }
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc
{

    [aStages release];
    [aStrings release];
    [ArrayPoints release];
    
    [strUID release];
    [strName release];
    
    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
@end
