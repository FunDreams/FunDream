
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


@interface Ob_ParticleCont_ForStr : GObject {
@public
    int **pIndexParticles; //индексы частиц в матрице
    int **pDrawPar; //индексы частиц в матрице
    int **pDrawText; //индексы текстур    
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

/** Добавим/удалим частицу **/
-(int)CreateParticle;
-(void)CopySprite:(int)iPlaceDest source:(int)iPlaceSrc;
-(void)RemoveParticle:(int)iIndexPar;
-(void)RemoveAllParticles;

-(void)UpdateSpriteVertex:(int)Place X:(float)X Y:(float)Y;
-(void)DrawSprite:(int)Place tex:(int)iTex;

-(void)SetDefaultVertex:(int)Place;

-(void)selfLoad:(NSMutableData *)m_pData rpos:(int *)iCurReadingPos;
-(void)selfSave:(NSMutableData *)m_pData;

/** заготовки =) **/
-(void)Destroy;
-(void)Start;

- (void)dealloc;

@end
