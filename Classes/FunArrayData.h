//
//  FunArrayData.h
//  FunDreams
//
//  Created by Konstantin Maximov on 24.04.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FunArrayData : NSObject{
@public
    float *pData;//единый массив данных
    void *pDataInt;//данные о копиях ячейки
    int m_iSize;//число байтов в значении
    
    int iCount;//ёмкость массива
    int iCountInc;//шаг расширения массива
    
    NSMutableArray *pFreeArray;//массив со свободными индексами
}

-(id)initWithCopasity:(int)iCopasity;
- (void)Increase:(int)CountInc;
- (int)GetFree;
- (int)SetData:(float)DataValue;
- (void)IncDataAtIndex:(int)iIndex;
- (void)DecDataAtIndex:(int)iIndex;
- (float *)GetDataAtIndex:(int)iIndex;

- (void)dealloc;

@end
