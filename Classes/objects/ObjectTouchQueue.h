
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

#define LIMIT_POINTS 3
#define TIME_LIFE 0.2f
//макрос для названия объекта, просто переименуйте его что бы получить новый объект
#define NAME_TEMPLETS_OBJECT ObjectTouchQueue

@interface PointQueue : NSObject {
	@public
	Vector3D vPoint;
	float m_fTime;
}

-(id)Init:(float)Time WithPoint:(CGPoint)Point;
-(void)dealloc;

@end

/** Шаблонный класс для объектов**/
@interface NAME_TEMPLETS_OBJECT : GObject {
	NSMutableArray *m_pPoints;
	bool m_bEnable;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

- (void)GetParams:(CParams *)Parametrs;
- (void)SetParams:(CParams *)Parametrs;

- (void)UpdateArray;
/** **/
-(void)dealloc;
-(void)Start;
-(void)Move;

@end
