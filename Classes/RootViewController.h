#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PrSettings.h"

@class MainController;
@class PreviewController;

/**
 перечисляемая структура видов 
 **/
typedef enum tagRootViewControllerState {
	vwPreview = 0,	
	vwGame = 1,
} EGP_RootViewController;
//------------------------------------------------------------------------------------------------------
@interface RootViewController : UIViewController {
	
	EGP_RootViewController m_iCurrentView;
	MainController *m_pMainController;
	PreviewController *m_pPreviewController;
	
	CPrSettings* m_pPrSettings;
	
	float m_fSwitchViewTimer;
    float m_fTimePause;
}
//------------------------------------------------------------------------------------------------------

- (void)initViews;

- (void)toggleView: (int) iViewID;

-(void)SetPrSettings: (CPrSettings*)pPrSettings;

- (void)SelfMove:(double)DeltaTime;

-(BOOL)isDeviceAniPad;
@property (nonatomic, retain) MainController *m_pMainController;
@property (nonatomic, retain) PreviewController *m_pPreviewController;
//------------------------------------------------------------------------------------------------------
@end
