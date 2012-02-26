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
	self = [super Init:Parent WithName:strName];
    if(self!=nil)
    {
        m_fVelMovePos=1;
        m_iLayer = layerOb2;
        m_bHiden=YES;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    
    [m_pObjMng->pMegaTree SetCell:LINK_VECTOR_V(m_vEndPos,m_strName,@"m_vEndPos")];
    
    
    Processor_ex *pProc = [self START_QUEUE:@"Proc"];
    
        ASSIGN_STAGE(@"Show",@"AchiveLineFloat:",
                     LINK_FLOAT_V(mColor.alpha,@"Instance"),
                     SET_FLOAT_V(0.6f,@"finish_Instance"),
                     LINK_FLOAT_V(m_fVelMovePos,@"Vel"));
        
        ASSIGN_STAGE(@"Position",@"Position:",
                     LINK_FLOAT_V(m_fCurPosSlader,@"Instance"),
                     SET_FLOAT_V(1,@"finish_Instance"),
                     SET_FLOAT_V(0.5f,@"Vel"));
        
        ASSIGN_STAGE(@"Wait",@"Wait:",nil);
        
        ASSIGN_STAGE(@"PrepareMove", @"PrepareMove:", nil);
        ASSIGN_STAGE(@"Move",@"AchiveLineFloatBall:",
                     LINK_FLOAT_V(m_pCurPosition.y,@"Instance"),
                     SET_FLOAT_V(-360,@"finish_Instance"),
                     SET_FLOAT_V(-50,@"Vel"));
        
        ASSIGN_STAGE(@"Mirror",@"DropRight:",
                     LINK_FLOAT_V(m_fCurPosSlader,@"Instance"),
                     SET_FLOAT_V(1,@"finish_Instance"),
                     SET_FLOAT_V(0.5f,@"Vel"));
        
        ASSIGN_STAGE(@"hide",@"AchiveLineFloat:",
                     LINK_FLOAT_V(mColor.alpha,@"Instance"),
                     SET_FLOAT_V(0,@"finish_Instance"),
                     SET_FLOAT_V(-1,@"Vel"));
        
        ASSIGN_STAGE(@"Destroy",@"DestroySelf:",nil);

    [self END_QUEUE:pProc];
    
    pProc = [self START_QUEUE:@"Mirror"];
    
        ASSIGN_STAGE(@"Idle",@"Idle:",nil);
        
        ASSIGN_STAGE(@"AchivePoint",@"Mirror2Dvector:",
                     LINK_VECTOR_V(m_vStartPos,@"pStartV"),
                     LINK_VECTOR_V(m_vEndPos,@"pFinishV"),
                     LINK_VECTOR_V(m_pCurPosition,@"pDestV"),
                     SET_FLOAT_V(0,@"pfStartF"),
                     SET_FLOAT_V(1,@"pfFinishF"),
                     LINK_FLOAT_V(m_fCurPosSlader2,@"pfSrc"));
    
    [self END_QUEUE:pProc];
    

    pProc = [self START_QUEUE:@"Parabola"];
    
        ASSIGN_STAGE(@"Idle",@"Idle:",nil);
        
        ASSIGN_STAGE(@"MoveParabola",@"Parabola1:",
                     SET_INT_V(4,@"PowI"),
                     LINK_FLOAT_V(m_fCurPosSlader,@"SrcF"),
                     LINK_FLOAT_V(m_fCurPosSlader2,@"DestF"));

    [self END_QUEUE:pProc];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

//    GET_TEXTURE(mTextureId,@"Bullet_Up.png");

    m_pCurPosition.x=(float)(RND%500)-250;
    m_pCurPosition.y=300;
    
    VelRotate = (float)(RND%20)-10;
    m_fVelMove=(float)(RND%20)+50;
//    m_pCurAngle.z=RND%360;

    m_vEndPos=Vector3DMake(300, 0, 0);
    
    mWidth  = 30;
	mHeight = 30;
    mRadius = 90;

	[super Start];
    
    m_fCurPosSlader=0;
    m_fCurPosSlader2=0;

    mColor = Color3DMake(1.0f,1.0f,1.0f,1.0f);
    mColor.alpha=0.0f;
     
    SET_STAGE_EX(NAME(self), @"Proc", @"Show");
    SET_STAGE_EX(NAME(self), @"Mirror", @"Idle");
    SET_STAGE_EX(NAME(self), @"Parabola", @"Idle"); 
    
    m_fStartScale=m_pCurScale.x;
    m_fEndScale=m_fStartScale*0.6f;
    
    if(pParticle==nil){
        
        pParticle=[[Particle alloc] Init:self];
        [pParticle AddToContainer:@"ParticlesUp"];
        [pParticle SetFrame:0];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Update{
    [pParticle UpdateParticleMatr];
}
//------------------------------------------------------------------------------------------------------
- (void)PrepareMove:(Processor_ex *)pProc{
    
    [m_pObjMng AddToGroup:@"BallUp" Object:self];
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)PreparePosition:(ProcStage_ex *)pStage{
    [m_pObjMng RemoveFromGroup:@"BallUp" Object:self];
    
    m_vStartPos=m_pCurPosition;

    m_fVelPhase=RND%20+20;
    m_fVelPhase*=0.1f;
    m_fPosSin=300;
    m_vEndPos=Vector3DMake((float)(RND%600)-300, m_fPosSin, 0);

    m_fCurPosSlader=0;
    
    SET_STAGE_EX(NAME(self), @"Mirror", @"AchivePoint");
    SET_STAGE_EX(NAME(self), @"Parabola", @"MoveParabola");
    
    m_fVelRotate=(float)(RND%50)-25;
    m_fVelMovePos=1;

    int iRnd=RND%2;

    if(iRnd==0)
        m_iDir=-1;
    else m_iDir=1;

    if(m_fVelRotate>0)m_fVelRotate+=100;
    else m_fVelRotate-=100;    
}
//------------------------------------------------------------------------------------------------------
- (void)InitPosition:(ProcStage_ex *)pStage{
    [super InitAchiveLineFloat:pStage];
}
//------------------------------------------------------------------------------------------------------
- (void)Position:(Processor_ex *)pProc{
    
    [super AchiveLineFloat:pProc];
    
    [pParticle UpdateParticleMatr];
}
//------------------------------------------------------------------------------------------------------
- (void)PrepareDropRight:(ProcStage_ex *)pStage{
    [m_pObjMng RemoveFromGroup:@"BallUp" Object:self];
    
    mColor.alpha=0.15f;
    m_vStartPos=m_pCurPosition;
    m_fCurPosSlader=0;
    
    SET_STAGE_EX(NAME(self), @"Mirror", @"AchivePoint");
    SET_STAGE_EX(NAME(self), @"Parabola", @"MoveParabola");
    
    m_fVelRotate=(float)(RND%50)-25;
    
    if(m_fVelRotate>0)m_fVelRotate+=100;
    else m_fVelRotate-=100;    
}
//------------------------------------------------------------------------------------------------------
- (void)InitDropRight:(ProcStage_ex *)pStage{
    [super InitAchiveLineFloat:pStage];
}
//------------------------------------------------------------------------------------------------------
- (void)DropRight:(Processor_ex *)pProc{
    
    [super AchiveLineFloat:pProc];
    
    SET_MIRROR( m_fCurPosSlader2, 1, 0,m_pCurScale.x, m_fEndScale, m_fStartScale);
    SET_MIRROR( m_fCurPosSlader2, 1, 0,m_pCurScale.y, m_fEndScale, m_fStartScale);

    if(m_fCurPosSlader<0.7 && m_vEndPos.x>0){
        m_pCurAngle.z+=DELTA*m_fVelRotate;
    }
    
    [pParticle UpdateParticleMatr];
    [pParticle UpdateParticleColor];
}
//------------------------------------------------------------------------------------------------------
- (void)PrepareWait:(ProcStage_ex *)pStage{
    SET_STAGE_EX(NAME(self), @"Mirror", @"Idle");
    SET_STAGE_EX(NAME(self), @"Parabola", @"Idle"); 
}
//------------------------------------------------------------------------------------------------------
- (void)Wait:(Processor_ex *)pProc{
    m_pCurAngle.z+=DELTA*VelRotate;
    
//    if()
    m_fVelMoveTmp+=DELTA*70;
    if(m_fVelMoveTmp>m_fVelMove)m_fVelMoveTmp=m_fVelMove;
    
    m_pCurPosition.x+=m_fVelMoveTmp*DELTA*m_iDir;
    
    if(m_pCurPosition.x>300 && m_iDir>0)m_iDir=-1;
    if(m_pCurPosition.x<-300 && m_iDir<0)m_iDir=1;
    
    m_fPhase+=m_fVelMoveTmp*0.05f*DELTA;
    m_pCurPosition.y=m_fPosSin+10*sin(m_fPhase);

    [pParticle UpdateParticleMatr];
}
//------------------------------------------------------------------------------------------------------
- (void)AchiveLineFloat:(Processor_ex *)pProc{

//    m_pCurAngle.z+=DELTA*10;
    [super AchiveLineFloat:pProc];
    [pParticle UpdateParticleColor];
}
//------------------------------------------------------------------------------------------------------
- (void)InitAchiveLineFloatBall:(ProcStage_ex *)pStage{
    [super InitAchiveLineFloat:pStage];
}
//------------------------------------------------------------------------------------------------------
- (void)AchiveLineFloatBall:(Processor_ex *)pProc{
    [super AchiveLineFloat:pProc];
    [pParticle UpdateParticleMatr];
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    UPDATE;
    
    [pParticle RemoveFromContainer];
    [pParticle release];
    pParticle=nil;

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
@end
