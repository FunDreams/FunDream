//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "StaticObject.h"

@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
    mWidth=60;
    mHeight=60;
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    SET_CELL(LINK_BOOL_V(m_bDimFromTexture,m_strName,@"m_bDimFromTexture"));
    SET_CELL(LINK_BOOL_V(m_bDimMirrorX,m_strName,@"m_bDimMirrorX"));
    SET_CELL(LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY"));
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
    if(m_bDimFromTexture){GET_DIM_FROM_TEXTURE(m_pNameTexture);}

	[super Start];
    
    if(m_bDimMirrorX){m_pCurScale.x=-m_pCurScale.x;}
    if(m_bDimMirrorY){m_pCurScale.y=-m_pCurScale.y;}
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//------------------------------------------------------------------------------------------------------
- (void)sfMove{}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT

