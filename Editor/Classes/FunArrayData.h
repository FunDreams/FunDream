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
#define Ind_W_EMULATOR              200001
#define Ind_H_EMULATOR              200002
#define Ind_ANG_EMULATOR            200003
#define Ind_SCALE_EMULATOR          200004
#define Ind_dX_EMULATOR             200005
#define Ind_dY_EMULATOR             200006
#define Ind_SCALE_X_EMULATOR        200007
#define Ind_SCALE_Y_EMULATOR        200008
#define Ind_MODE_EMULATOR           200009

#define Ind_TOP_X                   200010
#define Ind_TOP_Y                   200011
#define Ind_IS_IPAD                 200012

#define Ind_DATA_Y                  200013
#define Ind_DATA_M                  200014
#define Ind_DATA_DAY                200015
#define Ind_DATA_H                  200016
#define Ind_DATA_MIN                200017
#define Ind_DATA_S                  200018

#define Ind_PAUSE                   200019

#define Ind_V1                      200020
#define Ind_V2                      200021
#define Ind_V3                      200022

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
#define DATA_P_MATR         9//ссылка на матрицу
#define DATA_U_INT          10//номер строки в матрице


#define DATA_ARRAY         50
//-------------------------------------------------------------------------------------------------
//определения для типов ячеек матрицы
#define STR_SIMPLE          0//нулевой-объект
#define STR_OPERATION       1//объект-операция
#define STR_CONTAINER       2//объект со спецефическими свойствами
#define STR_COMPLEX         3//составной объект
//-------------------------------------------------------------------------------------------------
//имена ячеек матрицы
//имена струн (Операации)++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#define NAME_O_ADD_DATA         3001
#define NAME_O_MOVE_DATA        3002
#define NAME_O_COPY_DATA        3003
#define NAME_O_DEL_DATA         3004

#define NAME_O_UPDATE_XY        3010
#define NAME_O_DRAW             3011

#define NAME_O_DELTA_T          3012
#define NAME_O_RND              3013
#define NAME_O_MIRROR           3014
#define NAME_O_PLUS             3015
#define NAME_O_MINUS            3016
#define NAME_O_MULL             3017
#define NAME_O_DIV              3018
#define NAME_O_DIV_OST          3019
#define NAME_O_PLUS_EQUAL       3020
#define NAME_O_MINUS_EQUAL      3021
#define NAME_O_MUL_EQUAL        3022
#define NAME_O_DIV_EQUAL        3023
#define NAME_O_DIV_OST_EQUAL    3024
#define NAME_O_INC              3025
#define NAME_O_DEC              3026

#define NAME_O_MORE             3027
#define NAME_O_LESS             3028
#define NAME_O_EQUAL            3029
#define NAME_O_NOT_EQUAL        3030
#define NAME_O_MORE_EQUAL       3031
#define NAME_O_LESS_EQUAL       3032
#define NAME_O_SWITCH           3033

#define NAME_O_JMP              3043
#define NAME_O_STRING           3044
#define NAME_O_PL_TO_I          3045
#define NAME_O_I_TO_PL          3046
#define NAME_CLEAR_SPACE        3047
#define NAME_O_UPDATE_COLOR     3048
#define NAME_O_SIN              3049
#define NAME_O_COS              3050
#define NAME_O_TG               3051
#define NAME_O_INV              3052
#define NAME_O_ABS              3053
#define NAME_O_RND_MINUS        3054
#define NAME_O_POW              3055
#define NAME_O_PLAY_SOUND       3056

#define NAME_O_UL_UV_TEX        3057
#define NAME_O_UR_UV_TEX        3058
#define NAME_O_DL_UV_TEX        3059
#define NAME_O_DR_UV_TEX        3060

#define NAME_O_UL_XY            3061
#define NAME_O_UR_XY            3062
#define NAME_O_DL_XY            3063
#define NAME_O_DR_XY            3064

#define NAME_O_KX_PLUS_C        3065
#define NAME_O_SIZE             3066
#define NAME_O_JMP_EX           3067
#define NAME_O_FIND             3068

#define NAME_O_DRAW_EX          3069
#define NAME_O_SPLINE           3070
#define NAME_O_RND_QUEUE        3071

#define NAME_O_MUL_PLACE        3072

#define NAME_O_ASIN             3073
#define NAME_O_ACOS             3074
#define NAME_O_ATAN             3075

#define NAME_O_SUMMA            3076

#define NAME_O_DIST             3077
#define NAME_O_MUL_SCALAR       3078
#define NAME_O_ANGLE            3079

#define NAME_O_NUMBER           3080

#define NAME_O_JMP_CYCLE        3081
#define NAME_O_PROCEDURE        3082

#define NAME_O_TOUCH_BEG        3100
#define NAME_O_TOUCH_MOVE       3101
#define NAME_O_TOUCH_END        3102

