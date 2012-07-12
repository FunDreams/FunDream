//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_B_Slayder.h"

@implementation Ob_B_Slayder
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerInterfaceSpace4;
        m_iLayerTouch=layerTouch_0;//слой касания
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{
    m_bHiden=NO;
    m_fLink=0;
    pInsideString=0;
}
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
//    [m_pObjMng->pMegaTree SetCell:[UniCell Link_Float:m_fLink withKey:m_strName,@"m_fLink",nil]];
     
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    [m_pObjMng->pMegaTree SetCell:(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"))];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
    [m_pNameTexture setString:@"B_Slayder.png"];
    GET_TEXTURE(mTextureId, m_pNameTexture);

    mWidth=40;
    mHeight=40;
    m_bTouchButton=NO;
    
	[super Start];

    //[m_pObjMng AddToGroup:@"NameGroup" Object:self];//группировка
    //[self SelfOffsetVert:Vector3DMake(0,1,0)];//cдвиг
    m_pOffsetCurPosition.x=0;
    [self SetPosWithOffsetOwner];
    [self Show];
}
//------------------------------------------------------------------------------------------------------
- (void)Show{
    if(m_fLink==0){
        
        [self SetTouch:NO];//интерактивность
        [self DeleteFromDraw];        
    }
    else {
        
        [self SetTouch:YES];//интерактивность
        [self AddToDraw];
        [self setStartPos];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)setStartPos{

    if(pInsideString!=0){
        float WHalf=m_pOwner->mWidth*0.5f; 
        SET_MIRROR(*m_fLink, *pInsideString->F, *pInsideString->S,m_pOffsetCurPosition.x, WHalf, -WHalf);
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
    
    if(m_bTouchButton==YES){
        
        m_pOffsetCurPosition.x=(m_vCurrentTouchPoint.x-m_vStartTouchPoint.x)+m_vCurrentOffsetPos.x;
        float WHalf=m_pOwner->mWidth*0.5f; 
        if(m_pOffsetCurPosition.x<-WHalf)m_pOffsetCurPosition.x=-WHalf;
        if(m_pOffsetCurPosition.x>WHalf)m_pOffsetCurPosition.x=WHalf;
    }
    
    [self SetPosWithOffsetOwner];
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
- (void)ProcMove:(CGPoint)Point{
    
    if(m_bTouchButton==YES){
        float WHalf=m_pOwner->mWidth*0.5f; 

        m_vCurrentTouchPoint=Vector3DMake(Point.x, 0, 0);
        
        if(m_fLink!=0 && pInsideString!=0){
            SET_MIRROR(m_pOffsetCurPosition.x, WHalf, -WHalf,
                       *m_fLink, *pInsideString->F, *pInsideString->S);
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    [self ProcMove:Point];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    [self ProcMove:Point];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    m_vStartTouchPoint=Vector3DMake(Point.x, 0, 0);
    m_vCurrentTouchPoint=Vector3DMake(Point.x, 0, 0);
    m_vCurrentOffsetPos=Vector3DMake(Point.x-m_pOwner->m_pCurPosition.x+
                                     (m_pCurPosition.x-Point.x), 0, 0);

    m_bTouchButton=YES;
    [self ProcMove:Point];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    m_bTouchButton=NO;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEndedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    m_bTouchButton=NO;
}
@end