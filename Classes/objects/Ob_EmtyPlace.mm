//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_EmtyPlace.h"
#import "UniCell.h"
#import "ObjectB_Ob.h"

@implementation Ob_EmtyPlace
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_Disable=false;
        m_iLayer = layerInterfaceSpace4;
        m_iLayerTouch=layerTouch_2N;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{
    mColor.red=1;
    mColor.green=1;
    mColor.blue=1;
    mColor.alpha=1;
    
    m_pOwner=nil;
    
    m_bNotPush=NO;
    m_bHiden=NO;
    m_bPush=NO;
    m_bCheck=NO;

    [m_strNameSound setString:@""];
    [m_strNameStage setString:@""];
    [m_strNameObject setString:@""];

    [m_strNameStageDClick setString:@""];
    [m_strNameObjectDClick setString:@""];
    
    mColorBack = Color3DMake(0, 1, 0, 1);
    m_bBack=NO;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];

    [m_pObjMng->pMegaTree SetCell:LINK_COLOR_V(mColorBack,m_strName,@"mColorBack")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bBack,m_strName,@"m_bBack")];

    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bNotPush,m_strName,@"m_bNotPush")];

    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimFromTexture,m_strName,@"m_bDimFromTexture")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimMirrorX,m_strName,@"m_bDimMirrorX")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY")];
    
    m_strNameSound=[NSMutableString stringWithString:@""];
    m_strNameStage=[NSMutableString stringWithString:@""];
    m_strNameObject=[NSMutableString stringWithString:@""];

    m_strNameStageDClick=[NSMutableString stringWithString:@""];
    m_strNameObjectDClick=[NSMutableString stringWithString:@""];

    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound")];
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_strNameStage,m_strName,@"m_strNameStage")];
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_strNameObject,m_strName,@"m_strNameObject")];
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_strNameStageDClick,m_strName,@"m_strNameStageDClick")];
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_strNameObjectDClick,m_strName,@"m_strNameObjectDClick")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bLookTouch,m_strName,@"m_bLookTouch")];

    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_Disable,m_strName,@"m_Disable")];

//    pProc = [self START_QUEUE:@"Proc"];
//    
//        ASSIGN_STAGE(@"Idle",@"Proc:",nil);
//    
//    [self END_QUEUE:pProc name:@"Proc"];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
	
    if(m_bDimFromTexture){GET_DIM_FROM_TEXTURE(m_pNameTexture);}
    
	[super Start];
    [self SetTouch:YES];

    if(m_bDimMirrorX==YES){m_pCurScale.x=-m_pCurScale.x;}
    if(m_bDimMirrorY==YES){m_pCurScale.y=-m_pCurScale.y;}

	m_vStartPos=m_pCurPosition;
	
    
    m_vStartPos=m_pCurPosition;
    m_vEndPos=m_pCurPosition;
    m_vEndPos.y-=1000;
}
//------------------------------------------------------------------------------------------------------
- (void)SetUnPush{
    
    m_bPush=NO;
    
    mColor.green=1;
    mColor.blue=1;

}
//------------------------------------------------------------------------------------------------------
- (void)SetPush{

    m_bPush=YES;
    
    mColor.green=0;
    mColor.blue=0;
}
//------------------------------------------------------------------------------------------------------
- (void)DoubleTouch:(Processor_ex *)pProc{
    
    m_bDoubleTouch=NO;
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    [self SetPush];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    [self SetUnPush];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{

     pOb = GET_ID_V(@"DragObject");
    
    if(pOb!=nil){
        
        [m_pObjMng->pMegaTree SetCell:(LINK_ID_V(self,@"EmptyPlace"))];

        OBJECT_PERFORM_SEL(NAME(pOb), @"SetPlace");
    }
    
    [self SetUnPush];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEndedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    [self SetUnPush];
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    
    [self SetTouch:NO];
    [super Destroy];
}
//------------------------------------------------------------------------------------------------------

@end