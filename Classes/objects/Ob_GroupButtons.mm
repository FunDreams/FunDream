//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_GroupButtons.h"

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
    
    if(pObTmp!=nil){
        for (GObject *pOb in m_pChildrenbjectsArr) {
            if(pOb==pObTmp){
                continue;
            }
            else{
                OBJECT_PERFORM_SEL(pOb->m_strName, @"SetUnPush");
            }
        }
    }

}
//------------------------------------------------------------------------------------------------------
- (void)UpdateButt{
    
    for (GObject *pOb in m_pChildrenbjectsArr) {
        DESTROY_OBJECT(pOb);
    }
    [m_pChildrenbjectsArr removeAllObjects];
                      
    
    m_iNumButton=[pInsideString->aStrings count];
    
    if(m_iNumButton>10)m_iNumButton=10;
    mHeight=m_iNumButton*56;
    float Step=mHeight/m_iNumButton;
    
    float fOffset=-mHeight/2+Step*0.5f;
    
    for(int i=0;i<m_iNumButton;i++){
        
        GObject *pOb=UNFROZE_OBJECT(@"ObjectButton",@"ButtonSaveToDropBox",
                        SET_STRING_V(@"Button_To_box_Down.png",@"m_DOWN"),
                        SET_STRING_V(@"Button_To_box_Up.png",@"m_UP"),
                        SET_FLOAT_V(54,@"mWidth"),
                        SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
                        SET_BOOL_V(YES,@"m_bLookTouch"),
                        SET_INT_V(2,@"m_iType"),
                        SET_STRING_V(NAME(self),@"m_strNameObject"),
                        SET_STRING_V(@"Check",@"m_strNameStage"),
                        SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                        SET_BOOL_V(YES,@"m_bDrag"),
                        SET_VECTOR_V(Vector3DMake(m_pCurPosition.x,
                           m_pCurPosition.y+i*Step+fOffset,0),@"m_pCurPosition"));
        
        [m_pChildrenbjectsArr addObject:pOb];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
	[super Start];
    
    pInsideString = [m_pObjMng->pStringContainer GetString:@"Object"];

    [self UpdateButt];
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
@end