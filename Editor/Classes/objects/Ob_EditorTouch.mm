//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 FunDreamsInc. All rights reserved.
//

#import "Ob_EditorTouch.h"

@implementation Ob_EditorTouch
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerTemplet;
        m_iLayerTouch=layerTouch_2N;//слой касания
        
        aProp = [[NSMutableArray alloc] init];
        aTemplate = [[NSMutableArray alloc] init];
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
//====//процессоры для объекта==========================================================================
//    Processor_ex* pProc = [self START_QUEUE:@"Proc"];
//  //      ASSIGN_STAGE(@"IDLE",@"Idle:",nil);
//        ASSIGN_STAGE(@"PROC",@"Proc:",nil);
//    [self END_QUEUE:pProc name:@"Proc"];
    
//====//различные параметры=============================================================================
//   [m_pObjMng->pMegaTree SetCell:(LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY"));
    
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    [m_pObjMng->pMegaTree SetCell:(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"))];
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
    m_bHiden=YES;
    m_bNoOffset=YES;
    mColor.alpha=0.5f;
    [self SetTouch:NO];

	mWidth  = 960;
	mHeight = 960;

	[super Start];
}
//------------------------------------------------------------------------------------------------------
- (void)InitProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)PrepareProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
//- (void)Proc:(Processor_ex *)pProc{}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    [aProp release];
    [aTemplate release];
    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
@end