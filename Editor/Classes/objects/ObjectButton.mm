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
        m_iLayerTouch=layerTouch_0;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{
    
    m_iType=bSimple;
    mColor.red=1;
    mColor.green=1;
    mColor.blue=1;
    mColor.alpha=1;
    
    m_pOwner=nil;
    
    m_bIsPush=NO;
    m_bNotPush=NO;
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
    m_Disable=NO;
    m_bBack=NO;
    [self SetUnPush];
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    
    [m_pObjMng->pMegaTree SetCell:LINK_INT_V(m_iNum,m_strName,@"m_iNum")];

    [m_pObjMng->pMegaTree SetCell:LINK_COLOR_V(mColorBack,m_strName,@"mColorBack")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bBack,m_strName,@"m_bBack")];

    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bNotPush,m_strName,@"m_bNotPush")];

    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimFromTexture,m_strName,@"m_bDimFromTexture")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimMirrorX,m_strName,@"m_bDimMirrorX")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY")];

    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bIsPush,m_strName,@"m_bIsPush")];

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
    
        ASSIGN_STAGE(@"Idle",@"Proc:",nil);
    
    [self END_QUEUE:pProc name:@"Proc"];
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
    
    if(m_bIsPush==YES){
        [self SetPush];
    }
    else [self SetUnPush];
    
    if(m_iType==bSimple)
        [self SetUnPush];
    
    if(m_Disable==YES)
        mColor.alpha=0.2f;
    else mColor.alpha=1;
}
//------------------------------------------------------------------------------------------------------
- (void)SetUnPush{
    
    if(m_iType==bCheckBox || m_iType==bCheckBox){
        m_bCheck=NO;
    }

    m_bPush=NO;
    mTextureId=m_TextureUP;
    
    mColor.green=1;
    mColor.blue=1;

}
//------------------------------------------------------------------------------------------------------
- (void)SetPush{
    
    if(m_iType==bCheckBox || m_iType==bCheckBox){
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
- (void)Proc:(Processor_ex *)pProc{
    
//    if(m_bDrag==YES){
//        if(m_pCurPosition.y>250)
//            m_bLookTouch=NO;
//        else m_bLookTouch=YES;
//    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    if(m_bLookTouch==YES)LOCK_TOUCH;
    
    LastPointTouch.x=Point.x;
    LastPointTouch.y=Point.y;

	if([[self FindProcByName:@"Proc"]->m_CurStage->NameStage isEqualToString:@"Idle"] && m_Disable==NO)
    {
        if(m_bNotPush==NO){
            if(m_iType==bCheckBox || m_iType==bRadioBox)
            {
              if(m_iType==bRadioBox && m_bDrag==YES){
                   [m_pObjMng->pMegaTree SetCell:LINK_ID_V(self,@"ObCheck")];
                  
                  if(m_iLayer==layerInterfaceSpace5){

                      m_bStartPush=YES;
                      [self SetLayer:m_iLayer+1];
                      [self SetTouch:YES WithLayer:m_iLayerTouch-1];
                      m_bLookTouch=NO;
                    }
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
                [m_pObjMng->pMegaTree SetCell:LINK_ID_V(self,@"ButtonPush")];
                [m_pParent PlaySound:m_strNameSound];
                [self SetPush];
                OBJECT_PERFORM_SEL(m_strNameObject, m_strNameStage);
            }
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
    
 //   if(m_bLookTouch==YES)LOCK_TOUCH;
    
	if([[self FindProcByName:@"Proc"]->m_CurStage->NameStage isEqualToString:@"Idle"] && m_Disable==NO)
    {
        if(m_iType==bSimple)
            [self SetPush];
    }
    
    if(m_bDrag==YES && m_bStartPush==YES){
        
        m_pCurPosition.x-=LastPointTouch.x-Point.x;
        m_pCurPosition.y-=LastPointTouch.y-Point.y;

        LastPointTouch.x=Point.x;
        LastPointTouch.y=Point.y;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
//    if(m_bLookTouch==YES)LOCK_TOUCH;

	if([[self FindProcByName:@"Proc"]->m_CurStage->NameStage isEqualToString:@"Idle"] && m_Disable==NO)
   {
       if(m_iType==bSimple){

            [self SetUnPush];
        }
    }
    
    if(m_bDrag==YES && m_bStartPush==YES){
        
        m_pCurPosition.x-=LastPointTouch.x-Point.x;
        m_pCurPosition.y-=LastPointTouch.y-Point.y;
        
        LastPointTouch.x=Point.x;
        LastPointTouch.y=Point.y;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{

    if(m_bLookTouch==YES)LOCK_TOUCH;
    m_bStartPush=NO;
    
	if([[self FindProcByName:@"Proc"]->m_CurStage->NameStage isEqualToString:@"Idle"] && m_Disable==NO)
	{                    
        if(m_iType==bSimple){
            [self SetUnPush];
        }
    }
    
    if(m_iType==bRadioBox){
        if(m_iLayer==layerInterfaceSpace6){
            m_bLookTouch=YES;

            [self SetLayer:m_iLayer-1];
            [self SetTouch:YES WithLayer:m_iLayerTouch+1];
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEndedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    if(m_iType!=bCheckBox && m_iType!=bRadioBox){
        [self SetUnPush];
    }
    
    if(m_iType==bRadioBox){
        
        if(m_iLayer==layerInterfaceSpace6){
            m_bLookTouch=YES;

            [self SetLayer:m_iLayer-1];
            [self SetTouch:YES WithLayer:m_iLayerTouch+1];
        }
    }

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

    mColorBack.alpha=mColor.alpha;
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