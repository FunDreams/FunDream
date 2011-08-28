//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectButtonDiff.h"

@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
    LOAD_SOUND(iIdSound,@"click1.wav",NO);
    LOAD_SOUND(iIdSound2,@"click2.wav",NO);
    
    m_fSpeedScale = 9+(RND%10)*0.1f;	
	m_fPhase=0;

	m_iLayer = layerInterfaceSpace3;
    m_iLayerTouch=layerOb3;

	mWidth  = 50;
	mHeight = 50;

START_PROC(@"MirrorVector");
    UP_SELECTOR(@"e00",@"Mirror2DvectorStatic:");

    UP_POINT(@"p00_f_SrcF",&m_fCurPosSlader);
    UP_POINT(@"p00_v_DestV",&m_pCurPosition);
    UP_CONST_FLOAT(@"p00_f_StartF",0);
    UP_CONST_FLOAT(@"p00_f_FinishF",1);
    UP_VECTOR(@"p00_v_StartV",&m_vStartPos);
    UP_VECTOR(@"p00_v_FinishV",&m_vEndPos);

    UP_SELECTOR(@"e01",@"Idle:");
END_PROC(@"MirrorVector");

START_PROC(@"Proc1");
    UP_SELECTOR(@"e00",@"Mirror4DColorStatic:");

    UP_POINT(@"p00_f_SrcF",&m_fCurPosSlader);
    UP_POINT(@"p00_c_DestC",&mColor);
    UP_CONST_FLOAT(@"p00_f_StartF",0);
    UP_CONST_FLOAT(@"p00_f_FinishF",1);
    UP_COLOR(@"p00_c_StartC", &mColor);
    UP_COLOR(@"p00_c_FinishC",&(TmpColor1=Color3DMake(1.0f, 1.0f, 1.0f, 1.0f)));

    UP_SELECTOR(@"e01",@"Idle:");
END_PROC(@"Proc1");

START_PROC(@"Alpha");
    UP_SELECTOR(@"e00",@"Alpha:");    	
    UP_SELECTOR(@"e01",@"Idle:");
END_PROC(@"Alpha");
    
START_PROC(@"Proc4");
    UP_SELECTOR(@"e00",@"Parabola:");
    
    UP_POINT(@"p00_f_SrcF",&TmpSlider);
    UP_POINT(@"p00_f_DestF",&m_fCurPosSlader);
    UP_CONST_INT(@"p00_i_PowI",8);
    
    UP_SELECTOR(@"e01",@"Idle:");
END_PROC(@"Proc4");

START_PROC(@"Wave");

    UP_SELECTOR(@"e00",@"Idle:");
    UP_SELECTOR(@"e01",@"wave:");    
    
END_PROC(@"Wave");

START_PROC(@"Slider");
	
    UP_SELECTOR(@"e00",@"Idle:");

	UP_POINT(@"p01_f_Instance",&TmpSlider);
    //	UP_CONST_FLOAT(@"s01_f_Instance",0);
	UP_CONST_FLOAT(@"f01_f_Instance",1);
	UP_CONST_FLOAT(@"s01_f_vel",3.3f);
	UP_SELECTOR(@"e01",@"AchiveLineFloat:");

    UP_SELECTOR(@"e02",@"FinishShow:");

	UP_SELECTOR(@"e03",@"Idle:");
    
	UP_POINT(@"p04_f_Instance",&TmpSlider);
    //	UP_CONST_FLOAT(@"s04_f_Instance",0.5f);
	UP_CONST_FLOAT(@"f04_f_Instance",0);
	UP_CONST_FLOAT(@"s04_f_vel",-3.3f);
	UP_SELECTOR(@"e04",@"AchiveLineFloat:");

	UP_SELECTOR(@"e5",@"FinishHide:");
	UP_SELECTOR(@"e6",@"Reset:");
    
	UP_POINT(@"p7_f_Instance",&TmpSlider);
	UP_CONST_FLOAT(@"f7_f_Instance",1);
	UP_CONST_FLOAT(@"s7_f_vel",1.5f);
	UP_SELECTOR(@"e7",@"AchiveLineFloat:");
    
    UP_SELECTOR(@"e8",@"FinishShow:");
    
	UP_SELECTOR(@"e9",@"Idle:");
    
	UP_POINT(@"p10_f_Instance",&TmpSlider);
	UP_CONST_FLOAT(@"f10_f_Instance",0);
	UP_CONST_FLOAT(@"s10_f_vel",-0.3f);
	UP_SELECTOR(@"e10",@"AchiveLineFloat:");
	
	UP_SELECTOR(@"11",@"FinishHide:");
	UP_SELECTOR(@"12",@"Reset:");

