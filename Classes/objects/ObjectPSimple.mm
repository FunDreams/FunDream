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

START_QUEUE(@"Proc");

    ASSIGN_STAGE(@"Show",@"AchiveLineFloat:",
                 LINK_FLOAT_V(mColor.alpha,@"Instance"),
                 SET_FLOAT_V(1,@"finish_Instance"),
                 SET_FLOAT_V(1,@"Vel"));

    ASSIGN_STAGE(@"PrepareMove", @"PrepareMove:", nil);
    ASSIGN_STAGE(@"Move",@"AchiveLineFloat:",
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

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    
    SET_CELL(LINK_VECTOR_V(m_vEndPos,m_strName,@"m_vEndPos"));
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

    GET_TEXTURE(mTextureId,@"Bullet_Up.png");

    m_vEndPos=Vector3DMake(300, 0, 0);
    
    mWidth  = 100;
	mHeight = 100;
    mRadius = 90;

	[super Start];
    
    m_pCurPosition.x=((float)(RND%640)-320)*0.8f;
    m_pCurPosition.y=220;
    m_pCurAngle.z=0;
    m_fCurPosSlader=0;
    m_fCurPosSlader2=0;
    
 //   m_pCurAngle.z=RND%360;

    mColor = Color3DMake(1.0f,1.0f,1.0f,1.0f);
    mColor.alpha=0.0f;
    //[self SetTouch:YES];//интерактивность
    
    SET_STAGE_EX(NAME(self), @"Proc", @"Show");
    SET_STAGE_EX(NAME(self), @"Mirror", @"Idle");
    SET_STAGE_EX(NAME(self), @"Parabola", @"Idle"); 
    
    m_fStartScale=m_pCurScale.x;
    m_fEndScale=m_fStartScale*0.6f;
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
//------------------------------------------------------------------------------------------------------
- (void)PrepareMove:(Processor_ex *)pProc{
    
    [m_pObjMng AddToGroup:@"BallUp" Object:self];
    NEXT_STAGE;
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
