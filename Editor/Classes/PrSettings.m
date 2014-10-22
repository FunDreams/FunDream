//
//  Object.m
//  Engine
//
//  Created by Konstantin on 02.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "PrSettings.h"

@implementation CPrSettings

//------------------------------------------------------------------------------------------------------

- (id)init
{
    self = [super init];
    if (self)
    {
        m_pPlManager = [[CPlManager alloc] init];
#ifdef SUDOKU
        bGhost=NO;
#endif
//	    m_iCurRecord = 0;
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------
- (bool) Load
{

	m_iCurRecord = [m_pPlManager GetKeyIntValue:@"CurRecord"];
	
//#ifdef SUDOKU
//    TimerMain=[m_pPlManager GetKeyFloatValue:@"TimerMain"];
//    TimerEasy=[m_pPlManager GetKeyFloatValue:@"TimerEasy"];
//    TimerNormal=[m_pPlManager GetKeyFloatValue:@"TimerNormal"];
//    TimerHard=[m_pPlManager GetKeyFloatValue:@"TimerHard"];
//
//    iCompl=[m_pPlManager GetKeyIntValue:@"iCompl"];
//
//    bGhost=[m_pPlManager GetKeyBoolValue:@"bGhost"];
//    
//    for (int i=0; i<81; i++) {
//        
//        NumShowField[i]=[m_pPlManager GetKeyIntValue:[NSString stringWithFormat:@"Hiden%d",i]];
//        NumHidenField[i]=[m_pPlManager GetKeyIntValue:[NSString stringWithFormat:@"NumField%d",i]];
//        TypeField[i]=[m_pPlManager GetKeyIntValue:[NSString stringWithFormat:@"TypeField%d",i]];        
//    }    
//    
//#endif

	return true;
}	
//------------------------------------------------------------------------------------------------------
- (bool) Save
{	
	[m_pPlManager SetKeyIntValue:@"CurRecord" withValue:m_iCurRecord];
    
//#ifdef SUDOKU
//    [m_pPlManager SetKeyFloatValue:@"TimerMain" withValue:TimerMain];
//    [m_pPlManager SetKeyFloatValue:@"TimerEasy" withValue:TimerEasy];
//    [m_pPlManager SetKeyFloatValue:@"TimerNormal" withValue:TimerNormal];
//    [m_pPlManager SetKeyFloatValue:@"TimerHard" withValue:TimerHard];
//
//    [m_pPlManager SetKeyIntValue:@"iCompl" withValue:iCompl];
//
//    [m_pPlManager SetKeyBoolValue:@"bGhost" withValue:bGhost];
//
//    for (int i=0; i<81; i++) {
//
//    [m_pPlManager SetKeyIntValue:[NSString stringWithFormat:@"Hiden%d",i] withValue:NumShowField[i]];
//    [m_pPlManager SetKeyIntValue:[NSString stringWithFormat:@"NumField%d",i] withValue:NumHidenField[i]];
//    [m_pPlManager SetKeyIntValue:[NSString stringWithFormat:@"TypeField%d",i] withValue:TypeField[i]];
//        
//    }
//#endif
	
    [m_pPlManager->m_pDictionary synchronize];

	return true;
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {
	[super dealloc];
    
    [m_pPlManager release];
}
//------------------------------------------------------------------------------------------------------
@end
