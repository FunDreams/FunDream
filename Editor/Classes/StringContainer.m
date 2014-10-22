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
        
        m_bInDropBox=NO;
        ArrayPoints = [[FunArrayData alloc] initWithCopasity:0];

        m_OperationIndex = [[FunArrayDataIndexes alloc] init];
        m_OperationIndex->m_pParent=self;
        [ArrayPoints PostInit:self];
        
        pParMatrixStack=[m_OperationIndex InitMemory];
        pCurPlaceStack=[m_OperationIndex InitMemory];

        DicStrings = [[NSMutableDictionary alloc] init];
        DicLog = [[NSMutableDictionary alloc] init];

        m_pObjMng=Parent;
        
        pMainCycle = [[MainCycle alloc] init:self];
        pKernel = [[Kernel alloc] init:self];

        ArrayDumpFiles = [[NSMutableArray alloc] init];

#ifdef __EDITOR
        CDataManager *pDataManager=[[CDataManager alloc] InitWithFileFromDoc:@"MainDump"];
        [ArrayDumpFiles addObject:pDataManager];
#else
        CDataManager *pDataManager=[[CDataManager alloc] InitWithFileFromTemp:@"MainDump"];
        [ArrayDumpFiles addObject:pDataManager];

        pDataManager=[[CDataManager alloc] InitWithFileFromRes:@"MainDump"];
        [ArrayDumpFiles addObject:pDataManager];

