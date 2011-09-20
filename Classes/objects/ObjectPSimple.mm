//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectPSimple.h"

@implementation ObjectPSimple
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
	m_iLayer = layerOb2;

 //   GET_DIM_FROM_TEXTURE(@"");
	mWidth  = 100;
	mHeight = 100;
    mRadius = 90;

START_QUEUE(@"Proc");

    ASSIGN_STAGE(@"Show",@"AchiveLineFloat:",
                 LINK_FLOAT_V(mColor.alpha,@"Instance"),
                 SET_FLOAT_V(1,@"finish_Instance"),
                 SET_FLOAT_V(1,@"Vel"));

    ASSIGN_STAGE(@"PrepareMove", @"PrepareMove:", nil);
    ASSIGN_STAGE(@"Move",@"AchiveLineFloat:",
                 LINK_FLOAT_V(m_pCurPosition.y,@"Instance"),
                 SET_FLOAT_V(m_pCurPosition.y-450,@"finish_Instance"),
                 SET_FLOAT_V(-200,@"Vel"));

    ASSIGN_STAGE(@"PrapareHide",@"PrapareHide:",nil);
    ASSIGN_STAGE(@"hide",@"AchiveLineFloat:",
                 LINK_FLOAT_V(mColor.alpha,@"Instance"),
                 SET_FLOAT_V(0,@"finish_Instance"),
                 SET_FLOAT_V(-1,@"Vel"));

	ASSIGN_STAGE(@"Destroy",@"DestroySelf:",nil);
END_QUEUE(@"Proc");
    
    GET_TEXTURE(mTextureId,@"Bullet_Up.png");

//    [self SelfOffsetVert:Vector3DMake(0,1,0)];//cдвиг
 //   m_iLayerTouch=layerTouch_0;//слой касания

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];
    
    m_pCurPosition.x=((float)(RND%640)-320)*0.8f;
    m_pCurPosition.y=220;
    
 //   m_pCurAngle.z=RND%360;

    mColor = Color3DMake(1.0f,1.0f,1.0f,1.0f);
    mColor.alpha=0.0f;
    //[self SetTouch:YES];//интерактивность
    
    SET_STAGE_EX(NAME(self), @"Proc", @"Show");
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
//------------------------------------------------------------------------------------------------------
- (void)PrepareMove:(Processor_ex *)pProc{
    
    [m_pObjMng AddToGroup:@"BallUp" Object:self];
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)PrapareHide:(Processor_ex *)pProc{
    [m_pObjMng RemoveFromGroup:@"BallUp" Object:self];
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)AchiveLineFloat:(Processor_ex *)pProc{

//    m_pCurAngle.z+=DELTA*10;
    [super AchiveLineFloat:pProc];
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    UPDATE;
    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    DESTROY_OBJECT(self);
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    DESTROY_OBJECT(self);
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end