//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectBullet.h"

@implementation ObjectBullet
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
	m_iLayer = layerOb2;

    GET_TEXTURE(mTextureId,@"button.png");

    mWidth  = 150;
	mHeight = 150;

START_QUEUE(@"Proc");
	ASSIGN_STAGE(@"Idle",@"Idle:",nil);
//	ASSIGN_STAGE(@"Proc",@"Proc:",nil);
        
    ASSIGN_STAGE(@"Move",@"AchiveLineFloat:",
                 LINK_FLOAT_V(m_pCurPosition.y,@"Instance"),
                 SET_FLOAT_V(220,@"finish_Instance"),
                 SET_FLOAT_V(400,@"Vel"));
    
    ASSIGN_STAGE(@"hide",@"AchiveLineFloat:",
                 LINK_FLOAT_V(mColor.alpha,@"Instance"),
                 SET_FLOAT_V(0,@"finish_Instance"),
                 SET_FLOAT_V(-1,@"Vel"));
    
	ASSIGN_STAGE(@"Destroy",@"DestroySelf:",nil);

END_QUEUE(@"Proc");
    
    GET_TEXTURE(mTextureId,m_pNameTexture);
    
//    [self SelfOffsetVert:Vector3DMake(0,1,0)];//cдвиг
 //   m_iLayerTouch=layerTouch_0;//слой касания

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];
    //   [self SetTouch:YES];//интерактивность
    
    mColor.alpha=1;
    [m_pObjMng AddToGroup:@"Bullets" Object:self];
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{
    
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end