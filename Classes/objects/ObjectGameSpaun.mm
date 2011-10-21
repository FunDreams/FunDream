//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectGameSpaun.h"

@implementation ObjectGameSpaun
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
START_QUEUE(@"Proc");
//	ASSIGN_STAGE(@"Idle",@"Idle:",nil);
	ASSIGN_STAGE(@"Spaun",@"Spaun:",nil);
END_QUEUE(@"Proc");
    
    m_bHiden=YES;
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    
//   SET_CELL(LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY"));
    
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    SET_CELL(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"));
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    m_iLayer = layerSystem;

	[super Start];
    
    m_fStartPeriod=3;
    m_fCurrntPeriod=m_fStartPeriod;
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
//------------------------------------------------------------------------------------------------------
- (void)Spaun{
    
    CREATE_NEW_OBJECT(@"ObjectPSimple", @"PushSimple", nil);
    //    CREATE_NEW_OBJECT(@"ObjectPSimple", @"PushSimple", nil);
    //    CREATE_NEW_OBJECT(@"ObjectPSimple", @"PushSimple", nil);

}
//------------------------------------------------------------------------------------------------------
- (void)Spaun:(Processor_ex *)pProc{
    
    m_fCurrntPeriod-=DELTA;
    
    if(m_fCurrntPeriod<0){
        
        [self Spaun];
        m_fCurrntPeriod=m_fStartPeriod;
        
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end