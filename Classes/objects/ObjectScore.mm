//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectScore.h"

@implementation ObjectScore
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
	m_bHiden=TRUE;
	m_iLayer = layerInvisible;

	mWidth  = 50;
	mHeight = 50;

    WSym=30;
    HSym=50;

	m_fWNumber=30;

START_QUEUE(@"Proc");
    ASSIGN_STAGE(@"Move",@"MoveScore:",nil);
END_QUEUE(@"Proc");

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
        
    m_strStartStage=[NSMutableString stringWithString:@"Idle"];
    
    SET_CELL(LINK_STRING_V(m_strStartStage,m_strName,@"m_strStartStage"));

    SET_CELL(LINK_FLOAT_V(WSym,m_strName,@"WSym"));
    SET_CELL(LINK_FLOAT_V(HSym,m_strName,@"HSym"));

    SET_CELL(LINK_FLOAT_V(m_fWNumber,m_strName,@"m_fWNumber"));

    SET_CELL(LINK_INT_V(iScoreAdd,m_strName,@"iScoreAdd"));
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
	
	[super Start];

    if(m_iLayer==layerTemplet)m_iLayer--;
    
	for (int i=0; i<20; i++) {
		
		GObject *Ob = CREATE_NEW_OBJECT(@"ObjectSymbol",([NSString stringWithFormat:@"sym%d", i]),
                                LINK_STRING_V(m_pNameTexture, @"m_pNameTexture"),
                                LINK_ID_V(self,@"m_pOwner"),
                                SET_INT_V(0,@"m_iCurrentSym"),
                    SET_VECTOR_V(Vector3DMake(i*m_fWNumber,0,0),@"m_pOffsetCurPosition"),
                                SET_BOOL_V(YES,@"m_bHiden"),
                                SET_BOOL_V(m_bNoOffset,@"m_bNoOffset"),
                                SET_BOOL_V(YES, @"m_bDimFromTexture"),
//                                SET_FLOAT_V(WSym,@"mWidth"),
//                                SET_FLOAT_V(HSym,@"mHeight"),
                                SET_BOOL_V(m_bNoOffset, @"m_bNoOffset"),
                                SET_INT_V(m_iLayer+1,@"m_iLayer"));

        SET_STAGE_EX(NAME(Ob), @"Proc", m_strStartStage);        
		[m_pChildrenbjectsArr addObject:Ob];
	}

	[self SetColorSym];

	[self UpdateScore];
	UPDATE;
}
//------------------------------------------------------------------------------------------------------
-(void)SetColorSym{
	
	for(GObject *pOb in m_pChildrenbjectsArr)
		OBJECT_SET_PARAMS(pOb->m_strName,SET_COLOR_V(mColor,@"mColor"));
	
	UPDATE;
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateScore{

	iCountScore+=iScoreAdd;

	NSMutableArray *pArrayScore = [[self ParseIntValue:iCountScore] autorelease];
	NSMutableArray *TmpArr=m_pChildrenbjectsArr;

	for (int i=0; i< [TmpArr count]; i++)
		OBJECT_SET_PARAMS(((GObject *)[TmpArr objectAtIndex:i])->m_strName,
						  SET_BOOL_V(YES,@"m_bHiden"));

	if ([pArrayScore count]==0 && [TmpArr count]!=0) {

		OBJECT_SET_PARAMS(((GObject *)[TmpArr objectAtIndex:0])->m_strName,
						  SET_INT_V(0,@"m_iCurrentSym"),
						  SET_VECTOR_V(Vector3DMake(0,0,0),@"m_pOffsetCurPosition"),
						  SET_BOOL_V(NO,@"m_bHiden"));		
	}
	else for (int i=0; i< [pArrayScore count]; i++) {

		OBJECT_SET_PARAMS(((GObject *)[TmpArr objectAtIndex:i])->m_strName,
            SET_INT_V([[pArrayScore objectAtIndex:[pArrayScore count]-i-1] intValue],@"m_iCurrentSym"),
                    SET_VECTOR_V(Vector3DMake(i*m_fWNumber,0,0),@"m_pOffsetCurPosition"),
						  SET_BOOL_V(NO,@"m_bHiden"));
	}

	UPDATE;
}
//------------------------------------------------------------------------------------------------------
- (void)MoveScore:(Processor_ex *)pProc{
    if(iScoreAdd){

        [self UpdateScore];
        iScoreAdd=0;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end