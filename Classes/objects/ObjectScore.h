
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
@interface ObjectScore : StaticObject {
	
	int iCountScore;
	int iScoreAdd;
	
	float m_fWNumber;
    float WSym,HSym;
    
    NSMutableString *m_strStartStage;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

- (void)UpdateScore;
/** **/

-(void)SetColorSym;
-(void)dealloc;
-(void)Start;

@end
