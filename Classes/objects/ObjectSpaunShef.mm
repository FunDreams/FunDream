//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectSpaunShef.h"
#import "ObjectStaff.h"

@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
	m_iLayer = layerTemplet;

	mWidth  = 50;
	mHeight = 50;

	LOAD_SOUND(iIdSound,@"mouse_spaun.wav",NO);

	m_bHiden=YES;
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)GetParams:(CParams *)Parametrs{[super GetParams:Parametrs];}
//------------------------------------------------------------------------------------------------------
- (void)SetParams:(CParams *)Parametrs{
    [super SetParams:Parametrs];
    
    COPY_IN_FLOAT(m_fTime);
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];

START_PROC(@"Proc");
	
	UP_SELECTOR(@"a00",@"Idle:");
	UP_SELECTOR(@"a01",@"Spaun:");

	UP_SELECTOR(@"t02_5.0f",@"timerWaitNextStage:");
	UP_SELECTOR(@"a03",@"ChangePar:");

END_PROC(@"Proc");

START_PROC(@"Proc2");
	
	UP_SELECTOR(@"a00",@"Idle:");	
	UP_SELECTOR(@"t01_7.0",@"ChangeParKoktel:");
	
END_PROC(@"Proc2");

START_PROC(@"Proc3");
	
	UP_SELECTOR(@"a00",@"Idle:");	
	UP_SELECTOR(@"t01_10.0",@"SpaunRat:");
	
END_PROC(@"Proc3");
}
//------------------------------------------------------------------------------------------------------
- (void)Move{m_fTime+=DELTA;}
//------------------------------------------------------------------------------------------------------
- (void)Spaun:(Processor *)pProc{

	switch (RND%4) {
		case 0:
			CREATE_NEW_OBJECT(@"ObjectStaff",@"Apple",SET_INT(@"iType",apple),
							  SET_FLOAT(@"mWidth",274*FACTOR_INC),
							  SET_FLOAT(@"mHeight",224),
							  nil);			
			break;
		case 1:
			CREATE_NEW_OBJECT(@"ObjectStaff",@"Bread",SET_INT(@"iType",Bread),
							  SET_FLOAT(@"mWidth",508*FACTOR_INC),
							  SET_FLOAT(@"mHeight",195),
							  nil);	
			break;
		case 2:
			CREATE_NEW_OBJECT(@"ObjectStaff",@"carrot",SET_INT(@"iType",Carrot),
							  SET_FLOAT(@"mWidth",685*FACTOR_INC),
							  SET_FLOAT(@"mHeight",182),
							  nil);	
			break;
		case 3:
			CREATE_NEW_OBJECT(@"ObjectStaff",@"Tarelka",SET_INT(@"iType",Tarelka),
							  SET_FLOAT(@"mWidth",488*FACTOR_INC),
							  SET_FLOAT(@"mHeight",445),
							  nil);	
			break;
		default:
			break;
	}
	
	NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)ChangeParKoktel:(Processor *)pProc{

	CREATE_NEW_OBJECT(@"ObjectStaff",@"Koktel",SET_INT(@"iType",Koktel),
					  SET_FLOAT(@"mWidth",95),
					  SET_FLOAT(@"mHeight",114),
					  //	  SET_BOOL(@"m_bNoOffset",YES),
					  nil);	

	//	NSString *NameEx = [[[NSString alloc] initWithFormat:@"t01_%d",RND%2+1] autorelease];
	//	UP_SELECTOR(NameEx,@"timerWaitNextStage:");

	if(INTERVAL(m_fTime,0,30))
		{UP_SELECTOR(@"t02_6.2",@"timerWaitNextStage:");}
	else if(INTERVAL(m_fTime,30,90))
		{UP_SELECTOR(@"t02_3.4",@"timerWaitNextStage:");}
	else {UP_SELECTOR(@"t02_1.8",@"timerWaitNextStage:");}

	[pProc SetStage:1];
}
//------------------------------------------------------------------------------------------------------
- (void)SpaunRat:(Processor *)pProc{
	
    int CountScore=GET_INT(@"Score",@"iCountScore");
    
    if(CountScore>100){
        
        CREATE_NEW_OBJECT(@"ObjectRat",@"Rat",
                          SET_FLOAT(@"mWidth",152),
                          SET_FLOAT(@"mHeight",337),
                          nil);	

        PLAY_SOUND(iIdSound);
    }
    
    UP_SELECTOR(@"t02_6.0",@"timerWaitNextStage:");        
    [pProc SetStage:1];
}
//------------------------------------------------------------------------------------------------------
- (void)ChangePar:(Processor *)pProc{
	
//	NSString *NameEx = [NSString  stringWithFormat:@"t01_%2.2f",(float)(RND%2)+1];
//	UP_SELECTOR(NameEx,@"timerWaitNextStage:");
		
	if(INTERVAL(m_fTime,0,30))
		{UP_SELECTOR(@"t02_5.0",@"timerWaitNextStage:");}
	else if(INTERVAL(m_fTime,30,90))
		{UP_SELECTOR(@"t02_3.0",@"timerWaitNextStage:");}
	else {UP_SELECTOR(@"t02_1.5",@"timerWaitNextStage:");}

//	UP_SELECTOR(@"t01_1.5f",@"timerWaitNextStage:");

	[pProc SetStage:1];
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT