//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectAura.h"

#define Usechenie 15
#define LINIT_AURA_NUM 30

@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];

    m_iLayerTouch=layerOb2;
	m_iLayer = layerOb3;

	mWidth  = 300;
	mHeight = 150;

    if([self->m_pParent isDeviceAniPad])Width2=160;
    else Width2=280;
    
    float VelTrans=2;

	[self SelfOffsetVert:Vector3DMake(0,1,0)];
	
	m_pIntervals = [[NSMutableArray alloc] init];
    
    LOAD_SOUND(iIdSound,@"postanovka_zifry1.wav",NO);
    LOAD_SOUND(iIdChangemNum,@"smena_zifr.wav",NO);
    LOAD_SOUND(iIdError,@"error.wav",NO);
    LOAD_SOUND(iIdZero,@"delet.wav",NO);
	
    
    START_PROC(@"Proc");
    
	UP_POINT(@"p2_f_Instance",&mColor.alpha);
	UP_CONST_FLOAT(@"f2_f_Instance",1);
	UP_CONST_FLOAT(@"s2_f_Instance",0);
	UP_CONST_FLOAT(@"s2_f_vel",VelTrans);
	UP_SELECTOR(@"e2",@"AchiveLineFloat:");
	
	UP_SELECTOR(@"e3",@"Idle:");
    
	UP_SELECTOR(@"e4",@"ActionRemove:");
    
	UP_POINT(@"p5_f_Instance",&mColor.alpha);
	UP_CONST_FLOAT(@"f5_f_Instance",0);
    //	UP_CONST_FLOAT(@"s5_f_Instance",1);
	UP_CONST_FLOAT(@"s5_f_vel",-VelTrans);
	UP_SELECTOR(@"e5",@"AchiveLineFloat:");
    
    //	UP_SELECTOR(@"e06",@"Idle:");
    
	UP_SELECTOR(@"e6",@"DestroySelf:");
    
    END_PROC(@"Proc");	

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)GetParams:(CParams *)Parametrs{
    [super GetParams:Parametrs];
    
    COPY_OUT_POINT(m_pCellNum);
}
//------------------------------------------------------------------------------------------------------
- (void)SetParams:(CParams *)Parametrs{
		
	[super SetParams:Parametrs];
	
	COPY_IN_POINT(m_pCellNum,GObject);
	COPY_IN_VECTOR(m_vOffsetStart);
    COPY_IN_FLOAT(m_fCurrentTouchX);
    COPY_IN_FLOAT(m_fCurrentTouchASS);

    COPY_IN_FLOAT(m_fStartX);
    COPY_IN_INT(m_iPlace);
}
//------------------------------------------------------------------------------------------------------
- (void)DestroyChildrenArray{
	
	for(int i=0;i<[m_pChildrenbjectsArr count];i++)
		DESTROY_OBJECT([m_pChildrenbjectsArr  objectAtIndex:i]);
	
	[m_pChildrenbjectsArr removeAllObjects];
	
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];
	
	[self DestroyChildrenArray];
    
//    PARAMS_APP->Numbers[m_iSelNumber-1]--;

	m_iCountNum=10;

//	float fStep=(620)/m_iCountNum-1;
	
//	m_fCurrentTouchASS=LINIT_AURA_NUM+fStep*(7);
//	m_fCurrentTouchX=m_fCurrentTouchASS;
	
//    NSLog(@"Array");

	for (int i=0; i<10; i++) {
		
		NSString* pName=[NSString stringWithFormat:@"NumberAura%d", i];

        GObject* Ob=nil;
        int TmpSym=0;
        
        if(m_fStartX>0){
            
            if(i==9){
                TmpSym=0;
            }
            else TmpSym=i+1;
        }
        else {
            TmpSym=i;
        }

        
        if(TmpSym!=0)
            
            if(PARAMS_APP->Numbers2[TmpSym-1]==9){
                m_iCountNum--;
                continue;
        }

        Ob =  CREATE_NEW_OBJECT(@"ObjectNumSudoku2",pName,
                 SET_POINT(@"m_pOwner",@"id",self),
                 SET_INT(@"m_iCurrentSym",TmpSym),
                 SET_INT(@"m_iLayer",layerInterfaceSpace5),
                 SET_VECTOR(@"m_pOffsetCurAngle",(TmpVector1=Vector3DMake(0,0,0))),
                 SET_VECTOR(@"m_pOffsetCurPosition",m_vOffsetStart),
                 SET_VECTOR(@"m_pCurPosition",m_pCurPosition),
                 SET_VECTOR(@"m_vCurSourcePoint",m_vOffsetStart),
                 nil);

		[m_pChildrenbjectsArr addObject:Ob];
		OBJECT_PERFORM_SEL(Ob->m_strName,@"Move");
	}

//    m_iPlace;

    StepAura=(Width2*2)/m_iCountNum;

    int iCurrentNum=m_iCountNum/2;
    
    float fPopravka=((float)(m_iCountNum))/2-iCurrentNum;
//    NSLog(@"%d",iCurrentNum);
    
    if(m_iCountNum%2==0)shift=-m_fStartX-StepAura*0.5f;
    else shift=-m_fStartX;
    
    int iSdvig=0;
    
    float TmpWidth=GET_INT(@"Field",@"mWidth");
repeate:
    
    if(m_fStartX>0){
        
        float TmpFloat = StepAura*(iCurrentNum+fPopravka)-shift;
        float TmpFloat2 = TmpWidth*0.5f;
        
        if(TmpFloat>TmpFloat2 && (iCurrentNum+iSdvig)>0){

            iSdvig--;
            shift+=StepAura;
            goto repeate;
        }
    }
    else
    {
        float TmpFloat = shift+StepAura*(m_iCountNum-iCurrentNum-1-fPopravka);
        float TmpFloat2 = TmpWidth*0.5f;

        if(TmpFloat+(0.5f)*StepAura+20>TmpFloat2 && (iCurrentNum+iSdvig)>0){
            
            iSdvig++;
            shift-=StepAura;
            goto repeate;
        }
    }
    
    iCurrentNum+=iSdvig;
    
    StepAura2=(mWidth-Usechenie)/(m_iCountNum+3);
    
    for (int i=0; i<m_iCountNum; i++) {
        GooPlace[i]=i*StepAura2+StepAura2*2;
    }

    LastPlace=GooPlace[iCurrentNum];
/////////////////////////////////////////////////////
	mColor.alpha=0;

    m_fCurrentTouchASS=LastPlace;
    m_fCurrentTouchX=LastPlace;

    TmpPoint.x=m_fStartX;
    [self Intersect:TmpPoint];
	[self SetTouch:YES];
    [self UpdateNum];
    
    PLAY_SOUND(iIdChangemNum);
}
//------------------------------------------------------------------------------------------------------
- (void)reset{
    
    m_fCurrentTouchX=m_fCurrentTouchASS;
    
    [self Intersect:TmpPoint];

    [self UpdateNum];
}
//------------------------------------------------------------------------------------------------------
- (void)Move{
	
    int iStage=GET_STAGE_EX(NAME(self), @"Proc");
    
    if(iStage!=5 && iStage!=6){
        
        float Interval=LastPlace-m_fCurrentTouchASS;
        
        if(((m_fCurrentTouchASS<LastPlace && LastPlace==GooPlace[0]) ||
            m_fCurrentTouchASS>LastPlace && LastPlace==GooPlace[m_iCountNum-1])){
            
            float Interval2=LastPlace-m_fCurrentTouchX;
            
            m_fCurrentTouchX+=Interval2*DELTA*10;
            
            [self UpdateNum];

            
        }
        else{
               
            if(fabs(Interval)>StepAura2){
                
                int MinIndex=0;
                float MinInterval=1000;
                for (int i=0; i<m_iCountNum; i++) {
                    float TmpInterval=fabs(m_fCurrentTouchASS-GooPlace[i]);
                    if(TmpInterval<MinInterval)
                    {
                        MinIndex=i;
                        MinInterval=TmpInterval;
                    }
                }
                
                LastPlace=GooPlace[MinIndex];
                
                PLAY_SOUND(iIdChangemNum);
                
            }
            else {
                
                if(fabs(Interval)>(StepAura2-StepAura2*0.3f)){
                    
                    float Interval2=(m_fCurrentTouchASS-m_fCurrentTouchX)*0.1f;
                    
                    m_fCurrentTouchX+=Interval2*DELTA*10;
                    [self UpdateNum];
                }
                else{
                    
                    float Interval2=LastPlace-m_fCurrentTouchX;
                    
                    m_fCurrentTouchX+=Interval2*DELTA*10;
                    
                    [self UpdateNum];
                }
            }   
        }
    }
    
    OBJECT_SET_PARAMS(m_pCellNum->m_strName,
                      SET_COLOR(@"mColor",(TmpColor1=Color3DMake(1,1,1,mColor.alpha))),
                      nil);
}
//------------------------------------------------------------------------------------------------------
- (void)ActionRemove:(Processor *)pProc{
	[self SetTouch:NO];
	NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateNum{
	
	[m_pIntervals removeAllObjects];
	
	float fStep=(mWidth-Usechenie)/(m_iCountNum+3);
	float R=fStep;
	float MaxInterval=0;

	for (int i=0; i<m_iCountNum+3; i++) {

		float Point1=(i)*(float)fStep;
		float Point2=(i+1)*(float)fStep;
		
		float fInterval=0;
		
		if(i!=0 && i!=m_iCountNum+2){
			if(fabs(Point1-m_fCurrentTouchX)<R){
				Point1-=10*pow((R-fabs(Point1-m_fCurrentTouchX)),1);
			}

			if(fabs(Point2-m_fCurrentTouchX)<R){
				Point2+=10*pow((R-fabs(Point2-m_fCurrentTouchX)),1);
			}
			
			fInterval=fabs(Point2-Point1);
			MaxInterval+=fInterval;			
		}
		else fInterval=fabs(Point2-Point1);
		
		NSNumber *Num = [NSNumber numberWithFloat:fInterval];
		[m_pIntervals addObject:Num];
	}	
	
	float fStandartIntervals=fStep*(m_iCountNum+1);
	float K=fStandartIntervals/MaxInterval;
	
	NSNumber *Num1= [m_pIntervals objectAtIndex:0];
	float tmpInt1= [Num1 floatValue];

	float fStartPoint=-(mWidth-Usechenie)*0.5f+tmpInt1;

	float fMaxScale=0;
    ObCurItems=nil;
	for (int i=1; i<m_iCountNum+1; i++) {
		
		NSNumber *Num= [m_pIntervals objectAtIndex:i];
		float tmpInt= [Num floatValue];

		NSNumber *NumNext= [m_pIntervals objectAtIndex:i+1];
		float tmpIntNext= [NumNext floatValue];

		float fScale=25;
		if(tmpInt*K>fStep){fScale+=0.1f*(tmpInt*K-fStep);}
		if(tmpIntNext*K>fStep){fScale+=0.1f*(tmpIntNext*K-fStep);}

		GObject *ObChild= [m_pChildrenbjectsArr objectAtIndex:i-1];

		if(fScale>fMaxScale){
			fMaxScale=fScale;
			ObCurItems = ObChild;
		}

		fStartPoint+=(tmpInt*K);
		OBJECT_SET_PARAMS(ObChild->m_strName,
            SET_VECTOR(@"m_vCurTargetPoint",(TmpVector1=Vector3DMake(fStartPoint,100,0))),
            SET_VECTOR(@"m_pCurScale",(TmpVector2=Vector3DMake(fScale,fScale,1))),
            SET_COLOR(@"mColor",(TmpColor1=Color3DMake(.3f,.3f,.3f,1))),
            nil);
        
        OBJECT_PERFORM_SEL(NAME(ObChild), @"Move");
	}
	    
    bool bTmpGhost=GET_BOOL(@"Field", @"m_bGhost");
    
    Color3D TmpColor;
    if(!bTmpGhost)
        TmpColor = Color3DMake(0,1,0,1);
    else TmpColor=Color3DMake(1,0.6f,1,1.0f);
    
	OBJECT_SET_PARAMS(ObCurItems->m_strName,SET_COLOR(@"mColor",TmpColor),nil);	
                      
	m_iSelNumber=GET_INT(ObCurItems->m_strName,@"m_iCurrentSym");
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy {
	
	[self DestroyChildrenArray];

    OldName=nil;
    
    int iType=0;
    
    bool bTmpGhost=GET_BOOL(@"Field", @"m_bGhost");
    
    GObject *pAura=(GObject*)GET_POINT(@"Field", @"ObAura");
    GObject *pCell;
    
    if(pAura!=nil){pCell=(GObject*)GET_POINT(NAME(pAura), @"m_pCellNum");}
    
    if(self==pAura || pCell!=m_pCellNum){
        
        if(bTmpGhost)iType=3;
        
        if(m_iSelNumber==0){
            OBJECT_SET_PARAMS(m_pCellNum->m_strName,
                              SET_BOOL(@"m_bHiden",YES),
                              SET_INT(@"m_iCurrentSym",m_iSelNumber),
                              SET_INT(@"iType",iType),
                              nil);
        }
        else{
            OBJECT_SET_PARAMS(m_pCellNum->m_strName,
                              SET_BOOL(@"m_bHiden",NO),
                              SET_INT(@"m_iCurrentSym",m_iSelNumber),
                              SET_INT(@"iType",iType),
                              nil);            
        }
        
        OBJECT_PERFORM_SEL(NAME(m_pCellNum), @"SetType");
        OBJECT_PERFORM_SEL(NAME(m_pCellNum), @"Move");
    //    SET_STAGE_EX(NAME(m_pCellNum), @"Error", 0);

        int TmpI=GET_INT(NAME(m_pCellNum),@"m_iCurNum");
        OBJECT_SET_PARAMS(@"Field",
                          SET_INT(@"m_iCurIndex",TmpI),
                          SET_POINT(@"ObAura", @"id", nil),
                          nil);
        
        OBJECT_PERFORM_SEL(@"Field",@"Validation");
        
        int  m_iCountError=GET_INT(@"Field", @"m_iCountError");
        
        bool bError=GET_BOOL(NAME(m_pCellNum), @"bError");
        if(m_iCountError>0){
            
            if(m_iSelNumber==0){PLAY_SOUND(iIdZero)}
            else if(bError==YES){PLAY_SOUND(iIdError);}
            else {PLAY_SOUND(iIdSound);}
        }
        else {
            
            if(m_iSelNumber==0){PLAY_SOUND(iIdZero)}
            else PLAY_SOUND(iIdSound);
        }
    }
    
    SET_STAGE_EX(@"Field", @"ProcSave", 0);

	UPDATE;
}
//------------------------------------------------------------------------------------------------------
- (bool)Intersect:(CGPoint)pPoint{
    
    int iBound=Width2;
    TmpPoint=pPoint;
    
//    if(TmpPoint.x<-iBound+StepAura*0.5f+shift)TmpPoint.x=-iBound+shift+StepAura*0.5f;
//    if(TmpPoint.x>iBound-StepAura*0.5f+shift)TmpPoint.x=iBound+shift-StepAura*0.5f;
    
    SET_MIRROR(m_fCurrentTouchASS,TmpPoint.x,iBound+shift,-(iBound+shift),LINIT_AURA_NUM,
               (mWidth-Usechenie)-LINIT_AURA_NUM);
    
//    NSLog(@"%1.1f",m_fCurrentTouchASS);
    return YES;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    LOCK_TOUCH;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    LOCK_TOUCH;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    LOCK_TOUCH;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEndedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
	SET_STAGE(m_strName,4);
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
	SET_STAGE(m_strName,4);
    
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {
	[super dealloc];
	
	[m_pIntervals release];
}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT