//
//  mainController.h
//  Engine
//
//  Created by Konstantin on 01.04.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "GameLogicObject.h"
//#import "ObjectManager.h"
#import "GLView.h"
#import <iAd/iAd.h>

#import <CoreMotion/CoreMotion.h>
//------------------------------------------------------------------------------------------------------
@interface SoundContainer : NSObject {
@public
}
- (id)InitWithName:(NSString *)pName WithUint:(UInt32)SoundId;
@end
//------------------------------------------------------------------------------------------------------
@interface AtlasContainer : NSObject {
@public
	float m_fWidth;
	float m_fHeight;
    
    UInt32	m_iTextureId;
    NSString *pAtlasName;
    
    Vector3D m_vSizeFrame;
    int      m_iCountX;
    int      m_iCountY;
    int      m_INumLoadTextures;
    NSString *m_psNameStartTexture;
}
//------------------------------------------------------------------------------------------------------
- (id)InitWithName:(NSString *)pNamet
            NameStartTexture:(NSString *)pNameStart
            CountX:(int)iCountX
            CountY:(int)iCountY
            NumLoadTextures:(int)iNumLoadTextures
            SizeAtlas:(Vector3D)vSize;

@end
//------------------------------------------------------------------------------------------------------
@interface TextureContainer : NSObject {
@public
	float m_fWidth;
	float m_fHeight;

    UInt32	m_iTextureId;
    bool m_bPvr;
    NSString *pName;
}

- (id)InitWithName:(NSString *)pName WithUint:(UInt32)TextureId 
         WithWidth:(float)fWidth  WithWidth:(float)fHeight;

@end
//------------------------------------------------------------------------------------------------------
//главный контроллер приложения. отвечает за события интерфейса и обработку всех объектов
@interface MainController : UIViewController <UIAccelerometerDelegate,ADBannerViewDelegate> {
@public
	
    NSString *currentLanguage;

    NSSet *mpCurtouches;
    CMMotionManager *motionManager;

#ifdef BANNER_IAD
	BOOL bannerIsVisible;
	ADBannerView *adView;
#endif

    bool m_bTouchGathe;

	bool m_bMultiTouch;
    bool m_bPause;//пауза внутри игры
    bool m_bMegaPause;//большая пауза, при положении прилоежения неактивным в IOs
	SEL m_sPause;
	SEL m_sNormal;
	SEL m_SCurrentSel;
	
	//родидель для данного класса
	RootViewController* m_pRootViewController;
	
	CPrSettings* m_pPrSettings;
	CObjectManager* m_pObjMng;	
	
	//масштаб для контроллера
	float m_fScacleController;
			
	//главный экран
	GLView *glView;
	
	//все Id для звуков
	NSMutableDictionary* m_pSoundList;
	
	//все Id для текстур
	NSMutableDictionary* m_pTextureList;

    //все Id для атлосов
	NSMutableDictionary* m_pTextureAtlasList;

	int m_CountTouch;
	
	UIInterfaceOrientation previousOrientation;

    //факторы для коррекции масштаба Iphone/Ipad
    float fFactorInc;
    float fFactorDec;
    float fFactorIncInv;
    float fFactorDecInv;

	//смещение для отображения
	Vector3D m_vOffset;
    
    //вектора для акселерометра и гироскопа
    Vector3D m_vAccel;
    Vector3D m_vRYawPitchRoll;
    bool m_bMotionMashine;
}
@property (nonatomic, retain) GLView *glView;
@property (nonatomic, retain) RootViewController* m_pRootViewController;
@property (nonatomic, retain) CObjectManager* m_pObjMng;
@property (nonatomic, retain) CPrSettings* m_pPrSettings;
@property (nonatomic) float m_fScacleController;
@property (nonatomic) int m_CountTouch;

- (void)Pause:(bool)bPause;
- (void)MegaPause:(bool)bPause;

//desc: самообработка для контроллера. в этой функции контроллер перебирает все объкты находящиеся в m_pObjectList
//и вызывает функцию самообработки для каждого.
//par: DeltaTime время прошедшее между кадрами
- (void)SelfMove:(double)DeltaTime;

-(void)AddSubview:(UIView*) pView withLayer: (int) iLayerNum;
-(void)MoveSubview:(UIView*) pView withLayer: (int) iLayerNum;

-(void) Start;
-(UInt32) LoadSound:(NSString *)NameSound WithExt:(NSString *)Ext
           WithLoop:(bool)loop FullName:(NSString *)FullNameSound;

-(void)vibe:(id)sender;
-(void) Vibration: (float) fTime;

-(void) PlaySound: (NSString *)NameSound;
-(void) StopSound: (NSString *)NameSound;
-(void) SetPitchSound: (NSString *)NameSound Pithc:(float)Pitch;
-(void) SetVolumeSound: (NSString *)NameSound Volume:(float)Volume;

-(BOOL)isDeviceAniPad;
- (void)ConvPoint:(CGPoint *)pPoint;
-(void)LoadAllTextures;
-(void)LoadAllSounds;
-(void)LoadTextureAtlas:(AtlasContainer *)pAtlasContainer;
- (void)DeleteTexture:(NSString *)NameTexture;
- (void)DeleteSound:(NSString *)NameSound;

-(NSString *)GetNameWithLocale:(NSString *)NameTexture Ext:(NSString *)Ext;

-(void) createGLView;

- (void)setupView:(GLView*)view;


//функции загрузки текстур
-(UInt32)loadTexture:(NSString *)NameTexture WithExt:(NSString *)Extention  NameFile:(NSString *)NameFile;
-(UInt32)loadTexturePVR:(NSString *)NameTexture WithExt:(NSString *)Extention NameFile:(NSString *)NameFile;

-(void)SetProection;
-(void)SetOrt:(Vector3D)Offset;

-(UInt32)SetDim:(UInt32)Varialable;
- (bool)SmallDevice;

-(UInt32) GetTextureId:(NSString*)textureName;

@end
//------------------------------------------------------------------------------------------------------
