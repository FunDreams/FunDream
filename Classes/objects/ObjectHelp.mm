//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectHelp.h"

@implementation NAME_TEMPLETS_OBJECT
//-----------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
    
    [self SetTouch:YES];
	m_iLayer = layerInterfaceSpace6;

	mWidth  = 50;
	mHeight = 50;

	mColor.alpha=0;
		
	return self;
}
//-----------------------------------------------------------------------------------------------
- (void)GetParams:(CParams *)Parametrs{[super GetParams:Parametrs];}
//-----------------------------------------------------------------------------------------------
- (void)SetParams:(CParams *)Parametrs{
    [super SetParams:Parametrs];
    
    COPY_IN_INT(m_iCountHelp);
}
//-----------------------------------------------------------------------------------------------
- (void)Start{

    mColor.alpha=1;
    
    START_PROC(@"Proc");
	
//	UP_POINT(@"p00_f_Instance",&mColor.alpha);
//	UP_CONST_FLOAT(@"s00_f_Instance",0);
//	UP_CONST_FLOAT(@"f00_f_Instance",1);
//	UP_CONST_FLOAT(@"s00_f_vel",2.0f);
//	UP_SELECTOR(@"e00",@"AchiveLineFloat:");
	
	UP_SELECTOR(@"e01",@"Idle:");
    
//	UP_POINT(@"p02_f_Instance",&mColor.alpha);
//	UP_CONST_FLOAT(@"s02_f_Instance",1);
//	UP_CONST_FLOAT(@"f02_f_Instance",0);
//	UP_CONST_FLOAT(@"s02_f_vel",-2.0f);
//	UP_SELECTOR(@"e02",@"AchiveLineFloat:");
    
	UP_SELECTOR(@"e03",@"DestroySelf:");
	
    END_PROC(@"Proc");

	[super Start];
}
//-----------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    if([self FindProcByName:@"Proc"]->m_pICurrentStage==1){
        [[self FindProcByName:@"Proc"] NextStage];
    }
}
//-----------------------------------------------------------------------------------------------
- (void)Move{}
//-----------------------------------------------------------------------------------------------
- (void)Destroy{

    if(m_iCountHelp<3)
    {
        NSString *pStrNameTexture=nil;
        
        if(m_iCountHelp==0)
            pStrNameTexture = [NSString stringWithString:@"hlp2.jpg"];
        
        if(m_iCountHelp==1)
            pStrNameTexture = [NSString stringWithString:@"hlp3.jpg"];
        
        if(m_iCountHelp==2)
            pStrNameTexture = [NSString stringWithString:@"hlp4.jpg"];
       
        CREATE_NEW_OBJECT(@"ObjectHelp",@"Help",
                          SET_INT(@"m_iCountHelp", m_iCountHelp+1),
                          SET_STRING(@"m_pNameTexture",pStrNameTexture),
                          SET_FLOAT(@"mWidth",960),
                          SET_FLOAT(@"mHeight",640),
                          SET_VECTOR(@"m_pCurPosition",(TmpVector1=Vector3DMake(0.0f,0.0f,0.0f))),
                          SET_INT(@"m_iLayer",layerInterfaceSpace6),
                          SET_BOOL(@"m_bNoOffset",YES),
                          SET_BOOL(@"m_bNonStop", YES),
                          nil);
    }
    else SET_STAGE(@"GameShef",7);


    [super Destroy];
}
//-----------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT