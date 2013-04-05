//
//  StringContainer.m
//  FunDreams
//
//  Created by Konstantin Maximov on 15.06.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import "StringContainer.h"
#import "DropBoxMng.h"
#import "Ob_Editor_Interface.h"
#import "Ob_ParticleCont_ForStr.h"
#import "MainCycle.h"
#import "Kernel.h"

@implementation StringContainer
//------------------------------------------------------------------------------------------------------
-(id)init:(id)Parent{
    
    self = [super init];

    if(self){
        
        ArrayPoints = [[FunArrayData alloc] initWithCopasity:0];
        ArrayPoints->iCountInc=100;
        ArrayPoints->pParent=self;

        m_OperationIndex = [[FunArrayDataIndexes alloc] init];
        m_OperationIndex->m_pParent=self;
        
        pParMatrixStack=[m_OperationIndex InitMemory];
        pCurPlaceStack=[m_OperationIndex InitMemory];

        DicStrings = [[NSMutableDictionary alloc] init];
        DicLog = [[NSMutableDictionary alloc] init];

        m_pObjMng=Parent;

        DicStrings = [[NSMutableDictionary alloc] init];
        
        pMainCycle = [[MainCycle alloc] init:self];
        pKernel = [[Kernel alloc] init:self];

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
- (void)SetParCont{
    
    Ob_ParticleCont_ForStr *TmpOb=[m_pObjMng CreateNewObject:@"Ob_ParticleCont_ForStr"
                            WithNameObject:@"SpriteContainer"
                              WithParams:[NSArray arrayWithObjects:
                            SET_STRING_V(@"PensilAtl",@"m_pNameAtlas"),
                            SET_VECTOR_V(Vector3DMake(0, 0, 0),@"m_pCurPosition"),nil] ];

    ArrayPoints->pCurrenContPar=TmpOb;
}
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
- (void)LogQueue:(FractalString*)pStr{
    MATRIXcell *pMatr=[ArrayPoints GetMatrixAtIndex:pStr->m_iIndex];
    
    if(pMatr!=nil){
        InfoArrayValue *InfoStr=(InfoArrayValue *)(*pMatr->pQueue);
        int *StartData=((*pMatr->pQueue)+SIZE_INFO_STRUCT);
        
        for (int i=0; i<InfoStr->mCount; i++) {
            HeartMatr *pHeart=(HeartMatr *)StartData[i];
            
            if(pHeart!=0){
                
                NSLog(@"Heart:%p Place:%d",pHeart,i);
                
                InfoArrayValue *InfoStrEnPar=(InfoArrayValue *)(*pHeart->pEnPairPar);
                int *StartDataEnPar=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT);

//                InfoArrayValue *InfoStrEnChi=(InfoArrayValue *)(*pHeart->pEnPairChi);
                int *StartDataEnChi=((*pHeart->pEnPairChi)+SIZE_INFO_STRUCT);

            
                InfoArrayValue *InfoStrExPar=(InfoArrayValue *)(*pHeart->pExPairPar);
                int *StartDataExPar=((*pHeart->pExPairPar)+SIZE_INFO_STRUCT);
                
//                InfoArrayValue *InfoStrExChi=(InfoArrayValue *)(*pHeart->pExPairChi);
                int *StartDataExChi=((*pHeart->pExPairChi)+SIZE_INFO_STRUCT);
                
                NSString *pStrLogOut = @"EntersPair:";

                for (int j=0; j<InfoStrEnPar->mCount; j++) {
                    int iIndexPar=StartDataEnPar[j];
                    int iIndexChi=StartDataEnChi[j];
                    
                    pStrLogOut=[pStrLogOut stringByAppendingFormat:@"%d-%d.",iIndexPar,iIndexChi];
                }
                NSLog(@"%@",pStrLogOut);

                pStrLogOut = @"ExitPair:";
                
                for (int j=0; j<InfoStrExPar->mCount; j++) {
                    int iIndexPar=StartDataExPar[j];
                    int iIndexChi=StartDataExChi[j];
                    
                    pStrLogOut=[pStrLogOut stringByAppendingFormat:@"%d-%d.",iIndexPar,iIndexChi];
                }
                NSLog(@"%@",pStrLogOut);
                
                InfoArrayValue *InfoStrNext=(InfoArrayValue *)(*pHeart->pNextPlaces);
                int *StartDataNext=((*pHeart->pNextPlaces)+SIZE_INFO_STRUCT);
                pStrLogOut = @"Places:";

                for (int j=0; j<InfoStrNext->mCount; j++) {
                    
                    int Place=StartDataNext[j];
                    
                    pStrLogOut=[pStrLogOut stringByAppendingFormat:@"%d.",Place];
                }
                NSLog(@"%@",pStrLogOut);
            }
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)LogInfo:(FractalString *)fString{
    NSLog(@"Str:%@ %p Ind:%d IndS:%d ic:%@",fString->strUID,fString,fString->m_iIndex,
          fString->m_iIndexSelf,fString->sNameIcon);

    if(fString->pParent!=nil){
        NSLog(@"Par:%@ %p Ind:%d IndS:%d ic:%@",fString->pParent->strUID,
              fString->pParent,fString->pParent->m_iIndex,
              fString->pParent->m_iIndexSelf,fString->pParent->sNameIcon);
    }

    NSLog(@"Association:%p",fString->pAssotiation);
    
    [self LogDataPoint:fString->pChildString Name:@"ChildsInString"];
    [self LogQueue:fString];
}
//------------------------------------------------------------------------------------------------------
- (void)LogDataPoint:(int**)pData Name:(NSString *)Name{
    
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*pData);
    int *StartData=((*pData)+SIZE_INFO_STRUCT);

    NSString *pStr= [NSString stringWithFormat:@"%p %@(%d):",pData,Name,InfoStr->mCount];
    NSString *pStrLog = [NSString stringWithString:pStr];
    
    for (int i=0; i<InfoStr->mCount; i++) {
        int iTmpIndex=StartData[i];
        
        pStrLog=[pStrLog stringByAppendingFormat:@"%d.",iTmpIndex];
    }

    NSLog(@"%@",pStrLog);
}
//------------------------------------------------------------------------------------------------------
- (void)LogInfoIndex:(int)iIndex{
    
    int iType = [ArrayPoints GetTypeAtIndex:iIndex];
    int iCount = [ArrayPoints GetCountAtIndex:iIndex];
    NSLog(@"количесво ссылок (Count): %d",iCount);
    
    switch (iType) {
        case DATA_ID:
        {
            NSLog(@"DATA_ID");
            FractalString * pTmpString = [ArrayPoints GetIdAtIndex:iIndex];
            NSLog(@"V=%@",pTmpString->strUID);
        }
        break;

        case DATA_MATRIX:
        {
            MATRIXcell * pTmpMatrix = [ArrayPoints GetMatrixAtIndex:iIndex];

            NSLog(@"DATA_MATRIX IndexSelf=%d",pTmpMatrix->iIndexSelf);

            [self LogDataPoint:pTmpMatrix->pLinks Name:@"Links"];
            [self LogDataPoint:pTmpMatrix->pValueCopy Name:@"Childs"];
//          int iCount = [ArrayPoints GetCountAtIndex:pTmpMatrix->iIndexSelf];
        }
        break;

        case DATA_FLOAT:
        {
            float * pTmpfloat = [ArrayPoints GetDataAtIndex:iIndex];
            NSLog(@"DATA_FLOAT V=%1.2f",*pTmpfloat);
        }
        break;

        case DATA_INT:
        {
            int * pTmpInt = [ArrayPoints GetDataAtIndex:iIndex];
            NSLog(@"DATA_INT V=%d",*pTmpInt);
        }
        break;

        case DATA_STRING:
        {
            NSString * pTmpStr = [ArrayPoints GetIdAtIndex:iIndex];
            NSLog(@"DATA_STRING V=%@",pTmpStr);
        }
        break;

        case DATA_TEXTURE:
        {
            NSString * pTmpStr = [ArrayPoints GetIdAtIndex:iIndex];
            NSLog(@"DATA_TEXTURE V=%@",pTmpStr);
        }
        break;

        case DATA_SOUND:
        {
            NSString * pTmpStr = [ArrayPoints GetIdAtIndex:iIndex];
            NSLog(@"DATA_SOUND V=%@",pTmpStr);
        }
        break;

        default:
            NSLog(@"тип неизвестен");
            break;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)LogChild:(FractalString *)fString{

    NSNumber *pNum=[NSNumber numberWithInt:fString->m_iIndex];
    NSNumber *pTmpNum=[DicLog objectForKey:pNum];
    
    NSLog(@"=====================================================");
    [self LogInfoIndex:fString->m_iIndex];
    [self LogInfo:fString];
    NSLog(@"=====================================================");

    if(pTmpNum==nil){

        [DicLog setObject:pNum forKey:pNum];

        InfoArrayValue *InfoStr=(InfoArrayValue *)(*fString->pChildString);
        int *StartIndex=(*fString->pChildString)+SIZE_INFO_STRUCT;
        int iCount=InfoStr->mCount;
        
        NSLog(@"Child string %d",iCount);
        
        for (int i=0; i<iCount; i++) {
            
            int index=(StartIndex)[i];
            FractalString *FChild=[ArrayPoints GetIdAtIndex:index];
            [self LogChild:FChild];
        }
    }
    else
    {
        NSLog(@"link Alrady in use");
    }
}
//------------------------------------------------------------------------------------------------------
- (void)LogString:(FractalString *)StartString{

    [DicLog removeAllObjects];

    NSLog(@"Start=====================================================");
    NSLog(@"общее количество струн %d",[DicStrings count]);
    NSLog(@"общее количество имён %d",[ArrayPoints->pNamesValue count]);
    NSLog(@"общее количество матриц %d",[ArrayPoints->pMartixDic count]);
    NSLog(@"общее количество имён струн %d (струны в матрице)",[ArrayPoints->pNamesOb count]);

    NSLog(@"общее количество ассоциаций %d",[ArrayPoints->DicAllAssociations count]);

    NSEnumerator *Key_enumerator = [ArrayPoints->DicAllAssociations keyEnumerator];
    NSString *pNameKey;
    
    while ((pNameKey = [Key_enumerator nextObject])) {
        
        NSMutableDictionary * pGroupsLinks = [ArrayPoints->DicAllAssociations objectForKey:pNameKey];
        
        NSString *pStr= [NSString stringWithFormat:@"%p (%d):",pGroupsLinks,[pGroupsLinks count]];
        NSString *pStrLog = [NSString stringWithString:pStr];

        if(pGroupsLinks!=nil){
            NSEnumerator *pTmpEnumerator = [pGroupsLinks objectEnumerator];
            NSNumber *pNum=nil;

            while ((pNum = [pTmpEnumerator nextObject])) {
                int iIndex=[pNum integerValue];
                
                pStrLog=[pStrLog stringByAppendingFormat:@"%d.",iIndex];
            }
        }
        NSLog(@"%@",pStrLog);
    }

    NSLog(@"=====================================================");
    [self LogInfoIndex:StartString->m_iIndex];
    [self LogInfo:StartString];
    NSLog(@"=====================================================");
    
    NSNumber *pNum=[NSNumber numberWithInt:StartString->m_iIndex];
    [DicLog setObject:pNum forKeyedSubscript:pNum];
    
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*StartString->pChildString);
    int *StartIndex=(*StartString->pChildString)+SIZE_INFO_STRUCT;
    int iCount=InfoStr->mCount;
    
    for (int i=0; i<iCount; i++) {
        
        int index=(StartIndex)[i];
        FractalString *FChild=[ArrayPoints GetIdAtIndex:index];
        [self LogChild:FChild];
    }
    NSLog(@"End=====================================================");
}
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
-(void)ReLinkDataManager{
    
    for (int i=0; i<[ArrayDumpFiles count]; i++) {

        CDataManager *pDataManager=[ArrayDumpFiles objectAtIndex:i];
        [pDataManager relinkResClient];
    }
}
//------------------------------------------------------------------------------------------------------
-(void)SetKernel{
    [pKernel SetKernel];
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
    
    for(int i=0;i<11;i++){//записываем имя струны на полке
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
}
//------------------------------------------------------------------------------------------------------
-(void)ConnectStart:(FractalString *)StartStr End:(FractalString *)EndStr
{
    int **DataParent=(StartStr->pParent->pChildString);
    InfoArrayValue *InfoStrParent=(InfoArrayValue *)(*DataParent);
    int iCount=InfoStrParent->mCount;
    int *StartData=((*DataParent)+SIZE_INFO_STRUCT);
    
    int PlaceStart=-1,PlaceEnd=-1;
    for (int i=0; i<iCount; i++){

        int index=(StartData)[i];
        FractalString *pFrStr=*((FractalString **)(ArrayPoints->pData+index));

        if(StartStr->m_iIndexSelf==pFrStr->m_iIndexSelf)
        {
            PlaceStart=i;
        }

        if(EndStr->m_iIndexSelf==pFrStr->m_iIndexSelf)
        {
            PlaceEnd=i;
        }
    }
    
    MATRIXcell *pMatrPar=[ArrayPoints GetMatrixAtIndex:StartStr->pParent->m_iIndex];
    //----------------------------------------------------------------------
 //   InfoArrayValue *InfoQueue=(InfoArrayValue *)(*pMatrStart->pQueue);
    int *StartDataQueue=((*pMatrPar->pQueue)+SIZE_INFO_STRUCT);
    
//    for(int i=0;i<InfoQueue->mCount;i++){
//        HeartMatr *pHeart=StartDataQueue[i];
//        int m=0;
//    }
    //----------------------------------------------------------------------
    int iTypeStart=[ArrayPoints GetTypeAtIndex:StartStr->m_iIndex];
    int iTypeEnd=[ArrayPoints GetTypeAtIndex:EndStr->m_iIndex];
    
    if(((iTypeStart==DATA_FLOAT)||(iTypeStart==DATA_INT)||(iTypeStart==DATA_STRING)
        ||(iTypeStart==DATA_SPRITE)||
        (iTypeStart==DATA_TEXTURE)||(iTypeStart==DATA_SOUND)) && iTypeEnd==DATA_MATRIX){
        
        MATRIXcell *pMatrEnd=[ArrayPoints GetMatrixAtIndex:EndStr->m_iIndex];
        
        if(pMatrEnd!=0){
            InfoArrayValue *pEnters=(InfoArrayValue *)(*pMatrEnd->pEnters);
            InfoArrayValue *pExits=(InfoArrayValue *)(*pMatrEnd->pExits);
            
            if(pEnters->mCount>0 || pExits->mCount>0){
                
                HeartMatr *pHeartStart = (HeartMatr *)StartDataQueue[PlaceEnd];
                
                //если индекс уже есть в паре, то удалаем его
                bool bFind=NO;
                
                InfoArrayValue *InfoPairPar=(InfoArrayValue *)(*pHeartStart->pEnPairPar);
                int *StartPairChild=*pHeartStart->pEnPairPar+SIZE_INFO_STRUCT;
                
                for (int k=0; k<InfoPairPar->mCount; k++){
                    int iIndexPair=StartPairChild[k];
                    
                    if(StartStr->m_iIndex==iIndexPair){
                        
                        int iIndexChild=(*pHeartStart->pEnPairChi+SIZE_INFO_STRUCT)[k];
                        (*pHeartStart->pEnPairPar+SIZE_INFO_STRUCT)[k]=iIndexChild;
                        
//                        [m_pObjMng->pStringContainer->m_OperationIndex
//                         OnlyRemoveDataAtPlace:k WithData:pHeartStart->pEnPairChi];
//                        
//                        [m_pObjMng->pStringContainer->m_OperationIndex
//                         OnlyRemoveDataAtPlace:k WithData:pHeartStart->pEnPairPar];
                        
                        bFind=YES;
                    }
                }

                InfoPairPar=(InfoArrayValue *)(*pHeartStart->pExPairPar);
                StartPairChild=*pHeartStart->pExPairPar+SIZE_INFO_STRUCT;
                
                for (int k=0; k<InfoPairPar->mCount; k++){
                    int iIndexPair=StartPairChild[k];
                    
                    if(StartStr->m_iIndex==iIndexPair){
                        
                        int iIndexChild=(*pHeartStart->pExPairChi+SIZE_INFO_STRUCT)[k];
                        (*pHeartStart->pExPairPar+SIZE_INFO_STRUCT)[k]=iIndexChild;

//                        [m_pObjMng->pStringContainer->m_OperationIndex
//                         OnlyRemoveDataAtPlace:k WithData:pHeartStart->pExPairChi];
//                        
//                        [m_pObjMng->pStringContainer->m_OperationIndex
//                         OnlyRemoveDataAtPlace:k WithData:pHeartStart->pExPairPar];
                        
                        bFind=YES;
                    }
                }

                if(bFind==YES){
                    Ob_Editor_Interface *pObInterface = (Ob_Editor_Interface *)
                    [m_pObjMng GetObjectByName:@"Ob_Editor_Interface"];

                    [pObInterface UpdateB];
                    return;
                }
                
                int iIndexStart=StartStr->m_iIndex;
                
                Ob_Editor_Interface *pObInterface = (Ob_Editor_Interface *)
                [m_pObjMng GetObjectByName:@"Ob_Editor_Interface"];
                
                pObInterface->m_iIndexStart=iIndexStart;
                pObInterface->EndHeart=pHeartStart;
                pObInterface->pMatrTmp=pMatrEnd;
                pObInterface->pConnString=EndStr;
                
                [pObInterface SetMode:M_CONNECT_IND];
                [pObInterface UpdateB];
            }
        }
    }
    else if(iTypeStart==DATA_MATRIX && iTypeEnd==DATA_MATRIX){
        
        HeartMatr *pHeartStart = (HeartMatr *)StartDataQueue[PlaceStart];
  //      HeartMatr *pHeartEnd = (HeartMatr *)StartDataQueue[PlaceEnd];
        
        InfoArrayValue *InfoHeartStartNextPlace=(InfoArrayValue *)(*pHeartStart->pNextPlaces);
        int *NexpPlaces=((*pHeartStart->pNextPlaces)+SIZE_INFO_STRUCT);

  //      InfoArrayValue *InfoHeartEndNextPlace=(InfoArrayValue *)(*pHeartEnd->pNextPlaces);
 //       int *NexpPlacesEnd=((*pHeartEnd->pNextPlaces)+SIZE_INFO_STRUCT);

        if(InfoHeartStartNextPlace->mCount>0){
            int TmpPlace=NexpPlaces[0];
            
            if(TmpPlace==PlaceEnd){
                [m_OperationIndex OnlyRemoveDataAtIndex:TmpPlace WithData:pHeartStart->pNextPlaces];
//                NexpPlacesEnd[0]=-1;
            }
            else NexpPlaces[0]=PlaceEnd;
        }
        else [m_OperationIndex OnlyAddData:PlaceEnd WithData:pHeartStart->pNextPlaces];
        
//        if(InfoHeartEndNextPlace->mCount>0){
////            NexpPlacesEnd[0]=-1;
//        }
//        else
//        {
//            [m_OperationIndex OnlyAddData:-1 WithData:pHeartEnd->pNextPlaces];
//        }
    }
    
    OBJECT_PERFORM_SEL(@"Ob_Editor_Interface",@"UpdateB");
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
                //загрузка струн
                [[FractalString alloc] initWithData:pDataCurManager->m_pDataDmp
                                WithCurRead:&pDataCurManager->m_iCurReadingPos
                                WithParent:nil WithContainer:self];
                                
                //загрузка матрицы
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
    
    //сбрасываем флаги сохранения
    NSEnumerator *Enumerator = [DicStrings objectEnumerator];
    FractalString *pOb;
    
    while ((pOb = [Enumerator nextObject])) {
        pOb->bAlradySave=NO;
    }
}
//------------------------------------------------------------------------------------------------------
//копируем струну в другое пространство (перекодирование имён параметров)
-(void)CopyStrFrom:(StringContainer*)SourceContainer WithId:(FractalString *)SourceStr{
    
    FractalString *pFStringZero=[self GetString:@"Zero"];
    
    /*FractalString *pDestStr = */[[FractalString alloc] initAsCopy:SourceStr
        WithParent:pFStringZero WithContainer:self WithSourceContainer:SourceContainer WithLink:NO];

 //   [pDestStr->m_pContainer LogString:pDestStr];
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

            int TypeDel=[ArrayPoints GetTypeAtIndex:strDel->m_iIndex];
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
                    int Count=[ArrayPoints GetCountAtIndex:strDel->pParent->m_iIndex];

                    if(pMatr!=0 && Count>0)
                    {
//                        int iRet=-1;
//                        iRet=[m_OperationIndex FindIndex:pFrStr->m_iIndex WithData:pMatr->pValueCopy];
//                        if(iRet>-1)
                          [m_OperationIndex RemoveDataAtPlace:i WithData:pMatr->pValueCopy];
                    }
//удаляем ассоциации=======================================================================================
                    if(pFrStr->pAssotiation!=nil)
                    {
                        //смотрим на матрицу данных
                        int Count=[ArrayPoints GetCountAtIndex:pFrStr->m_iIndex];
                        
                        NSMutableDictionary *TmpAssotionation=pFrStr->pAssotiation;
                        
                        if(Count==0)
                        {
                            NSNumber *pNumSource=[NSNumber numberWithInt:pFrStr->m_iIndexSelf];
                            [pFrStr->pAssotiation removeObjectForKey:pNumSource];
                            [pFrStr->pAssotiation release];
                            pFrStr->pAssotiation=nil;

                            NSArray *Objects = [TmpAssotionation allValues];
                            
                            for (int i=0; i<[Objects count]; i++) {
                                NSNumber *pNum = [Objects objectAtIndex:i];
                                
                                FractalString *TmpStrInside = [ArrayPoints GetIdAtIndex:[pNum intValue]];
                                
                                int **DataChild=(TmpStrInside->pParent->pChildString);
                                int iRet=[m_OperationIndex FindIndex:TmpStrInside->
                                          m_iIndexSelf WithData:DataChild];
                                
                                if(iRet>-1)
                                    [m_OperationIndex RemoveDataAtPlace:iRet WithData:DataChild];
                                [DicStrings removeObjectForKey:TmpStrInside->strUID];
                                [TmpStrInside release];
                            }
                            
                            NSString *pKey = [NSString stringWithFormat:@"%p",TmpAssotionation];
                            [ArrayPoints->DicAllAssociations removeObjectForKey:pKey];
                        }
                        else
                        {
                            NSNumber *pNumSource=[NSNumber numberWithInt:pFrStr->m_iIndexSelf];
                            [pFrStr->pAssotiation removeObjectForKey:pNumSource];
//переназначаем парентов с случае удаления ссылки========================================================
                            if(TypeDel==DATA_MATRIX){
                                NSArray *keys_Tmp = [pFrStr->pAssotiation allKeys];
                                id aKey_Tmp = [keys_Tmp objectAtIndex:0];
                                NSNumber *pNum_Tmp = [pFrStr->pAssotiation objectForKey:aKey_Tmp];
                                FractalString *StrDiffParrent = [ArrayPoints
                                                                 GetIdAtIndex:[pNum_Tmp intValue]];

                                int **DataChild=(strDel->pChildString);
                                InfoArrayValue *InfoStr_Childs=(InfoArrayValue *)(*DataChild);
                                
                                if(InfoStr_Childs->mCount>0){
                                    int *StartDataInDelChild=((*DataChild)+SIZE_INFO_STRUCT);
                                        
                                    int iChildInd=StartDataInDelChild[0];
                                    FractalString *ChildStrInDelString=[ArrayPoints GetIdAtIndex:iChildInd];

                                    if(ChildStrInDelString->pParent==strDel)
                                    {
                                        for (int i=0; i<InfoStr_Childs->mCount; i++) {
                                            
                                            iChildInd=StartDataInDelChild[i];
                                            FractalString *Tmp_Str = [ArrayPoints GetIdAtIndex:iChildInd];
                                            Tmp_Str->pParent=StrDiffParrent;
                                        }
                                    }
                                }
                            }
//=======================================================================================================
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
                    }
//=========================================================================================================
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
- (void)dealloc
{
    [m_OperationIndex OnlyReleaseMemory:pCurPlaceStack];
    [m_OperationIndex OnlyReleaseMemory:pParMatrixStack];

    [DicStrings release];
    [DicLog release];

    [ArrayPoints release];
    [m_OperationIndex release];
    
    for (CDataManager *pManager in ArrayDumpFiles) {
        [pManager release];
    }
    [ArrayDumpFiles release];
    
    [pMainCycle release];
    [pKernel release];

    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
@end