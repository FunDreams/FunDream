//
//  FunArrayData.h
//  FunDreams
//
//  Created by Konstantin Maximov on 24.04.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//
#define DATA_ZERO           0//пустая струна
#define DATA_ID             1//струна, объект для отображения информации
#define DATA_MATRIX         2//матрица данных
#define DATA_FLOAT          3
#define DATA_INT            4
#define DATA_STRING         5
#define DATA_TEXTURE        6
#define DATA_SOUND          7

#import <Foundation/Foundation.h>
@class StringContainer;
@class FractalString;
//-------------------------------------------------------------------------------------------------
//определения для типов ячеек матрицы
#define STR_SIMPLE          0//нулевой-объект
#define STR_OPERATION       1//объект-операция
#define STR_CONTAINER       2//объект со спецефическими свойствами
#define STR_COMPLEX         3//составной объект
#define STR_ARRAY           4//матрица массив
//-------------------------------------------------------------------------------------------------
//имена ячеек матрицы
#define NAME_SIMPLE               0
//имена струн (Операации)
#define NAME_O_PLUS             5001
//имена струн (Контейнеры)
#define NAME_K_START            10001
#define NAME_K_BUTTON_ENVENT    10002
//-------------------------------------------------------------------------------------------------
typedef struct{
//MATRIX 28.01.2013
//матрица универсальных данных---------------------------------------------------------------------
    //    int **pValueLink;
    
    int **pLinks;//индексы для указаний родителей                   (Parents)
    int **pValueCopy;//int,float,string,(array), указатели и матрицы. (childs)

    //последовательности
    int **pQueue;//индексы для последовательности

    //типы
    BYTE TypeInformation;//тип матрицы.
    short NameInformation;//Имя-число матрицы.
    int iIndexSelf;//индекс-указатель на себя
//-------------------------------------------------------------------------------------------------
} MATRIXcell;

@interface FunArrayData : NSObject{
@public
    StringContainer *pParent;//контейнер родитель

    float *pData;//единый массив данных
    int *pDataInt;//данные о копиях ячейки
    BYTE *pType;//тип данных

    float *pDataSrc;//исходный массив данных при копировании
    int *pDataIntSrc;//исходный массив данных при копировании
    BYTE *pTypeSrc;//тип данных исходника

    int iCount;//ёмкость массива
    int iCountInc;//шаг расширения массива
    int iCountInArray;//количесво элементов внутри массива
    
    NSMutableArray *pFreeArray;//массив со свободными индексами
    
    NSMutableDictionary *pNamesOb;//словарь с именми объектов
    NSMutableDictionary *pNamesValue;//словарь с простыми именами
    NSMutableDictionary *pMartixDic;//словарь с ячейками матрицы
    NSMutableDictionary *pDicRename;//словарь для переименования индексов
    NSMutableDictionary *DicAllAssociations;//для списков ссылок
}

-(id)initWithCopasity:(int)iCopasity;
- (void)Increase:(int)CountInc;
- (int)GetFree;
- (void)SetCellFreeAtIndex:(int)iIndex;

- (void)InitMemoryMatrix:(MATRIXcell *)pMatr;

- (int)SetFloat:(float)DataValue;
- (int)SetInt:(int)DataValue;
- (int)SetName:(NSMutableString *)DataValue;
- (int)SetOb:(FractalString *)DataValue;
- (int)SetMatrix:(MATRIXcell *)DataMatrix;

- (void)IncDataAtIndex:(int)iIndex;
- (void)DecDataAtIndex:(int)iIndex;
- (int)GetCountAtIndex:(int)iIndex;

- (MATRIXcell *)GetMatrixAtIndex:(int)iIndex;
- (void *)GetDataAtIndex:(int)iIndex;
- (id)GetIdAtIndex:(int)iIndex;
- (unsigned char)GetTypeAtIndex:(int)iIndex;
- (int)CopyDataAtIndex:(int)iIndex;
- (int)LinkDataAtIndex:(int)iIndex;

-(void)selfSave:(NSMutableData *)m_pData;
-(void)selfLoad:(NSMutableData *)m_pData rpos:(int *)iCurReadingPos;

- (void)LoadMatrix:(NSMutableData *)pMutData rpos:(int *)iCurReadingPos WithMatr:(MATRIXcell *)pMatr;
- (void)SaveMatrix:(NSMutableData *)pData WithMatr:(MATRIXcell *)pMatr;

- (void)Reserv:(int)iCountTmp;
-(void)PrepareLoadData;

- (void)SetSrc:(FunArrayData *)pSourceData;

- (void)dealloc;

@end
