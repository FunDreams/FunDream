//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectDynamicObject.h"

@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
	m_iLayer = layerTemplet;
	
	mWidth  = 600;
	mHeight = 200;
		
	m_fVelMove=1;
	m_fVelFade=4;
	
	m_vStartPos=Vector3DMake(0,-400,0);
	m_vEndPos=Vector3DMake(0,0,0);
	
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)GetParams:(CParams *)Parametrs{[super GetParams:Parametrs];}
//------------------------------------------------------------------------------------------------------
- (void)SetParams:(CParams *)Parametrs{
	[super SetParams:Parametrs];
	
	COPY_IN_VECTOR(m_vStartPos);
	COPY_IN_VECTOR(m_vEndPos);
	
	COPY_IN_FLOAT(m_fVelMove);
	COPY_IN_FLOAT(m_fVelFade);
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
	[super Start];

	m_pCurPosition=m_vStartPos;

START_PROC(@"Proc");
	UP_SELECTOR(@"e00",@"ProcMove:");
	UP_SELECTOR(@"e01",@"Idle:");
END_PROC(@"Proc");
	

START_PROC(@"Proc2");
	UP_POINT(@"p01_f_Instance",&m_fNormPar0_1);
	UP_CONST_FLOAT(@"f01_f_Instance",1);
	UP_CONST_FLOAT(@"s01_f_Instance",0);
	UP_CONST_FLOAT(@"s01_f_vel",m_fVelMove);
	UP_SELECTOR(@"e01",@"AchiveLineFloat:");
	
	UP_SELECTOR(@"a02",@"ActionFade:");

	UP_SELECTOR(@"t03_3.0",@"timerWaitNextStage:");

	UP_POINT(@"p04_f_Instance",&mColor.alpha);
	UP_CONST_FLOAT(@"f04_f_Instance",0);
	UP_CONST_FLOAT(@"s04_f_Instance",1);
	UP_CONST_FLOAT(@"s04_f_vel",-m_fVelFade);
	UP_SELECTOR(@"e04",@"AchiveLineFloat:");
	
	UP_SELECTOR(@"e05",@"DestroySelf:");

END_PROC(@"Proc2");
	
}
//------------------------------------------------------------------------------------------------------
- (void)Move{}
//------------------------------------------------------------------------------------------------------
- (void)ProcMove:(Processor *)pProc{
//	Vector3D TmpRotate=Vector3DRotateZ2D(m_pOffsetCurPosition,m_pOwner->m_pCurAngle.z+m_pOffsetCurAngle.z);
//	m_pCurPosition.x=m_pOwner->m_pCurPosition.x+TmpRotate.x;
//	m_pCurPosition.y=m_pOwner->m_pCurPosition.y+TmpRotate.y;

	m_fCurPosSlader=1-pow(1-m_fNormPar0_1,8);

	//	m_pCurAngle.z=m_fCurPosSlader*m_pOwner->m_pCurAngle.z;
	//vector++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Vector3D DirV=Vector3DMake(m_vEndPos.x-m_vStartPos.x,m_vEndPos.y-m_vStartPos.y,0);
	float Magnitude = sqrtf(DirV.x*DirV.x+DirV.y*DirV.y);
	
	if(Magnitude>0)
	{
		DirV.x/=Magnitude;
		DirV.y/=Magnitude;
		
		float K=((m_fCurPosSlader)*(Magnitude));
		
		m_pCurPosition.x=DirV.x*K+m_vStartPos.x;
		m_pCurPosition.y=DirV.y*K+m_vStartPos.y;
	}
}
//------------------------------------------------------------------------------------------------------
- (void)ActionFade:(Processor *)pProc{
	
	SET_STAGE(@"GameShef",5);
	[[self FindProcByName:@"Proc"] SetStage:1];
	NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{SET_STAGE(@"GameShef",3);}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT