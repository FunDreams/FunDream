//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectGameShef.h"

#define STEP_BARIER 100
@implementation NAME_TEMPLETS_OBJECT
//-----------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
	mWidth  = 50;
	mHeight = 50;
    m_iBarier=STEP_BARIER;
	
	m_bHiden=YES;
    m_bNewRecord=NO;
	
	START_PROC(@"Proc");
	UP_SELECTOR(@"e00",@"Idle:");
	UP_SELECTOR(@"e01",@"InterfaceToGame:");
	UP_SELECTOR(@"e02",@"Idle:");
	UP_SELECTOR(@"e03",@"GameToInterface:");
	UP_SELECTOR(@"e04",@"Idle:");
	UP_SELECTOR(@"e05",@"NoSpaun:");
	UP_SELECTOR(@"e06",@"Idle:");
	UP_SELECTOR(@"e07",@"HelpToInterface:");
	UP_SELECTOR(@"e08",@"Idle:");
	UP_SELECTOR(@"e09",@"InterfaceToHelp:");
	UP_SELECTOR(@"e10",@"Idle:");
	END_PROC(@"Proc");   
    
	LOAD_SOUND(iIdSound_StartGame,@"start.wav",NO);

	return self;
}
//-----------------------------------------------------------------------------------------------
- (void)GetParams:(CParams *)Parametrs{
    
    COPY_OUT_BOOL(m_bNewRecord);
    
    [super GetParams:Parametrs];
}
//-----------------------------------------------------------------------------------------------
- (void)SetParams:(CParams *)Parametrs{[super SetParams:Parametrs];}
//-----------------------------------------------------------------------------------------------
- (void)Start{[super Start];}
//-----------------------------------------------------------------------------------------------
- (void)Move{
    
    int CountScore=GET_INT(@"Score",@"iCountScore");
    int CountBest=GET_INT(@"Best",@"iCountScore");
    
    if(CountScore>CountBest){
        
        PARAMS_APP->m_iCurRecord=CountScore;

        OBJECT_SET_PARAMS(@"Best",SET_INT(@"iCountScore",CountScore),nil);
        OBJECT_PERFORM_SEL(@"Best", @"Update");
        m_bNewRecord=YES;
        
        [PARAMS_APP Save];
    }
    
    
    NSMutableArray *pArray=[m_pObjMng->m_pGroups objectForKey:@"life"];
	int iCount= [pArray count];
    
    if(CountScore>=m_iBarier && iCount==3)m_iBarier+=STEP_BARIER;
        
    if(iCount<3 && CountScore>=m_iBarier){
        
        m_iBarier+=STEP_BARIER;
        
        int iTmpCount=0;
        if(iCount==1)iTmpCount=1;
        
        NSString *pStrName = [NSString stringWithFormat:@"life%d",3-iTmpCount];
        
        GObject *TmpOb = [m_pObjMng GetObjectByName:pStrName];
        
        if(TmpOb){
            
            SET_STAGE_EX(TmpOb->m_strName, @"Proc", 0);
            [m_pObjMng AddToGroup:@"life" Object:TmpOb];

            
        }
        else{
            
            CREATE_NEW_OBJECT(@"ObjectLifeShef",pStrName,
                            SET_VECTOR(@"m_pCurPosition",(TmpVector1=Vector3DMake(180+iTmpCount*80,360,0))),
                            SET_VECTOR(@"m_vStart",(TmpVector2=Vector3DMake(180+iTmpCount*80,360,0))),
                            SET_VECTOR(@"m_vEnd",(TmpVector3=Vector3DMake(180+iTmpCount*80,260,0))),
                            SET_BOOL(@"m_bNoOffset",YES),
                            nil);
        }
    }
    
}
//-----------------------------------------------------------------------------------------------
- (void)NoSpaun:(Processor *)pProc{
	
	SET_STAGE(@"Spaun",0);
	SET_STAGE_EX(@"Spaun",@"Proc2",0);
    SET_STAGE_EX(@"Spaun",@"Proc3",0);

	SET_STAGE_EX(@"Drunk",@"Proc3",3);
}
//-----------------------------------------------------------------------------------------------
- (void)InterfaceToGame:(Processor *)pProc{
	    
    CREATE_NEW_OBJECT(@"ObjectButton",@"ButtonPause",
					  SET_STRING(@"m_DOWN",@"pause_2.png"),
					  SET_STRING(@"m_UP",@"pause_1.png"),
					  SET_INT(@"mWidth",70),
					  SET_INT(@"mHeight",70),
					  SET_VECTOR(@"m_pCurPosition",(TmpVector1=Vector3DMake(440,280,0))),
					  SET_BOOL(@"m_bNoOffset",YES),
                      SET_BOOL(@"m_bNonStop", YES),
					  nil);	

	SET_STAGE(@"ButtonPlay",5);
	SET_STAGE(@"ButtonHelp",5);
	SET_STAGE(@"Fade",2);
            
    if(!m_pObjMng->m_bGlobalPause){
        
        OBJECT_SET_PARAMS(@"Spaun",SET_FLOAT(@"m_fTime",0),nil);
        SET_STAGE(@"Spaun",1);
        SET_STAGE_EX(@"Spaun",@"Proc2",1);
        SET_STAGE_EX(@"Spaun",@"Proc3",1);
        
        CREATE_NEW_OBJECT(@"ObjectLifeShef",@"life1",
                                    SET_VECTOR(@"m_pCurPosition",(TmpVector1=Vector3DMake(340,360,0))),
                                    SET_VECTOR(@"m_vStart",(TmpVector2=Vector3DMake(340,360,0))),
                                    SET_VECTOR(@"m_vEnd",(TmpVector3=Vector3DMake(340,260,0))),
                                    SET_BOOL(@"m_bNoOffset",YES),
                                    nil);
        
        CREATE_NEW_OBJECT(@"ObjectLifeShef",@"life2",
                                    SET_VECTOR(@"m_pCurPosition",(TmpVector1=Vector3DMake(260,360,0))),
                                    SET_VECTOR(@"m_vStart",(TmpVector2=Vector3DMake(260,360,0))),
                                    SET_VECTOR(@"m_vEnd",(TmpVector3=Vector3DMake(260,260,0))),
                                    SET_BOOL(@"m_bNoOffset",YES),
                                    nil);
        
        
        CREATE_NEW_OBJECT(@"ObjectLifeShef",@"life3",
                                    SET_VECTOR(@"m_pCurPosition",(TmpVector1=Vector3DMake(180,360,0))),
                                    SET_VECTOR(@"m_vStart",(TmpVector2=Vector3DMake(180,360,0))),
                                    SET_VECTOR(@"m_vEnd",(TmpVector3=Vector3DMake(180,260,0))),
                                    SET_BOOL(@"m_bNoOffset",YES),
                                    nil);
        
        OBJECT_SET_PARAMS(@"TouchQueue",SET_BOOL(@"m_bEnable",YES),nil);
        OBJECT_SET_PARAMS(@"Score",SET_INT(@"iCountScore",0),nil);
        OBJECT_PERFORM_SEL(@"Score",@"Update")
        
        PLAY_SOUND(iIdSound_StartGame);
        m_bNewRecord=NO;
    }
    else [m_pObjMng->m_pParent Pause:NO];
	
	NEXT_STAGE;
}
//-----------------------------------------------------------------------------------------------
- (void)GameToInterface:(Processor *)pProc{
	
	CREATE_NEW_OBJECT(@"ObjectFade",@"Fade",
					  SET_INT(@"m_iLayer",layerInvisible),
					  SET_COLOR(@"mColor",(TmpColor1=Color3DMake(0, 0, 0, 0.0f))),
					  SET_FLOAT(@"mWidth",960),
					  SET_FLOAT(@"mHeight",640),
                      SET_BOOL(@"m_bNoOffset",YES),
                      SET_BOOL(@"m_bNonStop", YES),
					  nil);

	CREATE_NEW_OBJECT(@"ObjectButton",@"ButtonPlay",
					  SET_STRING(@"m_DOWN",@"ButtonPlayDown.png"),
					  SET_STRING(@"m_UP",@"ButtonPlayUp.png"),
					  SET_INT(@"mWidth",300),
					  SET_INT(@"mHeight",300*FACTOR_DEC),
					  SET_VECTOR(@"m_pCurPosition",(TmpVector1=Vector3DMake(150,0,0))),
					  SET_BOOL(@"m_bNoOffset",YES),
                      SET_BOOL(@"m_bNonStop", YES),
					  nil);	

    CREATE_NEW_OBJECT(@"ObjectButton",@"ButtonHelp",
					  SET_STRING(@"m_DOWN",@"Help_2.png"),
					  SET_STRING(@"m_UP",@"Help_1.png"),
					  SET_INT(@"mWidth",300),
					  SET_INT(@"mHeight",300*FACTOR_DEC),
					  SET_VECTOR(@"m_pCurPosition",(TmpVector1=Vector3DMake(-150,0,0))),
					  SET_BOOL(@"m_bNoOffset",YES),
                      SET_BOOL(@"m_bNonStop", YES),
					  nil);
    
    SET_STAGE(@"ButtonPause",5);

	NEXT_STAGE;
}
//-----------------------------------------------------------------------------------------------
- (void)HelpToInterface:(Processor *)pProc{
    OBJECT_SET_PARAMS(@"ButtonPlay",SET_BOOL(@"m_Disable",NO),nil);
    OBJECT_SET_PARAMS(@"ButtonPause",SET_BOOL(@"m_Disable",NO),nil);
    OBJECT_SET_PARAMS(@"ButtonHelp",SET_BOOL(@"m_Disable",NO),nil);
}
//-----------------------------------------------------------------------------------------------
- (void)InterfaceToHelp:(Processor *)pProc{
    OBJECT_SET_PARAMS(@"ButtonPlay",SET_BOOL(@"m_Disable",YES),nil);
    OBJECT_SET_PARAMS(@"ButtonPause",SET_BOOL(@"m_Disable",YES),nil);
    OBJECT_SET_PARAMS(@"ButtonHelp",SET_BOOL(@"m_Disable",YES),nil);
}
//-----------------------------------------------------------------------------------------------
- (void)Destroy{}
//-----------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//-----------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT

