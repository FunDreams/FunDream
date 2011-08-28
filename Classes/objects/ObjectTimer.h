
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
#define NAME_TEMPLETS_OBJECT ObjectTimer

/** Шаблонный класс для объектов**/
@interface NAME_TEMPLETS_OBJECT : GObject {
	float m_fTimer;
	float m_fOldTimer;
	
	int Sec;
	int Min;
	int Hour;	
	
	int iCountColon;
	int iCountNum;

	float m_fWColon;
	float m_fWNumber;
	
	int iDir;
	
	Color3D m_cNumbers;
    bool m_bSuspend;
    
    float m_fVelTranslate;
    float m_fCurPosSlader2;
    
    int m_iNextStage;
    
    UInt32 iIdWin;
    UInt32 iIdMegaWin;
    UInt32 iIdNoRecord;
    uint32 iIdBrRecord;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

- (void)GetParams:(CParams *)Parametrs;
- (void)SetParams:(CParams *)Parametrs;

/** **/
-(void)dealloc;
-(void)Start;
-(void)Move;
-(void)UpdatePos;
- (void)UpdateTimer;

- (void)ResetTimer;
- (void)SuspendTimer;
-(void)ResumeTimer;
-(void)SetColorSym;


@end
