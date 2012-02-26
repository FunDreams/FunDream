//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "OB_MiniParticle.h"

@implementation OB_MiniParticle
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerTemplet;
        m_iLayerTouch=layerTouch_0;//слой касания
        
        if(pParticle==nil){
            
            pParticle=[[Particle alloc] Init:self];
            [pParticle AddToContainer:@"ParticlesMini"];
            m_bHiden=YES;
        }
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{
    m_fCurPosSlader=0;
    
    mColor.red=1;
    mColor.green=1;
    mColor.blue=1;
    mColor.alpha=0;
    Start_Vector=m_pCurPosition;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
//====//процессоры для объекта==========================================================================
    
    Processor_ex *pProc = [self START_QUEUE:@"Stages"];
        
        ASSIGN_STAGE(@"ShowStage",@"Show:",
                     //отражения позиции
                     LINK_FLOAT_V(mColor.alpha, @"SrcF"),
                     SET_FLOAT_V(0, @"StartF"),
                     SET_FLOAT_V(1, @"FinishF"),
                     LINK_VECTOR_V(m_pCurPosition, @"DestV"),
                     LINK_VECTOR_V(Start_Vector, @"StartV"),
                     LINK_VECTOR_V(End_Vector, @"FinishV"));

        ASSIGN_STAGE(@"Placement",@"Placement:",
                     SET_INT_V(1000,@"TimeBaseDelay"),
                     LINK_FLOAT_V(m_fCurPosSlader, @"SrcF"),
                     SET_FLOAT_V(0, @"StartF"),
                     SET_FLOAT_V(1, @"FinishF"),
                     LINK_COLOR_V(mColor, @"DestC"),
                     LINK_COLOR_V(Start_Color, @"StartC"),
                     LINK_COLOR_V(End_Color, @"FinishC"),
                     LINK_VECTOR_V(m_pCurPosition, @"DestV"),
                     LINK_VECTOR_V(Start_Vector, @"StartV"),
                     LINK_VECTOR_V(End_Vector, @"FinishV"));

        ASSIGN_STAGE(@"Sin",@"sin:",nil);

        ASSIGN_STAGE(@"Stop",@"Idle:",nil); 
    
    [self END_QUEUE:pProc];
    
//====//различные параметры=============================================================================
    [m_pObjMng->pMegaTree SetCell:(LINK_VECTOR_V(End_Vector,m_strName,@"End_Vector"))];
    
    m_pStrType=[NSMutableString stringWithString:@""];    
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_pStrType,m_strName,@"m_pStrType")];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
    //GET_DIM_FROM_TEXTURE(@"");
	mWidth  = 30;
	mHeight = 30;

	[super Start];

    [pParticle SetFrame:0];
    [pParticle UpdateParticleMatr];
    [pParticle UpdateParticleColor];
    
    SET_STAGE_EX(self->m_strName,@"Stages",@"ShowStage");
    SET_STAGE_EX(self->m_strName,@"Morphing",@"MirrorFirst");
    m_fPhase=0;
}
//--------------------------------------------------------------------------------------------------------
- (void)Update{}
////------------------------------------------------------------------------------------------------------
- (void)InitShow:(ProcStage_ex *)pStage{
    [self InitMirror2Dvector:pStage];
}
//--------------------------------------------------------------------------------------------------------
- (void)PrepareShow:(Processor_ex *)pProc{
    
    if([m_pStrType isEqualToString:@"Up"]){

        mColor=Color3DMake(1, 0, 0, 0);
    }
    else{
        mColor=Color3DMake(0, 1, 0, 0);
    }
}
//--------------------------------------------------------------------------------------------------------
- (void)Show:(Processor_ex *)pProc{

    mColor.alpha+=DELTA*5;

    if(mColor.alpha>1){
        mColor.alpha=1;
    }

    [self Mirror2Dvector:pProc];

    [pParticle UpdateParticleMatr];
    [pParticle UpdateParticleColor];

    if(mColor.alpha==1){
        NEXT_STAGE;
    }
}
//--------------------------------------------------------------------------------------------------------
- (void)PreparePlacement:(ProcStage_ex *)pStage{
        
    Start_Color=mColor;
    Start_Vector=m_pCurPosition;
    
    if([m_pStrType isEqualToString:@"Up"]){
    
        End_Vector=Vector3DMake(((float)(RND%580)-290), 300, 0);
        End_Color=Color3DMake(1, 0, 0, 1);
        
    }
    else{
        
        End_Vector=Vector3DMake(((float)(RND%580)-290), -430, 0);
        End_Color=Color3DMake(0, 1, 0, 1);
    }
    
    m_fCurPosSlader=0;
}
//--------------------------------------------------------------------------------------------------------
- (void)InitPlacement:(ProcStage_ex *)pStage{
    [self InitMirror2Dvector:pStage];
    [self InitMirror4DColor:pStage];
}
//--------------------------------------------------------------------------------------------------------
- (void)Placement:(Processor_ex *)pProc{
    
    m_fCurPosSlader2+=DELTA*.3f;

    m_fCurPosSlader=pow(m_fCurPosSlader2,8);
    
    if(m_fCurPosSlader>1){
        m_fCurPosSlader=1;
    }
    
    [self Mirror2Dvector:pProc];
    [self Mirror4DColor:pProc];

    [pParticle UpdateParticleMatr];
    [pParticle UpdateParticleColor];
    
    if(m_fCurPosSlader==1){
        NEXT_STAGE;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Preparesin:(ProcStage_ex *)pStage{
    m_fVelPhase=RND%200+200;
    m_fPosSin=m_pCurPosition.y;
    
    m_fVelMove=RND%10+10;
    if(RND%2!=0)m_fVelMove=-m_fVelMove;
    m_fPhase=0;
}
//------------------------------------------------------------------------------------------------------
- (void)sin:(Processor_ex *)pProc{
    
    m_fPhase+=m_fVelPhase*0.01f*DELTA;
    m_pCurPosition.y=m_fPosSin+10*sin(m_fPhase);

    m_pCurPosition.x+=m_fVelMove*DELTA;
    
    if(m_pCurPosition.x>300 && m_fVelMove>0)m_fVelMove=-m_fVelMove;
    if(m_pCurPosition.x<-300 && m_fVelMove<0)m_fVelMove=-m_fVelMove;
    
    [pParticle UpdateParticleMatr];
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
@end