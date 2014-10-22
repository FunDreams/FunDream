//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectB_Ob_Array.h"
#import "UniCell.h"
#import "Ob_IconDragArray.h"
#import "Ob_Editor_Interface.h"
#import "Ob_Arrow.h"
#import "Ob_Editor_Num.h"
#import "MainCycle.h"
#import "Ob_ParticleCont_ForStr.h"

@implementation ObjectB_Ob_Array
//------------------------------------------------------------------------------------------------------
- (void)UpdateTextureOnFace{
    
    mCountTmp++;
    NSString *pStr;
    
    if(mCountTmp>=10)
    {
        mCountTmp=0;
                
        switch (m_iTypeStr)
        {                    
            case DATA_FLOAT:
            {
                float *Tmpf=(float *)[m_pObjMng->pStringContainer->
                                      ArrayPoints GetDataAtIndex:m_iIndexArray];
                
                pStr = [NSString stringWithFormat:@"%1.2f",*Tmpf];
                
                if(![StrValueOnFace isEqualToString:pStr])
                {
                    [StrValueOnFace release];
                    StrValueOnFace=[[NSString stringWithString:pStr] retain];
                    
                    int iFontSize=10;
                    TextureIndicatorValue=[self CreateText:StrValueOnFace al:UITextAlignmentCenter
                                        Tex:TextureIndicatorValue fSize:iFontSize
                                        dimensions:CGSizeMake(mWidth, iFontSize+4) fontName:@"Gill Sans"];
                }
            }
            break;
                
            case DATA_INT:
            {
                float *Tmpf=(float *)[m_pObjMng->pStringContainer->
                                      ArrayPoints GetDataAtIndex:m_iIndexArray];
                
                pStr = [NSString stringWithFormat:@"%d",(int)*Tmpf];
                
                if(![StrValueOnFace isEqualToString:pStr])
                {
                    [StrValueOnFace release];
                    StrValueOnFace=[[NSString stringWithString:pStr] retain];
                    
                    int iFontSize=10;
                    TextureIndicatorValue=[self CreateText:StrValueOnFace al:UITextAlignmentCenter
                                                       Tex:TextureIndicatorValue fSize:iFontSize
                                                dimensions:CGSizeMake(mWidth, iFontSize+4) fontName:@"Gill Sans"];
                }
            }
                break;

                
            case DATA_SPRITE:
            {
                int *Tmpi=(int *)[m_pObjMng->pStringContainer->
                                  ArrayPoints GetDataAtIndex:m_iIndexArray];
                
                pStr = [NSString stringWithFormat:@"%d",*Tmpi];
                
                if(![StrValueOnFace isEqualToString:pStr])
                {
                    [StrValueOnFace release];
                    StrValueOnFace=[[NSString stringWithString:pStr] retain];
                    
                    int iFontSize=10;
                    TextureIndicatorValue=[self CreateText:StrValueOnFace al:UITextAlignmentCenter
                                        Tex:TextureIndicatorValue fSize:iFontSize
                                        dimensions:CGSizeMake(mWidth, iFontSize+4) fontName:@"Gill Sans"];
                }
            }
            break;

            case DATA_SOUND:
            {
                float *Tmpi=(float *)[m_pObjMng->pStringContainer->
                                  ArrayPoints GetDataAtIndex:m_iIndexArray];
                
                pStr = [NSString stringWithFormat:@"%d",(int)*Tmpi];
                
                if(![StrValueOnFace isEqualToString:pStr])
                {
                    [StrValueOnFace release];
                    StrValueOnFace=[[NSString stringWithString:pStr] retain];
                    
                    int iFontSize=10;
                    TextureIndicatorValue=[self CreateText:StrValueOnFace al:UITextAlignmentCenter
                                                       Tex:TextureIndicatorValue fSize:iFontSize
                                                dimensions:CGSizeMake(mWidth, iFontSize+4) fontName:@"Gill Sans"];
                }
            }
            break;

            case DATA_U_INT:
            {
             
                Ob_Editor_Interface *pInterface=(Ob_Editor_Interface *)[m_pObjMng
                                                GetObjectByName:@"Ob_Editor_Interface"];

                int **ppArray=[m_pObjMng->pStringContainer->
                        ArrayPoints GetArrayAtIndex:pInterface->ButtonGroup->pInsideString->m_iIndex];

                pStr = [NSString stringWithFormat:@"%d",*(*ppArray+SIZE_INFO_STRUCT+m_iIndexArray)];
                
                if(![StrValueOnFace isEqualToString:pStr])
                {
                    [StrValueOnFace release];
                    StrValueOnFace=[[NSString stringWithString:pStr] retain];
                    
                    int iFontSize=10;
                    TextureIndicatorValue=[self CreateText:StrValueOnFace al:UITextAlignmentCenter
                                Tex:TextureIndicatorValue fSize:iFontSize
                                dimensions:CGSizeMake(mWidth, iFontSize+4) fontName:@"Gill Sans"];
                }
            }
            break;
                
            default:
                break;
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
        
    m_fWaitTime=0;
    
    LOCK_TOUCH;
    
    m_bStartTouch=YES;
    
    LastPointTouch.x=Point.x;
    LastPointTouch.y=Point.y;
    
    Ob_Editor_Interface *pInterface=(Ob_Editor_Interface *)[m_pObjMng
                                                            GetObjectByName:@"Ob_Editor_Interface"];
    
    int** ppArray=[m_pObjMng->pStringContainer->ArrayPoints
                   GetArrayAtIndex:pInterface->ButtonGroup->pInsideString->m_iIndex];
    
    int IndexData=(*ppArray+SIZE_INFO_STRUCT)[m_iNum];
    int iType=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:IndexData];

    if(iType==DATA_SOUND)
    {
        float *Data=(float*)[m_pObjMng->pStringContainer->ArrayPoints GetDataAtIndex:IndexData];
        
        ResourceCell *TmpCell=m_pObjMng->pStringContainer->ArrayPoints->
        pCurrenContPar->pSoundRes->pCells+(int)(*Data);
        
        PLAY_SOUND(TmpCell->sName);
    }
    else {PLAY_SOUND(@"take.wav");}
    
    if(m_bNotPush==NO)
    {
        [m_pObjMng->pMegaTree SetCell:LINK_ID_V(self,@"ObCheckObArray")];
                
        OBJECT_PERFORM_SEL(m_strNameObject, m_strNameStage);
        [self SetPush];
    }
    
    if(m_bDoubleTouch==YES)
    {
        m_bDoubleTouch=NO;
        
        Ob_Editor_Interface *pInterface=(Ob_Editor_Interface *)[m_pObjMng
                                                GetObjectByName:@"Ob_Editor_Interface"];
        
        int **ppArray=[m_pObjMng->pStringContainer->ArrayPoints
                   GetArrayAtIndex:pInterface->ButtonGroup->pInsideString->m_iIndex];
        
        InfoArrayValue *pInfoValue=(InfoArrayValue *)*ppArray;
                
        switch (pInfoValue->mType)
        {
            case DATA_FLOAT:
            case DATA_INT:
            case DATA_U_INT:
            {
                Ob_Editor_Interface *pInterface = (Ob_Editor_Interface *)[m_pObjMng GetObjectByName:@"Ob_Editor_Interface"];
                
                pInterface->iIndexForNum=pInterface->IndexSelect;
                [pInterface SetMode:M_EDIT_NUM];
            }
            break;
                
            case DATA_TEXTURE:
            {
                SET_CELL(LINK_INT_V(m_iIndexPlace,@"m_iIndexPlace"));
                SET_CELL(LINK_ID_V(pString,@"DoubleTouchFractalString"));
                OBJECT_PERFORM_SEL(@"Ob_Editor_Interface", @"SelTexture");
            }
            break;

            case DATA_SOUND:
            {
                SET_CELL(LINK_INT_V(m_iIndexPlace,@"m_iIndexPlace"));
                SET_CELL(LINK_ID_V(pString,@"DoubleTouchFractalString"));
                OBJECT_PERFORM_SEL(@"Ob_Editor_Interface", @"SelSound");
            }
            break;

            default:
                break;
        }
    }
    else
    {
        NEXT_STAGE_EX(NAME(self), @"DTouch");
        m_bDoubleTouch=YES;
    }
}
//------------------------------------------------------------------------------------------------------
-(void)MoveObject:(CGPoint)Point WithMode:(bool)bMoveIn{
    
   // int *pMode=GET_INT_V(@"m_iMode");
    SET_STAGE_EX(NAME(self), @"Wait", @"Stop");
    
    if(m_bStartMove==NO && m_bStartTouch==YES){
        
//        [m_pObjMng->pMegaTree SetCell:(LINK_ID_V(pString,@"DragObject"))];
        
        Ob_IconDragArray *pOb=UNFROZE_OBJECT(@"Ob_IconDragArray",@"IconDrag",
                                        SET_FLOAT_V(44,@"mWidth"),
                                        SET_FLOAT_V(44,@"mHeight"),
                                        SET_BOOL_V(NO,@"bFromEmpty"),
                                        SET_VECTOR_V(m_pCurPosition,@"m_pCurPosition"),
                                        SET_STRING_V(@"",@"m_pNameTexture"));
        
        Ob_Editor_Interface *pInterface=(Ob_Editor_Interface *)[m_pObjMng
                                            GetObjectByName:@"Ob_Editor_Interface"];

        pString->m_iCurState=m_iNum;
        [m_pObjMng->pMegaTree SetCell:(LINK_ID_V(pString,@"DragObject"))];

        pOb->pInsideString=pString;
        pOb->m_iArrayIndex=pInterface->ButtonGroup->pInsideString->m_iIndex;
        pOb->NumInArray=m_iNum;

        m_bStartMove=YES;
    }    
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    [self SetPush];
    [self MoveObject:Point WithMode:YES];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    SET_STAGE_EX(NAME(self), @"Wait", @"Stop");
    
    if(m_bStartPush==NO)[self SetUnPush];
    [self MoveObject:Point WithMode:NO];
}
//------------------------------------------------------------------------------------------------------
- (void)SelfDrawOffset{

    switch (m_iTypeStr){
        case DATA_FLOAT:
        case DATA_INT:
        case DATA_U_INT:
        case DATA_SPRITE:
        case DATA_SOUND:
        {
            glVertexPointer(3, GL_FLOAT, 0, vertices);
            glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
            glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
            
            glTranslatef(m_pCurPosition.x+m_pObjMng->m_pParent->m_vOffset.x*m_fScaleOffset,
                         m_pCurPosition.y+m_pObjMng->m_pParent->m_vOffset.y*m_fScaleOffset,
                         m_pCurPosition.z);
            
            glRotatef(m_pCurAngle.z, 0, 0, 1);
            glScalef(m_pCurScale.x,m_pCurScale.y,m_pCurScale.z);
            
            [self SetColor:mColorBack];
            
            glBindTexture(GL_TEXTURE_2D, -1);
            
            if(m_bBack==YES){
                glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
            }
            
            glScalef(0.9f,0.9f,1);
            [self SetColor:mColor];
            
//                glBindTexture(GL_TEXTURE_2D, mTextureId);
            glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
                            
            [self UpdateTextureOnFace];
            [self drawTextAtX:m_pCurPosition.x Y:m_pCurPosition.y-10
                        Color:Color3DMake(0,0,0,1) Tex:TextureIndicatorValue];
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
            glScalef(m_pCurScale.x,m_pCurScale.y,m_pCurScale.z);
            
            [self SetColor:mColorBack];
            
            int **ppArray=[m_pObjMng->pStringContainer->ArrayPoints
                           GetArrayAtIndex:pString->m_iIndex];
            
            if(ppArray!=0){
                int *pStartData=(*ppArray)+SIZE_INFO_STRUCT;
                
                mTextureId=[m_pObjMng->pStringContainer->ArrayPoints
                                         GetResAtIndex:pStartData[m_iIndexPlace]];

//                GET_TEXTURE(mTextureId, StrTex);
                glBindTexture(GL_TEXTURE_2D, mTextureId);
            }
            else glBindTexture(GL_TEXTURE_2D, -1);
            
            if(m_bBack==YES){
                glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
            }
            
            glScalef(0.9f,0.9f,1);
            [self SetColor:mColor];
            
            //                glBindTexture(GL_TEXTURE_2D, mTextureId);
            glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
            
        }
        break;

        default:
            break;
    }
    
    int iCount=[m_pObjMng->pStringContainer->ArrayPoints GetCountAtIndex:m_iIndexArray];
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
        [self drawTextAtX:m_pCurPosition.x Y:m_pCurPosition.y+10
                    Color:Color3DMake(0.3f,0,0,1) Tex:TextureIndicatorLink];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    [super Start];
    
    mWidth=44;
    mHeight=44;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point
{
    m_bStartTouch=NO;
//    [self EndTouch:Point];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEndedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
//    [self EndTouch:Point];
    m_bStartTouch=NO;
}
//------------------------------------------------------------------------------------------------------
@end