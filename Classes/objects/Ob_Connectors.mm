//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_Connectors.h"

@implementation Ob_Connectors
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerInterfaceSpace2;
        m_iLayerTouch=layerTouch_0;//слой касания
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault
{
    m_bHiden=NO;
}
//- (void)PostSetParams{}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    [m_pObjMng->pMegaTree SetCell:(LINK_VECTOR_V(Start_Vector,m_strName,@"Start_Vector"))];
//====//процессоры для объекта==========================================================================
    Processor_ex* pProc = [self START_QUEUE:@"Proc"];
  //      ASSIGN_STAGE(@"IDLE",@"Idle:",nil);
        ASSIGN_STAGE(@"PROC",@"Proc:",nil);
    [self END_QUEUE:pProc name:@"Proc"];
    
//====//различные параметры=============================================================================       
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    [m_pObjMng->pMegaTree SetCell:(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"))];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
    //Start_Vector,End_Vector;

    End_Vector.x=Start_Vector.x;
    End_Vector.y=Start_Vector.y;

    //   GET_DIM_FROM_TEXTURE(@"");
    m_bHiden=NO;
	mWidth  = 5;
	mHeight = 0;

	[super Start];

    [self SetTouch:NO];//интерактивность
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
- (void)dealloc{[super dealloc];}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    End_Vector.x=Point.x;
    End_Vector.y=Point.y;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    End_Vector.x=Point.x;
    End_Vector.y=Point.y;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    DESTROY_OBJECT(self);
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEndedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    DESTROY_OBJECT(self);
}
//------------------------------------------------------------------------------------------------------
- (void)SelfDrawOffset{
	
    if(Start==0)return;
    if(End==0)return;

    Vector3D TmpVector=Vector3DMake(End->x-Start->x, End->y-Start->y, 0);
    float L=Vector3DMagnitude(TmpVector);
    Vector3D CurPos=Vector3DMake(TmpVector.x*0.5f+Start->x,
                                 TmpVector.y*0.5f+Start->y,0);
    
    Vector3D TmpVector2=TmpVector;
    TmpVector2.x/=L;
    TmpVector2.y/=L;

    float Angle=atan(TmpVector.x/TmpVector.y);
    
    if(((TmpVector.x<=0  && TmpVector.y<0)||
       (TmpVector.x>0  && TmpVector.y<0)))
    {
        Angle+=3.14f;
    }
    
    m_pCurAngle.z=-Angle*180/(3.14f);
    
    if(L*0.5f-20<0)
        m_pCurScale.y=0;
    else m_pCurScale.y=L*0.5f-20;
    
	[self SetColor:mColor];
    
	glVertexPointer(3, GL_FLOAT, 0, vertices);
    glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
   	
	glBindTexture(GL_TEXTURE_2D, mTextureId);
	
	glTranslatef(CurPos.x+m_pObjMng->m_pParent->m_vOffset.x*m_fScaleOffset,
				 CurPos.y+m_pObjMng->m_pParent->m_vOffset.y*m_fScaleOffset,
				 CurPos.z);
	
	glRotatef(m_pCurAngle.z, 0, 0, 1);
	glScalef(m_pCurScale.x,m_pCurScale.y,m_pCurScale.z);
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
}
//------------------------------------------------------------------------------------------------------
@end