//
//  EngineAppDelegate.m
//  Engine
//
//  Created by Konstantin on 01.04.10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "EngineAppDelegate.h"

#ifdef EDITOR
#import <DropboxSDK/DropboxSDK.h>
#endif

//#if !defined (CONFIGURATION_AppStore_Distribution)
//#import "BWHockeyManager.h"
//#import "BWQuincyManager.h"
//#endif

#ifdef EDITOR
@interface EngineAppDelegate () <DBSessionDelegate, DBNetworkRequestDelegate>
@end
#endif

@implementation EngineAppDelegate

@synthesize window;
@synthesize m_pRootViewController;
//------------------------------------------------------------------------------------------------------
- (void)applicationDidFinishLaunching:(UIApplication *)application {    

#ifdef EDITOR
    // Set these variables before launching the app
    NSString* appKey = @"4mrgtc1jg1k1gub";
	NSString* appSecret = @"6tyvjyni3p0zpp3";
    
	NSString *root = kDBRootAppFolder; // Should be set to either kDBRootAppFolder or kDBRootDropbox
	// You can determine if you have App folder access or Full Dropbox along with your consumer key/secret
	// from https://dropbox.com/developers/apps
	
	// Look below where the DBSession is created to understand how to use DBSession in your app
	
	NSString* errorMsg = nil;
	if ([appKey rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
		errorMsg = @"Make sure you set the app key correctly in DBRouletteAppDelegate.m";
	} else if ([appSecret rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
		errorMsg = @"Make sure you set the app secret correctly in DBRouletteAppDelegate.m";
	} else if ([root length] == 0) {
		errorMsg = @"Set your root to use either App Folder of full Dropbox";
	} else {
		NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
		NSData *plistData = [NSData dataWithContentsOfFile:plistPath];
		NSDictionary *loadedPlist =
        [NSPropertyListSerialization
         propertyListFromData:plistData mutabilityOption:0 format:NULL errorDescription:NULL];
		NSString *scheme = [[[[loadedPlist objectForKey:@"CFBundleURLTypes"] objectAtIndex:0] objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
		if ([scheme isEqual:@"db-APP_KEY"]) {
			errorMsg = @"Set your URL scheme correctly in DBRoulette-Info.plist";
		}
	}
	
	DBSession* session =
    [[DBSession alloc] initWithAppKey:appKey appSecret:appSecret root:root];
	session.delegate = self; // DBSessionDelegate methods allow you to handle re-authenticating
	[DBSession setSharedSession:session];
    [session release];
	
	[DBRequest setNetworkRequestDelegate:self];
    
	if (errorMsg != nil) {
		[[[[UIAlertView alloc]
		   initWithTitle:@"Error Configuring Session" message:errorMsg
		   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
		  autorelease]
		 show];
	}
#endif
    
    // This variable is available if you add "CONFIGURATION_$(CONFIGURATION)"
    // to the Preprocessor Macros in the project settings to all configurations
        
	m_pPrSettings = [[CPrSettings alloc] init];
	[m_pPrSettings Load];

	[m_pRootViewController SetPrSettings:m_pPrSettings]; 
	[m_pRootViewController initViews];

	[window addSubview:m_pRootViewController.view];
	
    [window makeKeyAndVisible];
//--------------------------------------------------------------------------
//	m_pTimer=[NSTimer scheduledTimerWithTimeInterval:(1.0f/60.0f) target:self selector:@selector(OnTimer) userInfo:nil repeats:YES];

    m_flastTime = CFAbsoluteTimeGetCurrent();

#ifdef EDITOR
    [self LinkSesstion];
#endif
//	[MKStoreManager sharedManager];
}
//----------------------------------------------------------------------------------------------------
- (void)LinkSesstion{
    
    if (![[DBSession sharedSession] isLinked])
		[[DBSession sharedSession] linkFromController:m_pRootViewController];
    //   else [[DBSession sharedSession] unlinkAll];
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
    
    [m_pRootViewController.m_pMainController MegaPause:NO];
    
    m_pTimer=[NSTimer scheduledTimerWithTimeInterval:(1.0f/60.0f)
        target:self selector:@selector(OnTimer) userInfo:nil repeats:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application{

    [m_pTimer invalidate];
    [m_pRootViewController.m_pMainController MegaPause:YES];
    [m_pPrSettings Save];
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    
#ifdef EDITOR
    [m_pRootViewController->m_pMainController->m_pObjMng->pStringContainer SaveContainer];
#endif
    
	[m_pPrSettings Save];

}

- (void)applicationWillTerminate:(UIApplication *)application{
	
    [m_pTimer invalidate];
    
#ifdef EDITOR
    [m_pRootViewController->m_pMainController->m_pObjMng->pStringContainer SaveContainer];
#endif
    
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

#ifdef EDITOR
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	if ([[DBSession sharedSession] handleOpenURL:url]) {
		if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"Link Success");
            
            GObject *pOb = [m_pRootViewController->m_pMainController->m_pObjMng GetObjectByName:@"DropBox"];
            SEL TmpSel=NSSelectorFromString(@"ReLinkDataManager");

            if([pOb respondsToSelector:TmpSel])
                [pOb performSelector:TmpSel];
            
            [m_pRootViewController->m_pMainController->m_pObjMng->pStringContainer ReLinkDataManager];
            
            return YES;
        }
	}
	
	return NO;
}

#pragma mark -
#pragma mark DBSessionDelegate methods

- (void)sessionDidReceiveAuthorizationFailure:(DBSession*)session userId:(NSString *)userId {
//	relinkUserId = [userId retain];
//	[[[[UIAlertView alloc]
//	   initWithTitle:@"Dropbox Session Ended" message:@"Do you want to relink?" delegate:self
//	   cancelButtonTitle:@"Cancel" otherButtonTitles:@"Relink", nil]
//	  autorelease]
//	 show];
}


#pragma mark -
#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index {
//	if (index != alertView.cancelButtonIndex) {
//		[[DBSession sharedSession] linkUserId:relinkUserId fromController:rootViewController];
//	}
//	[relinkUserId release];
//	relinkUserId = nil;
}

#pragma mark -
#pragma mark DBNetworkRequestDelegate methods

static int outstandingRequests;

- (void)networkRequestStarted {
	outstandingRequests++;
	if (outstandingRequests == 1) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	}
}

- (void)networkRequestStopped {
	outstandingRequests--;
	if (outstandingRequests == 0) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
}
#endif

@end
