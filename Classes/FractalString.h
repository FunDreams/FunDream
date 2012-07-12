//
//  FractalString.h
//  FunDreams
//
//  Created by Konstantin Maximov on 28.04.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StringContainer;
//структура перечисления типов струн
typedef enum tagTypeString {
    tLine=0,
    t2dString,
    t3dString,
    tCircle
} EGP_TypeString;


@interface FractalPoint : NSObject{
@public
    float *T;//параметр.
}
@end

@interface FractalString : NSObject{
@public
    int m_iType;

    FractalString *pParent;//струна родитель
    NSString *strName;//Имя
    NSString *strUID;//уникальный идентификатор струны (случайное имя дня словаря)
    int m_iDeep;//вложенность

    int iType;//тип струны  линия/кривая/круг
    
    NSMutableArray *aStrings;//вложенные струны
    
    float *S;//начальная граница параметра
    FunArrayData *ArrayPoints;//ссылки на значения параметров
    float *F;//конечная граница параметра

    //точки необходимы для преобразования координат (отражение)
    //в зависимости от типа струны нужно определённое количество точек.
    //линия (2)
    //парабола (3)
    //кубическая (4)
    //круг (2)
//    point2d *P1;
//    point2d *P2;
//    point2d *P3;
//    point2d *P4;
}

- (id)initWithName:(NSString *)NameString WithParent:(FractalString *)Parent
     WithContainer:(StringContainer *)pContainer S:(float *)fS F:(float *)fF;

- (id)initWithData:(NSMutableData *)pData WithCurRead:(int *)iCurReadingPos 
        WithParent:(FractalString *)Parent WithContainer:(StringContainer *)pContainer 
                 S:(float *)fS F:(float *)fF;

- (id)initAsCopy:(FractalString *)pStrSource WithParent:(FractalString *)Parent
   WithContainer:(StringContainer *)pContainer;

- (void)SetLimmitStringS:(float *)fS F:(float *)fF;

-(void)UpDate:(float)fDelta;
-(void)selfSave:(NSMutableData *)m_pData WithVer:(int)iVersion;
-(void)selfLoad:(NSMutableData *)m_pData ReadPos:(int *)iCurReadingPos
        WithContainer:(StringContainer *)pContainer;

@end