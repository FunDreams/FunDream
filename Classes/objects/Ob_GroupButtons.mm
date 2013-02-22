//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_GroupButtons.h"
#import "ObjectB_Ob.h"
#import "Ob_Editor_Interface.h"

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
    
    id pObTmp = GET_ID_V(@"ObCheckOb");
    
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
    
    [self SetButton];
}
//------------------------------------------------------------------------------------------------------
- (void)SetButton{
    ObjectB_Ob *pOb = [m_pChildrenbjectsArr objectAtIndex:m_iCurrentSelect];
    int iType=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:pOb->pString->m_iIndex];
    
    if(iType==DATA_FLOAT || iType==DATA_INT ||
       iType==DATA_STRING || iType==DATA_TEXTURE || iType==DATA_SOUND)
    {
        OBJECT_PERFORM_SEL(@"Ob_Editor_Interface", @"SetButtonEdit");
    }
    else
    {
        OBJECT_PERFORM_SEL(@"Ob_Editor_Interface", @"RemButtonEdit");
    }
    
    Ob_Editor_Interface *pInterface=(Ob_Editor_Interface *)[m_pObjMng
                            GetObjectByName:@"Ob_Editor_Interface"];
    
    pInterface->StringSelect=pOb->pString;

    DEL_CELL(@"ObCheckOb");
}
//------------------------------------------------------------------------------------------------------
- (void)Hide{

    for (ObjectB_Ob *pOb in m_pChildrenbjectsArr) {
        DESTROY_OBJECT(pOb);
    }
    [m_pChildrenbjectsArr removeAllObjects];

//    for (ObjectB_Ob *pOb in m_pChildrenbjectsArr) {
//        [pOb SetTouch:NO];
//        [pOb DeleteFromDraw];
//    }
}
//------------------------------------------------------------------------------------------------------
- (void)Show{

    for (ObjectB_Ob *pOb in m_pChildrenbjectsArr) {
        [pOb SetTouch:YES];
        [pOb AddToDraw];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)CreateInfo:(FractalString *)pFrStr{
    
    Color3D ColorTmp = Color3DMake(0, 0, 0, 1);
    bool bFlick=NO;
    
    

    
    
//    switch (pFrStr->TypeInformation) {
//        case STR_DATA:
//            ColorTmp = Color3DMake(0.4f, 0.4f, 1, 1);
//            break;
//        case STR_OPERATION:
//            ColorTmp = Color3DMake(1, 0, 1, 1);
//            break;
//        case STR_CONTAINER:
            ColorTmp = Color3DMake(0, 0, 0, 1);
//            
//            if(pFrStr->NameInformation==NAME_K_START)
//                bFlick=YES;
//            break;
//            
//        default:
//            break;
//    }
    
    ObjectB_Ob *pOb=UNFROZE_OBJECT(@"ObjectB_Info",@"Info",
                                   SET_STRING_V(@"ButtonOb.png",@"m_DOWN"),
                                   SET_STRING_V(@"ButtonOb.png",@"m_UP"),
                                   SET_FLOAT_V(100,@"mWidth"),
                                   SET_FLOAT_V(34*FACTOR_DEC,@"mHeight"),
                                   //SET_BOOL_V(YES,@"m_bLookTouch"),
                                   SET_INT_V(2,@"m_iType"),
                                   SET_STRING_V(NAME(self),@"m_strNameObject"),
                                   SET_STRING_V(@"Check",@"m_strNameStage"),
                                   SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                                   SET_BOOL_V(YES,@"m_bDrag"),
                                   SET_COLOR_V(ColorTmp,@"mColorBack"),
                                   SET_BOOL_V(bFlick,@"m_bFlicker"),
                                   SET_VECTOR_V(Vector3DMake(pFrStr->X,pFrStr->Y,0),@"m_pCurPosition"));
    
    GET_TEXTURE(pOb->mTextureId, pFrStr->sNameIcon);
    pOb->pString=pFrStr;
    
    [m_pChildrenbjectsArr addObject:pOb];
}
//------------------------------------------------------------------------------------------------------
- (void)CreateOb:(FractalString *)pFrStr{
    
    Color3D ColorTmp = Color3DMake(0, 0, 0, 1);
    bool bFlick=NO;
    float Width=44;
    float Height=44;
    
    int iType=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:pFrStr->m_iIndex];
    
    switch (iType)
    {
        case DATA_FLOAT:
        case DATA_INT:
            Width=100;
            Height=34;

            switch (pFrStr->m_iAdditionalType) {
                case ADIT_TYPE_SIMPLE:
                    ColorTmp = Color3DMake(0.4f, 0.4f, 1, 1);
                    break;

                case ADIT_TYPE_ENTER:
                    ColorTmp = Color3DMake(1, 1, 0, 1);
                    break;

                case ADIT_TYPE_EXIT:
                    ColorTmp = Color3DMake(0, 1, 0, 1);
                    break;

                default:
                    break;
            }

            break;
        case DATA_MATRIX:
        {
            MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:pFrStr->m_iIndex];

            switch (pMatr->TypeInformation) {
                    
                case STR_OPERATION:
                    ColorTmp = Color3DMake(1, 0, 1, 1);
                    break;
                    
                case STR_CONTAINER:
                    ColorTmp = Color3DMake(0, 0, 0, 1);
                    if(pMatr->NameInformation==NAME_K_START)
                        bFlick=YES;
                    
                    break;
                    
                default:
                    break;
            }
            break;
        }
        default:
            break;

    }
    
    
    ObjectB_Ob *pOb=UNFROZE_OBJECT(@"ObjectB_Ob",@"Object",
                           SET_INT_V(iType,@"m_iTypeStr"),
                           SET_STRING_V(@"ButtonOb.png",@"m_DOWN"),
                           SET_STRING_V(@"ButtonOb.png",@"m_UP"),
                           SET_FLOAT_V(Width,@"mWidth"),
                           SET_FLOAT_V(Height*FACTOR_DEC,@"mHeight"),
                           //SET_BOOL_V(YES,@"m_bLookTouch"),
                           SET_INT_V(2,@"m_iType"),
                           SET_STRING_V(NAME(self),@"m_strNameObject"),
                           SET_STRING_V(@"Check",@"m_strNameStage"),
                           SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                           SET_BOOL_V(YES,@"m_bDrag"),
                           SET_COLOR_V(ColorTmp,@"mColorBack"),
                           SET_BOOL_V(bFlick,@"m_bFlicker"),
                           SET_VECTOR_V(Vector3DMake(pFrStr->X,pFrStr->Y,0),@"m_pCurPosition"));
    
    GET_TEXTURE(pOb->mTextureId, pFrStr->sNameIcon);
    pOb->pString=pFrStr;
    pOb->m_iTypeStr=iType;
    
    [m_pChildrenbjectsArr addObject:pOb];
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateButt{
    
    if(pInsideString==nil)return;
    
    for (ObjectB_Ob *pOb in m_pChildrenbjectsArr) {
        DESTROY_OBJECT(pOb);
    }
    [m_pChildrenbjectsArr removeAllObjects];
    
    int *Data=(*pInsideString->pChildString);
    InfoArrayValue *InfoStr=(InfoArrayValue *)(Data);

    for(int i=0;i<InfoStr->mCount;i++){
        
        int index=(Data+SIZE_INFO_STRUCT)[i];
        FractalString *pFrStr=[m_pObjMng->pStringContainer->ArrayPoints
                       GetIdAtIndex:index];

            [self CreateOb:pFrStr];
    }
    
    if([m_pChildrenbjectsArr count]>0 && m_iCurrentSelect!=-1)
    {
        if(m_iCurrentSelect>[m_pChildrenbjectsArr count]-1)
            m_iCurrentSelect=0;
        
        ObjectB_Ob *pObSel=[m_pChildrenbjectsArr objectAtIndex:m_iCurrentSelect];
        
        OBJECT_PERFORM_SEL(NAME(pObSel), @"SetPush");
    }
    [self SetButton];
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
- (void)Destroy{
    for (ObjectB_Ob *pOb in m_pChildrenbjectsArr) {
        DESTROY_OBJECT(pOb);
    }
    [m_pChildrenbjectsArr removeAllObjects];

    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
@end