//
//  mainController.m
//  Engine
//
//  Created by Konstantin on 01.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//частота обновления акселерометра
#define kAccelerometerFrequency 10

#import <sys/types.h>
#import <sys/sysctl.h>
//------------------------------------------------------------------------------------------------------
@implementation TextureContainer

- (id)InitWithName:(NSString *)pNamet WithUint:(UInt32)TextureId 
         WithWidth:(float)fWidth  WithWidth:(float)fHeight{
    
    m_fWidth=fWidth;
    m_fHeight=fHeight;
    
    m_iTextureId=TextureId;
    pName=[NSString stringWithString:pNamet];

    return self;
}

- (void)dealloc{
    [super dealloc];
}
@end
//------------------------------------------------------------------------------------------------------
@implementation MainController

@synthesize m_pRootViewController;
@synthesize m_fScacleController,m_pObjMng,m_pPrSettings,glView;
@synthesize m_CountTouch;
//------------------------------------------------------------------------------------------------------
#ifdef BANNER_IAD
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	adView.hidden=NO;

    if (!self->bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
		// assumes the banner view is offset 50 pixels so that it is not visible.
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        [UIView commitAnimations];
        self->bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	if (self->bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
		// assumes the banner view is at the top of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        [UIView commitAnimations];
        self->bannerIsVisible = NO;
    }
}
#endif
//------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
 	m_pPrSettings = nil;

	m_pSoundList = [[NSMutableDictionary alloc] init];
	m_pTextureList = [[NSMutableDictionary alloc] init];

    fFactorInc=1;
    fFactorDec=1;
    fFactorIncInv=1;
    fFactorDecInv=1;
	m_fScacleController=1;

	if([self isDeviceAniPad]){
        fFactorDec=(float)(2.0f-FACTOR_SCALE);
        fFactorInc=FACTOR_SCALE;

        self->m_fScacleController=2;
    }
    else{
        fFactorDecInv=(float)(2.0f-FACTOR_SCALE);
        fFactorIncInv=FACTOR_SCALE;
    }
	
	m_sPause=NSSelectorFromString(@"SelfMovePaused:");
	m_sNormal=NSSelectorFromString(@"SelfMoveNormal:");
	m_SCurrentSel=m_sNormal;
	
	NSString* Str_Orientation = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIInterfaceOrientation"];
	
	if([Str_Orientation isEqualToString:@"UIInterfaceOrientationLandscapeLeft"])
		previousOrientation=UIInterfaceOrientationLandscapeLeft;
	else if([Str_Orientation isEqualToString:@"UIInterfaceOrientationPortraitUpsideDown"])
		previousOrientation=UIInterfaceOrientationPortraitUpsideDown;
	else if([Str_Orientation isEqualToString:@"UIInterfaceOrientationLandscapeRight"])
		previousOrientation=UIInterfaceOrientationLandscapeRight;
	else previousOrientation=UIInterfaceOrientationPortrait;

    return self;
}
//------------------------------------------------------------------------------------------------------
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];

#ifdef FADE_NO
    [UIApplication sharedApplication].idleTimerDisabled = YES;
#endif

    motionManager = [[CMMotionManager alloc] init];
    [motionManager setGyroUpdateInterval:1.0 / kAccelerometerFrequency];
    
    if(motionManager.isDeviceMotionAvailable){
        [motionManager startDeviceMotionUpdates];
        m_bMotionMashine=YES;
    }
    
	m_pObjMng = [[CObjectManager alloc] Init:self];

	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];	

	if(previousOrientation==UIInterfaceOrientationLandscapeLeft || previousOrientation==UIInterfaceOrientationLandscapeRight)
	{
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(didRotate)
													 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
        
        if(previousOrientation==UIInterfaceOrientationLandscapeRight){
            m_pObjMng->fAngleRotateOffset=-90;
            m_pObjMng->fCurrentAngleRotateOffset=-90;
        }

        if(previousOrientation==UIInterfaceOrientationLandscapeLeft){
            m_pObjMng->fAngleRotateOffset=90;
            m_pObjMng->fCurrentAngleRotateOffset=90;
        }
	}

    //создаём 
    CGRect bounds = CGRectMake(0,0,
                               [[UIScreen mainScreen] bounds].size.width,
                               [[UIScreen mainScreen] bounds].size.height);
    
    glView = [[GLView alloc] initWithFrame:bounds];

    self.view.contentScaleFactor = [[UIScreen mainScreen] scale];
	[self.view addSubview:glView];
	
	glView.controller = self;
	[self setupView:glView];
    [self LoadAllTextures];
    [self LoadAllSounds];

