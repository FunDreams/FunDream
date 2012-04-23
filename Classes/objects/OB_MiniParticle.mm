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
                     SET_INT_V(10,@"TimeBaseDelay"),
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

        ASSIGN_STAGE(@"Attract",@"Attract:",nil);

        ASSIGN_STAGE(@"Stop",@"Idle:",nil); 
    
    [self END_QUEUE:pProc];
    
//====//различные параметры=============================================================================
    [m_pObjMng->pMegaTree SetCell:(LINK_VECTOR_V(End_Vector,m_strName,@"End_Vector"))];
    
    m_pStrType=[NSMutableString stringWithString:@""];    
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_pStrType,m_strName,@"m_pStrType")];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
    [pParticle AddToContainer:@"ParticlesMini"];

	mWidth  = 30;
	mHeight = 30;

	[super Start];
    
    m_fPhase=0;
    
    if([m_pStrType isEqualToString:@"Up"]){
        [m_pObjMng AddToGroup:@"UpPar" Object:self];
        bUp=YES;
    }
    SET_STAGE_EX(self->m_strName,@"Stages",@"ShowStage");
    SET_STAGE_EX(self->m_strName,@"Morphing",@"MirrorFirst");
    
//    m_pCurPosition.x=RND_I_F(0, 200);
//    m_pCurPosition.y=RND_I_F(0, 400);
//    
//    mColor=Color3DMake(1, 0, 0, 1);
    
    [pParticle SetFrame:0];
    [pParticle UpdateParticleMatr];
    [pParticle UpdateParticleColor];
}
//--------------------------------------------------------------------------------------------------------
- (void)Update{}
////------------------------------------------------------------------------------------------------------
- (void)InitShow:(ProcStage_ex *)pStage{
    [self InitMirror2Dvector:pStage];
}
//--------------------------------------------------------------------------------------------------------
- (void)PrepareShow:(Processor_ex *)pProc{
    
    if(bUp==YES){

        mColor=Color3DMake(1, 0, 0, 0);
    }
    else{
        mColor=Color3DMake(0, 1, 0, 0);
    }   
}
//--------------------------------------------------------------------------------------------------------
- (void)Show:(Processor_ex *)pProc{

    mColor.alpha+=DELTA*10;

    if(mColor.alpha>1){
        mColor.alpha=0.999f;
    }

    [self Mirror2Dvector:pProc];
    
    if(mColor.alpha==0.999f){
        NEXT_STAGE;
    }

    [pParticle UpdateParticleMatr];
    [pParticle UpdateParticleColor];
}
//--------------------------------------------------------------------------------------------------------
- (void)PreparePlacement:(ProcStage_ex *)pStage{
        
    Start_Color=mColor;
    Start_Vector=m_pCurPosition;
    
    if(bUp==YES){
    
        End_Vector=Vector3DMake(RND_I_F(m_pCurPosition.x,30), 300, 0);
        End_Color=Color3DMake(1, 0, 0, 1);
        
    }
    else{
        
        End_Vector=Vector3DMake(RND_I_F(m_pCurPosition.x,30), -430, 0);
        End_Color=Color3DMake(0, 1, 0, 1);
    }
    
    m_fCurPosSlader=0;
}
//-------------------------------------------------------------------------------------------------------
- (void)InitPlacement:(ProcStage_ex *)pStage{
    [self InitMirror2Dvector:pStage];
    [self InitMirror4DColor:pStage];
}
//-------------------------------------------------------------------------------------------------------
- (void)Placement:(Processor_ex *)pProc{
    
    m_fCurPosSlader2+=DELTA*3;//.3f;

    m_fCurPosSlader=pow(m_fCurPosSlader2,8);
    
    if(m_fCurPosSlader>0.999f){
        m_fCurPosSlader=0.999f;
    }
    
    [self Mirror2Dvector:pProc];
    [self Mirror4DColor:pProc];
    
    if(m_fCurPosSlader==0.999f){
        NEXT_STAGE;
    }
    
    [pParticle UpdateParticleMatr];
    [pParticle UpdateParticleColor];
}
//------------------------------------------------------------------------------------------------------
- (void)Preparesin:(ProcStage_ex *)pStage{
    m_fVelPhase=float(RND%200)+200;
    m_fPosSin=m_pCurPosition.y;
    
    m_fVelMove=float(RND%30)+30;
    if(RND%2!=0)m_fVelMove=-m_fVelMove;
    m_fPhase=0;
}
//------------------------------------------------------------------------------------------------------
- (void)sin:(Processor_ex *)pProc{
    
    m_fPhase+=m_fVelPhase*0.01f*DELTA;
   m_pOffsetCurPosition.y=.5f*sin(m_fPhase);

    m_pCurPosition.x+=m_fVelMove*DELTA;

    if(m_pCurPosition.x>300 && m_fVelMove>0)m_fVelMove=-m_fVelMove;
    if(m_pCurPosition.x<-300 && m_fVelMove<0)m_fVelMove=-m_fVelMove;

    if(bUp==YES){
        NSMutableArray *pArr= [m_pObjMng GetGroup:@"Shapes"];

        if(pArr!=nil && [pArr count]>0){

            for(GObject *pOb in pArr){
                float fDelta=m_pCurPosition.x-pOb->m_pCurPosition.x;
                
                if(pOb->m_pCurPosition.y<260)continue;
                
                if(fabs(fDelta)<60){
                    
                    if(fDelta<0 && m_fVelMove>0){
                        m_fVelMove=-m_fVelMove;
                    }

                    if(fDelta>0 && m_fVelMove<0){
                        m_fVelMove=-m_fVelMove;
                    }
                }
            }
        }
    }
    [pParticle UpdateParticleMatrWihtOffset];
}
//------------------------------------------------------------------------------------------------------
- (void)PrepareAttract:(Processor_ex *)pProc{
    
    if(bUp==YES){
        [m_pObjMng RemoveFromGroup:@"UpPar" Object:self];
        
        m_fStart=m_pCurPosition.x;
        
        m_fVelRotate=RND_I_F(0,100);
        mColor=Color3DMake(1,1,1,1.0f);
        [pParticle UpdateParticleColor];
        m_fAmpl=0.5f;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Attract:(Processor_ex *)pProc{
    
    if(m_pOwner){
        float Vel=(m_pOwner->m_pCurPosition.x-m_pCurPosition.x)*3.0f;
        m_pCurPosition.x+=Vel*DELTA;

		m_pCurPosition.y=m_pOwner->m_pCurPosition.y;
	}

    m_fAmpl+=DELTA;
    if(m_fAmpl>1)m_fAmpl=1;

    m_fPhase+=m_fVelPhase*0.01f*DELTA;
    m_pOffsetCurPosition.y=m_fAmpl*sin(m_fPhase);
    
    m_pCurAngle.z+=DELTA*m_fVelRotate;
    [pParticle UpdateParticleMatrWihtOffset];
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
@end