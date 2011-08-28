//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectCup.h"

@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
	m_iLayer = layerInterfaceSpace1;

    GET_TEXTURE(mTextureId,@"main_interface@2x.png");
    GET_DIM_FROM_TEXTURE(@"main_interface@2x.png");
    
START_QUEUE(@"Proc");
	
	ASSIGN_STAGE(@"e00",@"Idle:",nil);
    
    ASSIGN_STAGE(@"e02",@"AchiveLineFloat:",
                 LINK_FLOAT_V(m_pCurPosition.y,@"Instance"),
                 SET_FLOAT_V(m_pCurPosition.y-960,@"finish_Instance"),
                 SET_FLOAT_V(-1000,@"Vel"));
    
	ASSIGN_STAGE(@"e03",@"DestroySelf:",nil);
    
END_QUEUE(@"Proc");

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
	
	[super Start];
}
//------------------------------------------------------------------------------------------------------
- (void)Move{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT