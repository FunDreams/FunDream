//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectAlNumber.h"

#define PLACEPER 40
@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
		
	m_iLayer = layerNumber;
	
	for (int i=0; i<10; i++) {
		for (int j=0; j<10; j++) {
			
			NSString *pstr=nil;
			
			if(j==9)
				pstr=[NSString stringWithFormat:@"%d-%d@2x.png", i,j+1];
			else pstr=[NSString stringWithFormat:@"%d-0%d@2x.png", i,j+1];
			
			UInt32 TmpIdTexture=-1;
			GET_TEXTURE(TmpIdTexture,pstr);
			
			[m_pArrayImages addObject:[NSNumber numberWithInt:TmpIdTexture]];
		}
	}
	
	mWidth=50;
	mHeight=92;
//====================================================
START_QUEUE(@"Move");
    ASSIGN_STAGE(@"Move", @"Move:", nil);
END_QUEUE(@"Move");

START_QUEUE(@"Proc");

    ASSIGN_STAGE(@"Idle",@"Idle:",nil);

    ASSIGN_STAGE(@"a10",@"timerWaitNextStage:",nil);
    DELAY_STAGE(@"a10", 1000, 1);

    ASSIGN_STAGE(@"Animate1",@"Animate:",
                 LINK_INT_V(iFinishFrame,@"Finish_Frame"),
                 LINK_INT_V(mTextureId,@"InstFrame"),
                 LINK_FLOAT_V(InstFrameFloat,@"InstFrameFloat"),
                 SET_FLOAT_V(-30,@"Vel"));

    ASSIGN_STAGE(@"ChangePar",@"ChangePar:",nil);
    DELAY_STAGE(@"ChangePar", 3000, 4000);

    ASSIGN_STAGE(@"Animate2",@"Animate:",
                 LINK_INT_V(iFinishFrame,@"Finish_Frame"),
                 LINK_INT_V(mTextureId,@"InstFrame"),
                 LINK_FLOAT_V(InstFrameFloat,@"InstFrameFloat"),
                 SET_FLOAT_V(30,@"Vel"));

	ASSIGN_STAGE(@"FinishQueue",@"FinishQueue:",nil); 

END_QUEUE(@"Proc");
//====================================================
	
	mColor = Color3DMake(1,1,0,1.0f);

    SET_CELL(LINK_INT_V(m_iCurrenNumber,m_strName,@"m_iCurrenNumber"));
    SET_CELL(LINK_INT_V(m_iPlace,m_strName,@"m_iPlace"));

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
	
	[super Start];
	
	m_fSpeedScale = 6+(RND%2-1);
	m_fPhase=RND%10;

	[self Move:nil];

	m_pCurPosition.x=-284+m_iPlace%15*PLACEPER;
	m_pCurPosition.y=428-m_iPlace/15*(PLACEPER+18);
	
	m_iCurrentFrame=9;
	mTextureId = [(NSNumber *)[m_pArrayImages objectAtIndex:
                               (m_iCurrenNumber*10+m_iCurrentFrame)] intValue];
    
    InstFrameFloat=mTextureId;
    iFinishFrame=mTextureId-9;
}
//------------------------------------------------------------------------------------------------------
- (void)Move:(Processor_ex *)pProc{

	if (m_bHiden==NO) {
		m_fPhase+=DELTA*m_fSpeedScale;
		float OffsetRotate=5.0f*sin(m_fPhase/2);
		m_pCurAngle.z=OffsetRotate;
		
		float OffsetScale=2*cos(m_fPhase);
		
		m_pCurScale.x=mWidth*0.5f+OffsetScale;
		m_pCurScale.y=mHeight*0.5f-OffsetScale;		
	}
}
//------------------------------------------------------------------------------------------------------
- (void)HidenOb:(Processor_ex *)pProc{
	m_bHiden=YES;
	NEXT_STAGE;
	REPEATE;
}
//------------------------------------------------------------------------------------------------------
- (void)ChangePar:(Processor_ex *)pProc{

    iFinishFrame=mTextureId+9;
	NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)FinishQueue:(Processor_ex *)pProc{
	
    m_iCurrenNumber=RND%10;
	
    m_iCurrentFrame=9;
	mTextureId = [(NSNumber *)[m_pArrayImages objectAtIndex:(m_iCurrenNumber*10+m_iCurrentFrame)] intValue];
	
    InstFrameFloat=mTextureId;
    iFinishFrame=mTextureId-9;
	
    SET_STAGE_EX(NAME(self), @"Proc", @"Animate1");
}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(CGPoint)CurrentPoint{
	//int m=0;
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT