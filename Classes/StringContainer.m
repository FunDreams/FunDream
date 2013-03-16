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
        
        pParMatrixStack=[m_OperationIndex InitMemory];
        pCurPlaceStack=[m_OperationIndex InitMemory];

        DicStrings = [[NSMutableDictionary alloc] init];
        DicLog = [[NSMutableDictionary alloc] init];

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
-(void)AddSmallCube:(FractalString *)pFParent{
    MATRIXcell *pMatrObject=[ArrayPoints GetMatrixAtIndex:pFParent->m_iIndex];
    
    FractalString *pStrSprite=[[FractalString alloc]
                              initWithName:@"Sprite" WithParent:pFParent WithContainer:self];
    
    [pStrSprite SetNameIcon:@"A.png"];
    pStrSprite->X=-220;
    pStrSprite->Y=-200;
    
    pStrSprite->m_iIndex=[ArrayPoints SetSprite:0];
    [m_OperationIndex AddData:pStrSprite->m_iIndex WithData:pMatrObject->pValueCopy];

//--------------------------------------------------------------------------------------
    FractalString *pStrUpdate=[[FractalString alloc]
                             initWithName:@"Update" WithParent:pFParent WithContainer:self];
    pStrUpdate->m_iIndex=12;
    MATRIXcell *pMatrUpdate=[ArrayPoints GetMatrixAtIndex:pStrUpdate->m_iIndex];
    
    int index=(*pMatrUpdate->pValueCopy+SIZE_INFO_STRUCT)[0];
    NSMutableString *pNameIcon=[m_pObjMng->pStringContainer->ArrayPoints
                                GetIdAtIndex:index];
    [m_OperationIndex AddData:pStrUpdate->m_iIndex WithData:pMatrObject->pValueCopy];
    
    [pStrUpdate SetNameIcon:pNameIcon];
    pStrUpdate->X=-250;
    pStrUpdate->Y=70;
//--------------------------------------------------------------------------------------
    FractalString *pStrDraw=[[FractalString alloc]
                               initWithName:@"Draw" WithParent:pFParent WithContainer:self];
    pStrDraw->m_iIndex=24;
    MATRIXcell *pMatrDraw=[ArrayPoints GetMatrixAtIndex:pStrDraw->m_iIndex];
    
    index=(*pMatrDraw->pValueCopy+SIZE_INFO_STRUCT)[0];
    pNameIcon=[m_pObjMng->pStringContainer->ArrayPoints
                                GetIdAtIndex:index];
    [m_OperationIndex AddData:pStrDraw->m_iIndex WithData:pMatrObject->pValueCopy];
    
    [pStrDraw SetNameIcon:pNameIcon];
    pStrDraw->X=-250;
    pStrDraw->Y=0;

    
    FractalString *pStrMove=[[FractalString alloc]
                             initWithName:@"Move" WithParent:pFParent WithContainer:self];
    pStrMove->m_iIndex=29;
    MATRIXcell *pMatrMove=[ArrayPoints GetMatrixAtIndex:pStrMove->m_iIndex];
    
    index=(*pMatrMove->pValueCopy+SIZE_INFO_STRUCT)[0];
    pNameIcon=[m_pObjMng->pStringContainer->ArrayPoints
               GetIdAtIndex:index];
    [m_OperationIndex AddData:pStrMove->m_iIndex WithData:pMatrObject->pValueCopy];
    
    [pStrMove SetNameIcon:pNameIcon];
    pStrMove->X=-350;
    pStrMove->Y=0;

    
    FractalString *pStrMoveOrbit=[[FractalString alloc]
                             initWithName:@"MoveOrbit" WithParent:pFParent WithContainer:self];
    pStrMoveOrbit->m_iIndex=35;
    MATRIXcell *pMatrMoveOrbit=[ArrayPoints GetMatrixAtIndex:pStrMoveOrbit->m_iIndex];
    
    index=(*pMatrMoveOrbit->pValueCopy+SIZE_INFO_STRUCT)[0];
    pNameIcon=[m_pObjMng->pStringContainer->ArrayPoints
               GetIdAtIndex:index];
    [m_OperationIndex AddData:pStrMoveOrbit->m_iIndex WithData:pMatrObject->pValueCopy];
    
    [pStrMoveOrbit SetNameIcon:pNameIcon];
    pStrMoveOrbit->X=-350;
    pStrMoveOrbit->Y=-100;

    
    FractalString *pStrAddVector=[[FractalString alloc]
                                  initWithName:@"AddVector" WithParent:pFParent WithContainer:self];
    pStrAddVector->m_iIndex=49;
    MATRIXcell *pMatrAddVector=[ArrayPoints GetMatrixAtIndex:pStrAddVector->m_iIndex];
    
    index=(*pMatrAddVector->pValueCopy+SIZE_INFO_STRUCT)[0];
    pNameIcon=[m_pObjMng->pStringContainer->ArrayPoints
               GetIdAtIndex:index];
    [m_OperationIndex AddData:pStrAddVector->m_iIndex WithData:pMatrObject->pValueCopy];
    
    [pStrAddVector SetNameIcon:pNameIcon];
    pStrAddVector->X=-350;
    pStrAddVector->Y=-200;


    //текстура
    FractalString *pStrTexture=[[FractalString alloc]
                           initWithName:@"Texture" WithParent:pFParent WithContainer:self];

    [pStrTexture SetNameIcon:@"R.png"];
    pStrTexture->X=-100;
    pStrTexture->Y=-130;

    NSMutableString *StrTexture=[[NSMutableString alloc] initWithString:@"5.png"];
    pStrTexture->m_iIndex=[ArrayPoints SetTexture:StrTexture];
    [m_OperationIndex AddData:pStrTexture->m_iIndex WithData:pMatrObject->pValueCopy];
//--------------------------------------------------------------------------------------
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
    
//  return;
//--------------------------------------------------------------------------------------------------
//    FractalString *pStrIngib=[[FractalString alloc]
//                            initWithName:@"StartActive" WithParent:pStrInfo WithContainer:self];
//    
//    [pStrIngib SetNameIcon:@"StartActivity.png"];
//    pStrIngib->X=-400;
//    pStrIngib->Y=130;
//    
//    pStrIngib->m_iIndex=[ArrayPoints SetMatrix:0];
//    [m_OperationIndex AddData:pStrIngib->m_iIndex WithData:pMatrInfo->pValueCopy];
//    MATRIXcell *pMatr=[ArrayPoints GetMatrixAtIndex:pStrIngib->m_iIndex];
//    pMatr->TypeInformation=STR_CONTAINER;
//    pMatr->NameInformation=NAME_K_START;
//
//    FractalString *pStrButton=[[FractalString alloc]
//                            initWithName:@"Action" WithParent:pStrInfo WithContainer:self];
//
//    [pStrButton SetNameIcon:@"ButtonAction.png"];
//    pStrButton->X=-300;
//    pStrButton->Y=130;
//    
//    pStrButton->m_iIndex=[ArrayPoints SetMatrix:0];
//    [m_OperationIndex AddData:pStrButton->m_iIndex WithData:pMatrInfo->pValueCopy];
//    pMatr=[ArrayPoints GetMatrixAtIndex:pStrButton->m_iIndex];
//    pMatr->TypeInformation=STR_CONTAINER;
//    pMatr->NameInformation=NAME_K_BUTTON_ENVENT;
//

    FractalString *pStrPlus=[[FractalString alloc]
                            initWithName:@"Plus" WithParent:pStrInfo WithContainer:self];
    pStrPlus->m_iIndex=4;
    MATRIXcell *pMatrPlus=[ArrayPoints GetMatrixAtIndex:pStrPlus->m_iIndex];
        
    index=(*pMatrPlus->pValueCopy+SIZE_INFO_STRUCT)[0];
    pNameIcon=[m_pObjMng->pStringContainer->ArrayPoints
                            GetIdAtIndex:index];
    [m_OperationIndex AddData:pStrPlus->m_iIndex WithData:pMatrInfo->pValueCopy];

    [pStrPlus SetNameIcon:pNameIcon];
    pStrPlus->X=-350;
    pStrPlus->Y=50;
    

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
    
    
//    //----------------------------------------------------------------------
//    InfoArrayValue *InfoQueue=(InfoArrayValue *)(*pMatrInfo->pQueue);
//    int *StartDataQueue=((*pMatrInfo->pQueue)+SIZE_INFO_STRUCT);
//    
//    for(int i=0;i<InfoQueue->mCount;i++){
//        HeartMatr *pHeart=StartDataQueue[i];
//        int m=0;
//    }
//    //----------------------------------------------------------------------
}
//------------------------------------------------------------------------------------------------------
#define MAX_REZERV 4000
-(void)InitIndex{//линкуем константы к контейнеру
    FractalString *pFStringZero = [self GetString:@"Zero"];
    if(pFStringZero!=nil){
        
        pDeltaTime = [ArrayPoints GetDataAtIndex:2];        
        iIndexMaxSys=MAX_REZERV+2;//202
    }
}
//------------------------------------------------------------------------------------------------------
-(void)SetKernel{//устанавливаем константы для ядра (эти индексы не переименовываются)
    FractalString *pFStringZero=[[FractalString alloc]
                                 initWithName:@"Zero" WithParent:nil WithContainer:self];
    pFStringZero->m_iIndex=[ArrayPoints SetMatrix:0];
    [ArrayPoints IncDataAtIndex:pFStringZero->m_iIndex];
    MATRIXcell *pMatrZero=[ArrayPoints GetMatrixAtIndex:pFStringZero->m_iIndex];
////////////////////////////////////////////////////////////////////////////////////////////////////
    //zero point
    int iZeroPoint=[ArrayPoints SetFloat:0];//1
    [m_OperationIndex AddData:iZeroPoint WithData:pMatrZero->pValueCopy];

    //delta time
    int iDeltaTime=[ArrayPoints SetFloat:0.0f];//2
    [m_OperationIndex AddData:iDeltaTime WithData:pMatrZero->pValueCopy];
    
//операции -----------------------------------------------------------------------------------------
    int m_iIndexOpetations=[ArrayPoints SetMatrix:0];//матрица списка всех операций
    MATRIXcell *pMatrOperations=[ArrayPoints GetMatrixAtIndex:m_iIndexOpetations];
    [m_OperationIndex AddData:m_iIndexOpetations WithData:pMatrZero->pValueCopy];
//операция "плюс"----------------------------------------------------------------------------------
    int IndexMatrPlus=[ArrayPoints SetMatrix:0];//4
    MATRIXcell *pMatrPlus=[ArrayPoints GetMatrixAtIndex:IndexMatrPlus];
    pMatrPlus->TypeInformation=STR_OPERATION;
    pMatrPlus->NameInformation=NAME_O_PLUS;
    
    //заглавный смысл
    NSMutableString *pNameIcon = [NSMutableString stringWithString:@"o_plus.png"];
    int iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrPlus->pValueCopy];
//Enter===============================================================================================
    int iIndexA=[ArrayPoints SetFloat:0];//A
    [m_OperationIndex AddData:iIndexA WithData:pMatrPlus->pValueCopy];
    pNameIcon = [NSMutableString stringWithString:@"_A.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrPlus->pValueCopy];

    int iIndexB=[ArrayPoints SetFloat:0];//B
    [m_OperationIndex AddData:iIndexB WithData:pMatrPlus->pValueCopy];
    pNameIcon = [NSMutableString stringWithString:@"_B.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrPlus->pValueCopy];
    
    [m_OperationIndex OnlyAddData:iIndexA  WithData:pMatrPlus->pEnters];
    [m_OperationIndex OnlyAddData:iIndexB  WithData:pMatrPlus->pEnters];
//exit===============================================================================================
    int iIndexR=[ArrayPoints SetFloat:0];//R
    [m_OperationIndex AddData:iIndexR WithData:pMatrPlus->pValueCopy];
    pNameIcon = [NSMutableString stringWithString:@"_R.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    
    [m_OperationIndex AddData:pMatrPlus->iIndexSelf WithData:pMatrOperations->pValueCopy];
//операция "update"----------------------------------------------------------------------------------
    int IndexMatrUpdate=[ArrayPoints SetMatrix:0];//12
    MATRIXcell *pMatrUpdate=[ArrayPoints GetMatrixAtIndex:IndexMatrUpdate];
    pMatrUpdate->TypeInformation=STR_OPERATION;
    pMatrUpdate->NameInformation=NAME_O_UPDATE_XY;
    
    //заглавный смысл
    pNameIcon = [NSMutableString stringWithString:@"_updateSprite.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrUpdate->pValueCopy];
//Enter===============================================================================================
    int iIndexX=[ArrayPoints SetFloat:0];//X
    [m_OperationIndex AddData:iIndexX WithData:pMatrUpdate->pValueCopy];
    pNameIcon = [NSMutableString stringWithString:@"_X.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrUpdate->pValueCopy];
    
    int iIndexY=[ArrayPoints SetFloat:0];//Y
    [m_OperationIndex AddData:iIndexY WithData:pMatrUpdate->pValueCopy];
    pNameIcon = [NSMutableString stringWithString:@"_Y.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrUpdate->pValueCopy];

    int iIndexW=[ArrayPoints SetFloat:0];//W
    [m_OperationIndex AddData:iIndexW WithData:pMatrUpdate->pValueCopy];
    pNameIcon = [NSMutableString stringWithString:@"_W.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrUpdate->pValueCopy];
    
    int iIndexH=[ArrayPoints SetFloat:0];//H
    [m_OperationIndex AddData:iIndexH WithData:pMatrUpdate->pValueCopy];
    pNameIcon = [NSMutableString stringWithString:@"_H.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrUpdate->pValueCopy];
    
    int iIndexSpriteZero=[ArrayPoints SetSprite:0];//Zero Sprite
    [m_OperationIndex AddData:iIndexSpriteZero WithData:pMatrUpdate->pValueCopy];
    pNameIcon = [NSMutableString stringWithString:@"_S.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrUpdate->pValueCopy];

    [m_OperationIndex OnlyAddData:iIndexX  WithData:pMatrUpdate->pEnters];
    [m_OperationIndex OnlyAddData:iIndexY  WithData:pMatrUpdate->pEnters];
    [m_OperationIndex OnlyAddData:iIndexW  WithData:pMatrUpdate->pEnters];
    [m_OperationIndex OnlyAddData:iIndexH  WithData:pMatrUpdate->pEnters];
    [m_OperationIndex OnlyAddData:iIndexSpriteZero  WithData:pMatrUpdate->pEnters];
    
    [m_OperationIndex AddData:pMatrUpdate->iIndexSelf WithData:pMatrOperations->pValueCopy];
//операция "draw"----------------------------------------------------------------------------------
    int IndexMatrDraw=[ArrayPoints SetMatrix:0];//24
    MATRIXcell *pMatrDraw=[ArrayPoints GetMatrixAtIndex:IndexMatrDraw];
    pMatrDraw->TypeInformation=STR_OPERATION;
    pMatrDraw->NameInformation=NAME_O_DRAW;
    
    //заглавный смысл
    pNameIcon = [NSMutableString stringWithString:@"_draw.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrDraw->pValueCopy];
//Enter===============================================================================================
    NSMutableString *NameTexture=[NSMutableString stringWithString:@""];
    int iNameTex=[ArrayPoints SetTexture:NameTexture];//Texture
    [m_OperationIndex AddData:iNameTex WithData:pMatrDraw->pValueCopy];
    pNameIcon = [NSMutableString stringWithString:@"_T.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrDraw->pValueCopy];
    
    [m_OperationIndex AddData:iIndexSpriteZero WithData:pMatrDraw->pValueCopy];
    pNameIcon = [NSMutableString stringWithString:@"_S.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrDraw->pValueCopy];
    
    [m_OperationIndex OnlyAddData:iNameTex  WithData:pMatrDraw->pEnters];
    [m_OperationIndex OnlyAddData:iIndexSpriteZero  WithData:pMatrDraw->pEnters];
    
    [m_OperationIndex AddData:pMatrDraw->iIndexSelf WithData:pMatrOperations->pValueCopy];
//операция "Прямолинейное движение"------------------------------------------------------------------
    int IndexMatrMove=[ArrayPoints SetMatrix:0];//29
    MATRIXcell *pMatrMove=[ArrayPoints GetMatrixAtIndex:IndexMatrMove];
    pMatrMove->TypeInformation=STR_OPERATION;
    pMatrMove->NameInformation=NAME_O_MOVE;
    
    //заглавный смысл
    pNameIcon = [NSMutableString stringWithString:@"_MoveLine.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrMove->pValueCopy];
//Enter===============================================================================================
    int iIndexV=[ArrayPoints SetFloat:0];//V
    [m_OperationIndex AddData:iIndexV WithData:pMatrMove->pValueCopy];
    pNameIcon = [NSMutableString stringWithString:@"_V.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrMove->pValueCopy];
    
    [m_OperationIndex OnlyAddData:iIndexV  WithData:pMatrMove->pEnters];
//exit===============================================================================================
    iIndexR=[ArrayPoints SetFloat:0];//R
    [m_OperationIndex AddData:iIndexR WithData:pMatrMove->pValueCopy];
    pNameIcon = [NSMutableString stringWithString:@"_R.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrMove->pValueCopy];
    
    [m_OperationIndex OnlyAddData:iIndexR  WithData:pMatrMove->pExits];
    
    [m_OperationIndex AddData:pMatrMove->iIndexSelf WithData:pMatrOperations->pValueCopy];
//операция "движение по окружности"-----------------------------------------------------------------
    int IndexMatrMoveOrbit=[ArrayPoints SetMatrix:0];//35
    MATRIXcell *pMatrMoveOrbit=[ArrayPoints GetMatrixAtIndex:IndexMatrMoveOrbit];
    pMatrMoveOrbit->TypeInformation=STR_OPERATION;
    pMatrMoveOrbit->NameInformation=NAME_O_MOVE_ORBIT;
    
    //заглавный смысл
    pNameIcon = [NSMutableString stringWithString:@"_MoveOrbit.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrMoveOrbit->pValueCopy];
//Enter===============================================================================================
    iIndexX=[ArrayPoints SetFloat:0];//X
    [m_OperationIndex AddData:iIndexX WithData:pMatrMoveOrbit->pValueCopy];
    pNameIcon = [NSMutableString stringWithString:@"_X.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrMoveOrbit->pValueCopy];

    iIndexY=[ArrayPoints SetFloat:0];//Y
    [m_OperationIndex AddData:iIndexY WithData:pMatrMoveOrbit->pValueCopy];
    pNameIcon = [NSMutableString stringWithString:@"_Y.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrMoveOrbit->pValueCopy];

    iIndexR=[ArrayPoints SetFloat:0];//R
    [m_OperationIndex AddData:iIndexR WithData:pMatrMoveOrbit->pValueCopy];
    pNameIcon = [NSMutableString stringWithString:@"_R.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrMoveOrbit->pValueCopy];

    iIndexA=[ArrayPoints SetFloat:0];//A
    [m_OperationIndex AddData:iIndexA WithData:pMatrMoveOrbit->pValueCopy];
    pNameIcon = [NSMutableString stringWithString:@"_A.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrMoveOrbit->pValueCopy];

    [m_OperationIndex OnlyAddData:iIndexX  WithData:pMatrMoveOrbit->pEnters];
    [m_OperationIndex OnlyAddData:iIndexY  WithData:pMatrMoveOrbit->pEnters];
    [m_OperationIndex OnlyAddData:iIndexR  WithData:pMatrMoveOrbit->pEnters];
    [m_OperationIndex OnlyAddData:iIndexA  WithData:pMatrMoveOrbit->pEnters];
//exit==========================================================================================
    iIndexX=[ArrayPoints SetFloat:0];//X
    [m_OperationIndex AddData:iIndexX WithData:pMatrMoveOrbit->pValueCopy];
    pNameIcon = [NSMutableString stringWithString:@"_X.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrMoveOrbit->pValueCopy];

    iIndexY=[ArrayPoints SetFloat:0];//Y
    [m_OperationIndex AddData:iIndexX WithData:pMatrMoveOrbit->pValueCopy];
    pNameIcon = [NSMutableString stringWithString:@"_Y.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrMoveOrbit->pValueCopy];

    [m_OperationIndex OnlyAddData:iIndexX  WithData:pMatrMoveOrbit->pExits];
    [m_OperationIndex OnlyAddData:iIndexY  WithData:pMatrMoveOrbit->pExits];
    
    [m_OperationIndex AddData:pMatrMoveOrbit->iIndexSelf WithData:pMatrOperations->pValueCopy];
//операция "сложение векторов"----------------------------------------------------------------------------
    int IndexMatrAddVector=[ArrayPoints SetMatrix:0];//49
    MATRIXcell *pMatrAddVector=[ArrayPoints GetMatrixAtIndex:IndexMatrAddVector];
    pMatrAddVector->TypeInformation=STR_OPERATION;
    pMatrAddVector->NameInformation=NAME_O_PLUS_VECTOR;
    
    //заглавный смысл
    pNameIcon = [NSMutableString stringWithString:@"_peXY.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrAddVector->pValueCopy];
    //Enter===============================================================================================
    iIndexX=[ArrayPoints SetFloat:0];//X
    [m_OperationIndex AddData:iIndexX WithData:pMatrAddVector->pValueCopy];
    pNameIcon = [NSMutableString stringWithString:@"_X.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrAddVector->pValueCopy];
    
    iIndexY=[ArrayPoints SetFloat:0];//Y
    [m_OperationIndex AddData:iIndexY WithData:pMatrAddVector->pValueCopy];
    pNameIcon = [NSMutableString stringWithString:@"_Y.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrAddVector->pValueCopy];
    
    [m_OperationIndex OnlyAddData:iIndexX  WithData:pMatrAddVector->pEnters];
    [m_OperationIndex OnlyAddData:iIndexY  WithData:pMatrAddVector->pEnters];
    //exit===============================================================================================
    iIndexX=[ArrayPoints SetFloat:0];//X
    [m_OperationIndex AddData:iIndexX WithData:pMatrAddVector->pValueCopy];
    pNameIcon = [NSMutableString stringWithString:@"_X.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrAddVector->pValueCopy];

    iIndexY=[ArrayPoints SetFloat:0];//Y
    [m_OperationIndex AddData:iIndexY WithData:pMatrAddVector->pValueCopy];
    pNameIcon = [NSMutableString stringWithString:@"_Y.png"];
    iIndIconName=[ArrayPoints SetName:pNameIcon];
    [m_OperationIndex AddData:iIndIconName WithData:pMatrAddVector->pValueCopy];

    [m_OperationIndex OnlyAddData:iIndexX  WithData:pMatrAddVector->pExits];
    [m_OperationIndex OnlyAddData:iIndexY  WithData:pMatrAddVector->pExits];
    
    [m_OperationIndex AddData:pMatrAddVector->iIndexSelf WithData:pMatrOperations->pValueCopy];
//=================================================================================================
////////////////////////////////////////////////////////////////////////////////////////////////////
    //резервируем константы ядра
    for (int i=0; i<MAX_REZERV; i++) {
        int iIndexRezerv=[ArrayPoints SetFloat:0.0f];
        [m_OperationIndex AddData:iIndexRezerv WithData:pMatrZero->pValueCopy];
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
-(void)Update:(FractalString *)StartString{
//главный цикл обработки матрицы
        
    short iCurrentPlace;
    int iCurrentIndex;
    int *pQueue;
    HeartMatr *pHeart;
    InfoArrayValue *pInfoTmp;
    NSMutableString *pName;
    
    TextureContainer *pNum;
    int *I1;//,*I2,*I3;
    float *F1,*F2,*F3,*F4,*F5,*F6;
    int iIndexValue,iTextureName=-1;
    
    InfoArrayValue *InfoParMatrix=(InfoArrayValue *)(*pParMatrixStack);
    InfoArrayValue *InfoCurPlace=(InfoArrayValue *)(*pCurPlaceStack);
    
    int *StartDataParMatrix=((*pParMatrixStack)+SIZE_INFO_STRUCT);
    int *StartDataCurPlace=((*pCurPlaceStack)+SIZE_INFO_STRUCT);
//------------------------------------------------------------------------------------
    if(StartString==nil)return;
    MATRIXcell *pParMatrix=[ArrayPoints GetMatrixAtIndex:StartString->m_iIndex];
    if(pParMatrix->sStartPlace==-1)return;
    iCurrentPlace=pParMatrix->sStartPlace;

    int IndexInside=((*pParMatrix->pValueCopy) + SIZE_INFO_STRUCT)[pParMatrix->sStartPlace];
    MATRIXcell *pCurrentMatr=[ArrayPoints GetMatrixAtIndex:IndexInside];
    if(pCurrentMatr==nil)return;
        
    pQueue=(*pParMatrix->pQueue)+SIZE_INFO_STRUCT;
    pHeart=(HeartMatr *)pQueue[iCurrentPlace];

LOOP://бесконечный цикл
    
    switch (pCurrentMatr->TypeInformation)
    {
//операции===========================================================================
        case STR_OPERATION:

            switch (pCurrentMatr->NameInformation)
            {
//операция плюс----------------------------------------------------------------------
                case NAME_O_PLUS:
                    
                    iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[0];//A
                    F1=(ArrayPoints->pData+iIndexValue);
                    
                    iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[1];//B
                    F2=(ArrayPoints->pData+iIndexValue);
                    
                    iIndexValue=((*pHeart->pExPairPar)+SIZE_INFO_STRUCT)[0];//R
                    F3=(ArrayPoints->pData+iIndexValue);
                    
                    *F3+= *F1+ *F2;//плюсование
                    break;
//операция update---------------------------------------------------------------------
                case NAME_O_UPDATE_XY:
                    
                    iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[0];//X
                    F1=(ArrayPoints->pData+iIndexValue);
                    
                    iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[1];//Y
                    F2=(ArrayPoints->pData+iIndexValue);

                    iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[2];//W
                    F3=(ArrayPoints->pData+iIndexValue);
                    
                    iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[3];//H
                    F4=(ArrayPoints->pData+iIndexValue);

                    iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[4];//Sprite
                    I1=((int *)ArrayPoints->pData+iIndexValue);

                    [ArrayPoints->pCurrenContPar UpdateSpriteVertex:*I1 X:*F1 Y:*F2 W:*F3 H:*F4];
                    break;
//операция draw---------------------------------------------------------------------
                case NAME_O_DRAW:

                    iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[0];//texture
                    pName=*((id *)(ArrayPoints->pData+iIndexValue));
                                        
                    pNum=[m_pObjMng->m_pParent->m_pTextureList objectForKey:pName];
                    if(pNum!=nil)iTextureName=pNum->m_iTextureId;
                    else iTextureName=-1;

                    iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[1];//Sprite
                    I1=((int *)ArrayPoints->pData+iIndexValue);
                    
                    [ArrayPoints->pCurrenContPar DrawSprite:*I1 tex:iTextureName];
                    break;
//операция move---------------------------------------------------------------------
                case NAME_O_MOVE:
                    
                    iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[0];//V
                    F1=(ArrayPoints->pData+iIndexValue);
                    
                    iIndexValue=((*pHeart->pExPairPar)+SIZE_INFO_STRUCT)[0];//R
                    F2=(ArrayPoints->pData+iIndexValue);
                    
                    *F2+=*F1*(*pDeltaTime);
                    
                    break;

                case NAME_O_MOVE_ORBIT:
                    
                    iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[0];//X0
                    F1=(ArrayPoints->pData+iIndexValue);

                    iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[1];//Y0
                    F2=(ArrayPoints->pData+iIndexValue);

                    iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[2];//R
                    F3=(ArrayPoints->pData+iIndexValue);

                    iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[3];//A
                    F4=(ArrayPoints->pData+iIndexValue);

                    iIndexValue=((*pHeart->pExPairPar)+SIZE_INFO_STRUCT)[0];//X
                    F5=(ArrayPoints->pData+iIndexValue);

                    iIndexValue=((*pHeart->pExPairPar)+SIZE_INFO_STRUCT)[1];//Y
                    F6=(ArrayPoints->pData+iIndexValue);

                    float fSin=sinf(*F4);
                    float fCos=cosf(*F4);
                    
                    *F5=*F1+*F3*(fCos);
                    *F6=*F2+*F3*(fSin);
                    
                    break;

                case NAME_O_PLUS_VECTOR:
                    
                    iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[0];//X0
                    F1=(ArrayPoints->pData+iIndexValue);
                    
                    iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[1];//Y0
                    F2=(ArrayPoints->pData+iIndexValue);
                    
                    iIndexValue=((*pHeart->pExPairPar)+SIZE_INFO_STRUCT)[0];//X1
                    F3=(ArrayPoints->pData+iIndexValue);
                    
                    iIndexValue=((*pHeart->pExPairPar)+SIZE_INFO_STRUCT)[1];//Y1
                    F4=(ArrayPoints->pData+iIndexValue);
    
                    *F3=*F3+*F1;//сложение векторов покомпонентно
                    *F4=*F4+*F2;
                    
                    break;
//-----------------------------------------------------------------------------------
                default://имя операции не найдено
                    break;
            }
//следующая операция=================================================================
            pInfoTmp=(InfoArrayValue *)(*pHeart->pNextPlaces);
            
            if(pInfoTmp->mCount>0){
                iCurrentPlace=((*pHeart->pNextPlaces)+SIZE_INFO_STRUCT)[0];
                IndexInside=((*pParMatrix->pValueCopy) + SIZE_INFO_STRUCT)[iCurrentPlace];
                
                pCurrentMatr=*((MATRIXcell **)(ArrayPoints->pData+IndexInside));
                pHeart=(HeartMatr *)pQueue[iCurrentPlace];
            }
            else
            {
LEVEL_UP:
                if(InfoParMatrix->mCount==0)return;//выходим из обработки если стек пуст
                
                //достаём данные из стека
                InfoParMatrix->mCount--;
                InfoCurPlace->mCount--;

                pParMatrix=*((MATRIXcell **)(StartDataParMatrix+InfoParMatrix->mCount));
                iCurrentPlace=StartDataCurPlace[InfoCurPlace->mCount];
                pQueue=(*pParMatrix->pQueue)+SIZE_INFO_STRUCT;
                pHeart=(HeartMatr *)pQueue[iCurrentPlace];
NEXT_HEART:
                pInfoTmp=(InfoArrayValue *)(*pHeart->pNextPlaces);
                if(pInfoTmp->mCount>0){

                    iCurrentPlace=((*pHeart->pNextPlaces)+SIZE_INFO_STRUCT)[0];
                    iCurrentIndex=((*pParMatrix->pValueCopy)+SIZE_INFO_STRUCT)[iCurrentPlace];
                    pCurrentMatr=*((MATRIXcell **)(ArrayPoints->pData+iCurrentIndex));
                    
//                    pQueue=(*pParMatrix->pQueue)+SIZE_INFO_STRUCT;
                    pHeart=(HeartMatr *)pQueue[iCurrentPlace];
                }
                else goto LEVEL_UP;//переходим ещё на уровень выше
            }
            goto LOOP;
        break;
//составная матрица==================================================================
        case STR_COMPLEX:
            if(pCurrentMatr->sStartPlace==-1)goto NEXT_HEART;
            
            //заносим старые данные в стек
            if(InfoParMatrix->mCount==InfoParMatrix->mCopasity)
            {                
                InfoParMatrix->mCopasity+=100;
                InfoCurPlace->mCopasity+=100;
                
                int FullSize=InfoParMatrix->mCopasity*sizeof(int)+sizeof(InfoArrayValue);
                *pParMatrixStack = (int *)realloc(*pParMatrixStack,FullSize);
                *pCurPlaceStack = (int *)realloc(*pCurPlaceStack,FullSize);
                
                InfoParMatrix=(InfoArrayValue *)(*pParMatrixStack);
                InfoCurPlace=(InfoArrayValue *)(*pCurPlaceStack);
                
                StartDataParMatrix=((*pParMatrixStack)+SIZE_INFO_STRUCT);
                StartDataCurPlace=((*pCurPlaceStack)+SIZE_INFO_STRUCT);
            }
            
            //копируем данные в стек
            MATRIXcell **TmpLink=(MATRIXcell **)(StartDataParMatrix+InfoParMatrix->mCount);
            *TmpLink=pParMatrix;
            StartDataCurPlace[InfoCurPlace->mCount]=iCurrentPlace;
            
            InfoParMatrix->mCount++;
            InfoCurPlace->mCount++;

            pParMatrix=pCurrentMatr;
            iCurrentPlace=pCurrentMatr->sStartPlace;
            iCurrentIndex=((*pCurrentMatr->pValueCopy)+SIZE_INFO_STRUCT)[iCurrentPlace];
            pCurrentMatr=*((MATRIXcell **)(ArrayPoints->pData+iCurrentIndex));
            pQueue=(*pParMatrix->pQueue)+SIZE_INFO_STRUCT;
            pHeart=(HeartMatr *)pQueue[iCurrentPlace];

            goto LOOP;//входим в матрицу
        break;
//===================================================================================
        default://тип не найден
            break;
    }
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
        
    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
@end