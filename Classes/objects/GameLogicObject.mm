//
//  TestGameObject.m
//  Engine
//
//  Created by Konstantin on 02.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "GameLogicObject.h"

#ifdef BLACK_PIG
#import "ObjectStaff.h"
#endif

@implementation CGameLogic
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];

	m_bHiden = true;

//    LOAD_SOUND(iIdSound, @"papper.wav", NO);
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {
	[super dealloc];
}
//------------------------------------------------------------------------------------------------------
- (void)Start
{
	CREATE_NEW_OBJECT(@"StaticObject",@"Fon",
                      SET_STRING_V(@"fon@2x.png",@"m_pNameTexture"),
					  SET_FLOAT_V(640,@"mWidth"),
					  SET_FLOAT_V(960,@"mHeight"),
					  SET_INT_V(layerBackground,@"m_iLayer"));
	
	for (int k=0; k<14; k++) {	
		NSString *NameOb= [[[NSString alloc] initWithFormat:@"ObjectAlNumber%d",k] autorelease];
		RESERV_NEW_OBJECT(@"ObjectAlNumber",NameOb,nil);
	}
	
	for (int k=0; k<7; k++) {	
		NSString *NameOb= [[[NSString alloc] initWithFormat:@"ObjectAlNumber%d",k] autorelease];
		CREATE_NEW_OBJECT(@"ObjectAlNumber",NameOb,
						  SET_INT_V(k,@"m_iPlace"),
						  SET_INT_V(RND%9,@"m_iCurrenNumber"));
	}
//interface======================================================================
//	CREATE_NEW_OBJECT(@"ObjectButton",@"ButtonPlay",
//					  SET_STRING_V(@"Button_Play_down@2x.png",@"m_DOWN"),
//					  SET_STRING_V(@"Button_Play_up@2x.png",@"m_UP"),
//					  SET_FLOAT_V(280,@"mWidth"),
//					  SET_FLOAT_V(300,@"mHeight"),
//					  SET_VECTOR_V(Vector3DMake(180,330,0),@"m_pCurPosition"));
//===============================================================================
//	CREATE_NEW_OBJECT(@"ObjectCup",@"Cup",nil);
    CREATE_NEW_OBJECT(@"ObjectWorld",@"World",nil);
    CREATE_NEW_OBJECT(@"ObjectMultiTouch",@"OMultiTouch",nil);
    
//  CREATE_NEW_OBJECT(@"ObjectTest",@"Test",nil);

//физика приложения тут///////////////////////////////////////////////////////		
//	CREATE_NEW_OBJECT(@"CPhysics",@"Physics",nil);
//	CREATE_NEW_OBJECT(@"CJumper",@"TestJumper",nil);
    
    for (int k=0; k<40; k++) {	
		NSString *NameOb= [[[NSString alloc] initWithFormat:@"ObjectPSimple%d",k] autorelease];
		RESERV_NEW_OBJECT(@"ObjectPSimple",NameOb,nil);
	}
}
@end
