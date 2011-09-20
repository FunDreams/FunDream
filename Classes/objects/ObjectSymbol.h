
//
//  TestGameObject.h
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "StaticObject.h"

/** Шаблонный класс для объектов**/
@interface ObjectSymbol : StaticObject {
	int m_iCurrentSym;
	
	float m_fSpeedScale;    
        
    float m_fOffsetPosYTmp;
    
    float m_fRotateVel;
    Vector3D m_Vvelosity;
    
    NSMutableString *m_strStartStage;
    NSMutableString *m_strNextStage;
    
    int m_iStartTexture;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

/** **/
-(void)dealloc;
-(void)Start;

@end
