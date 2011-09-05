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

    GET_TEXTURE(mTextureId,@"2-09@2x.png");

    mWidth  = 150;
	mHeight = 150;

START_QUEUE(@"Proc");
	ASSIGN_STAGE(@"Idle",@"Idle:",nil);
//	ASSIGN_STAGE(@"Proc",@"Proc:",nil);
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
    
    [m_pObjMng AddToGroup:@"Bullets" Object:self];
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end