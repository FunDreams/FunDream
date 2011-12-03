//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectEvilMatter1.h"

@implementation ObjectEvilMatter1
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
    m_iLayer = layerOb4;

START_QUEUE(@"Proc");
//	ASSIGN_STAGE(@"Idle",@"Idle:",nil);
	ASSIGN_STAGE(@"Proc",@"Proc:",nil);
END_QUEUE(@"Proc");

    m_Corner1=Vector3DMake(130,380, 0);
    m_Corner2=Vector3DMake(290, 450, 0);
    
    mWidth  = 50;
	mHeight = 50;

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    SET_CELL(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"));
    
    SET_CELL(LINK_VECTOR_V(m_Corner1,m_strName,@"m_Corner1"));
    SET_CELL(LINK_VECTOR_V(m_Corner2,m_strName,@"m_Corner2"));
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
    GET_TEXTURE(mTextureId,@"button.png");
    
    //   GET_DIM_FROM_TEXTURE(@"");

	[super Start];

    //   m_iLayerTouch=layerTouch_0;//слой касания
    //   [self SetTouch:YES];//интерактивность

    //[m_pObjMng AddToGroup:@"NameGroup" Object:self];//группировка
    //[self SelfOffsetVert:Vector3DMake(0,1,0)];//cдвиг
    
    StartAngle=270;
    m_fVelMove=RND%10+300;
    Start_Vector=Vector3DMake(m_fVelMove*sin(StartAngle), m_fVelMove*cos(StartAngle), 0);
	m_fVelRotate=((float)(RND%200))-100;
    
    m_vCenter=Vector3DMake((m_Corner2.x-m_Corner1.x)*0.5f+m_Corner1.x,
                           (m_Corner2.y-m_Corner1.y)*0.5f+m_Corner1.y, 0);
    
    [self CreateNextPoint];
    
//    int W=(int)(m_Corner2.x-m_Corner1.x)*0.3f;
//    int H=(int)(m_Corner2.y-m_Corner1.y);
//    
//    m_vPoint=Vector3DMake(RND%W+m_Corner1.x, RND%H+m_Corner1.y, 0);

    
    m_bFirstPoint=YES;
    mColor=Color3DMake(((float)(RND%255))/255, ((float)(RND%255))/255, ((float)(RND%255))/255, 1.0f);
}
//------------------------------------------------------------------------------------------------------
- (void)CreateNextPoint{
repeate:
    int W=(int)(m_Corner2.x-m_Corner1.x);
    int H=(int)(m_Corner2.y-m_Corner1.y);
    
    m_vPoint=Vector3DMake(RND%W+m_Corner1.x, RND%H+m_Corner1.y, 0);
    Vector3D TmpV=Vector3DMake(m_vPoint.x-m_pCurPosition.x,m_vPoint.y-m_pCurPosition.y, 0);

    float Dist=Vector3DMagnitude(TmpV);
    if(Dist<30)goto repeate;
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
//------------------------------------------------------------------------------------------------------
- (void)InitProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)PrepareProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{

    Vector3D TmpV=Vector3DMake(m_vPoint.x-m_pCurPosition.x,m_vPoint.y-m_pCurPosition.y, 0);
    float change=Start_Vector.x*TmpV.y-Start_Vector.y*TmpV.x;

    float CosAngle=(TmpV.x*Start_Vector.x+TmpV.y*Start_Vector.y)/
    (Vector3DMagnitude(TmpV)*Vector3DMagnitude(Start_Vector));
    float fCurAngle=acosf(CosAngle);

    float LimAngle=0.06f;
    if(fCurAngle<LimAngle)LimAngle=fCurAngle;

    if(change<0)LimAngle=-LimAngle;

    float fCos=cosf(LimAngle);//1
    float fSin=sinf(LimAngle);//0

    Vector3D TmpStart_Vector=Vector3DMake(Start_Vector.x*fCos-Start_Vector.y*fSin,
                              Start_Vector.y*fCos+Start_Vector.x*fSin,0.0f);
    
//    StartAngle+=4*DELTA;
  //  Start_Vector=Vector3DMake(m_fVelMove*sin(StartAngle), m_fVelMove*cos(StartAngle), 0);

    Start_Vector=TmpStart_Vector;
    m_pCurAngle.z+=m_fVelRotate*DELTA;
    
    m_pCurPosition.x+=Start_Vector.x*DELTA;
    m_pCurPosition.y+=Start_Vector.y*DELTA;
    
    float Dist=Vector3DMagnitude(TmpV);
    
    if(Dist<10.0f){
        
        if(m_bFirstPoint==YES){
           
            m_bFirstPoint=NO;
            Start_Vector.x*=0.1;
            Start_Vector.y*=0.1;
            
            
            bool *pbSound=GET_BOOL_V(@"FirstSoundParticle")

            if(pbSound && *pbSound==YES){
                PLAY_SOUND(@"level_up1.wav");
                *pbSound=NO;
            }
        }
        [self CreateNextPoint];
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