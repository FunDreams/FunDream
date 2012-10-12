//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectB_Ob.h"
#import "UniCell.h"
#import "Ob_IconDrag.h"

@implementation ObjectB_Ob
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
    
    m_bNotPush=NO;
    m_bHiden=NO;
    m_bPush=NO;
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

    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bNotPush,m_strName,@"m_bNotPush")];
    
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
    
    if(m_bLookTouch==YES)LOCK_TOUCH;
//    int *pMode=GET_INT_V(@"m_iMode");

    LastPointTouch.x=Point.x;
    LastPointTouch.y=Point.y;

    if(m_bNotPush==NO){
            
          if(m_bDrag==YES){
               [m_pObjMng->pMegaTree SetCell:LINK_ID_V(self,@"ObCheck")];
              
              if(m_iLayer==layerInterfaceSpace5){

                  m_bStartPush=YES;
                  [self SetLayer:m_iLayer+1];
                  [self SetTouch:YES WithLayer:m_iLayerTouch-1];
                  m_bLookTouch=NO;
                  
                }
            }
                
            [m_pParent PlaySound:m_strNameSound];
            
            OBJECT_PERFORM_SEL(m_strNameObject, m_strNameStage);
            [self SetPush];
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
-(void)MoveObject:(CGPoint)Point WithMode:(bool)bMoveIn{
    
    int *pMode=GET_INT_V(@"m_iMode");
    if(*pMode==0){
        
        if(m_bDrag==YES && m_bStartPush==YES){
            
            m_pCurPosition.x-=LastPointTouch.x-Point.x;
            m_pCurPosition.y-=LastPointTouch.y-Point.y;
            
            LastPointTouch.x=Point.x;
            LastPointTouch.y=Point.y;
            
            if(m_pCurPosition.x<-440)m_pCurPosition.x=-440;
            if(m_pCurPosition.x>-40)m_pCurPosition.x=-40;
            
            if(m_pCurPosition.y<-280)m_pCurPosition.y=-280;
            if(m_pCurPosition.y>170)m_pCurPosition.y=170;
            
            pString->X=m_pCurPosition.x;
            pString->Y=m_pCurPosition.y;
        }
    }
    else
    {
        if(m_bStartMove==NO && bMoveIn==YES){
            
            [m_pObjMng->pMegaTree SetCell:(LINK_ID_V(self,@"DragObject"))];

            Ob_IconDrag *pOb=UNFROZE_OBJECT(@"Ob_IconDrag",@"IconDrag",
                           SET_FLOAT_V(54,@"mWidth"),
                           SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
                           SET_BOOL_V(NO,@"bFromEmpty"),
                           SET_VECTOR_V(m_pCurPosition,@"m_pCurPosition"),
                           SET_INT_V(mTextureId,@"mTextureId"));
            
            pOb->pInsideString=pString;

            m_bStartMove=YES;
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
 //   if(m_bLookTouch==YES)LOCK_TOUCH;
    
    [self SetPush];
    
    [self MoveObject:Point WithMode:YES];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
//    if(m_bLookTouch==YES)LOCK_TOUCH;

//    if(m_bStartPush==NO)[self SetUnPush];
    
//    [m_pObjMng->pMegaTree SetCell:LINK_ID_V(self,@"ObCheck")];
    OBJECT_PERFORM_SEL(m_strNameObject, m_strNameStage);
    
    [self MoveObject:Point WithMode:NO];
}
//------------------------------------------------------------------------------------------------------
- (void)EndTouch{
        
    m_bStartPush=NO;
    m_bStartMove=NO;
    
    int *pMode=GET_INT_V(@"m_iMode");
    
    if(m_iLayer==layerInterfaceSpace6){
        m_bLookTouch=YES;
        
        GObject *pOb=[m_pObjMng GetObjectByName:@"ButtonTach"];
        CGPoint Point;
        Point.x=m_pCurPosition.x;
        Point.y=m_pCurPosition.y;
        
        if([pOb Intersect:Point])
        {
            [m_pObjMng->pStringContainer DelString:pString];
        }
        else if(pMode!=0 && *pMode==0)
        {
            GObject *pObGroup = [m_pObjMng GetObjectByName:@"GroupButtons"];

            if(pObGroup!=nil)
            {
                for (ObjectB_Ob *pObob in pObGroup->m_pChildrenbjectsArr)
                {
                    if(pObob==self)continue;
                    else
                    {
                        if([pObob Intersect:Point])
                        {
                            [[FractalString alloc] initAsCopy:pString
                                WithParent:pObob->pString WithContainer:m_pObjMng->pStringContainer];
                            
                            [m_pObjMng->pStringContainer DelString:pString];
                            goto Exit;
                        }
                    }
                }
            }
        }
        
Exit:
        [self SetLayer:m_iLayer-1];
        [self SetTouch:YES WithLayer:m_iLayerTouch+1];
        DEL_CELL(@"DragObject");
        OBJECT_PERFORM_SEL(@"GroupButtons",@"UpdateButt");
    }
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