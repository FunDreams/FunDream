
//
//  TestGameObject.h
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StaticObject.h"


/** Шаблонный класс для объектов**/
@interface ObjectScoreFun1 : StaticObject {
	
	int iCountScore;
	int iScoreAdd;
    
    int iCountDownScore;
	int iScoreDownAdd;
	
	float m_fWNumber;
    float WSym,HSym;
    
    NSMutableString *m_strStartStage;
    float m_fStartPos;
    int m_iAlign;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

- (void)UpdateScore;
/** **/

-(void)SetColorSym;
-(void)Start;

@end
