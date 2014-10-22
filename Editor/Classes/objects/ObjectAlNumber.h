
//
//  TestGameObject.h
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Object.h"
#import "ObjectParticle.h"

//макрос для названия объекта, просто переименуйте его что бы получить новый объект
#define NAME_TEMPLETS_OBJECT ObjectAlNumber

/** Шаблонный класс для объектов**/
@interface NAME_TEMPLETS_OBJECT : GObject {
	
	int m_iCurrenNumber;
	int m_iCurrenNumberOld;
	int m_iPlace;
	float m_fSpeedScale;
	
	int m_iCurrentFrame;
	float Velocity;	
    
    int iFinishFrame;
    float InstFrameFloat;
    
    NSMutableString *m_strNameContainer;
    Particle *pParticle;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

- (void)Move:(Processor_ex *)pProc;

/** **/
-(void)Start;

- (void)HideNum;
- (void)ShowNum;

- (void)PrepareTexture:(Processor_ex *)pProc;

- (void)SwitchSym;

@end
