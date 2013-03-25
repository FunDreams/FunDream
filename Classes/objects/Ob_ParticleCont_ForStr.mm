//
//  Ob_ParticleCont_Ex.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_ParticleCont_ForStr.h"
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
//-(void)SetFrame:(int)iFrame{
//
//    if(m_pParticleContainer!=nil){
//        
//        m_iCurFrame=iFrame;
//        GLfloat *m_pTexCoords=(m_pParticleContainer->texCoords+(m_iCurrentOffset)*12);
//
//        float OffsetX=iFrame%((Ob_ParticleCont_ForStr *)m_pParticleContainer)->
//        m_pAtlasContainer->m_iCountX;
//        float OffsetY=iFrame/((Ob_ParticleCont_ForStr *)m_pParticleContainer)->
//        m_pAtlasContainer->m_iCountX;
//
//        float TmpStepX=((Ob_ParticleCont_ForStr *)m_pParticleContainer)->Xstep/
//        ((Ob_ParticleCont_ForStr *)m_pParticleContainer)->m_pAtlasContainer->m_vSizeFrame.x;
//
//        float TmpStepY=((Ob_ParticleCont_ForStr *)m_pParticleContainer)->Ystep/
//        ((Ob_ParticleCont_ForStr *)m_pParticleContainer)->m_pAtlasContainer->m_vSizeFrame.y;
//
//        CGRect R= CGRectMake(TmpStepX*OffsetX,TmpStepY*OffsetY,
//        TmpStepX*(OffsetX+1),TmpStepY*(OffsetY+1) );
//
////////координаты текстуры
//        m_pTexCoords[0]= R.origin.x;
//        m_pTexCoords[1]= R.size.height;
//        
//        m_pTexCoords[2]= R.size.width;
//        m_pTexCoords[3]= R.size.height;
//        
//        m_pTexCoords[6]= R.size.width;
//        m_pTexCoords[7]= R.origin.y;
//        
//        m_pTexCoords[4]= R.origin.x;
//        m_pTexCoords[5]= R.origin.y;
//
//        m_pTexCoords[8]= m_pTexCoords[4];
//        m_pTexCoords[9]= m_pTexCoords[5];
//        m_pTexCoords[10]= m_pTexCoords[2];
//        m_pTexCoords[11]= m_pTexCoords[3];
//    }
//}
//------------------------------------------------------------------------------------------------------
//-(void)UpdateParticleMatr{
//    Vertex3D *m_pVertices=(m_pParticleContainer->vertices+(m_iCurrentOffset)*6);
//    
//    float fSizeX=m_fSize+*X;
//    float fSizeY=m_fSize+*Y;
//    //координаты вершин
//    m_pVertices[0]=Vector3DMake(-fSizeX,  fSizeY, 0.0f);
//    m_pVertices[1]=Vector3DMake( fSizeX,  fSizeY, 0.0f);
//    m_pVertices[2]=Vector3DMake(-fSizeX, -fSizeY, 0.0f);
//    m_pVertices[3]=Vector3DMake( fSizeX, -fSizeY, 0.0f);
//    m_pVertices[4]=m_pVertices[2];
//    m_pVertices[5]=m_pVertices[1]; 
//}
////------------------------------------------------------------------------------------------------------
//-(void)UpdateParticleColor{
//    
//    GLubyte *m_pSquareColors=(m_pParticleContainer->squareColors+(m_iCurrentOffset)*24);
//    
//    ////цвет вершин
//    m_pSquareColors[0]=m_cColor.red*255;
//    m_pSquareColors[1]=m_cColor.green*255;
//    m_pSquareColors[2]=m_cColor.blue*255;
//    m_pSquareColors[3]=m_cColor.alpha*255;
//
//    m_pSquareColors[4]=m_cColor.red*255;
//    m_pSquareColors[5]=m_cColor.green*255;
//    m_pSquareColors[6]=m_cColor.blue*255;
//    m_pSquareColors[7]=m_cColor.alpha*255;
//
//    m_pSquareColors[8]=m_cColor.red*255;
//    m_pSquareColors[9]=m_cColor.green*255;
//    m_pSquareColors[10]=m_cColor.blue*255;
//    m_pSquareColors[11]=m_cColor.alpha*255;
//
//    m_pSquareColors[12]=m_cColor.red*255;
//    m_pSquareColors[13]=m_cColor.green*255;
//    m_pSquareColors[14]=m_cColor.blue*255;
//    m_pSquareColors[15]=m_cColor.alpha*255;
//
//    m_pSquareColors[16]=m_pSquareColors[8];
//    m_pSquareColors[17]=m_pSquareColors[9];
//    m_pSquareColors[18]=m_pSquareColors[10];
//    m_pSquareColors[19]=m_pSquareColors[11];
//
//    m_pSquareColors[20]=m_pSquareColors[4];
//    m_pSquareColors[21]=m_pSquareColors[5];
//    m_pSquareColors[22]=m_pSquareColors[6];
//    m_pSquareColors[23]=m_pSquareColors[7];
//}
////------------------------------------------------------------------------------------------------------
//-(void)UpdateParticle{
//
//    [self UpdateParticleMatr];
//    [self UpdateParticleColor];
//}
////------------------------------------------------------------------------------------------------------
//-(void)dealloc{
//    [m_pParticleContainer release];
//    [super dealloc];
//}
//@end
//------------------------------------------------------------------------------------------------------
@implementation Ob_ParticleCont_ForStr//container
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
    self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        pIndexParticles=[m_pObjMng->pStringContainer->m_OperationIndex InitMemory];
        pDrawPar=[m_pObjMng->pStringContainer->m_OperationIndex InitMemory];
        pDrawText=[m_pObjMng->pStringContainer->m_OperationIndex InitMemory];

        m_iLayer = layerGame;

        mWidth  = 2;
        mHeight = 2;
        
        free(vertices);
        free(texCoords);
        free(squareColors);	
        
        vertices=0;
        texCoords=0;
        squareColors=0;

        mTextureId=-1;
        mColor = Color3DMake(1.0f,1.0f,1.0f,1.0f);
        
        m_iCountVertex=0;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{m_bHiden=NO;}
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
-(void)CopySprite:(int)iPlaceDest source:(int)iPlaceSrc
{
    Vertex3D *m_pVertices=(vertices+(iPlaceDest)*6);
    Vertex3D *m_pVerticesSrc=(m_pObjMng->pStringContainer->
                        ArrayPoints->pCurrenContParSrc->vertices+(iPlaceSrc)*6);
    
    for (int i=0; i<6; i++)
        m_pVertices[i]=m_pVerticesSrc[i];


    GLubyte *m_pSquareColors=(squareColors+(iPlaceDest)*24);
    GLubyte *m_pSquareColorsSrc=(m_pObjMng->pStringContainer->
                        ArrayPoints->pCurrenContParSrc->squareColors+(iPlaceSrc)*24);
    
    for (int i=0; i<24; i++)
        m_pSquareColors[i]=m_pSquareColorsSrc[i];
    
    GLfloat *m_pTexCoords=(texCoords+(iPlaceDest)*12);
    GLfloat *m_pTexCoordsSrc=(m_pObjMng->pStringContainer->
                        ArrayPoints->pCurrenContParSrc->texCoords+(iPlaceSrc)*12);
    
    for (int i=0; i<12; i++)
        m_pTexCoords[i]=m_pTexCoordsSrc[i];
}
//------------------------------------------------------------------------------------------------------
-(void)DrawSprite:(int)Place tex:(int)iTex{
    
    [m_pObjMng->pStringContainer->m_OperationIndex OnlyAddData:Place WithData:pDrawPar];
    [m_pObjMng->pStringContainer->m_OperationIndex OnlyAddData:iTex WithData:pDrawText];
}
//------------------------------------------------------------------------------------------------------
-(void)UpdateSpriteVertex:(int)Place X:(float)X Y:(float)Y W:(float)W H:(float)H{
    
    Vertex3D *m_pVertices=(vertices+(Place)*6);

    float fHalfW=W*0.5f;
    float fHalfH=H*0.5f;
    //координаты вершин
    m_pVertices[0]=Vector3DMake(-fHalfW+X,  fHalfH+Y, 0.0f);
    m_pVertices[1]=Vector3DMake( fHalfW+X,  fHalfH+Y, 0.0f);
    m_pVertices[2]=Vector3DMake(-fHalfW+X, -fHalfH+Y, 0.0f);
    m_pVertices[3]=Vector3DMake( fHalfW+X, -fHalfH+Y, 0.0f);
    m_pVertices[4]=m_pVertices[2];
    m_pVertices[5]=m_pVertices[1];
}
//------------------------------------------------------------------------------------------------------
-(void)SetDefaultVertex:(int)Place
{
    Vertex3D *m_pVertices=(vertices+(Place)*6);
    
    int iSize=30;
    float X=RND_I_F(200, 100);
    float Y=RND_I_F(0, 100);
    //координаты вершин
    m_pVertices[0]=Vector3DMake(-iSize+X,  iSize+Y, 0.0f);
    m_pVertices[1]=Vector3DMake( iSize+X,  iSize+Y, 0.0f);
    m_pVertices[2]=Vector3DMake(-iSize+X, -iSize+Y, 0.0f);
    m_pVertices[3]=Vector3DMake( iSize+X, -iSize+Y, 0.0f);
    m_pVertices[4]=m_pVertices[2];
    m_pVertices[5]=m_pVertices[1];
    
    GLubyte *m_pSquareColors=(squareColors+(Place)*24);
    
    ////цвет вершин
    m_pSquareColors[0]=255;
    m_pSquareColors[1]=255;
    m_pSquareColors[2]=255;
    m_pSquareColors[3]=255;
    
    m_pSquareColors[4]=255;
    m_pSquareColors[5]=255;
    m_pSquareColors[6]=255;
    m_pSquareColors[7]=255;
    
    m_pSquareColors[8]=255;
    m_pSquareColors[9]=255;
    m_pSquareColors[10]=255;
    m_pSquareColors[11]=255;
    
    m_pSquareColors[12]=255;
    m_pSquareColors[13]=255;
    m_pSquareColors[14]=255;
    m_pSquareColors[15]=255;
    
    m_pSquareColors[16]=m_pSquareColors[8];
    m_pSquareColors[17]=m_pSquareColors[9];
    m_pSquareColors[18]=m_pSquareColors[10];
    m_pSquareColors[19]=m_pSquareColors[11];
    
    m_pSquareColors[20]=m_pSquareColors[4];
    m_pSquareColors[21]=m_pSquareColors[5];
    m_pSquareColors[22]=m_pSquareColors[6];
    m_pSquareColors[23]=m_pSquareColors[7];
    
    GLfloat *m_pTexCoords=(texCoords+(Place)*12);

    m_pTexCoords[0]= 0;
    m_pTexCoords[1]= 1;
    
    m_pTexCoords[2]= 1;
    m_pTexCoords[3]= 1;
    
    m_pTexCoords[6]= 1;
    m_pTexCoords[7]= 0;
    
    m_pTexCoords[4]= 0;
    m_pTexCoords[5]= 0;
    
    m_pTexCoords[8]= m_pTexCoords[4];
    m_pTexCoords[9]= m_pTexCoords[5];
    m_pTexCoords[10]= m_pTexCoords[2];
    m_pTexCoords[11]= m_pTexCoords[3];
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];
        
