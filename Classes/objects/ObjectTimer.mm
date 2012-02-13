//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectTimer.h"

@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];

    LOAD_SOUND(iIdWin,@"win.wav",NO);
    LOAD_SOUND(iIdMegaWin,@"hight_score.wav",NO);
    LOAD_SOUND(iIdNoRecord,@"new_hight_score.wav",NO);
    LOAD_SOUND(iIdBrRecord,@"break_record.wav",NO);

    m_fVelFade=1;
    m_bSuspend=false;
	m_bHiden=TRUE;
	m_iLayer = layerInvisible;

	mWidth  = 50;
	mHeight = 50;

	iCountColon=1;
	iCountNum=4;

	m_fWColon=22;
	m_fWNumber=24;
	iDir = 1;

START_PROC(@"Proc");
	UP_SELECTOR(@"e0",@"Idle:");
    
	UP_SELECTOR(@"e1",@"InitShow:");
	UP_SELECTOR(@"e2",@"Show:");
    
	UP_SELECTOR(@"e03",@"Idle:");
    
    UP_SELECTOR(@"e4",@"InitFade:");
	UP_SELECTOR(@"e5",@"Fade:");
    
	UP_SELECTOR(@"e6",@"Reset:");
/////////////////////////////////////////////////////////////////////////////
    UP_SELECTOR(@"e7",@"InitMove:");
	UP_SELECTOR(@"e8",@"MoveEx:");
        
	UP_SELECTOR(@"e9",@"Sound:");
	UP_SELECTOR(@"e10",@"Idle:");
    
    UP_SELECTOR(@"e11",@"InitMove2:");
	UP_SELECTOR(@"e12",@"MoveEx:");
    
	UP_SELECTOR(@"a13",@"Reset:");

END_PROC(@"Proc");


START_PROC(@"MirrorVector");
    
    UP_SELECTOR(@"e0",@"Idle:");

    UP_SELECTOR(@"e1",@"Mirror2DvectorStatic:");
    UP_POINT(@"p1_f_SrcF",&m_fCurPosSlader);
    UP_POINT(@"p1_v_DestV",&m_pCurPosition);
    UP_CONST_FLOAT(@"p1_f_StartF",0);
    UP_CONST_FLOAT(@"p1_f_FinishF",1);
    UP_VECTOR(@"p1_v_StartV",&m_vStartPos);
    UP_VECTOR(@"p1_v_FinishV",&m_vEndPos);
    
END_PROC(@"MirrorVector");
    
START_PROC(@"MoveEx")
    
    UP_SELECTOR(@"e0",@"Idle:");
    UP_SELECTOR(@"e1",@"InitMoveSlow:");
    UP_SELECTOR(@"e2",@"MoveSlow:");

END_PROC(@"MoveEx")
    
	return self;
}
//------------------------------------------------------------------------------------------------------
-(void)SetColorSym{
	
	for(GObject *pOb in m_pChildrenbjectsArr)
		OBJECT_SET_PARAMS(pOb->m_strName,SET_COLOR(@"mColor",m_cNumbers),nil);
	
	UPDATE;
}
//------------------------------------------------------------------------------------------------------
-(void)UpdatePos{
	
	float fWidthTimer=m_fWColon*iCountColon+iCountNum*m_fWNumber*FACTOR_DEC;
	
	int StartValue=0;
	Vector3D StatrPoint=Vector3DMake(-fWidthTimer*0.5f,0,0);
	
	if(Hour==0)StartValue=3;
	else if(Hour<10)StartValue=1;
	
	for (int i=StartValue; i<8; i++) {
        
        GObject *pOb=[m_pChildrenbjectsArr objectAtIndex:i];
		
		OBJECT_SET_PARAMS(NAME(pOb),SET_VECTOR(@"m_pOffsetCurPosition",StatrPoint),nil);
		
		if(i==1 || i==2 || i==4|| i==5)
			StatrPoint.x+=m_fWColon;
		else StatrPoint.x+=m_fWNumber; 
	}
    
    [self SetColorSym];
}
//------------------------------------------------------------------------------------------------------
- (void)GetParams:(CParams *)Parametrs{
	[super GetParams:Parametrs];

	COPY_OUT_FLOAT(m_fTimer);
}
//------------------------------------------------------------------------------------------------------
- (void)SetParams:(CParams *)Parametrs{
	[super SetParams:Parametrs];	
	
	COPY_IN_STRING(m_pNameTexture);
	
	COPY_IN_FLOAT(m_fTimer);
	COPY_IN_FLOAT(m_fWColon);
	COPY_IN_FLOAT(m_fWNumber);
	
	COPY_IN_INT(iDir);

	COPY_IN_COLOR(m_cNumbers);
    
    COPY_IN_VECTOR(m_vStartPos);
    COPY_IN_VECTOR(m_vEndPos);
    
    COPY_IN_FLOAT(m_fVelFade);
    
    COPY_IN_INT(m_iNextStage);
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];
    
	LOAD_TEXTURE(mTextureId,m_pNameTexture);    
    
    [m_pChildrenbjectsArr removeAllObjects];
	for (int i=0; i<8; i++) {

		GObject *Ob = CREATE_NEW_OBJECT(@"ObjectSymbol",([NSString stringWithFormat:@"sym%d", i]),
                        SET_POINT(@"m_pOwner",@"id",self),
						  SET_INT(@"m_iCurrentSym",(i==2 || i==5)?10:0),
						  SET_BOOL(@"m_bHiden",(i<3)?YES:NO),
                          SET_FLOAT(@"mHeight", 50),
                          SET_FLOAT(@"mWidth", 40),
                          SET_COLOR(@"mColor", m_cNumbers),
						  SET_VECTOR(@"m_pCurPosition",(TmpVector1=Vector3DMake(i*35,1,0))),
                          SET_VECTOR(@"m_pCurAngle", (TmpVector1=Vector3DMake(0,0,0))),
                          SET_INT(@"m_iLayer",m_iLayer),
						  nil);
        
        SET_STAGE_EX(Ob->m_strName,@"Proc",2);
        [m_pChildrenbjectsArr addObject:Ob];
	}

    [self UpdateTimer];	
	[self UpdatePos];
}
//------------------------------------------------------------------------------------------------------
- (void)ResetTimer{
    m_fTimer=0;
    Hour=0;
    Sec=0;
    Min=0;

    m_cNumbers=Color3DMake(1, 1, 0, 1);
    [self SetColorSym];

    [self UpdateTimer];
    [self UpdatePos];
    [self Move];
}
//------------------------------------------------------------------------------------------------------
- (void)SuspendTimer{
    m_bSuspend=YES;
    
    [self UpdatePos];
    [self UpdateTimer];
}
//------------------------------------------------------------------------------------------------------
- (void)ResumeTimer{
    m_bSuspend=NO;
    
    [self UpdatePos];
    [self UpdateTimer];
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateTimer{
	
	m_fOldTimer=(int)m_fTimer+0.01f;
	
	[self ParseTime:m_fTimer OutSec:&Sec OutMin:&Min OutHour:&Hour];
	
	NSMutableArray *ArraySec = [self ParseIntValue:Sec];
	NSMutableArray *ArrayMin = [self ParseIntValue:Min];
	NSMutableArray *ArrayHour = [self ParseIntValue:Hour];
    iCountColon=1;
    iCountNum=4;

    int Count=0;
    for (GObject *pOb in m_pChildrenbjectsArr) {
        
        if(Count==2 || Count==5){
            Count++;
            continue;
        }
        OBJECT_SET_PARAMS(NAME(pOb),SET_INT(@"m_iCurrentSym",0),nil);
        Count++;
    }

	if (Hour==0) {
		
		for (int i=0; i<3; i++) {
			
            GObject *pOb=[m_pChildrenbjectsArr objectAtIndex:i];
			OBJECT_SET_PARAMS(NAME(pOb),SET_BOOL(@"m_bHiden",YES),nil);
		}
	}
	else{
		
		iCountColon=2;
		iCountNum=5;
		int StartSym=0;
		if(Hour<10)StartSym=1;
		else iCountNum=6;
		
		for (int i=StartSym; i<3; i++) {

            GObject *pOb=[m_pChildrenbjectsArr objectAtIndex:i];
            OBJECT_SET_PARAMS(NAME(pOb),SET_BOOL(@"m_bHiden",NO),nil);
		}
	}
	
	for (int i=0; i<[ArraySec count]; i++) {
		
		int Value = [[ArraySec objectAtIndex:i] intValue];
        
        GObject *pOb=[m_pChildrenbjectsArr objectAtIndex:7-i];
        OBJECT_SET_PARAMS(NAME(pOb),SET_INT(@"m_iCurrentSym",Value),nil);
	}
	
	for (int i=0; i<[ArrayMin count]; i++) {
		
		int Value = [[ArrayMin objectAtIndex:i] intValue];
        
        GObject *pOb=[m_pChildrenbjectsArr objectAtIndex:4-i];
        OBJECT_SET_PARAMS(NAME(pOb),SET_INT(@"m_iCurrentSym",Value),nil);
	}
	
	for (int i=0; i<[ArrayHour count]; i++) {
		
		int Value = [[ArrayHour objectAtIndex:i] intValue];
        
        GObject *pOb=[m_pChildrenbjectsArr objectAtIndex:1-i];
        OBJECT_SET_PARAMS(NAME(pOb),SET_INT(@"m_iCurrentSym",Value),nil);
	}
	
	[self UpdatePos];
	
    for (GObject *pOb in m_pChildrenbjectsArr) {
        OBJECT_PERFORM_SEL(NAME(pOb),@"Move");
    }
		
	[ArraySec release];
	[ArrayMin release];
	[ArrayHour release];
}
//------------------------------------------------------------------------------------------------------
- (void)Move{
	
    if(m_bSuspend==false){
        
	if(m_fTimer<200000 || m_fTimer >0)
		m_fTimer+=iDir*DELTA;
	
	if(fabs(m_fOldTimer-m_fTimer)>1)
        m_fOldTimer=m_fTimer;
        [self UpdatePos];
		[self UpdateTimer];
        
        if(NAME(self)==@"Timer"){
            int CurrentTime=GET_INT(@"Timer", @"m_fTimer");
            PARAMS_APP->TimerMain=CurrentTime;
        }
        
        int m_iComplexity=GET_INT(@"Field",@"m_iComplexity");
        int TimeTmp;
        
        switch (m_iComplexity) {
            case 0:{
                TimeTmp=PARAMS_APP->TimerEasy;
            }
            break;

            case 1:{
                TimeTmp=PARAMS_APP->TimerNormal;
            }
            break;

            case 2:{
                TimeTmp=PARAMS_APP->TimerHard;
            }
            break;

            default:
                break;
        }
        
        if(TimeTmp<m_fTimer && TimeTmp!=0 && m_cNumbers.green!=0){
            
            PLAY_SOUND(iIdNoRecord);
            m_cNumbers=Color3DMake(1, 0, 0.5f, 1);
            [self SetColorSym];
        }
    }
    
    if(m_iNextStage!=0){
        
        for (GObject *pOb in m_pChildrenbjectsArr) {
            OBJECT_SET_PARAMS(NAME(pOb),SET_INT(@"m_iNextStage", m_iNextStage),nil);
        }

        m_iNextStage=0;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Sound:(Processor *)pProc{

    bool bwin=GET_BOOL(@"Field", @"m_bNewRecord");

    if(bwin==YES){PLAY_SOUND(iIdMegaWin);}
    else {PLAY_SOUND(iIdWin)}
    
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)InitShow:(Processor *)pProc{

    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)InitFade:(Processor *)pProc{
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)Fade:(Processor *)pProc{
    
    m_cNumbers.alpha-=DELTA*3;
    
    if (m_cNumbers.alpha<0){
        m_cNumbers.alpha=0;
        
        DESTROY_OBJECT(self);
        NEXT_STAGE;
    }
    
    [self SetColorSym];
}
//------------------------------------------------------------------------------------------------------
- (void)Show:(Processor *)pProc{
    m_cNumbers.alpha+=DELTA*0.5f;
    
    if (m_cNumbers.alpha>1){
        m_cNumbers.alpha=1;
        NEXT_STAGE;
    }
    
    [self SetColorSym];
}
//------------------------------------------------------------------------------------------------------
- (void)InitMove:(Processor *)pProc{
    
    int m_iComplexity=GET_INT(@"Field",@"m_iComplexity");

    m_fVelTranslate=0.5f;
    m_vStartPos=Vector3DMake(-70*FACTOR_DEC, 420, 0);
    m_vEndPos=Vector3DMake(80*FACTOR_DEC, 320, 0);
    m_fCurPosSlader=0;
    
    switch (m_iComplexity) {
        case 0:
            m_vEndPos.y=205;
            break;
            
        case 1:
            m_vEndPos.y=75;
            break;
            
        case 2:
            m_vEndPos.y=-55;
            break;
            
        default:
            break;
    }

    TmpVector5=m_vEndPos;
    TmpVector5.y-=30;

START_PROC(@"MirrorVector");
    
    UP_VECTOR(@"p1_v_StartV",&m_vStartPos);
    UP_VECTOR(@"p1_v_FinishV",&m_vEndPos);

END_PROC(@"MirrorVector");

    SET_STAGE_EX(NAME(self),@"MirrorVector",1);
    
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)InitMove2:(Processor *)pProc{
    m_fVelTranslate=-2.6f;
    m_fCurPosSlader=1;
    
    m_cNumbers=Color3DMake(1, 1, 0, 1);
    [self SetColorSym];

    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)MoveEx:(Processor *)pProc{
    
    m_fCurPosSlader2+=DELTA*m_fVelTranslate;

    m_fCurPosSlader=1-pow(1-m_fCurPosSlader2,8);
    
    if(m_fVelTranslate>0 && m_fCurPosSlader2>1){
        m_fCurPosSlader2=1;
        m_fCurPosSlader=1;
        NEXT_STAGE;
    }

    if(m_fVelTranslate<0 && m_fCurPosSlader2<0){
        m_fCurPosSlader2=0;
        m_fCurPosSlader=0;
        NEXT_STAGE;
    }

    [self UpdatePos];
}

//------------------------------------------------------------------------------------------------------
- (void)InitMoveSlow:(Processor *)pProc{
    
    int iStage=GET_STAGE_EX(NAME(self), @"Proc");
    if(iStage==10){

 //       SET_STAGE_EX(NAME(self), @"MirrorVector", 0);
        NEXT_STAGE;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)MoveSlow:(Processor *)pProc{
    
    int iStage=GET_STAGE_EX(NAME(self), @"Proc");
    if(iStage==10){
        
        m_pCurPosition.y-=DELTA*20;
        m_vEndPos.y=m_pCurPosition.y;
        
START_PROC(@"MirrorVector");
        UP_VECTOR(@"p1_v_FinishV",&m_vEndPos);
END_PROC(@"MirrorVector");
        
        SET_STAGE_EX(NAME(self),@"MirrorVector",1);
        
        if(m_pCurPosition.y<=TmpVector5.y){
            
            PLAY_SOUND(iIdBrRecord);
//            SET_STAGE_EX(NAME(self), @"MirrorVector", 1);


            int m_iComplexity=GET_INT(@"Field", @"m_iComplexity");
            
            switch (m_iComplexity) {
                case 0:{
                    OBJECT_SET_PARAMS(@"TimerEasy", SET_INT(@"m_iNextStage", 4),nil);
                    break;
                }
                case 1:{
                    OBJECT_SET_PARAMS(@"TimerNormal", SET_INT(@"m_iNextStage", 4),nil);
                    break;
                }
                case 2:{
                    OBJECT_SET_PARAMS(@"TimerHard", SET_INT(@"m_iNextStage", 4),nil);
                    break;
                }
            }
            
            NEXT_STAGE;
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    [super Destroy];
    
    for (GObject *pOb in m_pChildrenbjectsArr){DESTROY_OBJECT(pOb);}
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT