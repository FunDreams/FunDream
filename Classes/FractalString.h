//
//  FractalString.h
//  FunDreams
//
//  Created by Konstantin Maximov on 28.04.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import <Foundation/Foundation.h>

//структура перечисле типов струн
typedef enum tagTypeString {
    tLine=0,
    t2dString,
    t3dString,
    tCircle
} EGP_TypeString;


@interface FractalString : NSObject{
@public
    int iType;//тип струны  линия/кривая/круг
    
    float *S;//стартовое значение
    float *T;//главный параметр струны
    float *F;//конечное значение

    //точки необходимы для преобразования координат (отражение)
    //в зависимости от типа струны нужно определённое количество точек.
    //линия (2)
    //парабола (3)
    //кубическая (4)
    //круг (2)
    point2d *P1;
    point2d *P2;
    point2d *P3;
    point2d *P4;
}

@end