//
//  Ob_ParticleCont_Ex.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_ParticleCont_ForStr.h"
//------------------------------------------------------------------------------------------------------
@implementation Particle_ForStr
-(id)Init:(GObject *)pObParent{

    self = [super init];
    if (self != nil)
    {
        m_pParticleContainer=[pObParent retain];
        
        m_fSize=1;
        m_cColor=pObParent->mColor;        
    }
    
    return self;
}
//------------------------------------------------------------------------------------------------------
-(void)SetFrame:(int)iFrame{

    if(m_pParticleContainer!=nil){
        
        m_iCurFrame=iFrame;
        GLfloat *m_pTexCoords=(m_pParticleContainer->texCoords+(m_iCurrentOffset)*12);

        float OffsetX=iFrame%((Ob_ParticleCont_ForStr *)m_pParticleContainer)->
        m_pAtlasContainer->m_iCountX;
        float OffsetY=iFrame/((Ob_ParticleCont_ForStr *)m_pParticleContainer)->
        m_pAtlasContainer->m_iCountX;

        float TmpStepX=((Ob_ParticleCont_ForStr *)m_pParticleContainer)->Xstep/
        ((Ob_ParticleCont_ForStr *)m_pParticleContainer)->m_pAtlasContainer->m_vSizeFrame.x;

        float TmpStepY=((Ob_ParticleCont_ForStr *)m_pParticleContainer)->Ystep/
        ((Ob_ParticleCont_ForStr *)m_pParticleContainer)->m_pAtlasContainer->m_vSizeFrame.y;

        CGRect R= CGRectMake(TmpStepX*OffsetX,TmpStepY*OffsetY,
        TmpStepX*(OffsetX+1),TmpStepY*(OffsetY+1) );

//////координаты текстуры
        m_pTexCoords[0]= R.origin.x;
        m_pTexCoords[1]= R.size.height;
        
        m_pTexCoords[2]= R.size.width;
        m_pTexCoords[3]= R.size.height;
        
        m_pTexCoords[6]= R.size.width;
        m_pTexCoords[7]= R.origin.y;
        
        m_pTexCoords[4]= R.origin.x;
        m_pTexCoords[5]= R.origin.y;

        m_pTexCoords[8]= m_pTexCoords[4];
        m_pTexCoords[9]= m_pTexCoords[5];
        m_pTexCoords[10]= m_pTexCoords[2];
        m_pTexCoords[11]= m_pTexCoords[3];
    }
}
//------------------------------------------------------------------------------------------------------
-(void)UpdateParticleMatr{
    Vertex3D *m_pVertices=(m_pParticleContainer->vertices+(m_iCurrentOffset)*6);
    
    float fSizeX=m_fSize+*X;
    float fSizeY=m_fSize+*Y;
    //координаты вершин
    m_pVertices[0]=Vector3DMake(-fSizeX,  fSizeY, 0.0f);
    m_pVertices[1]=Vector3DMake( fSizeX,  fSizeY, 0.0f);
    m_pVertices[2]=Vector3DMake(-fSizeX, -fSizeY, 0.0f);
    m_pVertices[3]=Vector3DMake( fSizeX, -fSizeY, 0.0f);
    m_pVertices[4]=m_pVertices[2];
    m_pVertices[5]=m_pVertices[1]; 
}
//------------------------------------------------------------------------------------------------------
-(void)UpdateParticleColor{
    
    GLubyte *m_pSquareColors=(m_pParticleContainer->squareColors+(m_iCurrentOffset)*24);
    
    ////цвет вершин
    m_pSquareColors[0]=m_cColor.red*255;
    m_pSquareColors[1]=m_cColor.green*255;
    m_pSquareColors[2]=m_cColor.blue*255;
    m_pSquareColors[3]=m_cColor.alpha*255;

    m_pSquareColors[4]=m_cColor.red*255;
    m_pSquareColors[5]=m_cColor.green*255;
    m_pSquareColors[6]=m_cColor.blue*255;
    m_pSquareColors[7]=m_cColor.alpha*255;

    m_pSquareColors[8]=m_cColor.red*255;
    m_pSquareColors[9]=m_cColor.green*255;
    m_pSquareColors[10]=m_cColor.blue*255;
    m_pSquareColors[11]=m_cColor.alpha*255;

    m_pSquareColors[12]=m_cColor.red*255;
    m_pSquareColors[13]=m_cColor.green*255;
    m_pSquareColors[14]=m_cColor.blue*255;
    m_pSquareColors[15]=m_cColor.alpha*255;

    m_pSquareColors[16]=m_pSquareColors[8];
    m_pSquareColors[17]=m_pSquareColors[9];
    m_pSquareColors[18]=m_pSquareColors[10];
    m_pSquareColors[19]=m_pSquareColors[11];

    m_pSquareColors[20]=m_pSquareColors[4];
    m_pSquareColors[21]=m_pSquareColors[5];
    m_pSquareColors[22]=m_pSquareColors[6];
    m_pSquareColors[23]=m_pSquareColors[7];
}
//------------------------------------------------------------------------------------------------------
-(void)UpdateParticle{

    [self UpdateParticleMatr];
    [self UpdateParticleColor];
}
//------------------------------------------------------------------------------------------------------
-(void)dealloc{
    [m_pParticleContainer release];
    [super dealloc];
}
@end
//------------------------------------------------------------------------------------------------------
@implementation Ob_ParticleCont_ForStr//container
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
    self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        pIndexParticles=[m_pObjMng->pStringContainer->m_OperationIndex InitMemory];

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
- (void)SetDefault{
    m_bHiden=NO;
    [m_pNameAtlas setString:@""];
}
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
-(void)CopySprite:(int)iPlaceDest source:(int)iPlaceSrc
{
    Vertex3D *m_pVertices=(vertices+(iPlaceDest)*6);
    Vertex3D *m_pVerticesSrc=(m_pObjMng->pStringContainer->
                        ArrayPoints->pCurrenContParSrc->vertices+(iPlaceSrc)*6);
    
    for (int i=0; i<6; i++) {
        m_pVertices[i]=m_pVerticesSrc[i];
    }
}
//------------------------------------------------------------------------------------------------------
-(void)SetDefaultVertex:(int)Place
{
    Vertex3D *m_pVertices=(vertices+(Place)*6);
    
    int iSize=10;
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
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];

    m_pNameAtlas=[NSMutableString stringWithString:@""];
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_pNameAtlas,m_strName,@"m_pNameAtlas")];
    
//    Processor_ex *pProc = [self START_QUEUE:@"TimeDie"];
//        ASSIGN_STAGE(@"Proc",@"Proc:",nil);
//    [self END_QUEUE:pProc name:@"TimeDie"];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];
        
    m_pAtlasContainer=[m_pParent->m_pTextureAtlasList objectForKey:m_pNameAtlas];
    
    if(m_pAtlasContainer!=nil){
        
        m_ICountFrames=m_pAtlasContainer->m_iCountY*m_pAtlasContainer->m_iCountX;
        
        Xstep=m_pAtlasContainer->m_vSizeFrame.x/m_pAtlasContainer->m_iCountX;
        Ystep=m_pAtlasContainer->m_vSizeFrame.y/m_pAtlasContainer->m_iCountY;
        
        GET_ATLAS_TEXTURE(mTextureId,m_pNameAtlas);
    }
    
 //   [self CreateNewParticle];
}
//------------------------------------------------------------------------------------------------------
- (void)SelfDrawOffset{
	    
	glVertexPointer(3, GL_FLOAT, 0, vertices);
    glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
   	
	glBindTexture(GL_TEXTURE_2D, -1);
	
	glTranslatef(m_pCurPosition.x+m_pObjMng->m_pParent->m_vOffset.x*m_fScaleOffset,
				 m_pCurPosition.y+m_pObjMng->m_pParent->m_vOffset.y*m_fScaleOffset,
				 m_pCurPosition.z);
	
	glRotatef(m_pCurAngle.z, 0, 0, 1);
	glScalef(m_pCurScale.x,m_pCurScale.y,m_pCurScale.z);
	
	glDrawArrays(GL_TRIANGLES, 0, m_iCountVertex);
}
//------------------------------------------------------------------------------------------------------
-(id)NewParticle{
    Particle_ForStr *pParticle=[[Particle_ForStr alloc] Init:self];
    pParticle->m_iStage=0;
    return pParticle;
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

    int Size=m_iCountVertex*sizeof(Vertex3D);
    [m_pData appendBytes:&Size length:sizeof(int)];
    [m_pData appendBytes:vertices length:Size];

    Size=m_iCountVertex*2*sizeof(GLfloat);
    [m_pData appendBytes:&Size length:sizeof(int)];
    [m_pData appendBytes:texCoords length:Size];

    Size=m_iCountVertex*4*sizeof(GLubyte);
    [m_pData appendBytes:&Size length:sizeof(int)];
    [m_pData appendBytes:squareColors length:Size];
    
    [m_pObjMng->pStringContainer->m_OperationIndex selfSave:m_pData WithData:pIndexParticles];
}
//------------------------------------------------------------------------------------------
-(void)selfLoad:(NSMutableData *)m_pData rpos:(int *)iCurReadingPos{

    //координаты вершин
    int iSize;
    int iReadSize=sizeof(int);
    [m_pData getBytes:&iSize range:NSMakeRange( *iCurReadingPos, iReadSize)];
    *iCurReadingPos += iReadSize;

    m_iCountVertex=iSize/6;
    
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
    
    [m_pObjMng->pStringContainer->m_OperationIndex
     selfLoad:m_pData rpos:iCurReadingPos WithData:pIndexParticles];
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{
    
    [m_pObjMng->pStringContainer->m_OperationIndex OnlyReleaseMemory:pIndexParticles];
    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
@end