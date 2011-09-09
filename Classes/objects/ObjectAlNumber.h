
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
#define NAME_TEMPLETS_OBJECT ObjectAlNumber

/** Шаблонный класс для объектов**/
@interface NAME_TEMPLETS_OBJECT : GObject {
	
	int m_iCurrenNumber;
	int m_iPlace;
	float m_fSpeedScale;
	
	int m_iCurrentFrame;
	float Velocity;	
    
    int iFinishFrame;
    float InstFrameFloat;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

- (void)Move:(Processor_ex *)pProc;

/** **/
-(void)dealloc;
-(void)Start;

@end
