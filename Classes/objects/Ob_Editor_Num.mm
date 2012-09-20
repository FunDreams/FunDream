//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_Editor_Num.h"
#import "Ob_NumIndicator.h"

@implementation Ob_Editor_Num
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerTemplet;
        m_iLayerTouch=layerTouch_0;//слой касания
        m_bHiden=YES;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
//- (void)SetDefault{}
//- (void)PostSetParams{}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
//====//процессоры для объекта==========================================================================
    Processor_ex* pProc = [self START_QUEUE:@"Proc"];
  //      ASSIGN_STAGE(@"IDLE",@"Idle:",nil);
        ASSIGN_STAGE(@"PROC",@"Proc:",nil);
    [self END_QUEUE:pProc name:@"Proc"];
    
//====//различные параметры=============================================================================
//   [m_pObjMng->pMegaTree SetCell:(LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY"));
    
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    [m_pObjMng->pMegaTree SetCell:(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"))];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
    //   GET_DIM_FROM_TEXTURE(@"");
	mWidth  = 50;
	mHeight = 50;

	[super Start];

    //   [self SetTouch:YES];//интерактивность
    GET_TEXTURE(mTextureId, m_pNameTexture);

    pObInd = UNFROZE_OBJECT(@"Ob_NumIndicator",@"testIndicator1",
                 SET_STRING_V(@"ParticlesFroIndicator",@"m_strNameContainer"),
                 SET_VECTOR_V(Vector3DMake(-200,260,0),@"m_pOffsetCurPosition"),
                 SET_FLOAT_V(1.5f,@"m_fScale"),
                 LINK_ID_V(self,@"m_pOwner"));

    pOb = UNFROZE_OBJECT(@"ObjectFade",@"Fade",
                   SET_FLOAT_V(1024,@"mWidth"),
                   SET_FLOAT_V(768,@"mHeight"),
                   SET_INT_V(layerInterfaceSpace7,@"m_iLayer"),
                   SET_INT_V(layerTouch_1N,@"m_iLayerTouch"),
                   SET_BOOL_V(YES,@"m_bLookTouch"),
                   SET_BOOL_V(YES,@"m_bObTouch"),
                   SET_FLOAT_V(5,@"m_fVelFade"),
                   SET_COLOR_V(Color3DMake(0.4f, 0.4f, 0.4f, 1),@"mColor"));

    pObBtnClose=UNFROZE_OBJECT(@"ObjectButton",@"ButtonClose",
                   SET_STRING_V(@"Close.png",@"m_DOWN"),
                   SET_STRING_V(@"Close.png",@"m_UP"),
                   SET_FLOAT_V(64,@"mWidth"),
                   SET_FLOAT_V(64*FACTOR_DEC,@"mHeight"),
                   SET_BOOL_V(YES,@"m_bLookTouch"),
                   SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                   SET_INT_V(layerTouch_2N,@"m_iLayerTouch"),
                   SET_STRING_V(NAME(self),@"m_strNameObject"),
                   SET_STRING_V(@"Close",@"m_strNameStage"),
                   SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                   SET_VECTOR_V(Vector3DMake(440,280,0),@"m_pCurPosition"));

    pObBtnMinus=UNFROZE_OBJECT(@"ObjectButton",@"ButtonMinus",
                               SET_STRING_V(@"ButtonMinus.png",@"m_DOWN"),
                               SET_STRING_V(@"ButtonMinus.png",@"m_UP"),
                               SET_FLOAT_V(90,@"mWidth"),
                               SET_FLOAT_V(90*FACTOR_DEC,@"mHeight"),
                               SET_BOOL_V(YES,@"m_bLookTouch"),
                               SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                               SET_INT_V(layerTouch_2N,@"m_iLayerTouch"),
                               SET_STRING_V(NAME(self),@"m_strNameObject"),
                               SET_STRING_V(@"ClickMinus",@"m_strNameStage"),
                               SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                               SET_VECTOR_V(Vector3DMake(-300,130,0),@"m_pCurPosition"));

    pObBtnPoint=UNFROZE_OBJECT(@"ObjectButton",@"ButtonPoint",
                               SET_STRING_V(@"Point.png",@"m_DOWN"),
                               SET_STRING_V(@"Point.png",@"m_UP"),
                               SET_FLOAT_V(90,@"mWidth"),
                               SET_FLOAT_V(90*FACTOR_DEC,@"mHeight"),
                               SET_BOOL_V(YES,@"m_bLookTouch"),
                               SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                               SET_INT_V(layerTouch_2N,@"m_iLayerTouch"),
                               SET_STRING_V(NAME(self),@"m_strNameObject"),
                               SET_STRING_V(@"ClickPoint",@"m_strNameStage"),
                               SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                               SET_VECTOR_V(Vector3DMake(-200,130,0),@"m_pCurPosition"));

    pObBtnPoint2=UNFROZE_OBJECT(@"ObjectButton",@"ButtonPoint",
                               SET_STRING_V(@"Point.png",@"m_DOWN"),
                               SET_STRING_V(@"Point.png",@"m_UP"),
                               SET_FLOAT_V(90,@"mWidth"),
                               SET_FLOAT_V(90*FACTOR_DEC,@"mHeight"),
                               SET_BOOL_V(YES,@"m_bLookTouch"),
                               SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                               SET_INT_V(layerTouch_2N,@"m_iLayerTouch"),
                               SET_STRING_V(NAME(self),@"m_strNameObject"),
                               SET_STRING_V(@"ClickPoint2",@"m_strNameStage"),
                               SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                               SET_VECTOR_V(Vector3DMake(-100,130,0),@"m_pCurPosition"));

    pObBtnClear=UNFROZE_OBJECT(@"ObjectButton",@"ButtonClear",
                               SET_STRING_V(@"Clear.png",@"m_DOWN"),
                               SET_STRING_V(@"Clear.png",@"m_UP"),
                               SET_FLOAT_V(90,@"mWidth"),
                               SET_FLOAT_V(90*FACTOR_DEC,@"mHeight"),
                               SET_BOOL_V(YES,@"m_bLookTouch"),
                               SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                               SET_INT_V(layerTouch_2N,@"m_iLayerTouch"),
                               SET_STRING_V(NAME(self),@"m_strNameObject"),
                               SET_STRING_V(@"Clear",@"m_strNameStage"),
                               SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                               SET_VECTOR_V(Vector3DMake(80,130,0),@"m_pCurPosition"));

    float Step=90;
    for(int i=0;i<10;i++){
        
        NSString *StrContainer = [NSString stringWithFormat:@"%d.png",i];
        NSString *StrSel = [NSString stringWithFormat:@"Click%d",i];
        
        GObject *pObBtnNum=UNFROZE_OBJECT(@"ObjectButton",@"ButtonNum",
                                   SET_STRING_V(StrContainer,@"m_DOWN"),
                                   SET_STRING_V(StrContainer,@"m_UP"),
                                   SET_FLOAT_V(80,@"mWidth"),
                                   SET_FLOAT_V(80*FACTOR_DEC,@"mHeight"),
                                   SET_BOOL_V(YES,@"m_bLookTouch"),
                                   SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                                   SET_INT_V(layerTouch_2N,@"m_iLayerTouch"),
                                   SET_STRING_V(NAME(self),@"m_strNameObject"),
                                   SET_STRING_V(StrSel,@"m_strNameStage"),
                                   SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                                   SET_VECTOR_V(Vector3DMake(-400+i*Step,0,0),@"m_pCurPosition"));
        
        [m_pChildrenbjectsArr addObject:pObBtnNum];
    }

    //[m_pObjMng AddToGroup:@"NameGroup" Object:self];//группировка
    //[self SelfOffsetVert:Vector3DMake(0,1,0)];//cдвиг
}
//------------------------------------------------------------------------------------------------------
- (void)Close{
    
    OBJECT_PERFORM_SEL(@"Ob_Editor_Interface", @"Update");
    DESTROY_OBJECT(self);
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
//------------------------------------------------------------------------------------------------------
- (void)AddValue:(int)V{
    
    if(pObInd->m_fCurValue!=0){
        float TmpFloat=*pObInd->m_fCurValue;
        int TmpValue=(int)TmpFloat;
        float TmpFloat2=TmpFloat-TmpValue;
        
        if(fabs(TmpValue)<10000000){
            TmpValue*=10;
            TmpValue+=V;
            
            TmpFloat=TmpValue+TmpFloat2;
        }
        
        *pObInd->m_fCurValue=TmpFloat;
        [pObInd UpdateNum];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Click0{
    [self AddValue:0];
}
//------------------------------------------------------------------------------------------------------
- (void)Click1{
    [self AddValue:1];
}
//------------------------------------------------------------------------------------------------------
- (void)Click2{
    [self AddValue:2];
}
//------------------------------------------------------------------------------------------------------
- (void)Click3{
    [self AddValue:3];
}
//------------------------------------------------------------------------------------------------------
- (void)Click4{
    [self AddValue:4];
}
//------------------------------------------------------------------------------------------------------
- (void)Click5{
    [self AddValue:5];
}
//------------------------------------------------------------------------------------------------------
- (void)Click6{
    [self AddValue:6];
}
//------------------------------------------------------------------------------------------------------
- (void)Click7{
    [self AddValue:7];
}
//------------------------------------------------------------------------------------------------------
- (void)Click8{
    [self AddValue:8];
}
//------------------------------------------------------------------------------------------------------
- (void)Click9{
    [self AddValue:9];
}
//------------------------------------------------------------------------------------------------------
- (void)Clear{
    
    if(pObInd->m_fCurValue!=0){
        *pObInd->m_fCurValue=0.0f;
        
        [pObInd UpdateNum];
    }

}
//------------------------------------------------------------------------------------------------------
- (void)ClickPoint{
    
    if(pObInd->m_fCurValue!=0){
        float TmpFloat=*pObInd->m_fCurValue;
        
        if(fabs(TmpFloat)>0.001f)
            TmpFloat/=10;
        
        *pObInd->m_fCurValue=TmpFloat;
        
        [pObInd UpdateNum];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)ClickPoint2{
    
    if(pObInd->m_fCurValue!=0){
        float TmpFloat=*pObInd->m_fCurValue;
        
        if(fabs(TmpFloat)<10000000.0f)
            TmpFloat*=10;
        
        *pObInd->m_fCurValue=TmpFloat;
        
        [pObInd UpdateNum];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)ClickClear{
    
    if(pObInd->m_fCurValue!=0){
        *pObInd->m_fCurValue=0;
        [pObInd UpdateNum];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)ClickMinus{
    if(pObInd->m_fCurValue!=0){
        *pObInd->m_fCurValue=-(*pObInd->m_fCurValue);
        [pObInd UpdateNum];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)InitProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)PrepareProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{
    
//    PLAY_SOUND(@"");
//    STOP_SOUND(@"");
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    
    DESTROY_OBJECT(pOb);
    DESTROY_OBJECT(pObBtnClose);
    DESTROY_OBJECT(pObBtnClear);
    DESTROY_OBJECT(pObBtnMinus);
    DESTROY_OBJECT(pObBtnPoint);
    DESTROY_OBJECT(pObBtnPoint2);
    DESTROY_OBJECT(pObInd);
    
    for (GObject *pObTmp in m_pChildrenbjectsArr) {
        DESTROY_OBJECT(pObTmp);
    }
    
    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
@end