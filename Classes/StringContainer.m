//
//  StringContainer.m
//  FunDreams
//
//  Created by Konstantin Maximov on 15.06.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import "StringContainer.h"

@implementation StringContainer
//------------------------------------------------------------------------------------------------------
-(id)init:(id)Parent{
    
    self = [super init];

    if(self){
        
        DicStrings = [[NSMutableDictionary alloc] init];
        ArrayStrings = [[NSMutableArray alloc] init];
        ArrayActiveStrings = [[NSMutableArray alloc] init];
        
        m_pObjMng=Parent;
        
        [self SetTemplateString];
        
#ifdef DEBUG
        
        ArrayDumpFiles = [[NSMutableArray alloc] init];
                                 
        for (int i=0; i<10; i++) {
            NSString *strNameContainer = [[NSString alloc]
                    initWithFormat:@"FractalDump%d",i];
            
            CDataManager *pDataManager = [[CDataManager alloc] InitWithFileFromRes:strNameContainer];
            // [m_pDataManager initDropBox];
            
            [ArrayDumpFiles addObject:pDataManager];
            [strNameContainer release];
        }
        
#endif
    }
    return self;
}
//------------------------------------------------------------------------------------------------------
-(void)SetTemplateString{

    FractalString *pFStringZero=[[FractalString alloc] 
                    initWithName:@"Zero" WithParent:nil WithContainer:self];

    FractalString *pFStringEditor=[[FractalString alloc]
                    initWithName:@"Editor" WithParent:pFStringZero WithContainer:self];
///////////////////////////////////////////
    pFStringObjects=[[FractalString alloc]
                     initWithName:@"Object" WithParent:pFStringEditor WithContainer:self];
    
    FractalString *pFStringProp=[[FractalString alloc]
                    initWithName:@"Prop" WithParent:pFStringEditor WithContainer:self];    
//------------------------------------------------------------------------------------------------------
    FractalString *pFStringXY=[[FractalString alloc]
                    initWithName:@"XY" WithParent:pFStringProp WithContainer:self];
    
    [[FractalString alloc] initWithName:@"X" WithParent:pFStringXY WithContainer:self];
    [[FractalString alloc] initWithName:@"Y" WithParent:pFStringXY WithContainer:self];
    
    FractalString *pFStringColor=[[FractalString alloc]
                    initWithName:@"Color" WithParent:pFStringProp WithContainer:self];

    [[FractalString alloc] initWithName:@"R" WithParent:pFStringColor WithContainer:self];
    [[FractalString alloc] initWithName:@"G" WithParent:pFStringColor WithContainer:self];
    [[FractalString alloc] initWithName:@"B" WithParent:pFStringColor WithContainer:self];
    [[FractalString alloc] initWithName:@"A" WithParent:pFStringColor WithContainer:self];

    FractalString *pFStringT=[[FractalString alloc]
                    initWithName:@"Timer" WithParent:pFStringProp WithContainer:self];

    [[FractalString alloc] initWithName:@"T" WithParent:pFStringT WithContainer:self];
//------------------------------------------------------------------------------------------------------
}
//------------------------------------------------------------------------------------------------------
-(void)AddObject{
    
    [[FractalString alloc] initWithName:@"Prop" WithParent:pFStringObjects WithContainer:self];
}
//------------------------------------------------------------------------------------------------------
-(NSString *)GetRndName{

    NSString *outstring = nil;
    NSString *allLetters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890";

repeate:
    
    outstring = @"";

    for (int ii=0; ii<8; ii++) {
        outstring = [outstring stringByAppendingString:[allLetters substringWithRange:[allLetters rangeOfComposedCharacterSequenceAtIndex:RND%[allLetters length]]]];
    }

    id TmpId=[DicStrings objectForKey:outstring];
    if(TmpId!=nil){
        goto repeate;
    }

    return outstring;
}
//------------------------------------------------------------------------------------------------------
-(void)Synhronize{
    //   [m_pObjMng->m_pDataManager DownLoad];
    //      [m_pDataManager UpLoad];
}
//------------------------------------------------------------------------------------------------------
-(void)LoadContainer{
    
    CDataManager* pDataCurManager =[ArrayDumpFiles objectAtIndex:m_iCurFile];

    [pDataCurManager Load];
    
    [DicStrings removeAllObjects];

    if([pDataCurManager->m_pDataDmp length]!=0){
        
        int iLenVersion = [pDataCurManager GetIntValue];

        switch (iLenVersion) {
            case 1:
            {
                [[FractalString alloc] initWithData:pDataCurManager->m_pDataDmp
                            WithCurRead:&pDataCurManager->m_iCurReadingPos
                                         WithParent:nil WithContainer:self];
            }
            break;
                
            default:
                break;
        }
    }
}
//------------------------------------------------------------------------------------------------------
-(void)SaveContainer{

    //версия дампа для сохранения струн
    int iVersion=1;
    
    CDataManager* pDataCurManager =[ArrayDumpFiles objectAtIndex:m_iCurFile];
    
    if(pDataCurManager->m_pDataDmp!=nil)
    {
        [pDataCurManager Clear];
        [pDataCurManager->m_pDataDmp appendBytes:&iVersion length:sizeof(int)];

        FractalString *pFStringZero = [DicStrings objectForKey:@"Zero"];

        if(pFStringZero!=nil)
            [pFStringZero selfSave:pDataCurManager->m_pDataDmp WithVer:iVersion];
    
        [pDataCurManager Save];
    }
}
//------------------------------------------------------------------------------------------------------
-(void)AddString:(FractalString *)pString{}
//------------------------------------------------------------------------------------------------------
-(void)DelString:(FractalString *)strDel{
    
    int iCount=[strDel->pParent->aStrings count];
    for (int i=0; i<iCount; i++) {
        
        FractalString *TmpStr=[strDel->pParent->aStrings objectAtIndex:i];
        if(strDel==TmpStr){//нашли в струне парента
            
            int iCountTmp=[TmpStr->aStrings count];
            for (int j=0; j<iCountTmp; j++) {
                FractalString *TmpShild=[TmpStr->aStrings objectAtIndex:0];
                [self DelString:TmpShild];
            }
            
            [strDel->pParent->aStrings removeObjectAtIndex:i];
            [DicStrings removeObjectForKey:TmpStr->strUID];
            [TmpStr release];
            
            break;
        }
    }
}
//------------------------------------------------------------------------------------------------------
-(id)GetString:(NSString *)strName{
    
    return [DicStrings objectForKey:strName];
}
//------------------------------------------------------------------------------------------------------
-(void)Update:(float)fDelta{
    for (NSMutableArray *Arr in ArrayActiveStrings) {
        for (FractalString *pFString in Arr) {

            [pFString UpDate:fDelta];
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc
{
    for (CDataManager *pManager in ArrayDumpFiles) {
        [pManager release];
    }
    [ArrayDumpFiles release];
    
    [ArrayStrings release];
    [ArrayActiveStrings release];
    
    NSEnumerator *enumeratorObjects = [DicStrings objectEnumerator];
    FractalString *pFString;
    
    while ((pFString = [enumeratorObjects nextObject])) {
        [pFString release];
    }
    
    [DicStrings release];
    
    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
@end