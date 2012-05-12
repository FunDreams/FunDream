//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectGameSpaun.h"

@implementation ObjectGameSpaun
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self=[super Init:Parent WithName:strName];
	
    if(self!=nil)
    {
        m_bHiden=YES;
    }
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    
    Processor_ex *pProc = [self START_QUEUE:@"Proc"];
        //	ASSIGN_STAGE(@"Idle",@"Idle:",nil);
        ASSIGN_STAGE(@"Spaun",@"Spaun:",
                     SET_INT_V(10000,@"TimeBaseDelay"),
                     SET_INT_V(100,@"TimeRndDelay"));
    
    [self END_QUEUE:pProc];
    
//   SET_CELL(LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY"));
    
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    SET_CELL(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"));
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    m_iLayer = layerSystem;

	[super Start];
    
    m_fStartPeriod=3;
    m_fCurrntPeriod=m_fStartPeriod;
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
//------------------------------------------------------------------------------------------------------
- (void)Spaun{
    int *CountSinPar=GET_INT_V(@"EvilPar",@"iCountParInSin");
    
    if (*CountSinPar>0) {
        CREATE_NEW_OBJECT(@"Ob_Shape",@"Shape",
                          SET_VECTOR_V(Vector3DMake(32,32,0),@"m_vSize"),
                          SET_INT_V(1, @"m_iCountX"),
                          SET_INT_V(1, @"m_iCountY"),
                          SET_INT_V(1, @"m_INumLoadTextures"),
                          SET_STRING_V(@"Particle_001.png",@"m_pNameTexture"),
                          SET_VECTOR_V(Vector3DMake(RND_I_F(0,250), 320, 0),@"m_pCurPosition"),
                          SET_INT_V(6,@"iDiff"));
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Spaun:(Processor_ex *)pProc{
    
    [self Spaun];
    m_fCurrntPeriod=m_fStartPeriod;
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
@end