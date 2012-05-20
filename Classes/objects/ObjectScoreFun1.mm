//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectScoreFun1.h"

@implementation ObjectScoreFun1
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self=[super Init:Parent WithName:strName];
    if (self != nil)
    {
        m_iLayer = layerInvisible;

        mWidth  = 50;
        mHeight = 50;

        WSym=30;
        HSym=50;

        m_fWNumber=30;

        m_iAlign=-1;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{
    m_bHiden=YES;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];

    m_strStartStage=[NSMutableString stringWithString:@""];

    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_strStartStage,m_strName,@"m_strStartStage")];

    [m_pObjMng->pMegaTree SetCell:LINK_FLOAT_V(WSym,m_strName,@"WSym")];
    [m_pObjMng->pMegaTree SetCell:LINK_FLOAT_V(HSym,m_strName,@"HSym")];

    [m_pObjMng->pMegaTree SetCell:LINK_FLOAT_V(m_fWNumber,m_strName,@"m_fWNumber")];

    [m_pObjMng->pMegaTree SetCell:LINK_INT_V(iScoreAdd,m_strName,@"iScoreAdd")];
    [m_pObjMng->pMegaTree SetCell:LINK_INT_V(m_iAlign,m_strName,@"m_iAlign")];

    [m_pObjMng->pMegaTree SetCell:LINK_FLOAT_V(m_fStartPos,m_strName,@"m_fStartPos")];

    [m_pObjMng->pMegaTree SetCell:LINK_INT_V(iCountDownScore,m_strName,@"iCountDownScore")];
    [m_pObjMng->pMegaTree SetCell:LINK_INT_V(iScoreDownAdd,m_strName,@"iScoreDownAdd")];
    
    Processor_ex *pProc = [self START_QUEUE:@"Proc"];
        ASSIGN_STAGE(@"Move",@"MoveScore:",nil);
    [self END_QUEUE:pProc];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];

    iCountScore=PARAMS_APP->m_iCurRecord;

    if(m_iLayer==layerTemplet)m_iLayer--;

	for (int i=0; i<10; i++) {
		
		GObject *Ob = UNFROZE_OBJECT(@"ObjectAlNumber",([NSString stringWithFormat:@"sym%d", i]),
                        SET_STRING_V(m_pNameTexture, @"m_pNameTexture"),
                        LINK_ID_V(self,@"m_pOwner"),
                        SET_INT_V(0,@"m_iCurrentSym"),
                        SET_VECTOR_V(Vector3DMake(i*m_fWNumber,0,0),@"m_pOffsetCurPosition"),
                        SET_BOOL_V(YES,@"m_bHiden"),
                        SET_BOOL_V(m_bNoOffset,@"m_bNoOffset"),
//                      SET_BOOL_V(YES, @"m_bDimFromTexture"),
                        SET_FLOAT_V(WSym,@"mWidth"),
                        SET_FLOAT_V(HSym,@"mHeight"),
                        SET_BOOL_V(m_bNoOffset, @"m_bNoOffset"),
                        SET_INT_V(m_iLayer+1,@"m_iLayer"));

        SET_STAGE_EX(NAME(Ob), @"Proc", m_strStartStage);
		[m_pChildrenbjectsArr addObject:Ob];
	}

	[self SetColorSym];

	[self UpdateScore];
    
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    [m_pChildrenbjectsArr removeAllObjects];
}
//------------------------------------------------------------------------------------------------------
-(void)SetColorSym{
	
	for(GObject *pOb in m_pChildrenbjectsArr)
		OBJECT_SET_PARAMS(pOb->m_strName,SET_COLOR_V(mColor,@"mColor"));
	
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateScore{

	iCountScore+=iScoreAdd;

    if(iCountScore>PARAMS_APP->m_iCurRecord)
        PARAMS_APP->m_iCurRecord=iCountScore;

    if(iCountScore<0)iCountScore=0;

	NSMutableArray *pArrayScore = [self ParseIntValue:iCountScore];
	NSMutableArray *TmpArr=m_pChildrenbjectsArr;

    int AddCount=0;
    if([pArrayScore count]==0)AddCount=1;
    
	for (int i=[pArrayScore count]+AddCount; i< [TmpArr count]; i++)
    {        
        OBJECT_PERFORM_SEL(((GObject *)[TmpArr objectAtIndex:i])->m_strName, @"HideNum");
    }

    if ([pArrayScore count]==0 && [TmpArr count]!=0) {

        GObject *pOb=(GObject *)[TmpArr objectAtIndex:0];

        OBJECT_SET_PARAMS(pOb->m_strName,
                          SET_INT_V(0,@"m_iCurrentSym"),
                          SET_VECTOR_V(Vector3DMake(0,0,0),@"m_pOffsetCurPosition"));

        OBJECT_PERFORM_SEL(NAME(pOb), @"ShowNum");
    }
    else for (int i=0; i< [pArrayScore count]; i++)
    {
        GObject *pOb=(GObject *)[TmpArr objectAtIndex:i];
        
        OBJECT_SET_PARAMS(pOb->m_strName,
            SET_INT_V([[pArrayScore objectAtIndex:i] intValue],@"m_iCurrentSym"),
            SET_VECTOR_V(Vector3DMake(m_fStartPos-i*m_fWNumber,0,0),@"m_pOffsetCurPosition"));

        OBJECT_PERFORM_SEL(NAME(pOb), @"ShowNum");
        OBJECT_PERFORM_SEL(NAME(pOb), @"Move:");
    }    
}
//------------------------------------------------------------------------------------------------------
- (void)RezetScore{
    
    iCountScore=0;
    iScoreAdd=0;
    [self UpdateScore];
}
//------------------------------------------------------------------------------------------------------
- (void)MoveScore:(Processor_ex *)pProc{
    if(iScoreAdd){

        [self UpdateScore];
        iScoreAdd=0;
    }
}
//------------------------------------------------------------------------------------------------------
@end