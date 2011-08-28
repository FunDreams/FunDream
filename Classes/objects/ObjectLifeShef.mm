//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectLifeShef.h"

@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
	m_iLayer = layerInterfaceSpace5;

	mWidth  = 80;
	mHeight = 80;

    LOAD_SOUND(iIdSound, @"record.wav", NO);
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)GetParams:(CParams *)Parametrs{[super GetParams:Parametrs];}
//------------------------------------------------------------------------------------------------------
- (void)SetParams:(CParams *)Parametrs{
	[super SetParams:Parametrs];
	
	COPY_IN_VECTOR(m_vStart);
	COPY_IN_VECTOR(m_vEnd);
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
	
	[super Start];

	LOAD_TEXTURE(mTextureId,@"live.png");

	[m_pObjMng AddToGroup:@"life" Object:self];

	START_PROC(@"Proc");
	
	UP_POINT(@"p00_v_Instance",&m_pCurPosition);
	UP_CONST_FLOAT(@"p00_f_Vel",200);
	UP_VECTOR(@"p00_v_Start",&m_vStart);
	UP_VECTOR(@"p00_v_Finish",&m_vEnd);
	UP_SELECTOR(@"e00",@"Achive2DvectorStatic:");
	
	UP_SELECTOR(@"e01",@"Idle:");
	
	UP_POINT(@"p02_v_Instance",&m_pCurPosition);
	UP_CONST_FLOAT(@"p02_f_Vel",300);
	UP_VECTOR(@"p02_v_Start",&m_vEnd);
	UP_VECTOR(@"p02_v_Finish",&m_vStart);
	UP_SELECTOR(@"e02",@"Achive2DvectorStatic:");

	UP_SELECTOR(@"e03",@"Proc:");

	UP_SELECTOR(@"e04",@"DestroySelfUpdate:");

	END_PROC(@"Proc");
}
//------------------------------------------------------------------------------------------------------
- (void)Move{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor *)pProc{
	
	if(m_strName==@"life1"){
        
        bool bRecord = GET_BOOL(@"GameShef", @"m_bNewRecord");
        
        if(bRecord){
            
            PLAY_SOUND(iIdSound);
            
            CREATE_NEW_OBJECT(@"ObjectDynamicObject",@"BestSplash",
                              SET_STRING(@"m_pNameTexture",@"newbest.png"),
                              SET_BOOL(@"m_bNoOffset",YES),
                              SET_FLOAT(@"mWidth", 150),
                              SET_FLOAT(@"mHeight", 150),
                              nil);
        }
        else {
            CREATE_NEW_OBJECT(@"ObjectDynamicObject",@"GameOver",
                              SET_STRING(@"m_pNameTexture",@"GameOver.png"),
                              SET_BOOL(@"m_bNoOffset",YES),
                              SET_FLOAT(@"mWidth", 600),
                              SET_FLOAT(@"mHeight", 200),
                              nil);
        }
	}
	
	NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT