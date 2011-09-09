//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectAnimateStatic.h"

@implementation ObjectAnimateStatic
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
	m_iLayer = layerOb3;
    m_fVelFrame=25;

//    [self SelfOffsetVert:Vector3DMake(0,1,0)];//cдвиг
 //   m_iLayerTouch=layerTouch_0;//слой касания

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    
    SET_CELL(LINK_INT_V(m_iOffsetFrame,m_strName,@"m_iOffsetFrame"));
    SET_CELL(LINK_INT_V(m_fVelFrame,m_strName,@"m_fVelFrame"));
    SET_CELL(LINK_BOOL_V(m_bDimFromTexture,m_strName,@"m_bDimFromTexture"));
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

    mTextureId=-1;
    GET_TEXTURE(mTextureId,m_pNameTexture);
    
    if(m_bDimFromTexture){GET_DIM_FROM_TEXTURE(m_pNameTexture);}
    
START_QUEUE(@"Proc");
    
    ASSIGN_STAGE(@"Animate",@"AnimateLoop:",
                 SET_INT_V(mTextureId,@"Start_Frame"),
                 SET_INT_V(mTextureId+m_iOffsetFrame,@"Finish_Frame"),
                 LINK_INT_V(mTextureId,@"InstFrame"),
                 SET_FLOAT_V(mTextureId,@"InstFrameFloat"),
                 SET_FLOAT_V(m_fVelFrame,@"Vel"));
    
    ASSIGN_STAGE(@"Animate2",@"Animate:",
                 SET_INT_V(mTextureId+m_iOffsetFrame,@"Finish_Frame"),
                 LINK_INT_V(mTextureId,@"InstFrame"),
                 SET_FLOAT_V(mTextureId,@"InstFrameFloat"),
                 SET_FLOAT_V(m_fVelFrame,@"Vel"));

    ASSIGN_STAGE(@"Destroy",@"DestroySelf:",nil);
    
END_QUEUE(@"Proc");

	[super Start];
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
- (void)Destroy{
    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end