//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectNumSudoku.h"

#define VEL_GROW 4
@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
    m_fPhase=0;
    m_fSpeedScale=4;
	m_iLayer = 	layerOb1;
	
//	m_iCurrentSym=RND%10;

	for (int i=0; i<11; i++) {
		
        NSString *pstr=nil;
        
        if (i==10) pstr=[NSString stringWithFormat:@"n_t.png"];
        else pstr=[NSString stringWithFormat:@"n_%d.png", i];
		
		UInt32 TmpIdTexture=-1;
		LOAD_TEXTURE(TmpIdTexture,pstr);
		
		[m_pArrayImages addObject:[NSNumber numberWithInt:TmpIdTexture]];
	}
	
	mWidth  = 60;
	mHeight = 60;

//	[m_pObjMng AddToGroup:@"NumbersField" Object:self];

START_PROC(@"Proc");
    
    UP_SELECTOR(@"e00",@"Idle:");

    UP_TIMER(1,300,1000,@"timerWaitNextStage:");
    UP_SELECTOR(@"a02",@"InitGrow:");
	UP_SELECTOR(@"e03",@"Grow:");
	UP_SELECTOR(@"e04",@"Decrease:");
    
    UP_SELECTOR(@"e05",@"Idle:");
    UP_SELECTOR(@"e06",@"Reset:");
    
    UP_SELECTOR(@"a08",@"InitFall:");
    UP_SELECTOR(@"e09",@"Fall:");
    UP_SELECTOR(@"e10",@"Idle:");

    UP_SELECTOR(@"a11",@"InitFinish:");
    UP_SELECTOR(@"e12",@"Finish:");
    UP_SELECTOR(@"e13",@"Idle:");

END_PROC(@"Proc");

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)Error{
    
    if(bError){
  //      mColor=Color3DMake(1.0f,0.0f,0.0f,1.0f);
        TmpColor1=mColor;//Color3DMake(1.0f,0.0f,0.0f,1.0f);
        
START_PROC(@"Error");
        UP_SELECTOR(@"e00",@"Idle:");
        UP_SELECTOR(@"e01",@"Error:");
END_PROC(@"Error");

        SET_STAGE_EX(NAME(self), @"Error", 1);
                
        float fPhaseField=GET_FLOAT(@"Field", @"m_fPhase");
        mbColor=YES;
        
        m_fPhase=fPhaseField;
        m_fOldPhase=m_fPhase;
    }
    else {
        [self SetType];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetType{
    
    switch (iType) {
        case 0:
            mColor=Color3DMake(0.0f,1.0f,0.0f,1.0f);
            break;

        case 1:
            mColor=Color3DMake(0.8f,0.8f,0.0f,1.0f);
            break;

        case 2:
  //          mColor=Color3DMake(1.0f,0.0f,0.0f,1.0f);
            break;

        case 3:
            mColor=Color3DMake(1.0f,0.6f,1.0f,1.0f);
            break;

    }
    
    TmpColor1=mColor;
}
//------------------------------------------------------------------------------------------------------
- (void)GetParams:(CParams *)Parametrs{
	[super GetParams:Parametrs];
    
	COPY_OUT_INT(m_iCurrentSym);
    COPY_OUT_INT(iType);
    COPY_OUT_INT(m_iCurNum);
    COPY_OUT_BOOL(bError);
}
//------------------------------------------------------------------------------------------------------
- (void)SetParams:(CParams *)Parametrs{
	[super SetParams:Parametrs];
    
	COPY_IN_INT(m_iCurrentSym);
    COPY_IN_INT(iType);
    COPY_IN_INT(m_iCurNum);
    COPY_IN_BOOL(bError);
    
    COPY_IN_VECTOR(m_Vvelosity);
    COPY_IN_FLOAT(m_fRotateVel);
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];

	mTextureId = [[m_pArrayImages objectAtIndex:m_iCurrentSym] intValue];
        
    m_pCurAngle.z=(float)(RND%10)-5;
    mColor=Color3DMake(1.0f,1.0f,1.0f,1.0f);
    bError=NO;
    iType=0;
    m_fPhase=0;
    m_fOldPhase=0;
    
    [self SetType];
    [self SetPosWithOffsetOwner];
    [self Reset:nil];
}
//------------------------------------------------------------------------------------------------------
- (void)Reset:(Processor *)pProc{
    SET_STAGE(m_strName,0);
}
//------------------------------------------------------------------------------------------------------
- (void)Move{mTextureId = [[m_pArrayImages objectAtIndex:m_iCurrentSym] intValue];}
//------------------------------------------------------------------------------------------------------
- (void)Error:(Processor *)pProc{
    
    int Stage=GET_STAGE_EX(NAME(self), @"Proc");
    
    if(Stage==5 || Stage==0){
                
            
        m_fCurPosSlader=0.5f*(-cos(m_fPhase)+1);
        float pfSrc=m_fCurPosSlader;
        
        float fPhaseField=GET_FLOAT(@"Field", @"m_fPhase");

        m_fPhase=fPhaseField;

        if(bError==NO && (m_fCurPosSlader-0.05f)<0){
            m_fCurPosSlader=0;
            pfSrc=0;
            NEXT_STAGE;
        }

        float pfStartF=0;
        float pfFinishF=1;
        
        Color3D pStartV=TmpColor1;
        Color3D pFinishV=Color3DMake(1, 0, 0, 1);
        
        if(mbColor){
        
            m_pCurScale.x=mWidth*0.5f+4*m_fCurPosSlader;
            m_pCurScale.y=mHeight*0.5f+4*m_fCurPosSlader;

            Color3D Dir=Color3DMake(pFinishV.red-pStartV.red,pFinishV.green-pStartV.green,
                                    pFinishV.blue-pStartV.blue,pFinishV.alpha-pStartV.alpha);
            
            float Magnitude = sqrtf(Dir.red*Dir.red+Dir.green*Dir.green+
                                    Dir.blue*Dir.blue+Dir.alpha*Dir.alpha);
            
            if(Magnitude>0)
            {
                Dir.red/=Magnitude;
                Dir.green/=Magnitude;
                Dir.blue/=Magnitude;
                Dir.alpha/=Magnitude;
                
                float K=((pfSrc-pfStartF)*(Magnitude/(pfFinishF-pfStartF)));
                
                mColor.red=Dir.red*K+pStartV.red;
                mColor.green=Dir.green*K+pStartV.green;
                mColor.blue=Dir.blue*K+pStartV.blue;
                mColor.alpha=Dir.alpha*K+pStartV.alpha;
            }
        }
        
        if(m_fPhase-m_fOldPhase>=3.14*2 && mbColor==YES && pfSrc<0.05f)
        {            
            m_fOldPhase=m_fPhase;
            mbColor=NO;
        }
        else if(m_fPhase-m_fOldPhase>=3.14*6 && pfSrc<0.05f){
            mbColor=YES;
            m_fOldPhase=m_fPhase;
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)InitFall:(Processor *)pProc{
    
    m_fRotateVel=RND%400;
    m_Vvelosity=Vector3DMake((float)(RND%700)-350,(float)(RND%800)-400,0);

    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)Fall:(Processor *)pProc{
 //   int m=0;
    
    m_Vvelosity.y-=DELTA*1000;
    m_pCurAngle.z+=DELTA*m_fRotateVel;

    m_pCurPosition.x+=DELTA*m_Vvelosity.x;
    m_pCurPosition.y+=DELTA*m_Vvelosity.y;
    
    if(m_pCurPosition.y<-500){
        DESTROY_OBJECT(self);
        [self Reset:pProc];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)InitGrow:(Processor *)pProc{
    
    m_pCurAngle.z=RND%360;
    
    m_vStartPos=Vector3DMake(0.1f, 0.1f, 1);
    m_vEndPos=Vector3DMake(35, 35, 1);
    
    int iCurRand=1;//RND%50;
    m_pCurScale.x=iCurRand;
    m_pCurScale.y=iCurRand;
    m_fCurPosSlader=0;

    m_bHiden=NO;
    NEXT_STAGE;
    UPDATE;
}
//------------------------------------------------------------------------------------------------------
- (void)Decrease:(Processor *)pProc{
	mTextureId = [[m_pArrayImages objectAtIndex:m_iCurrentSym] intValue];

    [self SetPosWithOffsetOwner];
    
    m_fCurPosSlader-=2*DELTA;
	float TmpY=1-pow(1-m_fCurPosSlader,2);
//	float TmpY2=pow(m_fCurPosSlader,5);
    
    if(m_fCurPosSlader<0)
    {
        m_fCurPosSlader=0;
        TmpY=0;
    }
    //vector++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Vector3D DirV=Vector3DMake(m_vEndPos.x-m_vStartPos.x,m_vEndPos.y-m_vStartPos.y,0);
	float Magnitude = sqrtf(DirV.x*DirV.x+DirV.y*DirV.y);
	
	if(Magnitude>0)
	{
		DirV.x/=Magnitude;
		DirV.y/=Magnitude;
		
		float K=((TmpY)*(Magnitude));
		
		m_pCurScale.x=DirV.x*K+m_vStartPos.x;
		m_pCurScale.y=DirV.y*K+m_vStartPos.y;
	}
    
    SET_MIRROR(m_pCurAngle.z,TmpY,1,0,m_fStartAngle,m_fEndAngle);
    
 //    m_pCurAngle.z=((m_fCurPosSlader-0)*((m_fStartAngle-m_fEndAngle)/(1-0)))+m_fEndAngle;
    
    if(m_fCurPosSlader==0){
        
        m_pCurScale=m_vStartPos;

        NEXT_STAGE;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Grow:(Processor *)pProc{
	
	mTextureId = [[m_pArrayImages objectAtIndex:m_iCurrentSym] intValue];

    [self SetPosWithOffsetOwner];

    m_fCurPosSlader+=VEL_GROW*DELTA;
	float TmpY=1-pow(1-m_fCurPosSlader,3);
    
    if(m_fCurPosSlader>1)
        m_fCurPosSlader=1;
    
    //vector++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Vector3D DirV=Vector3DMake(m_vEndPos.x-m_vStartPos.x,m_vEndPos.y-m_vStartPos.y,0);
	float Magnitude = sqrtf(DirV.x*DirV.x+DirV.y*DirV.y);
	
	if(Magnitude>0)
	{
		DirV.x/=Magnitude;
		DirV.y/=Magnitude;
		
		float K=((TmpY)*(Magnitude));
		
		m_pCurScale.x=DirV.x*K+m_vStartPos.x;
		m_pCurScale.y=DirV.y*K+m_vStartPos.y;
	}
    
    if(m_fCurPosSlader==1){
        
        m_vStartPos=Vector3DMake(28, 28, 1);

        m_fStartAngle=m_pCurAngle.z;
        m_fEndAngle=(float)(RND%10)-5;
        
        NEXT_STAGE;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)InitFinish:(Processor *)pProc{
    
    m_fRotateVel=RND%4;
    m_Vvelosity=Vector3DMake((float)(RND%8)-4,(float)(RND%8)-4,0);
    m_fCurPosSlader2=0;
    
    TmpColor1=mColor;
     
    //setrndcolor----------------
    int Dev=10;
    float MinLimit=0.0f;
    
    float Red=((float)(RND%Dev))*0.1f+MinLimit;            
    float Green=((float)(RND%Dev))*0.1f+MinLimit;
    float Blue=((float)(RND%Dev))*0.1f+MinLimit;
    
    if (Red>1)Red=1;
    if (Green>1)Green=1;
    if (Blue>1)Blue=1;
    
    TmpColor2=Color3DMake(Red,Green,Blue,1);
    //-------------------------
    
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)Finish:(Processor *)pProc{
    
    m_pCurAngle.z+=DELTA*m_fRotateVel;
    
    m_pCurPosition.x+=DELTA*m_Vvelosity.x;
    m_pCurPosition.y+=DELTA*m_Vvelosity.y;

    if(m_pCurPosition.x<-300 && m_Vvelosity.x<0)
        m_Vvelosity.x=-m_Vvelosity.x;
    if(m_pCurPosition.x>300 && m_Vvelosity.x>0)
        m_Vvelosity.x=-m_Vvelosity.x;
    
    if(m_pCurPosition.y<-450 && m_Vvelosity.y<0)
        m_Vvelosity.y=-m_Vvelosity.y;
    if(m_pCurPosition.y>450 && m_Vvelosity.y>0)
        m_Vvelosity.y=-m_Vvelosity.y;
    
    m_fPhase+=DELTA*m_fSpeedScale;
    m_fCurPosSlader=0.5f*(-cos(m_fPhase)+1);
    
    m_pCurScale.x=mWidth*0.5f+4*m_fCurPosSlader;
	m_pCurScale.y=mHeight*0.5f+4*m_fCurPosSlader;
    
    m_fCurPosSlader2+=DELTA*0.5f;
    if(m_fCurPosSlader2>1)m_fCurPosSlader2=1;
    
    float *pfSrc=&m_fCurPosSlader2;
	
	float pfStartF=0;
	float pfFinishF=1;
	
	Color3D pStartV=TmpColor1;
	Color3D pFinishV=TmpColor2;
    
	Color3D Dir=Color3DMake(pFinishV.red-pStartV.red,pFinishV.green-pStartV.green,
							pFinishV.blue-pStartV.blue,pFinishV.alpha-pStartV.alpha);
	
	float Magnitude = sqrtf(Dir.red*Dir.red+Dir.green*Dir.green+
							Dir.blue*Dir.blue+Dir.alpha*Dir.alpha);
	
	if(Magnitude>0)
	{
		Dir.red/=Magnitude;
		Dir.green/=Magnitude;
		Dir.blue/=Magnitude;
		Dir.alpha/=Magnitude;
		
		float K=((*pfSrc-pfStartF)*(Magnitude/(pfFinishF-pfStartF)));
		
		mColor.red=Dir.red*K+pStartV.red;
		mColor.green=Dir.green*K+pStartV.green;
		mColor.blue=Dir.blue*K+pStartV.blue;
		mColor.alpha=Dir.alpha*K+pStartV.alpha;
	}

}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT