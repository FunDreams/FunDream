
//
//  TestGameObject.h
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Object.h"
#import "FractalString.h"
#import "Ob_TouchView.h"
#import "FunArrayData.h"

typedef struct{
    
    int iName;//число-имя ресурса
    NSString *sName;//имя файла
    
} ResourceCell;

@interface Ob_Cont_Res : GObject {
@public
    FunArrayData *ArrayPointsParent;
    int **pIndexRes; //индексы-пары ресурсов в матрице
    ResourceCell *pCells;
    NSMutableDictionary *pDic;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

/** Добавим/удалим частицу **/
-(int)CreateResTexture:(NSString *)sName;
-(int)CreateResSound:(NSString *)sName;
-(void)CopyData:(int)iPlaceDest source:(int)iPlaceSrc;
-(void)RemoveRes:(int)iIndexPar;

-(void)selfLoad:(NSMutableData *)m_pData rpos:(int *)iCurReadingPos;
-(void)selfSave:(NSMutableData *)m_pData;
-(void)PrepareResTexture;
-(void)PrepareResSound;

-(void)CopyRes:(int)iPlaceDest source:(int)iPlaceSrc;

/** заготовки =) **/
-(void)Destroy;
-(void)Start;

- (void)dealloc;

@end
