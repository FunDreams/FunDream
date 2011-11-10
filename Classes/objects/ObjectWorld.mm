//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectWorld.h"

@implementation ObjectWorld
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
    m_bHiden=YES;
	m_iLayer = layerSystem;

START_QUEUE(@"Proc");
	ASSIGN_STAGE(@"Idle",@"Idle:",nil);
	ASSIGN_STAGE(@"Proc",@"Proc:",nil);
    DELAY_STAGE(@"Proc",1000, 1);
END_QUEUE(@"Proc");
        
//    [self SelfOffsetVert:Vector3DMake(0,1,0)];//cдвиг
 //   m_iLayerTouch=layerTouch_0;//слой касания
 //   [self SetTouch:YES];//интерактивность

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

    m_pObSpaun=CREATE_NEW_OBJECT(@"ObjectGameSpaun",@"Spaun",nil);
    
    CREATE_NEW_OBJECT(@"ObjectParticle",@"ParticlesDown",
                      SET_VECTOR_V(Vector3DMake(128,128,0),@"m_vSize"),
                      SET_INT_V(1, @"m_iCountX"),
                      SET_INT_V(1, @"m_iCountY"),
                      SET_INT_V(1, @"m_INumLoadTextures"),
                      SET_STRING_V(@"Down_Bullet.png",@"m_pNameTexture"));

    CREATE_NEW_OBJECT(@"ObjectParticle",@"ParticlesUp",
                      SET_VECTOR_V(Vector3DMake(128,128,0),@"m_vSize"),
                      SET_INT_V(1, @"m_iCountX"),
                      SET_INT_V(1, @"m_iCountY"),
                      SET_INT_V(1, @"m_INumLoadTextures"),
                      SET_STRING_V(@"Up_Bullet.png",@"m_pNameTexture"));

	[super Start];
}
//------------------------------------------------------------------------------------------------------
- (void)Update{

}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{
    
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    
    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end