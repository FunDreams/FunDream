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
    MATRIXcell *pMatrObject=[ArrayPoints GetMatrixAtIndex:pFParent->m_iIndex];
    
//    FractalString *pStrTest=[[FractalString alloc]
//                              initWithName:@"test" WithParent:pFParent WithContainer:self];
//    
//    [pStrTest SetNameIcon:@"A.png"];
//    pStrTest->X=-420;
//    pStrTest->Y=-30;
//    
//    pStrTest->m_iIndex=[ArrayPoints SetFloat:44.56];
//    [m_OperationIndex AddData:pStrTest->m_iIndex WithData:pMatrObject->pValueCopy];

//    return;
    
    //парент objects
    FractalString *pStrInfo=[[FractalString alloc]
                             initWithName:@"Info" WithParent:pFParent WithContainer:self];
    
    [pStrInfo SetNameIcon:@"R.png"];
    pStrInfo->X=-180;
    pStrInfo->Y=-30;
    
    pStrInfo->m_iIndex=[ArrayPoints SetMatrix:0];
    [m_OperationIndex AddData:pStrInfo->m_iIndex WithData:pMatrObject->pValueCopy];
    MATRIXcell *pMatrInfo=[ArrayPoints GetMatrixAtIndex:pStrInfo->m_iIndex];
    pMatrInfo->TypeInformation=STR_COMPLEX;
    pMatrInfo->NameInformation=NAME_SIMPLE;
    
    return;
//--------------------------------------------------------------------------------------------------
    FractalString *pStrIngib=[[FractalString alloc]
                            initWithName:@"StartActive" WithParent:pStrInfo WithContainer:self];
    
    [pStrIngib SetNameIcon:@"StartActivity.png"];
    pStrIngib->X=-400;
    pStrIngib->Y=130;
    
    pStrIngib->m_iIndex=[ArrayPoints SetMatrix:0];
    [m_OperationIndex AddData:pStrIngib->m_iIndex WithData:pMatrInfo->pValueCopy];
    MATRIXcell *pMatr=[ArrayPoints GetMatrixAtIndex:pStrIngib->m_iIndex];
    pMatr->TypeInformation=STR_CONTAINER;
    pMatr->NameInformation=NAME_K_START;
    
    FractalString *pStrButton=[[FractalString alloc]
                            initWithName:@"Action" WithParent:pStrInfo WithContainer:self];

    [pStrButton SetNameIcon:@"ButtonAction.png"];
    pStrButton->X=-300;
    pStrButton->Y=130;
    
    pStrButton->m_iIndex=[ArrayPoints SetMatrix:0];
    [m_OperationIndex AddData:pStrButton->m_iIndex WithData:pMatrInfo->pValueCopy];
    pMatr=[ArrayPoints GetMatrixAtIndex:pStrButton->m_iIndex];
    pMatr->TypeInformation=STR_CONTAINER;
    pMatr->NameInformation=NAME_K_BUTTON_ENVENT;


    FractalString *pStrPlus=[[FractalString alloc]
                            initWithName:@"Plus" WithParent:pStrInfo WithContainer:self];
    
    [pStrPlus SetNameIcon:@"o_plus.png"];
    pStrPlus->X=-350;
    pStrPlus->Y=50;
    
    pStrPlus->m_iIndex=[ArrayPoints SetMatrix:0];
    [m_OperationIndex AddData:pStrPlus->m_iIndex WithData:pMatrInfo->pValueCopy];
    pMatr=[ArrayPoints GetMatrixAtIndex:pStrPlus->m_iIndex];
    pMatr->TypeInformation=STR_OPERATION;
    pMatr->NameInformation=NAME_O_PLUS;


    FractalString *pStrVA=[[FractalString alloc]
                        initWithName:@"A" WithParent:pStrInfo WithContainer:self];
    
    [pStrVA SetNameIcon:@"A.png"];
    pStrVA->X=-420;
    pStrVA->Y=-30;
    
    pStrVA->m_iIndex=[ArrayPoints SetFloat:44.56];
    [m_OperationIndex AddData:pStrVA->m_iIndex WithData:pMatrInfo->pValueCopy];

    FractalString *pStrVB=[[FractalString alloc]
                           initWithName:@"B" WithParent:pStrInfo WithContainer:self];
    
    [pStrVB SetNameIcon:@"B.png"];
    pStrVB->X=-350;
    pStrVB->Y=-70;
    
    pStrVB->m_iIndex=[ArrayPoints SetFloat:100.2];
    [m_OperationIndex AddData:pStrVB->m_iIndex WithData:pMatrInfo->pValueCopy];

    FractalString *pStrVR=[[FractalString alloc]
                           initWithName:@"R" WithParent:pStrInfo WithContainer:self];
    
    [pStrVR SetNameIcon:@"R.png"];
    pStrVR->X=-280;
    pStrVR->Y=-30;
    
    pStrVR->m_iIndex=[ArrayPoints SetFloat:99.3];
    [m_OperationIndex AddData:pStrVR->m_iIndex WithData:pMatrInfo->pValueCopy];

    FractalString *pStrVT=[[FractalString alloc]
                           initWithName:@"R" WithParent:pStrInfo WithContainer:self];
    
    [pStrVT SetNameIcon:@"R.png"];
    pStrVT->X=-280;
    pStrVT->Y=-160;
    
    pStrVT->m_iIndex=[ArrayPoints SetInt:123456];
    [m_OperationIndex AddData:pStrVT->m_iIndex WithData:pMatrInfo->pValueCopy];
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
                                 initWithName:@"Zero" WithParent:nil WithContainer:self];
    pFStringZero->m_iIndex=[ArrayPoints SetMatrix:0];
    [ArrayPoints IncDataAtIndex:pFStringZero->m_iIndex];
    MATRIXcell *pMatr=[ArrayPoints GetMatrixAtIndex:pFStringZero->m_iIndex];
////////////////////////////////////////////////////////////////////////////////////////////////////
    //zero point
    int iZeroPoint=[ArrayPoints SetFloat:0];//1
    [m_OperationIndex AddData:iZeroPoint WithData:pMatr->pValueCopy];

    //delta time
    int iDeltaTime=[ArrayPoints SetFloat:0.0f];//2
    [m_OperationIndex AddData:iDeltaTime WithData:pMatr->pValueCopy];
////////////////////////////////////////////////////////////////////////////////////////////////////
    //резервируем индексы ядра
    for (int i=0; i<MAX_REZERV; i++) {
        int iIndexRezerv=[ArrayPoints SetFloat:0.0f];
        [m_OperationIndex AddData:iIndexRezerv WithData:pMatr->pValueCopy];
        iIndexMaxSys=iIndexRezerv;
    }
}
//------------------------------------------------------------------------------------------------------
-(void)SetEditor{//надстройка для редактора

    [self SetKernel];
    
    FractalString *pFStringZero = [self GetString:@"Zero"];
    MATRIXcell *pZeroMatr=[ArrayPoints GetMatrixAtIndex:pFStringZero->m_iIndex];
    
    FractalString *pFStringEditor=[[FractalString alloc]
                                   initWithName:@"Editor" WithParent:pFStringZero WithContainer:self];
    pFStringEditor->m_iIndex=[ArrayPoints SetMatrix:0];
    [m_OperationIndex AddData:pFStringEditor->m_iIndex WithData:pZeroMatr->pValueCopy];
    MATRIXcell *pMatrEditor=[ArrayPoints GetMatrixAtIndex:pFStringEditor->m_iIndex];
///////////////////////////////////////////
    FractalString *pFSCurrentCheck=[[FractalString alloc]
        initWithName:@"CurrentCheck" WithParent:pFStringEditor
        WithContainer:self];
    pFSCurrentCheck->m_iIndex=[ArrayPoints SetMatrix:0];
    [m_OperationIndex AddData:pFSCurrentCheck->m_iIndex WithData:pMatrEditor->pValueCopy];
    MATRIXcell *pMatrCheck=[ArrayPoints GetMatrixAtIndex:pFSCurrentCheck->m_iIndex];

    //для режимов
    [m_OperationIndex AddData:[ArrayPoints SetInt:0] WithData:pMatrCheck->pValueCopy];
    //для текущей полки
    [m_OperationIndex AddData:[ArrayPoints SetInt:0] WithData:pMatrCheck->pValueCopy];
//струны на полке
    FractalString *pFSChelf=[[FractalString alloc]
            initWithName:@"ChelfStirngs" WithParent:pFStringEditor
            WithContainer:self];
    pFSChelf->m_iIndex=[ArrayPoints SetMatrix:0];
    [m_OperationIndex AddData:pFSChelf->m_iIndex WithData:pMatrEditor->pValueCopy];
    MATRIXcell *pMatrChelf=[ArrayPoints GetMatrixAtIndex:pFSChelf->m_iIndex];
    
    for(int i=0;i<8;i++){//записываем имя струны на полке
        NSMutableString *ZeroString = [NSMutableString stringWithString:@"Objects"];
        
        int iIndexZeroName=[ArrayPoints SetName:ZeroString];
        [m_OperationIndex AddData:iIndexZeroName WithData:pMatrChelf->pValueCopy];
    }
/////
    FractalString *pFSDropBox=[[FractalString alloc]
        initWithName:@"DropBox" WithParent:pFStringEditor WithContainer:self];
    pFSDropBox->m_iIndex=[ArrayPoints SetMatrix:0];
    [m_OperationIndex AddData:pFSDropBox->m_iIndex WithData:pMatrEditor->pValueCopy];

    pFStringObjects=[[FractalString alloc]
        initWithName:@"Objects" WithParent:pFStringEditor WithContainer:self];
    pFStringObjects->m_iIndex=[ArrayPoints SetMatrix:0];
    [m_OperationIndex AddData:pFStringObjects->m_iIndex WithData:pMatrEditor->pValueCopy];
    
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
    
    [[FractalString alloc] initWithName:@"Prop" WithParent:pFStringObjects WithContainer:self];
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
//-(void)CopyData:(int **)Data DestData:(int **)DestData dic:(NSMutableDictionary *)pDic
//    SourceContainer:(StringContainer*)SourceContainer{
//    
//    int *StartData=((*Data)+SIZE_INFO_STRUCT);
//    InfoArrayValue *InfoStr=(InfoArrayValue *)(*Data);
//    int iCount=InfoStr->mCount;
//    
//    for (int i=0; i<iCount; i++) {
//        
//        int iIndexSource=StartData[i];
//        
//        NSNumber *pNumSource = [NSNumber numberWithInt:iIndexSource];
//        NSNumber *pNumDest = [pDic objectForKey:pNumSource];
//        
//        if(pNumDest==nil){
//            if(iIndexSource>iIndexMaxSys){
//                
// //               float *pValue=SourceContainer->ArrayPoints->pData+iIndexSource;
//   //             BYTE *pType=SourceContainer->ArrayPoints->pType+iIndexSource;
//                
//                int iIndexDest=[ArrayPoints GetFree];
//                
////                float *pValueDest=ArrayPoints->pData+iIndexDest;
////                BYTE *pTypeDest=ArrayPoints->pType+iIndexDest;
//                
////                *pTypeDest=*pType;
//                
////                switch (*pType) {
////                    case <#constant#>:
////                        <#statements#>
////                        break;
////                        
////                    default:
////                        break;
////                }
////                *pValueDest=*pValue;
//
//                [m_OperationIndex AddData:iIndexDest WithData:DestData];
//                
//                NSNumber *pNumSource = [NSNumber numberWithInt:iIndexSource];
//                NSNumber *pNumDest = [NSNumber numberWithInt:iIndexDest];
//                
//                [m_OperationIndex AddData:iIndexDest WithData:DestData];
//                
//                [pDic setObject:pNumDest forKey:pNumSource];
//            }
//        }
//        else
//        {
//            int iIndexDest=[pNumDest intValue];
//            int *pCountDest=ArrayPoints->pDataInt+iIndexDest;
//            (*pCountDest)++;
//        }
//    }
//}
////------------------------------------------------------------------------------------------------------
//-(void)DeepString:(FractalString *)SourceStr dic:(NSMutableDictionary *)pDic
//  SourceContainer:(StringContainer*)SourceContainer parent:(FractalString *)pParent{
////-------------------------------------------------------------------------------------------
//    FractalString *pDestStr = [[FractalString alloc] init:self];
//    
//    [pDestStr->strUID release];
//    pDestStr->strUID = [[NSString alloc] initWithString:SourceStr->strUID];
//    [pDestStr->sNameIcon release];
//    pDestStr->sNameIcon = [[NSString alloc] initWithString:SourceStr->sNameIcon];
//    
//    pDestStr->X=SourceStr->X;
//    pDestStr->Y=SourceStr->Y;
//    pDestStr->m_iFlags=SourceStr->m_iFlags;
//    
//    [pDestStr SetParent:pParent];
//    [DicStrings setObject:pDestStr forKey:pDestStr->strUID];
//////////////////////////////////////////////////////////////////////////////////////////////////
//    //копируем данные
//    int iType=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:SourceStr->m_iIndex];
//    
////#define DATA_ZERO           0//пустая струна
////#define DATA_ID             1//струна, объект для отображения информации
////#define DATA_MATRIX         2//матрица данных
////#define DATA_FLOAT          4
////#define DATA_INT            5
////#define DATA_STRING         6
////#define DATA_TEXTURE        7
////#define DATA_SOUND          8
//
//    switch (iType) {
//
//        case DATA_FLOAT:
//        case DATA_INT:
//        case DATA_STRING:
//        case DATA_TEXTURE:
//        case DATA_SOUND:
//        {
//        }
//        break;
//            
//        case DATA_MATRIX:
//        {
//            pDestStr->m_iIndexSelf=[ArrayPoints SetMatrix:0];
//            MATRIXcell *pMatrDest=[ArrayPoints GetMatrixAtIndex:pDestStr->m_iIndexSelf];
//            MATRIXcell *pMatrSource=[ArrayPoints GetMatrixAtIndex:SourceStr->m_iIndexSelf];
//            
//            pMatrSource->TypeInformation=pMatrDest->TypeInformation;
//            pMatrSource->NameInformation=pMatrDest->NameInformation;
//
//            [self CopyData:pMatrSource->pValueCopy DestData:pMatrDest->pValueCopy
//                       dic:pDic SourceContainer:SourceContainer];
////            [self CopyData:pMatrSource->pValueLink DestData:pMatrDest->pValueLink
////                       dic:pDic SourceContainer:SourceContainer];
//            
//            [self CopyData:pMatrSource->pQueue DestData:pMatrDest->pQueue
//                       dic:pDic SourceContainer:SourceContainer];
//
//            [self CopyData:pMatrSource->pLinks DestData:pMatrDest->pLinks
//                       dic:pDic SourceContainer:SourceContainer];
//}
//        break;
//            
//        default:
//            break;
//    }
////-------------------------------------------------------------------------------------------
//    //копируем childs
//    int *Data=(*SourceStr->pChildString);
//    InfoArrayValue *InfoStr=(InfoArrayValue *)(Data);
//
//    for(int i=0;i<InfoStr->mCount;i++){
//        
//        int index=(Data+SIZE_INFO_STRUCT)[i];
//        FractalString *pFrStr=[SourceContainer->ArrayPoints
//                               GetIdAtIndex:index];
//        
//        [self DeepString:pFrStr dic:pDic
//            SourceContainer:(StringContainer*)SourceContainer parent:pDestStr];
//    }
//}
//------------------------------------------------------------------------------------------------------
//копируем струну в другое пространство (перекодирование имён параметров)
-(void)CopyStrFrom:(StringContainer*)SourceContainer WithId:(FractalString *)SourceStr{

    FractalString *pDestStr = [[FractalString alloc] initAsCopy:SourceStr
        WithParent:nil WithContainer:self WithSourceContainer:SourceContainer WithLink:NO];

    
//    NSMutableDictionary *pDicRename=[[NSMutableDictionary alloc] init];
//
//    [self DeepString:SourceStr dic:pDicRename
//            SourceContainer:(StringContainer*)SourceContainer parent:nil];
//
//    [pDicRename release];
}
//------------------------------------------------------------------------------------------------------
-(void)DelChilds:(FractalString *)strDelChilds{
    
    int **Data=(strDelChilds->pChildString);
    int *StartData=((*Data)+SIZE_INFO_STRUCT);
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*Data);
    int iCount=InfoStr->mCount;

    for (int i=0; i<iCount; i++) {

        int index=(StartData)[0];
        FractalString *pFrStr=*((FractalString **)(ArrayPoints->pData+index));
        [self DelString:pFrStr];
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

                FractalString *pFrStr=*((FractalString **)(ArrayPoints->pData+index));

                if(strDel->m_iIndexSelf==pFrStr->m_iIndexSelf){
//если нашли себя в струне парента, то удаляем -------------------------------------------------------
                    //удаляем данные связаные со струной
                    MATRIXcell *pMatr=[ArrayPoints GetMatrixAtIndex:strDel->pParent->m_iIndex];

                    if(pMatr!=0)
                    {
                        int iRet=-1;

//                        if(pFrStr->m_bLink==YES)
//                        {
//                            iRet=[m_OperationIndex FindIndex:pFrStr->m_iIndex WithData:pMatr->pValueLink];
//                          if(iRet>-1)[m_OperationIndex RemoveDataAtPlace:iRet WithData:pMatr->pValueLink];
//                        }
//                        else
//                        {
                            iRet=[m_OperationIndex FindIndex:pFrStr->m_iIndex WithData:pMatr->pValueCopy];
                            if(iRet>-1)[m_OperationIndex RemoveDataAtPlace:iRet WithData:pMatr->pValueCopy];
           //             }
                    }

//удаляем ассоциации=======================================================================================
                    if(pFrStr->pAssotiation!=nil)
                    {
                        NSNumber *pNumSource=[NSNumber numberWithInt:pFrStr->m_iIndexSelf];
                        [pFrStr->pAssotiation removeObjectForKey:pNumSource];
                        

                        if([pFrStr->pAssotiation count]==1)
                        {//если больше нет ссылок очищаем массив

                            NSArray *keys = [pFrStr->pAssotiation allKeys];
                            id aKey = [keys objectAtIndex:0];
                            NSNumber *pNum = [pFrStr->pAssotiation objectForKey:aKey];
                            FractalString *TmpStr = [ArrayPoints GetIdAtIndex:[pNum intValue]];

                            NSString *pKey = [NSString stringWithFormat:@"%p",TmpStr->pAssotiation];
                            [ArrayPoints->DicAllAssociations removeObjectForKey:pKey];

                            [TmpStr->pAssotiation release];
                            TmpStr->pAssotiation=nil;
                        }
                        
                    }
                    
                    //смотрим на матрицу данных
                    int Count=[ArrayPoints GetCountAtIndex:pFrStr->m_iIndex];
                    
                    if(Count==0)
                    {
                        NSArray *Objects = [pFrStr->pAssotiation allValues];
                        
                        for (int i=0; i<[Objects count]; i++) {
                            NSNumber *pNum = [Objects objectAtIndex:i];
                            
                            FractalString *TmpStr = [ArrayPoints GetIdAtIndex:[pNum intValue]];
                            
                            int **DataChild=(TmpStr->pParent->pChildString);
                            int iRet=[m_OperationIndex FindIndex:pFrStr->m_iIndexSelf WithData:DataChild];
                            if(iRet>-1)[m_OperationIndex RemoveDataAtPlace:iRet WithData:DataChild];
                            [TmpStr release];
                        }
                    }
//==========================================================================================================
                    //удаляемся из парента саму струну
                    [m_OperationIndex RemoveDataAtPlace:i WithData:Data];
                    [DicStrings removeObjectForKey:pFrStr->strUID];
                    [pFrStr release];

                    return;
                }
            }
        }
        else
        {
            [ArrayPoints DecDataAtIndex:strDel->m_iIndex];
            [ArrayPoints DecDataAtIndex:strDel->m_iIndexSelf];
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
    MATRIXcell *pMatrChelf=[ArrayPoints GetMatrixAtIndex:pCurString->m_iIndex];

    //    int a,y;
    //    __asm__("mov %0, %1, ASR #1" : "=r" (y) : "r" (a));
    
LOOP:
    
    switch (pMatrChelf->TypeInformation)
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
            
    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
@end