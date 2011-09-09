//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectFade.h"

@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
    mWidth  = 50;
	mHeight = 50;

	m_iLayer = layerInvisible;
        
START_QUEUE(@"Proc");
	
    ASSIGN_STAGE(@"ShowStage",@"AchiveLineFloat:",
                 LINK_FLOAT_V(mColor.alpha,@"Instance"),
                 LINK_FLOAT_V(m_fFinish,@"finish_Instance"),
                 LINK_FLOAT_V(m_fVelFade,@"Vel"));

    ASSIGN_STAGE(@"Idle",@"Idle:",nil);
    
    ASSIGN_STAGE(@"HideStage",@"AchiveLineFloat:",
                 LINK_FLOAT_V(mColor.alpha,@"Instance"),
                 LINK_FLOAT_V(m_fFinish,@"finish_Instance"),
                 LINK_FLOAT_V(m_fVelFade,@"Vel"));
    
    ASSIGN_STAGE(@"Destroy",@"DestroySelf:",nil);
    
END_QUEUE(@"Proc");

    m_fVelFade=1.2f;
    m_fFinish=1;

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{

    [super LinkValues];

    m_strNameSound=[NSMutableString stringWithString:@""];
    m_strNameStage=[NSMutableString stringWithString:@""];
    m_strNameObject=[NSMutableString stringWithString:@""];

    SET_CELL(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"));
    SET_CELL(LINK_STRING_V(m_strNameStage,m_strName,@"m_strNameStage"));
    SET_CELL(LINK_STRING_V(m_strNameObject,m_strName,@"m_strNameObject"));

    SET_CELL(LINK_BOOL_V(m_bDimFromTexture,m_strName,@"m_bDimFromTexture"));
    SET_CELL(LINK_BOOL_V(m_bDimMirrorX,m_strName,@"m_bDimMirrorX"));
    SET_CELL(LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY"));

    SET_CELL(LINK_BOOL_V(m_bObTouch,m_strName,@"m_bObTouch"));
    SET_CELL(LINK_BOOL_V(m_bLookTouch,m_strName,@"m_bLookTouch"));

    SET_CELL(LINK_FLOAT_V(m_fFinish,m_strName,@"m_fFinish"));
    SET_CELL(LINK_FLOAT_V(m_fVelFade,m_strName,@"m_fVelFade"));
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

    if(m_bDimFromTexture==YES){GET_DIM_FROM_TEXTURE(m_pNameTexture);}
    
	[super Start];
    
    if(m_bDimMirrorX==YES){m_pCurScale.x=-m_pCurScale.x;}
    if(m_bDimMirrorY==YES){m_pCurScale.y=-m_pCurScale.y;}
    
    mColor.alpha=0;
}
//------------------------------------------------------------------------------------------------------
- (void)HideFade{
    
    SET_STAGE_EX(NAME(self),@"Proc", @"HideStage");
    [self SetTouch:NO];
}
//------------------------------------------------------------------------------------------------------
- (void)PrepareIdle:(ProcStage_ex *)pStage{
    
    m_fFinish=0;
    m_fVelFade=-m_fVelFade;
    if(m_bObTouch==YES)[self SetTouch:YES];
}
//------------------------------------------------------------------------------------------------------
- (void)Move{}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    if(m_bLookTouch==YES)LOCK_TOUCH;
    
    [self HideFade];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    if(m_bLookTouch==YES)LOCK_TOUCH;
    
    OBJECT_PERFORM_SEL(m_strNameObject, m_strNameStage);
    PLAY_SOUND(m_strNameSound);
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT