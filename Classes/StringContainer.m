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
        ArrayPoints->pParent=self;

        DicStrings = [[NSMutableDictionary alloc] init];
        ArrayStrings = [[NSMutableArray alloc] init];
        ArrayActiveStrings = [[NSMutableArray alloc] init];
        
        m_pObjMng=Parent;

        iIndexZero=[self->ArrayPoints SetFloat:0.0f];

#ifdef EDITOR

        ArrayDumpFiles = [[NSMutableArray alloc] init];

        CDataManager *pDataManager=[[CDataManager alloc] InitWithFileFromRes:@"MainDump"];
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
-(void)AddSmallCube:(FractalString *)pFParent{
    
    FractalString *pStrIngib=[[FractalString alloc]
                            initWithName:@"Activety" WithParent:pFParent WithContainer:self];
    
    [pStrIngib SetNameIcon:@"StartActivity.png"];
    pStrIngib->X=-400;
    pStrIngib->Y=130;
    pStrIngib->TypeInformation=STR_CONTAINER;
    pStrIngib->NameInformation=NAME_K_START;
    
    FractalString *pStrButton=[[FractalString alloc]
                            initWithName:@"Action" WithParent:pFParent WithContainer:self];

    [pStrButton SetNameIcon:@"ButtonAction.png"];
    pStrButton->X=-300;
    pStrButton->Y=130;
    pStrButton->TypeInformation=STR_CONTAINER;
    pStrButton->NameInformation=NAME_K_BUTTON_ENVENT;


    FractalString *pStrPlus=[[FractalString alloc]
                               initWithName:@"Plus" WithParent:pFParent WithContainer:self];
    
    [pStrPlus SetNameIcon:@"o_plus.png"];
    pStrPlus->X=-350;
    pStrPlus->Y=50;
    pStrPlus->TypeInformation=STR_OPERATION;
    pStrPlus->NameInformation=NAME_O_PLUS;


    FractalString *pStrVA=[[FractalString alloc]
                               initWithName:@"A" WithParent:pFParent WithContainer:self];
    
    [pStrVA SetNameIcon:@"A.png"];
    pStrVA->X=-420;
    pStrVA->Y=-30;
    pStrVA->TypeInformation=STR_DATA;
    pStrVA->NameInformation=NAME_V_FLOAT;


    FractalString *pStrVB=[[FractalString alloc]
                           initWithName:@"B" WithParent:pFParent WithContainer:self];
    
    [pStrVB SetNameIcon:@"B.png"];
    pStrVB->X=-350;
    pStrVB->Y=-70;
    pStrVB->TypeInformation=STR_DATA;
    pStrVB->NameInformation=NAME_V_FLOAT;


    FractalString *pStrVR=[[FractalString alloc]
                           initWithName:@"R" WithParent:pFParent WithContainer:self];
    
    [pStrVR SetNameIcon:@"R.png"];
    pStrVR->X=-280;
    pStrVR->Y=-30;
    pStrVR->TypeInformation=STR_DATA;
    pStrVR->NameInformation=NAME_V_FLOAT;
}
//------------------------------------------------------------------------------------------------------
-(void)SetTemplateString{

    FractalString *pFStringZero=[[FractalString alloc]
         initWithName:@"Zero" WithParent:nil WithContainer:self];

    FractalString *pFStringEditor=[[FractalString alloc]
                                   initWithName:@"Editor" WithParent:pFStringZero WithContainer:self];
///////////////////////////////////////////
    //test
    
//    int Index1=[ArrayPoints SetFloat:3.65f];
//    int Index2=[ArrayPoints SetInt:81];
//    
//    NSMutableString *strMutString=[NSMutableString stringWithString:@"dfdf"];
//    int Index3=[ArrayPoints SetName:strMutString];
//    int Index4=[ArrayPoints SetOb:pFStringZero];
    

    FractalString *pFSCurrentCheck=[[FractalString alloc]
        initWithName:@"CurrentCheck" WithParent:pFStringEditor
        WithContainer:self];
    
    //для режимов
    [pFSCurrentCheck->ArrayPoints AddData:[ArrayPoints SetFloat:0]];
    //для текущей полки
    [pFSCurrentCheck->ArrayPoints AddData:[ArrayPoints SetFloat:0]];
//струны на полке
    FractalString *pFSChelf=[[FractalString alloc]
            initWithName:@"ChelfStirngs" WithParent:pFStringEditor
            WithContainer:self];    
    
    for(int i=0;i<8;i++){//записываем имя струны на полке
        NSMutableString *ZeroString = [NSMutableString stringWithString:@"Objects"];
        [pFSChelf->ArrayLinks addObject:ZeroString];
    }
/////
    [[FractalString alloc]
        initWithName:@"DropBox" WithParent:pFStringEditor WithContainer:self];

    pFStringObjects=[[FractalString alloc]
        initWithName:@"Objects" WithParent:pFStringEditor WithContainer:self];
    
    [pFStringObjects SetNameIcon:@"EmptyPlace.png"];

    [self AddSmallCube:pFStringObjects];    

    FractalString *pFStringProp=[[FractalString alloc]
        initWithName:@"Prop" WithParent:pFStringEditor WithContainer:self];
//------------------------------------------------------------------------------------------------------
    FractalString *pFStringXY=[[FractalString alloc]
        initWithName:@"XY" WithParent:pFStringProp WithContainer:self];

    [[FractalString alloc] initWithName:@"X" WithParent:pFStringXY WithContainer:self];
    [[FractalString alloc] initWithName:@"Y" WithParent:pFStringXY WithContainer:self];

    FractalString *pFStringColor=[[FractalString alloc]
                    initWithName:@"Color" WithParent:pFStringProp WithContainer:self];

    [[FractalString alloc] initWithName:@"R" WithParent:pFStringColor
                          WithContainer:self];

    [[FractalString alloc] initWithName:@"G" WithParent:pFStringColor
                          WithContainer:self];

    [[FractalString alloc] initWithName:@"B" WithParent:pFStringColor
                          WithContainer:self];

    [[FractalString alloc] initWithName:@"A" WithParent:pFStringColor
                          WithContainer:self];

    FractalString *pFStringT=[[FractalString alloc]
        initWithName:@"Timer" WithParent:pFStringProp WithContainer:self];

    [[FractalString alloc] initWithName:@"T" WithParent:pFStringT WithContainer:self];
//------------------------------------------------------------------------------------------------------
}
//------------------------------------------------------------------------------------------------------
-(void)AddObject{
    
    [[FractalString alloc] initWithName:@"Prop" WithParent:pFStringObjects
                          WithContainer:self];
}
//------------------------------------------------------------------------------------------------------
-(NSString *)GetRndName{
    
//    CFUUIDRef theUUID = CFUUIDCreate(NULL);
//    CFStringRef outstring = CFUUIDCreateString(NULL, theUUID);
//    CFRelease(theUUID);
//    return [(NSString *)outstring autorelease];
    
    NSString *outstring = nil;
    NSString *allLetters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890";

repeate:
    
    outstring = @"";

    for (int ii=0; ii<20; ii++) {
        outstring = [outstring stringByAppendingString:[allLetters substringWithRange:[allLetters rangeOfComposedCharacterSequenceAtIndex:RND%[allLetters length]]]];
    }

    id TmpId=[DicStrings objectForKey:outstring];
    if(TmpId!=nil){
        goto repeate;
    }
    
    NSString *StrRet=[NSString stringWithString:outstring];

    return [StrRet retain];
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
    
//    float *ddd=(float *)[ArrayPoints GetDataAtIndex:1];
//    int *eddd=(int *)[ArrayPoints GetDataAtIndex:2];
//    
//    id TmpStr = [ArrayPoints GetIdAtIndex:3];
//    NSMutableString *Mstr;
//    if(TmpStr!=nil)
//        Mstr=[NSMutableString stringWithString:[ArrayPoints GetIdAtIndex:3]];
//    
//    FractalString *fStr = [ArrayPoints GetIdAtIndex:4];
//
//    int tmpd=[ArrayPoints GetIncAtIndex:1];
//    tmpd=[ArrayPoints GetIncAtIndex:2];
//    tmpd=[ArrayPoints GetIncAtIndex:3];
//    tmpd=[ArrayPoints GetIncAtIndex:4];
//
//    unsigned char tddmpd=[ArrayPoints GetTypeAtIndex:1];
//    tddmpd=[ArrayPoints GetTypeAtIndex:2];
//    tddmpd=[ArrayPoints GetTypeAtIndex:3];
//    tddmpd=[ArrayPoints GetTypeAtIndex:4];

    return Rez;
}
//------------------------------------------------------------------------------------------------------
-(void)SaveContainer{

    return;
    
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
-(void)AddString:(FractalString *)pString{}
//------------------------------------------------------------------------------------------------------
-(void)DelChilds:(FractalString *)strDelChilds{
    
    int iCount=[strDelChilds->aStrings count];
    for (int i=0; i<iCount; i++) {
        
        FractalString *TmpStr=[strDelChilds->aStrings objectAtIndex:0];
        [self DelString:TmpStr];
    }
    
    [strDelChilds SetFlag:SYNH_AND_HEAD];
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
-(void)Update{
    
    for (NSMutableArray *Arr in ArrayActiveStrings){
        for (FractalString *pFString in Arr){

            //    switch (m_iType) {
            //        case tLine:
            //
            //           for (FractalString *pFStringChild in aStrings){
            //             [pFStringChild UpDate:fDelta];
            ////mirror
            //        }
            //            break;
            //            
            //        default:
            //            break;
            //    }

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