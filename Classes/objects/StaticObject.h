
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
#define NAME_TEMPLETS_OBJECT StaticObject

/** Шаблонный класс для объектов**/
@interface NAME_TEMPLETS_OBJECT : GObject {
    bool m_bDimFromTexture;
    bool m_bDimMirrorX;
    bool m_bDimMirrorY;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

/** **/
-(void)dealloc;
-(void)sfMove;
-(void)Start;

@end