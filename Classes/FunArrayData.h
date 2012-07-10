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
    void *pData;//единый массив данных
    int iType;//число байтов в значении
    
    int iCount;//ёмкость массива
    int iCountInArray;//число элементов
    int iCountInc;//шаг расширения массива
    bool m_bValue;//Флаг который показывает что массив со значениями.
}

-(id) initWithCopasity:(int)iCopasity CountByte:(int)i_Type;

-(void)Reserv:(int)NewSize;
-(void *)AddData:(void *)pDataValue;
-(void)RemoveDataAtIndex:(int)iIndex;
-(void *)GetDataAtIndex:(int)iIndex;
-(void)Reset;

@end