//    m_pAtlasContainer=[m_pParent->m_pTextureAtlasList objectForKey:m_pNameAtlas];
//    
//    if(m_pAtlasContainer!=nil){
//        
//        m_ICountFrames=m_pAtlasContainer->m_iCountY*m_pAtlasContainer->m_iCountX;
//        
//        Xstep=m_pAtlasContainer->m_vSizeFrame.x/m_pAtlasContainer->m_iCountX;
//        Ystep=m_pAtlasContainer->m_vSizeFrame.y/m_pAtlasContainer->m_iCountY;
//        
//        GET_ATLAS_TEXTURE(mTextureId,m_pNameAtlas);
//    }
//    
// //   [self CreateNewParticle];
}
//------------------------------------------------------------------------------------------------------
- (void)SelfDrawOffset{
	       
    glTranslatef(m_pCurPosition.x+m_pObjMng->m_pParent->m_vOffset.x*m_fScaleOffset,
                 m_pCurPosition.y+m_pObjMng->m_pParent->m_vOffset.y*m_fScaleOffset,
                 m_pCurPosition.z);
    
    glRotatef(m_pCurAngle.z, 0, 0, 1);
    glScalef(m_pCurScale.x,m_pCurScale.y,m_pCurScale.z);

    InfoArrayValue *pInfoDraw=(InfoArrayValue *)(*pDrawPar);
    int *StartData=(*pDrawPar)+SIZE_INFO_STRUCT;

    InfoArrayValue *pInfoTex=(InfoArrayValue *)(*pDrawText);
    int *StartDataTex=(*pDrawText)+SIZE_INFO_STRUCT;

    for (int i=0; i<pInfoDraw->mCount; i++) {
        
        int iPlace=StartData[i];
        int iTex=StartDataTex[i];
        
        glVertexPointer(3, GL_FLOAT, 0, vertices+(iPlace)*6);
        glTexCoordPointer(2, GL_FLOAT, 0, texCoords+(iPlace)*12);
        glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors+(iPlace)*24);

        glBindTexture(GL_TEXTURE_2D, iTex);

        glDrawArrays(GL_TRIANGLES, 0, 6);
    }
    
    pInfoDraw->mCount=0;
    pInfoTex->mCount=0;
}
//------------------------------------------------------------------------------------------------------
-(int)CreateParticle{

    InfoArrayValue *pInfoParticles=(InfoArrayValue *)(*pIndexParticles);
    int iCount=pInfoParticles->mCount;

    m_iCountVertex=6*(iCount+1);
    
    vertices=(Vertex3D *)realloc(vertices,m_iCountVertex*sizeof(Vertex3D));
    texCoords=(GLfloat *)realloc(texCoords,m_iCountVertex*2*sizeof(GLfloat));
    squareColors=(GLubyte *)realloc(squareColors,m_iCountVertex*4*sizeof(GLubyte));

    return iCount;
}
//------------------------------------------------------------------------------------------------------
-(void)RemoveParticle:(int)iIndexPar{
    
    InfoArrayValue *pInfoParticles=(InfoArrayValue *)(*pIndexParticles);
    int *pStartData=(*pIndexParticles)+SIZE_INFO_STRUCT;
    int iCount=pInfoParticles->mCount-1;
    int iIndexLast=pStartData[iCount];
    int iRetPlace=[m_pObjMng->pStringContainer->m_OperationIndex
              FindIndex:iIndexPar WithData:pIndexParticles];
//------------------------------------------------------------------------------------------------------
    Vertex3D *m_pVerticesS=(vertices+(iCount)*6);
    Vertex3D *m_pVerticesD=(vertices+(iRetPlace)*6);
    
    memcpy(m_pVerticesD, m_pVerticesS, 72);
    
    GLfloat *m_pTexCoordsS=(texCoords+(iCount)*12);
    GLfloat *m_pTexCoordsD=(texCoords+(iRetPlace)*12);
    
    memcpy(m_pTexCoordsD, m_pTexCoordsS, 48);

    GLubyte *m_pSquareColorsS=(squareColors+(iCount)*24);
    GLubyte *m_pSquareColorsD=(squareColors+(iRetPlace)*24);
    
    memcpy(m_pSquareColorsD, m_pSquareColorsS, 24);
    
    int *TmpPlace=(int *)[m_pObjMng->pStringContainer->ArrayPoints GetDataAtIndex:iIndexLast];
    *TmpPlace=iRetPlace;
    
    [m_pObjMng->pStringContainer->m_OperationIndex
            OnlyRemoveDataAtPlace:iRetPlace WithData:pIndexParticles];
    pInfoParticles=(InfoArrayValue *)(*pIndexParticles);

    m_iCountVertex=6*(iCount);
    
    vertices=(Vertex3D *)realloc(vertices,m_iCountVertex*sizeof(Vertex3D));
    texCoords=(GLfloat *)realloc(texCoords,m_iCountVertex*2*sizeof(GLfloat));
    squareColors=(GLubyte *)realloc(squareColors,m_iCountVertex*4*sizeof(GLubyte));
}
//------------------------------------------------------------------------------------------------------
-(void)RemoveAllParticles{
    InfoArrayValue *pInfoParticles=(InfoArrayValue *)(*pIndexParticles);
    int *pStartData=(*pIndexParticles)+SIZE_INFO_STRUCT;
    int iCount=pInfoParticles->mCount-1;
    
    for (int i=0;i<iCount;i++) {
        int TmpIndex=pStartData[0];
        [self RemoveParticle:TmpIndex];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
-(void)selfSave:(NSMutableData *)m_pData{
    
    [m_pObjMng->pStringContainer->m_OperationIndex selfSave:m_pData WithData:pIndexParticles];
    InfoArrayValue *pInfoParticles=(InfoArrayValue *)(*pIndexParticles);
    
    int Size=m_iCountVertex*sizeof(Vertex3D);
    [m_pData appendBytes:&Size length:sizeof(int)];
    [m_pData appendBytes:vertices length:Size];

    Size=m_iCountVertex*2*sizeof(GLfloat);
    [m_pData appendBytes:&Size length:sizeof(int)];
    [m_pData appendBytes:texCoords length:Size];

    Size=m_iCountVertex*4*sizeof(GLubyte);
    [m_pData appendBytes:&Size length:sizeof(int)];
    [m_pData appendBytes:squareColors length:Size];
    
}
//------------------------------------------------------------------------------------------
-(void)selfLoad:(NSMutableData *)m_pData rpos:(int *)iCurReadingPos{

    //количество вершин
    [m_pObjMng->pStringContainer->m_OperationIndex
     selfLoad:m_pData rpos:iCurReadingPos WithData:pIndexParticles];
    InfoArrayValue *pInfoParticles=(InfoArrayValue *)(*pIndexParticles);
    
    if(pInfoParticles->mCount>0){

        //координаты вершин
        int iSize;
        int iReadSize=sizeof(int);
        [m_pData getBytes:&iSize range:NSMakeRange( *iCurReadingPos, iReadSize)];
        *iCurReadingPos += iReadSize;
        
        vertices=(Vertex3D *)realloc(vertices, iSize);
        [m_pData getBytes:vertices range:NSMakeRange( *iCurReadingPos, iSize)];
        *iCurReadingPos += iSize;

        //координаты текстуры
        iReadSize=sizeof(int);
        [m_pData getBytes:&iSize range:NSMakeRange( *iCurReadingPos, iReadSize)];
        *iCurReadingPos += iReadSize;
        
        texCoords=(GLfloat *)realloc(texCoords, iSize);
        [m_pData getBytes:texCoords range:NSMakeRange( *iCurReadingPos, iSize)];
        *iCurReadingPos += iSize;

        //цвета вершин
        iReadSize=sizeof(int);
        [m_pData getBytes:&iSize range:NSMakeRange( *iCurReadingPos, iReadSize)];
        *iCurReadingPos += iReadSize;
        
        squareColors=(GLubyte *)realloc(squareColors, iSize);
        [m_pData getBytes:squareColors range:NSMakeRange( *iCurReadingPos, iSize)];
        *iCurReadingPos += iSize;
    }
    
    m_iCountVertex=6*(pInfoParticles->mCount);
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{
    
    [m_pObjMng->pStringContainer->m_OperationIndex OnlyReleaseMemory:pIndexParticles];
    [m_pObjMng->pStringContainer->m_OperationIndex OnlyReleaseMemory:pDrawPar];
    [m_pObjMng->pStringContainer->m_OperationIndex OnlyReleaseMemory:pDrawText];

    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
@end