//
//  StringContainer.m
//  FunDreams
//
//  Created by Konstantin Maximov on 15.06.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import "StringContainer.h"
#import "DropBoxMng.h"

@implementation StringContainer
//------------------------------------------------------------------------------------------------------
-(id)init:(id)Parent{
    
    self = [super init];

    if(self){
        
        ArrayPoints = [[FunArrayData alloc] initWithCopasity:100];
        ArrayPoints->iCountInc=1000;

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

//        pDataManager=[[CDataManager alloc] InitWithFileFromRes:@"InfoFile"];
//        [ArrayDumpFiles addObject:pDataManager];

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
-(void)ReLinkDataManager{
    
    for (int i=0; i<[ArrayDumpFiles count]; i++) {

        CDataManager *pDataManager=[ArrayDumpFiles objectAtIndex:i];
        [pDataManager relinkResClient];
    }
}
//------------------------------------------------------------------------------------------------------
-(void)SetTemplateString{

    FractalString *pFStringZero=[[FractalString alloc]
         initWithName:@"Zero" WithParent:nil WithContainer:self  S:iIndexZero F:iIndexZero];

    FractalString *pFStringEditor=[[FractalString alloc]
        initWithName:@"Editor" WithParent:pFStringZero WithContainer:self   S:iIndexZero F:iIndexZero];
///////////////////////////////////////////
    FractalString *pFSCurrentCheck=[[FractalString alloc]
        initWithName:@"CurrentCheck" WithParent:pFStringEditor
        WithContainer:self S:iIndexZero F:iIndexZero];
    
    //для режимов
    [pFSCurrentCheck->ArrayPoints AddData:[ArrayPoints SetData:0]];
    //для текущей полки
    [pFSCurrentCheck->ArrayPoints AddData:[ArrayPoints SetData:1]];
//струны на полке
    FractalString *pFSChelf=[[FractalString alloc]
            initWithName:@"ChelfStirngs" WithParent:pFStringEditor
            WithContainer:self S:iIndexZero F:iIndexZero];    
    
    for(int i=0;i<8;i++){
        NSMutableString *ZeroString = [NSMutableString stringWithString:@"Objects"];

        [pFSChelf->ArrayLinks addObject:ZeroString];
    }
/////
    [[FractalString alloc]
        initWithName:@"DropBox" WithParent:pFStringEditor WithContainer:self S:iIndexZero F:iIndexZero];

    pFStringObjects=[[FractalString alloc]
        initWithName:@"Objects" WithParent:pFStringEditor WithContainer:self S:iIndexZero F:iIndexZero];
    
    TextureContainer *pNum=[m_pObjMng->m_pParent->m_pTextureList objectForKey:@"EmptyPlace.png"];
    pFStringObjects->iIndexIcon=pNum->m_iTextureId;
    

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

    int iX1=[self->ArrayPoints SetData:   0];
    int iX2=[self->ArrayPoints SetData: 480];
    int iY1=[self->ArrayPoints SetData:-320];
    int iY2=[self->ArrayPoints SetData: 320];

    [[FractalString alloc] initWithName:@"X" WithParent:pFStringXY WithContainer:self S:iX1 F:iX2];
    [[FractalString alloc] initWithName:@"Y" WithParent:pFStringXY WithContainer:self S:iY1 F:iY2];

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
    
    NSString *StrRet=outstring;

    return StrRet;
}
//------------------------------------------------------------------------------------------------------
-(void)Synhronize{
    //   [m_pObjMng->m_pDataManager DownLoad];
    //      [m_pDataManager UpLoad];
}
//------------------------------------------------------------------------------------------------------
-(bool)LoadContainer{
    
    CDataManager* pDataCurManager =[ArrayDumpFiles objectAtIndex:0];

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
                
                [ArrayPoints selfLoad:pDataCurManager->m_pDataDmp
                                 rpos:&pDataCurManager->m_iCurReadingPos];
            }
            break;
                
            default:
                Rez=NO;
                break;
        }
    }
    return Rez;
}
//------------------------------------------------------------------------------------------------------
-(void)SaveContainer{

    //версия дампа для сохранения струн
    int iVersion=1;
    
    //mainDump
    CDataManager* pDataCurManager = [ArrayDumpFiles objectAtIndex:0];
    [pDataCurManager Clear];
    [pDataCurManager->m_pDataDmp appendBytes:&iVersion length:sizeof(int)];

    FractalString *pFStringZero = [DicStrings objectForKey:@"Zero"];
    [pFStringZero selfSave:pDataCurManager->m_pDataDmp WithVer:iVersion];
    
    [ArrayPoints selfSave:pDataCurManager->m_pDataDmp];

    [pDataCurManager Save];
}
//------------------------------------------------------------------------------------------------------
-(void)SaveStringToDropBox:(FractalString *)Str Version:(int)iVersion{
    
    CDataManager* pDataCurManager = [ArrayDumpFiles objectAtIndex:1];

    if(Str!=nil && pDataCurManager->m_pDataDmp!=nil){

        [pDataCurManager Clear];
        [Str selfSave:pDataCurManager->m_pDataDmp WithVer:iVersion];
        
        [ArrayPoints selfSave:pDataCurManager->m_pDataDmp];
        [pDataCurManager Save];
    
        [pDataCurManager UpLoadWithName:Str->strUID];
    }
}
//------------------------------------------------------------------------------------------------------
-(void)AddString:(FractalString *)pString{}
//------------------------------------------------------------------------------------------------------
-(void)DelChilds:(FractalString *)strDelChilds{
    
    int iCount=[strDelChilds->aStrings count];
    for (int i=0; i<iCount; i++) {
        
        FractalString *TmpStr=[strDelChilds->aStrings objectAtIndex:0];
        TmpStr->m_iFlagsString &= ONLY_HEAD;
        [self DelString:TmpStr];
    }
}
//------------------------------------------------------------------------------------------------------
-(void)DelString:(FractalString *)strDel{
    
    if(strDel->pParent!=nil){

        int iCount=[strDel->pParent->aStrings count];
        for (int i=0; i<iCount; i++) {
            
            FractalString *TmpStr=[strDel->pParent->aStrings objectAtIndex:i];
            
            if(strDel==TmpStr){//нашли себя в струне парента
                
                while ([TmpStr->aStrings count]>0) {
                    FractalString *TmpShild=[TmpStr->aStrings objectAtIndex:0];
                    [self DelString:TmpShild];
                }
                
                [strDel->pParent->aStrings removeObjectAtIndex:i];
                [DicStrings removeObjectForKey:TmpStr->strUID];
                [strDel release];
                
                break;
            }
        }
    }
    else
    {
        [DicStrings removeObjectForKey:strDel->strUID];
        [strDel release];
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