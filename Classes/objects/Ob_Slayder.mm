//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_Slayder.h"
#import "Ob_NumIndicator.h"

@implementation Ob_Slayder
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerInterfaceSpace3;
        m_iLayerTouch=layerTouch_0;//слой касания
        mWidth=200;
        mHeight=18;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{
    m_bHiden=NO;
}
//------------------------------------------------------------------------------------------------------
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

	[super Start];

    //   [self SetTouch:YES];//интерактивность
    GET_TEXTURE(mTextureId, m_pNameTexture);

    //[m_pObjMng AddToGroup:@"NameGroup" Object:self];//группировка
    //[self SelfOffsetVert:Vector3DMake(0,1,0)];//cдвиг
    
    pOb_BSlayder=UNFROZE_OBJECT(@"Ob_B_Slayder",@"B_Slayder",
                SET_VECTOR_V(Vector3DMake(0, 0, 0),@"m_pCurPosition"),
                LINK_ID_V(self,@"m_pOwner"),
                SET_STRING_V(@"Ob_B_Slayder.png",@"m_pNameTexture"));

    pObInd1 = UNFROZE_OBJECT(@"Ob_NumIndicator",@"testIndicator1",
                   SET_STRING_V(@"ParticlesScore",@"m_strNameContainer"),
                   SET_VECTOR_V(Vector3DMake(-100,20,0),@"m_pOffsetCurPosition"),
                   SET_FLOAT_V(0.4,@"m_fScale"),
                   LINK_ID_V(self,@"m_pOwner"));

    pObInd2 = UNFROZE_OBJECT(@"Ob_NumIndicator",@"testIndicator2",
                   SET_STRING_V(@"ParticlesScore",@"m_strNameContainer"),
                   SET_VECTOR_V(Vector3DMake(100,20,0),@"m_pOffsetCurPosition"),
                   SET_FLOAT_V(0.4,@"m_fScale"),
                   LINK_ID_V(self,@"m_pOwner"));
}
//------------------------------------------------------------------------------------------------------
- (void)SetString{
    
    if(pOb_BSlayder->pInsideString!=nil){
                
//        pObInd1->m_fCurValue=[m_pObjMng->pStringContainer->ArrayPoints
//                              GetDataAtIndex:pOb_BSlayder->pInsideString->S];
//        
//        pObInd2->m_fCurValue=[m_pObjMng->pStringContainer->ArrayPoints
//                              GetDataAtIndex:pOb_BSlayder->pInsideString->F];
        
        OBJECT_PERFORM_SEL(NAME(pObInd1), @"UpdateNum");
        OBJECT_PERFORM_SEL(NAME(pObInd2), @"UpdateNum");
    }
}
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
    DESTROY_OBJECT(pOb_BSlayder);
    DESTROY_OBJECT(pObInd1);
    DESTROY_OBJECT(pObInd2);
    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
@end