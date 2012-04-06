//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_PensilPar.h"

@implementation Ob_PensilPar
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
//- (void)SetDefault{}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
//====//процессоры для объекта==========================================================================
    Processor_ex* pProc = [self START_QUEUE:@"Proc"];
        ASSIGN_STAGE(@"IDLE",@"Idle:",nil);
        ASSIGN_STAGE(@"PROC",@"Proc:",nil);
    ASSIGN_STAGE(@"HIDEN",@"Hiden:",SET_INT_V(500,@"TimeBaseDelay"));
    [self END_QUEUE:pProc name:@"Proc"];
    
//======различные параметры=============================================================================
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
    [pParticle AddToContainer:@"ParticlesPensil"];

	mWidth  = 50;
	mHeight = 50;

	[super Start];

    mColor.alpha=1;

    [pParticle SetFrame:0];
    [pParticle UpdateParticleMatr];
    [pParticle UpdateParticleColor];
    m_fVelMove=50;
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
//------------------------------------------------------------------------------------------------------
- (void)InitProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)PrepareProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{
    
    m_fVelMove+=DELTA*500;
    m_pCurPosition.y+=DELTA*m_fVelMove;

    if(m_pCurPosition.y>=0){
        m_pCurPosition.y=0;
        NEXT_STAGE;
    }
    
    [pParticle UpdateParticleMatr];
}
//------------------------------------------------------------------------------------------------------
- (void)Hiden:(Processor_ex *)pProc{
    mColor.alpha-=DELTA;
    
    if(mColor.alpha<0){
        
        mColor.alpha=0;
        DESTROY_OBJECT(self);
    }
    [pParticle UpdateParticleColor];
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
@end