//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ButtonGhost.h"

@implementation ButtonGhost
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
	m_Disable=false;
    
    m_iLayer = layerInterfaceSpace3;
//    m_iLayerTouch=layerOb3;

    LOAD_SOUND(iIdSound,@"click_phantom.wav",NO);

    LOAD_SOUND(iIdYes,@"correct.wav",NO);
    LOAD_SOUND(iIdNo,@"not_correct.wav",NO);

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)GetParams:(CParams *)Parametrs{[super GetParams:Parametrs];}
//------------------------------------------------------------------------------------------------------
- (void)SetParams:(CParams *)Parametrs{
	[super SetParams:Parametrs];

	COPY_IN_STRING(m_UP);
	COPY_IN_BOOL(m_Disable);
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
	
	[super Start];

	m_vStartPos=m_pCurPosition;
	[self Move];
	
    m_TextureUP=-1;
	LOAD_TEXTURE(m_TextureUP,m_UP);

	mTextureId=m_TextureUP;

    m_vStartPos=m_pCurPosition;
    m_vEndPos=m_pCurPosition;
    
    
    if(NAME(self)==@"NButtonGhost"){[self SetTouch:YES];}

    if(NAME(self)==@"NButtonNO"){m_vEndPos.x-=45*FACTOR_DEC;}
    if(NAME(self)==@"NButtonYES"){m_vEndPos.x+=45*FACTOR_DEC;}

START_PROC(@"Proc");
		
	UP_SELECTOR(@"e03",@"Idle:");
	
    UP_SELECTOR(@"e04",@"TouchNo:");

	UP_POINT(@"p05_f_Instance",&mColor.alpha);
	UP_CONST_FLOAT(@"f05_f_Instance",0);
	UP_CONST_FLOAT(@"s05_f_vel",-5.0f);
	UP_SELECTOR(@"e05",@"AchiveLineFloat:");
	
	UP_SELECTOR(@"e06",@"HideSelf:");
    
    UP_SELECTOR(@"e07",@"Idle:");
    
    UP_SELECTOR(@"e08",@"ShowSelfEx:");

    UP_POINT(@"p09_f_Instance",&mColor.alpha);
	UP_CONST_FLOAT(@"f09_f_Instance",1);
	UP_CONST_FLOAT(@"s09_f_vel",5.0f);
	UP_SELECTOR(@"e09",@"AchiveLineFloat:");

    UP_SELECTOR(@"e10",@"TouchYes:");

	UP_SELECTOR(@"e11",@"Idle:");
	
END_PROC(@"Proc");
    
START_PROC(@"MirrorVector");
    UP_SELECTOR(@"e00",@"Mirror2DvectorStatic:");
    
    UP_POINT(@"p00_f_SrcF",&mColor.alpha);
    UP_POINT(@"p00_v_DestV",&m_pCurPosition);
    UP_CONST_FLOAT(@"p00_f_StartF",0);
    UP_CONST_FLOAT(@"p00_f_FinishF",1);
    UP_VECTOR(@"p00_v_StartV",&m_vStartPos);
    UP_VECTOR(@"p00_v_FinishV",&m_vEndPos);
    
    UP_SELECTOR(@"e01",@"Idle:");
END_PROC(@"MirrorVector");

}
//------------------------------------------------------------------------------------------------------
- (void)ShowSelfEx:(Processor *)pProc{
    
    if(m_strName==@"NButtonYES"){PLAY_SOUND(iIdSound);}
    
    m_bHiden=NO;
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)Move{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor *)pProc{}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
-(void)PushGhost{
    SET_STAGE(NAME(self), 4);
    
    CREATE_NEW_OBJECT(@"ButtonGhost",@"NButtonNO",
                      SET_COLOR(@"mColor",(TmpColor1=Color3DMake(1, 1, 1, 0.0f))),
                      SET_STRING(@"m_UP",@"no.png"),
                      SET_VECTOR(@"m_pCurPosition",(TmpVector1=m_pCurPosition)),
                      SET_FLOAT(@"mWidth",85*FACTOR_DEC),
                      SET_FLOAT(@"mHeight",85),
                      SET_BOOL(@"m_bHiden",NO),
                      nil);
    
    SET_STAGE(@"NButtonNO", 8);
    
    CREATE_NEW_OBJECT(@"ButtonGhost",@"NButtonYES",
                      SET_COLOR(@"mColor",(TmpColor1=Color3DMake(1,1,1,0.0f))),
                      SET_STRING(@"m_UP",@"yes.png"),
                      SET_VECTOR(@"m_pCurPosition",(TmpVector1=m_pCurPosition)),
                      SET_FLOAT(@"mWidth",85*FACTOR_DEC),
                      SET_FLOAT(@"mHeight",85),
                      SET_BOOL(@"m_bHiden",NO),
                      nil);
    
    SET_STAGE(@"NButtonYES", 8);
    
    OBJECT_SET_PARAMS(@"Field",SET_BOOL(@"m_bGhost",YES),nil);
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{

    LOCK_TOUCH;
    
//    [self SetTouch:NO];

    if(m_strName==@"NButtonGhost"){

        PARAMS_APP->bGhost=YES;
        [self PushGhost];
    }
    
    if(m_strName==@"NButtonNO"){
        
        PLAY_SOUND(iIdNo);
        
        SET_STAGE(@"NButtonNO", 4);
        SET_STAGE(@"NButtonYES", 4);

        SET_STAGE(@"NButtonGhost", 8);
        
        OBJECT_SET_PARAMS(@"Field", SET_BOOL(@"m_bGhost", NO),nil);
        
        OBJECT_PERFORM_SEL(@"Field", @"GhostNO");
        
        PARAMS_APP->bGhost=NO;
    }
    if(m_strName==@"NButtonYES"){
        
        PLAY_SOUND(iIdYes);

        SET_STAGE(@"NButtonNO", 4);
        SET_STAGE(@"NButtonYES", 4);
        
        SET_STAGE(@"NButtonGhost", 8);
        
        OBJECT_SET_PARAMS(@"Field", SET_BOOL(@"m_bGhost", NO),nil);
        
        OBJECT_PERFORM_SEL(@"Field", @"GhostYES");
        
        PARAMS_APP->bGhost=NO;
    }
    
    UPDATE;
//    SAVE;
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end