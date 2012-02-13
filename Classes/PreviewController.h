#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PreviewController : UIViewController {
	
	RootViewController* m_pRootViewController;
	CPrSettings* m_pPrSettings;
	
}
@property (nonatomic, retain) CPrSettings* m_pPrSettings;
@property (nonatomic, retain) RootViewController* m_pRootViewController;

- (void)SelfMove:(double)DeltaTime;


@end
