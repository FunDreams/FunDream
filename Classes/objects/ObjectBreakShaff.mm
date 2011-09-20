//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectBreakShaff.h"
#import "ObjectStaff.h"

@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
	m_iLayer = layerTemplet;

	mWidth  = 50;
	mHeight = 50;
	
	for (int i=0; i<4; i++) {
		
		NSString *pstr=[NSString stringWithFormat:@"koktel_a%d.png", i+1];
		
		UInt32 TmpIdTexture=-1;
		LOAD_TEXTURE(TmpIdTexture,pstr);
		
		[m_pArrayImages addObject:[NSNumber numberWithInt:TmpIdTexture]];
	}
	for (int i=0; i<4; i++) {
		
		NSString *pstr=[NSString stringWithFormat:@"bread_a%d.png", i+1];
		
		UInt32 TmpIdTexture=-1;
		LOAD_TEXTURE(TmpIdTexture,pstr);
		
		[m_pArrayImages addObject:[NSNumber numberWithInt:TmpIdTexture]];
	}
	for (int i=0; i<4; i++) {
		
		NSString *pstr=[NSString stringWithFormat:@"carrot_a%d.png", i+1];
		
		UInt32 TmpIdTexture=-1;
		LOAD_TEXTURE(TmpIdTexture,pstr);
		
		[m_pArrayImages addObject:[NSNumber numberWithInt:TmpIdTexture]];
	}
	for (int i=0; i<4; i++) {
		
		NSString *pstr=[NSString stringWithFormat:@"break_a%d.png", i+1];
		
		UInt32 TmpIdTexture=-1;
		LOAD_TEXTURE(TmpIdTexture,pstr);
		
		[m_pArrayImages addObject:[NSNumber numberWithInt:TmpIdTexture]];
	}	
	for (int i=0; i<4; i++) {
		
		NSString *pstr=[NSString stringWithFormat:@"Tarelka_a%d.png", i+1];
		
		UInt32 TmpIdTexture=-1;
		LOAD_TEXTURE(TmpIdTexture,pstr);
		
		[m_pArrayImages addObject:[NSNumber numberWithInt:TmpIdTexture]];
	}
	
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)GetParams:(CParams *)Parametrs{[super GetParams:Parametrs];}
//------------------------------------------------------------------------------------------------------
- (void)SetParams:(CParams *)Parametrs{
	[super SetParams:Parametrs];
	COPY_IN_INT(iType);
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];

	mTextureId = [(NSNumber *)[m_pArrayImages objectAtIndex:4*iType] intValue];

	START_PROC(@"Proc");
	
	UP_POINT(@"p00_i_Frame",&mTextureId);
	UP_CONST_INT(@"p00_i_Direct",1);
	UP_SELECTOR(@"t00_0.07",@"Animate:");
	
	UP_CONST_INT(@"s00_i_Frame",mTextureId);
	UP_CONST_INT(@"f00_i_Frame",mTextureId+3);
	
	UP_POINT(@"p01_f_Instance",&mColor.alpha);
	UP_CONST_FLOAT(@"s01_f_Instance",1);
	UP_CONST_FLOAT(@"f01_f_Instance",0.5f);
	UP_CONST_FLOAT(@"s01_f_vel",-0.8);
	UP_SELECTOR(@"e01",@"AchiveLineFloat:");

	UP_POINT(@"p02_f_Instance",&m_pCurPosition.x);
	UP_CONST_FLOAT(@"f02_f_Instance",-1000);
	UP_CONST_FLOAT(@"s02_f_vel",-1300.0f+(float)(RND%500+300));
	UP_SELECTOR(@"e02",@"AchiveLineFloat:");

	UP_SELECTOR(@"e03",@"DestroySelf:");
	
	END_PROC(@"Proc");
}
//------------------------------------------------------------------------------------------------------
- (void)Move{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor *)pProc{}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT