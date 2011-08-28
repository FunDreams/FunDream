
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
#define NAME_TEMPLETS_OBJECT ObjectAura

/** Шаблонный класс для объектов**/
@interface NAME_TEMPLETS_OBJECT : GObject {	
	int m_iCountNum;
	float m_fCurrentTouchX;
	float m_fCurrentTouchASS;
	
	GObject *m_pCellNum;
	Vector3D m_vOffsetStart;
	NSMutableArray *m_pIntervals;
	
	int m_iSelNumber;
    
    UInt32 iIdChangemNum;
    UInt32 iIdError;
    UInt32 iIdZero;
    
    NSString *OldName;
    
    int m_iPlace;
    float m_fStartX;
    float shift;

    float GooPlace[10];
    float StepAura;
    float LastPlace;
    CGPoint TmpPoint;
    float StepAura2;
    
    GObject * ObCurItems;
    float Width2;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

- (void)GetParams:(CParams *)Parametrs;
- (void)SetParams:(CParams *)Parametrs;

/** **/
-(void)Start;
-(void)Move;
- (void)UpdateNum;


@end
