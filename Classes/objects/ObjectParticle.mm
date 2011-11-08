//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectParticle.h"

@implementation Particle
-(id)Init:(GObject *)pObParent{
    
    m_pParent=[pObParent retain];
    m_vPos=&pObParent->m_pCurPosition;
    m_vScale=&pObParent->m_pCurScale;
    m_fAngle=&pObParent->m_pCurAngle.z;
    m_cColor=&pObParent->mColor;
    
    m_cColor1=Color3DMake(1,1,1,1);
    m_cColor2=Color3DMake(1,1,1,1);
    m_cColor3=Color3DMake(1,1,1,1);
    m_cColor4=Color3DMake(1,1,1,1);
    
    
    m_vTex1=Vector3DMake(0, 1, 0);
    m_vTex2=Vector3DMake(1, 1, 0);
    m_vTex3=Vector3DMake(1, 0, 0);
    m_vTex4=Vector3DMake(0, 0, 0);
    
    return self;
}
//------------------------------------------------------------------------------------------------------
-(void)SetFrame:(int)iFrame{

    if(m_pParticleContainer!=nil){
        
        m_iNextFrame=iFrame;
        GLfloat *m_pTexCoords=(m_pParticleContainer->texCoords+(m_iCurrentOffset)*12);
        
        
        float OffsetX=iFrame%((ObjectParticle *)m_pParticleContainer)->m_iCountX;
        float OffsetY=iFrame/((ObjectParticle *)m_pParticleContainer)->m_iCountX;

        float TmpStepX=((ObjectParticle *)m_pParticleContainer)->Xstep/((ObjectParticle *)m_pParticleContainer)->m_vSize.x;

        float TmpStepY=((ObjectParticle *)m_pParticleContainer)->Ystep/((ObjectParticle *)m_pParticleContainer)->m_vSize.y;

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
-(void)RemoveFromContainer{
    
    if(m_pParticleContainer!=nil){
        
        [m_pParticleContainer->m_pObjMng->pMegaTree SetCell:LINK_ID_V(self,@"RemoveIdParticle")];
        
        SEL TmpSel=NSSelectorFromString(@"RemoveParticle");
        
        if ([m_pParticleContainer respondsToSelector:TmpSel])
            [m_pParticleContainer performSelector:TmpSel withObject:nil];
        
        m_pParticleContainer=nil;
    }
    
}
//------------------------------------------------------------------------------------------------------
-(void)AddToContainer:(NSString *)strNameContainer{
    
    GObject *ObjectParticle=[m_pParent->m_pObjMng GetObjectByName:strNameContainer];

    if(ObjectParticle!=nil && m_pParticleContainer==nil){
        
        m_pParticleContainer=ObjectParticle;
        
        [ObjectParticle->m_pObjMng->pMegaTree SetCell:LINK_ID_V(self,@"TmpIdParticle")];

        SEL TmpSel=NSSelectorFromString(@"AddParticle");
        
        if ([ObjectParticle respondsToSelector:TmpSel])
            [ObjectParticle performSelector:TmpSel withObject:nil];
    }
}
//------------------------------------------------------------------------------------------------------
-(void)UpdateParticleMatr{
    Vertex3D *m_pVertices=(m_pParticleContainer->vertices+(m_iCurrentOffset)*6);
    
    //////координаты вершин
    
    float fAngleRadians=*m_fAngle*3.14f/180;
    
    float fCos=cosf(fAngleRadians);//1
    float fSin=sinf(fAngleRadians);//0
    
    m_pVertices[0]=Vector3DMake(-fCos-fSin,  fCos-fSin, 0.0f);
    m_pVertices[1]=Vector3DMake( fCos-fSin,  fCos+fSin, 0.0f);
    m_pVertices[2]=Vector3DMake(-fCos+fSin, -fCos-fSin, 0.0f);
    m_pVertices[3]=Vector3DMake( fCos+fSin, -fCos+fSin, 0.0f);
    m_pVertices[4]=m_pVertices[2];
    m_pVertices[5]=m_pVertices[1]; 
    
    for (int i=0; i<6; i++) {
        m_pVertices[i].x*=m_vScale->x;
        m_pVertices[i].y*=m_vScale->y;
    }
    
    for (int i=0; i<6; i++) {
        m_pVertices[i].x+=m_vPos->x;
        m_pVertices[i].y+=m_vPos->y;
    }
}
//------------------------------------------------------------------------------------------------------
-(void)UpdateParticleTex4Vertex{
    GLfloat *m_pTexCoords=(m_pParticleContainer->texCoords+(m_iCurrentOffset)*12);
    
    //////координаты текстуры
    
    m_pTexCoords[0]= m_vTex1.x;
    m_pTexCoords[1]= m_vTex1.y;
    
    m_pTexCoords[2]= m_vTex2.x;
    m_pTexCoords[3]= m_vTex2.y;
    
    m_pTexCoords[6]= m_vTex3.x;
    m_pTexCoords[7]= m_vTex3.y;
    
    m_pTexCoords[4]= m_vTex4.x;
    m_pTexCoords[5]= m_vTex4.y;
    
    
    m_pTexCoords[8]= m_pTexCoords[4];
    m_pTexCoords[9]= m_pTexCoords[5];
    m_pTexCoords[10]= m_pTexCoords[2];
    m_pTexCoords[11]= m_pTexCoords[3];
}
//------------------------------------------------------------------------------------------------------
-(void)UpdateParticleTex{
    GLfloat *m_pTexCoords=(m_pParticleContainer->texCoords+(m_iCurrentOffset)*12);
    
    //////координаты текстуры
    
    m_pTexCoords[0]= 0.0f+m_vOffsetTex.x;
    m_pTexCoords[1]= 1.0f+m_vOffsetTex.y;
    
    m_pTexCoords[2]= 1.0f+m_vOffsetTex.x;
    m_pTexCoords[3]= 1.0f+m_vOffsetTex.y;
    
    m_pTexCoords[6]= 1.0f+m_vOffsetTex.x;
    m_pTexCoords[7]= 0.0f+m_vOffsetTex.y;
    
    m_pTexCoords[4]= 0.0f+m_vOffsetTex.x;
    m_pTexCoords[5]= 0.0f+m_vOffsetTex.y;
    
    
    m_pTexCoords[8]= m_pTexCoords[4];
    m_pTexCoords[9]= m_pTexCoords[5];
    m_pTexCoords[10]= m_pTexCoords[2];
    m_pTexCoords[11]= m_pTexCoords[3];
}
//------------------------------------------------------------------------------------------------------
-(void)UpdateParticleColor4Vectex{
    
    GLubyte *m_pSquareColors=(m_pParticleContainer->squareColors+(m_iCurrentOffset)*24);
    
    ////цвет вершин
    m_pSquareColors[0]=m_cColor1.red*255;
    m_pSquareColors[1]=m_cColor1.green*255;
    m_pSquareColors[2]=m_cColor1.blue*255;
    m_pSquareColors[3]=m_cColor1.alpha*255;
    
    m_pSquareColors[4]=m_cColor2.red*255;
    m_pSquareColors[5]=m_cColor2.green*255;
    m_pSquareColors[6]=m_cColor2.blue*255;
    m_pSquareColors[7]=m_cColor2.alpha*255;
    
    m_pSquareColors[8]=m_cColor3.red*255;
    m_pSquareColors[9]=m_cColor3.green*255;
    m_pSquareColors[10]=m_cColor3.blue*255;
    m_pSquareColors[11]=m_cColor3.alpha*255;
    
    m_pSquareColors[12]=m_cColor4.red*255;
    m_pSquareColors[13]=m_cColor4.green*255;
    m_pSquareColors[14]=m_cColor4.blue*255;
    m_pSquareColors[15]=m_cColor4.alpha*255;
    
    
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
-(void)UpdateParticleColor{
    
    GLubyte *m_pSquareColors=(m_pParticleContainer->squareColors+(m_iCurrentOffset)*24);
    
    ////цвет вершин
    m_pSquareColors[0]=m_cColor->red*255;
    m_pSquareColors[1]=m_cColor->green*255;
    m_pSquareColors[2]=m_cColor->blue*255;
    m_pSquareColors[3]=m_cColor->alpha*255;

    m_pSquareColors[4]=m_cColor->red*255;
    m_pSquareColors[5]=m_cColor->green*255;
    m_pSquareColors[6]=m_cColor->blue*255;
    m_pSquareColors[7]=m_cColor->alpha*255;

    m_pSquareColors[8]=m_cColor->red*255;
    m_pSquareColors[9]=m_cColor->green*255;
    m_pSquareColors[10]=m_cColor->blue*255;
    m_pSquareColors[11]=m_cColor->alpha*255;

    m_pSquareColors[12]=m_cColor->red*255;
    m_pSquareColors[13]=m_cColor->green*255;
    m_pSquareColors[14]=m_cColor->blue*255;
    m_pSquareColors[15]=m_cColor->alpha*255;


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
    [self UpdateParticleTex];
    [self UpdateParticleColor];
}
//------------------------------------------------------------------------------------------------------
-(void)dealloc{
    [self RemoveFromContainer];
    [m_pParent release];
    [super dealloc];
}
@end
//------------------------------------------------------------------------------------------------------
@implementation ObjectParticle
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
    m_iLayer = layerTemplet;

    mWidth  = 2;
	mHeight = 2;
    
    m_pParticle = [[NSMutableDictionary alloc] init];

//START_QUEUE(@"Proc");
//	ASSIGN_STAGE(@"Idle",@"Idle:",nil);
 //   ASSIGN_STAGE(@"Proc",@"Proc:",nil);
//END_QUEUE(@"Proc");

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
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];

    SET_CELL(LINK_VECTOR_V(m_vSize,m_strName,@"m_vSize"));
    SET_CELL(LINK_INT_V(m_iCountX,m_strName,@"m_iCountX"));
    SET_CELL(LINK_INT_V(m_iCountY,m_strName,@"m_iCountY"));
    SET_CELL(LINK_INT_V(m_INumLoadTextures,m_strName,@"m_INumLoadTextures"));
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];
    
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

//  m_iLayerTouch=layerTouch_0;//слой касания
//  [self SetTouch:YES];//интерактивность

    //[m_pObjMng AddToGroup:@"NameGroup" Object:self];//группировка
    //[self SelfOffsetVert:Vector3DMake(0,1,0)];//cдвиг
}
//------------------------------------------------------------------------------------------------------
-(UInt32)LoadTextureAtlas{
    
    int IcureText=0;

    TextureContainer * TmpContainer=[m_pParent->m_pTextureList objectForKey:m_pNameTexture];
    
    if(TmpContainer!=nil)return TmpContainer->m_iTextureId;

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
-(void)AddParticle{

    Particle *pParticle=GET_ID_V(@"TmpIdParticle");

    if(pParticle!=nil){

        int iCount=[m_pParticle count];

        NSString *Str_Tmp=[NSString stringWithFormat:@"%d",iCount];
        [m_pParticle setObject:pParticle forKey:Str_Tmp];
//-------------------------------------------------------------------------
        m_iCountVertex=6*(iCount+1);

        vertices=(Vertex3D *)realloc(vertices,m_iCountVertex*sizeof(Vertex3D));
        texCoords=(GLfloat *)realloc(texCoords,m_iCountVertex*2*sizeof(GLfloat));
        squareColors=(GLubyte *)realloc(squareColors,m_iCountVertex*4*sizeof(GLubyte));
//-------------------------------------------------------------------------
        pParticle->m_pParticleContainer=self;
        pParticle->m_iCurrentOffset=(iCount);

        [pParticle UpdateParticle];
    }
}
//------------------------------------------------------------------------------------------------------
-(void)RemoveParticle{

    Particle *pParticle=GET_ID_V(@"RemoveIdParticle");

    if(pParticle!=nil){

        int iCount=[m_pParticle count]-1;

        NSString *Str_Last=[NSString stringWithFormat:@"%d",iCount];
        Particle *pParticleLast=(Particle *)[m_pParticle objectForKey:Str_Last];

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

        NSString *Str_Tmp=[NSString stringWithFormat:@"%d",pParticle->m_iCurrentOffset];
        [m_pParticle setObject:pParticleLast forKey:Str_Tmp];

        [m_pParticle removeObjectForKey:Str_Last];        
        pParticle->m_pParticleContainer=nil;

        m_iCountVertex=6*(iCount);
    }
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
//------------------------------------------------------------------------------------------------------//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{
    [m_pParticle release];
    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
@end