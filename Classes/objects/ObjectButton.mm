//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectButton.h"
#import "UniCell.h"

@implementation ObjectButton
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_Disable=false;
        m_iLayer = layerInterfaceSpace5;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{
    mColor.alpha=1;
    m_bHiden=NO;
    
    [m_DOWN setString:@""];
    [m_UP setString:@""];
    [m_strNameSound setString:@""];
    [m_strNameStage setString:@""];
    [m_strNameObject setString:@""];
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimFromTexture,m_strName,@"m_bDimFromTexture")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimMirrorX,m_strName,@"m_bDimMirrorX")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY")];
    
    m_strNameSound=[NSMutableString stringWithString:@""];
    m_strNameStage=[NSMutableString stringWithString:@""];
    m_strNameObject=[NSMutableString stringWithString:@""];
    
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound")];
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_strNameStage,m_strName,@"m_strNameStage")];
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_strNameObject,m_strName,@"m_strNameObject")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bLookTouch,m_strName,@"m_bLookTouch")];

    m_DOWN=[NSMutableString stringWithString:@""];
    m_UP=[NSMutableString stringWithString:@""];
    
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_DOWN,m_strName,@"m_DOWN")];
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_UP,m_strName,@"m_UP")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_Disable,m_strName,@"m_Disable")];
    
    Processor_ex* pProc = [self START_QUEUE:@"Proc"];
    
        ASSIGN_STAGE(@"Idle",@"Idle:",nil);
        
        ASSIGN_STAGE(@"Move",@"AchiveLineFloat:",
                     LINK_FLOAT_V(m_fCurPosSlader,@"Instance"),
                     SET_FLOAT_V(1,@"finish_Instance"),
                     SET_FLOAT_V(1,@"Vel"));
        
        ASSIGN_STAGE(@"e03",@"DestroySelf:",nil);
        ASSIGN_STAGE(@"e04",@"Idle:",nil);
        
        ASSIGN_STAGE(@"e05",@"AchiveLineFloat:",
                     LINK_FLOAT_V(mColor.alpha,@"Instance"),
                     SET_FLOAT_V(0,@"finish_Instance"),
                     SET_FLOAT_V(-1.8f,@"Vel"));
        
        ASSIGN_STAGE(@"e06",@"DestroySelf:",nil);
    
    [self END_QUEUE:pProc name:@"Proc"];
    
    
    pProc = [self START_QUEUE:@"Mirror"];
    
        //   ASSIGN_STAGE(@"Idle",@"Idle:",nil);
        
        ASSIGN_STAGE(@"AchivePoint",@"Mirror2Dvector:",
                     LINK_VECTOR_V(m_vStartPos,@"StartV"),
                     LINK_VECTOR_V(m_vEndPos,@"FinishV"),
                     LINK_VECTOR_V(m_pCurPosition,@"DestV"),
                     SET_FLOAT_V(0,@"StartF"),
                     SET_FLOAT_V(1,@"FinishF"),
                     LINK_FLOAT_V(m_fCurPosSlader2,@"SrcF"));
    
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
	
    if(m_bDimFromTexture){GET_DIM_FROM_TEXTURE(m_DOWN);}
    
	[super Start];
    
    [self SetTouch:YES];

    if(m_bDimMirrorX==YES){m_pCurScale.x=-m_pCurScale.x;}
    if(m_bDimMirrorY==YES){m_pCurScale.y=-m_pCurScale.y;}
    
	m_vStartPos=m_pCurPosition;
	
    m_TextureUP=-1;
    m_TextureDown=-1;
	GET_TEXTURE(m_TextureUP,m_UP);
	GET_TEXTURE(m_TextureDown,m_DOWN);
    
	mTextureId=m_TextureUP;
    
    m_vStartPos=m_pCurPosition;
    m_vEndPos=m_pCurPosition;
    m_vEndPos.y-=1000;
}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    if(m_bLookTouch==YES)LOCK_TOUCH;

	if([[self FindProcByName:@"Proc"]->m_CurStage->NameStage isEqualToString:@"Idle"] && m_Disable==NO)
		mTextureId=m_TextureDown;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    if(m_bLookTouch==YES)LOCK_TOUCH;
    
	if([[self FindProcByName:@"Proc"]->m_CurStage->NameStage isEqualToString:@"Idle"] && m_Disable==NO)
		mTextureId=m_TextureDown;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
//    if(m_bLookTouch==YES)LOCK_TOUCH;

	if([[self FindProcByName:@"Proc"]->m_CurStage->NameStage isEqualToString:@"Idle"] && m_Disable==NO)
		mTextureId=m_TextureUP;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{

    if(m_bLookTouch==YES)LOCK_TOUCH;

	if([[self FindProcByName:@"Proc"]->m_CurStage->NameStage isEqualToString:@"Idle"] && m_Disable==NO)
	{
		mTextureId=m_TextureUP;

        OBJECT_PERFORM_SEL(m_strNameObject, m_strNameStage);
            
        [m_pParent PlaySound:m_strNameSound];
        
   //     NEXT_STAGE_EX(self->m_strName, @"Proc");

        //[[[m_pObjMng GetObjectByName:self->m_strName] FindProcByName:@"Proc"] NextStage];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    
    [self SetTouch:NO];
    [super Destroy];
}
//------------------------------------------------------------------------------------------------------

@end