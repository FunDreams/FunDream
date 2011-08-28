//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectNumSudoku2.h"

@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
	m_iLayer = layerNumber;
//	m_iCurrentSym=RND%10;

	for (int i=0; i<10; i++) {
		
		NSString *pstr;
		
		pstr=[NSString stringWithFormat:@"n_%d.png", i];
		
		UInt32 TmpIdTexture=-1;
		LOAD_TEXTURE(TmpIdTexture,pstr);
		
		[m_pArrayImages addObject:[NSNumber numberWithInt:TmpIdTexture]];
	}
	
	mWidth  = 50;
	mHeight = 50;
	
//	[m_pObjMng AddToGroup:@"NumbersAura" Object:self];
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
	
	COPY_IN_VECTOR(m_vCurTargetPoint);
	COPY_IN_VECTOR(m_vCurSourcePoint);
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];
	
	mTextureId = [[m_pArrayImages objectAtIndex:m_iCurrentSym] intValue];
	
	m_fCurPosSlader=0;
	
	mColor=Color3DMake(1.0f,1.0f, 1.0f, 0.0f);

	
//START_PROC(@"Controler");
	
//	UP_POINT(@"p00_f_Instance",&m_fCurPosSlader2);
//	UP_CONST_FLOAT(@"s00_f_Instance",0);
//	UP_CONST_FLOAT(@"f00_f_Instance",1);
//	UP_CONST_FLOAT(@"s00_f_vel",1);
//	UP_SELECTOR(@"e00",@"AchiveLineFloat:");
//	
//	UP_SELECTOR(@"e01",@"Idle:");

//END_PROC(@"Controler");

//START_PROC(@"Proc");
//	UP_SELECTOR(@"e00",@"Mirror2DvectorStatic:");
//	
//	UP_POINT(@"p00_f_SrcF",&m_fCurPosSlader);
//	UP_POINT(@"p00_v_DestV",&m_pOffsetCurPosition);
//	UP_CONST_FLOAT(@"p00_f_StartF",0);
//	UP_CONST_FLOAT(@"p00_f_FinishF",1);
//	UP_VECTOR(@"p00_v_StartV",&m_vCurStartPoint);
//	UP_VECTOR(@"p00_v_FinishV",&m_vCurTargetPoint);
//	
//	UP_SELECTOR(@"e01",@"Idle:");
//END_PROC(@"Proc");
	
//START_PROC(@"Proc1");
//	UP_SELECTOR(@"e00",@"Mirror4DColorStatic:");
//	
//	UP_POINT(@"p00_f_SrcF",&m_fCurPosSlader);
//	UP_POINT(@"p00_c_DestC",&mColor);
//	UP_CONST_FLOAT(@"p00_f_StartF",0);
//	UP_CONST_FLOAT(@"p00_f_FinishF",1);
//	UP_COLOR(@"p00_c_StartC", &mColor);
//	UP_COLOR(@"p00_c_FinishC",&Color3DMake(1.0f, 1.0f, 1.0f, 1.0f));
//	
//	UP_SELECTOR(@"e01",@"Idle:");
//END_PROC(@"Proc1");
	
//START_PROC(@"Proc2");
//	UP_SELECTOR(@"e00",@"Mirror1DFloatStatic:");
//	
//	UP_POINT(@"p00_f_SrcF",&m_fCurPosSlader);
//	UP_POINT(@"p00_f_DestF",&m_pCurAngle.z);
//	UP_CONST_FLOAT(@"p00_f_StartF1",0);
//	UP_CONST_FLOAT(@"p00_f_FinishF1",1);
//	UP_CONST_FLOAT(@"p00_f_StartF2",0);
//	UP_CONST_FLOAT(@"p00_f_FinishF2",m_pOwner->m_pCurAngle.z);
//	
//	UP_SELECTOR(@"e01",@"Idle:");
//END_PROC(@"Proc2");

//START_PROC(@"Proc3");
//	UP_SELECTOR(@"e00",@"Parabola:");
//	
//	UP_POINT(@"p00_f_SrcF",&m_pOwner->mColor.alpha);
//	UP_POINT(@"p00_f_DestF",&m_fCurPosSlader);
//	UP_CONST_INT(@"p00_i_PowI",8);
//	
//	UP_SELECTOR(@"e01",@"Idle:");
//END_PROC(@"Proc3");
	
}
//------------------------------------------------------------------------------------------------------
- (void)Move{

	Vector3D TmpRotate=Vector3DRotateZ2D(m_pOffsetCurPosition,m_pOwner->m_pCurAngle.z+m_pOffsetCurAngle.z);
	m_pCurPosition.x=m_pOwner->m_pCurPosition.x+TmpRotate.x;
	m_pCurPosition.y=m_pOwner->m_pCurPosition.y+TmpRotate.y;
	
	m_fCurPosSlader=1-pow(1-m_pOwner->mColor.alpha,8);
	
//	m_pCurAngle.z=m_fCurPosSlader*m_pOwner->m_pCurAngle.z;
	
	if((mColor.green!=1 && mColor.green!=0.6f) || m_iCurrentSym==0)
		mColor.alpha=m_fCurPosSlader;
//vector++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Vector3D DirV=Vector3DMake(m_vCurTargetPoint.x-m_vCurSourcePoint.x,m_vCurTargetPoint.y-m_vCurSourcePoint.y,0);
	float Magnitude = sqrtf(DirV.x*DirV.x+DirV.y*DirV.y);
	
	if(Magnitude>0)
	{
		DirV.x/=Magnitude;
		DirV.y/=Magnitude;
		
		float K=((m_fCurPosSlader)*(Magnitude));
		
		m_pOffsetCurPosition.x=DirV.x*K+m_vCurSourcePoint.x;
		m_pOffsetCurPosition.y=DirV.y*K+m_vCurSourcePoint.y;
	}
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT