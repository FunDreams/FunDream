
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
#define NAME_TEMPLETS_OBJECT ObjectSymbol

/** Шаблонный класс для объектов**/
@interface NAME_TEMPLETS_OBJECT : GObject {
	int m_iCurrentSym;
	
	float m_fPhase;
	float m_fSpeedScale;    
    
    int m_iNextStage;
    
    float m_fOffsetPosYTmp;
    
    float m_fRotateVel;
    Vector3D m_Vvelosity;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

- (void)GetParams:(CParams *)Parametrs;
- (void)SetParams:(CParams *)Parametrs;

/** **/
-(void)dealloc;
-(void)Start;
-(void)Move;

@end
