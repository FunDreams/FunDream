//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObB_DropBox.h"
#import "UniCell.h"
#import "Ob_IconDrag.h"

@implementation ObB_DropBox
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerInterfaceSpace5;
        m_iLayerTouch=layerTouch_1N;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{
    mColor.red=1;
    mColor.green=1;
    mColor.blue=1;
    mColor.alpha=1;
    
    m_pOwner=nil;
    
    m_bHiden=NO;
    m_bPush=NO;
    m_bDrag=NO;
    m_bStartPush=NO;
    m_bStartMove=NO;
    
    [m_DOWN setString:@""];
    [m_UP setString:@""];
    [m_strNameSound setString:@""];
    [m_strNameStage setString:@""];
    [m_strNameObject setString:@""];

    [m_strNameStageDClick setString:@""];
    [m_strNameObjectDClick setString:@""];
    
    mColorBack = Color3DMake(0,1,1,1);
    mColorBackCorn = Color3DMake(1,1,0,1);
    m_bBack=YES;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    
    [m_pObjMng->pMegaTree SetCell:LINK_COLOR_V(mColorBack,m_strName,@"mColorBack")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bBack,m_strName,@"m_bBack")];
    
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

    
//////--------------------------------------------------------------------------------------------------
    Processor_ex *pProc = [self START_QUEUE:@"DTouch"];
        ASSIGN_STAGE(@"Idle", @"Idle:",nil)
        ASSIGN_STAGE(@"DoubleTouch",@"DoubleTouch:",SET_INT_V(300,@"TimeBaseDelay"));
    [self END_QUEUE:pProc name:@"DTouch"];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
	    
	[super Start];
    [self SetTouch:YES];

	m_vStartPos=m_pCurPosition;
	
    m_TextureUP=-1;
    m_TextureDown=-1;
	GET_TEXTURE(m_TextureUP,m_UP);
	GET_TEXTURE(m_TextureDown,m_DOWN);
    
	mTextureId=m_TextureUP;
    
    m_vStartPos=m_pCurPosition;
    m_vEndPos=m_pCurPosition;
    m_vEndPos.y-=1000;
    m_bLookTouch=NO;
}
//------------------------------------------------------------------------------------------------------
- (void)SetUnPush{
    
    m_bPush=NO;
    
    mColor.green=1;
    mColor.blue=1;
}
//------------------------------------------------------------------------------------------------------
- (void)SetPush{

    m_bPush=YES;
    
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
- (void)SetPlace{
    
//    pObEmptyPlace = GET_ID_V(@"EmptyPlace");
//    if(pObEmptyPlace!=nil){
//        
//    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    m_bStartPush=YES;
    
    [m_pObjMng->pMegaTree SetCell:LINK_ID_V(self,@"ObCheckInDropBox")];
      
    PLAY_SOUND(m_strNameSound);

    OBJECT_PERFORM_SEL(m_strNameObject, m_strNameStage);
    [self SetPush];
}
//------------------------------------------------------------------------------------------------------
-(void)MoveObject:(CGPoint)Point WithMode:(bool)bMoveIn{
    
    int *pMode=GET_INT_V(@"m_iMode");
    if(*pMode==3){
        
        if(m_bStartMove==NO && m_bStartPush==YES){
            
            [m_pObjMng->pMegaTree SetCell:(LINK_ID_V(pString,@"DropBoxString"))];

            Ob_IconDrag *pOb=UNFROZE_OBJECT(@"Ob_IconDrag",@"IconDrag",
                           SET_FLOAT_V(44,@"mWidth"),
                           SET_BOOL_V(NO,@"bFromEmpty"),
                           SET_FLOAT_V(44,@"mHeight"),
                           SET_VECTOR_V(m_pCurPosition,@"m_pCurPosition"),
                           SET_STRING_V(pString->sNameIcon,@"m_pNameTexture"));
            
            pOb->pInsideString=pString;

            m_bStartMove=YES;
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    if(m_bStartPush==YES){
        
        [self SetPush];        
        [self MoveObject:Point WithMode:YES];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    OBJECT_PERFORM_SEL(m_strNameObject, m_strNameStage);
    [self MoveObject:Point WithMode:NO];    
}
//------------------------------------------------------------------------------------------------------
- (void)EndTouch{
    
    DEL_CELL(@"DropBoxString");
    
    m_bStartPush=NO;
    m_bStartMove=NO;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    [self EndTouch];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEndedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    [self EndTouch];
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
    glScalef(m_pCurScale.x,m_pCurScale.y,m_pCurScale.z);

    glBindTexture(GL_TEXTURE_2D, -1);
    
    if(m_bBack==YES){
        
        if(pString->m_iFlags & DEAD_STRING)
            mColorBack=Color3DMake(1, 0, 0, 1);
        else if(pString->m_iFlags & SYNH_AND_HEAD)
            mColorBack=Color3DMake(1, 1, 0, 1);
        else if(pString->m_iFlags & ONLY_IN_MEM)
            mColorBack=Color3DMake(0, 0.5f, 1, 1);
        else mColorBack=Color3DMake(0, 1, 0, 1);
            
        [self SetColor:mColorBack];
        glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
    }

    glBindTexture(GL_TEXTURE_2D, mTextureId);
    
    [self SetColor:mColor];
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
    
    if(![pString->sNameIcon2 isEqualToString:@"0.png"])
    {
        glScalef(0.5f,0.5f,1);
        glTranslatef(1.0f,-1.5f,0);
        
        int iTex;
        GET_TEXTURE(iTex, pString->sNameIcon2);
        glBindTexture(GL_TEXTURE_2D, iTex);
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
        
        if(![pString->sNameIcon3 isEqualToString:@"0.png"])
        {
            glTranslatef(2.0f,0,0);
            
            int iTex;
            GET_TEXTURE(iTex, pString->sNameIcon3);
            glBindTexture(GL_TEXTURE_2D, iTex);
            
            glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
        }
        
    }
    else if(![pString->sNameIcon3 isEqualToString:@"0.png"])
    {
        glScalef(0.5f,0.5f,1);
        glTranslatef(1.0f,-1.5f,0);
        
        int iTex;
        GET_TEXTURE(iTex, pString->sNameIcon3);
        glBindTexture(GL_TEXTURE_2D, iTex);
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
    }

}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    
    [self SetTouch:NO];
    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
@end