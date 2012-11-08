//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_ResourceMng.h"

@implementation Ob_ResourceMng
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_fCurrentOffset=0;
        m_bHiden=YES;
        m_iLayer = layerTemplet;
        m_iLayerTouch=layerTouch_0;//слой касания
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
   [m_pObjMng->pMegaTree SetCell:(LINK_INT_V(m_iTypeRes,m_strName,@"m_iTypeRes"))];
    
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    [m_pObjMng->pMegaTree SetCell:(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"))];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
    m_fCurrentOffset=0;
    
    mWidth=460;
    mHeight=510;
        
	[super Start];
    
    NumButtons=19;

    float StepY=50;
        
    pObBtnClose=UNFROZE_OBJECT(@"ObjectButton",@"ButtonClose",
                   SET_STRING_V(@"Close.png",@"m_DOWN"),
                   SET_STRING_V(@"Close.png",@"m_UP"),
                   SET_FLOAT_V(64,@"mWidth"),
                   SET_FLOAT_V(64*FACTOR_DEC,@"mHeight"),
                   SET_BOOL_V(YES,@"m_bLookTouch"),
                   SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                   SET_STRING_V(NAME(self),@"m_strNameObject"),
                   SET_STRING_V(@"Close",@"m_strNameStage"),
                   SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                   SET_VECTOR_V(Vector3DMake(-35,290,0),@"m_pCurPosition"));
    
    m_fStartOffset=mWidth*0.55f;
    float OffsetY=m_fStartOffset;
    m_fUpLimmit=OffsetY;
    
    bool bTexture=NO;
    switch (m_iTypeRes) {
        case R_TEXTURE:
            RootFolder=@"Textures";
            bTexture=YES;
            break;
        case R_ICON:
            RootFolder=@"Icons";
            bTexture=YES;
            break;
            
        case R_SOUND:
            RootFolder=@"Sounds";
            bTexture=NO;
            break;

        case R_ATLAS:
            RootFolder=@"Atlases";
            bTexture=YES;
            break;

        default:
            RootFolder=@"Icons";
            bTexture=YES;
            break;
    }

    for (int i=0; i<NumButtons; i++) {
        
        float fOffset=0;
        float TmpOff=115;
        
        if(i%2==0){
            fOffset=-TmpOff;
            OffsetY-=StepY;
            m_fDownLimmit=OffsetY-64*FACTOR_DEC;
        }
        else fOffset=TmpOff;
                
        GObject *pOb = UNFROZE_OBJECT(@"Ob_Label",@"Label",
                          LINK_ID_V(self,@"m_pOwner"),
                          SET_STRING_V(@"Button_To_box_Down.png",@"pNameLabel"),
                          SET_BOOL_V(bTexture,@"bTexture"),
                          SET_VECTOR_V(Vector3DMake(fOffset, OffsetY, 0),@"m_pOffsetCurPosition"));
        
        [m_pChildrenbjectsArr addObject:pOb];
    }
    
    [self SetTouch:YES];
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
//------------------------------------------------------------------------------------------------------
- (void)InitProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)PrepareProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{}
//------------------------------------------------------------------------------------------------------
- (void)Close{

    OBJECT_PERFORM_SEL(@"Ob_Editor_Interface", @"CloseChoseIcon");
    DESTROY_OBJECT(self);
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    DESTROY_OBJECT(pObBtnClose);
    
    for (int i=0; i<NumButtons; i++) {
        
        DESTROY_OBJECT([m_pChildrenbjectsArr objectAtIndex:i]);
    }
    [m_pChildrenbjectsArr removeAllObjects];

    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEndedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    m_bStartPush=NO;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    m_bStartPush=NO;
}
//------------------------------------------------------------------------------------------------------
- (void)Move:(CGPoint)Point{
    if(m_bStartPush==YES && NumButtons > 18){
        float DeltaF=Point.y-m_pStartPoint.y;
        m_fCurrentOffset+=DeltaF;
        
        if((m_fCurrentOffset+m_fStartOffset)<m_fUpLimmit)m_fCurrentOffset=m_fUpLimmit-m_fStartOffset;
        if((m_fCurrentOffset+m_fStartOffset)>-m_fDownLimmit){
            m_fCurrentOffset=-m_fDownLimmit-m_fStartOffset;
        }

        m_pStartPoint=Point;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    [self Move:Point];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    [self Move:Point];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    m_bStartPush=YES;
    m_pStartPoint=Point;
}
@end