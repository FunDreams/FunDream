//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "PhoneShake.h"

@implementation PhoneShake
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
	m_iLayer = layerTemplet;

	mWidth  = 50;
	mHeight = 50;

START_PROC(@"Proc");
    
    UP_POINT(@"p00_f_Instance",&mColor.alpha);
    //	UP_CONST_FLOAT(@"s00_f_Instance",0);
	UP_CONST_FLOAT(@"f00_f_Instance",1.0f);
	UP_CONST_FLOAT(@"s00_f_vel",1.8);
	UP_SELECTOR(@"e00",@"AchiveLineFloat:");
	
	UP_SELECTOR(@"e01",@"Proc:");
    UP_TIMER(2,1,8000, @"Action:");
    
	UP_POINT(@"p3_f_Instance",&mColor.alpha);
    //	UP_CONST_FLOAT(@"s3_f_Instance",0.5f);
	UP_CONST_FLOAT(@"f3_f_Instance",0);
	UP_CONST_FLOAT(@"s3_f_vel",-1.8);
	UP_SELECTOR(@"e3",@"AchiveLineFloat:");
	
    UP_SELECTOR(@"e4",@"DestroySelf:");

END_PROC(@"Proc");
    
//    LOAD_SOUND(iIdSound,@"knopka.wav",NO);
    LOAD_TEXTURE(mTextureId,m_pNameTexture);
    
    [self SelfOffsetVert:Vector3DMake(0,3,0)];

 //   m_iLayerTouch=layerTouch_0;
 //   [self SetTouch:YES];

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)GetParams:(CParams *)Parametrs{[super GetParams:Parametrs];}
//------------------------------------------------------------------------------------------------------
- (void)SetParams:(CParams *)Parametrs{[super SetParams:Parametrs];}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];
    mColor.alpha=0;
    m_fPhase=0;
    m_pCurAngle.z=-10;
}
//------------------------------------------------------------------------------------------------------
- (void)Move{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor *)pProc{
    
    m_fPhase+=DELTA*8;
    m_pCurAngle.z=20*0.5f*(-cos(m_fPhase)+1)-10;
    
    if(m_fPhase>3.14159*2){
        m_fPhase=0;
        m_pCurAngle.z=-10;
        NEXT_STAGE;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Action:(Processor *)pProc{
    SET_STAGE(NAME(self), 1);
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end