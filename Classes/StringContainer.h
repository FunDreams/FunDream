//
//  StringContainer.h
//  FunDreams
//
//  Created by Konstantin Maximov on 15.06.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FractalString.h"
@class FunArrayDataIndexes;
@class CObjectManager;
@class Ob_ParticleCont_ForStr;
@class MainCycle;
@class Kernel;

#define MAX_REZERV 4000

@interface StringContainer : NSObject{//пространство струн 
@public
    
    MainCycle *pMainCycle;
    Kernel *pKernel;

    FunArrayData *ArrayPoints;
    NSMutableDictionary *DicStrings;
    NSMutableDictionary *DicLog;
    FunArrayDataIndexes *m_OperationIndex;
    
    FractalString *pFStringObjects;
    CObjectManager* m_pObjMng;

    //массив менеджеров данных файла
    int m_iCurFile;
    NSMutableArray *ArrayDumpFiles;
    CDataManager *pDataCurManagerTmp;

    FunArrayData *ArrayPointsTmp;
    //Массив параметно для сохранения/загрузки
    
    int *pDataTmp;
    //Двойной временной массив индексов для копирования
    //частей струкруты в DropBox и загрузки.
//================================================================================
    int **pParMatrixStack;
    int **pCurPlaceStack;
//kernell data====================================================================
    float *pDeltaTime;
    int iIndexMaxSys;
}

-(id)init:(id)Parent;

-(void)SetKernel;
-(void)SetEditor;
-(void)InitIndex;

-(id)GetString:(NSString *)strName;
-(void)DelChilds:(FractalString *)strDelChilds;
-(void)DelString:(FractalString *)strDel;
-(NSString *)GetRndName;
-(void)AddSmallCube:(FractalString *)pFParent;
- (void)LogString:(FractalString *)fString;
- (void)SetParCont;

-(void)CopyStrFrom:(StringContainer*)SourceContainer WithId:(FractalString *)SourceStr;
-(void)ConnectStart:(FractalString *)StartStr End:(FractalString *)EndStr;
-(void)ReLinkDataManager;
-(bool)LoadContainer;
-(void)SaveContainer;
-(void)Synhronize;

@end
