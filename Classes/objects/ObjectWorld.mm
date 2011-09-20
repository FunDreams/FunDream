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
	m_iLayer = layerTemplet;

START_QUEUE(@"Proc");
//	ASSIGN_STAGE(@"Idle",@"Idle:",nil);
	ASSIGN_STAGE(@"Proc",@"Proc:",nil);
    DELAY_STAGE(@"Proc",3000, 1);
END_QUEUE(@"Proc");
    
    GET_TEXTURE(mTextureId,m_pNameTexture);
    
//    [self SelfOffsetVert:Vector3DMake(0,1,0)];//cдвиг
 //   m_iLayerTouch=layerTouch_0;//слой касания
 //   [self SetTouch:YES];//интерактивность

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];    
    [self Spaun];
}
//------------------------------------------------------------------------------------------------------
- (void)Spaun{
    CREATE_NEW_OBJECT(@"ObjectPSimple", @"PushSimple", nil);
//    CREATE_NEW_OBJECT(@"ObjectPSimple", @"PushSimple", nil);
//    CREATE_NEW_OBJECT(@"ObjectPSimple", @"PushSimple", nil);
}
//------------------------------------------------------------------------------------------------------
- (void)Update{

}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{
    
    [self Spaun];
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end