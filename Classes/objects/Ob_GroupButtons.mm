//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_GroupButtons.h"
#import "ObjectB_Ob.h"

@implementation Ob_GroupButtons
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerTemplet;
        m_iLayerTouch=layerTouch_0;//слой касания
        m_bHiden=YES;
        mHeight=330;
        m_iNumButton=9;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
//- (void)SetDefault{}
//- (void)PostSetParams{}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];

//====//различные параметры=============================================================================
//   [m_pObjMng->pMegaTree SetCell:(LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY"));
    
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    [m_pObjMng->pMegaTree SetCell:(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"))];

    [m_pObjMng->pMegaTree SetCell:(LINK_INT_V(m_iNumButton,m_strName,@"m_iNumButton"))];
}
//------------------------------------------------------------------------------------------------------
- (void)Check{
    
    id pObTmp = GET_ID_V(@"ObCheck");
    
    int i=0;
    if(pObTmp!=nil){
        for (GObject *pOb in m_pChildrenbjectsArr)
        {
            if(pOb==pObTmp){
                m_iCurrentSelect=i;
                continue;
            }
            else{
                OBJECT_PERFORM_SEL(pOb->m_strName, @"SetUnPush");
            }
            i++;
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Hide{

    for (ObjectB_Ob *pOb in m_pChildrenbjectsArr) {
        [pOb SetTouch:NO];
        [pOb DeleteFromDraw];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Show{
    
    for (ObjectB_Ob *pOb in m_pChildrenbjectsArr) {
        [pOb SetTouch:YES];
        [pOb AddToDraw];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateButt{
    
    if(pInsideString==nil)return;
    
    for (ObjectB_Ob *pOb in m_pChildrenbjectsArr) {
        DESTROY_OBJECT(pOb);
    }
    [m_pChildrenbjectsArr removeAllObjects];
                      
    m_iNumButton=[pInsideString->aStrings count];
    
    for(int i=0;i<m_iNumButton;i++){
        
        FractalString *pFrStr = [pInsideString->aStrings objectAtIndex:i];
        ObjectB_Ob *pOb=UNFROZE_OBJECT(@"ObjectB_Ob",@"Object",
            SET_STRING_V(@"ButtonOb.png",@"m_DOWN"),
            SET_STRING_V(@"ButtonOb.png",@"m_UP"),
            SET_FLOAT_V(54,@"mWidth"),
            SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
            SET_BOOL_V(YES,@"m_bLookTouch"),
            SET_INT_V(2,@"m_iType"),
            SET_STRING_V(NAME(self),@"m_strNameObject"),
            SET_STRING_V(@"Check",@"m_strNameStage"),
            SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
            SET_BOOL_V(YES,@"m_bDrag"),
            SET_VECTOR_V(Vector3DMake(pFrStr->X,pFrStr->Y,0),@"m_pCurPosition"));
        
        GET_TEXTURE(pFrStr->iIndexIcon, @"ButtonOb.png");
        pOb->pString=pFrStr;

        [m_pChildrenbjectsArr addObject:pOb];
    }
    
    if([m_pChildrenbjectsArr count]>0){
        if(m_iCurrentSelect>[m_pChildrenbjectsArr count]-1)
            m_iCurrentSelect=[m_pChildrenbjectsArr count]-1;
        
        ObjectB_Ob *pObSel=[m_pChildrenbjectsArr objectAtIndex:m_iCurrentSelect];
        
        OBJECT_PERFORM_SEL(NAME(pObSel), @"SetPush");
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetString:(FractalString *)Str{
    
    FractalString *pStr = Str;

    if(pStr!=nil)
        pInsideString=pStr;
    else
        pInsideString=[m_pObjMng->pStringContainer GetString:@"Objects"];

    [m_pObjMng->pMegaTree SetCell:LINK_ID_V(pInsideString,@"ParentString")];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
	[super Start];
    
    pInsideString = [m_pObjMng->pStringContainer GetString:@"Objects"];
    [m_pObjMng->pMegaTree SetCell:LINK_ID_V(pInsideString,@"ParentString")];

 //   [self UpdateButt];
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
@end