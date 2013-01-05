//
//  StringContainer.h
//  FunDreams
//
//  Created by Konstantin Maximov on 15.06.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FractalString.h"

@interface StringContainer : NSObject{
@public
    NSMutableArray *ArrayStrings;
    FunArrayData *ArrayPoints;
    NSMutableArray *ArrayActiveStrings;
    NSMutableDictionary *DicStrings;
    
    FractalString *pFStringObjects;
    CObjectManager* m_pObjMng;

    //массив менеджеров данных файла
    int m_iCurFile;
    NSMutableArray *ArrayDumpFiles;
    CDataManager *pDataCurManagerTmp;
    
    int iIndexZero;
    
    FunArrayData *ArrayPointsTmp;
    //Массив параметно для сохранения/загрузки
    
    int *pDataTmp;
    //Двойной временной массив индексов для копирования
    //частей струкруты в DropBox и загрузки.
}

-(id)init:(id)Parent;
-(void)Update;

-(void)SetTemplateString;
-(id)GetString:(NSString *)strName;
-(void)AddString:(FractalString *)pString;
-(void)DelChilds:(FractalString *)strDelChilds;
-(void)DelString:(FractalString *)strDel;
-(NSString *)GetRndName;
-(void)AddSmallCube:(FractalString *)pFParent;

-(void)ReLinkDataManager;
-(bool)LoadContainer;
-(void)SaveContainer;
-(void)Synhronize;

@end
