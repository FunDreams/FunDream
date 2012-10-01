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
        
        ArrayPoints = [[FunArrayData alloc] initWithCopasity:100];
        ArrayPoints->iCountInc=1;

        DicStrings = [[NSMutableDictionary alloc] init];
        ArrayStrings = [[NSMutableArray alloc] init];
        ArrayActiveStrings = [[NSMutableArray alloc] init];
        
        m_pObjMng=Parent;

        iIndexZero=[self->ArrayPoints SetData:0.0f];

#ifdef EDITOR

        ArrayDumpFiles = [[NSMutableArray alloc] init];

        CDataManager *pDataManager=[[CDataManager alloc] InitWithFileFromRes:@"MainDump"];
        [ArrayDumpFiles addObject:pDataManager];

        pDataManager=[[CDataManager alloc] InitWithFileFromRes:@"Upload"];
        [ArrayDumpFiles addObject:pDataManager];

        pDataManager=[[CDataManager alloc] InitWithFileFromRes:@"Download"];
        [ArrayDumpFiles addObject:pDataManager];
        
//        for (int i=0; i<10; i++) {
//            NSString *strNameContainer = [[NSString alloc]
//                    initWithFormat:@"FractalDump%d",i];
//
//            CDataManager *pDataManager=[[CDataManager alloc] InitWithFileFromRes:strNameContainer];
//
//            [ArrayDumpFiles addObject:pDataManager];
//            [strNameContainer release];
//        }

        m_iCurFile=0;
        pDataCurManagerTmp=[ArrayDumpFiles objectAtIndex:m_iCurFile];
#endif
    }
    return self;
}
//------------------------------------------------------------------------------------------------------
-(void)SetTemplateString{

    FractalString *pFStringZero=[[FractalString alloc]
         initWithName:@"Zero" WithParent:nil WithContainer:self  S:iIndexZero F:iIndexZero];

    FractalString *pFStringEditor=[[FractalString alloc]
        initWithName:@"Editor" WithParent:pFStringZero WithContainer:self   S:iIndexZero F:iIndexZero];
///////////////////////////////////////////
    pFStringObjects=[[FractalString alloc]
        initWithName:@"DropBox" WithParent:pFStringEditor WithContainer:self S:iIndexZero F:iIndexZero];

    pFStringObjects=[[FractalString alloc]
        initWithName:@"Objects" WithParent:pFStringEditor WithContainer:self S:iIndexZero F:iIndexZero];

    [[FractalString alloc]
            initWithName:@"Ob1" WithParent:pFStringObjects WithContainer:self  S:iIndexZero F:iIndexZero];
    [[FractalString alloc]
            initWithName:@"Ob2" WithParent:pFStringObjects WithContainer:self  S:iIndexZero F:iIndexZero];
    [[FractalString alloc]
            initWithName:@"Ob3" WithParent:pFStringObjects WithContainer:self  S:iIndexZero F:iIndexZero];

    FractalString *pFStringProp=[[FractalString alloc]
        initWithName:@"Prop" WithParent:pFStringEditor WithContainer:self S:iIndexZero F:iIndexZero];
//------------------------------------------------------------------------------------------------------
    FractalString *pFStringXY=[[FractalString alloc]
        initWithName:@"XY" WithParent:pFStringProp WithContainer:self  S:iIndexZero F:iIndexZero];

    int iX1=[self->ArrayPoints SetData:0];
    int iX2=[self->ArrayPoints SetData:480];
    int iY1=[self->ArrayPoints SetData:-320];
    int iY2=[self->ArrayPoints SetData:320];

    [[FractalString alloc] initWithName:@"X" WithParent:pFStringXY WithContainer:self
                S:iX1 F:iX2];

    [[FractalString alloc] initWithName:@"Y" WithParent:pFStringXY WithContainer:self
                S:iY1 F:iY2];

    FractalString *pFStringColor=[[FractalString alloc]
                    initWithName:@"Color" WithParent:pFStringProp WithContainer:self
                                  S:iIndexZero F:iIndexZero];

    [[FractalString alloc] initWithName:@"R" WithParent:pFStringColor
                          WithContainer:self  S:iIndexZero F:iIndexZero];

    [[FractalString alloc] initWithName:@"G" WithParent:pFStringColor
                          WithContainer:self  S:iIndexZero F:iIndexZero];

    [[FractalString alloc] initWithName:@"B" WithParent:pFStringColor
                          WithContainer:self  S:iIndexZero F:iIndexZero];

    [[FractalString alloc] initWithName:@"A" WithParent:pFStringColor
                          WithContainer:self  S:iIndexZero F:iIndexZero];

    FractalString *pFStringT=[[FractalString alloc]
        initWithName:@"Timer" WithParent:pFStringProp WithContainer:self
                              S:iIndexZero F:iIndexZero];

    [[FractalString alloc] initWithName:@"T" WithParent:pFStringT WithContainer:self
                                      S:iIndexZero F:iIndexZero];
//------------------------------------------------------------------------------------------------------
}
//------------------------------------------------------------------------------------------------------
-(void)AddObject{
    
    [[FractalString alloc] initWithName:@"Prop" WithParent:pFStringObjects
                          WithContainer:self  S:iIndexZero F:iIndexZero];
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
-(bool)LoadContainer{
    
    CDataManager* pDataCurManager =[ArrayDumpFiles objectAtIndex:m_iCurFile];

    bool Rez=[pDataCurManager Load];
    
    [DicStrings removeAllObjects];

    if([pDataCurManager->m_pDataDmp length]==0)Rez=false;
        
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
    return Rez;
}
//------------------------------------------------------------------------------------------------------
-(void)SaveContainer{

    //версия дампа для сохранения струн
    int iVersion=1;
    
    CDataManager* pDataCurManager = [ArrayDumpFiles objectAtIndex:m_iCurFile];
    
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
        if(strDel==TmpStr){//нашли себя в струне парента
            
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
    [ArrayPoints release];
    
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