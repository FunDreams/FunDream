//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectButton.h"
#import "UniCell.h"

@implementation ObjectButton
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_Disable=false;
        m_iLayer = layerInterfaceSpace5;
        m_iType=bSimple;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{
    mColor.red=1;
    mColor.green=1;
    mColor.blue=1;
    mColor.alpha=1;
    
    m_bHiden=NO;
    m_bPush=NO;
    m_bCheck=NO;
    m_bDrag=NO;
    m_bStartPush=NO;
    
    [m_DOWN setString:@""];
    [m_UP setString:@""];
    [m_strNameSound setString:@""];
    [m_strNameStage setString:@""];
    [m_strNameObject setString:@""];

    [m_strNameStageDClick setString:@""];
    [m_strNameObjectDClick setString:@""];
    
    mColorBack = Color3DMake(0, 1, 0, 1);
    m_bBack=NO;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];

    [m_pObjMng->pMegaTree SetCell:LINK_COLOR_V(mColorBack,m_strName,@"mColorBack")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bBack,m_strName,@"m_bBack")];

    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimFromTexture,m_strName,@"m_bDimFromTexture")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimMirrorX,m_strName,@"m_bDimMirrorX")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY")];

    [m_pObjMng->pMegaTree SetCell:LINK_INT_V(m_iType,m_strName,@"m_iType")];
    
    m_strNameSound=[NSMutableString stringWithString:@""];
    m_strNameStage=[NSMutableString stringWithString:@""];
    m_strNameObject=[NSMutableString stringWithString:@""];

    m_strNameStageDClick=[NSMutableString stringWithString:@""];
    m_strNameObjectDClick=[NSMutableString stringWithString:@""];

    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound")];
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_strNameStage,m_strName,@"m_strNameStage")];
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_strNameObject,m_strName,@"m_strNameObject")];
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_strNameStageDClick,m_strName,@"m_strNameStageDClick")];
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_strNameObjectDClick,m_strName,@"m_strNameObjectDClick")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bLookTouch,m_strName,@"m_bLookTouch")];

    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDrag,m_strName,@"m_bDrag")];
    
    m_DOWN=[NSMutableString stringWithString:@""];
    m_UP=[NSMutableString stringWithString:@""];
    
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_DOWN,m_strName,@"m_DOWN")];
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_UP,m_strName,@"m_UP")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_Disable,m_strName,@"m_Disable")];

    Processor_ex *pProc = [self START_QUEUE:@"DTouch"];
        ASSIGN_STAGE(@"Idle", @"Idle:",nil)
        ASSIGN_STAGE(@"DoubleTouch", @"DoubleTouch:",SET_INT_V(300,@"TimeBaseDelay"));
    [self END_QUEUE:pProc name:@"DTouch"];

    pProc = [self START_QUEUE:@"Proc"];
    
        ASSIGN_STAGE(@"Idle",@"Idle:",nil);
        
        ASSIGN_STAGE(@"Move",@"AchiveLineFloat:",
                     LINK_FLOAT_V(m_fCurPosSlader,@"Instance"),
                     SET_FLOAT_V(1,@"finish_Instance"),
                     SET_FLOAT_V(1,@"Vel"));
        
        ASSIGN_STAGE(@"e03",@"DestroySelf:",nil);
        ASSIGN_STAGE(@"e04",@"Idle:",nil);
        
        ASSIGN_STAGE(@"e05",@"AchiveLineFloat:",
                     LINK_FLOAT_V(mColor.alpha,@"Instance"),
                     SET_FLOAT_V(0,@"finish_Instance"),
                     SET_FLOAT_V(-1.8f,@"Vel"));
        
        ASSIGN_STAGE(@"e06",@"DestroySelf:",nil);
    
    [self END_QUEUE:pProc name:@"Proc"];
    
    
    pProc = [self START_QUEUE:@"Mirror"];
    
        //   ASSIGN_STAGE(@"Idle",@"Idle:",nil);
        
        ASSIGN_STAGE(@"AchivePoint",@"Mirror2Dvector:",
                     LINK_VECTOR_V(m_vStartPos,@"StartV"),
                     LINK_VECTOR_V(m_vEndPos,@"FinishV"),
                     LINK_VECTOR_V(m_pCurPosition,@"DestV"),
                     SET_FLOAT_V(0,@"StartF"),
                     SET_FLOAT_V(1,@"FinishF"),
                     LINK_FLOAT_V(m_fCurPosSlader2,@"SrcF"));
    
    [self END_QUEUE:pProc name:@"Mirror"];
    
    pProc = [self START_QUEUE:@"Parabola"];
    
        //   ASSIGN_STAGE(@"Idle",@"Idle:",nil);
        
        ASSIGN_STAGE(@"MoveParabola",@"Parabola2:",
                     SET_INT_V(4,@"PowI"),
                     LINK_FLOAT_V(m_fCurPosSlader,@"SrcF"),
                     LINK_FLOAT_V(m_fCurPosSlader2,@"DestF"));
    
    [self END_QUEUE:pProc name:@"Parabola"];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
	
    if(m_bDimFromTexture){GET_DIM_FROM_TEXTURE(m_DOWN);}
    
	[super Start];
    [self SetTouch:YES];

    if(m_bDimMirrorX==YES){m_pCurScale.x=-m_pCurScale.x;}
    if(m_bDimMirrorY==YES){m_pCurScale.y=-m_pCurScale.y;}
    
	m_vStartPos=m_pCurPosition;
	
    m_TextureUP=-1;
    m_TextureDown=-1;
	GET_TEXTURE(m_TextureUP,m_UP);
	GET_TEXTURE(m_TextureDown,m_DOWN);
    
	mTextureId=m_TextureUP;
    
    m_vStartPos=m_pCurPosition;
    m_vEndPos=m_pCurPosition;
    m_vEndPos.y-=1000;
}
//------------------------------------------------------------------------------------------------------
- (void)SetUnPush{
    
    if(m_iType!=bCheckBox || m_iType!=bCheckBox){
        m_bCheck=NO;
    }

    m_bPush=NO;
    mTextureId=m_TextureUP;
    
    mColor.green=1;
    mColor.blue=1;

}
//------------------------------------------------------------------------------------------------------
- (void)SetPush{
    
    if(m_iType!=bCheckBox || m_iType!=bCheckBox){
        m_bCheck=YES;
    }

    m_bPush=YES;
    mTextureId=m_TextureDown;
    
    mColor.green=0;
    mColor.blue=0;
}
//------------------------------------------------------------------------------------------------------
- (void)DoubleTouch:(Processor_ex *)pProc{
    
    m_bDoubleTouch=NO;
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    if(m_bLookTouch==YES)LOCK_TOUCH;
    
    m_bStartPush=YES;

	if([[self FindProcByName:@"Proc"]->m_CurStage->NameStage isEqualToString:@"Idle"] && m_Disable==NO){
        
        if(m_iType==bCheckBox || m_iType==bRadioBox){
            
          if(m_iType==bRadioBox){
               [m_pObjMng->pMegaTree SetCell:LINK_ID_V(self,@"ObCheck")];
            }

            if(m_bCheck==NO){
                [m_pParent PlaySound:m_strNameSound];
                [self SetPush];
                OBJECT_PERFORM_SEL(m_strNameObject, m_strNameStage);
            }
            else if(m_bCheck==YES){
                
                if(m_iType==bCheckBox){
                    [m_pParent PlaySound:m_strNameSound];
                    [self SetUnPush];
                    OBJECT_PERFORM_SEL(m_strNameObject, m_strNameStage);
                }
            }
        }
        else
        {
            [m_pParent PlaySound:m_strNameSound];
            [self SetPush];
            OBJECT_PERFORM_SEL(m_strNameObject, m_strNameStage);
        }
    }

    if(m_bDoubleTouch==YES)
    {
        m_bDoubleTouch=YES;
        OBJECT_PERFORM_SEL(m_strNameObjectDClick, m_strNameStageDClick);
    }
    else
    {
        NEXT_STAGE_EX(NAME(self), @"DTouch")
        m_bDoubleTouch=YES;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    if(m_bLookTouch==YES)LOCK_TOUCH;
    
	if([[self FindProcByName:@"Proc"]->m_CurStage->NameStage isEqualToString:@"Idle"] && m_Disable==NO){
        if(m_iType!=bCheckBox && m_iType!=bRadioBox)
            [self SetPush];
    }
    
    if(m_bDrag==YES && m_bStartPush==YES){
        
        m_bStartPush=NO;
        
        UNFROZE_OBJECT(@"Ob_IconDrag",@"IconDrag",
                       SET_FLOAT_V(54,@"mWidth"),
                       SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
                       SET_INT_V(m_TextureUP,@"mTextureId"),
//                       SET_BOOL_V(YES,@"m_bLookTouch"),
                       SET_VECTOR_V(Vector3DMake(Point.x,Point.y,0),@"m_pCurPosition"));
    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
//    if(m_bLookTouch==YES)LOCK_TOUCH;

	if([[self FindProcByName:@"Proc"]->m_CurStage->NameStage isEqualToString:@"Idle"] && m_Disable==NO){
        if(m_iType!=bCheckBox && m_iType!=bRadioBox)
            [self SetUnPush];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{

    if(m_bLookTouch==YES)LOCK_TOUCH;

	if([[self FindProcByName:@"Proc"]->m_CurStage->NameStage isEqualToString:@"Idle"] && m_Disable==NO)
	{                    
        if(m_iType==bSimple){
            [self SetUnPush];
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEndedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    if(m_iType!=bCheckBox && m_iType!=bRadioBox)
        [self SetUnPush];
    
    m_bStartPush=NO;
}
//------------------------------------------------------------------------------------------------------
- (void)SelfDrawOffset{

	glVertexPointer(3, GL_FLOAT, 0, vertices);
    glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);

	glTranslatef(m_pCurPosition.x+m_pObjMng->m_pParent->m_vOffset.x*m_fScaleOffset,
				 m_pCurPosition.y+m_pObjMng->m_pParent->m_vOffset.y*m_fScaleOffset,
				 m_pCurPosition.z);

    glRotatef(m_pCurAngle.z, 0, 0, 1);
    glScalef(m_pCurScale.x*1.1f,m_pCurScale.y*1.1f,m_pCurScale.z);

    [self SetColor:mColorBack];

    glBindTexture(GL_TEXTURE_2D, -1);

    if(m_bBack==YES){
        glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
    }

    glBindTexture(GL_TEXTURE_2D, mTextureId);
    
	glScalef(0.9f,0.9f,m_pCurScale.z);
    [self SetColor:mColor];
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    
    [self SetTouch:NO];
    [super Destroy];
}
//------------------------------------------------------------------------------------------------------

@end