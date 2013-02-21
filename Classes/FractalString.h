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

#define ADIT_TYPE_SIMPLE      0x0001//для внутренных использований
#define ADIT_TYPE_ENTER       0x0002//для входных параметров
#define ADIT_TYPE_EXIT        0x0003//для выходных параметров
//-------------------------------------------------------------------------------------------------
#define SIZE_INFO_STRUCT    3
typedef struct{
    short mCount;     //количество элементов в массиве
    short mCopasity;  //ёмкость
    BYTE  mCountAdd;  //количество элеменнтов добавляемое при расширении
    BYTE  mFlags;     //флаги массива-переменной
    BYTE mType;        //тип данных в массиве
    BYTE mReserv;
    MATRIXcell *ParentMatrix;
}InfoArrayValue;
//-------------------------------------------------------------------------------------------------
@interface FractalString : NSObject{
@public
    
    int m_iIndex;//сслыка на данные струны
    int m_iIndexSelf;//индекс в структуре данных
    NSString *strUID;//уникальный идентификатор струны (случайное имя для словаря)
//--------------------------------------------------------------------------------------------------
    //индексы
    int **pChildString; //id (струны)(array)

    StringContainer *m_pContainer;//контейнер содержащий струну
    FractalString *pParent;//струна родитель
    
    bool bAlradySave;
//--------------------------------------------------------------------------------------------------
    //информация для редактора
    float X;
    float Y;
    
    NSString *sNameIcon;//имя иконки
    int m_iFlags;
    short m_iAdditionalType;
    NSMutableDictionary *pAssotiation;//ассоциации
}

- (id)init:(StringContainer *)pContainer;
- (void)InitMemory;
- (void)SetNameIcon:(NSString *)Name;

- (void)SetParent:(FractalString *)Parent;

- (id)initWithName:(NSString *)NameString WithParent:(FractalString *)Parent
     WithContainer:(StringContainer *)pContainer;

- (id)initWithData:(NSMutableData *)pData WithCurRead:(int *)iCurReadingPos 
        WithParent:(FractalString *)Parent WithContainer:(StringContainer *)pContainer;

- (id)initAsCopy:(FractalString *)pStrSource WithParent:(FractalString *)Parent
   WithContainer:(StringContainer *)pContainer WithSourceContainer:(StringContainer *)pSrcContainer
        WithLink:(bool)bLink;

-(void)LoadData:(NSMutableData *)pData ReadPos:(int *)iCurReadingPos;
-(void)SaveData:(NSMutableData *)pData;

-(void)selfSave:(NSMutableData *)m_pData WithVer:(int)iVersion;
-(void)selfLoad:(NSMutableData *)m_pData ReadPos:(int *)iCurReadingPos
        WithContainer:(StringContainer *)pContainer;

- (void)CopyChild:(int)iNewCopy WithDic:(NSMutableDictionary *)pDicRename
       WithParent:(FractalString *)Parent WithSourceContainer:(StringContainer *)pSrcContainer
        WithModel:(FractalString *)pModel;

-(void)SetFlag:(int)iFlag;
//--------------------------------------------------------------------------------------------------
@end