END_PROC(@"Slider");

START_PROC(@"PauseTouch");
    UP_SELECTOR(@"e00",@"Idle:");
    UP_TIMER(1,1,1000, @"timerWaitNextStage:");
    UP_SELECTOR(@"e2",@"TouchYes:");
END_PROC(@"PauseTouch");

//    LOAD_SOUND(iIdSound,@"knopka.wav",NO);
//    LOAD_TEXTURE(mTextureId,m_pNameTexture);

 //   [self SetTouch:YES];
    
    [m_pObjMng AddToGroup:@"ButtonDiff" Object:self];
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)GetParams:(CParams *)Parametrs{[super GetParams:Parametrs];}
//------------------------------------------------------------------------------------------------------
- (void)SetParams:(CParams *)Parametrs{[super SetParams:Parametrs];}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];
    
    m_vStartPos=m_pCurPosition;
    m_vEndPos=Vector3DMake(-240*FACTOR_DEC, 320, 0);
}
//------------------------------------------------------------------------------------------------------
- (void)Move{}
//------------------------------------------------------------------------------------------------------
- (void)SetStatesAutomat{}
//------------------------------------------------------------------------------------------------------
- (void)InitAllButton{
    
    NSMutableArray *pArray = [m_pObjMng GetGroup:@"ButtonDiff"];
    
    int Count=0;
    for (GObject *pObject in pArray) {
        switch (Count) {
            case 0:
            {
                SET_STAGE_EX(pObject->m_strName,@"MirrorVector",1);
                SET_STAGE_EX(pObject->m_strName,@"Alpha",1);
                
                [pObject SetTouch:NO];
                SET_STAGE_EX(NAME(pObject), @"PauseTouch", 1);
            }
                break;
                
            case 1:
            {
                SET_STAGE_EX(pObject->m_strName,@"MirrorVector",0);
                SET_STAGE_EX(pObject->m_strName,@"Alpha",0);
                
                m_vEndPos=Vector3DMake(-240*FACTOR_DEC, 200, 0);                
                
                START_PROC_EX(NAME(pObject),@"MirrorVector");
                UP_VECTOR(@"p00_v_StartV",&m_vStartPos);
                UP_VECTOR(@"p00_v_FinishV",&m_vEndPos);    
                END_PROC_EX(pObject->m_strName,@"MirrorVector");
                
                [pObject SetTouch:NO];
            }
                break;
                
            case 2:
            {
                
                SET_STAGE_EX(pObject->m_strName,@"MirrorVector",0);
                SET_STAGE_EX(pObject->m_strName,@"Alpha",0);
                
                m_vEndPos=Vector3DMake(-240*FACTOR_DEC, 80, 0);
                
                START_PROC_EX(pObject->m_strName,@"MirrorVector");
                UP_VECTOR(@"p00_v_StartV",&m_vStartPos);
                UP_VECTOR(@"p00_v_FinishV",&m_vEndPos);    
                END_PROC_EX(pObject->m_strName,@"MirrorVector");
                
                [pObject SetTouch:NO];
            }
                break;
                
            default:
                break;
        }
        
        Count++;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetButtonPosFinalize{
    
    if(NAME(self)==@"ButtonDif1"){
        self->m_vEndPos=Vector3DMake(-100*FACTOR_DEC, 180, 0);
    }
    else if(NAME(self)==@"ButtonDif2"){
        self->m_vEndPos=Vector3DMake(-100*FACTOR_DEC, 50, 0);
    }
    else if(NAME(self)==@"ButtonDif3"){
        self->m_vEndPos=Vector3DMake(-100*FACTOR_DEC, -80, 0);
    }
}
//------------------------------------------------------------------------------------------------------
- (void)InitAllButton2{
    
    NSMutableArray *pArray = [m_pObjMng GetGroup:@"ButtonDiff"];

    ObjectButtonDiff *Ob1=[pArray objectAtIndex:0];
    SET_STAGE_EX(NAME(Ob1),@"Slider",7); 
    SET_STAGE_EX(NAME(Ob1),@"Wave", 1);
    SET_STAGE_EX(Ob1->m_strName,@"MirrorVector",0);
    
    [Ob1 SetButtonPosFinalize];
    [Ob1 SetTouch:NO];
    
START_PROC_EX(NAME(Ob1),@"MirrorVector");
    UP_VECTOR(@"p00_v_StartV",&m_vStartPos);
    UP_VECTOR(@"p00_v_FinishV",&Ob1->m_vEndPos);  
END_PROC_EX(Ob1->m_strName,@"MirrorVector");
    
    Ob1=[pArray objectAtIndex:1];
    SET_STAGE_EX(Ob1->m_strName,@"Slider",7);
    SET_STAGE_EX(NAME(Ob1),@"Wave", 0);
    SET_STAGE_EX(Ob1->m_strName,@"MirrorVector",0);
    [Ob1 SetButtonPosFinalize];
    [Ob1 SetTouch:NO];
  
START_PROC_EX(NAME(Ob1),@"MirrorVector");
    UP_VECTOR(@"p00_v_StartV",&m_vStartPos);
    UP_VECTOR(@"p00_v_FinishV",&Ob1->m_vEndPos);    
END_PROC_EX(Ob1->m_strName,@"MirrorVector");

    Ob1=[pArray objectAtIndex:2];
    SET_STAGE_EX(Ob1->m_strName,@"Slider",7);
    SET_STAGE_EX(NAME(Ob1),@"Wave", 0);
    SET_STAGE_EX(Ob1->m_strName,@"MirrorVector",0);
    [Ob1 SetButtonPosFinalize];
    [Ob1 SetTouch:NO];
    
START_PROC_EX(NAME(Ob1),@"MirrorVector");
    UP_VECTOR(@"p00_v_StartV",&m_vStartPos);
    UP_VECTOR(@"p00_v_FinishV",&Ob1->m_vEndPos);    
END_PROC_EX(Ob1->m_strName,@"MirrorVector");
}
//------------------------------------------------------------------------------------------------------
- (void)touchesBeganOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{

    int iCurStage=GET_STAGE_EX(NAME(self),@"Slider");

    if(iCurStage==9)
    {
        NSMutableArray *pArray = [m_pObjMng GetGroup:@"ButtonDiff"];
        
        GObject *pTmpObject=[pArray objectAtIndex:0];
        SET_STAGE_EX(NAME(pTmpObject),@"Wave", 1);

        pTmpObject=[pArray objectAtIndex:0];
        SET_STAGE_EX(NAME(pTmpObject),@"Wave", 1);

        pTmpObject=[pArray objectAtIndex:0];
        SET_STAGE_EX(NAME(pTmpObject),@"Wave", 1);
    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    LOCK_TOUCH;
    
    NSMutableArray *pArray = [m_pObjMng GetGroup:@"ButtonDiff"];
    Processor *pTmpProc=[self FindProcByName:@"Slider"];
    
    int iTmpStage=pTmpProc->m_pICurrentStage;
    
    if(iTmpStage>6){
        
        GObject *Ob1=[pArray objectAtIndex:0];
        SET_STAGE_EX(NAME(Ob1),@"Wave", 1);
        
        Ob1=[pArray objectAtIndex:1];
        SET_STAGE_EX(NAME(Ob1),@"Wave", 0);

        Ob1=[pArray objectAtIndex:2];
        SET_STAGE_EX(NAME(Ob1),@"Wave", 0);
        
        SET_STAGE_EX(m_strName,@"Wave", 1);
    }
    else
    {
        GObject *pOb = [m_pObjMng GetObjectByName:@"Fade"];

        if(pOb==nil){
            CREATE_NEW_OBJECT(@"ObjectFade",@"Fade2",
                          SET_INT(@"m_iLayer",layerInvisible),
                          SET_COLOR(@"mColor",(TmpColor1=Color3DMake(0,0,0,0))),
                        SET_VECTOR(@"m_pCurPosition",(TmpVector1=Vector3DMake(-240*FACTOR_DEC,240,0.0f))),
                          SET_INT(@"m_iStartStage", 0),
                          SET_FLOAT(@"mWidth",160*FACTOR_DEC),
                          SET_FLOAT(@"mHeight",480),
                        SET_STRING(@"m_pNameTexture",@"FadeTextureMini.png"),
                          SET_INT(@"m_iLayer",layerNumber),
                          nil);
        }
        
        SET_STAGE_EX(m_strName,@"Wave", 1);
        SET_STAGE_EX(m_strName,@"Slider",1);
                
        GObject *Ob1=[pArray objectAtIndex:1];
        SET_STAGE_EX(Ob1->m_strName,@"Slider",1);
    //    SET_STAGE_EX(NAME(Ob1),@"Wave", 0);
        
        Ob1=[pArray objectAtIndex:2];
        SET_STAGE_EX(Ob1->m_strName,@"Slider",1);
    //    SET_STAGE_EX(NAME(Ob1),@"Wave", 0);
        
    }
    
    PLAY_SOUND(iIdSound);
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    int TmpComp=GET_INT(@"Field",@"m_iComplexity");
    
    if(NAME(self)==@"ButtonDif1" && TmpComp!=0){SET_STAGE_EX(NAME(self),@"Wave", 0);}
    else if(NAME(self)==@"ButtonDif2" && TmpComp!=1){SET_STAGE_EX(NAME(self),@"Wave", 0);}
    else if(NAME(self)==@"ButtonDif3" && TmpComp!=2){SET_STAGE_EX(NAME(self),@"Wave", 0);}    
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    SET_STAGE_EX(NAME(self),@"Wave", 1);
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEndedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    int iCurStage=GET_STAGE_EX(NAME(self),@"Slider");
    
    if(iCurStage<7)
    {
    //    SET_STAGE_EX(NAME(self),@"Slider",4);
        SET_STAGE_EX(m_strName,@"Wave", 0);
        SET_STAGE(@"Fade2", 2);
        
        SET_STAGE_EX(@"ButtonDif1",@"Slider", 4);
        SET_STAGE_EX(@"ButtonDif2",@"Slider", 4);
        SET_STAGE_EX(@"ButtonDif3",@"Slider", 4);
    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    PLAY_SOUND(iIdSound2);

    LOCK_TOUCH;
    
    NSMutableArray *pArray = [m_pObjMng GetGroup:@"ButtonDiff"];
    
    int Count=0;
    for (GObject *pObject in pArray) {
        
        if(m_strName==pObject->m_strName)
        {
            switch (Count) {
                case 0:
                {
                    SET_STAGE_EX(pObject->m_strName,@"MirrorVector",1);
                    SET_STAGE_EX(pObject->m_strName,@"Alpha",1);
                    mColor.alpha=1;
                    
                    GObject *pObj;
                    pObj=[pArray objectAtIndex:1];
                    SET_STAGE_EX(pObj->m_strName,@"Slider",4);
                    SET_STAGE_EX(pObj->m_strName,@"MirrorVector",0);
                    SET_STAGE_EX(pObj->m_strName,@"Alpha",0);
                    SET_STAGE_EX(pObj->m_strName,@"Wave", 0);
                    
                    pObj=[pArray objectAtIndex:2];
                    SET_STAGE_EX(pObj->m_strName,@"Slider",4);
                    SET_STAGE_EX(pObj->m_strName,@"MirrorVector",0);
                    SET_STAGE_EX(pObj->m_strName,@"Alpha",0);                    
                    SET_STAGE_EX(pObj->m_strName,@"Wave", 0);
                }
                break;

                case 1:
                {
#ifdef DEMO                    
                    NSString *iTunesLink = @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=443906995&mt=8"; 
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
                    
                    GObject *pObFade=[m_pObjMng GetObjectByName:@"Fade"];
                    
                    if(pObFade==nil){
                        CGPoint TmpPoint;
                        [self touchesEndedOut:nil WithPoint:TmpPoint];
                    }
                    return;
#endif

                    GObject *pObj;
                    SET_STAGE_EX(pObject->m_strName,@"MirrorVector",0);
                    SET_STAGE_EX(pObject->m_strName,@"Alpha",1);

                    pObj=[pArray objectAtIndex:0];
                    SET_STAGE_EX(pObj->m_strName,@"Slider",4);
                    SET_STAGE_EX(pObj->m_strName,@"MirrorVector",1);
                    SET_STAGE_EX(pObj->m_strName,@"Alpha",0);
                    SET_STAGE_EX(pObj->m_strName,@"Wave", 0);

                    mColor.alpha=1;
                    
                    pObj=[pArray objectAtIndex:2];
                    SET_STAGE_EX(pObj->m_strName,@"Slider",4);
                    SET_STAGE_EX(pObj->m_strName,@"MirrorVector",0);
                    SET_STAGE_EX(pObj->m_strName,@"Alpha",0);
                    SET_STAGE_EX(pObj->m_strName,@"Wave", 0);
                    

                }
                break;

                case 2:
                {
#ifdef DEMO                    
                    NSString *iTunesLink = @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=443906995&mt=8"; 
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
                    
                    GObject *pObFade=[m_pObjMng GetObjectByName:@"Fade"];
                    
                    if(pObFade==nil){
                        CGPoint TmpPoint;
                        [self touchesEndedOut:nil WithPoint:TmpPoint];
                    }
                    return;
#endif

                    GObject *pObj;

                    SET_STAGE_EX(pObject->m_strName,@"MirrorVector",0);
                    SET_STAGE_EX(pObject->m_strName,@"Alpha",1);
                    
                    pObj=[pArray objectAtIndex:0];
                    SET_STAGE_EX(pObj->m_strName,@"Slider",4);
                    SET_STAGE_EX(pObj->m_strName,@"MirrorVector",1);
                    SET_STAGE_EX(pObj->m_strName,@"Alpha",0);
                    SET_STAGE_EX(pObj->m_strName,@"Wave", 0);

                    mColor.alpha=1;
                    
                    pObj=[pArray objectAtIndex:1];
                    SET_STAGE_EX(pObj->m_strName,@"Slider",4);
                    SET_STAGE_EX(pObj->m_strName,@"MirrorVector",0);
                    SET_STAGE_EX(pObj->m_strName,@"Alpha",0);
                    SET_STAGE_EX(pObj->m_strName,@"Wave", 0);

                }
                    break;

                default:
                    break;
            }
            break;
        }

        Count++;
    }
    
    SET_STAGE(@"Fade2", 2);

    [self SetTouch:NO];
    SET_STAGE_EX(m_strName,@"Wave", 0);

    SET_STAGE_EX(m_strName,@"Slider",4);

    if(Count==1){
        GObject *pObject=[pArray objectAtIndex:0];
        [pArray removeObjectAtIndex:0];
        [pArray addObject:pObject];
    }
    else if(Count==2){
        GObject *pObject=[pArray objectAtIndex:2];
        [pArray removeObjectAtIndex:2];
        [pArray insertObject:pObject atIndex:0];
    }
    
    GObject *pObj=[pArray objectAtIndex:0];
    
    int TmpCompl=0;
    if(NAME(pObj)==@"ButtonDif3")TmpCompl=2;
    if(NAME(pObj)==@"ButtonDif2")TmpCompl=1;
        
    OBJECT_SET_PARAMS(@"Field",SET_FLOAT(@"m_iComplexity",TmpCompl),nil);
    
    OBJECT_PERFORM_SEL(@"Hint", @"Disable");
    OBJECT_PERFORM_SEL(@"Field", @"StartNewField");
    OBJECT_PERFORM_SEL(@"Field", @"ResetGhost");
}
//------------------------------------------------------------------------------------------------------
- (void)wave:(Processor *)pProc{
	
	float OffsetScale=6*sin(m_fPhase);
	
	m_pCurScale.x=mWidth*0.5f+OffsetScale;
	m_pCurScale.y=mHeight*0.5f-OffsetScale;
    m_fPhase+=DELTA*m_fSpeedScale;
}
//------------------------------------------------------------------------------------------------------
- (void)FinishShow:(Processor *)pProc{
    
    if(self->m_bTouch==NO)
        [self SetTouch:YES];

    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)FinishHide:(Processor *)pProc{
    m_pCurPosition=m_vStartPos;
    
    if(m_strName==@"ButtonDif3"){
        [self InitAllButton];
    }
    
    SET_STAGE_EX(NAME(self),@"Slider",0);
}
//------------------------------------------------------------------------------------------------------
- (void)Alpha:(Processor *)pProc{
    mColor.alpha=TmpSlider;
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT