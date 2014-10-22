//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_RectView.h"
#import "Ob_ParticleCont_ForStr.h"

@implementation Ob_RectView
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerSystem;
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
//   [m_pObjMng->pMegaTree SetCell:(LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY"))];
    
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    [m_pObjMng->pMegaTree SetCell:(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"))];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
    m_bHiden=NO;

    //   GET_DIM_FROM_TEXTURE(@"");
	mWidth  = 1;
	mHeight = 500;

	[super Start];

    //   [self SetTouch:YES];//интерактивность
    GET_TEXTURE(mTextureId, m_pNameTexture);

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
- (void)SelfDrawOffset{
    
    float W=*((float *)[m_pObjMng->pStringContainer->ArrayPoints GetDataAtIndex:Ind_W_EMULATOR]);
    float H=*((float *)[m_pObjMng->pStringContainer->ArrayPoints GetDataAtIndex:Ind_H_EMULATOR]);
    Vector3D CurScale=m_pObjMng->pStringContainer->ArrayPoints->pCurrenContPar->m_pCurScale;
    int Mode=*((int *)[m_pObjMng->pStringContainer->ArrayPoints GetDataAtIndex:Ind_MODE_EMULATOR]);
    float ScaleXK=*((float *)[m_pObjMng->pStringContainer->ArrayPoints GetDataAtIndex:Ind_SCALE_X_EMULATOR]);
    float ScaleYK=*((float *)[m_pObjMng->pStringContainer->ArrayPoints GetDataAtIndex:Ind_SCALE_Y_EMULATOR]);

    [self SetColor:mColor];
    
	glVertexPointer(3, GL_FLOAT, 0, vertices);
    glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
   	
	glBindTexture(GL_TEXTURE_2D, mTextureId);

    glTranslatef(m_pCurPosition.x+256+m_pObjMng->m_pParent->m_vOffset.x*m_fScaleOffset,
				 m_pCurPosition.y+m_pObjMng->m_pParent->m_vOffset.y*m_fScaleOffset,
				 m_pCurPosition.z);
//---------------------------------------------------------------------------------------
    float ScaleX=W*.5f*CurScale.x/(ScaleXK*0.01f);
    float ScaleY=H*.5f*CurScale.y/(ScaleYK*0.01f);
    
    m_pCurScale.x=1;
    m_pCurScale.y=ScaleY;
	glScalef(m_pCurScale.x,m_pCurScale.y,m_pCurScale.z);
    
    glTranslatef(-ScaleX,0,0);

	glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
//---------------------------------------------------------------------------------------    
    glTranslatef(ScaleX*2,0,0);
    
    if(Mode>=1)[self SetColor:Color3DMake(0, 1, 0, 1)];
    glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
    if(Mode>=1)[self SetColor:Color3DMake(1, 1, 1, 1)];
//---------------------------------------------------------------------------------------
    glLoadIdentity();
    glRotatef(m_pObjMng->fCurrentAngleRotateOffset, 0, 0, 1);
    
    glTranslatef(m_pCurPosition.x+256+m_pObjMng->m_pParent->m_vOffset.x*m_fScaleOffset,
				 m_pCurPosition.y+m_pObjMng->m_pParent->m_vOffset.y*m_fScaleOffset,
				 m_pCurPosition.z);


    m_pCurScale.x=ScaleX;
    m_pCurScale.y=1;
	glScalef(m_pCurScale.x,m_pCurScale.y,1);
    
    glTranslatef(0,ScaleY,0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
//---------------------------------------------------------------------------------------
    glTranslatef(0,-2*ScaleY,0);
    if(Mode==0)[self SetColor:Color3DMake(0, 1, 0, 1)];
    glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
//---------------------------------------------------------------------------------------
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{[super dealloc];}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
@end