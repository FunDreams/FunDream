//
//  Ob_ParticleCont_Ex.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_ParticleCont_Ex.h"

@implementation Particle_Ex
-(id)Init:(GObject *)pObParent{

    self = [super init];
    if (self != nil)
    {
        m_pParticleContainer=[pObParent retain];
        
        m_vPos=pObParent->m_pCurPosition;
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

        float OffsetX=iFrame%((Ob_ParticleCont_Ex *)m_pParticleContainer)->m_iCountX;
        float OffsetY=iFrame/((Ob_ParticleCont_Ex *)m_pParticleContainer)->m_iCountX;

        float TmpStepX=((Ob_ParticleCont_Ex *)m_pParticleContainer)->Xstep/((Ob_ParticleCont_Ex *)m_pParticleContainer)->m_vSize.x;

        float TmpStepY=((Ob_ParticleCont_Ex *)m_pParticleContainer)->Ystep/((Ob_ParticleCont_Ex *)m_pParticleContainer)->m_vSize.y;

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
    m_pVertices[0]=Vector3DMake(-m_fSize+m_vPos.x,  m_fSize+m_vPos.y, 0.0f);
    m_pVertices[1]=Vector3DMake( m_fSize+m_vPos.x,  m_fSize+m_vPos.y, 0.0f);
    m_pVertices[2]=Vector3DMake(-m_fSize+m_vPos.x, -m_fSize+m_vPos.y, 0.0f);
    m_pVertices[3]=Vector3DMake( m_fSize+m_vPos.x, -m_fSize+m_vPos.y, 0.0f);
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
@implementation Ob_ParticleCont_Ex//container
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

        m_vSize=Vector3DMake(128,128,0);
        m_iCountX=1;
        m_iCountY=1;
        m_INumLoadTextures=1;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];

    [m_pObjMng->pMegaTree SetCell:LINK_VECTOR_V(m_vSize,m_strName,@"m_vSize")];
    [m_pObjMng->pMegaTree SetCell:LINK_INT_V(m_iCountX,m_strName,@"m_iCountX")];
    [m_pObjMng->pMegaTree SetCell:LINK_INT_V(m_iCountY,m_strName,@"m_iCountY")];
    [m_pObjMng->pMegaTree SetCell:LINK_INT_V(m_INumLoadTextures,m_strName,@"m_INumLoadTextures")];
    
    //START_QUEUE(@"Proc");
    //	ASSIGN_STAGE(@"Idle",@"Idle:",nil);
    //   ASSIGN_STAGE(@"Proc",@"Proc:",nil);
    //END_QUEUE(@"Proc");
}
//------------------------------------------------------------------------------------------------------
- (void)PostSetParams{
    
    if(m_INumLoadTextures>1){
        
        m_ICountFrames=m_iCountY*m_iCountX;
        
        Xstep=m_vSize.x/m_iCountX;
        Ystep=m_vSize.y/m_iCountY;
        
        mTextureId=[self LoadTextureAtlas];
    }
    else {
        GET_TEXTURE(mTextureId,m_pNameTexture);
        m_vSize=Vector3DMake(mWidth,mHeight,0);
        
        m_ICountFrames=m_iCountY*m_iCountX;
        
        Xstep=m_vSize.x/m_iCountX;
        Ystep=m_vSize.y/m_iCountY;
        
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];
    
//  m_iLayerTouch=layerTouch_0;//слой касания
//  [self SetTouch:YES];//интерактивность

    //[m_pObjMng AddToGroup:@"NameGroup" Object:self];//группировка
    //[self SelfOffsetVert:Vector3DMake(0,1,0)];//cдвиг
}
//------------------------------------------------------------------------------------------------------
-(UInt32)LoadTextureAtlas{
    
    int IcureText=0;

    TextureContainer * TmpContainer=[m_pParent->m_pTextureList objectForKey:m_pNameTexture];
    
    if(TmpContainer!=nil)
        return TmpContainer->m_iTextureId;

    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    bundleRoot=[bundleRoot stringByAppendingString:@"/textureAtlas"];
    
    NSError *Error=[[NSError alloc] init];
    NSArray *dirContents = [[NSFileManager defaultManager] 
                            contentsOfDirectoryAtPath:bundleRoot error:&Error];
    
    UInt32	m_iTextureId=-1;
    
    //		NSLog(NameTexture);
    glBindTexture(GL_TEXTURE_2D, m_pParent->texture[m_pParent->m_iCount]);
    
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    
    GLuint width = m_vSize.x;
    GLuint height = m_vSize.y;
            
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *imageData = malloc( height * width * 4 );
    CGContextRef context = CGBitmapContextCreate( imageData, width, height, 8, 4 * width, colorSpace,kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
    
    // Flip the Y-axis
    CGContextTranslateCTM (context, 0, height);
    CGContextScaleCTM (context, 1.0, -1.0);
    
    CGColorSpaceRelease( colorSpace );
    CGContextClearRect( context, CGRectMake( 0, 0, width, height ) );
    bool mBstart=false;

    for (NSString *tString in dirContents) {

        if(mBstart==false){
            
            if([tString isEqualToString:m_pNameTexture]){
                
                mBstart=true;
            }
            else continue;
        }

        NSRange toprange = [tString rangeOfString: @"."];
        NSString *SubStr = [tString substringToIndex:toprange.location];
        NSString *SubStr1 = [tString substringFromIndex:toprange.location+1];

        NSString *REZ=[NSString stringWithString:@"textureAtlas/"];
        REZ=[REZ stringByAppendingString:SubStr];
//---------------------------------------------------------------
        NSString *path = [[NSBundle mainBundle] pathForResource:REZ ofType:SubStr1];
		
        if(path!=nil)
        {            
            NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
            UIImage *image = [[UIImage alloc] initWithData:texData];

            if (image == nil)
                NSLog(@"Do real error checking here");

            float OffsetX=IcureText%m_iCountX;
            float OffsetY=IcureText/m_iCountX;
            
            //копирование
            CGContextDrawImage( context,
                CGRectMake( Xstep*OffsetX, Ystep*OffsetY, Xstep, Ystep ), image.CGImage );
            
            [image release];
            [texData release];
            
            m_INumLoadTextures--;
            IcureText++;
            
            if(m_INumLoadTextures==0)break;
        }
    }
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);    
    
    m_iTextureId=m_pParent->texture[m_pParent->m_iCount];
    m_pParent->m_iCount++;
    
    TmpContainer=[[TextureContainer alloc] InitWithName:m_pNameTexture WithUint:m_iTextureId WithWidth:width WithWidth:height];
    
    [m_pParent->m_pTextureList setObject:TmpContainer forKey:m_pNameTexture];
    
    CGContextRelease(context);
    free(imageData);

    [Error release];
    return m_iTextureId;
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
    Particle_Ex *pParticle=[[Particle_Ex alloc] Init:self];
    return pParticle;
}
//------------------------------------------------------------------------------------------------------
-(id)CreateParticle{

    Particle_Ex *pParticle;
    
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
    [pParticle UpdateParticle];

    return pParticle;
}
//------------------------------------------------------------------------------------------------------
-(void)RemoveParticle:(Particle_Ex *)pParticle{

    [m_pParticleInFreeze addObject:pParticle];
    pParticle->m_vPos.x+=4000+RND;
    pParticle->m_iStage=-1;
    [pParticle UpdateParticle];
}
//------------------------------------------------------------------------------------------------------
- (void)TestSel:(Processor_ex *)pProc{

    m_pCurPosition.x+=30*DELTA;
    m_pCurAngle.z+=30*DELTA;

    m_pCurScale.x+=3*DELTA;
}
//------------------------------------------------------------------------------------------------------
- (void)InitProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)PrepareProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{
    m_pCurPosition.y-=15*DELTA;
    m_pCurAngle.z-=-10*DELTA;
    
//    m_pCurScale.y+=3*DELTA;
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