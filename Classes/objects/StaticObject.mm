//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "StaticObject.h"
#import "UniCell.h"

@implementation StaticObject
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        mWidth=60;
        mHeight=60;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimFromTexture,m_strName,@"m_bDimFromTexture")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimMirrorX,m_strName,@"m_bDimMirrorX")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY")];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
    if(m_bDimFromTexture){GET_DIM_FROM_TEXTURE(m_pNameTexture);}

	[super Start];
    
    if(m_bDimMirrorX){m_pCurScale.x=-m_pCurScale.x;}
    if(m_bDimMirrorY){m_pCurScale.y=-m_pCurScale.y;}
}
- (void)sfMove{}
//------------------------------------------------------------------------------------------------------
@end

