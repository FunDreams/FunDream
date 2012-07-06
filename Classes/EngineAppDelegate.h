//
//  EngineAppDelegate.h
//  Engine
//
//  Created by Konstantin on 01.04.10.
//  Copyright __FunDreamsInc__ 2010. All rights reserved.
//
#define MIN_DELTA_TIME 0.011f

#import "PlManager.h"
#import "PrSettings.h"
#import "RootViewController.h"
#import "mach/mach_time.h"
//------------------------------------------------------------------------------------------------------
//делегат приложения. корневой класс. отвечает за загрузку данных. Загрузку уровней.
@interface EngineAppDelegate : NSObject <UIApplicationDelegate> {
	//класс-окно необходим для отображения окна
    UIWindow *window;

	//главный контроллер приложения
	RootViewController *m_pRootViewController;

	//таймер. Нужен для обработки объектов 
	NSTimer *m_pTimer;

	CPrSettings* m_pPrSettings;

//	uint64_t m_fTime;
//	mach_timebase_info_data_t m_pTimebaseInfo;

	CADisplayLink *displayLink;
    
    CFTimeInterval m_flastTime;
}

//desc: функция таймера. Цикл обработки приложения.
- (void)OnTimer;

- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)applicationWillResignActive:(UIApplication *)application;
- (void)applicationWillTerminate:(UIApplication *)application;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *m_pRootViewController;


@end
//------------------------------------------------------------------------------------------------------
