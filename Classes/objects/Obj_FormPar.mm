//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Obj_FormPar.h"

@implementation Obj_FormPar
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
  //      ASSIGN_STAGE(@"IDLE",@"Idle:",nil);
        ASSIGN_STAGE(@"PROC",@"Proc:",nil);
    [self END_QUEUE:pProc name:@"Proc"];
    
//====//различные параметры=============================================================================
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
    [pParticle AddToContainer:@"ParticlesShapes"];

	mWidth  = 10;
	mHeight = 10;

	[super Start];

    GET_TEXTURE(mTextureId, m_pNameTexture);

    [pParticle SetFrame:0];
    [pParticle UpdateParticleMatr];
    [pParticle UpdateParticleColor];
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
//------------------------------------------------------------------------------------------------------
- (void)InitProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)PrepareProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
@end