//имена струн (Контейнеры)+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#define NAME_K_SLAYDER          40000
//-------------------------------------------------------------------------------------------------
typedef struct{
//MATRIX 28.01.2013
//матрица универсальных данных---------------------------------------------------------------------
    
    int **pLinks;//индексы для указаний родителей                   (Parents)
    int **pValueCopy;//int,float,string,(array), указатели и матрицы. (childs)

    int **pEnters;//входные параметны
    int **pExits;//выходные параметны

    //последовательности
    int **pQueue;//индексы для последовательности в виде мини матриц связей (hearts)
    int **ppStartPlaces;//точки входа
    int **ppActivitySpace;//активные пространства
    int **ppDataMartix;//матрица данных
    int iDimMatrix;//размерность матрицы

    //типы
    BYTE    TypeInformation;//тип матрицы.
    short   NameInformation;//Имя-число матрицы.
    int     iIndexSelf;//индекс-указатель на себя
    
    int iIndexString;//индекс-указатель на информационную струну
//-------------------------------------------------------------------------------------------------
} MATRIXcell;
////мини матрица (используется для создания последовательностей)
typedef struct{

    int **pEnPairPar;//входные параметны парент
    int **pEnPairChi;//входные параметны чилд

    int **pExPairPar;//выходные параметны парент
    int **pExPairChi;//выходные параметны чилд

    int **pModes;//режимы работы матрицы
    
    int pNextPlace;//следующее место в очереди матрицы

} HeartMatr;

@interface FunArrayData : NSObject{
@public

    int **ppIndexNeedDelTex;
    int **ppIndexNeedDelSound;
    int **ppIndexNeedDelPar;
    
    int **ppHelpData;
    int **ppListMatrix;
    bool m_bFirstMatrix;
    int m_iCurIndex;
    
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
    int **ppFreeArrayEx;
    
    NSMutableDictionary *pNamesOb;//словарь с именми объектов (струны)
    NSMutableDictionary *pNamesValue;//словарь с простыми именами
    NSMutableDictionary *pMartixDic;//словарь с ячейками матрицы
    NSMutableDictionary *pDicRename;//словарь для переименования индексов
    NSMutableDictionary *DicAllAssociations;//для списков ссылок
    
    NSMutableDictionary *ppAllArrays;//все массивы.
}

-(void)PostInit:(StringContainer*)PContainer;
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
- (int)SetTexture:(int)IndexTexture;
- (int)SetSound:(int)IndexSound;
- (int)CreateZeroByType:(int)iType;
- (int)SetArray:(int **)DataArray;
- (int)SetIndexOb:(int **)DataArray;
//- (int)SetUInt:(unsigned int)DataValue;

-(int)CreateArrayByIndex:(int)iIndex withType:(unsigned char)iTypeArray;

- (void)IncDataAtIndex:(int)iIndex;
- (void)DecDataAtIndex:(int)iIndex;
- (int)GetCountAtIndex:(int)iIndex;

- (MATRIXcell *)GetMatrixAtIndex:(int)iIndex;
- (void *)GetDataAtIndex:(int)iIndex;
- (id)GetIdAtIndex:(int)iIndex;
- (unsigned char)GetTypeAtIndex:(int)iIndex;
- (int)CopyDataAtIndex:(int)iIndex;
- (int)LinkDataAtIndex:(int)iIndex;
- (int **)GetArrayAtIndex:(int)iIndex;
- (int)GetResAtIndex:(int)iIndex;

-(void)selfSave:(NSMutableData *)m_pData;
-(void)selfLoad:(NSMutableData *)m_pData rpos:(int *)iCurReadingPos;

- (void)LoadMatrix:(NSMutableData *)pMutData rpos:(int *)iCurReadingPos WithMatr:(MATRIXcell *)pMatr;
- (void)SaveMatrix:(NSMutableData *)pData WithMatr:(MATRIXcell *)pMatr;

- (void)LoadHeart:(NSMutableData *)pMutData rpos:(int *)iCurReadingPos
         WithHeat:(HeartMatr *)pHeart WithMatr:(MATRIXcell *)pMatr;
- (void)SaveHeart:(NSMutableData *)pMutData WithMatr:(HeartMatr *)pHeart;
-(void)CopyAndRenameHeartData:(HeartMatr *)pHeartSelf from:(HeartMatr *)pHeartData
                          Dic:(NSMutableDictionary *)pDic;

-(void)CopyHeartData:(HeartMatr *)pHeartSelf from:(HeartMatr *)pHeartData;
-(void)delResource;

- (void)Reserv:(int)iCountTmp;
- (int)GetZeroByType:(int)iType;
-(void)PrepareLoadData;

- (void)SetSrc:(FunArrayData *)pSourceData;

- (void)dealloc;

@end

