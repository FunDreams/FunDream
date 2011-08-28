//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectSymbol.h"

@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
	m_iLayer = layerInterfaceSpace5;
	
	for (int i=0; i<11; i++) {
			
		NSString *pstr;
		
		if (i==10) pstr=[NSString stringWithFormat:@"n_c.png"];
		else pstr=[NSString stringWithFormat:@"n_%d.png", i];
		
		UInt32 TmpIdTexture=-1;
		LOAD_TEXTURE(TmpIdTexture,pstr);
		
		[m_pArrayImages addObject:[NSNumber numberWithInt:TmpIdTexture]];
	}
		
	mWidth  = 50;
	mHeight = 50;

	m_fSpeedScale = 4+(float)(RND%20+20)*0.1f;
	m_fPhase=0;
    m_fOffsetPosYTmp=0;
	
START_PROC(@"Proc");
	UP_SELECTOR(@"e01",@"Idle:");
	UP_SELECTOR(@"e02",@"ScaleWave:");

	UP_SELECTOR(@"e03",@"Jump:");
    
    UP_SELECTOR(@"a04",@"InitFall:");
    UP_SELECTOR(@"e05",@"Fall:");

END_PROC(@"Proc");

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)GetParams:(CParams *)Parametrs{
	[super GetParams:Parametrs];
	
	COPY_OUT_INT(m_iCurrentSym);
}
//------------------------------------------------------------------------------------------------------
- (void)SetParams:(CParams *)Parametrs{
	[super SetParams:Parametrs];
	
	COPY_IN_INT(m_iCurrentSym);
    COPY_IN_INT(m_iNextStage);
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
	
	[super Start];
	mTextureId = [[m_pArrayImages objectAtIndex:m_iCurrentSym] intValue];
}
//------------------------------------------------------------------------------------------------------
- (void)Move{
	mTextureId = [[m_pArrayImages objectAtIndex:m_iCurrentSym] intValue];
    
  [self SetPosWithOffsetOwner];
   m_pCurPosition.y+=m_fOffsetPosYTmp;
}
//------------------------------------------------------------------------------------------------------
- (void)Jump:(Processor *)pProc{
    
    m_fPhase+=DELTA*m_fSpeedScale;
    float OffsetRotate=5.0f*sin(m_fPhase/2);
    m_pCurAngle.z=OffsetRotate;
    
    m_fOffsetPosYTmp=10*sin(m_fPhase);
    float OffsetScale=-5*sin(m_fPhase);
    
    m_pCurScale.x=mWidth*0.5f+OffsetScale;
    m_pCurScale.y=mHeight*0.5f-OffsetScale;		

    if(m_iNextStage!=0 && fabs(OffsetScale)<0.45){
        SET_STAGE_EX(NAME(self), @"Proc", m_iNextStage);
        m_iNextStage=0;
        m_fPhase=0;
        m_fOffsetPosYTmp=0;
        m_pCurAngle.z=0;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)ScaleWave:(Processor *)pProc{
    
    m_fPhase+=DELTA*m_fSpeedScale;
	
	float OffsetScale=sin(m_fPhase);
	
	m_pCurScale.x=mWidth*0.5f+OffsetScale;
	m_pCurScale.y=mHeight*0.5f+OffsetScale;
    
    if(m_iNextStage!=0 && fabs(OffsetScale)<0.1){
        SET_STAGE_EX(NAME(self), @"Proc", m_iNextStage);
        m_iNextStage=0;
        m_fPhase=0;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)InitFall:(Processor *)pProc{
    
    m_fRotateVel=RND%400;
    m_Vvelosity=Vector3DMake(0,(float)(RND%200)-100,0);
    m_pOwner=nil;
    
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)Fall:(Processor *)pProc{
    
    m_Vvelosity.y-=DELTA*1000;
    m_pCurAngle.z+=DELTA*m_fRotateVel;
    
    m_pCurPosition.x+=DELTA*m_Vvelosity.x;
    m_pCurPosition.y+=DELTA*m_Vvelosity.y;
    
    if(m_pCurPosition.y<-500){
        DESTROY_OBJECT(self);
        SET_STAGE_EX(NAME(self), @"Proc", 0);
    }
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT