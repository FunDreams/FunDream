#import "RootViewController.h"
#import "MainController.h"
#import "PreviewController.h"
//------------------------------------------------------------------------------------------------------
@implementation RootViewController

@synthesize m_pMainController;
@synthesize m_pPreviewController;
//------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
{	
	m_pPrSettings = nil;
	m_pMainController = nil;
	m_pPreviewController = nil;
	
	m_fSwitchViewTimer = 0;
    m_fTimePause=1;
}
//------------------------------------------------------------------------------------------------------
-(BOOL)isDeviceAniPad
{   
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES; 
    }
#endif
    return NO;
}
//------------------------------------------------------------------------------------------------------
-(void) completeLoading
{
    [self.view insertSubview:m_pMainController.view atIndex:0];
    
    m_iCurrentView = vwPreview;

    [m_pMainController Start];
    [m_pMainController Pause:NO];
    loadingSubviews = NO;
}
//------------------------------------------------------------------------------------------------------
- (void) loadVerySlowLoadingViews
{
//    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    // do all time-intensive jobs here
    
    // draw what's loaded in a Main Thread. 
    // we can't draw in a background thread because GL does not support this.
//    [self performSelectorOnMainThread:@selector(completeLoading) withObject:nil waitUntilDone:NO];
    
//    [pool drain];
    
    [self completeLoading];
}
//------------------------------------------------------------------------------------------------------
-(BOOL) isReady
{
    return !loadingSubviews;
}
//------------------------------------------------------------------------------------------------------
- (void)initViews
{
	if([self isDeviceAniPad])
	{
		m_pMainController = [[MainController alloc] initWithNibName:@"mainController-ipad" bundle:nil];
		m_pPreviewController=[[PreviewController alloc] initWithNibName:@"PreviewController-ipad" bundle:nil];
	}
	else 
	{
		m_pMainController = [[MainController alloc] initWithNibName:@"mainController" bundle:nil];		
		m_pPreviewController=[[PreviewController alloc] initWithNibName:@"PreviewController" bundle:nil];
	}
    
	m_pMainController.m_pRootViewController = self;
	m_pMainController.m_pPrSettings=m_pPrSettings;
	
	m_pPreviewController.m_pRootViewController = self;
	m_pPreviewController.m_pPrSettings=m_pPrSettings;
	
	m_iCurrentView = vwPreview;
    [self.view addSubview:m_pMainController.view];
    [self.view addSubview:m_pPreviewController.view];
    
    [m_pMainController createGLView];
    [m_pMainController Start];
}
//------------------------------------------------------------------------------------------------------
- (void)toggleView: (int) iViewID {	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	
	if ( iViewID == vwPreview && m_iCurrentView != vwPreview )
    {
		[m_pPreviewController viewWillAppear:YES];
		[m_pMainController viewWillDisappear:YES];
		
        [m_pMainController.view removeFromSuperview];

		[m_pMainController viewDidDisappear:YES];
		[m_pPreviewController viewDidAppear:YES];
		m_iCurrentView = vwPreview;
	}
    else if ( iViewID == vwGame && m_iCurrentView != vwGame )
    {
		[m_pMainController viewWillAppear:YES];
		[m_pPreviewController viewWillDisappear:YES];
		
        [m_pPreviewController.view removeFromSuperview];

		[m_pPreviewController viewDidDisappear:YES];
		[m_pMainController viewDidAppear:YES];
		m_iCurrentView = vwGame;
	}
	
	[UIView commitAnimations];
}
//------------------------------------------------------------------------------------------------------
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {}
//------------------------------------------------------------------------------------------------------
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//	// Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
//}
//------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {
	[m_pPreviewController release];
	[m_pMainController release];

	[super dealloc];
}
//------------------------------------------------------------------------------------------------------
-(void)SetPrSettings: (CPrSettings*)pPrSettings
{
	m_pPrSettings = pPrSettings;
}
//------------------------------------------------------------------------------------------------------
- (void)SelfMove:(double)DeltaTime
{
  //  if(loadingSubviews==YES)return;
    
    if( m_iCurrentView == vwPreview  )
    {
        m_fSwitchViewTimer += DeltaTime;
        if( m_fSwitchViewTimer > 0.001 ) {
            [self toggleView: vwGame ];
        }
    }
    else
    {
        if(m_fTimePause>0)
        {
            m_fTimePause-=DeltaTime;
        }
        else
        {
            if( m_iCurrentView == vwGame )
            {
                [m_pMainController SelfMove:DeltaTime];
            }
            if( m_iCurrentView == vwPreview )
            {
      //          [m_pPreviewController SelfMove:DeltaTime];
            }        
        }
    }
}
//------------------------------------------------------------------------------------------------------
@end
