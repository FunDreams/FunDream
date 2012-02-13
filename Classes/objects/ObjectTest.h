
//
//  TestGameObject.h
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Object.h"

/** Шаблонный класс для объектов**/
@interface ObjectTest : GObject {
	
	int TestPar;
	DWORD TestDword;
	bool TestBool;
    float TestFloat;
    float TestFloat2;
	NSMutableString *TestStr;
	Vector3D Testvec;
    Color3D TestCol;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

-(void)sfMove;
-(void)Start;

- (void)timesel:(Processor_ex *)pProc;
- (void)testAction:(Processor_ex *)pProc;

@end
