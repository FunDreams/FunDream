//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectAlNumber.h"

#define PLACEPER 40
@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
    self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerNumber;
        m_bHiden=YES;
            
        mWidth=50;
        mHeight=92;
        
        mColor = Color3DMake(1,1,0,1.0f);
    }

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    
    [m_pObjMng->pMegaTree SetCell:LINK_INT_V(m_iCurrenNumber,m_strName,@"m_iCurrentSym")];
    [m_pObjMng->pMegaTree SetCell:LINK_INT_V(m_iPlace,m_strName,@"m_iPlace")];
    
//====================================================
    Processor_ex *pProc = [self START_QUEUE:@"Move"];
        ASSIGN_STAGE(@"Move", @"Move:", nil);
    [self END_QUEUE:pProc name:@"Move"];
    
    pProc = [self START_QUEUE:@"Proc"];
    
        ASSIGN_STAGE(@"First",@"PrepareTexture:",nil);
        
        ASSIGN_STAGE(@"a10",@"timerWaitNextStage:",
                     SET_INT_V(1000, @"TimeBaseDelay"));
        //        DELAY_STAGE(@"a10", 1000, 1);
        
        ASSIGN_STAGE(@"Animate1",@"AnimateParticle:",
                     LINK_INT_V(iFinishFrame,@"Finish_Frame"),
                     LINK_INT_V(mTextureId,@"InstFrame"),
                     LINK_FLOAT_V(InstFrameFloat,@"InstFrameFloat"),
                     SET_FLOAT_V(-30,@"Vel"));
        
        ASSIGN_STAGE(@"Wait",@"Wait:",nil);
        
        ASSIGN_STAGE(@"ChangePar",@"ChangePar:",nil);
        //   DELAY_STAGE(@"ChangePar", 3000, 4000);
        
        ASSIGN_STAGE(@"Animate2",@"AnimateParticle:",
                     LINK_INT_V(iFinishFrame,@"Finish_Frame"),
                     LINK_INT_V(mTextureId,@"InstFrame"),
                     LINK_FLOAT_V(InstFrameFloat,@"InstFrameFloat"),
                     SET_FLOAT_V(30,@"Vel"));
        
        ASSIGN_STAGE(@"FinishQueue",@"FinishQueue:",nil); 
    
    [self END_QUEUE:pProc name:@"Proc"];
//====================================================
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
	
	[super Start];
	
	m_fSpeedScale = 6+(RND%2-1);
	m_fPhase=RND%10;

	[self Move:nil];

	m_pCurPosition.x=-284+m_iPlace%15*PLACEPER;
	m_pCurPosition.y=428-m_iPlace/15*(PLACEPER+18);
	
    [self PrepareTexture:nil];
    
    m_iCurrenNumberOld=m_iCurrenNumber;
    
    [self SetPosWithOffsetOwner];
    SET_STAGE_EX(NAME(self), @"Proc", @"a10");
    
    if(pParticle==nil){pParticle=[[Particle alloc] Init:self];}
}
//------------------------------------------------------------------------------------------------------
- (void)HideNum{
    [pParticle RemoveFromContainer];
}
//------------------------------------------------------------------------------------------------------
- (void)ShowNum{
    
    if(pParticle->m_pParticleContainer==nil){
        SET_STAGE_EX(NAME(self), @"Proc", @"First");
    }

    [pParticle AddToContainer:@"ParticlesScore"];
    [pParticle SetFrame:mTextureId];
}
//------------------------------------------------------------------------------------------------------
- (void)PrepareTexture:(Processor_ex *)pProc{
    
    m_iCurrentFrame=9;
	mTextureId = m_iCurrenNumber*10+m_iCurrentFrame;
    
    [pParticle SetFrame:mTextureId];

    InstFrameFloat=mTextureId;
    iFinishFrame=mTextureId-9;
    m_iCurrenNumberOld=m_iCurrenNumber;

    if(pProc!=nil){
        SET_STAGE_EX(NAME(self), @"Proc", @"Animate1");
    }
}
//------------------------------------------------------------------------------------------------------
- (void)InitAnimateParticle:(ProcStage_ex *)pStage{
    
    [self InitAnimate:pStage];
}
//------------------------------------------------------------------------------------------------------
- (void)AnimateParticle:(Processor_ex *)pProc{
    [self Animate:pProc];
    [pParticle SetFrame:mTextureId];
}
//------------------------------------------------------------------------------------------------------
- (void)Move:(Processor_ex *)pProc{

    [self SetPosWithOffsetOwner];

	if (pParticle!=nil && pParticle->m_pParticleContainer!=nil) {
		m_fPhase+=DELTA*m_fSpeedScale;
		float OffsetRotate=5.0f*sin(m_fPhase/2);
		m_pCurAngle.z=OffsetRotate;
		
		float OffsetScale=2*cos(m_fPhase);
		
		m_pCurScale.x=mWidth*0.5f+OffsetScale;
		m_pCurScale.y=mHeight*0.5f-OffsetScale;	
        
        [pParticle UpdateParticleMatr];
	}
}
//------------------------------------------------------------------------------------------------------
- (void)HidenOb:(Processor_ex *)pProc{
        
    [pParticle RemoveFromContainer];
	NEXT_STAGE;
	REPEATE;
}
//------------------------------------------------------------------------------------------------------
- (void)Wait:(Processor_ex *)pProc{
    
    if(m_iCurrenNumber!=m_iCurrenNumberOld){
        
        m_iCurrenNumberOld=m_iCurrenNumber;
        NEXT_STAGE;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)ChangePar:(Processor_ex *)pProc{

//    [self SwitchSym];
    
    InstFrameFloat=mTextureId;
    iFinishFrame=mTextureId+9;

	NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)SwitchSym{
    
    m_iCurrentFrame=9;
    mTextureId = m_iCurrenNumber*10+m_iCurrentFrame;
	
    InstFrameFloat=mTextureId;
    iFinishFrame=mTextureId-9;
    
    [pParticle SetFrame:mTextureId];
}
//------------------------------------------------------------------------------------------------------
- (void)FinishQueue:(Processor_ex *)pProc{
	
//    m_iCurrenNumber=RND%10;	
    [self SwitchSym];
    SET_STAGE_EX(NAME(self), @"Proc", @"Animate1");
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    
    m_pOwner=nil;
    [pParticle RemoveFromContainer];
    [pParticle release];
    pParticle=nil;
    
    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(CGPoint)CurrentPoint{
	//int m=0;
}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT