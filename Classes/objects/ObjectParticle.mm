//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectParticle.h"

@implementation ObjectParticle
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
START_QUEUE(@"Proc");
	ASSIGN_STAGE(@"Idle",@"Idle:",nil);
    //	ASSIGN_STAGE(@"Proc",@"Proc:",nil);
END_QUEUE(@"Proc");
    
    
    free(vertices);
	free(texCoords);
	free(squareColors);	

    
//-------------------------------------------------------------------------	
    int NumParticle=3;

	m_iCountVertex=4*NumParticle;
    
	vertices=(Vertex3D *)malloc(m_iCountVertex*sizeof(Vertex3D));
    
    float NumSquare=m_iCountVertex/4;

    for (int i=0; i<NumSquare; i++) {

        vertices[0+i*4]=Vector3DMake(-1.0+i*4,  1.0, -0.0);
        vertices[1+i*4]=Vector3DMake( 1.0+i*4,  1.0, -0.0);
        vertices[2+i*4]=Vector3DMake(-1.0+i*4, -1.0, -0.0);
        vertices[3+i*4]=Vector3DMake( 1.0+i*4, -1.0, -0.0);	
    }
    
	texCoords=(GLfloat *)malloc(m_iCountVertex*2*sizeof(GLfloat));
	
    
    for (int i=0; i<NumSquare; i++) {
    
        texCoords[0+i*8]= 0.0f;
        texCoords[1+i*8]= 1.0f;
        texCoords[2+i*8]= 1.0f;
        texCoords[3+i*8]= 1.0f;
        texCoords[4+i*8]= 0.0f;
        texCoords[5+i*8]= 0.0f;
        texCoords[6+i*8]= 1.0f;
        texCoords[7+i*8]= 0.0f;
    }
	
	squareColors=(GLubyte *)malloc(m_iCountVertex*4*sizeof(GLubyte));
	
	for (int i=0; i<m_iCountVertex*4; i++) 
		squareColors[i]=255;
    
	mTextureId=-1;
	
	mColor = Color3DMake(1.0f,1.0f,1.0f,1.0f);
//-------------------------------------------------------------------------	

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
    
    GET_TEXTURE(mTextureId,@"Bullet_Up.png");
    //   GET_DIM_FROM_TEXTURE(@"");
	mWidth  = 50;
	mHeight = 50;
    
	[super Start];
    
    m_pCurPosition.y=-400;
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
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
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
- (void)dealloc{[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end