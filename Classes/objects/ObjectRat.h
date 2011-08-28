
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
#define NAME_TEMPLETS_OBJECT3 ObjectRat

/** Шаблонный класс для объектов**/
@interface NAME_TEMPLETS_OBJECT3 : GObject {
	float m_fSpeedScale;
	float m_fPhase;
	
	float m_fVel;
	Vector3D m_pDirection;

	int iType;
	int iFrame;
	
	CGPoint m_pLastPoint;

	UInt32 iIdSound_GRat;
	UInt32 iIdSound_BRat;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

- (void)GetParams:(CParams *)Parametrs;
- (void)SetParams:(CParams *)Parametrs;

/** **/
-(void)dealloc;
-(void)Start;
-(void)Move;

- (void)Proc:(Processor *)pProc;

@end
