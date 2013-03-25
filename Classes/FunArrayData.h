//
//  FunArrayData.h
//  FunDreams
//
//  Created by Konstantin Maximov on 24.04.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//
#import <Foundation/Foundation.h>
@class StringContainer;
@class FractalString;
@class Ob_ParticleCont_ForStr;
//-------------------------------------------------------------------------------------------------
#define RESERV_KERNEL 1000000
//-------------------------------------------------------------------------------------------------
#define Ind_ZERO                    0
#define Ind_DELTATIME               200000
#define IND_MAIN_DATA_MATRIX        100

#define IND_DATA_MATRIX_EMPTY       101
#define IND_DATA_MATRIX_SYS         102
#define IND_DATA_MATRIX_OPER        103
//-------------------------------------------------------------------------------------------------
#define DATA_ZERO           0//ничего
#define DATA_ID             1//струна, объект для отображения информации
#define DATA_MATRIX         2//матрица данных
#define DATA_FLOAT          3
#define DATA_INT            4
#define DATA_STRING         5
#define DATA_TEXTURE        6
#define DATA_SOUND          7
#define DATA_SPRITE         8
//-------------------------------------------------------------------------------------------------
//определения для типов ячеек матрицы
#define STR_SIMPLE          0//нулевой-объект
#define STR_OPERATION       1//объект-операция
#define STR_CONTAINER       2//объект со спецефическими свойствами
#define STR_COMPLEX         3//составной объект
#define STR_ARRAY           4//матрица массив
//-------------------------------------------------------------------------------------------------
//имена ячеек матрицы
//имена струн (Операации)++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#define NAME_O_PLUS             3001
#define NAME_O_UPDATE_XY        3002
#define NAME_O_DRAW             3003
#define NAME_O_MOVE             3004
#define NAME_O_MOVE_ORBIT       3005
#define NAME_O_PLUS_VECTOR      3006
//имена струн (Контейнеры)+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#define NAME_K_BUTTON_ENVENT    40001
//-------------------------------------------------------------------------------------------------
typedef struct{
//MATRIX 28.01.2013
//матрица универсальных данных---------------------------------------------------------------------
    
    int **pLinks;//индексы для указаний родителей                   (Parents)
    int **pValueCopy;//int,float,string,(array), указатели и матрицы. (childs)

    int **pEnters;//входные параметны
    int **pExits;//выходные параметны

    //последовательности
    int **pQueue;//индексы для последовательности
    //в виде мини матриц связей

    //типы
    BYTE    TypeInformation;//тип матрицы.
    short   NameInformation;//Имя-число матрицы.
    int     iIndexSelf;//индекс-указатель на себя
    short   sStartPlace;//точка входа
//-------------------------------------------------------------------------------------------------
} MATRIXcell;
////мини матрица (используется для создания последовательностей)
typedef struct{
    
    int **pEnPairPar;//входные параметны парент
    int **pEnPairChi;//входные параметны чилд

    int **pExPairPar;//выходные параметны парент
    int **pExPairChi;//выходные параметны чилд

    int **pNextPlaces;//следующее место в очереди матрицы

} HeartMatr;

@interface FunArrayData : NSObject{
@public

    bool m_bSaveKernel;
    StringContainer *pParent;//контейнер родитель

    Ob_ParticleCont_ForStr *pCurrenContPar;//спрайты
    float *pData;//единый массив данных
    int *pDataInt;//данные о копиях ячейки
    BYTE *pType;//тип данных

    Ob_ParticleCont_ForStr *pCurrenContParSrc;//спрайты исходника
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
- (void)InitMemoryHeart:(HeartMatr *)pHeart parent:(MATRIXcell *)pMatr;
- (void)ReleaseMemoryHeart:(HeartMatr *)pHeart;

- (int)SetFloat:(float)DataValue;
- (int)SetInt:(int)DataValue;
- (int)SetName:(NSMutableString *)DataValue;
- (int)SetOb:(FractalString *)DataValue;
- (int)SetMatrix:(MATRIXcell *)DataMatrix;
- (int)SetSprite:(int)IndexSprite;
- (int)SetTexture:(NSMutableString *)DataValue;

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

- (void)LoadHeart:(NSMutableData *)pMutData rpos:(int *)iCurReadingPos
         WithHeat:(HeartMatr *)pHeart WithMatr:(MATRIXcell *)pMatr;
- (void)SaveHeart:(NSMutableData *)pMutData WithMatr:(HeartMatr *)pHeart;
-(void)CopyAndRenameHeartData:(HeartMatr *)pHeartSelf from:(HeartMatr *)pHeartData
                          Dic:(NSMutableDictionary *)pDic;

- (void)Reserv:(int)iCountTmp;
-(void)PrepareLoadData;

- (void)SetSrc:(FunArrayData *)pSourceData;

- (void)dealloc;

@end
