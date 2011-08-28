
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

typedef enum tagTypeStaff {
	Koktel = 0,
	Bread,	
	Carrot,	
	apple,
	Tarelka
} TypeStaff;


//макрос для названия объекта, просто переименуйте его что бы получить новый объект
#define NAME_TEMPLETS_OBJECT1 ObjectStaff

/** Шаблонный класс для объектов**/
@interface NAME_TEMPLETS_OBJECT1 : GObject {
	float m_fSpeedScale;
	float m_fPhase;
	
	float m_fVel;
	Vector3D m_pDirection;

	int iType;
	int iFrame;
	
	CGPoint m_pLastPoint;

	UInt32 iIdSound_ObVisible;

	UInt32 iIdSound_Gtesto;
	UInt32 iIdSound_Gapple;
	UInt32 iIdSound_Gcarrot;
	UInt32 iIdSound_GBread;
	UInt32 iIdSound_GKoktel;

	UInt32 iIdSound_Btesto;
	UInt32 iIdSound_Bapple;
	UInt32 iIdSound_Bcarrot;
	UInt32 iIdSound_BBread;
	UInt32 iIdSound_BKoktel;
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
