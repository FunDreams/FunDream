//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_IconDrag.h"

@implementation Ob_IconDrag
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerInterfaceSpace9;
        m_iLayerTouch=layerTouch_2N;//слой касания
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{m_bHiden=NO;}
//- (void)PostSetParams{}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
//====//процессоры для объекта==========================================================================
    Processor_ex* pProc = [self START_QUEUE:@"Proc"];
  //      ASSIGN_STAGE(@"IDLE",@"Idle:",nil);
        ASSIGN_STAGE(@"PROC",@"Proc:",nil);
    [self END_QUEUE:pProc name:@"Proc"];

    [m_pObjMng->pMegaTree SetCell:LINK_INT_V(mTextureId,m_strName,@"mTextureId")];
//====//различные параметры=============================================================================
//   [m_pObjMng->pMegaTree SetCell:(LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY"));
    
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    [m_pObjMng->pMegaTree SetCell:(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"))];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

    int TmpTexture=mTextureId;
	[super Start];
    mTextureId=TmpTexture;

    [self SetTouch:YES];//интерактивность
//    GET_TEXTURE(mTextureId, m_pNameTexture);
}
//------------------------------------------------------------------------------------------------------
- (void)EndObject{
    
    GObject *pOb=[m_pObjMng GetObjectByName:@"ButtonTach"];
    CGPoint Point;
    Point.x=m_pCurPosition.x;
    Point.y=m_pCurPosition.y;

    if([pOb Intersect:Point]){        
    }
    else if(m_pCurPosition.y<202){
        FractalString *pParent=pInsideString->pParent;

        FractalString *pNewString =[[FractalString alloc] initAsCopy:pInsideString
                               WithParent:pParent WithContainer:m_pObjMng->pStringContainer];
        
        pNewString->X=m_pCurPosition.x;
        pNewString->Y=m_pCurPosition.y;
        
        if(pNewString->X<-440)pNewString->X=-440;
        if(pNewString->X>-40)pNewString->X=-40;
        
        if(pNewString->Y<-280)pNewString->Y=-280;
        if(pNewString->Y>170)pNewString->Y=170;

        OBJECT_PERFORM_SEL(@"GroupButtons",@"UpdateButt");
    }
    
    DESTROY_OBJECT(self);
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
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    m_pCurPosition.x=Point.x;
    m_pCurPosition.y=Point.y;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    m_pCurPosition.x=Point.x;
    m_pCurPosition.y=Point.y;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    [self EndObject];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEndedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    [self EndObject];    
}
//------------------------------------------------------------------------------------------------------
@end