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

    GET_TEXTURE(mTextureId,@"Bullet_Down.png");

	mWidth  = 100;
	mHeight = 100;
    mRadius = 90;

START_QUEUE(@"Proc");
	ASSIGN_STAGE(@"Idle",@"Idle:",nil);
//	ASSIGN_STAGE(@"Proc",@"Proc:",nil);
        
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
    ASSIGN_STAGE(@"hide",@"AchiveLineFloat:",
                 LINK_FLOAT_V(mColor.alpha,@"Instance"),
                 SET_FLOAT_V(0,@"finish_Instance"),
                 SET_FLOAT_V(-1,@"Vel"));
    
	ASSIGN_STAGE(@"Destroy",@"DestroySelf:",nil);

END_QUEUE(@"Proc");
    
START_QUEUE(@"Mirror");
    
    ASSIGN_STAGE(@"Idle",@"Idle:",nil);
    
    ASSIGN_STAGE(@"AchivePoint",@"Mirror2Dvector:",
                 LINK_VECTOR_V(m_vStartPos,@"pStartV"),
                 LINK_VECTOR_V(m_vEndPos,@"pFinishV"),
                 LINK_VECTOR_V(m_pCurPosition,@"pDestV"),
                 SET_FLOAT_V(0,@"pfStartF"),
                 SET_FLOAT_V(1,@"pfFinishF"),
                 LINK_FLOAT_V(m_fCurPosSlader2,@"pfSrc"));
    
END_QUEUE(@"Mirror");
    
START_QUEUE(@"Parabola");
    
    ASSIGN_STAGE(@"Idle",@"Idle:",nil);
    
    ASSIGN_STAGE(@"MoveParabola",@"Parabola1:",
                 SET_INT_V(4,@"PowI"),
                 LINK_FLOAT_V(m_fCurPosSlader,@"SrcF"),
                 LINK_FLOAT_V(m_fCurPosSlader2,@"DestF"));
    
END_QUEUE(@"Parabola");

    GET_TEXTURE(mTextureId,m_pNameTexture);
    
//    [self SelfOffsetVert:Vector3DMake(0,1,0)];//cдвиг
 //   m_iLayerTouch=layerTouch_0;//слой касания

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];
    //   [self SetTouch:YES];//интерактивность
    
    mColor.alpha=1;
    [m_pObjMng AddToGroup:@"StartBullet" Object:self];
    
    m_vEndPos=Vector3DMake(300, 0, 0);
    mColor = Color3DMake(1.0f,1.0f,1.0f,1.0f);
    
    m_pCurAngle.z=0;
    m_fCurPosSlader=0;
    m_fCurPosSlader2=0;

    SET_STAGE_EX(NAME(self), @"Proc", @"Idle");
    SET_STAGE_EX(NAME(self), @"Mirror", @"Idle");
    SET_STAGE_EX(NAME(self), @"Parabola", @"Idle");
    
    m_fStartScale=m_pCurScale.x;
    m_fEndScale=m_fStartScale*0.6f;
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
//------------------------------------------------------------------------------------------------------
- (void)PrepareMove:(Processor_ex *)pProc{
    
    [m_pObjMng AddToGroup:@"BallDown" Object:self];
    NEXT_STAGE;
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
- (void)AchiveLineFloat:(Processor_ex *)pProc{
    [super AchiveLineFloat:pProc];
    
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
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end