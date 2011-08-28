//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectScore.h"

@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
	m_bHiden=TRUE;
	m_iLayer = layerInvisible;

	mWidth  = 50;
	mHeight = 50;

    WSym=50;
    HSym=50;

	m_fWNumber=30;
    
    m_iStageSym=0;

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)GetParams:(CParams *)Parametrs{
    [super GetParams:Parametrs];
    
    COPY_OUT_INT(iCountScore);
}
//------------------------------------------------------------------------------------------------------
- (void)SetParams:(CParams *)Parametrs{
	[super SetParams:Parametrs];

	COPY_IN_INT(iCountScore);
	COPY_IN_INT(iScoreAdd);
	COPY_IN_STRING(m_pNameTexture);
    
    COPY_IN_FLOAT(WSym);
    COPY_IN_FLOAT(HSym);
    COPY_IN_FLOAT(m_fWNumber);
    
    COPY_IN_INT(m_iStageSym);
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
	
	[super Start];
	
	for (int i=0; i<8; i++) {
		
		GObject *Ob = CREATE_NEW_OBJECT(@"ObjectSymbol",([NSString stringWithFormat:@"sym%d", i]),
                                SET_POINT(@"m_pOwner",@"id",self),
                                SET_INT(@"m_iCurrentSym",0),
                                SET_VECTOR(@"m_pOffsetCurPosition",(TmpVector1=Vector3DMake(i*m_fWNumber,0,0))),
                                SET_BOOL(@"m_bHiden",YES),
                                SET_BOOL(@"m_bNoOffset",YES),
                                SET_FLOAT(@"mWidth", WSym),
                                SET_FLOAT(@"mHeight", HSym),
                                nil);
		
        [[Ob FindProcByName:@"Proc"] SetStage:m_iStageSym];
		[Ob Move];
		[m_pChildrenbjectsArr addObject:Ob];
	}

	[self Update];
	UPDATE;
	
//	START_PROC(@"Proc");
//	UP_SELECTOR(@"e00",@"Proc:");
//	END_PROC(@"Proc");
	
//	mColor = Color3DMake(1,1,1,1);
	[self SetColorSym];
}
//------------------------------------------------------------------------------------------------------
-(void)SetColorSym{
	
	for(GObject *pOb in m_pChildrenbjectsArr)
		OBJECT_SET_PARAMS(pOb->m_strName,SET_COLOR(@"mColor",mColor),nil);
	
	UPDATE;
}
//------------------------------------------------------------------------------------------------------
-(void)ScoreAdd{
	iTmpScore+=iScoreAdd;
	iScoreAdd=0;
}
//------------------------------------------------------------------------------------------------------
- (void)Update{
	
	iCountScore+=iTmpScore;
	iTmpScore=0;
	
	NSMutableArray *pArrayScore = [[self ParseIntValue:iCountScore] autorelease];
	NSMutableArray *TmpArr=m_pChildrenbjectsArr;
	
	for (int i=0; i< [TmpArr count]; i++)
		OBJECT_SET_PARAMS(((GObject *)[TmpArr objectAtIndex:i])->m_strName,
						  SET_BOOL(@"m_bHiden",YES),nil);		
	
		
	if ([pArrayScore count]==0) {
		
		OBJECT_SET_PARAMS(((GObject *)[TmpArr objectAtIndex:0])->m_strName,
						  SET_INT(@"m_iCurrentSym",0),
						  SET_VECTOR(@"m_pOffsetCurPosition",(TmpVector1=Vector3DMake(0,0,0))),
						  SET_BOOL(@"m_bHiden",NO),nil);		
	}
	else for (int i=0; i< [pArrayScore count]; i++) {
		
		OBJECT_SET_PARAMS(((GObject *)[TmpArr objectAtIndex:i])->m_strName,
            SET_INT(@"m_iCurrentSym",[[pArrayScore objectAtIndex:[pArrayScore count]-i-1] intValue]),
                    SET_VECTOR(@"m_pOffsetCurPosition",(TmpVector1=Vector3DMake(i*m_fWNumber,0,0))),
						  SET_BOOL(@"m_bHiden",NO),nil);
		
        OBJECT_PERFORM_SEL(((GObject *)[TmpArr objectAtIndex:i])->m_strName, @"Move");
	}
	
	UPDATE;
}
//------------------------------------------------------------------------------------------------------
- (void)Move{if(iTmpScore)[self Update];}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor *)pProc{}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT