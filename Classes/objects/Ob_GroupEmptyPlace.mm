//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_GroupEmptyPlace.h"
#import "Ob_EmtyPlace.h"
#import "Ob_GroupButtons.h"

@implementation Ob_GroupEmptyPlace
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerTemplet;
        m_iLayerTouch=layerTouch_0;//слой касания
        m_bHiden=YES;
        m_iNumButton=8;
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
    [m_pObjMng->pMegaTree SetCell:(LINK_INT_V(m_iNumButton,m_strName,@"m_iNumButton"))];
}
//------------------------------------------------------------------------------------------------------
- (void)Check{
    
    id pObTmp = GET_ID_V(@"ObPushEmPlace");
    
    int i=0;
    if(pObTmp!=nil){
        for (Ob_EmtyPlace *pOb in m_pChildrenbjectsArr) {
            if(pOb==pObTmp){
                m_iCurrentSelect=i;
                
                FractalString *StringTmp=pOb->pStr;
                
                Ob_GroupButtons *GrButt = (Ob_GroupButtons *)[m_pObjMng GetObjectByName:@"GroupButtons"];

                if(GrButt!=nil){
                    [GrButt SetString:StringTmp];
                }
                
                OBJECT_PERFORM_SEL(@"GroupButtons",@"UpdateButt");

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
- (void)UpdateButt{
    
    for (GObject *pOb in m_pChildrenbjectsArr) {
        DESTROY_OBJECT(pOb);
    }
    [m_pChildrenbjectsArr removeAllObjects];
                      
        
    if(m_iNumButton>10)m_iNumButton=10;
    mWidth=m_iNumButton*56;
    float Step=mWidth/m_iNumButton;
    
    float fOffset=mWidth/2+Step*0.5f;
    bool bPush=NO;
    
    for(int i=0;i<m_iNumButton;i++){
        
        if(i==0){
            bPush=YES;
        }
        else bPush=NO;
        
        ObjectB_Ob *pOb=UNFROZE_OBJECT(@"Ob_EmtyPlace",@"E_Place",
            SET_BOOL_V(bPush,@"m_bIsPush"),
            SET_FLOAT_V(54,@"mWidth"),
            SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
            SET_STRING_V(NAME(self),@"m_strNameObject"),
            SET_STRING_V(@"Check",@"m_strNameStage"),
            SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
            SET_VECTOR_V(Vector3DMake(m_pCurPosition.x-fOffset+i*Step,m_pCurPosition.y,0)
                         ,@"m_pCurPosition"));

        [m_pChildrenbjectsArr addObject:pOb];
    }    
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
	[super Start];
    [self UpdateButt];
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
@end