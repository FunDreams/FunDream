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
    FunArrayDataIndexes *m_OperationIndex;

    NSMutableDictionary *DicStrings;
    NSMutableDictionary *DicLog;
    
    FractalString *pFStringObjects;
    CObjectManager* m_pObjMng;

    //массив менеджеров данных файла
    int m_iCurFile;
    NSMutableArray *ArrayDumpFiles;
    CDataManager *pDataCurManagerTmp;

    FunArrayData *ArrayPointsTmp;
    //Массив параметров для сохранения/загрузки
    
    int *pDataTmp;
    //Двойной временной массив индексов для копирования
    //частей струкруты в DropBox и загрузки.
//================================================================================
    int **pParMatrixStack;
    int **pCurPlaceStack;
//kernel data====================================================================
  //  int iIndexDeltaTime;
    int iIndexMaxSys;
    
    bool m_bInDropBox;
}

-(id)init:(id)Parent;

-(void)SetKernel;
-(void)SetEditor;

-(id)GetString:(NSString *)strName;
-(void)DelChilds:(FractalString *)strDelChilds;
-(void)DelString:(FractalString *)strDel;
-(NSString *)GetRndName;
- (void)LogString:(FractalString *)fString;
- (void)LogDataPoint:(int**)pData Name:(NSString *)Name;
- (void)SetParCont;

-(void)spesProc:(int)type;
-(void)ReplaceStringIn:(FractalString *)strDest strscr:(FractalString *)strSrc strings:(NSMutableArray *)pArray;
-(void)ReplaceStringOut:(FractalString *)strDest strscr:(FractalString *)strSrc strings:(NSMutableArray *)pArray;

-(void)ReplaceStringIn2:(FractalString *)strDest strscr:(FractalString *)strSrc strings:(NSMutableArray *)pArray;
-(void)ReplaceStringOut2:(FractalString *)strDest strscr:(FractalString *)strSrc strings:(NSMutableArray *)pArray;

-(void)CopyStrFrom:(StringContainer*)SourceContainer WithId:(FractalString *)SourceStr;
-(void)ConnectStart:(FractalString *)StartStr End:(FractalString *)EndStr;
-(void)ReLinkDataManager;
-(bool)LoadContainer;
-(void)SaveContainer;
-(void)Synhronize;

@end
