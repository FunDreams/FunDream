//
//  FunArrayData.h
//  FunDreams
//
//  Created by Konstantin Maximov on 24.04.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//
#define DATA_ID             1//составной объект (matrix)
#define DATA_LINK           2//ссылка на данные
#define DATA_FLOAT          3
#define DATA_INT            4
#define DATA_STRING         5
#define DATA_TEXTURE        6
#define DATA_SOUND          7

#import <Foundation/Foundation.h>
@class StringContainer;
@class FractalString;

@interface FunArrayData : NSObject{
@public
    StringContainer *pParent;//контейнер родитель
    float *pData;//единый массив данных
    int *pDataInt;//данные о копиях ячейки
    BYTE *pType;//тип данных
    
    int iCount;//ёмкость массива
    int iCountInc;//шаг расширения массива
    int iCountInArray;//количесво элементов внутри массива
    
    NSMutableArray *pFreeArray;//массив со свободными индексами
    
    NSMutableDictionary *pNamesOb;//массив с именми объектов
    NSMutableDictionary *pNamesValue;//массив с простыми именами
}

-(id)initWithCopasity:(int)iCopasity;
- (void)Increase:(int)CountInc;
- (int)GetFree;

- (int)SetFloat:(float)DataValue;
- (int)SetInt:(int)DataValue;
- (int)SetName:(NSMutableString *)DataValue;
- (int)SetOb:(FractalString *)DataValue;

- (void)IncDataAtIndex:(int)iIndex;
- (void)DecDataAtIndex:(int)iIndex;

- (void *)GetDataAtIndex:(int)iIndex;
- (id)GetIdAtIndex:(int)iIndex;
- (unsigned char)GetTypeAtIndex:(int)iIndex;

-(void)selfSave:(NSMutableData *)m_pData;
-(void)selfLoad:(NSMutableData *)m_pData rpos:(int *)iCurReadingPos;

- (void)Reserv:(int)iCountTmp;
-(void)PrepareLoadData;

- (void)dealloc;

@end
