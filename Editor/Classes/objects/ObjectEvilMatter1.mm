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
    self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerOb4;

        m_Corner1=Vector3DMake(200,400, 0);
        m_Corner2=Vector3DMake(300, 450, 0);

        mWidth  = 100;
        mHeight = 100;
    }

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{
    m_bHiden=NO;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    SET_CELL(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"));
    
    [m_pObjMng->pMegaTree SetCell:LINK_VECTOR_V(m_Corner1,m_strName,@"m_Corner1")];
    [m_pObjMng->pMegaTree SetCell:LINK_VECTOR_V(m_Corner2,m_strName,@"m_Corner2")];
    
    Processor_ex* pProc = [self START_QUEUE:@"Proc"];

    ASSIGN_STAGE(@"Proc",@"Proc:",SET_INT_V(1000,@"TimeRndDelay"));

        ASSIGN_STAGE(@"Move",@"AchiveLineFloat:",
                     LINK_FLOAT_V(m_fCurPosSlader,@"Instance"),
                     SET_FLOAT_V(1,@"finish_Instance"),
                     SET_FLOAT_V(.20f,@"Vel"));
        
        ASSIGN_STAGE(@"Birth",@"Birth:",nil);
        ASSIGN_STAGE(@"Destroy",@"DestroySelf:",nil);
    
    [self END_QUEUE:pProc name:@"Proc"];
    
    pProc = [self START_QUEUE:@"Mirror"];
    
        ASSIGN_STAGE(@"Idle",@"Idle:",nil);
        
        ASSIGN_STAGE(@"AchivePoint",@"Mirror2Dvector:",
                     LINK_VECTOR_V(m_vStartPos,@"StartV"),
                     LINK_VECTOR_V(m_vEndPos,@"FinishV"),
                     LINK_VECTOR_V(m_pCurPosition,@"DestV"),
                     SET_FLOAT_V(0,@"StartF"),
                     SET_FLOAT_V(1,@"FinishF"),
                     LINK_FLOAT_V(m_fCurPosSlader2,@"SrcF"));
    
    [self END_QUEUE:pProc name:@"Mirror"];
    
    pProc = [self START_QUEUE:@"Parabola"];
    
        ASSIGN_STAGE(@"Idle",@"Idle:",nil);
        
        ASSIGN_STAGE(@"MoveParabola",@"Parabola1:",
                     SET_INT_V(4,@"PowI"),
                     LINK_FLOAT_V(m_fCurPosSlader,@"SrcF"),
                     LINK_FLOAT_V(m_fCurPosSlader2,@"DestF"));
    
    [self END_QUEUE:pProc name:@"Parabola"];

}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
    //   GET_DIM_FROM_TEXTURE(@"");

	[super Start];
    
    GET_TEXTURE(mTextureId,@"button.png");

    //   m_iLayerTouch=layerTouch_0;//слой касания
    //   [self SetTouch:YES];//интерактивность

    //[m_pObjMng AddToGroup:@"NameGroup" Object:self];//группировка
    //[self SelfOffsetVert:Vector3DMake(0,1,0)];//cдвиг
    
    StartAngle=270;
    m_fVelMove=RND%10+200;
    Start_Vector=Vector3DMake(m_fVelMove*sin(StartAngle),m_fVelMove*cos(StartAngle),0);
	m_fVelRotate=((float)(RND%200))-100;
    
    m_vCenter=Vector3DMake((m_Corner2.x-m_Corner1.x)*0.5f+m_Corner1.x,
                           (m_Corner2.y-m_Corner1.y)*0.5f+m_Corner1.y, 0);
    
    [self CreateNextPoint];
    
//    int W=(int)(m_Corner2.x-m_Corner1.x)*0.3f;
//    int H=(int)(m_Corner2.y-m_Corner1.y);
//    
//    m_vPoint=Vector3DMake(RND%W+m_Corner1.x, RND%H+m_Corner1.y, 0);
    
    m_bFirstPoint=YES;
    mColor=Color3DMake(((float)(RND%255))/255,((float)(RND%255))/255,((float)(RND%255))/255, 1.0f);
    
    SET_STAGE_EX(NAME(self),@"Mirror",@"Idle");
    SET_STAGE_EX(NAME(self),@"Parabola",@"Idle");
    SET_STAGE_EX(NAME(self), @"Proc", @"Proc");
}
//------------------------------------------------------------------------------------------------------
-(void)CreateNextPoint{
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
- (void)PrepareAchiveLineFloat:(ProcStage_ex *)pStage{
    
    m_vStartPos=m_pCurPosition;
    m_vEndPos=Vector3DMake(0, 0, 0);
    m_fCurPosSlader=0;
    m_fCurPosSlader2=0;
}
//------------------------------------------------------------------------------------------------------
- (void)PrepareProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)PrepareBirth:(ProcStage_ex *)pStage{
    
    float W=500;

    int iCountUp=100;
    float Step=W/iCountUp;
    float StartPoint=-W/2;

    for(int i=0;i<iCountUp;i++){
        UNFROZE_OBJECT(@"OB_MiniParticle",
            SET_VECTOR_V(m_pCurPosition,@"m_pCurPosition"),
            SET_STRING_V(@"Down", @"m_pStrType"),
            SET_VECTOR_V(Vector3DMake(StartPoint+Step*i+Step*0.5f,-40+(float)(RND%60-30),0),@"End_Vector"));
    }

    int iCountDown=100;
    Step=W/iCountDown;
    
    for(int i=0;i<iCountDown;i++){
        UNFROZE_OBJECT(@"OB_MiniParticle",
            SET_VECTOR_V(m_pCurPosition,@"m_pCurPosition"),
            SET_STRING_V(@"Up", @"m_pStrType"),
            SET_VECTOR_V(Vector3DMake(StartPoint+Step*i+Step*0.5f,40+(float)(RND%60-30),0),@"End_Vector"));
    }

    CREATE_NEW_OBJECT(@"ObjectGameSpaun",@"Spaun",nil);
}
//------------------------------------------------------------------------------------------------------
- (void)Birth:(Processor_ex *)pProc{
    m_pCurScale.x-=300.0f*DELTA;
    m_pCurScale.y-=300.0f*DELTA;
    
    if(m_pCurScale.x<10){
        NEXT_STAGE;
    }
}
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
    
    m_pCurPosition.x+=Start_Vector.x*DELTA*0.8f;
    m_pCurPosition.y+=Start_Vector.y*DELTA*0.8f;
    
    float Dist=Vector3DMagnitude(TmpV);
    
    if(Dist<10.0f){
        
        if(m_bFirstPoint==YES){
           
            m_bFirstPoint=NO;
            Start_Vector.x*=0.1;
            Start_Vector.y*=0.1;
            
            bool *pbSound=GET_BOOL_V(@"FirstSoundParticle")

            if(pbSound && *pbSound==YES){
           //   PLAY_SOUND(@"level_up1.wav");
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
@end