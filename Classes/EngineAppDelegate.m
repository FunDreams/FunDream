//
//  EngineAppDelegate.m
//  Engine
//
//  Created by Konstantin on 01.04.10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "EngineAppDelegate.h"

@implementation EngineAppDelegate

@synthesize window;
@synthesize m_pRootViewController;
//------------------------------------------------------------------------------------------------------
- (void)applicationDidFinishLaunching:(UIApplication *)application {    

	m_pPrSettings = [[CPrSettings alloc] Init];
	[m_pPrSettings Load];

	[m_pRootViewController SetPrSettings:m_pPrSettings]; 
	[m_pRootViewController initViews];

	[window addSubview:m_pRootViewController.view];
	
    [window makeKeyAndVisible];
//--------------------------------------------------------------------------
	m_pTimer=[NSTimer scheduledTimerWithTimeInterval:(1.0f/60.0f) target:self selector:@selector(OnTimer) userInfo:nil repeats:YES];

    m_flastTime = CFAbsoluteTimeGetCurrent();

//	[MKStoreManager sharedManager];
}
//main timer------------------------------------------------------------------------------------------
- (void)OnTimer{
	
 //   @try {
        CFTimeInterval time;
        time = CFAbsoluteTimeGetCurrent();
        double delta = (time - m_flastTime);
        if( delta > 1.0f ) delta = 1.0f;
    //    if( delta < 0.001 ) delta = 0.001;
        m_flastTime=time;
        
        [m_pRootViewController SelfMove:delta];

//    }
//    @catch (NSException *exception) {
//        NSLog ( @"Exception caught: %@", exception );
//
//    }
//    @finally {
//        int m=0;
//    }

}
//------------------------------------------------------------------------------------------------------
- (void)applicationDidBecomeActive:(UIApplication *)application{

    [m_pRootViewController.m_pMainController Pause:NO];
    
    m_pTimer=[NSTimer scheduledTimerWithTimeInterval:(1.0f/60.0f) target:self selector:@selector(OnTimer) userInfo:nil repeats:YES];
}
//------------------------------------------------------------------------------------------------------
- (void)applicationWillResignActive:(UIApplication *)application{
    
    [m_pTimer invalidate];
    [m_pRootViewController.m_pMainController Pause:YES];
    [m_pPrSettings Save];
}
//------------------------------------------------------------------------------------------------------
- (void)applicationWillTerminate:(UIApplication *)application{
	
    [m_pTimer invalidate];
	[m_pPrSettings Save];
}
//------------------------------------------------------------------------------------------------------
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	NSLog(@"memory warning");
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {
	
	[m_pTimer invalidate];

    [window release];
	[m_pRootViewController release];
    [m_pPrSettings release];
	
    [super dealloc];
}
//------------------------------------------------------------------------------------------------------

@end
