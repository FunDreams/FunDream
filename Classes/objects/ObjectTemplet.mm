//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectTemplet.h"

@implementation ObjectTemplet
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
	m_iLayer = layerTemplet;

    GET_TEXTURE(mTextureId,m_pNameTexture);
 //   GET_DIM_FROM_TEXTURE(@"");
	mWidth  = 50;
	mHeight = 50;

START_QUEUE(@"Proc");
	ASSIGN_STAGE(@"Idle",@"Idle:",nil);
//	ASSIGN_STAGE(@"Proc",@"Proc:",nil);
END_QUEUE(@"Proc");
    
    
//    [self SelfOffsetVert:Vector3DMake(0,1,0)];//cдвиг
 //   m_iLayerTouch=layerTouch_0;//слой касания

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{[super LinkValues];}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];
    //   [self SetTouch:YES];//интерактивность
    //[m_pObjMng AddToGroup:@"NameGroup" Object:self];//группировка
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
//------------------------------------------------------------------------------------------------------
- (void)InitProc:(ProcStage_ex *)pProc{}
//------------------------------------------------------------------------------------------------------
- (void)PrepareProc:(ProcStage_ex *)pProc{}
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