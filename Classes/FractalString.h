//
//  FractalString.h
//  FunDreams
//
//  Created by Konstantin Maximov on 28.04.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StringContainer;
//-------------------------------------------------------------------------------------------------
//определения для dropBox'a
#define DEAD_STRING         0x00000001
#define SYNH_AND_HEAD       0x00000002
#define SYNH_AND_LOAD       0x00000004
#define ONLY_IN_MEM         0x00000008
//-------------------------------------------------------------------------------------------------
//определения для типов струн
#define STR_ZERO            0
#define STR_DATA            1
#define STR_OPERATION       2
#define STR_CONTAINER       3//объект со спецефическими свойствами
//-------------------------------------------------------------------------------------------------
#define NAME_ZERO               0
//имена струн (Данные)
#define NAME_V_FLOAT            1
//имена струн (Операации)
#define NAME_O_PLUS             5001
//имена струн (Контейнеры)
#define NAME_K_START            10001
#define NAME_K_BUTTON_ENVENT    10002
//-------------------------------------------------------------------------------------------------
typedef struct{
    short Count;     //количество элементов в массиве
    short Type;      //тип элемента в массиве
    short Copasity;  //ёмкость
}StringValue;

@interface FractalString : NSObject{
@public

    int **pPointCopy;
    int **pPointLink;

    BYTE TypeInformation;//тип струны.
    short NameInformation;//Имя-число струны.

    int **pEnters;
    int **pExits;

    //old
    FunArrayDataIndexes *ArrayPoints;//значения параметров (strKey=(int)iValue)(index=Value)(ссылки)
    NSMutableArray *ArrayLinks;//массив ссылок (именновыные переменные).

    //объекты-данные (для структуры хранения и обработки)(объекты)
    //массив массивов вложенных составных объектов
    NSMutableArray *aStrings;
//--------------------------------------------------------------------------------------------------
    FractalString *pParent;//струна родитель
    NSString *strUID;//уникальный идентификатор струны (случайное имя для словаря)
    //информация для редактора
    float X;
    float Y;
    
    NSString *sNameIcon;//имя иконки
    int m_iFlagsDropBox;

    //0x00000001 струна мёртвая (без ссылок в DropBox'e) (красный)
    //0x00000002 струна на сервере, а в памяти только структура-заголовок (жёлтый)
    //0x00000004 струна загружена и синхронизирована с хранилищем (зелёный)
    //0x00000008 струна только в локальной памяти устройства (синий)
}

- (void)SetNameIcon:(NSString *)Name;
- (void)InitMemory;

- (id)initWithName:(NSString *)NameString WithParent:(FractalString *)Parent
     WithContainer:(StringContainer *)pContainer;

- (id)initWithData:(NSMutableData *)pData WithCurRead:(int *)iCurReadingPos 
        WithParent:(FractalString *)Parent WithContainer:(StringContainer *)pContainer;

- (id)initWithDataAndMerge:(NSMutableData *)pData WithCurRead:(int *)iCurReadingPos
                WithParent:(FractalString *)Parent WithContainer:(StringContainer *)pContainer;

- (id)initAsCopy:(FractalString *)pStrSource WithParent:(FractalString *)Parent
   WithContainer:(StringContainer *)pContainer;

- (id)initAsCopy:(FractalString *)pStrSource WithParent:(FractalString *)Parent
   WithContainer:(StringContainer *)pContainer WithLevel:(int)iCurLevel WithMaxDeep:(int)iDeep;

-(void)selfSaveOnlyStructure:(NSMutableData *)m_pData WithVer:(int)iVersion
                        Deep:(int)iDeep MaxDeep:(int)iMaxDeep;

-(void)selfSave:(NSMutableData *)m_pData WithVer:(int)iVersion;
-(void)selfLoad:(NSMutableData *)m_pData ReadPos:(int *)iCurReadingPos
        WithContainer:(StringContainer *)pContainer;

-(void)SetFlag:(int)iFlag;

-(void)selfLoadOnlyStructure:(NSMutableData *)pData ReadPos:(int *)iCurReadingPos;

@end