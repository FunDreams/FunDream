//
//  Parachute.h
//  Engine
//
//  Created by svp on 17.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"

/** Класс реализующий функционирование объекта**/
@interface CPhysics: GObject {
	b2World* m_pWorld;
	
}

/** Инициализирует объект**/
- (id)Init:(id)Parent WithName:(NSString *)strName;

/** **/
- (void)dealloc;

/** Начало движения**/
- (void)Start;

/** Осуществляет движение**/
- (void)sfWaiting;

/** Осуществляет движение**/
- (void)sfMove;

@end
