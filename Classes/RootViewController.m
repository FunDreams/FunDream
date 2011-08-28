#import "RootViewController.h"
#import "MainController.h"
#import "PreviewController.h"
//------------------------------------------------------------------------------------------------------
@implementation RootViewController

@synthesize m_pMainController;
@synthesize m_pPreviewController;
//------------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	
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
- (void)initViews
{
	if([self isDeviceAniPad])
	{
		m_pMainController = [[MainController alloc] initWithNibName:@"mainController-ipad" bundle:nil];
		m_pPreviewController = [[PreviewController alloc] initWithNibName:@"PreviewController-ipad" bundle:nil];
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
    [m_pMainController Start];
}
//------------------------------------------------------------------------------------------------------
- (void)toggleView: (int) iViewID {	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
	
	if ( iViewID == vwPreview && m_iCurrentView != vwPreview ) {
		
		[m_pPreviewController viewWillAppear:YES];
		[m_pMainController viewWillDisappear:YES];
		
        [m_pMainController.view removeFromSuperview];

		[m_pMainController viewDidDisappear:YES];
		[m_pPreviewController viewDidAppear:YES];
		m_iCurrentView = vwPreview;
		
	} else	if ( iViewID == vwGame && m_iCurrentView != vwGame ) {
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
- (void)SelfMove:(double)DeltaTime{
	
//	[NSThread sleepForTimeInterval:0.1f];
	
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
                [m_pPreviewController SelfMove:DeltaTime];
            }        
        }
    }
}
//------------------------------------------------------------------------------------------------------
@end
