//
//  EngineAppDelegate.m
//  Engine
//
//  Created by Konstantin on 01.04.10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "EngineAppDelegate.h"

//#if !defined (CONFIGURATION_AppStore_Distribution)
//#import "BWHockeyManager.h"
//#import "BWQuincyManager.h"
//#endif

@implementation EngineAppDelegate

@synthesize window;
@synthesize m_pRootViewController;
//------------------------------------------------------------------------------------------------------
- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // This variable is available if you add "CONFIGURATION_$(CONFIGURATION)"
    // to the Preprocessor Macros in the project settings to all configurations
    
//#if TARGET_IPHONE_SIMULATOR
//#else
//#if !defined (CONFIGURATION_AppStore_Distribution)
//    [[BWHockeyManager sharedHockeyManager] setAppIdentifier:@"e3e0c655a45a89bed3d55c1c8ebb9f77"];
//    [[BWHockeyManager sharedHockeyManager] setAlwaysShowUpdateReminder:YES];
//    
//    [[BWQuincyManager sharedQuincyManager] setAppIdentifier:@"e3e0c655a45a89bed3d55c1c8ebb9f77"];
//#endif
//#endif
    
	m_pPrSettings = [[CPrSettings alloc] init];
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
//	if (![m_pRootViewController isReady])
//    {
//        // root controller still performs initialization
//        return;
//    }
    
 //   @try {
        CFTimeInterval time;
        time = CFAbsoluteTimeGetCurrent();
        double delta = (time - m_flastTime);
        if( delta > 0.1f ) delta = 0.1f;
    //    if( delta < 0.001 ) delta = 0.001;
        m_flastTime=time;
        
        [m_pRootViewController SelfMove:delta];

//FPS----------------------------------------------------------------------------
#ifdef FPS
	static int AllFrame=0;
	static float fTimeOneSecond=0;
	static int iNumFrame=0;
	static int AllCount=0; 
	iNumFrame++;
	fTimeOneSecond+=delta;
    
	if(fTimeOneSecond>=1){
		
		AllFrame+=iNumFrame;
		AllCount++;
		
		NSLog(@"FPS:%d===%d",iNumFrame,AllFrame/AllCount);
        
		fTimeOneSecond=0;
		iNumFrame=0;		
	}
#endif
//-------------------------------------------------------------------------------

//    }
//    @catch (NSException *exception) {
//        NSLog ( @"Exception caught: %@", exception );
//
//    }
//    @finally {
//        int m=0;
//    }

}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    
    [m_pRootViewController.m_pMainController Pause:NO];
    
    m_pTimer=[NSTimer scheduledTimerWithTimeInterval:(1.0f/60.0f)
        target:self selector:@selector(OnTimer) userInfo:nil repeats:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application{
    
    [m_pTimer invalidate];
    [m_pRootViewController.m_pMainController Pause:YES];
    [m_pPrSettings Save];
}

- (void)applicationWillTerminate:(UIApplication *)application{
	
    [m_pTimer invalidate];
	[m_pPrSettings Save];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	NSLog(@"memory warning");
}

- (void)dealloc {
	
	[m_pTimer invalidate];

    [window release];
	[m_pRootViewController release];
    [m_pPrSettings release];
	
    [super dealloc];
}

@end
