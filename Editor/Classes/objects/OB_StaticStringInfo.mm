//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "OB_StaticStringInfo.h"
#import "UniCell.h"

@implementation OB_StaticStringInfo
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        mWidth=42;
        mHeight=42;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault
{    
    iIndexString=-1;
    m_bHiden=NO;
    [m_pNameTexture setString:@"m_NothingSrc.png"];
    m_pCurAngle=Vector3DMake(0, 0, 0);
    mColor=Color3DMake(1, 1, 1, 1);
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimFromTexture,m_strName,@"m_bDimFromTexture")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimMirrorX,m_strName,@"m_bDimMirrorX")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY")];

    [m_pObjMng->pMegaTree SetCell:LINK_INT_V(iIndexString,m_strName,@"iIndexString")];
}
//------------------------------------------------------------------------------------------------------
- (void)SelfDrawOffset{

    FractalString *pStrInside=[m_pObjMng->pStringContainer->ArrayPoints GetIdAtIndex:iIndexString];

    if(pStrInside!=nil)
    {
        glVertexPointer(3, GL_FLOAT, 0, vertices);
        glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
        glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);

        glTranslatef(m_pCurPosition.x,m_pCurPosition.y,m_pCurPosition.z);
        glRotatef(m_pCurAngle.z, 0, 0, 1);
        glScalef(m_pCurScale.x,m_pCurScale.y,m_pCurScale.z);

        int iType=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:pStrInside->m_iIndex];

        switch (iType)
        {
            case DATA_ARRAY:
            {
            int **ppArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:pStrInside->m_iIndex];
                
                if(ppArray==0)return;
                InfoArrayValue *pInfo=(InfoArrayValue *)(*ppArray);
                switch (pInfo->mType) {
                    case DATA_SPRITE:
                        mColorBack = Color3DMake(1,0,0,1);
                        break;
                    case DATA_TEXTURE:
                        mColorBack = Color3DMake(1,1,1,1);
                        break;
                    case DATA_SOUND:
                        mColorBack = Color3DMake(0,1,1,1);
                        break;
                    case DATA_FLOAT:
                        mColorBack = Color3DMake(0,0,1,1);
                        break;
                    case DATA_INT:
                        mColorBack = Color3DMake(1,1,0,1);
                        break;
                    case DATA_U_INT:
                        mColorBack = Color3DMake(1,0.5f,0,1);
                        break;
                        
                    default:
                        break;
                }
            }
                break;
                
                
            case DATA_MATRIX:
            {
                MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints
                                   GetMatrixAtIndex:pStrInside->m_iIndex];
                
                switch (pMatr->TypeInformation) {
                        
                    case STR_OPERATION:
                        mColorBack = Color3DMake(1, .4, 1, 1);
                        break;
                        
                    case STR_CONTAINER:
                        mColorBack = Color3DMake(0, 0, 0, 1);
                        //             if(pMatr->NameInformation==NAME_K_START)
                        //               bFlick=YES;
                        
                        break;
                        
                    case STR_COMPLEX:
                        mColorBack = Color3DMake(0, 1, 0, 1);
                        break;
                        
                    default:
                        break;
                }
                break;
            }
            default:
                mColorBack = Color3DMake(0,0,0,0);
                break;
        }
        
        [self SetColor:mColorBack];
        glBindTexture(GL_TEXTURE_2D, -1);
        glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
        
        [self SetColor:mColor];
        
        GET_TEXTURE(mTextureId, pStrInside->sNameIcon);
        glBindTexture(GL_TEXTURE_2D, mTextureId);
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
        
        if(iType==DATA_ARRAY)
        {
            int **ppArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:pStrInside->m_iIndex];
            if(ppArray==0)return;
            InfoArrayValue *pInfo=(InfoArrayValue *)(*ppArray);
            
            if(pInfo->UnParentMatrix.indexMatrix!=0)
            {
                MATRIXcell *pMatr = [m_pObjMng->pStringContainer->ArrayPoints
                                     GetMatrixAtIndex:pInfo->UnParentMatrix.indexMatrix];
                
                if(pMatr!=0)
                {
                    FractalString *pStringTmp=(FractalString *)
                    [m_pObjMng->pStringContainer->ArrayPoints
                     GetIdAtIndex:pMatr->iIndexString];
                    
                    if(pStringTmp!=0)
                    {
                        int iTextureMatrix;
                        GET_TEXTURE(iTextureMatrix, pStringTmp->sNameIcon);
                        
                        glScalef(0.5f,0.5f,1);
                        glTranslatef(-1.2f,1.5f,0);
                        
                        glBindTexture(GL_TEXTURE_2D, iTextureMatrix);
                        glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
                    }
                }
            }
            else
            {
                glScalef(0.5f,0.5f,1);
                glTranslatef(-1.2f,1.5f,0);
            }
        }
        else
        {
            glScalef(0.5f,0.5f,1);
            glTranslatef(-1.2f,1.5f,0);
        }
        
        if(![pStrInside->sNameIcon2 isEqualToString:@"0.png"])
        {
            //   glScalef(0.5f,0.5f,1);
            glTranslatef(0.5f,-3.5,0);
            
            int iTex=-1;
            GET_TEXTURE(iTex, pStrInside->sNameIcon2);
            glBindTexture(GL_TEXTURE_2D, iTex);
            
            glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
            
            if(![pStrInside->sNameIcon3 isEqualToString:@"0.png"])
            {
                glTranslatef(2.0f,0,0);
                
                int iTex=-1;
                GET_TEXTURE(iTex, pStrInside->sNameIcon3);
                glBindTexture(GL_TEXTURE_2D, iTex);
                
                glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
            }
        }
        else if(![pStrInside->sNameIcon3 isEqualToString:@"0.png"])
        {
            //    glScalef(0.5f,0.5f,1);
            glTranslatef(0.5f,-3.5f,0);
            
            int iTex=-1;
            GET_TEXTURE(iTex, pStrInside->sNameIcon3);
            glBindTexture(GL_TEXTURE_2D, iTex);
            
            glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
        }
    }
    else
    {
        GET_TEXTURE(mTextureId, @"m_NothingSrc.png");
        [super SelfDrawOffset];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
    if(m_bDimFromTexture){GET_DIM_FROM_TEXTURE(m_pNameTexture);}

	[super Start];
    
    if(m_bDimMirrorX){m_pCurScale.x=-m_pCurScale.x;}
    if(m_bDimMirrorY){m_pCurScale.y=-m_pCurScale.y;}
}
- (void)sfMove{}
//------------------------------------------------------------------------------------------------------
@end

