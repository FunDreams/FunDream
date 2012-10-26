//
//  FractalString.h
//  FunDreams
//
//  Created by Konstantin Maximov on 28.04.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StringContainer;

#define DEAD_STRING   0x00000001
#define ONLY_HEAD     0x00000002

@interface FractalString : NSObject{
@public
    FractalString *pParent;//струна родитель
    NSString *strName;//Имя
    NSString *strUID;//уникальный идентификатор струны (случайное имя для словаря)
    int m_iDeep;//вложенность

    NSMutableArray *aStages;//Состояния
    NSMutableArray *aStrings;//дочерние струны (для структуры хранения)
    NSMutableArray *ArrayLinks;//массив ссылок (имена струн).
    
    int S;//начальная граница параметра
    FunArrayDataIndexes *ArrayPoints;//ссылки на значения параметров
    int F;//конечная граница параметра

    int iIndexIcon;//иконка
    float X;
    float Y;
    int m_iFlagsString;

    //0x00000001 струна мёртвая (без ссылок в DropBox'e)
    //0x00000002 только структура заголовок
}

- (id)initWithName:(NSString *)NameString WithParent:(FractalString *)Parent
     WithContainer:(StringContainer *)pContainer S:(int)iS F:(int)iF;

- (id)initWithData:(NSMutableData *)pData WithCurRead:(int *)iCurReadingPos 
        WithParent:(FractalString *)Parent WithContainer:(StringContainer *)pContainer;

- (id)initAsCopy:(FractalString *)pStrSource WithParent:(FractalString *)Parent
   WithContainer:(StringContainer *)pContainer;

- (id)initAsCopy:(FractalString *)pStrSource WithParent:(FractalString *)Parent
   WithContainer:(StringContainer *)pContainer WithLevel:(int)iCurLevel WithMaxDeep:(int)iDeep;

- (void)SetLimmitStringS:(int)iS F:(int)iF;

-(void)UpDate:(float)fDelta;

-(void)selfSaveWithOutPoints:(NSMutableData *)m_pData WithVer:(int)iVersion
                        Deep:(int)iDeep MaxDeep:(int)iMaxDeep;

-(void)selfSave:(NSMutableData *)m_pData WithVer:(int)iVersion;
-(void)selfLoad:(NSMutableData *)m_pData ReadPos:(int *)iCurReadingPos
        WithContainer:(StringContainer *)pContainer;

-(void)selfLoadOnlyStructure:(NSMutableData *)pData ReadPos:(int *)iCurReadingPos;

@end