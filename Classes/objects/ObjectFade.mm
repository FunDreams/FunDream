//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectFade.h"

@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
    LOAD_SOUND(iIdSound,@"click2.wav",NO);

	m_iLayer = layerInvisible;

	mWidth  = 50;
	mHeight = 50;
    
    m_iStartStage=0;
    
START_PROC(@"Proc");
	
	UP_POINT(@"p00_f_Instance",&mColor.alpha);
    //	UP_CONST_FLOAT(@"s00_f_Instance",0);
	UP_CONST_FLOAT(@"f00_f_Instance",0.5f);
	UP_CONST_FLOAT(@"s00_f_vel",1.8);
	UP_SELECTOR(@"e00",@"AchiveLineFloat:");
	
	UP_SELECTOR(@"e01",@"Idle:");
    
	UP_POINT(@"p02_f_Instance",&mColor.alpha);
    //	UP_CONST_FLOAT(@"s02_f_Instance",0.5f);
	UP_CONST_FLOAT(@"f02_f_Instance",0);
	UP_CONST_FLOAT(@"s02_f_vel",-1.8);
	UP_SELECTOR(@"e02",@"AchiveLineFloat:");
	
    UP_SELECTOR(@"e03",@"DestroySelf:");

    //fade 2
    UP_POINT(@"p05_f_Instance",&mColor.alpha);
	UP_CONST_FLOAT(@"f5_f_Instance",1.0f);
	UP_CONST_FLOAT(@"s5_f_vel",2);
	UP_SELECTOR(@"e5",@"AchiveLineFloat:");

    UP_SELECTOR(@"e06",@"TouchYes:");
	UP_SELECTOR(@"e07",@"Idle:");
    
	UP_POINT(@"p8_f_Instance",&mColor.alpha);
	UP_CONST_FLOAT(@"f8_f_Instance",0);
	UP_CONST_FLOAT(@"s8_f_vel",-1.2f);
	UP_SELECTOR(@"e8",@"AchiveLineFloat:");
	
    UP_SELECTOR(@"e9",@"DestroySelf:");
    
END_PROC(@"Proc");

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)GetParams:(CParams *)Parametrs{[super GetParams:Parametrs];}
//------------------------------------------------------------------------------------------------------
- (void)SetParams:(CParams *)Parametrs{
    [super SetParams:Parametrs];
    
    COPY_IN_INT(m_iStartStage);
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];
    SET_STAGE(NAME(self), m_iStartStage);
}
//------------------------------------------------------------------------------------------------------
- (void)HideFade{
    SET_STAGE(NAME(self), 8);
    [self SetTouch:NO];
}
//------------------------------------------------------------------------------------------------------
- (void)Move{}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
#ifdef SUDOKU
    LOCK_TOUCH;
#endif
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
#ifdef SUDOKU
    LOCK_TOUCH;
    OBJECT_PERFORM_SEL(@"Field", @"StartNewField")
    PLAY_SOUND(iIdSound);
#endif
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEndedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
#ifdef SUDOKU
    LOCK_TOUCH;
    OBJECT_PERFORM_SEL(@"Field", @"StartNewField")
    PLAY_SOUND(iIdSound);
#endif
}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor *)pProc{}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT