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
#import "Ob_Editor_Interface.h"
#import "Ob_Arrow.h"
#import "Ob_Editor_Num.h"

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
    m_bDrag=YES;
    m_bStartPush=NO;
    m_bStartMove=NO;
    m_bFlicker=NO;
    m_bStartTouch=NO;
    
    [m_DOWN setString:@""];
    [m_UP setString:@""];
    [m_strNameSound setString:@""];
    [m_strNameStage setString:@""];
    [m_strNameObject setString:@""];

    [m_strNameStageDClick setString:@""];
    [m_strNameObjectDClick setString:@""];
    
    mColorBack = Color3DMake(0, 1, 0, 1);
    m_bBack=YES;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    
    [m_pObjMng->pMegaTree SetCell:LINK_INT_V(m_iTypeStr,m_strName,@"m_iTypeStr")];

    [m_pObjMng->pMegaTree SetCell:LINK_COLOR_V(mColorBack,m_strName,@"mColorBack")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bBack,m_strName,@"m_bBack")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bFlicker,m_strName,@"m_bFlicker")];

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

    pProc = [self START_QUEUE:@"Flick"];
        ASSIGN_STAGE(@"Stop", @"Idle:",nil)
        ASSIGN_STAGE(@"ActionFlick",@"ActionFlick:",nil);
    [self END_QUEUE:pProc name:@"Flick"];    

    pProc = [self START_QUEUE:@"Wait"];
        ASSIGN_STAGE(@"Stop", @"Idle:",nil)
        ASSIGN_STAGE(@"Wait",@"Wait:",nil);
    [self END_QUEUE:pProc name:@"Wait"];
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
    m_bStartPush=NO;
    SET_STAGE_EX(NAME(self), @"Wait", @"Stop");
    
    if(m_bFlicker==YES)[self setFlick];
    else [self setUnFlick];
    
    mCountTmp=30;
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateTextureOnFace{
    
    mCountTmp++;
    
    if(mCountTmp>=10)
    {
        mCountTmp=0;
        
        if(pString==nil)return;
        
        switch (m_iTypeStr)
        {
            case DATA_SPRITE:
            {
                NSString *pStr=nil;
                int *Tmpi=(int *)[m_pObjMng->pStringContainer->
                                  ArrayPoints GetDataAtIndex:pString->m_iIndex];
                
                pStr = [NSString stringWithFormat:@"%d",*Tmpi];

                if(![StrValueSprite isEqualToString:pStr])
                {
                    [StrValueSprite release];
                    StrValueSprite=[[NSString stringWithString:pStr] retain];
                    
                    int iFontSize=20;
                    TextureIndicatorSprite=[self CreateText:StrValueSprite al:UITextAlignmentCenter
                                                Tex:TextureIndicatorValue fSize:iFontSize
                                                dimensions:CGSizeMake(mWidth-10, iFontSize+4)
                                                fontName:@"Helvetica"];
                }

            }
            break;
                
            case DATA_FLOAT:
            case DATA_INT:
            {
                NSString *pStr=nil;
                
                if(m_iTypeStr==DATA_FLOAT){
                    float *Tmpf=(float *)[m_pObjMng->pStringContainer->
                                          ArrayPoints GetDataAtIndex:pString->m_iIndex];
                    
                    pStr = [NSString stringWithFormat:@"%1.2f",*Tmpf];
                }
                else if(m_iTypeStr==DATA_INT){
                    int *Tmpi=(int *)[m_pObjMng->pStringContainer->
                                      ArrayPoints GetDataAtIndex:pString->m_iIndex];
                    
                    pStr = [NSString stringWithFormat:@"%d",*Tmpi];
                }
                
                if(![StrValueOnFace isEqualToString:pStr])
                {
                    [StrValueOnFace release];
                    StrValueOnFace=[[NSString stringWithString:pStr] retain];
                    
                    int iFontSize=10;
                    TextureIndicatorValue=[self CreateText:StrValueOnFace al:UITextAlignmentCenter
                            Tex:TextureIndicatorValue fSize:iFontSize
                            dimensions:CGSizeMake(mWidth-10, iFontSize+4) fontName:@"Gill Sans"];
                }
            }
                
                
            default:
                break;
        }
    }
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
- (void)setFlick{
    m_fPhase=0;
    mColorBack.alpha=1;
    SET_STAGE_EX(NAME(self), @"Flick", @"ActionFlick");
}
//------------------------------------------------------------------------------------------------------
- (void)setUnFlick{
    mColorBack.alpha=1;
    SET_STAGE_EX(NAME(self), @"Flick", @"Stop");
}
//------------------------------------------------------------------------------------------------------
- (void)PrepareActionFlick:(ProcStage_ex *)pStage{
    m_fPhase=0;
}
//------------------------------------------------------------------------------------------------------
- (void)ActionFlick:(Processor_ex *)pProc{
    
    m_fPhase+=DELTA*3;
    mColorBack.alpha=0.5f*cos(m_fPhase)+0.5f;
}
//------------------------------------------------------------------------------------------------------
- (void)Wait:(Processor_ex *)pProc{
    m_fWaitTime+=DELTA;
    
    if(m_fWaitTime>1){
        int iType=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:pString->m_iIndex];
        
        if(iType==DATA_FLOAT || iType==DATA_INT){
            
            Ob_Editor_Interface *pInterface = (Ob_Editor_Interface *)[m_pObjMng GetObjectByName:@"Ob_Editor_Interface"];
            
            pInterface->iIndexForNum=pString->m_iIndex;
            [pInterface SetMode:M_EDIT_NUM];
        }


        if(iType==DATA_TEXTURE){
            
            SET_CELL(LINK_ID_V(pString,@"DoubleTouchFractalString"));
            OBJECT_PERFORM_SEL(@"Ob_Editor_Interface", @"SelTexture");
        }

            
        SET_STAGE_EX(NAME(self), @"Wait", @"Stop");
    }
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

    int *pMode=GET_INT_V(@"m_iMode");
    
    SET_STAGE_EX(NAME(self), @"Wait", @"Wait");
    m_fWaitTime=0;

    LOCK_TOUCH;
    
    m_bStartTouch=YES;
//    int *pMode=GET_INT_V(@"m_iMode");

    LastPointTouch.x=Point.x;
    LastPointTouch.y=Point.y;
    
    PLAY_SOUND(@"take.wav");

    if(m_bNotPush==NO)
    {
        if(m_bDrag==YES)
        {
            if(*pMode==M_CONNECT)
            {
                [m_pObjMng->pMegaTree SetCell:(LINK_ID_V(pString,@"StartConnection"))];
            }

            [m_pObjMng->pMegaTree SetCell:LINK_ID_V(self,@"ObCheckOb")];

            if(m_iLayer==layerInterfaceSpace5){

                m_bStartPush=YES;
                [self SetLayer:m_iLayer+1];
                [self SetTouch:YES WithLayer:m_iLayerTouch-1];
            }
        }
                            
        OBJECT_PERFORM_SEL(m_strNameObject, m_strNameStage);
        [self SetPush];
    }

    if(m_bDoubleTouch==YES)
    {
        m_bDoubleTouch=YES;

        SET_CELL(LINK_ID_V(pString,@"DoubleTouchFractalString"));

        OBJECT_PERFORM_SEL(@"Ob_Editor_Interface", @"DoubleTouchObject");
    }
    else
    {
        NEXT_STAGE_EX(NAME(self), @"DTouch");
        m_bDoubleTouch=YES;
    }
}
//------------------------------------------------------------------------------------------------------
-(void)MoveObject:(CGPoint)Point WithMode:(bool)bMoveIn{
        
    int *pMode=GET_INT_V(@"m_iMode");
    SET_STAGE_EX(NAME(self), @"Wait", @"Stop");

    if(*pMode==M_MOVE){
        
        if(m_bDrag==YES && m_bStartPush==YES){

            m_pCurPosition.x-=LastPointTouch.x-Point.x;
            m_pCurPosition.y-=LastPointTouch.y-Point.y;

            LastPointTouch.x=Point.x;
            LastPointTouch.y=Point.y;

            if(m_pCurPosition.x<-450)m_pCurPosition.x=-450;
            if(m_pCurPosition.x>-40)m_pCurPosition.x=-40;

            if(m_pCurPosition.y<-300)m_pCurPosition.y=-300;
            if(m_pCurPosition.y>170)m_pCurPosition.y=170;

            pString->X=m_pCurPosition.x;
            pString->Y=m_pCurPosition.y;
            m_bStartMove=YES;
        }
    }
    else
    {
        if(*pMode==M_CONNECT){
            
            if(m_bStartMove==NO  && m_bStartTouch==YES){

                UNFROZE_OBJECT(@"Ob_Arrow",@"Arrow",
                                SET_VECTOR_V(m_pCurPosition,@"Start_Vector"));
                m_bStartMove=YES;
            }
        }
        else
        {
            if(m_bStartMove==NO && m_bStartTouch==YES){


                [m_pObjMng->pMegaTree SetCell:(LINK_ID_V(pString,@"DragObject"))];

                Ob_IconDrag *pOb=UNFROZE_OBJECT(@"Ob_IconDrag",@"IconDrag",
                               SET_FLOAT_V(54,@"mWidth"),
                               SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
                               SET_BOOL_V(NO,@"bFromEmpty"),
                               SET_VECTOR_V(m_pCurPosition,@"m_pCurPosition"),
                               SET_STRING_V(pString->sNameIcon,@"m_pNameTexture"));

                pOb->pInsideString=pString;
                m_bStartMove=YES;
            }
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
 //   if(m_bLookTouch==YES)LOCK_TOUCH;
    
    [self SetPush];
    [self MoveObject:Point WithMode:YES];
    
 //   NSLog(@"%@",self->m_strName);
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
//    if(m_bLookTouch==YES)LOCK_TOUCH;
    SET_STAGE_EX(NAME(self), @"Wait", @"Stop");

    if(m_bStartPush==NO)[self SetUnPush];
    
//    [m_pObjMng->pMegaTree SetCell:LINK_ID_V(self,@"ObCheck")];
 //   OBJECT_PERFORM_SEL(m_strNameObject, m_strNameStage);
    
    [self MoveObject:Point WithMode:NO];
}
//------------------------------------------------------------------------------------------------------
- (void)EndTouch{
        
    bool bUpdate=NO;
    SET_STAGE_EX(NAME(self), @"Wait", @"Stop");
    
    if(m_bStartPush==YES)
        PLAY_SOUND(@"drop.wav");
    
//    int *pMode=GET_INT_V(@"m_iMode");
    
    if(m_iLayer==layerInterfaceSpace6){
     //   m_bLookTouch=YES;
                
        Ob_Editor_Interface *Interface=(Ob_Editor_Interface *)
                    [m_pObjMng GetObjectByName:@"Ob_Editor_Interface"];
        
        GObject *pOb=nil;
        if(Interface!=nil)
            pOb=Interface->BTash;

        CGPoint Point;
        Point.x=m_pCurPosition.x;
        Point.y=m_pCurPosition.y;
        
        if([pOb Intersect:Point])
        {
            [m_pObjMng->pStringContainer DelString:pString];
            bUpdate=YES;
            goto Exit;
        }
 //       else if(pMode!=0 && *pMode==0 && m_bStartMove==YES)
 //       {
//            GObject *pObGroup = [m_pObjMng GetObjectByName:@"GroupButtons"];
//
//            if(pObGroup!=nil)
//            {
//                for (ObjectB_Ob *pObob in pObGroup->m_pChildrenbjectsArr)
//                {
//                    if(pObob==self)continue;
//                    else
//                    {
//                        if([pObob Intersect:Point])
//                        {//копирование внутрь объекта
//                            
//                            FractalString *StrNew = [[FractalString alloc] initAsCopy:pString
//                                    WithParent:pObob->pString
//                                        WithContainer:m_pObjMng->pStringContainer
//                                            WithLink:NO];
//                            
//                            StrNew->X=-440;
//                            StrNew->Y=170;
//                            
//                            [m_pObjMng->pStringContainer DelString:pString];
//                            bUpdate=YES;
//
//                            goto Exit;
//                        }
//                    }
//                }
//            }
 //       }
        
Exit:
        
        m_bStartTouch=NO;
        m_bStartPush=NO;
        m_bStartMove=NO;

        [self SetLayer:m_iLayer-1];
        [self SetTouch:YES WithLayer:m_iLayerTouch+1];
        DEL_CELL(@"DragObject");

        if(m_bPush==NO || bUpdate==YES)
            OBJECT_PERFORM_SEL(@"Ob_Editor_Interface",@"UpdateB");
    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    int *pMode=GET_INT_V(@"m_iMode");
    if(pMode!=0 && *pMode==M_CONNECT && m_bStartTouch==NO){
        FractalString *StartStr=GET_ID_V(@"StartConnection");
        
        if(StartStr!=nil)
            [m_pObjMng->pStringContainer ConnectStart:StartStr End:pString];
    }

    [self EndTouch];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEndedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    [self EndTouch];
}
//------------------------------------------------------------------------------------------------------
- (void)SelfDrawOffset{

    switch (m_iTypeStr)
    {
        case DATA_FLOAT:
        case DATA_INT:
        {
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
            
            [self SetColor:mColor];
            
//            glScalef(0.9f,0.9f,m_pCurScale.z);
//            [self SetColor:mColor];
//            
//            glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
            
//            glTranslatef(-0.68,0,0);
  //          glScalef(0.35f,1,m_pCurScale.z);
            glBindTexture(GL_TEXTURE_2D, mTextureId);
            glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);

            [self UpdateTextureOnFace];
            [self drawTextAtX:m_pCurPosition.x Y:m_pCurPosition.y-26
                        Color:Color3DMake(1,1,1,1) Tex:TextureIndicatorValue];
//draw text======================================================================================
//===============================================================================================
        }
        break;

        case DATA_TEXTURE:
        {
            glVertexPointer(3, GL_FLOAT, 0, vertices);
            glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
            glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);

            glTranslatef(m_pCurPosition.x+m_pObjMng->m_pParent->m_vOffset.x*m_fScaleOffset,
                         m_pCurPosition.y+m_pObjMng->m_pParent->m_vOffset.y*m_fScaleOffset,
                         m_pCurPosition.z);

            glRotatef(m_pCurAngle.z, 0, 0, 1);
            glScalef(m_pCurScale.x*1.1f,m_pCurScale.y*1.1f,m_pCurScale.z);

            [self SetColor:mColorBack];

            if(m_bBack==YES){
                glBindTexture(GL_TEXTURE_2D, -1);
                glDrawArrays(GL_TRIANGLE_STRIP,0,m_iCountVertex);
            }

            NSMutableString *StrTex=[m_pObjMng->pStringContainer->ArrayPoints
                                      GetIdAtIndex:pString->m_iIndex];
            GET_TEXTURE(mTextureId, StrTex);
            glBindTexture(GL_TEXTURE_2D, mTextureId);

            glScalef(0.9f,0.9f,m_pCurScale.z);
            [self SetColor:mColor];

            glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
        }
        break;

        case DATA_MATRIX:
        case DATA_SPRITE:
            
            glVertexPointer(3, GL_FLOAT, 0, vertices);
            glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
            glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
            
            glTranslatef(m_pCurPosition.x+m_pObjMng->m_pParent->m_vOffset.x*m_fScaleOffset,
                         m_pCurPosition.y+m_pObjMng->m_pParent->m_vOffset.y*m_fScaleOffset,
                         m_pCurPosition.z);
            
            glRotatef(m_pCurAngle.z, 0, 0, 1);
            glScalef(m_pCurScale.x*1.1f,m_pCurScale.y*1.1f,m_pCurScale.z);
            
            [self SetColor:mColorBack];
            
            if(m_bBack==YES){
                glBindTexture(GL_TEXTURE_2D, -1);
                glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
            }
            
    //        if(m_iTypeStr==DATA_MATRIX)
  //          {
                glBindTexture(GL_TEXTURE_2D, mTextureId);
//            }
//            else
//            {
//                glBindTexture(GL_TEXTURE_2D, -1);
//            }
            
            glScalef(1.06f,1.06f,m_pCurScale.z);
            
            [self SetColor:mColor];
            
            glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
            
            if(m_iTypeStr==DATA_SPRITE)
            {
                [self UpdateTextureOnFace];

                [self drawTextAtX:m_pCurPosition.x-14 Y:m_pCurPosition.y-11
                            Color:Color3DMake(0,0,0,1) Tex:TextureIndicatorSprite];

                [self drawTextAtX:m_pCurPosition.x-16 Y:m_pCurPosition.y-12
                            Color:Color3DMake(1,1,1,1) Tex:TextureIndicatorSprite];
            }
            break;
            
        default:
            break;
    }
    
    int iCount=[m_pObjMng->pStringContainer->ArrayPoints GetCountAtIndex:pString->m_iIndex];
    //рисуем количество ассоциаций
    if(iCount>1){
        NSString *pStr = [NSString stringWithFormat:@"%d",iCount];

        if(![StrValueOnLink isEqualToString:pStr])
        {
            [StrValueOnLink release];
            StrValueOnLink=[[NSString stringWithString:pStr] retain];
            
            int iFontSize=14;
            TextureIndicatorLink=[self CreateText:StrValueOnLink al:UITextAlignmentCenter
                        Tex:TextureIndicatorLink fSize:iFontSize
                        dimensions:CGSizeMake(mWidth-10, iFontSize+4) fontName:@"Gill Sans"];
        }
    }

    if (TextureIndicatorLink!=nil) {
        [self drawTextAtX:m_pCurPosition.x Y:m_pCurPosition.y+28
                    Color:Color3DMake(0,1,0,1) Tex:TextureIndicatorLink];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    
    [self SetTouch:NO];
    
    [TextureIndicatorLink release];
    TextureIndicatorLink=0;
    [TextureIndicatorValue release];
    TextureIndicatorValue=0;
    [StrValueOnFace release];
    StrValueOnFace=0;
    [StrValueOnLink release];
    StrValueOnLink=0;
    
    [super Destroy];
}
//------------------------------------------------------------------------------------------------------

@end