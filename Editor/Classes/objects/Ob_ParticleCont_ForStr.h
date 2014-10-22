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
#import "Ob_Cont_Res.h"
#import "FunArrayData.h"


#define MODE_EDITOR     1
#define MODE_APP        2

@interface Ob_ParticleCont_ForStr : GObject {
@public
    int **pIndexParticles; //индексы частиц в массиве (все частицы)
    int **pDrawPar; //индексы частиц в матрице

    int **pDrawText2; //индексы текстур
    int **pCounts; //количество индексов одной текстуры

    FunArrayData *ArrayPointsParent;

    float fOffset;
    float fOffsetAngle;
    float CurW,CurH;
    int iMode;
    Ob_TouchView *pTouchOb;

    Ob_Cont_Res *pTexRes;
    Ob_Cont_Res *pSoundRes;
    int iCountTexture;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

/** Добавим/удалим частицу **/
-(int)CreateParticle;
-(void)CopySprite:(int)iPlaceDest source:(int)iPlaceSrc;
-(void)RemoveParticle:(int)iIndexPar;
-(void)RemoveAllParticles;

- (void)SetOrientation;
-(void)UpdateSpriteVertex:(int)Place X:(float)X Y:(float)Y W:(float)W H:(float)H;

-(void)DrawSprites:(int)iCountLoop data1:(int *)SData1 data2:(int *)SData2 data3:(int *)SData3
             data4:(int *)SData4 fdata2:(int *)FData2 data4:(int *)FData4;
-(void)DrawSprites_ex:(int)iCountLoop data1:(int *)SData1 data2:(int *)SData2 data3:(int *)SData34
             data4:(int *)SData4 fdata2:(int *)FData2 data4:(int *)FData4;

-(void)SetDefaultVertex:(int)Place;

-(void)selfLoad:(NSMutableData *)m_pData rpos:(int *)iCurReadingPos;
-(void)selfSave:(NSMutableData *)m_pData;

- (void)SetFullScreen;
- (void)SetWindow;

/** заготовки =) **/
-(void)Destroy;
-(void)Start;

- (void)dealloc;

@end
