//
//  FractalString.h
//  FunDreams
//
//  Created by Konstantin Maximov on 28.04.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StringContainer;

#define DEAD_STRING         0x00000001
#define SYNH_AND_HEAD       0x00000002
#define SYNH_AND_LOAD       0x00000004
#define ONLY_IN_MEM         0x00000008

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
    //0x00000002 струна на сервере, а в памяти только структура заголовок
    //0x00000004 струна загружена и синхронизировано с хранилищем
    //0x00000008 струна только в локальной памяти устройства
}

- (id)initWithName:(NSString *)NameString WithParent:(FractalString *)Parent
     WithContainer:(StringContainer *)pContainer S:(int)iS F:(int)iF;

- (id)initWithData:(NSMutableData *)pData WithCurRead:(int *)iCurReadingPos 
        WithParent:(FractalString *)Parent WithContainer:(StringContainer *)pContainer;

- (id)initWithDataAndMerge:(NSMutableData *)pData WithCurRead:(int *)iCurReadingPos
                WithParent:(FractalString *)Parent WithContainer:(StringContainer *)pContainer;

- (id)initAsCopy:(FractalString *)pStrSource WithParent:(FractalString *)Parent
   WithContainer:(StringContainer *)pContainer;

- (id)initAsCopy:(FractalString *)pStrSource WithParent:(FractalString *)Parent
   WithContainer:(StringContainer *)pContainer WithLevel:(int)iCurLevel WithMaxDeep:(int)iDeep;

- (void)SetLimmitStringS:(int)iS F:(int)iF;

-(void)UpDate:(float)fDelta;

-(void)selfSaveOnlyStructure:(NSMutableData *)m_pData WithVer:(int)iVersion
                        Deep:(int)iDeep MaxDeep:(int)iMaxDeep;

-(void)selfSave:(NSMutableData *)m_pData WithVer:(int)iVersion;
-(void)selfLoad:(NSMutableData *)m_pData ReadPos:(int *)iCurReadingPos
        WithContainer:(StringContainer *)pContainer;

-(void)SetFlag:(int)iFlag;

-(void)selfLoadOnlyStructure:(NSMutableData *)pData ReadPos:(int *)iCurReadingPos;

@end