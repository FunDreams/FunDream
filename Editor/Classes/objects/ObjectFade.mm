//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectFade.h"
#import "UniCell.h"

@implementation ObjectFade
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        mWidth  = 50;
        mHeight = 50;

        m_iLayer = layerInvisible;
            
        m_fVelFade=1.2f;
        m_fFinish=1;
        m_fStartAlpha=0;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{
    m_bHiden=NO;
    m_fVelFade=1.2f;
    m_fFinish=1;
    m_fStartAlpha=0;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{

    [super LinkValues];

    m_strNameSound=[NSMutableString stringWithString:@""];
    m_strNameStage=[NSMutableString stringWithString:@""];
    m_strNameObject=[NSMutableString stringWithString:@""];

    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound")];
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_strNameStage,m_strName,@"m_strNameStage")];
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_strNameObject,m_strName,@"m_strNameObject")];

    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimFromTexture,m_strName,@"m_bDimFromTexture")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimMirrorX,m_strName,@"m_bDimMirrorX")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY")];

    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bObTouch,m_strName,@"m_bObTouch")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bLookTouch,m_strName,@"m_bLookTouch")];

    [m_pObjMng->pMegaTree SetCell:LINK_FLOAT_V(m_fFinish,m_strName,@"m_fFinish")];
    [m_pObjMng->pMegaTree SetCell:LINK_FLOAT_V(m_fVelFade,m_strName,@"m_fVelFade")];

    [m_pObjMng->pMegaTree SetCell:LINK_FLOAT_V(m_fStartAlpha,m_strName,@"m_fStartAlpha")];
    
    
    Processor_ex* pProc = [self START_QUEUE:@"Proc"];
    
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
    
    [self END_QUEUE:pProc name:@"Proc"];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

    if(m_bDimFromTexture==YES){GET_DIM_FROM_TEXTURE(m_pNameTexture);}
    
	[super Start];
    
    if(m_bDimMirrorX==YES){m_pCurScale.x=-m_pCurScale.x;}
    if(m_bDimMirrorY==YES){m_pCurScale.y=-m_pCurScale.y;}
    
    mColor.alpha=m_fStartAlpha;
    
    SET_STAGE(NAME(self), @"ShowStage");
    [self SetTouch:NO];
}
//------------------------------------------------------------------------------------------------------
- (void)ShowFade{
    
    mColor.alpha=0;
    SET_STAGE_EX(self->m_strName,@"Proc", @"ShowStage");
    [self SetTouch:NO];
}
//------------------------------------------------------------------------------------------------------
- (void)HideFade{
    
    SET_STAGE_EX(self->m_strName,@"Proc", @"HideStage");
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
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    if(m_bLookTouch==YES)LOCK_TOUCH;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    if(m_bLookTouch==YES)LOCK_TOUCH;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    if(m_bLookTouch==YES)LOCK_TOUCH;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesBeganOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    if(m_bLookTouch==YES)LOCK_TOUCH;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    if(m_bLookTouch==YES)LOCK_TOUCH;
    
    if(![m_strNameObject isEqual:@""]){
        
        [self HideFade];
        [self OBJECT_PERFORM_SEL:m_strNameObject selector:m_strNameStage];
    }
    
    [m_pParent PlaySound:m_strNameSound];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEndedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    if(m_bLookTouch==YES)LOCK_TOUCH;
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[self SetTouch:NO];}
@end
