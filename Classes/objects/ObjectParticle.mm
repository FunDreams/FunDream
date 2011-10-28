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

    return self;
}

-(void)AddToContainer:(NSString *)strNameContainer{
    
    GObject *ObjectParticle=[m_pParent->m_pObjMng GetObjectByName:strNameContainer];

    if(ObjectParticle!=nil){
        
        [ObjectParticle->m_pObjMng->pMegaTree SetCell:LINK_ID_V(self,@"TmpIdParticle")];

        GObject *TmpObject = [ObjectParticle->m_pObjMng GetObjectByName:strNameContainer];
        SEL TmpSel=NSSelectorFromString(@"AddParticle");
        
        if ([TmpObject respondsToSelector:TmpSel])
            [TmpObject performSelector:TmpSel withObject:nil];
    }
}

-(void)UpdateParticle{
}

-(void)RemoveFromContainer{
}

-(void)dealloc{
    [self RemoveFromContainer];
    [m_pParent release];
    [super dealloc];
}
@end

@implementation ObjectParticle
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
    mWidth  = 80;
	mHeight = 80;
    
    m_pParticle = [[NSMutableDictionary alloc] init];

START_QUEUE(@"Proc");
	ASSIGN_STAGE(@"Idle",@"Idle:",nil);
    //	ASSIGN_STAGE(@"Proc",@"Proc:",nil);
END_QUEUE(@"Proc");

    free(vertices);
	free(texCoords);
	free(squareColors);	
    
    vertices=0;
    texCoords=0;
    squareColors=0;

//-------------------------------------------------------------------------

	m_iTemplateCountVertex=6;
    
	Templatevertices=(Vertex3D *)malloc(m_iTemplateCountVertex*sizeof(Vertex3D));
    Templatevertices[0]=Vector3DMake(-1.0,  1.0, -0.0);
    Templatevertices[1]=Vector3DMake( 1.0,  1.0, -0.0);
    Templatevertices[2]=Vector3DMake(-1.0, -1.0, -0.0);
    Templatevertices[3]=Vector3DMake( 1.0, -1.0, -0.0);
    Templatevertices[4]=Vector3DMake(-1.0, -1.0, -0.0);
    Templatevertices[5]=Vector3DMake( 1.0,  1.0, -0.0);
    
	TemplatetexCoords=(GLfloat *)malloc(m_iTemplateCountVertex*2*sizeof(GLfloat));
	
    TemplatetexCoords[0]= 0.0f;
    TemplatetexCoords[1]= 1.0f;
    TemplatetexCoords[2]= 1.0f;
    TemplatetexCoords[3]= 1.0f;
    TemplatetexCoords[4]= 0.0f;
    TemplatetexCoords[5]= 0.0f;
    
    TemplatetexCoords[6]= 1.0f;
    TemplatetexCoords[7]= 0.0f;
    TemplatetexCoords[8]= 0.0f;
    TemplatetexCoords[9]= 0.0f;
    TemplatetexCoords[10]= 1.0f;
    TemplatetexCoords[11]= 1.0f;
	
	TemplatesquareColors=(GLubyte *)malloc(m_iTemplateCountVertex*4*sizeof(GLubyte));
	
	for (int i=0; i<24; i++)
		TemplatesquareColors[i]=255;
//-------------------------------------------------------------------------

    mTextureId=-1;
	mColor = Color3DMake(1.0f,1.0f,1.0f,1.0f);

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    
    //   SET_CELL(LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY"));
    
    //    m_strNameObject=[NSMutableString stringWithString:@""];    
    //    SET_CELL(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"));
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

    m_iLayer = layerTemplet;

    GET_TEXTURE(mTextureId,m_pNameTexture);
    //   GET_DIM_FROM_TEXTURE(@"");

	[super Start];

//    m_pCurPosition.y=-400;
//    m_pCurPosition.x=-100;

    //   m_iLayerTouch=layerTouch_0;//слой касания
    //   [self SetTouch:YES];//интерактивность

    //[m_pObjMng AddToGroup:@"NameGroup" Object:self];//группировка
    //[self SelfOffsetVert:Vector3DMake(0,1,0)];//cдвиг
}
//------------------------------------------------------------------------------------------------------
- (void)SelfDrawOffset{
	
	[self SetColor:mColor];
    
	glVertexPointer(3, GL_FLOAT, 0, vertices);
    glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
   	
	glBindTexture(GL_TEXTURE_2D, mTextureId);
	
	glTranslatef(m_pCurPosition.x+m_pObjMng->m_pParent->m_vOffset.x*m_fScaleOffset,
				 m_pCurPosition.y+m_pObjMng->m_pParent->m_vOffset.y*m_fScaleOffset,
				 m_pCurPosition.z);
	
	//	glRotatef(m_pCurAngle.x, 1, 0, 0);
	//	glRotatef(m_pCurAngle.y, 0, 1, 0);
	glRotatef(m_pCurAngle.z, 0, 0, 1);
	glScalef(m_pCurScale.x,m_pCurScale.y,m_pCurScale.z);
	
	glDrawArrays(GL_TRIANGLES, 0, m_iCountVertex);
}
//------------------------------------------------------------------------------------------------------
-(void)AddParticle{
    
    Particle *pParticle=GET_ID_V(@"TmpIdParticle");
    
    int iCount=[m_pParticle count];
    
    NSString *Str_Tmp=[NSString stringWithFormat:@"%d",iCount];
    [m_pParticle setObject:Str_Tmp forKey:Str_Tmp];
    
    
//-------------------------------------------------------------------------
    int NumParticle=1;
    
	m_iCountVertex=6*NumParticle;
    
	vertices=(Vertex3D *)realloc(vertices,m_iCountVertex*sizeof(Vertex3D));
    
    float NumSquare=m_iCountVertex/6;
    
    for (int i=0; i<NumSquare; i++) {
        
        vertices[0+i*6]=Vector3DMake(-1.0+i*2,  1.0, -0.0);
        vertices[1+i*6]=Vector3DMake( 1.0+i*2,  1.0, -0.0);
        vertices[2+i*6]=Vector3DMake(-1.0+i*2, -1.0, -0.0);
        vertices[3+i*6]=Vector3DMake( 1.0+i*2, -1.0, -0.0);
        vertices[4+i*6]=Vector3DMake(-1.0+i*2, -1.0, -0.0);
        vertices[5+i*6]=Vector3DMake( 1.0+i*2,  1.0, -0.0); 
    }
    
	texCoords=(GLfloat *)realloc(texCoords,m_iCountVertex*2*sizeof(GLfloat));
	
    for (int i=0; i<NumSquare; i++) {
        
        texCoords[0+i*12]= 0.0f;
        texCoords[1+i*12]= 1.0f;
        texCoords[2+i*12]= 1.0f;
        texCoords[3+i*12]= 1.0f;
        texCoords[4+i*12]= 0.0f;
        texCoords[5+i*12]= 0.0f;
        
        texCoords[6+i*12]= 1.0f;
        texCoords[7+i*12]= 0.0f;
        texCoords[8+i*12]= 0.0f;
        texCoords[9+i*12]= 0.0f;
        texCoords[10+i*12]= 1.0f;
        texCoords[11+i*12]= 1.0f;
    }
	
	squareColors=(GLubyte *)realloc(squareColors,m_iCountVertex*4*sizeof(GLubyte));
	
	for (int i=0; i<m_iCountVertex*4; i++) 
		squareColors[i]=255;
//-------------------------------------------------------------------------	

}
//------------------------------------------------------------------------------------------------------
- (void)InitProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)PrepareProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{
    [m_pParticle release];
    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
@end