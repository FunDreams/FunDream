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
#import "ObjectB_Ob.h"

@implementation Ob_GroupEmptyPlace
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerTemplet;
        m_iLayerTouch=layerTouch_0;//слой касания
        m_bHiden=YES;
        pChelf = [m_pObjMng->pStringContainer GetString:@"ChelfStirngs"];
        
        if(pChelf!=nil)
            m_iNumButton=[pChelf->ArrayLinks count];
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)ReLinkEmptyPlace{
    
    for (Ob_EmtyPlace *pOb in m_pChildrenbjectsArr) {
        
        [pOb SetEmpty];
    }
}
//------------------------------------------------------------------------------------------------------
//- (void)PostSetParams{}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];

//====//различные параметры=============================================================================
    [m_pObjMng->pMegaTree SetCell:(LINK_INT_V(m_iNumButton,m_strName,@"m_iNumButton"))];
    
    FractalString *pStrCheck = [m_pObjMng->pStringContainer GetString:@"CurrentCheck"];
    if(pStrCheck!=nil){
        float *FChelf=[m_pObjMng->pStringContainer->ArrayPoints
                       GetDataAtIndex:pStrCheck->ArrayPoints->pData[1]];
        
        m_fChelf=FChelf;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Check{
    
    id pObTmp = GET_ID_V(@"ObPushEmPlace");
    
    int i=0;
    if(pObTmp!=nil){
        for (Ob_EmtyPlace *pOb in m_pChildrenbjectsArr)
        {
            if(pOb==pObTmp)continue;
            else
            {
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

    mWidth=m_iNumButton*56;
    float Step=mWidth/m_iNumButton;
    
    float fOffset=mWidth/2+Step*0.5f;
    bool bPush=NO;

    if(pChelf!=nil){
        for(int i=0;i<m_iNumButton;i++){

            Ob_EmtyPlace *pObTmp=UNFROZE_OBJECT(@"Ob_EmtyPlace",@"E_Place",
                SET_BOOL_V(bPush,@"m_bIsPush"),
                SET_FLOAT_V(54,@"mWidth"),
                SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
                SET_STRING_V(NAME(self),@"m_strNameObject"),
                SET_STRING_V(@"Check",@"m_strNameStage"),
                SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                SET_INT_V(i,@"m_iCurIndex"),
                SET_VECTOR_V(Vector3DMake(m_pCurPosition.x-fOffset+i*Step,m_pCurPosition.y,0)
                             ,@"m_pCurPosition"));

            [m_pChildrenbjectsArr addObject:pObTmp];
            
            NSMutableString *Name = [pChelf->ArrayLinks objectAtIndex:i];
            FractalString *pStrTmp = [m_pObjMng->pStringContainer GetString:Name];
            
            if(pStrTmp!=nil){
                pObTmp->pStrInside=pStrTmp;
                pObTmp->mTextureId=pStrTmp->iIndexIcon;
            }
            else {
                [Name setString:@"Objects"];
                pObTmp->pStrInside = [m_pObjMng->pStringContainer GetString:@"Objects"];
                GET_TEXTURE(pObTmp->mTextureId, @"EmptyPlace.png");
            }
            
            if(i==*m_fChelf)[pObTmp SetPush];
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
	[super Start];
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
@end