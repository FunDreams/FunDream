//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectDrunk.h"

@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
	m_iLayer = layerTemplet;

	mWidth  = 50;
	mHeight = 50;

	m_fPhaseX=0;
	m_fPhaseY=0;
	
	m_bHiden=YES;
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)GetParams:(CParams *)Parametrs{
    [super GetParams:Parametrs];
    
    COPY_OUT_INT(m_iCurAlk);
}
//------------------------------------------------------------------------------------------------------
- (void)SetParams:(CParams *)Parametrs{[super SetParams:Parametrs];}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];

	m_bInit=YES;
	
START_PROC(@"Proc");
	UP_SELECTOR(@"e00",@"Idle:");
	UP_SELECTOR(@"e01",@"Proc:");
END_PROC(@"Proc");
	
START_PROC(@"Proc2");
	UP_SELECTOR(@"e00",@"Idle:");
	UP_SELECTOR(@"e01",@"Proc2:");
END_PROC(@"Proc2");
	
START_PROC(@"Proc3");
	UP_SELECTOR(@"e00",@"Idle:");
	UP_SELECTOR(@"e01",@"Action1:");
	UP_SELECTOR(@"t02_10.0",@"timerWaitNextStage:");
	UP_SELECTOR(@"a03",@"Action2:");
	UP_SELECTOR(@"e04",@"Idle:");
END_PROC(@"Proc3");
}
//------------------------------------------------------------------------------------------------------
- (void)Move{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor *)pProc{
	
	float fVel=0;
	
	switch (m_iCurAlk) {
		case 1:
			fVel=0.8f;
			break;
		case 2:
			fVel=1.3f;
			break;
		case 3:
			fVel=2.2f;
			break;
			
		default:
			break;
	}
	
	m_fPhaseX+=fVel*DELTA;
	
	float OffsetX=200*sin(m_fPhaseX);
	
	m_pObjMng->m_pParent->m_vOffset.x=OffsetX;
	
	int tmpStage=[self FindProcByName:@"Proc3"]->m_pICurrentStage;
	if(tmpStage==4 && fabs(OffsetX)<10)
	{
		if(m_bInit && [self FindProcByName:@"Proc2"]->m_pICurrentStage==0)
			m_iCurAlk=0;

		NEXT_STAGE;		
	}
}
//------------------------------------------------------------------------------------------------------
- (void)Proc2:(Processor *)pProc{
	
	float fVel=0;
	
	switch (m_iCurAlk) {
		case 1:
			fVel=1.0f;
			break;
		case 2:
			fVel=1.5f;
			break;
		case 3:
			fVel=2.5f;
			break;
			
		default:
			break;
	}
	m_fPhaseY+=fVel*DELTA;
	
	float OffsetY=200*sin(m_fPhaseY);
	
	m_pObjMng->m_pParent->m_vOffset.y=OffsetY;

	int tmpStage=[self FindProcByName:@"Proc3"]->m_pICurrentStage;
	if(tmpStage==4 && fabs(OffsetY)<10)
	{
		if(m_bInit && [self FindProcByName:@"Proc"]->m_pICurrentStage==0)
			m_iCurAlk=0;

		NEXT_STAGE;
	}
}
//------------------------------------------------------------------------------------------------------
- (void)ActionPrepare:(Processor *)pProc{
	m_iCurAlk=0;
}
//------------------------------------------------------------------------------------------------------
- (void)Action1:(Processor *)pProc{
	
	if(m_bInit){m_iCurAlk=1; m_bInit=NO;}
	else m_iCurAlk++;
	
	if(m_iCurAlk>3)m_iCurAlk=3;
	
	[[self FindProcByName:@"Proc"] SetStage:1];
	[[self FindProcByName:@"Proc2"] SetStage:1];

	OBJECT_SET_PARAMS(@"Score",
                    SET_COLOR(@"mColor",(TmpColor1=Color3DMake(1, 0.3f, 0.3f, 1))),
                      nil);
    
	OBJECT_PERFORM_SEL(@"Score",@"SetColorSym");
	
	NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)Action2:(Processor *)pProc{

	m_bInit=YES;
	
	OBJECT_SET_PARAMS(@"Score",
                      SET_COLOR(@"mColor",(TmpColor1=Color3DMake(1, 1, 1, 1))),
                      nil);
    
	OBJECT_PERFORM_SEL(@"Score",@"SetColorSym");

	NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT