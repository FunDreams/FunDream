//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectTest.h"
#import "UniCell.h"

@implementation ObjectTest

//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];    
    if (self != nil)
    {
        m_bHiden=YES;
        mWidth  = 50;
        mHeight = 80;
        
        m_iLayer = layerTemplet;
//        mTextureId = [m_pParent GetTextureId:@"1-02@2x.png"];
        

        Processor_ex *pProc = [self START_QUEUE:@"test"];

//            ASSIGN_STAGE(@"TestStage",@"AchiveLineFloat:",
//                         LINK_FLOAT_V(m_pCurPosition.y,@"Instance"),
//                         SET_FLOAT_V(m_pCurPosition.y-300,@"finish_Instance"),
//                         SET_FLOAT_V(-40,@"Vel"));
            
          //  PARAMS_STAGE(@"TestStage",SET_FLOAT_V(-400,@"Vel"));

            ASSIGN_STAGE(@"Stage1",@"TestSel:",nil);
        
//            DELAY_STAGE(@"Stage1",3000,1000);

            ASSIGN_STAGE(@"Stage2",@"TestSel2:",nil);

            INSERT_STAGE(@"Stage3",@"TestSel3:",@"Stage2",nil);

        [self END_QUEUE:pProc name:@"test"];
            
        //Processor_ex* pProc = [self START_QUEUE:@"test"];
        //    [pProc Remove_Stage:@"Stage2"];
        //[self END_QUEUE:pProc name:@"test"];
    }
    
    return self;
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];
}
//------------------------------------------------------------------------------------------------------
- (void)Move:(Processor_ex *)pProc{

}

- (void)timesel:(Processor_ex *)pProc{

	[pProc SetStage:pProc->m_CurStage->NameStage];
}

- (void)testAction2:(Processor_ex *)pProc{
	
}

- (void)testAction:(Processor_ex *)pProc{
}

- (void)TestSel3:(Processor_ex *)pProc{
}

- (void)TestSel2:(Processor_ex *)pProc{
 //   int m=0;
    NSLog(@"good");
    [pProc NextStage];
}

- (void)TestSel:(Processor_ex *)pProc{
//	NSLog(@"test");
//    [pProc NextStage];
}

- (void)sfMove
{
}

@end
