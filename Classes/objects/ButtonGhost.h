
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

/** Шаблонный класс для объектов**/
@interface ButtonGhost : GObject {

	NSString *m_UP;
	UInt32 m_TextureUP;
	bool m_Disable;
    
    UInt32 iIdYes;
    UInt32 iIdNo;
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
