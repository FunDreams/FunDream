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
    int *pDataInt;//данные о копиях ячейки
    
    int iCount;//ёмкость массива
    int iCountInc;//шаг расширения массива
    int iCountInArray;
    
    NSMutableArray *pFreeArray;//массив со свободными индексами
}

-(id)initWithCopasity:(int)iCopasity;
- (void)Increase:(int)CountInc;
- (int)GetFree;
- (int)SetData:(float)DataValue;
- (void)IncDataAtIndex:(int)iIndex;
- (void)DecDataAtIndex:(int)iIndex;
- (float *)GetDataAtIndex:(int)iIndex;

-(void)selfSave:(NSMutableData *)m_pData;
-(void)selfLoad:(NSMutableData *)m_pData rpos:(int *)iCurReadingPos;

- (void)Reserv:(int)iCountTmp;

- (void)dealloc;

@end
