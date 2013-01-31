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
        ArrayPoints->iCountInc=100;
        ArrayPoints->pParent=self;

        m_OperationIndex = [[FunArrayDataIndexes alloc] init];
        m_OperationIndex->m_pParent=self;

        DicStrings = [[NSMutableDictionary alloc] init];
        ArrayStrings = [[NSMutableArray alloc] init];

        m_pObjMng=Parent;

#ifdef EDITOR
        ArrayDumpFiles = [[NSMutableArray alloc] init];

        CDataManager *pDataManager=[[CDataManager alloc] InitWithFileFromRes:@"MainDump"];
        [ArrayDumpFiles addObject:pDataManager];

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
    
    FractalString *pStrInfo=[[FractalString alloc]
                             initWithName:@"Info" WithParent:pFParent WithContainer:self
                             WithLink:NO];
    
    [pStrInfo SetNameIcon:@"R.png"];
    pStrInfo->X=-180;
    pStrInfo->Y=-30;
    pStrInfo->TypeInformation=STR_CONTAINER;
    pStrInfo->NameInformation=NAME_K_INFO_WINDOW;

    
    FractalString *pStrIngib=[[FractalString alloc]
                            initWithName:@"StartActive" WithParent:pFParent WithContainer:self
                               WithLink:NO];
    
    [pStrIngib SetNameIcon:@"StartActivity.png"];
    pStrIngib->X=-400;
    pStrIngib->Y=130;
    pStrIngib->TypeInformation=STR_CONTAINER;
    pStrIngib->NameInformation=NAME_K_START;
    
    FractalString *pStrButton=[[FractalString alloc]
                            initWithName:@"Action" WithParent:pFParent WithContainer:self
                                WithLink:NO];

    [pStrButton SetNameIcon:@"ButtonAction.png"];
    pStrButton->X=-300;
    pStrButton->Y=130;
    pStrButton->TypeInformation=STR_CONTAINER;
    pStrButton->NameInformation=NAME_K_BUTTON_ENVENT;


    FractalString *pStrPlus=[[FractalString alloc]
                            initWithName:@"Plus" WithParent:pFParent WithContainer:self
                              WithLink:NO];
    
    [pStrPlus SetNameIcon:@"o_plus.png"];
    pStrPlus->X=-350;
    pStrPlus->Y=50;
    pStrPlus->TypeInformation=STR_OPERATION;
    pStrPlus->NameInformation=NAME_O_PLUS;


    FractalString *pStrVA=[[FractalString alloc]
                        initWithName:@"A" WithParent:pFParent WithContainer:self
                            WithLink:NO];
    
    [pStrVA SetNameIcon:@"A.png"];
    pStrVA->X=-420;
    pStrVA->Y=-30;
    pStrVA->TypeInformation=STR_DATA;
    pStrVA->NameInformation=NAME_V_FLOAT;


    FractalString *pStrVB=[[FractalString alloc]
                           initWithName:@"B" WithParent:pFParent WithContainer:self
                            WithLink:NO];
    
    [pStrVB SetNameIcon:@"B.png"];
    pStrVB->X=-350;
    pStrVB->Y=-70;
    pStrVB->TypeInformation=STR_DATA;
    pStrVB->NameInformation=NAME_V_FLOAT;


    FractalString *pStrVR=[[FractalString alloc]
                           initWithName:@"R" WithParent:pFParent WithContainer:self
                            WithLink:NO];
    
    [pStrVR SetNameIcon:@"R.png"];
    pStrVR->X=-280;
    pStrVR->Y=-30;
    pStrVR->TypeInformation=STR_DATA;
    pStrVR->NameInformation=NAME_V_FLOAT;    
}
//------------------------------------------------------------------------------------------------------
#define MAX_REZERV 200
-(void)InitIndex{
    FractalString *pFStringZero = [self GetString:@"Zero"];
    if(pFStringZero!=nil){
        
        pDeltaTime = [ArrayPoints GetDataAtIndex:2];        
        iIndexMaxSys=MAX_REZERV+2;//202
    }
}
//------------------------------------------------------------------------------------------------------
-(void)SetKernel{
    FractalString *pFStringZero=[[FractalString alloc]
                                 initWithName:@"Zero" WithParent:nil WithContainer:self WithLink:NO];
    pFStringZero->m_iIndex=[ArrayPoints SetOb:pFStringZero];
////////////////////////////////////////////////////////////////////////////////////////////////////    
    //zero point
    int iZeroPoint=[ArrayPoints SetFloat:0.0f];//1
    [ArrayPoints IncDataAtIndex:iZeroPoint];

    //delta time
    int iDeltaTime=[ArrayPoints SetFloat:0.0f];//2
    [ArrayPoints IncDataAtIndex:iDeltaTime];
////////////////////////////////////////////////////////////////////////////////////////////////////
    //резервируем индексы ядра
    for (int i=0; i<MAX_REZERV; i++) {
        int iIndexRezerv=[ArrayPoints SetFloat:0.0f];
        [ArrayPoints IncDataAtIndex:iIndexRezerv];
        iIndexMaxSys=iIndexRezerv;
    }
}
//------------------------------------------------------------------------------------------------------
-(void)SetEditor{//надстройка для редактора

    [self SetKernel];
    
    FractalString *pFStringZero = [self GetString:@"Zero"];
    
    FractalString *pFStringEditor=[[FractalString alloc]
                                   initWithName:@"Editor" WithParent:pFStringZero WithContainer:self
                                    WithLink:NO];
///////////////////////////////////////////
    FractalString *pFSCurrentCheck=[[FractalString alloc]
        initWithName:@"CurrentCheck" WithParent:pFStringEditor
        WithContainer:self WithLink:NO];
    
    //для режимов
    [m_OperationIndex AddData:[ArrayPoints SetInt:0] WithData:pFSCurrentCheck->pValueLink];
    //для текущей полки
    [m_OperationIndex AddData:[ArrayPoints SetInt:0] WithData:pFSCurrentCheck->pValueLink];
//струны на полке
    FractalString *pFSChelf=[[FractalString alloc]
            initWithName:@"ChelfStirngs" WithParent:pFStringEditor
            WithContainer:self WithLink:NO];    
    
    for(int i=0;i<8;i++){//записываем имя струны на полке
        NSMutableString *ZeroString = [NSMutableString stringWithString:@"Objects"];
        
        [m_OperationIndex AddData:[ArrayPoints SetName:ZeroString] WithData:pFSChelf->pValueLink];
    }
/////
    [[FractalString alloc]
        initWithName:@"DropBox" WithParent:pFStringEditor WithContainer:self WithLink:NO];

    pFStringObjects=[[FractalString alloc]
        initWithName:@"Objects" WithParent:pFStringEditor WithContainer:self WithLink:NO];
    
    [pFStringObjects SetNameIcon:@"EmptyPlace.png"];

    //добалсяем первичные струны
    [self AddSmallCube:pFStringObjects];
}
//------------------------------------------------------------------------------------------------------
-(void)ConnectStart:(FractalString *)StartStr End:(FractalString *)EndStr
{
//    int **pEnters;
//    int **pExits;
}
//------------------------------------------------------------------------------------------------------
-(void)AddObject{
    
    [[FractalString alloc] initWithName:@"Prop" WithParent:pFStringObjects
                          WithContainer:self WithLink:NO];
}
//------------------------------------------------------------------------------------------------------
-(NSString *)GetRndName{
        
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

    return Rez;
}
//------------------------------------------------------------------------------------------------------
-(void)SaveContainer{
    
    //версия дампа для сохранения струн
    int iVersion=VERSTION;
    
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
-(void)CopyData:(int **)Data DestData:(int **)DestData dic:(NSMutableDictionary *)pDic
    SourceContainer:(StringContainer*)SourceContainer{
    
    int *StartData=((*Data)+SIZE_INFO_STRUCT);
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*Data);
    int iCount=InfoStr->mCount;
    
    for (int i=0; i<iCount; i++) {
        
        int iIndexSource=StartData[i];
        
        NSNumber *pNumSource = [NSNumber numberWithInt:iIndexSource];
        NSNumber *pNumDest = [pDic objectForKey:pNumSource];
        
        if(pNumDest==nil){
            if(iIndexSource>iIndexMaxSys){
                
                float *pValue=SourceContainer->ArrayPoints->pData+iIndexSource;
                BYTE *pType=SourceContainer->ArrayPoints->pType+iIndexSource;
                
                int iIndexDest=[ArrayPoints GetFree];
                
                float *pValueDest=ArrayPoints->pData+iIndexDest;
                BYTE *pTypeDest=ArrayPoints->pType+iIndexDest;
                
                *pValueDest=*pValue;
                *pTypeDest=*pType;
                
                [m_OperationIndex AddData:iIndexDest WithData:DestData];
                
                NSNumber *pNumSource = [NSNumber numberWithInt:iIndexSource];
                NSNumber *pNumDest = [NSNumber numberWithInt:iIndexDest];
                
                [m_OperationIndex AddData:iIndexDest WithData:DestData];
                
                [pDic setObject:pNumDest forKey:pNumSource];
            }
        }
        else
        {
            int iIndexDest=[pNumDest intValue];
            int *pCountDest=ArrayPoints->pDataInt+iIndexDest;
            (*pCountDest)++;
        }
    }
}
//------------------------------------------------------------------------------------------------------
-(void)DeepString:(FractalString *)SourceStr dic:(NSMutableDictionary *)pDic
  SourceContainer:(StringContainer*)SourceContainer parent:(FractalString *)pParent{
//-------------------------------------------------------------------------------------------
    FractalString *pDestStr = [[FractalString alloc] init:self];
    
    pDestStr->TypeInformation=SourceStr->TypeInformation;
    pDestStr->NameInformation=SourceStr->NameInformation;
    
    [pDestStr->strUID release];
    pDestStr->strUID = [[NSString alloc] initWithString:SourceStr->strUID];
    [pDestStr->sNameIcon release];
    pDestStr->sNameIcon = [[NSString alloc] initWithString:SourceStr->sNameIcon];
    
    pDestStr->X=SourceStr->X;
    pDestStr->Y=SourceStr->Y;
    pDestStr->m_iFlags=SourceStr->m_iFlags;
    
    [pDestStr SetParent:pParent];
    [DicStrings setObject:pDestStr forKey:pDestStr->strUID];
//-------------------------------------------------------------------------------------------
    [self CopyData:SourceStr->pValueCopy DestData:pDestStr->pValueCopy
               dic:pDic SourceContainer:SourceContainer];
    [self CopyData:SourceStr->pValueLink DestData:pDestStr->pValueLink
               dic:pDic SourceContainer:SourceContainer];

    [self CopyData:SourceStr->pEnters DestData:pDestStr->pEnters
               dic:pDic SourceContainer:SourceContainer];
    [self CopyData:SourceStr->pExits  DestData:pDestStr->pExits
               dic:pDic SourceContainer:SourceContainer];
//-------------------------------------------------------------------------------------------
    int *Data=(*SourceStr->pChildString);
    InfoArrayValue *InfoStr=(InfoArrayValue *)(Data);

    for(int i=0;i<InfoStr->mCount;i++){
        
        int index=(Data+SIZE_INFO_STRUCT)[i];
        FractalString *pFrStr=[SourceContainer->ArrayPoints
                               GetIdAtIndex:index];
        
        [self DeepString:pFrStr dic:pDic
            SourceContainer:(StringContainer*)SourceContainer parent:pDestStr];
    }
}
//------------------------------------------------------------------------------------------------------
//копируем струну в другое пространство (перекодирование имён параметров)
-(void)CopyStrFrom:(StringContainer*)SourceContainer WithId:(FractalString *)SourceStr{

    NSMutableDictionary *pDicRename=[[NSMutableDictionary alloc] init];

    [self DeepString:SourceStr dic:pDicRename
            SourceContainer:(StringContainer*)SourceContainer parent:nil];

    [pDicRename release];
}
//------------------------------------------------------------------------------------------------------
-(void)DelChilds:(FractalString *)strDelChilds{
    
    int **Data=(strDelChilds->pChildString);
    int *StartData=((*Data)+SIZE_INFO_STRUCT);
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*Data);
    int iCount=InfoStr->mCount;

    for (int i=0; i<iCount; i++) {
        
        int index=(StartData)[0];
        FractalString *TmpStr=[m_pObjMng->pStringContainer->ArrayPoints
                               GetIdAtIndex:index];

        [self DelChilds:TmpStr];
        [m_OperationIndex RemoveDataAtIndex:0 WithData:Data];
        
        [DicStrings removeObjectForKey:TmpStr->strUID];
        
        [ArrayPoints DecDataAtIndex:TmpStr->m_iIndex];
    }
}
//------------------------------------------------------------------------------------------------------
-(void)DelString:(FractalString *)strDel{
    
    if(strDel!=nil){
        if(strDel->pParent!=nil){

            int **Data=(strDel->pParent->pChildString);
            InfoArrayValue *InfoStr=(InfoArrayValue *)(*Data);
            int iCount=InfoStr->mCount;
            int *StartData=((*Data)+SIZE_INFO_STRUCT);

            for (int i=0; i<iCount; i++){

                int index=(StartData)[i];
                FractalString *pFrStr=[m_pObjMng->pStringContainer->ArrayPoints
                                       GetIdAtIndex:index];
                
                if(strDel->m_iIndex==pFrStr->m_iIndex){//нашли себя в струне парента
                    
                    [self DelChilds:pFrStr];
                    
                    [m_OperationIndex RemoveDataAtIndex:i WithData:(Data)];
                    
                    [DicStrings removeObjectForKey:pFrStr->strUID];
                    [ArrayPoints DecDataAtIndex:pFrStr->m_iIndex];
                    
                    goto END;
                }
            }
END:;
        }
        else
        {
            [DicStrings removeObjectForKey:strDel->strUID];
            [strDel release];
        }
    }
}
//------------------------------------------------------------------------------------------------------
-(id)GetString:(NSString *)strName{

    return [DicStrings objectForKey:strName];
}
//------------------------------------------------------------------------------------------------------
-(void)Update:(FractalString *)StartString{
    
    if(StartString==nil)return;
    //stack
    FractalString *pCurString=StartString;
    
LOOP:
    
    switch (pCurString->TypeInformation)
    {
        case STR_OPERATION:
            //update
            break;
            
        case STR_COMPLEX:
            break;
            
        default:
            break;
    }
    
    //if next operation goto loop
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc
{
    [DicStrings release];

    [ArrayPoints release];
    [m_OperationIndex release];
    
    for (CDataManager *pManager in ArrayDumpFiles) {
        [pManager release];
    }
    [ArrayDumpFiles release];
    
    [ArrayStrings release];
            
    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
@end