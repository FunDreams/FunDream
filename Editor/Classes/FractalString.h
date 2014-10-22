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
#define F_ORDER       0x01//упорядоченность массива
#define F_SYS         0x02//системный массив
#define F_DATA        0x04//массив данных
#define F_DATA_UNION  0x08//данные для слияния
#define F_EN          0x10//используется для входных параметров
#define F_EX          0x20//используется для выходных параметров
//40
//80
typedef union _CurMatrDet
{
    int indexMatrix;
    MATRIXcell *ParentMatrix;
}CurMatrDet;

#define SIZE_INFO_STRUCT    4
typedef struct{
    unsigned int mCount;     //количество элементов в массиве
    unsigned int mCopasity;  //ёмкость
    BYTE  mCountAdd;  //количество элеменнтов добавляемое при расширении
    BYTE  mFlags;     //флаги (массива-переменной)
    BYTE mType;       //тип данных в массиве
    BYTE mGroup;      //номер группы для входных/выходных параметров
    
    CurMatrDet UnParentMatrix;
}InfoArrayValue;

//typedef struct{
//    short mCount;     //количество элементов в массиве
//    short mCopasity;  //ёмкость
//    BYTE  mCountAdd;  //количество элеменнтов добавляемое при расширении
//    BYTE  mFlags;     //флаги (массива-переменной)
//    BYTE mType;       //тип данных в массиве
//    BYTE mReserv;
//    
//    CurMatrDet UnParentMatrix;
//}InfoArrayValueOld;
//-------------------------------------------------------------------------------------------------
@interface FractalString : NSObject{
@public
    
    int m_iIndex;//сслыка на данные струны
    int m_iIndexSelf;//индекс в структуре данных
    NSString *strUID;//уникальный идентификатор струны (случайное имя для словаря)
//--------------------------------------------------------------------------------------------------
    //индексы
    FractalString *pParent;//струна родитель
    int **pChildString; //id (струны)(array)

    StringContainer *m_pContainer;//контейнер содержащий струну
    
    bool bAlradySave;
    bool bAlradyPrepare;
//--------------------------------------------------------------------------------------------------
    //информация для редактора
    float X;
    float Y;
    
    NSString *sNameIcon;//имя иконки
    NSString *sNameIcon2;//имя иконки 2
    NSString *sNameIcon3;//имя иконки 3
    int m_iFlags;
    short m_iAdditionalType;//simple/ex/en
    NSMutableDictionary *pAssotiation;//ассоциации
    int m_iCurState;//for array (создавать ссылки)
}

- (id)init:(StringContainer *)pContainer;
- (void)InitMemory;
- (void)SetNameIcon:(NSString *)Name;
- (void)SetNameIcon2:(NSString *)Name;
- (void)SetNameIcon3:(NSString *)Name;

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

-(void)PrepareMatrix:(StringContainer *)pContainer WithStartString:(FractalString *)pString;

-(void)SetFlag:(int)iFlag;
//--------------------------------------------------------------------------------------------------
@end