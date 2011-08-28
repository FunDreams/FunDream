//
//  Parachute.h
//  Engine
//
//  Created by svp on 17.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Box2D.h"
#import <Foundation/Foundation.h>
#import "Object.h"

typedef enum tagJumperViewDir {
	jwdLeft = -1,	//ожидание
	jwdRight = 1	//
} EGP_JumperViewDir;

/** Класс реализующий функционирование объэкта типа "яйцо"**/
@interface CJumper:GObject {

	b2World* m_pWorld;
	b2Body* m_pBody;
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
