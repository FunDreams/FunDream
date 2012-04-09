//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_Shape.h"

@implementation Ob_Shape
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerTemplet;
        m_iLayerTouch=layerTouch_0;//слой касания
        
        m_bHiden=YES;
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
    
	mWidth  = 50;
	mHeight = 50;

	[super Start];
    
    for (int i=0; i<10; i++) {
        UNFROZE_OBJECT(@"Obj_FormPar",
        SET_VECTOR_V(Vector3DMake(RND_I_F(m_pCurPosition.x,5),RND_I_F(m_pCurPosition.y,5),0),@"m_pCurPosition"));
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
//------------------------------------------------------------------------------------------------------
- (void)InitProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)PrepareProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{
    //
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
@end