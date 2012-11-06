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
//        m_bHiden=YES;
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
//   [m_pObjMng->pMegaTree SetCell:(LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY"));
    
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    [m_pObjMng->pMegaTree SetCell:(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"))];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
	[super Start];
    
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
                               SET_VECTOR_V(Vector3DMake(-20,280,0),@"m_pCurPosition"));
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
- (void)Close{
    
//    FractalString *pStrCheck = [m_pObjMng->pStringContainer GetString:@"CurrentCheck"];
    
//    if(pStrCheck!=nil){
//        FCheck=[m_pObjMng->pStringContainer->ArrayPoints
//                GetDataAtIndex:pStrCheck->ArrayPoints->pData[0]];
//        m_iMode=(int)(*FCheck);
//        
//        float *FChelf=[m_pObjMng->pStringContainer->ArrayPoints
//                       GetDataAtIndex:pStrCheck->ArrayPoints->pData[1]];
//        m_iChelf=(int)(*FChelf);
//    }

    OBJECT_PERFORM_SEL(@"Ob_Editor_Interface", @"CloseChoseIcon");
    DESTROY_OBJECT(self);
}
//------------------------------------------------------------------------------------------------------
- (void) drawText:(NSString*)theString AtX:(float)X Y:(float)Y {
    
//    glLoadIdentity();
//    glTranslatef(m_pCurPosition.x+m_pObjMng->m_pParent->m_vOffset.x*m_fScaleOffset,
//				 m_pCurPosition.y+m_pObjMng->m_pParent->m_vOffset.y*m_fScaleOffset,
//				 m_pCurPosition.z);
//	
//	glRotatef(m_pCurAngle.z, 0, 0, 1);
//	glScalef(m_pCurScale.x,m_pCurScale.y,1);


    // Use black
    glColor4f(1, 0, 0, 1.0);
    
    // Set up texture
    Texture2D* statusTexture = [[Texture2D alloc] initWithString:theString dimensions:CGSizeMake(250, 150) alignment:UITextAlignmentLeft fontName:@"Helvetica" fontSize:40];
    
    // Bind texture
    glBindTexture(GL_TEXTURE_2D, [statusTexture name]);
    
    // Enable modes needed for drawing
//    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
//    glEnableClientState(GL_VERTEX_ARRAY);
//    glEnable(GL_TEXTURE_2D);
//    glEnable(GL_BLEND);
//    
//    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    // Draw
    [statusTexture drawInRect:CGRectMake(X,Y-50,150,100)];
    
    // Disable modes so they don't interfere with other parts of the program
//    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
//    glDisableClientState(GL_VERTEX_ARRAY);
//    glDisable(GL_TEXTURE_2D);
//    glDisable(GL_BLEND);
    
    [statusTexture release];
}
//------------------------------------------------------------------------------------------------------
- (void)SelfDrawOffset{
//    [super SelfDrawOffset];

    [self drawText:@"GENERAL" AtX:100 Y:100];
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    DESTROY_OBJECT(pObBtnClose);

    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
@end