#endif
        

        m_iCurFile=0;
        pDataCurManagerTmp=[ArrayDumpFiles objectAtIndex:m_iCurFile];
    }
    return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetParCont{
    
    Ob_ParticleCont_ForStr *TmpOb=[m_pObjMng UnfrozeObject:@"Ob_ParticleCont_ForStr"
                            WithNameObject:@"SpriteContainer"
                              WithParams:[NSArray arrayWithObjects:
                            SET_STRING_V(@"PensilAtl",@"m_pNameAtlas"),
                            SET_VECTOR_V(Vector3DMake(0, 0, 0),@"m_pCurPosition"),nil]];

    TmpOb->ArrayPointsParent=ArrayPoints;
    TmpOb->pTexRes->ArrayPointsParent=ArrayPoints;
    TmpOb->pSoundRes->ArrayPointsParent=ArrayPoints;
    
    ArrayPoints->pCurrenContPar=TmpOb;
    ArrayPoints->pCurrenContParSrc=TmpOb;
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
                
                pStrLogOut = @"Places:";

                pStrLogOut=[pStrLogOut stringByAppendingFormat:@"%d.",pHeart->pNextPlace];
                
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

    NSString *pStr= [NSString stringWithFormat:@"%p %@(%d type:%d):",
                     pData,Name,InfoStr->mCount,InfoStr->mType];
    
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
    NSLog(@"общее количество массивов %d",[ArrayPoints->ppAllArrays count]);
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
-(void)spesProc:(int)type{
    switch (type) {
            
        case 0:
        {
            float * Tmp=pMainCycle->pDataLocal+Ind_V1;
            if(*Tmp>0)
            {
#ifdef GAME_CENTER
                [m_pObjMng->m_pParent SubScore:@"FD1" withScore:*Tmp];
#endif
            }
        }
        break;

        case 100:
        {
#ifdef GAME_CENTER
            [m_pObjMng->m_pParent ShowLider:@"FD1"];
#endif
        }
        break;
            
        case 200://fun 1 is purchase
        {
            float * Tmp=pMainCycle->pDataLocal+Ind_V1;
#ifdef GAME_CENTER
            [MKStoreManager sharedManager];
            if([MKStoreManager featureAPurchased])
            {
                *Tmp=1;
            }
            else
            {
                *Tmp=0;
            }
#else
            *Tmp=3;
#endif
        }
        break;
            
        case 201://purchase fun1
        {
#ifdef GAME_CENTER
            if (([[MKStoreManager sharedManager] GetBool]==NO))
            {
                if(![MKStoreManager featureAPurchased])
                    [[MKStoreManager sharedManager] buyFeatureA];
            }
#endif

        }
        break;
            
        case 300://restore all purchase
        {
#ifdef GAME_CENTER
            if (([[MKStoreManager sharedManager] GetBool]==NO))
            {
                [[MKStoreManager sharedManager] restoreIap];
            }
#endif
        }
            
        default:
            break;
    }
}
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
    pMatrEditor->iIndexString=pFStringEditor->m_iIndexSelf;
    
    int *iCurValue=*pMatrEditor->ppStartPlaces+SIZE_INFO_STRUCT;
    *iCurValue=2;//устанавливаем стартовую позицию на objects
///////////////////////////////////////////
    FractalString *pFSCurrentCheck=[[FractalString alloc]
        initWithName:@"CurrentCheck" WithParent:pFStringEditor
        WithContainer:self];
    pFSCurrentCheck->m_iIndex=[ArrayPoints SetMatrix:0];
    [m_OperationIndex AddData:pFSCurrentCheck->m_iIndex WithData:pMatrEditor->pValueCopy];
    MATRIXcell *pMatrCheck=[ArrayPoints GetMatrixAtIndex:pFSCurrentCheck->m_iIndex];
    pMatrCheck->iIndexString=pFSCurrentCheck->m_iIndexSelf;

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
    pMatrChelf->iIndexString=pFSChelf->m_iIndexSelf;
    
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
    MATRIXcell *pMatrDropBox=[ArrayPoints GetMatrixAtIndex:pFSDropBox->m_iIndex];
    pMatrDropBox->iIndexString=pFSDropBox->m_iIndexSelf;

    pFStringObjects=[[FractalString alloc]
        initWithName:@"Objects" WithParent:pFStringEditor WithContainer:self];
    pFStringObjects->m_iIndex=[ArrayPoints SetMatrix:0];
    [m_OperationIndex AddData:pFStringObjects->m_iIndex WithData:pMatrEditor->pValueCopy];
    MATRIXcell *pMatrObjects=[ArrayPoints GetMatrixAtIndex:pFStringObjects->m_iIndex];
    pMatrObjects->iIndexString=pFStringObjects->m_iIndexSelf;
    
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
    
    if(iTypeStart==DATA_ARRAY && iTypeEnd==DATA_MATRIX){
        
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
                        
//                      int iIndexChild=(*pHeartStart->pEnPairChi+SIZE_INFO_STRUCT)[k];
//                      (*pHeartStart->pEnPairPar+SIZE_INFO_STRUCT)[k]=iIndexChild;
//                        
//                        int **ppArrayTmp=[m_pObjMng->pStringContainer->ArrayPoints
//                                          GetArrayAtIndex:iIndexPair];
//                        InfoArrayValue *pArrayTmp=(InfoArrayValue *)*ppArrayTmp;
//                        
//                        if(pMatrEnd->TypeInformation==STR_OPERATION && pArrayTmp->mType!=DATA_U_INT)
//                        {
//                            int iIndexMatrLink=(*pMatrEnd->pValueCopy+SIZE_INFO_STRUCT)[2];
//                            MATRIXcell *pMatrLink=[m_pObjMng->pStringContainer->ArrayPoints
//                                                   GetMatrixAtIndex:iIndexMatrLink];
//                            InfoArrayValue *pInfoEnter=(InfoArrayValue *)*pMatrLink->pValueCopy;
//                            
//                            int iIndexMatrLink2=(*pMatrEnd->pValueCopy+SIZE_INFO_STRUCT)[3];
//                            MATRIXcell *pMatrLink2=[m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:iIndexMatrLink2];
//                            
//                            
//                            for (int p=0; p<pInfoEnter->mCount; p++)
//                            {
//                                int iIndexArrayLink=(*pMatrLink->pValueCopy+SIZE_INFO_STRUCT)[p];
//                                int **ArrayLink=[m_pObjMng->pStringContainer->ArrayPoints
//                                                 GetArrayAtIndex:iIndexArrayLink];
//                                
//                                int iRez=[m_pObjMng->pStringContainer->m_OperationIndex
//                                          FindIndex:k WithData:ArrayLink];
//                                
//                                if(iRez!=-1)
//                                {
//                                    InfoArrayValue *pInfoTmpLinkInside=(InfoArrayValue *)*ArrayLink;
//                                    for (int m=0; m<pInfoTmpLinkInside->mCount; m++)
//                                    {
//                                        int iTmpPlace=(*ArrayLink+SIZE_INFO_STRUCT)[m];
//                                        
//                                        int iIndexChild=(*pHeartStart->pEnPairChi+
//                                                         SIZE_INFO_STRUCT)[iTmpPlace];
//                                        (*pHeartStart->pEnPairPar+
//                                                    SIZE_INFO_STRUCT)[iTmpPlace]=iIndexChild;
//                                    }
//                                    
//                                    int iIndexArrayLink2=(*pMatrLink2->pValueCopy+SIZE_INFO_STRUCT)[p];
//                                    int **ArrayLink2=[m_pObjMng->pStringContainer->ArrayPoints
//                                                      GetArrayAtIndex:iIndexArrayLink2];
//                                    
//                                    pInfoTmpLinkInside=(InfoArrayValue *)*ArrayLink2;
//                                    for (int m=0; m<pInfoTmpLinkInside->mCount; m++)
//                                    {
//                                        int iTmpPlace=(*ArrayLink2+SIZE_INFO_STRUCT)[m];
//                                        
//                                        int iIndexChild=(*pHeartStart->pExPairChi+
//                                                         SIZE_INFO_STRUCT)[iTmpPlace];
//                                        (*pHeartStart->pExPairPar+
//                                         SIZE_INFO_STRUCT)[iTmpPlace]=iIndexChild;
//                                    }
//                                    
//                                break;
//                                }
//                            }
//                        }
//
////                        MATRIXcell *pMatrZero=pMatrPar;
////                        [m_pObjMng->pStringContainer->m_OperationIndex
////                         RemoveAllConnections:nil RootMatr:pMatrZero SearchCurIndex:StartStr->m_iIndex];
//                        
//                        bFind=YES;
//             //           goto Exit;
                    }
                }

                InfoPairPar=(InfoArrayValue *)(*pHeartStart->pExPairPar);
                StartPairChild=*pHeartStart->pExPairPar+SIZE_INFO_STRUCT;
                
                for (int k=0; k<InfoPairPar->mCount; k++){
                    int iIndexPair=StartPairChild[k];
                    
                    if(StartStr->m_iIndex==iIndexPair)
                    {
//                        int iIndexChild=(*pHeartStart->pExPairChi+SIZE_INFO_STRUCT)[k];
//                        (*pHeartStart->pExPairPar+SIZE_INFO_STRUCT)[k]=iIndexChild;
//                        
//                        
//                        int **ppArrayTmp=[m_pObjMng->pStringContainer->ArrayPoints
//                                          GetArrayAtIndex:iIndexPair];
//                        InfoArrayValue *pArrayTmp=(InfoArrayValue *)*ppArrayTmp;
//                        
//                        if(pMatrEnd->TypeInformation==STR_OPERATION && pArrayTmp->mType!=DATA_U_INT)
//                        {
//                            int iIndexMatrLink=(*pMatrEnd->pValueCopy+SIZE_INFO_STRUCT)[3];
//                            MATRIXcell *pMatrLink=[m_pObjMng->pStringContainer->ArrayPoints
//                                                   GetMatrixAtIndex:iIndexMatrLink];
//                            InfoArrayValue *pInfoEnter=(InfoArrayValue *)*pMatrLink->pValueCopy;
//                            
//                            int iIndexMatrLink2=(*pMatrEnd->pValueCopy+SIZE_INFO_STRUCT)[2];
//                            MATRIXcell *pMatrLink2=[m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:iIndexMatrLink2];
//                            
//                            for (int p=0; p<pInfoEnter->mCount; p++)
//                            {
//                                int iIndexArrayLink=(*pMatrLink->pValueCopy+SIZE_INFO_STRUCT)[p];
//                                int **ArrayLink=[m_pObjMng->pStringContainer->ArrayPoints
//                                                 GetArrayAtIndex:iIndexArrayLink];
//                                
//                                int iRez=[m_pObjMng->pStringContainer->m_OperationIndex
//                                          FindIndex:k WithData:ArrayLink];
//                                
//                                if(iRez!=-1)
//                                {
//                                    InfoArrayValue *pInfoTmpLinkInside=(InfoArrayValue *)*ArrayLink;
//                                    for (int m=0; m<pInfoTmpLinkInside->mCount; m++)
//                                    {
//                                        int iTmpPlace=(*ArrayLink+SIZE_INFO_STRUCT)[m];
//                                        
//                                        int iIndexChild=(*pHeartStart->pExPairChi+
//                                                         SIZE_INFO_STRUCT)[iTmpPlace];
//                                        (*pHeartStart->pExPairPar+
//                                         SIZE_INFO_STRUCT)[iTmpPlace]=iIndexChild;
//                                    }
//                                    
//                                    int iIndexArrayLink2=(*pMatrLink2->pValueCopy+SIZE_INFO_STRUCT)[p];
//                                    int **ArrayLink2=[m_pObjMng->pStringContainer->ArrayPoints
//                                                      GetArrayAtIndex:iIndexArrayLink2];
//                                    
//                                    pInfoTmpLinkInside=(InfoArrayValue *)*ArrayLink2;
//                                    for (int m=0; m<pInfoTmpLinkInside->mCount; m++)
//                                    {
//                                        int iTmpPlace=(*ArrayLink2+SIZE_INFO_STRUCT)[m];
//                                        
//                                        int iIndexChild=(*pHeartStart->pEnPairChi+
//                                                         SIZE_INFO_STRUCT)[iTmpPlace];
//                                        (*pHeartStart->pEnPairPar+
//                                         SIZE_INFO_STRUCT)[iTmpPlace]=iIndexChild;
//                                        
//                                    }
//                                    
//                                    break;
//                                }
//                            }
//                        }

//                        MATRIXcell *pMatrZero=pMatrPar;
//                        [m_pObjMng->pStringContainer->m_OperationIndex
//                         RemoveAllConnections:nil RootMatr:pMatrZero SearchCurIndex:StartStr->m_iIndex];
                        
                        bFind=YES;
               //         goto Exit;
                    }
                }