#ifdef MULTITOUCH
    m_bMultiTouch=YES;
    glView.multipleTouchEnabled=m_bMultiTouch;
#endif

#ifdef BANNER_IAD
    
    adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    
    
    if(previousOrientation==UIInterfaceOrientationLandscapeLeft || previousOrientation==UIInterfaceOrientationLandscapeRight)
	{
        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
        
        if ([self isDeviceAniPad])
            adView.frame=CGRectMake(0, 768, 320, 50);
        else adView.frame=CGRectMake(0, 320, 320, 50);
        
        adView.delegate=self;
        adView.hidden=YES;
        
        [glView addSubview:adView];
    }
    else
    {
    
        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        
        if ([self isDeviceAniPad])
            adView.frame=CGRectMake(0, 1024, 320, 50);
        else adView.frame=CGRectMake(0, 480, 320, 50);
        
        adView.delegate=self;
        adView.hidden=YES;
        [self.view addSubview:adView];
    }
    
	bannerIsVisible=FALSE;
#endif
}
//------------------------------------------------------------------------------------------------------
-(UInt32) LoadSound:(NSString *)NameSound WithExt:(NSString *)Ext WithLoop:(bool)loop
FullName:(NSString *)FullNameSound
{
	NSBundle* bundle = [NSBundle mainBundle];

	UInt32 iSoundID = -1;
	
	if((iSoundID=[[m_pSoundList objectForKey:FullNameSound] intValue])!=0)return iSoundID;
	
	NSString * pBundle=(NSString *)[[bundle pathForResource:NameSound ofType:Ext] UTF8String];

	if(pBundle!=nil)
	{
		if(loop==YES)SoundEngine_LoadLoopingEffect((char * )pBundle, 0, 0, &iSoundID);
		else SoundEngine_LoadEffect((char * )pBundle, &iSoundID);
		
		[m_pSoundList setObject:[[NSNumber alloc] initWithInt:iSoundID] forKey:FullNameSound];
	}
	
	return iSoundID;
}
//------------------------------------------------------------------------------------------------------
-(void) PlaySound: (NSString *)NameSound{
    
    NSNumber *pNum = [m_pSoundList objectForKey:NameSound];
    
    if(pNum!=nil)SoundEngine_StartEffect([pNum intValue]);
}
//------------------------------------------------------------------------------------------------------
-(void) StopSound:  (NSString *)NameSound{
    
    NSNumber *pNum = [m_pSoundList objectForKey:NameSound];

    if(pNum!=nil)SoundEngine_StopEffect( [pNum intValue], FALSE);
}
//------------------------------------------------------------------------------------------------------
- (void)didRotate{
	
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
		
	if(previousOrientation==UIInterfaceOrientationLandscapeLeft && orientation==UIInterfaceOrientationLandscapeRight){
		
        m_pObjMng->fAngleRotateOffset=-90;
		previousOrientation=UIInterfaceOrientationLandscapeRight;
	}
	
	if(previousOrientation==UIInterfaceOrientationLandscapeRight && orientation==UIInterfaceOrientationLandscapeLeft){
		
        m_pObjMng->fAngleRotateOffset=90;
		previousOrientation=UIInterfaceOrientationLandscapeLeft;
	}
}
//------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}
//------------------------------------------------------------------------------------------------------
- (void)viewDidUnload {}
//------------------------------------------------------------------------------------------------------
- (void)SelfMove:(double)DeltaTime{

    NSNumber *NumDelta = [NSNumber numberWithDouble:DeltaTime];
 	[m_pObjMng performSelector:m_SCurrentSel withObject:NumDelta];
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {
	
	[m_pObjMng release];
    [motionManager release];
	
	NSEnumerator *enumerator = [m_pSoundList objectEnumerator];
	NSNumber *TmpOb;
	
	while ((TmpOb = [enumerator nextObject])){SoundEngine_UnloadEffect([TmpOb intValue]);}
	
	[m_pSoundList release];

	glDeleteTextures(MAX_NUM_TEXTURE,texture);
	
    enumerator = [m_pTextureList objectEnumerator];
	TextureContainer *TmpContainer;
    while ((TmpContainer = [enumerator nextObject])){[TmpContainer release];}

	[m_pTextureList release];

#ifdef BANNER_IAD
	[adView release];
#endif
	
	[super dealloc];
}
//------------------------------------------------------------------------------------------------------
-(void)Start
{
	[m_pObjMng CreateObjects];	

#ifdef BLACK_PIG
	{
		SoundEngine_StopBackgroundMusic(FALSE);
		SoundEngine_UnloadBackgroundMusicTrack();

		NSBundle* bundle = [NSBundle mainBundle];
		SoundEngine_LoadBackgroundMusicTrack([[bundle pathForResource:@"chef" ofType:@"mp3"] UTF8String], true, true);
		SoundEngine_StartBackgroundMusic();
	}
#endif
}
//------------------------------------------------------------------------------------------------------
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
}
//------------------------------------------------------------------------------------------------------
-(void)AddSubview:(UIView*) pView withLayer: (int) iLayerNum
{
	pView.tag = iLayerNum;
	NSArray* pSubViews = self.view.subviews;
	for( int i = 0; i < [pSubViews count]; i++ )
	{
		UIView* pLayerView = [pSubViews objectAtIndex:i];
		if( pLayerView.tag > iLayerNum )
		{
			[self.view insertSubview:pView belowSubview:pLayerView];
			return;
		}
	}
	[self.view addSubview:pView];
}
//------------------------------------------------------------------------------------------------------
-(void)MoveSubview:(UIView*) pView withLayer: (int) iLayerNum
{
	[pView removeFromSuperview];
	[self AddSubview:pView withLayer: iLayerNum];
}
//------------------------------------------------------------------------------------------------------
//- (void)update:(ccTime)delta{
//}
//------------------------------------------------------------------------------------------------------
// UIAccelerometerDelegate method, called when the device accelerates.
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	//NSLog(@"x: %f, y: %f", acceleration.x, acceleration.y);
    
    if (previousOrientation==UIInterfaceOrientationLandscapeRight) {
        
        m_vAccel.x=-acceleration.y;
        m_vAccel.y=acceleration.x;

    }
    else if (previousOrientation==UIInterfaceOrientationLandscapeLeft){

        m_vAccel.x=acceleration.y;
        m_vAccel.y=-acceleration.x;
    }
    else {
        
        m_vAccel.x=acceleration.x;
        m_vAccel.y=acceleration.y;
    }
    
    m_vAccel.z=acceleration.z;
    
    if(m_bMotionMashine){
    
        CMDeviceMotion *deviceMotion = motionManager.deviceMotion;      
        CMAttitude *attitude = deviceMotion.attitude;
        
        m_vRYawPitchRoll.x=attitude.roll;
        m_vRYawPitchRoll.y=attitude.yaw;
        m_vRYawPitchRoll.z=attitude.pitch;
        
 //       NSLog(@"Roll:%.2f pitch:%.2f yaw:%.2f",
 //             m_vRYawPitchRoll.x, m_vRYawPitchRoll.y,m_vRYawPitchRoll.z);
    }
}
//------------------------------------------------------------------------------------------------------
- (void)ConvPoint:(CGPoint *)pPoint{
	
	CGPoint InterPoint=*pPoint;
	
	CGPoint tmpPointDif;
	CGRect rect = self.view.bounds; 
	
	if (previousOrientation==UIInterfaceOrientationLandscapeLeft) {
		
		tmpPointDif.x=(0.5f*VIEWPORT_H-InterPoint.y*VIEWPORT_H/rect.size.height);
		tmpPointDif.y=0.5*VIEWPORT_W-(InterPoint.x*VIEWPORT_W/rect.size.width);
	}
	else if (previousOrientation==UIInterfaceOrientationLandscapeRight) {
		
		tmpPointDif.x=-(0.5f*VIEWPORT_H-InterPoint.y*VIEWPORT_H/rect.size.height);
		tmpPointDif.y=-(0.5*VIEWPORT_W-(InterPoint.x*VIEWPORT_W/rect.size.width));
	}
	else{
		
		tmpPointDif.x=(InterPoint.x*VIEWPORT_W/rect.size.width-0.5f*VIEWPORT_W);
		tmpPointDif.y=0.5*VIEWPORT_H-(InterPoint.y*VIEWPORT_H/rect.size.height);
	}
	
	*pPoint = tmpPointDif;
}
//------------------------------------------------------------------------------------------------------
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    mpCurtouches = [event allTouches];
    m_CountTouch=[mpCurtouches count];

    for (NSMutableDictionary *pDic in m_pObjMng->m_pObjectTouches) {
        
        NSEnumerator *enumerator = [pDic objectEnumerator];
        GObject *TmpOb;
        
        while ((TmpOb = [enumerator nextObject])) {

            if ((m_pObjMng->m_bGlobalPause==YES && !TmpOb->m_bNonStop)||TmpOb->m_bDeleted==YES)
                continue;
            
            for (UITouch *touch in touches) {
                CGPoint tmpPoint = [touch locationInView:self.view];
                [self ConvPoint:&tmpPoint];

                if(TmpOb->m_bTouch && [TmpOb Intersect:tmpPoint])
                    {[TmpOb touchesBegan:touch WithPoint:tmpPoint];}
                else {[TmpOb touchesBeganOut:touch WithPoint:tmpPoint];}
                
            }
            
            if(m_bTouchGathe){m_bTouchGathe=NO;return;}
        }
    }
    
    mpCurtouches=nil;
    m_CountTouch=0;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    mpCurtouches = [event allTouches];
    m_CountTouch=[mpCurtouches count];

    for (NSMutableDictionary *pDic in m_pObjMng->m_pObjectTouches) {
        
        NSEnumerator *enumerator = [pDic objectEnumerator];
        GObject *TmpOb;
        
        while ((TmpOb = [enumerator nextObject])) {
            
            if ((m_pObjMng->m_bGlobalPause==YES && !TmpOb->m_bNonStop)||TmpOb->m_bDeleted==YES)
                continue;

            for (UITouch *touch in touches) {
                CGPoint tmpPoint = [touch locationInView:self.view];
                [self ConvPoint:&tmpPoint];
                                                
                if(TmpOb->m_bTouch && [TmpOb Intersect:tmpPoint])
                {[TmpOb touchesMoved:touch WithPoint:tmpPoint];}
                else {[TmpOb touchesMovedOut:touch WithPoint:tmpPoint];}
                
            }

            if(m_bTouchGathe){m_bTouchGathe=NO;return;}
        }
    }
    
    mpCurtouches=nil;
    m_CountTouch=0;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    mpCurtouches = [event allTouches];
    m_CountTouch=[mpCurtouches count];

    for (NSMutableDictionary *pDic in m_pObjMng->m_pObjectTouches) {
        
        NSEnumerator *enumerator = [pDic objectEnumerator];
        GObject *TmpOb;

        while ((TmpOb = [enumerator nextObject])) {
            
            if ((m_pObjMng->m_bGlobalPause==YES && !TmpOb->m_bNonStop)||TmpOb->m_bDeleted==YES)
                continue;

            for (UITouch *touch in touches) {
                CGPoint tmpPoint = [touch locationInView:self.view];
                [self ConvPoint:&tmpPoint];
                                
                if(TmpOb->m_bTouch && [TmpOb Intersect:tmpPoint])
                {[TmpOb touchesEnded:touch WithPoint:tmpPoint];}
                else {[TmpOb touchesEndedOut:touch WithPoint:tmpPoint];}
                
            }
            
            if(m_bTouchGathe){m_bTouchGathe=NO;return;}
        }
    }
    
    mpCurtouches=nil;
    m_CountTouch=0;
}
//------------------------------------------------------------------------------------------------------
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesEnded:touches withEvent:event];
}
//------------------------------------------------------------------------------------------------------
- (IBAction)StartBt
{	

#if TARGET_IPHONE_SIMULATOR
	
	[self Start];
#else	

//	if (([[MKStoreManager sharedManager] GetBool]==NO))
//	{
//		if([MKStoreManager featureAPurchased])
//		{			
			[self Start];
//		}
//		else
//		{
//			[[MKStoreManager sharedManager] buyFeatureA];
//		}
//	}
#endif
}
//------------------------------------------------------------------------------------------------------
- (void)Pause:(bool)bPause
{
    m_bPause=bPause;
	m_pObjMng->m_bGlobalPause = bPause;
	
	if(bPause)m_SCurrentSel=m_sPause;
	else m_SCurrentSel=m_sNormal;
}
//------------------------------------------------------------------------------------------------------
-(void)vibe:(id)sender
{
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
//------------------------------------------------------------------------------------------------------
-(void) Vibration: (float) fTime
{
	int iQty = fTime/0.3f;	

	for (int i = 1; i < iQty; i++)
	{
		[self performSelector:@selector(vibe:) withObject:self afterDelay:i *.3f];
	}
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
-(UInt32)SetDim:(UInt32)Varialable{
	
	UInt32 uiRet=Varialable;

	if(uiRet<2)return 2;
		
	for (int i=2; i<2048; i*=2) {
		
		if(Varialable>i && Varialable<(i*2)){
			
			int Delta1=Varialable-i;
			int Delta2=2*i-Varialable;
			
			if(Delta1>Delta2)uiRet=2*i;
			else if(Delta1<Delta2)uiRet=i;
			else uiRet=2*i;
			break;
		}
	}
		
	if([self SmallDevice]==YES)
	{
		uiRet*=0.5f;
	}
	
	return uiRet;
}
//------------------------------------------------------------------------------------------------------
- (bool)SmallDevice{

	size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *platform = [NSString stringWithCString:(const char *)machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"])    return YES;//@"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return YES;//@"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return YES;//@"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return NO;//@"iPhone 4";
    if ([platform isEqualToString:@"iPod1,1"])      return YES;//@"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return YES;//@"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return YES;//@"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return YES;//@"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])      return NO;//@"iPad";
    if ([platform isEqualToString:@"i386"])         return NO;//@"Simulator";
    return NO;
}
//------------------------------------------------------------------------------------------------------
-(UInt32)loadTexture:(NSString *)NameTexture WithExt:(NSString *)Extention 
            NameFile:(NSString *)NameFile
{
	UInt32	m_iTextureId=-1;
    TextureContainer * TmpContainer;

	if((TmpContainer=(TextureContainer *)[m_pTextureList objectForKey:NameFile])!=nil){
        
        return TmpContainer->m_iTextureId;
    }
	   
	NSString *path = [[NSBundle mainBundle] pathForResource:NameTexture ofType:Extention];
		
	if(path!=nil)
	{
//		NSLog(NameTexture);
		glBindTexture(GL_TEXTURE_2D, texture[m_iCount]);

		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
		
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
		
		NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
		UIImage *image = [[UIImage alloc] initWithData:texData];
		
		if (image == nil)
			NSLog(@"Do real error checking here");
		
		GLuint width = CGImageGetWidth(image.CGImage);
		GLuint height = CGImageGetHeight(image.CGImage);

        int sourceW=width;
        int sourceH=height;

		width=[self SetDim:width];
		height=[self SetDim:height];

		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		void *imageData = malloc( height * width * 4 );
		CGContextRef context = CGBitmapContextCreate( imageData, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );

		// Flip the Y-axis
		CGContextTranslateCTM (context, 0, height);
		CGContextScaleCTM (context, 1.0, -1.0);

		CGColorSpaceRelease( colorSpace );
		CGContextClearRect( context, CGRectMake( 0, 0, width, height ) );
		CGContextDrawImage( context, CGRectMake( 0, 0, width, height ), image.CGImage );

		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);

		m_iTextureId=texture[m_iCount];
		
        TmpContainer=[[TextureContainer alloc] InitWithName:NameTexture WithUint:m_iTextureId WithWidth:sourceW WithWidth:sourceH];
        
		[m_pTextureList setObject:TmpContainer forKey:NameFile];

		m_iCount++;

		CGContextRelease(context);

		free(imageData);
		[image release];
		[texData release];
	}
	
	return m_iTextureId;
}
//------------------------------------------------------------------------------------------------------
-(void)SetProection{
	const GLfloat zNear = 0.01, zFar = 100.0, fieldOfView = 45.0; 
	GLfloat size; 

	size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0); 
	CGRect rect = self.view.bounds; 
		glFrustumf(-size, size, -size / (rect.size.width / rect.size.height), size /
				   (rect.size.width / rect.size.height), zNear, zFar); 
}
//------------------------------------------------------------------------------------------------------
-(void)SetOrt:(Vector3D)Offset{
	m_vOffset=Offset;
        
    glOrthof (- VIEWPORT_W*0.5f+Offset.x, VIEWPORT_W*0.5f+Offset.x, - VIEWPORT_H*0.5f+Offset.y, VIEWPORT_H*0.5f+Offset.y,  0.0f, 20.0f);
}
//------------------------------------------------------------------------------------------------------
-(void)LoadAllSounds{
    
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    bundleRoot=[bundleRoot stringByAppendingString:@"/sounds"];
    
    NSError *Error=[[NSError alloc] init];
    NSArray *dirContents = [[NSFileManager defaultManager] 
                            contentsOfDirectoryAtPath:bundleRoot error:&Error];
    
    for (NSString *tString in dirContents) {
        
        int TmpId=-1;

        NSRange toprange = [tString rangeOfString: @"."];
        NSString *SubStr = [tString substringToIndex:toprange.location];
        NSString *SubStr1 = [tString substringFromIndex:toprange.location+1];
        
        NSString *REZ=[NSString stringWithString:@"sounds/"];
        REZ=[REZ stringByAppendingString:SubStr];

        TmpId = [self LoadSound:REZ WithExt:SubStr1 WithLoop:NO FullName:tString];        
    }
    
    bundleRoot = [[NSBundle mainBundle] bundlePath];
    bundleRoot=[bundleRoot stringByAppendingString:@"/sounds_loop"];
    
    dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:bundleRoot error:&Error];
    
    for (NSString *tString in dirContents) {
        
        int TmpId=-1;
        
        NSRange toprange = [tString rangeOfString: @"."];
        NSString *SubStr = [tString substringToIndex:toprange.location];
        NSString *SubStr1 = [tString substringFromIndex:toprange.location+1];
        
        NSString *REZ=[NSString stringWithString:@"sounds_loop/"];
        REZ=[REZ stringByAppendingString:SubStr];

        TmpId = [self LoadSound:REZ WithExt:SubStr1 WithLoop:YES FullName:tString]; 
    }
    
    [Error release];
}
//------------------------------------------------------------------------------------------------------
-(void)LoadAllTextures{
    
    //load all textures
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    bundleRoot=[bundleRoot stringByAppendingString:@"/texture"];
    
    NSError *Error=[[NSError alloc] init];
    NSArray *dirContents = [[NSFileManager defaultManager] 
        contentsOfDirectoryAtPath:bundleRoot error:&Error];
    
    for (NSString *tString in dirContents) {
        
        int TmpId=-1;
        
        NSRange toprange = [tString rangeOfString: @"."];
        NSString *SubStr = [tString substringToIndex:toprange.location];
        NSString *SubStr1 = [tString substringFromIndex:toprange.location+1];
        
        NSString *REZ=[NSString stringWithString:@"texture/"];
        REZ=[REZ stringByAppendingString:SubStr];
        
        TmpId = [self loadTexture:REZ WithExt:SubStr1 NameFile:tString];
    }
    
    [Error release];
}
//------------------------------------------------------------------------------------------------------
-(void)setupView:(GLView*)view
{
	glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
	
	glDisable(GL_DEPTH_TEST);
	glMatrixMode(GL_PROJECTION);

	Vector3D CurretnOffset=Vector3DMake(0,0,0);
	[self SetOrt:CurretnOffset];

	CGRect rect = view.bounds; 

    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = [mainScreen scale];

	glViewport(0, 0, rect.size.width*scale, rect.size.height*scale);
	glMatrixMode(GL_MODELVIEW);
    
    // Turn necessary features on
    glEnable(GL_TEXTURE_2D);
    glEnable(GL_BLEND);
	
	//glBlendFunc(GL_ONE,GL_ONE_MINUS_SRC_ALPHA);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    // Bind the number of textures we need, in this case one.
	glGenTextures(MAX_NUM_TEXTURE, &texture[0]);
}
//------------------------------------------------------------------------------------------------------
@end
