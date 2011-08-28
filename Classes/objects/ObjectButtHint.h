
//
//  TestGameObject.h
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "Object.h"

//макрос для названия объекта, просто переименуйте его что бы получить новый объект
#define NAME_TEMPLETS_OBJECT ObjectButtHint

/** Шаблонный класс для объектов**/
@interface NAME_TEMPLETS_OBJECT : GObject {
    UInt32 mTextureId2;
    float m_fAlpha2;
    float Phase;
    UInt32 iIdSound1;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

- (void)GetParams:(CParams *)Parametrs;
- (void)SetParams:(CParams *)Parametrs;

/** заготовки =) **/
-(void)Destroy;
-(void)Start;
-(void)Move;

- (void)Disable;
- (void)Enable;


@end
