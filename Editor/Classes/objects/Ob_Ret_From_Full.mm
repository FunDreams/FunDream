//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_Editor_Interface.h"
#import "Ob_Ret_From_Full.h"
#import "Ob_ParticleCont_ForStr.h"

@implementation Ob_Ret_From_Full
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerTemplet;
        m_iLayerTouch=layerTouch_3N;//слой касания
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
//   [m_pObjMng->pMegaTree SetCell:(LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY"))];
    
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    [m_pObjMng->pMegaTree SetCell:(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"))];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
    m_bHiden=YES;
    EndPoint=-1;

    //   GET_DIM_FROM_TEXTURE(@"");
    if(m_pObjMng->m_pParent->previousOrientation==UIInterfaceOrientationLandscapeLeft ||
       m_pObjMng->m_pParent->previousOrientation==UIInterfaceOrientationLandscapeRight)
    {
        mWidth  = 1024;
        mHeight = 768;
        
        Xp=412;
        Yp=284;
    }
    else {
        
        mWidth  = 768;
        mHeight = 1024;
        
        Xp=284;
        Yp=412;
    }

	[super Start];

    [self SetTouch:YES];//интерактивность
    mTextureId=-1;
    //[m_pObjMng AddToGroup:@"NameGroup" Object:self];//группировка
    //[self SelfOffsetVert:Vector3DMake(0,1,0)];//cдвиг
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
- (void)dealloc{[super dealloc];}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    
    Ob_Editor_Interface *pInterface=(Ob_Editor_Interface *)[m_pObjMng
                                        GetObjectByName:@"Ob_Editor_Interface"];
    
    [pInterface CreateFundInt];
    [pInterface SetMode:pInterface->OldInterfaceMode];
    [m_pObjMng->pStringContainer->ArrayPoints->pCurrenContPar SetWindow];
    [m_pObjMng->pStringContainer->ArrayPoints->pCurrenContPar SetOrientation];

    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
        
    if(Point.x<-Xp && Point.y>284){
        EndPoint=2;
    }
    else if(Point.x>Xp && Point.y>Yp){
        EndPoint=3;
    }
    else if(Point.x>Xp && Point.y<-Yp){
        EndPoint=0;
    }
    else if(Point.x<-Xp && Point.y<-Yp){
        EndPoint=1;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    if(Point.x<-Xp && Point.y>Yp && EndPoint==0){
        DESTROY_OBJECT(self);
    }
    else if(Point.x>Xp && Point.y>Yp && EndPoint==1){
        DESTROY_OBJECT(self);
    }
    else if(Point.x>Xp && Point.y<-Yp && EndPoint==2){
        DESTROY_OBJECT(self);
    }
    else if(Point.x<-Xp && Point.y<-Yp && EndPoint==3){
        DESTROY_OBJECT(self);
    }
    
    EndPoint=-1;
}
//------------------------------------------------------------------------------------------------------
@end