//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectSlice.h"

@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
	m_iLayer = layerInterfaceSpace4;

LOAD_TEXTURE(mTextureId,@"slice.png");

START_PROC(@"Proc");
	UP_POINT(@"p00_f_Instance",&mColor.alpha);
	UP_CONST_FLOAT(@"s00_f_Instance",1);
	UP_CONST_FLOAT(@"f00_f_Instance",0);
	UP_CONST_FLOAT(@"s00_f_vel",-3.5f);
	UP_SELECTOR(@"e00",@"AchiveLineFloat:");

	UP_SELECTOR(@"e01",@"DestroySelf:");
END_PROC(@"Proc");

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)GetParams:(CParams *)Parametrs{[super GetParams:Parametrs];}
//------------------------------------------------------------------------------------------------------
- (void)SetParams:(CParams *)Parametrs{[super SetParams:Parametrs];}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
	[super Start];

    [[self FindProcByName:@"Proc"] SetStage:0];
}
//------------------------------------------------------------------------------------------------------
- (void)Move{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor *)pProc{}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT