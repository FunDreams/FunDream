//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectSymbol.h"

@implementation ObjectSymbol
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
	m_iLayer = layerInterfaceSpace5;

	mWidth  = 50;
	mHeight = 50;

	m_fSpeedScale = 4+(float)(RND%20+20)*0.1f;
	m_fPhase=0;
    m_fOffsetPosYTmp=0;
	
START_QUEUE(@"Move");
    ASSIGN_STAGE(@"Move",@"Move:",nil);
END_QUEUE(@"Move");

START_QUEUE(@"Proc");
	ASSIGN_STAGE(@"Idle",@"Idle:", nil);

    ASSIGN_STAGE(@"ScaleWave",@"ScaleWave:", nil);

    ASSIGN_STAGE(@"Jump",@"Jump:", nil);
    
    ASSIGN_STAGE(@"Fall",@"Fall:", nil);

END_QUEUE(@"Proc");

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    
    m_strStartStage=[NSMutableString stringWithString:@"Animate"];
    SET_CELL(LINK_STRING_V(m_strStartStage,m_strName,@"m_strStartStage"));

    SET_CELL(LINK_INT_V(m_iCurrentSym,m_strName,@"m_iCurrentSym"));

    m_strNextStage=[NSMutableString stringWithString:@"Animate"];
    SET_CELL(LINK_STRING_V(m_strNextStage,m_strName,@"m_strNextStage"));
}
//------------------------------------------------------------------------------------------------------
- (void)Update{
    [self SetPosWithOffsetOwner];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
	
	[super Start];
    
    GET_TEXTURE(m_iStartTexture,m_pNameTexture);
    mTextureId = m_iStartTexture;
    [m_strNextStage setString:@""];
}
//------------------------------------------------------------------------------------------------------
- (void)Move:(Processor_ex *)pProc{
    
    [self Update];

    mTextureId = m_iStartTexture+m_iCurrentSym;
    m_pCurPosition.y+=m_fOffsetPosYTmp;
}
//------------------------------------------------------------------------------------------------------
- (void)Jump:(Processor_ex *)pProc{
    
    m_fPhase+=DELTA*m_fSpeedScale;
    float OffsetRotate=5.0f*sin(m_fPhase/2);
    m_pCurAngle.z=OffsetRotate;
    
    m_fOffsetPosYTmp=10*sin(m_fPhase);
    float OffsetScale=-5*sin(m_fPhase);
    
    m_pCurScale.x=mWidth*0.5f+OffsetScale;
    m_pCurScale.y=mHeight*0.5f-OffsetScale;		
    
    if([m_strNextStage length]>0 && fabs(OffsetScale)<0.45){
        
        SET_STAGE_EX(NAME(self), @"Proc", m_strNextStage);
        [m_strNextStage setString:@""];
        m_fPhase=0;
        m_fOffsetPosYTmp=0;
        m_pCurAngle.z=0;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)ScaleWave:(Processor_ex *)pProc{
    
    m_fPhase+=DELTA*m_fSpeedScale;
	
	float OffsetScale=sin(m_fPhase);
	
	m_pCurScale.x=mWidth*0.5f+OffsetScale;
	m_pCurScale.y=mHeight*0.5f+OffsetScale;
    
    if([m_strNextStage length]>0 && fabs(OffsetScale)<0.1){
        
        SET_STAGE_EX(NAME(self), @"Proc", m_strNextStage);
        [m_strNextStage setString:@""];
        m_fPhase=0;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)PrepareFall:(Processor_ex *)pProc{
    
    m_fRotateVel=RND%400;
    m_Vvelosity=Vector3DMake(0,(float)(RND%200)-100,0);
    m_pOwner=nil;
}
//------------------------------------------------------------------------------------------------------
- (void)Fall:(Processor_ex *)pProc{
    
    m_Vvelosity.y-=DELTA*1000;
    m_pCurAngle.z+=DELTA*m_fRotateVel;
    
    m_pCurPosition.x+=DELTA*m_Vvelosity.x;
    m_pCurPosition.y+=DELTA*m_Vvelosity.y;
    
    if(m_pCurPosition.y<-700){
        DESTROY_OBJECT(self);
        SET_STAGE_EX(NAME(self), @"Proc", @"Idle");
    }
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end