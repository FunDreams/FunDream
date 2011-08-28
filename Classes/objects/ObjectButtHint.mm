//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectButtHint.h"

@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
	m_iLayer = layerInterfaceSpace3;
//    m_fAlpha2=0.0f;
    Phase=0;

START_PROC(@"Proc");
    
    UP_POINT(@"p1_f_Instance",&m_fAlpha2);
	UP_CONST_FLOAT(@"f1_f_Instance",0.9f);
	UP_CONST_FLOAT(@"s1_f_Instance",0);
	UP_CONST_FLOAT(@"s1_f_vel",5);
	UP_SELECTOR(@"e1",@"AchiveLineFloat:");

    UP_SELECTOR(@"e2",@"TouchYes:");
    UP_SELECTOR(@"e3",@"Action:");
    UP_SELECTOR(@"e4",@"Flare:");

    UP_POINT(@"p5_f_Instance",&m_fAlpha2);
	UP_CONST_FLOAT(@"f5_f_Instance",0);
//	UP_CONST_FLOAT(@"s5_f_Instance",1);
	UP_CONST_FLOAT(@"s5_f_vel",-5);
	UP_SELECTOR(@"e5",@"AchiveLineFloat:");

END_PROC(@"Proc");
    
    LOAD_TEXTURE(mTextureId,@"hint_1.png");
    LOAD_TEXTURE(mTextureId2,@"hint_2.png");

    LOAD_SOUND(iIdSound,@"hint.wav",NO);
    LOAD_SOUND(iIdSound1,@"click_hint.wav",NO);

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)GetParams:(CParams *)Parametrs{[super GetParams:Parametrs];}
//------------------------------------------------------------------------------------------------------
- (void)SetParams:(CParams *)Parametrs{[super SetParams:Parametrs];}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
	[super Start];
    [self Enable];
}
//------------------------------------------------------------------------------------------------------
- (void)Disable{
    
START_PROC(@"Proc");
    
    [self SetTouch:NO];
 //   m_fAlpha2=0;
    UP_SELECTOR(@"e0",@"Idle:");

END_PROC(@"Proc");
    
    SET_STAGE_EX(@"Hint", @"Proc", 5);
}
//------------------------------------------------------------------------------------------------------
- (void)Enable{
    
    int oldStage=0;

START_PROC(@"Proc");
    oldStage=pProc->m_pICurrentStage;
    UP_TIMER(0,1,600000,@"timerWaitNextStage:");
END_PROC(@"Proc");
    
    SET_STAGE_EX(NAME(self), @"Proc", oldStage);
}
//------------------------------------------------------------------------------------------------------
- (void)Move{}
//------------------------------------------------------------------------------------------------------
- (void)Action:(Processor *)pProc{
    PLAY_SOUND(iIdSound);
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)Flare:(Processor *)pProc{
    
    Phase+=DELTA*2;
    m_fAlpha2=0.9f+0.1*sin(Phase);
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    [self SetTouch:NO];
    Phase=0;
    SET_STAGE_EX(NAME(self), @"Proc", 5);
    OBJECT_PERFORM_SEL(@"Field", @"Hint");
    
    PLAY_SOUND(iIdSound1)
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{[super dealloc];}
//------------------------------------------------------------------------------------------------------
- (void)SelfDrawOffset{
	
	[self SetColor:mColor];
    
	glVertexPointer(3, GL_FLOAT, 0, vertices);
    glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
   	
	glBindTexture(GL_TEXTURE_2D, mTextureId);
	
	glTranslatef(m_pCurPosition.x+m_pObjMng->m_pParent->m_vOffset.x,
				 m_pCurPosition.y+m_pObjMng->m_pParent->m_vOffset.y,
				 m_pCurPosition.z);
	
	glRotatef(m_pCurAngle.z, 0, 0, 1);
	glScalef(m_pCurScale.x,m_pCurScale.y,m_pCurScale.z);
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
    
    mColor.alpha=m_fAlpha2;
    [self SetColor:mColor];

    glBindTexture(GL_TEXTURE_2D, mTextureId2);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
    mColor.alpha=1;
}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT