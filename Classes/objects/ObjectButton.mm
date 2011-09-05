//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectButton.h"

@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
	m_Disable=false;
	m_iLayer = layerInterfaceSpace5;

	[self SetTouch:YES];
    
    m_DOWN=[NSMutableString stringWithString:@""];
    m_UP=[NSMutableString stringWithString:@""];

    SET_CELL(LINK_STRING_V(m_DOWN,m_strName,@"m_DOWN"));
    SET_CELL(LINK_STRING_V(m_UP,m_strName,@"m_UP"));
    SET_CELL(LINK_BOOL_V(m_Disable,m_strName,@"m_Disable"));

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
	
	[super Start];

	m_vStartPos=m_pCurPosition;
	
    m_TextureUP=-1;
    m_TextureDown=-1;
	GET_TEXTURE(m_TextureUP,m_UP);
	GET_TEXTURE(m_TextureDown,m_DOWN);

	mTextureId=m_TextureUP;

START_QUEUE(@"Proc");

    ASSIGN_STAGE(@"e01",@"Idle:",nil);

    ASSIGN_STAGE(@"e02",@"AchiveLineFloat:",
                 LINK_FLOAT_V(m_pCurPosition.y,@"Instance"),
                 SET_FLOAT_V(m_pCurPosition.y-960,@"finish_Instance"),
                 SET_FLOAT_V(-1000,@"Vel"));

	ASSIGN_STAGE(@"e03",@"DestroySelf:",nil);
    ASSIGN_STAGE(@"e04",@"Idle:",nil);

	mColor.alpha=1;
    
    ASSIGN_STAGE(@"e05",@"AchiveLineFloat:",
                 LINK_FLOAT_V(mColor.alpha,@"Instance"),
                 SET_FLOAT_V(0,@"finish_Instance"),
                 SET_FLOAT_V(-1.8f,@"Vel"));
    
    ASSIGN_STAGE(@"e06",@"DestroySelf:",nil);

END_QUEUE(@"Proc");
}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    NSString *Str= GET_STAGE_EX(NAME(self),@"Proc");
	if(Str==@"e01" && m_Disable==NO)
		mTextureId=m_TextureDown;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    NSString *Str= GET_STAGE_EX(NAME(self),@"Proc");
	if(Str==@"e01" && m_Disable==NO)
		mTextureId=m_TextureDown;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    NSString *Str= GET_STAGE_EX(NAME(self),@"Proc");
	if(Str==@"e01" && m_Disable==NO)
		mTextureId=m_TextureUP;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{

    NSString *Str= GET_STAGE_EX(NAME(self),@"Proc");

	if(Str==@"e01" && m_Disable==NO)
	{
		PLAY_SOUND(@"PushButton.wav");
 //       STOP_SOUND(@"PushButton.wav");

		mTextureId=m_TextureUP;

        if([m_strName isEqualToString:@"ButtonPlay"]){

			[[self FindProcByName:@"Proc"] NextStage];

			[[[m_pObjMng GetObjectByName:@"Cup"] FindProcByName:@"Proc"] NextStage];
		}
    }
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT