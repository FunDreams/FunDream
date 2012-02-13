//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectCup.h"

@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{	
    self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerInterfaceSpace1;
    }

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    
    Processor_ex* pProc = [self START_QUEUE:@"Proc"];
    
    ASSIGN_STAGE(@"e00",@"Idle:",nil);
    
    ASSIGN_STAGE(@"Move",@"AchiveLineFloat:",
                 LINK_FLOAT_V(m_fCurPosSlader,@"Instance"),
                 SET_FLOAT_V(1,@"finish_Instance"),
                 SET_FLOAT_V(1,@"Vel"));
    
    ASSIGN_STAGE(@"e03",@"DestroySelf:",nil);
    
    [self END_QUEUE:pProc name:@"Proc"];
    
    
    pProc = [self START_QUEUE:@"Mirror"];
    
    //   ASSIGN_STAGE(@"Idle",@"Idle:",nil);
    
    ASSIGN_STAGE(@"AchivePoint",@"Mirror2Dvector:",
                 LINK_VECTOR_V(m_vStartPos,@"pStartV"),
                 LINK_VECTOR_V(m_vEndPos,@"pFinishV"),
                 LINK_VECTOR_V(m_pCurPosition,@"pDestV"),
                 SET_FLOAT_V(0,@"pfStartF"),
                 SET_FLOAT_V(1,@"pfFinishF"),
                 LINK_FLOAT_V(m_fCurPosSlader2,@"pfSrc"));
    
    [self END_QUEUE:pProc name:@"Mirror"];
    
    
    pProc = [self START_QUEUE:@"Parabola"];
    
    //   ASSIGN_STAGE(@"Idle",@"Idle:",nil);
    
    ASSIGN_STAGE(@"MoveParabola",@"Parabola2:",
                 SET_INT_V(4,@"PowI"),
                 LINK_FLOAT_V(m_fCurPosSlader,@"SrcF"),
                 LINK_FLOAT_V(m_fCurPosSlader2,@"DestF"));
    
    [self END_QUEUE:pProc name:@"Parabola"];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
	    
    m_vStartPos=m_pCurPosition;
    m_vEndPos=m_pCurPosition;
    m_vEndPos.y-=1000;

    GET_DIM_FROM_TEXTURE(@"main_interface@2x.png");

	[super Start];
    
    GET_TEXTURE(mTextureId,@"main_interface@2x.png");
}
//------------------------------------------------------------------------------------------------------
- (void)Move{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT