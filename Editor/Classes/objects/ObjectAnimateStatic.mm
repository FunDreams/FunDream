//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectAnimateStatic.h"
#import "UniCell.h"

@implementation ObjectAnimateStatic
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerOb3;
        m_fVelFrame=25;

    //    [self SelfOffsetVert:Vector3DMake(0,1,0)];//cдвиг
     //   m_iLayerTouch=layerTouch_0;//слой касания
        
        m_vStartTex = Vector3DMake(0.0f, 0.0f, 0.0f);
        m_vEndTex   = Vector3DMake(1.0f, 1.0f, 0.0f);
        
        m_fVelOffset=0.3f;
        
        m_vStartOffsetTex = Vector3DMake(0.0f, 0.0f, 0.0f);
        m_vEndOffsetTex   = Vector3DMake(1.0f, 0.0f, 0.0f);
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{
    m_strStartStage=[NSMutableString stringWithString:@"Animate"];
    m_strGroup=[NSMutableString stringWithString:@"Animate"];
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    
    [m_pObjMng->pMegaTree SetCell:LINK_INT_V(m_iOffsetFrame,m_strName,@"m_iOffsetFrame")];
    [m_pObjMng->pMegaTree SetCell:LINK_INT_V(m_fVelFrame,m_strName,@"m_fVelFrame")];
    
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimFromTexture,m_strName,@"m_bDimFromTexture")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimMirrorX,m_strName,@"m_bDimMirrorX")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY")];

    [m_pObjMng->pMegaTree SetCell:LINK_VECTOR_V(m_vStartOffsetTex,m_strName,@"m_vStartOffsetTex")];
    [m_pObjMng->pMegaTree SetCell:LINK_VECTOR_V(m_vEndOffsetTex,m_strName,@"m_vEndOffsetTex")];
    
    [m_pObjMng->pMegaTree SetCell:LINK_VECTOR_V(m_vStartTex,m_strName,@"m_vStartTex")];
    [m_pObjMng->pMegaTree SetCell:LINK_VECTOR_V(m_vEndTex,m_strName,@"m_vEndTex")];
    
    [m_pObjMng->pMegaTree SetCell:LINK_FLOAT_V(m_fVelOffset,m_strName,@"m_fVelOffset")];

    [m_pObjMng->pMegaTree SetCell:LINK_INT_V(m_iStartDelay,m_strName,@"m_fStartDelay")];
    
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_strStartStage,m_strName,@"m_strStartStage")];

    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_strGroup,m_strName,@"m_strGroup")];
    
    
    
    Processor_ex* pProc = [self START_QUEUE:@"Animate"];
    
    ASSIGN_STAGE(@"AnimateLoop",@"AnimateLoop:",
                 LINK_INT_V(m_iStartFrame,@"Start_Frame"),
                 LINK_INT_V(m_iFinishFrame,@"Finish_Frame"),
                 LINK_INT_V(mTextureId,@"InstFrame"),
                 LINK_FLOAT_V(InstFrameFloat,@"InstFrameFloat"),
                 LINK_FLOAT_V(m_fVelFrame,@"Vel"));
    
    
    ASSIGN_STAGE(@"Idle",@"Idle:",nil);
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
    
    [self END_QUEUE:pProc name:@"Animate"];

}
//------------------------------------------------------------------------------------------------------
- (void)Start{

    mTextureId=-1;
    mTextureId = [m_pParent GetTextureId:m_pNameTexture];
    
    if(m_bDimFromTexture){GET_DIM_FROM_TEXTURE(m_pNameTexture);}
    
	[super Start];
    
    if(m_bDimMirrorX==YES){m_pCurScale.x=-m_pCurScale.x;}
    if(m_bDimMirrorY==YES){m_pCurScale.y=-m_pCurScale.y;}
    
    InstFrameFloat=mTextureId;
    m_iStartFrame=mTextureId;
    m_iFinishFrame=mTextureId+m_iOffsetFrame;
        
    
    if(m_iStartDelay>0){

        PROC_SET_PARAMS(@"Animate",m_strStartStage,
                        SET_INT_V(m_iStartDelay, @"TimeBaseDelay"),
                        SET_INT_V(1, @"TimeRndDelay"));
        
        m_bHiden=YES;
    }
    else {

        PROC_SET_PARAMS(@"Animate",m_strStartStage,
                        SET_INT_V(0, @"TimeBaseDelay"),
                        SET_INT_V(1, @"TimeRndDelay"));

        m_bHiden=NO;
    }

    SET_STAGE_EX(self->m_strName, @"Animate", m_strStartStage);

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

//    if(![m_strGroup isEqualToString:@"Animate"])
  //      [m_pObjMng AddToGroup:m_strGroup Object:self];
}
//------------------------------------------------------------------------------------------------------
- (void)PrepareAnimate:(ProcStage_ex *)pStage{
    HIDE;
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    [super Destroy];
    
//    if(![m_strGroup isEqualToString:@"Animate"])
//    {
//        [m_pObjMng RemoveFromGroup:m_strGroup Object:self];
//        [m_strGroup setString:@"Animate"];
//    }
}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
@end