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

    

    //[m_pObjMng AddToGroup:@"NameGroup" Object:self];//группировка
    //[self SelfOffsetVert:Vector3DMake(0,1,0)];//cдвиг
}
//------------------------------------------------------------------------------------------------------
- (void)Close{DESTROY_OBJECT(self);}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
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
    DESTROY_OBJECT(pObInd);
    
    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
@end