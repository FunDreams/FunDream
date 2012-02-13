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
    
    Processor_ex *pProc = [self START_QUEUE:@"Proc"];
        ASSIGN_STAGE(@"Idle",@"Idle:",nil);
        
        ASSIGN_STAGE(@"Show",@"Show:",
                     LINK_FLOAT_V(mColor.alpha,@"Instance"),
                     SET_FLOAT_V(0.6f,@"finish_Instance"),
                     LINK_FLOAT_V(m_fVelMovePos,@"Vel"));
        
        ASSIGN_STAGE(@"Position",@"Position:",
                     LINK_FLOAT_V(m_fCurPosSlader,@"Instance"),
                     SET_FLOAT_V(1,@"finish_Instance"),
                     SET_FLOAT_V(0.5f,@"Vel"));
        
        ASSIGN_STAGE(@"Wait",@"Wait:",nil);
        
        ASSIGN_STAGE(@"PrepareMove", @"PrepareMove:", nil);
        ASSIGN_STAGE(@"Move",@"AchiveLineFloat:",
                     LINK_FLOAT_V(m_pCurPosition.y,@"Instance"),
                     SET_FLOAT_V(260,@"finish_Instance"),
                     SET_FLOAT_V(600,@"Vel"));
        
        ASSIGN_STAGE(@"Mirror",@"DropRight:",
                     LINK_FLOAT_V(m_fCurPosSlader,@"Instance"),
                     SET_FLOAT_V(1,@"finish_Instance"),
                     SET_FLOAT_V(0.5f,@"Vel"));
        
        //    ASSIGN_STAGE(@"PrapareHide",@"PrapareHide:",nil);
        ASSIGN_STAGE(@"hide",@"Fade:",
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

    mWidth  = 30;
	mHeight = 30;
    mRadius = 90;

	[super Start];
    
    GET_TEXTURE(mTextureId,m_pNameTexture);

    //   [self SetTouch:YES];//интерактивность
        
    [m_pObjMng AddToGroup:@"StartBullet" Object:self];
    
    m_vEndPos=Vector3DMake(300, 0, 0);
    mColor = Color3DMake(1.0f,1.0f,1.0f,1.0f);
    
    m_pCurAngle.z=0;
    m_fCurPosSlader=0;
    m_fCurPosSlader2=0;

    SET_STAGE_EX(NAME(self), @"Proc", @"Show");
    SET_STAGE_EX(NAME(self), @"Mirror", @"Idle");
    SET_STAGE_EX(NAME(self), @"Parabola", @"Idle");
    
    m_fStartScale=m_pCurScale.x;
    m_fEndScale=m_fStartScale*0.6f;
    
    if(pParticle==nil){

        pParticle=[[Particle alloc] Init:self];
        [pParticle AddToContainer:@"ParticlesDown"];
        [pParticle SetFrame:0];
    }
    
    mColor.alpha=0;
    
    VelRotate = (float)(RND%20)-10;
    m_fVelMove=(float)(RND%20)+50;
    
    m_pCurAngle.z=RND%360;
    
    [pParticle UpdateParticleColor];
    [pParticle UpdateParticleMatr];
}
//------------------------------------------------------------------------------------------------------
- (void)Update{
    [pParticle UpdateParticleMatr];
}
//------------------------------------------------------------------------------------------------------
- (void)InitShow:(ProcStage_ex *)pStage{
    [super InitAchiveLineFloat:pStage];
}
//------------------------------------------------------------------------------------------------------
- (void)Show:(Processor_ex *)pProc{

    [super AchiveLineFloat:pProc];
    [pParticle UpdateParticleColor];
}
//------------------------------------------------------------------------------------------------------
- (void)PrepareMove:(Processor_ex *)pProc{
    
    [m_pObjMng AddToGroup:@"BallDown" Object:self];
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)PreparePosition:(ProcStage_ex *)pStage{
    [m_pObjMng RemoveFromGroup:@"BallUp" Object:self];
    
    m_vStartPos=m_pCurPosition;

    m_fVelPhase=RND%20+20;
    m_fVelPhase*=0.1f;
    m_fPosSin=-450;
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
- (void)PrepareDropRight:(ProcStage_ex *)pStage{
    [m_pObjMng RemoveFromGroup:@"BallDown" Object:self];

    mColor.alpha=0.15f;

    m_vStartPos=m_pCurPosition;
    m_fCurPosSlader=0;

    SET_STAGE_EX(NAME(self), @"Mirror", @"AchivePoint");
    SET_STAGE_EX(NAME(self), @"Parabola", @"MoveParabola");

    m_fVelRotate=(float)(RND%50)-25;
    if(m_fVelRotate>0)m_fVelRotate+=100;
    else m_fVelRotate-=100;

    [pParticle UpdateParticleColor];
}
//------------------------------------------------------------------------------------------------------
- (void)InitDropRight:(ProcStage_ex *)pStage{
    [super InitAchiveLineFloat:pStage];
}
//------------------------------------------------------------------------------------------------------
- (void)DropRight:(Processor_ex *)pProc{
    
    [super AchiveLineFloat:pProc];
    [pParticle UpdateParticleMatr];
    
    SET_MIRROR( m_fCurPosSlader2, 1, 0,m_pCurScale.x, m_fEndScale, m_fStartScale);
    SET_MIRROR( m_fCurPosSlader2, 1, 0,m_pCurScale.y, m_fEndScale, m_fStartScale);
    
    if(m_fCurPosSlader<0.7 && m_vEndPos.x>0){
        m_pCurAngle.z+=DELTA*m_fVelRotate;
    }
}
//------------------------------------------------------------------------------------------------------
- (bool)IntersectBullet:(GObject *)pOb{
    
    Vector3D V=Vector3DMake(m_pCurPosition.x-pOb->m_pCurPosition.x,
                            m_pCurPosition.y-pOb->m_pCurPosition.y,0);
    
    if(fabs(V.x)<80 && fabs(V.y)<60){
        return YES;
    }
            
    return NO;
}
//------------------------------------------------------------------------------------------------------
- (void)InitFade:(ProcStage_ex *)pStage{
    [self InitAchiveLineFloat:pStage];
}
//------------------------------------------------------------------------------------------------------
- (void)Fade:(Processor_ex *)pProc{
    [self AchiveLineFloat:pProc];
    
    [pParticle UpdateParticleColor];
}
//------------------------------------------------------------------------------------------------------
- (void)AchiveLineFloat:(Processor_ex *)pProc{
    [super AchiveLineFloat:pProc];
    [pParticle UpdateParticleMatr];
    
    int iNewScore=0;
    
    if(pProc->m_CurStage->NameStage==@"Move"){
        NSArray *pArray=[m_pObjMng GetGroup:@"BallUp"];
        
        for (GObject *pOb in pArray) {
            
            if([self IntersectBullet:pOb]){
                
                float fDist=fabs(m_pCurPosition.x-pOb->m_pCurPosition.x);
                if(fDist<10){
                    Color3D tColor=Color3DMake(1.0f, 0, 0, 1.0f);
                    OBJECT_SET_PARAMS(NAME(pOb),
                                      SET_COLOR_V(tColor,@"mColor"));
                    mColor=tColor;
                    
                    float TmpF=(m_pCurPosition.x+pOb->m_pCurPosition.x)*0.5f;
                    
                    float Deltaf=m_pCurPosition.x-TmpF;
                    m_pCurPosition.x-=Deltaf;

                    Deltaf=pOb->m_pCurPosition.x-TmpF;
                    pOb->m_pCurPosition.x-=Deltaf;
                    
                    PLAY_SOUND(@"break_5.wav");
                    
                    m_vEndPos=Vector3DMake(-300, 0, 0);
                    OBJECT_SET_PARAMS(NAME(pOb),SET_VECTOR_V(Vector3DMake(-300, 0, 0),@"m_vEndPos"));
                    
                    iNewScore=RND%30+10;
                }
                else if(fDist>40){
                    PLAY_SOUND(@"break.wav");
                    
                    iNewScore=-7;
                }
                else {
                    m_vEndPos=Vector3DMake(-300, 0, 0);
                    OBJECT_SET_PARAMS(NAME(pOb),SET_VECTOR_V(Vector3DMake(-300, 0, 0),@"m_vEndPos"));

                    PLAY_SOUND(@"break_4.wav");
                    
                    iNewScore=5;
                }
                
                NEXT_STAGE;

                NEXT_STAGE_EX(NAME(pOb), @"Proc");
                
                int *ScoreAdd=GET_INT_V(@"Score",@"iScoreAdd");
                *ScoreAdd+=iNewScore;

                
                break;
            }
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    
    [pParticle RemoveFromContainer];
    [pParticle release];
    pParticle=nil;

    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
@end