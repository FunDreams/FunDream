//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectTest.h"

@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];    
    
    mWidth  = 50;
	mHeight = 80;
    
    m_iLayer = layerTemplet;

    m_bHiden=YES;
    
//START_QUEUE(@"test2")
//    
//    ASSIGN_STAGE(@"TestStage",@"AchiveLineFloat:",
//                 LINK_FLOAT_V(m_pCurAngle.z,@"Instance"),
//                 SET_FLOAT_V(m_pCurPosition.y-3000000,@"finish_Instance"),
//                 SET_FLOAT_V(-100,@"Vel"));
//    
//    
//END_QUEUE(@"test2")

//START_QUEUE(@"test")
//
//    ASSIGN_STAGE(@"TestStage",@"AchiveLineFloat:",
//                 LINK_FLOAT_V(m_pCurPosition.y,@"Instance"),
//                 SET_FLOAT_V(m_pCurPosition.y-300,@"finish_Instance"),
//                 SET_FLOAT_V(-40,@"Vel"));
//    
//  //  PARAMS_STAGE(@"TestStage",SET_FLOAT_V(-400,@"Vel"));
//
//    ASSIGN_STAGE(@"Stage1",@"TestSel:",nil);
//    DELAY_STAGE(@"Stage1",3000,1000);
//
//    ASSIGN_STAGE(@"Stage2",@"TestSel2:",nil);
//
//    INSERT_STAGE(@"Stage3",@"TestSel3:",@"Stage2",nil);
//    
//END_QUEUE(@"test")
    
//START_QUEUE(@"test")
//    REMOVE_STAGE(@"Stage2");//[pProc Remove_Stage:@"Stage2"];
//END_QUEUE(@"test")

    return self;
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];

    pParticle=[[Particle alloc] Init:self];
    [pParticle AddToContainer:@"SysParticles"];
}
//------------------------------------------------------------------------------------------------------
- (void)Move:(Processor_ex *)pProc{
}
//------------------------------------------------------------------------------------------------------
- (void)timesel:(Processor_ex *)pProc{

}
//------------------------------------------------------------------------------------------------------
- (void)testAction2:(Processor_ex *)pProc{
	
}
//------------------------------------------------------------------------------------------------------
- (void)testAction:(Processor_ex *)pProc{
}
//------------------------------------------------------------------------------------------------------
- (void)TestSel3:(Processor_ex *)pProc{
  //  int m=0;
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)TestSel2:(Processor_ex *)pProc{
 //   int m=0;
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)TestSel:(Processor_ex *)pProc{
//	int m=0;
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    [pParticle release];

    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {
	[super dealloc];
}
//------------------------------------------------------------------------------------------------------
- (void)sfMove{}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT