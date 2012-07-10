//
//  Ob_ParticleCont_Ex.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_ParticleCont_ForStr.h"

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

        float OffsetX=iFrame%((Ob_ParticleCont_ForStr *)m_pParticleContainer)->m_pAtlasContainer->m_iCountX;
        float OffsetY=iFrame/((Ob_ParticleCont_ForStr *)m_pParticleContainer)->m_pAtlasContainer->m_iCountX;

        float TmpStepX=((Ob_ParticleCont_ForStr *)m_pParticleContainer)->Xstep/((Ob_ParticleCont_ForStr *)m_pParticleContainer)->m_pAtlasContainer->m_vSizeFrame.x;

        float TmpStepY=((Ob_ParticleCont_ForStr *)m_pParticleContainer)->Ystep/((Ob_ParticleCont_ForStr *)m_pParticleContainer)->m_pAtlasContainer->m_vSizeFrame.y;

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
    
    //координаты вершин
    m_pVertices[0]=Vector3DMake(-m_fSize+*X,  m_fSize+*Y, 0.0f);
    m_pVertices[1]=Vector3DMake( m_fSize+*X,  m_fSize+*Y, 0.0f);
    m_pVertices[2]=Vector3DMake(-m_fSize+*X, -m_fSize+*Y, 0.0f);
    m_pVertices[3]=Vector3DMake( m_fSize+*X, -m_fSize+*Y, 0.0f);
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
        m_iLayer = layerTemplet;

        mWidth  = 2;
        mHeight = 2;
        
        m_pParticleInProc = [[NSMutableArray alloc] init];
        m_pParticleInFreeze = [[NSMutableArray alloc] init];

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
- (void)LinkValues{
    [super LinkValues];

    m_pNameAtlas=[NSMutableString stringWithString:@""];
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_pNameAtlas,m_strName,@"m_pNameAtlas")];
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
   	
	glBindTexture(GL_TEXTURE_2D, mTextureId);
	
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
-(id)CreateParticle{

    Particle_ForStr *pParticle;
    
    int iFreezCount=[m_pParticleInFreeze count];
    if(iFreezCount>0)
    {
        pParticle=[m_pParticleInFreeze objectAtIndex:0];
        [m_pParticleInFreeze removeObjectAtIndex:0];
    }
    else 
    {
        pParticle=[self NewParticle];

        int iCount=[m_pParticleInProc count];

        [m_pParticleInProc addObject:pParticle];
        [pParticle release];

        m_iCountVertex=6*(iCount+1);
        
        vertices=(Vertex3D *)realloc(vertices,m_iCountVertex*sizeof(Vertex3D));
        texCoords=(GLfloat *)realloc(texCoords,m_iCountVertex*2*sizeof(GLfloat));
        squareColors=(GLubyte *)realloc(squareColors,m_iCountVertex*4*sizeof(GLubyte));
        
        pParticle->m_pParticleContainer=self;
        pParticle->m_iCurrentOffset=(iCount);
    }
//-------------------------------------------------------------------------
//    [pParticle UpdateParticle];

    return pParticle;
}
//------------------------------------------------------------------------------------------------------
-(void)RemoveParticle:(Particle_ForStr *)pParticle{
    
    int iCount=[m_pParticleInProc count]-1;
    
    Particle_ForStr *pParticleLast=(Particle_ForStr *)[m_pParticleInProc objectAtIndex:iCount];
//------------------------------------------------------------------------------------------------------
    Vertex3D *m_pVerticesS=(vertices+(pParticleLast->m_iCurrentOffset)*6);
    Vertex3D *m_pVerticesD=(vertices+(pParticle->m_iCurrentOffset)*6);
    
    memcpy(m_pVerticesD, m_pVerticesS, 72);
    
    GLfloat *m_pTexCoordsS=(texCoords+(pParticleLast->m_iCurrentOffset)*12);
    GLfloat *m_pTexCoordsD=(texCoords+(pParticle->m_iCurrentOffset)*12);
    
    memcpy(m_pTexCoordsD, m_pTexCoordsS, 48);
    
    GLubyte *m_pSquareColorsS=(squareColors+(pParticleLast->m_iCurrentOffset)*24);
    GLubyte *m_pSquareColorsD=(squareColors+(pParticle->m_iCurrentOffset)*24);
    
    memcpy(m_pSquareColorsD, m_pSquareColorsS, 24);
    
    pParticleLast->m_iCurrentOffset=pParticle->m_iCurrentOffset;
    
    [m_pParticleInProc replaceObjectAtIndex:pParticle->m_iCurrentOffset withObject:pParticleLast];
    [m_pParticleInProc removeLastObject];
    
    pParticle->m_pParticleContainer=nil;
    
    m_iCountVertex=6*(iCount);
    
    if(pParticle->m_iStage==-1){
        [m_pParticleInFreeze removeLastObject];
    }
    
    vertices=(Vertex3D *)realloc(vertices,m_iCountVertex*sizeof(Vertex3D));
    texCoords=(GLfloat *)realloc(texCoords,m_iCountVertex*2*sizeof(GLfloat));
    squareColors=(GLubyte *)realloc(squareColors,m_iCountVertex*4*sizeof(GLubyte));
}
//------------------------------------------------------------------------------------------------------
-(void)RemoveAllParticles{
    int iCount=[m_pParticleInProc count];
    
    for (int i=0;i<iCount;i++) {
        Particle_ForStr *pPar=[m_pParticleInProc objectAtIndex:0];
        [self RemoveParticle:pPar];
    }
}
//------------------------------------------------------------------------------------------------------
-(void)FrezeParticle:(Particle_ForStr *)pParticle{

    [m_pParticleInFreeze addObject:pParticle];
    if(pParticle->X!=0)(*pParticle->X)+=4000+RND;
    pParticle->m_iStage=-1;
    [pParticle UpdateParticle];
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{
    [m_pParticleInProc release];
    [m_pParticleInFreeze release];
    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
@end