Exit:
                if(bFind==YES){
//                    Ob_Editor_Interface *pObInterface = (Ob_Editor_Interface *)
//                    [m_pObjMng GetObjectByName:@"Ob_Editor_Interface"];
//
//                    [pObInterface UpdateB];
//                    return;
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
        
        if(pHeartStart->pNextPlace==-1)
        {
            pHeartStart->pNextPlace=PlaceEnd;
        }
        else
        {
            pHeartStart->pNextPlace=-1;
        }
    }
    
    OBJECT_PERFORM_SEL(@"Ob_Editor_Interface",@"UpdateB");
}
//------------------------------------------------------------------------------------------------------
-(void)AddObject{
    
    [[FractalString alloc] initWithName:@"Prop" WithParent:pFStringObjects WithContainer:self];
}
//------------------------------------------------------------------------------------------------------
-(NSString *)GetRndName{
        
    NSString *outstring = @"";
    NSString *allLetters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890";


repeate:

    for (int ii=0; ii<20; ii++) {
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
    
    CDataManager* pDataCurManager =[ArrayDumpFiles objectAtIndex:0];
    bool Rez=[pDataCurManager Load];
    [DicStrings removeAllObjects];

    int iLen=[pDataCurManager->m_pDataDmp length];
    if(iLen==0)
    {
#ifdef __EDITOR
        Rez=false;
#else
        pDataCurManager =[ArrayDumpFiles objectAtIndex:1];
        bool Rez=[pDataCurManager Load];
        iLen=[pDataCurManager->m_pDataDmp length];
        if(iLen==0)Rez=false;
#endif
    }
    
    if(iLen!=0){
        
        int iLenVersion = [pDataCurManager GetIntValue];

        switch (iLenVersion) {
            case 1:
            {
                //загрузка струн
                FractalString *pZeroString=[[FractalString alloc] initWithData:pDataCurManager->m_pDataDmp
                                WithCurRead:&pDataCurManager->m_iCurReadingPos
                                WithParent:nil WithContainer:self];
                                
                //загрузка матрицы
                [ArrayPoints selfLoad:pDataCurManager->m_pDataDmp
                                 rpos:&pDataCurManager->m_iCurReadingPos];
                
                [pZeroString PrepareMatrix:self WithStartString:pZeroString];

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
        
    [[FractalString alloc] initAsCopy:SourceStr
        WithParent:pFStringZero WithContainer:self WithSourceContainer:SourceContainer WithLink:NO];
}
//------------------------------------------------------------------------------------------------------
-(void)ReplaceStringOut2:(FractalString *)strDest strscr:(FractalString *)strSrc strings:(NSMutableArray *)pArray{
    
    MATRIXcell *pNewMatr=[ArrayPoints GetMatrixAtIndex:strDest->m_iIndex];
    MATRIXcell *DataMatrix=[ArrayPoints GetMatrixAtIndex:strSrc->m_iIndex];
    
    int **ppTmpArraySrc=[m_OperationIndex InitMemory];
    int **ppTmpArrayDest=[m_OperationIndex InitMemory];
    
    NSMutableArray *TmpArrDel=[[NSMutableArray alloc] init];
    for (int i=0; i<[pArray count]; i++) {
        NSNumber *pNum=[pArray objectAtIndex:i];
        
        int iIndex=(*strSrc->pChildString+SIZE_INFO_STRUCT)[[pNum intValue]];
        
        FractalString *pStrTmp=[ArrayPoints GetIdAtIndex:iIndex];
        [TmpArrDel addObject:pStrTmp];
        
        if(pStrTmp!=nil)
        {
            /*FractalString *pNewString=*/[[FractalString alloc] initAsCopy:pStrTmp
                                                             WithParent:strDest WithContainer:self
                                                    WithSourceContainer:self
                                                               WithLink:YES];
            
//            pNewString->X=RND_I_F(strSrc->X, 50);
//            pNewString->Y=RND_I_F(strSrc->Y, 50);
            
            InfoArrayValue *InfoStrQueueSelf=(InfoArrayValue *)(*pNewMatr->pQueue);
            
            if(InfoStrQueueSelf->mCount>0)
            {
                int *StartDataQueueSelf=((*pNewMatr->pQueue)+SIZE_INFO_STRUCT);
                int *StartDataQueue=((*DataMatrix->pQueue)+SIZE_INFO_STRUCT);
                
                HeartMatr *pHeartSelf=(HeartMatr *)StartDataQueueSelf[InfoStrQueueSelf->mCount-1];
                HeartMatr *pHeartData=(HeartMatr *)StartDataQueue[[pNum intValue]];
                
                if(pHeartSelf!=nil && pHeartData!=nil)
                {
                    //записываем места в queue для переименования
                    [m_OperationIndex OnlyAddData:[pNum intValue] WithData:ppTmpArraySrc];
                    [m_OperationIndex OnlyAddData:InfoStrQueueSelf->mCount-1 WithData:ppTmpArrayDest];
                    
                    [ArrayPoints CopyHeartData:pHeartSelf from:pHeartData];
                }
            }
        }
    }
    
    InfoArrayValue *TmpArraSrc=(InfoArrayValue *)*ppTmpArraySrc;
    int *StartDataQueueDest=((*pNewMatr->pQueue)+SIZE_INFO_STRUCT);
    int *StartDataQueueSrc=((*DataMatrix->pQueue)+SIZE_INFO_STRUCT);
    
    for (int i=0; i<TmpArraSrc->mCount; i++) {//настраиваем внутреннюю очередь
        int TmpPlace=(*ppTmpArrayDest+SIZE_INFO_STRUCT)[i];
        HeartMatr *pTmpHeart=StartDataQueueDest[TmpPlace];
        if(pTmpHeart->pNextPlace!=-1)
        {
            int iRet=[m_OperationIndex FindIndex:pTmpHeart->pNextPlace WithData:ppTmpArraySrc];
            
            if(iRet!=-1)
            {
                int INewPlace=(*ppTmpArrayDest+SIZE_INFO_STRUCT)[iRet];
                pTmpHeart->pNextPlace=INewPlace;
            }
            else
            {
                int iFind=[m_OperationIndex FindIndex:strDest->m_iIndexSelf
                                             WithData:strSrc->pChildString];
                if(iFind!=-1)
                {
                    HeartMatr *pHeratis=StartDataQueueSrc[iFind];
                    pHeratis->pNextPlace=pTmpHeart->pNextPlace;
                }
                pTmpHeart->pNextPlace=-1;
            }
        }
    }

    for (int i=0; i<[pArray count]; i++) {
        FractalString *pStrTmp=[TmpArrDel objectAtIndex:i];
        
        [self DelString:pStrTmp];
    }
    
    [TmpArrDel release];
    [m_OperationIndex ReleaseMemory:ppTmpArraySrc];
    [m_OperationIndex ReleaseMemory:ppTmpArrayDest];
    
    [self DelString:strSrc];
}
//------------------------------------------------------------------------------------------------------
-(void)ReplaceStringIn2:(FractalString *)strDest strscr:(FractalString *)strSrc strings:(NSMutableArray *)pArray{
    
    MATRIXcell *pNewMatr=[ArrayPoints GetMatrixAtIndex:strDest->m_iIndex];
    MATRIXcell *DataMatrix=[ArrayPoints GetMatrixAtIndex:strSrc->m_iIndex];
    
    int **ppTmpArraySrc=[m_OperationIndex InitMemory];
    int **ppTmpArrayDest=[m_OperationIndex InitMemory];
    
    NSMutableArray *TmpArrDel=[[NSMutableArray alloc] init];
    for (int i=0; i<[pArray count]; i++) {
        NSNumber *pNum=[pArray objectAtIndex:i];
        
        int iIndex=(*strSrc->pChildString+SIZE_INFO_STRUCT)[[pNum intValue]];
        
        FractalString *pStrTmp=[ArrayPoints GetIdAtIndex:iIndex];
        [TmpArrDel addObject:pStrTmp];
        
        if(pStrTmp!=nil)
        {
            /*FractalString *pNewString=*/[[FractalString alloc] initAsCopy:pStrTmp
                                                WithParent:strDest WithContainer:self
                                                WithSourceContainer:self
                                                    WithLink:YES];
            
            InfoArrayValue *InfoStrQueueSelf=(InfoArrayValue *)(*pNewMatr->pQueue);
            
            if(InfoStrQueueSelf->mCount>0)
            {
                int *StartDataQueueSelf=((*pNewMatr->pQueue)+SIZE_INFO_STRUCT);
                int *StartDataQueue=((*DataMatrix->pQueue)+SIZE_INFO_STRUCT);
                
                HeartMatr *pHeartSelf=(HeartMatr *)StartDataQueueSelf[InfoStrQueueSelf->mCount-1];
                HeartMatr *pHeartData=(HeartMatr *)StartDataQueue[[pNum intValue]];
                
                if(pHeartSelf!=nil && pHeartData!=nil)
                {
                    //записываем места в queue для переименования
                    [m_OperationIndex OnlyAddData:[pNum intValue] WithData:ppTmpArraySrc];
                    [m_OperationIndex OnlyAddData:InfoStrQueueSelf->mCount-1 WithData:ppTmpArrayDest];
                    
                    [ArrayPoints CopyHeartData:pHeartSelf from:pHeartData];
                }
            }
        }
    }
    
    InfoArrayValue *TmpArraSrc=(InfoArrayValue *)*ppTmpArraySrc;
    int *StartDataQueueDest=((*pNewMatr->pQueue)+SIZE_INFO_STRUCT);
    
    for (int i=0; i<TmpArraSrc->mCount; i++) {//настраиваем внутреннюю очередь
        int TmpPlace=(*ppTmpArrayDest+SIZE_INFO_STRUCT)[i];
        HeartMatr *pTmpHeart=StartDataQueueDest[TmpPlace];
        if(pTmpHeart->pNextPlace!=-1)
        {
            int iRet=[m_OperationIndex FindIndex:pTmpHeart->pNextPlace WithData:ppTmpArraySrc];
            
            if(iRet!=-1)
            {
                int INewPlace=(*ppTmpArrayDest+SIZE_INFO_STRUCT)[iRet];
                pTmpHeart->pNextPlace=INewPlace;
            }
            else pTmpHeart->pNextPlace=-1;
        }
    }
    
    //устраняем несвязанные параметры из сердец
    InfoArrayValue *pInfoDes=(InfoArrayValue*)*ppTmpArrayDest;
    for(int i=0;i<pInfoDes->mCount;i++)
    {
        int tmpPlace=(*ppTmpArrayDest+SIZE_INFO_STRUCT)[i];
        HeartMatr *pTmpHeart=StartDataQueueDest[tmpPlace];
        
        if(pTmpHeart!=nil)
        {
            InfoArrayValue *pInfoEnterPar=(InfoArrayValue*)*pTmpHeart->pEnPairPar;
            for (int j=0; j<pInfoEnterPar->mCount; j++) {
                int iIndex=(*pTmpHeart->pEnPairPar+SIZE_INFO_STRUCT)[j];
                
                int iRet=[m_OperationIndex FindIndex:iIndex WithData:pNewMatr->pValueCopy];
                if(iRet==-1 && iIndex>RESERV_KERNEL)
                {
                    int iIndex2=(*pTmpHeart->pEnPairChi+SIZE_INFO_STRUCT)[j];
                    (*pTmpHeart->pEnPairPar+SIZE_INFO_STRUCT)[j]=iIndex2;
                }
            }
            
            InfoArrayValue *pInfoExitPar=(InfoArrayValue*)*pTmpHeart->pExPairPar;
            for (int j=0; j<pInfoExitPar->mCount; j++) {
                int iIndex=(*pTmpHeart->pExPairPar+SIZE_INFO_STRUCT)[j];
                
                int iRet=[m_OperationIndex FindIndex:iIndex WithData:pNewMatr->pValueCopy];
                if(iRet==-1 && iIndex>RESERV_KERNEL)
                {
                    int iIndex2=(*pTmpHeart->pExPairChi+SIZE_INFO_STRUCT)[j];
                    (*pTmpHeart->pExPairPar+SIZE_INFO_STRUCT)[j]=iIndex2;
                }
            }
        }
    }
        
    [TmpArrDel release];
    [m_OperationIndex ReleaseMemory:ppTmpArraySrc];
    [m_OperationIndex ReleaseMemory:ppTmpArrayDest];
}
//------------------------------------------------------------------------------------------------------
-(void)ReplaceStringOut:(FractalString *)strDest strscr:(FractalString *)strSrc strings:(NSMutableArray *)pArray{
    
    MATRIXcell *pNewMatr=[ArrayPoints GetMatrixAtIndex:strDest->m_iIndex];
    MATRIXcell *DataMatrix=[ArrayPoints GetMatrixAtIndex:strSrc->m_iIndex];
    
    int **ppTmpArraySrc=[m_OperationIndex InitMemory];
    int **ppTmpArrayDest=[m_OperationIndex InitMemory];
    
    NSMutableArray *TmpArrDel=[[NSMutableArray alloc] init];
    for (int i=0; i<[pArray count]; i++) {
        NSNumber *pNum=[pArray objectAtIndex:i];
        
        int iIndex=(*strSrc->pChildString+SIZE_INFO_STRUCT)[[pNum intValue]];
        
        FractalString *pStrTmp=[ArrayPoints GetIdAtIndex:iIndex];
        [TmpArrDel addObject:pStrTmp];
        
        if(pStrTmp!=nil)
        {
            /*FractalString *pNewString=*/[[FractalString alloc] initAsCopy:pStrTmp
                                                                 WithParent:strDest WithContainer:self
                                                        WithSourceContainer:self
                                                                   WithLink:YES];
            
//            pNewString->X=RND_I_F(strSrc->X, 50);
//            pNewString->Y=RND_I_F(strSrc->Y, 50);
            
            InfoArrayValue *InfoStrQueueSelf=(InfoArrayValue *)(*pNewMatr->pQueue);
            
            if(InfoStrQueueSelf->mCount>0)
            {
                int *StartDataQueueSelf=((*pNewMatr->pQueue)+SIZE_INFO_STRUCT);
                int *StartDataQueue=((*DataMatrix->pQueue)+SIZE_INFO_STRUCT);
                
                HeartMatr *pHeartSelf=(HeartMatr *)StartDataQueueSelf[InfoStrQueueSelf->mCount-1];
                HeartMatr *pHeartData=(HeartMatr *)StartDataQueue[[pNum intValue]];
                
                if(pHeartSelf!=nil && pHeartData!=nil)
                {
                    //записываем места в queue для переименования
                    [m_OperationIndex OnlyAddData:[pNum intValue] WithData:ppTmpArraySrc];
                    [m_OperationIndex OnlyAddData:InfoStrQueueSelf->mCount-1 WithData:ppTmpArrayDest];
                    
                    [ArrayPoints CopyHeartData:pHeartSelf from:pHeartData];
                }
            }
        }
    }
    
    InfoArrayValue *TmpArraSrc=(InfoArrayValue *)*ppTmpArraySrc;
    int *StartDataQueueDest=((*pNewMatr->pQueue)+SIZE_INFO_STRUCT);
    int *StartDataQueueSrc=((*DataMatrix->pQueue)+SIZE_INFO_STRUCT);
    
    for (int i=0; i<TmpArraSrc->mCount; i++) {//настраиваем внутреннюю очередь
        int TmpPlace=(*ppTmpArrayDest+SIZE_INFO_STRUCT)[i];
        HeartMatr *pTmpHeart=StartDataQueueDest[TmpPlace];
        if(pTmpHeart->pNextPlace!=-1)
        {
            int iRet=[m_OperationIndex FindIndex:pTmpHeart->pNextPlace WithData:ppTmpArraySrc];
            
            if(iRet!=-1)
            {
                int INewPlace=(*ppTmpArrayDest+SIZE_INFO_STRUCT)[iRet];
                pTmpHeart->pNextPlace=INewPlace;
            }
            else
            {
                int iFind=[m_OperationIndex FindIndex:strDest->m_iIndexSelf
                                             WithData:strSrc->pChildString];
                if(iFind!=-1)
                {
                    HeartMatr *pHeratis=StartDataQueueSrc[iFind];
                    pHeratis->pNextPlace=pTmpHeart->pNextPlace;
                }
                pTmpHeart->pNextPlace=-1;
            }
        }
    }
    
    //сшиваем начальные связи, настраиваем точку входа
    InfoArrayValue *pArrayQueue=(InfoArrayValue*)*pNewMatr->pQueue;
    
    int iPlace=[m_OperationIndex FindIndex:strSrc->m_iIndex WithData:pNewMatr->pValueCopy];
    
    for(int i=0;i<pArrayQueue->mCount;i++)
    {
        HeartMatr *pTmpHeart=(*pNewMatr->pQueue+SIZE_INFO_STRUCT)[i];
        
        if(pTmpHeart!=nil && pTmpHeart->pNextPlace==iPlace)
        {
            int iStartPlace=(*DataMatrix->ppStartPlaces+SIZE_INFO_STRUCT)[0];
            
            int iRet=[m_OperationIndex FindIndex:iStartPlace WithData:ppTmpArraySrc];

            if(iRet!=-1)
            {
                pTmpHeart->pNextPlace=(*ppTmpArrayDest+SIZE_INFO_STRUCT)[iRet];
            }
            
            int iStartPlace2=(*pNewMatr->ppStartPlaces+SIZE_INFO_STRUCT)[0];
            
            if(iStartPlace2!=-1)
            {
                int iIndex2=(*pNewMatr->pValueCopy+SIZE_INFO_STRUCT)[iStartPlace2];
                
                if(strSrc->m_iIndex==iIndex2)
                {
                    int *pIPlace=(*pNewMatr->ppStartPlaces+SIZE_INFO_STRUCT);
                    *pIPlace=(*ppTmpArrayDest+SIZE_INFO_STRUCT)[iRet];
                }
            }
        }
    }
    
    [TmpArrDel release];
    [m_OperationIndex ReleaseMemory:ppTmpArraySrc];
    [m_OperationIndex ReleaseMemory:ppTmpArrayDest];
    
    [self DelString:strSrc];
}
//------------------------------------------------------------------------------------------------------
-(void)ReplaceStringIn:(FractalString *)strDest strscr:(FractalString *)strSrc strings:(NSMutableArray *)pArray{

    MATRIXcell *pNewMatr=[ArrayPoints GetMatrixAtIndex:strDest->m_iIndex];
    MATRIXcell *DataMatrix=[ArrayPoints GetMatrixAtIndex:strSrc->m_iIndex];
    
    int **ppTmpArraySrc=[m_OperationIndex InitMemory];
    int **ppTmpArrayDest=[m_OperationIndex InitMemory];

    NSMutableArray *TmpArrDel=[[NSMutableArray alloc] init];
    for (int i=0; i<[pArray count]; i++) {
        NSNumber *pNum=[pArray objectAtIndex:i];
        
        int iIndex=(*strSrc->pChildString+SIZE_INFO_STRUCT)[[pNum intValue]];
        
        FractalString *pStrTmp=[ArrayPoints GetIdAtIndex:iIndex];
        [TmpArrDel addObject:pStrTmp];
        
        if(pStrTmp!=nil)
        {
            /*FractalString *pNewString=*/[[FractalString alloc] initAsCopy:pStrTmp
                                    WithParent:strDest WithContainer:self
                                    WithSourceContainer:self
                                    WithLink:YES];

            InfoArrayValue *InfoStrQueueSelf=(InfoArrayValue *)(*pNewMatr->pQueue);
                        
            if(InfoStrQueueSelf->mCount>0)
            {
                int *StartDataQueueSelf=((*pNewMatr->pQueue)+SIZE_INFO_STRUCT);
                int *StartDataQueue=((*DataMatrix->pQueue)+SIZE_INFO_STRUCT);

                HeartMatr *pHeartSelf=(HeartMatr *)StartDataQueueSelf[InfoStrQueueSelf->mCount-1];
                HeartMatr *pHeartData=(HeartMatr *)StartDataQueue[[pNum intValue]];

                if(pHeartSelf!=nil && pHeartData!=nil)
                {
                    //записываем места в queue для переименования
                    [m_OperationIndex OnlyAddData:[pNum intValue] WithData:ppTmpArraySrc];
                    [m_OperationIndex OnlyAddData:InfoStrQueueSelf->mCount-1 WithData:ppTmpArrayDest];

                    [ArrayPoints CopyHeartData:pHeartSelf from:pHeartData];
                }
            }
        }
    }

    InfoArrayValue *TmpArraSrc=(InfoArrayValue *)*ppTmpArraySrc;
    int *StartDataQueueDest=((*pNewMatr->pQueue)+SIZE_INFO_STRUCT);
    int *StartDataQueueSrc=((*DataMatrix->pQueue)+SIZE_INFO_STRUCT);

    for (int i=0; i<TmpArraSrc->mCount; i++) {//настраиваем внутреннюю очередь
        int TmpPlace=(*ppTmpArrayDest+SIZE_INFO_STRUCT)[i];
        HeartMatr *pTmpHeart=StartDataQueueDest[TmpPlace];
        if(pTmpHeart->pNextPlace!=-1)
        {
            int iRet=[m_OperationIndex FindIndex:pTmpHeart->pNextPlace WithData:ppTmpArraySrc];
            
            if(iRet!=-1)
            {
                int INewPlace=(*ppTmpArrayDest+SIZE_INFO_STRUCT)[iRet];
                pTmpHeart->pNextPlace=INewPlace;
            }
            else
            {
                int iFind=[m_OperationIndex FindIndex:strDest->m_iIndexSelf
                                             WithData:strSrc->pChildString];
                if(iFind!=-1)
                {
                    HeartMatr *pHeratis=StartDataQueueSrc[iFind];
                    pHeratis->pNextPlace=pTmpHeart->pNextPlace;
                }
                pTmpHeart->pNextPlace=-1;
            }
        }
    }
    
    //сшиваем начальные связи, настраиваем точку входа
    MATRIXcell *pMatrSrc=[ArrayPoints GetMatrixAtIndex:strSrc->m_iIndex];
    InfoArrayValue *pArrayQueue=(InfoArrayValue*)*pMatrSrc->pQueue;

    for(int i=0;i<pArrayQueue->mCount;i++)
    {
        HeartMatr *pTmpHeart=(*pMatrSrc->pQueue+SIZE_INFO_STRUCT)[i];

        if(pTmpHeart!=nil && pTmpHeart->pNextPlace!=-1)
        {
            int iRet2=[m_OperationIndex FindIndex:i WithData:ppTmpArraySrc];

            if(iRet2==-1)
            {
                for (int k=0; k<[pArray count]; k++) {
                    NSNumber *pNumTmp=[pArray objectAtIndex:k];

                    if(pTmpHeart->pNextPlace==[pNumTmp intValue])
                    {
                        int iRet=[m_OperationIndex
                                  FindIndex:strDest->m_iIndexSelf WithData:strSrc->pChildString];
                        
                        int iRet2=[m_OperationIndex FindIndex:pTmpHeart->pNextPlace
                                                     WithData:ppTmpArraySrc];
                        pTmpHeart->pNextPlace=iRet;

                        MATRIXcell *pMatrDest=[ArrayPoints GetMatrixAtIndex:strDest->m_iIndex];

                        int tmpPlace=(*ppTmpArrayDest+SIZE_INFO_STRUCT)[iRet2];
                        (*pMatrDest->ppStartPlaces+SIZE_INFO_STRUCT)[0]=tmpPlace;
                    }
                }
            }
        }
    }

    //устраняем несвязанные параметры из сердец
    InfoArrayValue *pInfoDes=(InfoArrayValue*)*ppTmpArrayDest;
    for(int i=0;i<pInfoDes->mCount;i++)
    {
        int tmpPlace=(*ppTmpArrayDest+SIZE_INFO_STRUCT)[i];
        HeartMatr *pTmpHeart=StartDataQueueDest[tmpPlace];
        
        if(pTmpHeart!=nil)
        {
            InfoArrayValue *pInfoEnterPar=(InfoArrayValue*)*pTmpHeart->pEnPairPar;
            for (int j=0; j<pInfoEnterPar->mCount; j++) {
                int iIndex=(*pTmpHeart->pEnPairPar+SIZE_INFO_STRUCT)[j];
                
                int iRet=[m_OperationIndex FindIndex:iIndex WithData:pNewMatr->pValueCopy];
                if(iRet==-1 && iIndex>RESERV_KERNEL)
                {
                    int iIndex2=(*pTmpHeart->pEnPairChi+SIZE_INFO_STRUCT)[j];
                    (*pTmpHeart->pEnPairPar+SIZE_INFO_STRUCT)[j]=iIndex2;
                }
            }

            InfoArrayValue *pInfoExitPar=(InfoArrayValue*)*pTmpHeart->pExPairPar;
            for (int j=0; j<pInfoExitPar->mCount; j++) {
                int iIndex=(*pTmpHeart->pExPairPar+SIZE_INFO_STRUCT)[j];
                
                int iRet=[m_OperationIndex FindIndex:iIndex WithData:pNewMatr->pValueCopy];
                if(iRet==-1 && iIndex>RESERV_KERNEL)
                {
                    int iIndex2=(*pTmpHeart->pExPairChi+SIZE_INFO_STRUCT)[j];
                    (*pTmpHeart->pExPairPar+SIZE_INFO_STRUCT)[j]=iIndex2;
                }
            }
        }
    }
    
    for (int i=0; i<[pArray count]; i++) {
        FractalString *pStrTmp=[TmpArrDel objectAtIndex:i];
        
        [self DelString:pStrTmp];
    }
    
    [TmpArrDel release];
    [m_OperationIndex ReleaseMemory:ppTmpArraySrc];
    [m_OperationIndex ReleaseMemory:ppTmpArrayDest];
}
//------------------------------------------------------------------------------------------------------
-(void)DelChilds:(FractalString *)strDelChilds{
    
    int **Data=(strDelChilds->pChildString);
    int *StartData=((*Data)+SIZE_INFO_STRUCT);
    InfoArrayValue *InfoStr=(InfoArrayValue *)(*Data);
    int iCount=InfoStr->mCount;

    for (int i=0; i<iCount; i++) {

        StartData=((*strDelChilds->pChildString)+SIZE_INFO_STRUCT);

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
                          [m_OperationIndex RemoveDataAtPlace:i WithData:pMatr->pValueCopy];
//удаляем ассоциации=======================================================================================
                    if(pFrStr->pAssotiation!=nil)
                    {
                        if(TypeDel==DATA_MATRIX)
                        {
                            MATRIXcell *matrDel=[ArrayPoints GetMatrixAtIndex:strDel->m_iIndex];
                            NSNumber *pNumSource=[NSNumber numberWithInt:pFrStr->m_iIndexSelf];
                            [pFrStr->pAssotiation removeObjectForKey:pNumSource];
                            
                            NSArray *keys_Tmp = [pFrStr->pAssotiation allKeys];
                            FractalString *pNewParrent=nil;

                            for (int i=0; i<[keys_Tmp count]; i++) {
                                id aKey_Tmp = [keys_Tmp objectAtIndex:i];
                                
                                NSNumber *pNum_Tmp = [pFrStr->pAssotiation objectForKey:aKey_Tmp];
                                FractalString *StrTmp = [ArrayPoints
                                                                 GetIdAtIndex:[pNum_Tmp intValue]];
                                
                                FractalString *StrTmp2=StrTmp;

                                while (StrTmp!=strDel)
                                {
                                    if([StrTmp->pParent->strUID isEqualToString:@"Zero"])
                                    {
                                        pNewParrent=StrTmp2;
                                        goto Exit;
                                    }
                                    StrTmp = StrTmp->pParent;
                                }
                            }
Exit:
                            if(pNewParrent==nil)
                            {
//удаляем все ассоциации и саму струну

                                for (int i=0; i<[keys_Tmp count]; i++) {
                                    id aKey_Tmp = [keys_Tmp objectAtIndex:i];
                                    
                                    NSNumber *pNum_Tmp = [pFrStr->pAssotiation objectForKey:aKey_Tmp];
                                    FractalString *StrTmp = [ArrayPoints
                                                             GetIdAtIndex:[pNum_Tmp intValue]];
                                    
                                    NSString *pKey = [NSString stringWithFormat:@"%p",StrTmp->pAssotiation];
                                    [ArrayPoints->DicAllAssociations removeObjectForKey:pKey];

                                    NSNumber *pNumSourceTmp=[NSNumber
                                                             numberWithInt:StrTmp->m_iIndexSelf];
                                    [StrTmp->pAssotiation removeObjectForKey:pNumSourceTmp];
                                    [StrTmp->pAssotiation release];
                                    StrTmp->pAssotiation=0;
                                    StrTmp->pChildString=0;
                                }
                                
                                [pFrStr->pAssotiation release];
                                pFrStr->pAssotiation=0;
                            }
                            else
                            {
/////////////////////////////////удаляем только одну ассоциацию
//выставляем новый парент
                                int **DataChild=(strDel->pChildString);
                                if(DataChild!=NULL)
                                {
                                    InfoArrayValue *InfoStr_Childs=(InfoArrayValue *)(*DataChild);

                                    if(InfoStr_Childs->mCount>0){
                                        int *StartDataInDelChild=((*DataChild)+SIZE_INFO_STRUCT);

                                        int iChildInd=StartDataInDelChild[0];
                                        FractalString *ChildStrInDelString=[ArrayPoints GetIdAtIndex:iChildInd];

                                        if(ChildStrInDelString->pParent==strDel)
                                        {
                                            if(matrDel!=nil)
                                                matrDel->iIndexString=pNewParrent->m_iIndexSelf;
                                            
                                            for (int i=0; i<InfoStr_Childs->mCount; i++) {
                                                
                                                iChildInd=StartDataInDelChild[i];
                                                FractalString *Tmp_Str = [ArrayPoints
                                                                          GetIdAtIndex:iChildInd];
                                                Tmp_Str->pParent=pNewParrent;
                                            }
                                        }
                                    }
                                }
///////////////////////////////////////////
                                if([pFrStr->pAssotiation count]==1)
                                {
                                    NSArray *keys = [pFrStr->pAssotiation allKeys];
                                    id aKey = [keys objectAtIndex:0];
                                    NSNumber *pNum = [pFrStr->pAssotiation objectForKey:aKey];
                                    FractalString *TmpStr = [ArrayPoints GetIdAtIndex:[pNum intValue]];
                                    
                                    NSString *pKey = [NSString stringWithFormat:@"%p",TmpStr->pAssotiation];
                                    [ArrayPoints->DicAllAssociations removeObjectForKey:pKey];
                                    
                                    NSNumber *pNumSourceTmp=[NSNumber
                                                             numberWithInt:TmpStr->m_iIndexSelf];
                                    [pFrStr->pAssotiation removeObjectForKey:pNumSourceTmp];
                                    
                                    [TmpStr->pAssotiation release];
                                    TmpStr->pAssotiation=nil;
                                }
                            }
                        }
//=======================================================================================================
                        else
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

                                    NSNumber *pNumSourceTmp=[NSNumber
                                                             numberWithInt:TmpStr->m_iIndexSelf];
                                    [pFrStr->pAssotiation removeObjectForKey:pNumSourceTmp];
                                    
                                    [TmpStr->pAssotiation release];
                                    TmpStr->pAssotiation=nil;
                            }
                        }
                    }
//=========================================================================================================
                    //удаляемся из парента саму струну
                    [m_OperationIndex RemoveDataAtPlace:i WithData:Data];
                    
                    NSString *pKey = [NSString stringWithFormat:@"%d",pFrStr->m_iIndexSelf];
                    [ArrayPoints->pNamesOb removeObjectForKey:pKey];
                    [DicStrings removeObjectForKey:pFrStr->strUID];
                    [pFrStr release];

                    return;
                }
            }
        }
        else
        {
//            [ArrayPoints DecDataAtIndex:strDel->m_iIndex];
//            [ArrayPoints DecDataAtIndex:strDel->m_iIndexSelf];
            NSString *pKey = [NSString stringWithFormat:@"%d",strDel->m_iIndexSelf];
            [ArrayPoints->pNamesOb removeObjectForKey:pKey];
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
    
    for (CDataManager *pManager in ArrayDumpFiles) {
        [pManager release];
    }
    [ArrayDumpFiles release];
    
    [pMainCycle release];
    [pKernel release];
    [ArrayPoints release];
    [m_OperationIndex release];

    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
@end