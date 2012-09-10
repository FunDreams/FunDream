//
//  FractalString.h
//  FunDreams
//
//  Created by Konstantin Maximov on 28.04.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StringContainer;

@interface FractalString : NSObject{
@public
    FractalString *pParent;//струна родитель
    NSString *strName;//Имя
    NSString *strUID;//уникальный идентификатор струны (случайное имя дня словаря)
    int m_iDeep;//вложенность

    NSMutableArray *aStages;//Состояния
    NSMutableArray *aStrings;//дочерние струны
    
    int S;//начальная граница параметра
    FunArrayDataIndexes *ArrayPoints;//ссылки на значения параметров
    int F;//конечная граница параметра

    int iIndexIcon;//иконка
    float X;
    float Y;
//    int m_iFlags;
}

- (id)initWithName:(NSString *)NameString WithParent:(FractalString *)Parent
     WithContainer:(StringContainer *)pContainer S:(int)iS F:(int)iF;

- (id)initWithData:(NSMutableData *)pData WithCurRead:(int *)iCurReadingPos 
        WithParent:(FractalString *)Parent WithContainer:(StringContainer *)pContainer 
                 S:(int)iS F:(int)iF;

- (id)initAsCopy:(FractalString *)pStrSource WithParent:(FractalString *)Parent
   WithContainer:(StringContainer *)pContainer;

- (void)SetLimmitStringS:(int)iS F:(int)iF;

-(void)UpDate:(float)fDelta;
-(void)selfSave:(NSMutableData *)m_pData WithVer:(int)iVersion;
-(void)selfLoad:(NSMutableData *)m_pData ReadPos:(int *)iCurReadingPos
        WithContainer:(StringContainer *)pContainer;

@end