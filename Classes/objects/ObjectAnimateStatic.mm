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
    
    m_vStartTex = Vector3DMake(0.0f, 0.0f, 0.0f);
    m_vEndTex   = Vector3DMake(1.0f, 1.0f, 0.0f);
    
    m_fVelOffset=0.3f;
    
    m_vStartOffsetTex = Vector3DMake(0.0f, 0.0f, 0.0f);
    m_vEndOffsetTex   = Vector3DMake(1.0f, 0.0f, 0.0f);

START_QUEUE(@"Animate");
    
    ASSIGN_STAGE(@"AnimateLoop",@"AnimateLoop:",
                 LINK_INT_V(m_iStartFrame,@"Start_Frame"),
                 LINK_INT_V(m_iFinishFrame,@"Finish_Frame"),
                 LINK_INT_V(mTextureId,@"InstFrame"),
                 LINK_FLOAT_V(InstFrameFloat,@"InstFrameFloat"),
                 LINK_FLOAT_V(m_fVelFrame,@"Vel"));
    
    
    ASSIGN_STAGE(@"AnimateStage",@"Animate:",
                 LINK_INT_V(m_iStartFrame,@"Start_Frame"),
                 LINK_INT_V(m_iFinishFrame,@"Finish_Frame"),
                 LINK_INT_V(mTextureId,@"InstFrame"),
                 LINK_FLOAT_V(InstFrameFloat,@"InstFrameFloat"),
                 LINK_FLOAT_V(m_fVelFrame,@"Vel"));
    ASSIGN_STAGE(@"Destroy",@"DestroySelf:",nil);
    

    ASSIGN_STAGE(@"OffsetTex",@"OffsetTexLoop:",
                 LINK_FLOAT_V(m_fVelOffset,@"fVelOffset"),
                 LINK_FLOAT_V(m_fMagnitude,@"fMagnitude"),
                 LINK_VECTOR_V(m_vStartOffsetTex,@"vStartOffsetTex"),
                 LINK_VECTOR_V(m_vEndOffsetTex,@"vEndOffsetTex"),
                 LINK_VECTOR_V(m_vDirect,@"vDirect"),
                 LINK_VECTOR_V(m_vCurrentOffset,@"vCurrentOffset"));
    
END_QUEUE(@"Animate");

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    
    SET_CELL(LINK_INT_V(m_iOffsetFrame,m_strName,@"m_iOffsetFrame"));
    SET_CELL(LINK_INT_V(m_fVelFrame,m_strName,@"m_fVelFrame"));
    SET_CELL(LINK_BOOL_V(m_bDimFromTexture,m_strName,@"m_bDimFromTexture"));

    SET_CELL(LINK_VECTOR_V(m_vStartOffsetTex,m_strName,@"m_vStartOffsetTex"));
    SET_CELL(LINK_VECTOR_V(m_vEndOffsetTex,m_strName,@"m_vEndOffsetTex"));
    
    SET_CELL(LINK_VECTOR_V(m_vStartTex,m_strName,@"m_vStartTex"));
    SET_CELL(LINK_VECTOR_V(m_vEndTex,m_strName,@"m_vEndTex"));
    
    SET_CELL(LINK_FLOAT_V(m_fVelOffset,m_strName,@"m_fVelOffset"));

    SET_CELL(LINK_FLOAT_V(m_fStartDelay,m_strName,@"m_fStartDelay"));
    
    m_strStartStage=[NSMutableString stringWithString:@"Animate"];
    SET_CELL(LINK_STRING_V(m_strStartStage,m_strName,@"m_strStartStage"));
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

    mTextureId=-1;
    GET_TEXTURE(mTextureId,m_pNameTexture);
    
    if(m_bDimFromTexture){GET_DIM_FROM_TEXTURE(m_pNameTexture);}
    
	[super Start];
    
    InstFrameFloat=mTextureId;
    m_iStartFrame=mTextureId;
    m_iFinishFrame=mTextureId+m_iOffsetFrame;
        
    
    if(m_fStartDelay>0){

START_QUEUE(@"Animate");
        DELAY_STAGE(m_strStartStage, m_fStartDelay, 1);
END_QUEUE(@"Animate");
        
        m_bHiden=YES;
    }
    else {
     
START_QUEUE(@"Animate");
        DELAY_STAGE(m_strStartStage, 0, 1);
END_QUEUE(@"Animate");

        m_bHiden=NO;
    }

    SET_STAGE_EX(NAME(self), @"Animate", m_strStartStage);
    
    if([m_strStartStage isEqualToString:@"OffsetTex"]){
        m_vDirect=Vector3DMake(m_vEndOffsetTex.x-m_vStartOffsetTex.x, 
                               m_vEndOffsetTex.y-m_vStartOffsetTex.y, 0.0f);
        
        m_fMagnitude=Vector3DMagnitude(m_vDirect);
        Vector3DNormalize(&m_vDirect);
        
        m_vCurrentOffset=m_vStartOffsetTex;
        [self SetOffsetTexture:m_vCurrentOffset];
        
        m_fVelOffset=fabsf(m_fVelOffset);
        
        [self SetScaleTexture:m_vStartTex SecondVector:m_vEndTex];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)PrepareAnimate:(ProcStage_ex *)pStage{
    m_bHiden=NO;
    UPDATE;
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
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