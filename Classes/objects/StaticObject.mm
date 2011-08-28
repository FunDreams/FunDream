//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "StaticObject.h"

@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
	[super Start];
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//------------------------------------------------------------------------------------------------------
- (void)sfMove{}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT

