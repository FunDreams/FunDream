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
#define DEAD_STRING         0x00000001//струна мёртвая (без ссылок в DropBox'e) (красный)
#define SYNH_AND_HEAD       0x00000002//струна на сервере, а в памяти только структура-заголовок (жёлтый)
#define SYNH_AND_LOAD       0x00000004//струна загружена и синхронизирована с хранилищем (зелёный)
#define ONLY_IN_MEM         0x00000008//струна только в локальной памяти устройства (синий)

#define LINK                0x00000100//струна-ссылка
//-------------------------------------------------------------------------------------------------
//определения для типов струн
#define STR_ZERO            0//нулевой-объект
#define STR_DATA            1//объект-дата
#define STR_OPERATION       2//объект-операция
#define STR_CONTAINER       3//объект со спецефическими свойствами
#define STR_COMPLEX         4//составной объект
//-------------------------------------------------------------------------------------------------
//имена струн
#define NAME_ZERO               0
//имена струн (Данные)
#define NAME_V_FLOAT            1
//имена струн (Операации)
#define NAME_O_PLUS             5001
//имена струн (Контейнеры)
#define NAME_K_START            10001
#define NAME_K_BUTTON_ENVENT    10002

#define NAME_K_INFO_WINDOW      10003//информационное окно
//-------------------------------------------------------------------------------------------------
#define SIZE_INFO_STRUCT    2
typedef struct{
    short mCount;     //количество элементов в массиве
    short mCopasity;  //ёмкость
    BYTE  mCountAdd;  //количество элеменнтов добавляемое при расширении
    BYTE  mFlags;     //флаги массива-переменной
    short mReserv;
}InfoArrayValue;
//-------------------------------------------------------------------------------------------------
@interface FractalString : NSObject{
@public
    
//MATRIX 28.01.2013
//матрица универсальных данных---------------------------------------------------------------------
    int **pValueCopy;//int,float,string,(array)
    int **pValueLink;
    //индексы
    int **pChildString; //id (струны)(array)
    //последовательности4
    int **pEnters;//индексы для последовательности
    int **pExits;

    //типы
    BYTE TypeInformation;//тип струны.
    short NameInformation;//Имя-число струны.
//--------------------------------------------------------------------------------------------------
    int m_iIndex;//индекс в структуре данных
//--------------------------------------------------------------------------------------------------
    StringContainer *m_pContainer;//контейнер содержащий струну
    FractalString *pParent;//струна родитель
//--------------------------------------------------------------------------------------------------
    NSString *strUID;//уникальный идентификатор струны (случайное имя для словаря)
    //информация для редактора
    float X;
    float Y;
    
    NSString *sNameIcon;//имя иконки
    int m_iFlags;
}

- (id)init:(StringContainer *)pContainer;
- (void)InitMemory;
- (void)SetNameIcon:(NSString *)Name;

- (void)SetParent:(FractalString *)Parent;

- (id)initWithName:(NSString *)NameString WithParent:(FractalString *)Parent
     WithContainer:(StringContainer *)pContainer WithLink:(bool)bLink;

- (id)initWithData:(NSMutableData *)pData WithCurRead:(int *)iCurReadingPos 
        WithParent:(FractalString *)Parent WithContainer:(StringContainer *)pContainer;

- (id)initAsCopy:(FractalString *)pStrSource WithParent:(FractalString *)Parent
   WithContainer:(StringContainer *)pContainer WithLink:(bool)bLink;

-(void)LoadData:(NSMutableData *)pData ReadPos:(int *)iCurReadingPos;
-(void)SaveData:(NSMutableData *)pData;

-(void)selfSave:(NSMutableData *)m_pData WithVer:(int)iVersion;
-(void)selfLoad:(NSMutableData *)m_pData ReadPos:(int *)iCurReadingPos
        WithContainer:(StringContainer *)pContainer;

-(void)SetFlag:(int)iFlag;

@end