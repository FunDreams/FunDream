//
//  Object.m
//  Engine
//
//  Created by Konstantin on 02.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "Object.h"
#import "Processor_ex.h"

//------------------------------------------------------------------------------------------------------
@implementation GObject
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	//	NSLog(@"Init");	

    m_iLayerTouch = layerTouch_0;
	m_pArrayImages = [[NSMutableArray alloc] init];

	iIdSound=-1;
	
	m_pParent=(MainController *)Parent;
	m_pObjMng=m_pParent.m_pObjMng;
	
	m_strName= [[NSMutableString alloc] initWithString:strName];
    m_Groups=[[Dictionary_Ex alloc] init];

	m_bNonStop=NO;
	m_bHiden=NO;
    
	m_bNoOffset=NO;
    m_fScaleOffset=1.0f;

	m_pOwner = nil;
	m_pChildrenbjectsDic = [[NSMutableDictionary alloc] init];
	m_pChildrenbjectsArr = [[NSMutableArray alloc] init];

    m_pProcessor_ex = [[Dictionary_Ex alloc] init];
	
	m_fDeltaTime = 0;
	
	m_pCurPosition=Vector3DMake(0,0,0);
	m_pCurScale=Vector3DMake(1,1,1);
	m_pCurAngle=Vector3DMake(0,0,0);
//-------------------------------------------------------------------------	
	m_iCountVertex=4;

	vertices=malloc(m_iCountVertex*sizeof(Vertex3D));
	vertices[0]=Vector3DMake(-1.0,  1.0, -0.0);
	vertices[1]=Vector3DMake( 1.0,  1.0, -0.0);
	vertices[2]=Vector3DMake(-1.0, -1.0, -0.0);
	vertices[3]=Vector3DMake( 1.0, -1.0, -0.0);	

	texCoords=malloc(m_iCountVertex*2*sizeof(GLfloat));
	
	texCoords[0]= 0.0f;
	texCoords[1]= 1.0f;
	texCoords[2]= 1.0f;
	texCoords[3]= 1.0f;
	texCoords[4]= 0.0f;
	texCoords[5]= 0.0f;
	texCoords[6]= 1.0f;
	texCoords[7]= 0.0f;	
	
	squareColors=malloc(m_iCountVertex*4*sizeof(GLubyte));
	
	for (int i=0; i<16; i++) 
		squareColors[i]=255;
		
	mTextureId=-1;
	
	mColor = Color3DMake(1.0f,1.0f,1.0f,1.0f);
//-------------------------------------------------------------------------		
	mWidth = 40;
	mHeight = 40;
    mRadius = 40;

	m_pCurScale.x=mWidth*0.5f;
	m_pCurScale.y=mHeight*0.5f;

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    
    m_pNameTexture=[NSMutableString stringWithString:@""];

    //link values
    SET_CELL(LINK_STRING_V(m_pNameTexture,m_strName,@"m_pNameTexture"));
    
    SET_CELL(LINK_VECTOR_V(m_pCurPosition,m_strName,@"m_pCurPosition"));
    SET_CELL(LINK_VECTOR_V(m_pCurScale,m_strName,@"m_pCurScale"));
    SET_CELL(LINK_VECTOR_V(m_pCurAngle,m_strName,@"m_pCurAngle"));
    
    SET_CELL(LINK_VECTOR_V(m_pOffsetCurPosition,m_strName,@"m_pOffsetCurPosition"));
    SET_CELL(LINK_VECTOR_V(m_pOffsetCurScale,m_strName,@"m_pOffsetCurScale"));
    SET_CELL(LINK_VECTOR_V(m_pOffsetCurAngle,m_strName,@"m_pOffsetCurAngle"));
    
    SET_CELL(LINK_COLOR_V(mColor,m_strName,@"mColor"));
    
    SET_CELL(LINK_INT_V(m_iLayer,m_strName,@"m_iLayer"));
    SET_CELL(LINK_INT_V(m_iLayerTouch,m_strName,@"m_iLayerTouch"));
    
    SET_CELL(LINK_BOOL_V(m_bNoOffset,m_strName,@"m_bNoOffset"));
    SET_CELL(LINK_BOOL_V(m_bHiden,m_strName,@"m_bHiden"));
    SET_CELL(LINK_BOOL_V(m_bNonStop,m_strName,@"m_bNonStop"));
    
    SET_CELL(LINK_FLOAT_V(mWidth,m_strName,@"mWidth"));
    SET_CELL(LINK_FLOAT_V(mHeight,m_strName,@"mHeight"));
    SET_CELL(LINK_FLOAT_V(mRadius,m_strName,@"mRadius"));
    
    SET_CELL(LINK_ID_V(m_pOwner,m_strName,@"m_pOwner"));

    SET_CELL(LINK_FLOAT_V(m_fScaleOffset,m_strName,@"m_fScaleOffset"));
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
	
	if(m_bNoOffset)
		m_sDraw = NSSelectorFromString ( @"SelfDraw" );
	else m_sDraw = NSSelectorFromString ( @"SelfDrawOffset" );    

    GET_TEXTURE(mTextureId,m_pNameTexture);

	m_pCurScale.x=mWidth*0.5f;
	m_pCurScale.y=mHeight*0.5f;    
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
//------------------------------------------------------------------------------------------------------
- (void)SetDrawSelector:(NSString *)pNameSel {m_sDraw = NSSelectorFromString(pNameSel);}
//------------------------------------------------------------------------------------------------------
- (void)SetColor:(Color3D)color {
	
	for (int i=0; i<m_iCountVertex; i++) {
		
		squareColors[i*4+0]=color.red*255;
		squareColors[i*4+1]=color.green*255;
		squareColors[i*4+2]=color.blue*255;
		squareColors[i*4+3]=color.alpha*255;
	}
}
//------------------------------------------------------------------------------------------------------
- (void)SetOffsetTexture:(Vector3D)vOffset {
    
    for (int i=0; i<m_iCountVertex; i++) {
		
        texCoords[i*2]-=vOffset.x;
		texCoords[i*2+1]-=vOffset.y;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetScaleTexture:(Vector3D)vStartScale SecondVector:(Vector3D)vEndScale {

    texCoords[0]=vStartScale.x;
    texCoords[1]=vEndScale.y;
    
    texCoords[2]=vEndScale.x;
    texCoords[3]=vEndScale.y;
    
    texCoords[4]=vStartScale.x;
    texCoords[5]=vStartScale.y;
    
    texCoords[6]=vEndScale.x;
    texCoords[7]=vStartScale.y;
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
- (void)SelfDraw{
	
	[self SetColor:mColor];
	
	glVertexPointer(3, GL_FLOAT, 0, vertices);
    glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
   	
	glBindTexture(GL_TEXTURE_2D, mTextureId);
	
	glTranslatef(m_pCurPosition.x,m_pCurPosition.y,m_pCurPosition.z);
	
//	glRotatef(m_pCurAngle.x, 1, 0, 0);
//	glRotatef(m_pCurAngle.y, 0, 1, 0);
	glRotatef(m_pCurAngle.z, 0, 0, 1);
	glScalef(m_pCurScale.x,m_pCurScale.y,m_pCurScale.z);

	glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
	
//	glCopyTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 0, 0, 16, 16, 0);
}
//------------------------------------------------------------------------------------------------------
- (void)SetTouch:(bool)bTouch{

    if(m_strName!=nil){

        m_bTouch=bTouch;
        [m_pObjMng->m_pObjectAddToTouch setObject:self forKey:m_strName];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)RomoveFromTouch{
    
	[[m_pParent.m_pObjMng->m_pObjectTouches objectAtIndex:m_iLayerTouch] removeObjectForKey:m_strName];
}
//------------------------------------------------------------------------------------------------------
- (Processor_ex *)FindProcByName:(NSString *)Name{
	
	return [m_pProcessor_ex objectForKey:Name];
}
//------------------------------------------------------------------------------------------------------
- (void)AddToDraw{
	
	NSMutableDictionary *pCurrentLayer=[m_pObjMng->pLayers objectAtIndex:m_iLayer];
	
	if (pCurrentLayer && m_strName)
		[pCurrentLayer setObject:self forKey:m_strName];
}
//------------------------------------------------------------------------------------------------------
- (void)DeleteFromDraw{
	
	NSMutableDictionary *pCurrentLayer=[m_pObjMng->pLayers objectAtIndex:m_iLayer];
	
	if (pCurrentLayer && m_strName!=nil)
		[pCurrentLayer removeObjectForKey:m_strName];
	
}
//------------------------------------------------------------------------------------------------------
- (void)SetLayer:(int)iLayer{
	
	if (m_strName){
		[self DeleteFromDraw];
		m_iLayer=iLayer;
		[self AddToDraw];
	}
}
//------------------------------------------------------------------------------------------------------
- (void)SetLayerAndChild:(int)iLayer{
	
	if (m_strName){
		[self DeleteFromDraw];
		m_iLayer=iLayer;
		[self AddToDraw];
	}
    
    for (GObject *pOb in m_pChildrenbjectsArr) {
        [pOb SetLayer:iLayer];
    }
}
//------------------------------------------------------------------------------------------------------
- (bool)IntersectSphereWithOb:(GObject *)pOb{
    
    Vector3D V=Vector3DMake(m_pCurPosition.x-pOb->m_pCurPosition.x,
                            m_pCurPosition.y-pOb->m_pCurPosition.y,0);
    float Dist=Vector3DMagnitude(V);

    if(Dist<(pOb->mRadius+mRadius)*0.5f){
        return YES;
    }
    
    return NO;
}
//------------------------------------------------------------------------------------------------------
- (bool)Intersect:(CGPoint)pPoint{

	CGPoint tmpPointDif=pPoint;
	
	if(m_bNoOffset){
		tmpPointDif.x-=m_pObjMng->m_pParent->m_vOffset.x;
		tmpPointDif.y-=m_pObjMng->m_pParent->m_vOffset.y;
	}
	
	Vector3D VstartPoint = Vector3DMake(tmpPointDif.x-m_pCurPosition.x,tmpPointDif.y-m_pCurPosition.y,0);
	Vector3D TmpRotate=Vector3DRotateZ2D(VstartPoint,-m_pCurAngle.z);
	
	if((TmpRotate.x>=((m_pOffsetVert.x-1)*mWidth*0.5f)) && (TmpRotate.x<=((1+m_pOffsetVert.x)*mWidth*0.5f)) && (TmpRotate.y>=((m_pOffsetVert.y-1)*mHeight*0.5f)) && (TmpRotate.y<=((1+m_pOffsetVert.y)*mHeight*0.5f)))
	{
		m_pCurrentTouch.x=TmpRotate.x;
		m_pCurrentTouch.y=TmpRotate.y;

		return YES;
	}
	
	return NO;
}
//------------------------------------------------------------------------------------------------------
- (void)SelfOffsetVert:(Vertex3D)VOffset{
	m_pOffsetVert=VOffset;
	
	for (int i=0; i<m_iCountVertex; i++) {
		vertices[i].x+=VOffset.x;
		vertices[i].y+=VOffset.y;
	}
}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)touchesBeganOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)touchesEndedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {
		
	NSEnumerator *enumerator = [m_pProcessor_ex objectEnumerator];
	Processor_ex *pProc;
	
	while ((pProc = [enumerator nextObject])) {
		[pProc release];
	}
	[m_pProcessor_ex release];
    
	[m_pChildrenbjectsDic release];
	[m_pChildrenbjectsArr release];
	[m_pArrayImages release];
    [m_Groups release];

	
	free(vertices);
	free(texCoords);
	free(squareColors);	
	
	[super dealloc];
}

//Utils-------------------------------------------------------------------------------------------------
#define LEFT  1  /* двоичное 0001 */
#define RIGHT 2  /* двоичное 0010 */
#define BOT   4  /* двоичное 0100 */
#define TOP   8  /* двоичное 1000 */

/* вычисление кода точки
 r : указатель на struct rect; p : указатель на struct point */
#define vcode(r, p) \
((((p)->x < (r)->x_min) ? LEFT : 0)  +  /* +1 если точка левее прямоугольника */ \
(((p)->x > (r)->x_max) ? RIGHT : 0) +  /* +2 если точка правее прямоугольника */\
(((p)->y < (r)->y_min) ? BOT : 0)   +  /* +4 если точка ниже прямоугольника */  \
(((p)->y > (r)->y_max) ? TOP : 0))     /* +8 если точка выше прямоугольника */

/* если отрезок ab не пересекает прямоугольник r, функция возвращает -1;
 если отрезок ab пересекает прямоугольник r, функция возвращает 0 и отсекает
 те части отрезка, которые находятся вне прямоугольника */
-(int)cohen_sutherland:(rect2d *)r PointA:(point2d *)a PointB:(point2d*)b{
	
	int code_a, code_b, code; /* код конечных точек отрезка */
	point2d *c; /* одна из точек */
	
	code_a = vcode(r, a);
	code_b = vcode(r, b);
	
	/* пока одна из точек отрезка вне прямоугольника */
	while (code_a || code_b) {
		/* если обе точки с одной стороны прямоугольника, то отрезок не пересекает прямоугольник */
		if (code_a & code_b)
			return -1;
		
		/* выбираем точку c с ненулевым кодом */
		if (code_a) {
			code = code_a;
			c = a;
		} else {
			code = code_b;
			c = b;
		}
		
		/* если c левее r, то передвигаем c на прямую x = r->x_min
		 если c правее r, то передвигаем c на прямую x = r->x_max */
		if (code & LEFT) {
			c->y += (a->y - b->y) * (r->x_min - c->x) / (a->x - b->x);
			c->x = r->x_min;
		} else if (code & RIGHT) {
			c->y += (a->y - b->y) * (r->x_max - c->x) / (a->x - b->x);
			c->x = r->x_max;
		}
		/* если c ниже r, то передвигаем c на прямую y = r->y_min
		 если c выше r, то передвигаем c на прямую y = r->y_max */
		if (code & BOT) {
			c->x += (a->x - b->x) * (r->y_min - c->y) / (a->y - b->y);
			c->y = r->y_min;
		} else if (code & TOP) {
			c->x += (a->x - b->x) * (r->y_max - c->y) / (a->y - b->y);
			c->y = r->y_max;
		}
		
		/* обновляем код */
		if (code == code_a)
			code_a = vcode(r,a);
		else
			code_b = vcode(r,b);
	}
	
	/* оба кода равны 0, следовательно обе точки в прямоугольнике */
	return 0;
}
//------------------------------------------------------------------------------------------------------
- (void)ParseTime:(float)fTime OutSec:(int *)fSec OutMin:(int *)fMin OutHour:(int *)fHour{
	
	*fHour=(int)(fTime/3600);
	fTime-=*fHour*3600;
	*fMin=(int)(fTime/60);
	*fSec=(int)(fTime-(*fMin)*60);
}
//------------------------------------------------------------------------------------------------------
- (NSMutableArray *)ParseIntValue:(int)iValue{

	NSMutableArray *pArray = [[NSMutableArray alloc] init];

	int TmpValue=iValue;
	int Number;

	while ((TmpValue)>0){
		
		Number=TmpValue%10;
		TmpValue-=Number;
		TmpValue/=10;
		
		[pArray addObject:[[[NSNumber alloc] initWithInt:Number] autorelease]];
	}

	return pArray;
}
//processors--------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
- (void)Idle:(Processor_ex *)pProc{}
//------------------------------------------------------------------------------------------------------
- (void)timerWaitNextStage:(Processor_ex *)pProc{NEXT_STAGE;}
//------------------------------------------------------------------------------------------------------
- (void)TouchYes:(Processor_ex *)pProc{[self SetTouch:YES];NEXT_STAGE;}
//------------------------------------------------------------------------------------------------------
- (void)TouchNo:(Processor_ex *)pProc{[self SetTouch:NO];NEXT_STAGE;}
//------------------------------------------------------------------------------------------------------
- (void)InitAnimate:(ProcStage_ex *)pStage{
    
    NSString *TmpStr=[NSString stringWithFormat:@"%@%@%@",
                      m_strName,pStage->pParent->m_pNameProcessor,pStage->NameStage];
    
    NSString *NameParam=nil;
    
    //линкуем параметры
    NameParam=[NSString stringWithFormat:@"%@Finish_Frame",TmpStr];
    pStage->IntsValues[0]=GET_INT_V(NameParam);
    if(pStage->IntsValues[0]==0)NSLog(@"Error:Can't link Value:%@",NameParam);
    
    NameParam=[NSString stringWithFormat:@"%@InstFrame",TmpStr];
    pStage->IntsValues[1]=GET_INT_V(NameParam);
    if(pStage->IntsValues[1]==0)NSLog(@"Error:Can't link Value:%@",NameParam);

    
    NameParam=[NSString stringWithFormat:@"%@InstFrameFloat",TmpStr];
    pStage->FloatsValues[0]=GET_FLOAT_V(NameParam);
    if(pStage->FloatsValues[0]==0)NSLog(@"Error:Can't link Value:%@",NameParam);

    NameParam=[NSString stringWithFormat:@"%@Vel",TmpStr];
    pStage->FloatsValues[1]=GET_FLOAT_V(NameParam);
    if(pStage->FloatsValues[1]==0)NSLog(@"Error:Can't link Value:%@",NameParam);
}
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
- (void)Animate:(Processor_ex *)pProc{
    
    ProcStage_ex * pStage=pProc->m_CurStage;

    (*pStage->FloatsValues[0])+=(*pStage->FloatsValues[1])*DELTA;
    int TmpFrame=(int)(*pStage->FloatsValues[0]);

	if((*pStage->FloatsValues[1])>0 && (*pStage->IntsValues[0]<=TmpFrame))
    {
        *pStage->IntsValues[1]=(int)(*pStage->IntsValues[0]);
        NEXT_STAGE;
    }	
	else if((*pStage->FloatsValues[1])<0 && (*pStage->IntsValues[0]>=TmpFrame))
    {
        *pStage->IntsValues[1]=(int)(*pStage->IntsValues[0]);
        NEXT_STAGE;
    }	
    else (*pStage->IntsValues[1])=TmpFrame;  
}
//------------------------------------------------------------------------------------------------------
- (void)InitAnimateLoop:(ProcStage_ex *)pStage{
    
    NSString *TmpStr=[NSString stringWithFormat:@"%@%@%@",
                      m_strName,pStage->pParent->m_pNameProcessor,pStage->NameStage];
    
    NSString *NameParam=nil;
    
    //линкуем параметры
    NameParam=[NSString stringWithFormat:@"%@Start_Frame",TmpStr];
    pStage->IntsValues[0]=GET_INT_V(NameParam);
    if(pStage->IntsValues[0]==0)NSLog(@"Error:Can't link Value:%@",NameParam);

    NameParam=[NSString stringWithFormat:@"%@Finish_Frame",TmpStr];
    pStage->IntsValues[1]=GET_INT_V(NameParam);
    if(pStage->IntsValues[1]==0)NSLog(@"Error:Can't link Value:%@",NameParam);
    
    NameParam=[NSString stringWithFormat:@"%@InstFrame",TmpStr];
    pStage->IntsValues[2]=GET_INT_V(NameParam);
    if(pStage->IntsValues[2]==0)NSLog(@"Error:Can't link Value:%@",NameParam);
    
    
    NameParam=[NSString stringWithFormat:@"%@InstFrameFloat",TmpStr];
    pStage->FloatsValues[0]=GET_FLOAT_V(NameParam);
    if(pStage->FloatsValues[0]==0)NSLog(@"Error:Can't link Value:%@",NameParam);
    
    NameParam=[NSString stringWithFormat:@"%@Vel",TmpStr];
    pStage->FloatsValues[1]=GET_FLOAT_V(NameParam);
    if(pStage->FloatsValues[1]==0)NSLog(@"Error:Can't link Value:%@",NameParam);
}
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
- (void)AnimateLoop:(Processor_ex *)pProc{
    
    ProcStage_ex * pStage=pProc->m_CurStage;
    
    (*pStage->FloatsValues[0])+=(*pStage->FloatsValues[1])*DELTA;
    int TmpFrame=(int)(*pStage->FloatsValues[0]);
    
    if((*pStage->FloatsValues[1])<0)TmpFrame++;
    
    if(*pStage->IntsValues[0]<*pStage->IntsValues[1]){
        
        if((*pStage->FloatsValues[1])>0 && (TmpFrame>*pStage->IntsValues[1]))
        {
            TmpFrame=(int)(*pStage->IntsValues[0]);
            (*pStage->IntsValues[2])=TmpFrame;
            (*pStage->FloatsValues[0])=TmpFrame;
            return;
        }	
        else if((*pStage->FloatsValues[1])<0 && (TmpFrame<*pStage->IntsValues[0]))
        {
            TmpFrame=(int)(*pStage->IntsValues[1]);
            (*pStage->IntsValues[2])=TmpFrame;
            (*pStage->FloatsValues[0])=TmpFrame;
            return;
        }
    }
    else{
        
        if((*pStage->FloatsValues[1])>0 && (TmpFrame>*pStage->IntsValues[0]))
        {
            TmpFrame=(int)(*pStage->IntsValues[1]);
            (*pStage->IntsValues[2])=TmpFrame;
            (*pStage->FloatsValues[0])=TmpFrame;
            return;
        }	
        else if((*pStage->FloatsValues[1])<0 && (TmpFrame<*pStage->IntsValues[1]))
        {
            TmpFrame=(int)(*pStage->IntsValues[0]);
            (*pStage->IntsValues[2])=TmpFrame;
            (*pStage->FloatsValues[0])=TmpFrame;
            return;
        }
    }
    
    (*pStage->IntsValues[2])=TmpFrame;
}
//------------------------------------------------------------------------------------------------------
- (void)InitAchiveLineFloat:(ProcStage_ex *)pStage{
    
    NSString *TmpStr=[NSString stringWithFormat:@"%@%@%@",
                      m_strName,pStage->pParent->m_pNameProcessor,pStage->NameStage];

    NSString *NameParam=nil;

    //линкуем параметры
    NameParam=[NSString stringWithFormat:@"%@Instance",TmpStr];
    pStage->FloatsValues[0]=GET_FLOAT_V(NameParam);
    if(pStage->FloatsValues[0]==0)NSLog(@"Error:Can't link Value:%@",NameParam);
    
    NameParam=[NSString stringWithFormat:@"%@finish_Instance",TmpStr];
    pStage->FloatsValues[1]=GET_FLOAT_V(NameParam);
    if(pStage->FloatsValues[1]==0)NSLog(@"Error:Can't link Value:%@",NameParam);
    
    NameParam=[NSString stringWithFormat:@"%@Vel",TmpStr];
    pStage->FloatsValues[2]=GET_FLOAT_V(NameParam);
    if(pStage->FloatsValues[2]==0)NSLog(@"Error:Can't link Value:%@",NameParam);
}
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
- (void)AchiveLineFloat:(Processor_ex *)pProc{

    ProcStage_ex * pStage=pProc->m_CurStage;
    
	*pStage->FloatsValues[0]+=DELTA*(*pStage->FloatsValues[2]);
	
	if((*pStage->FloatsValues[2])>0 && (*pStage->FloatsValues[0] > *pStage->FloatsValues[1])){
        
		(*pStage->FloatsValues[0]) = (*pStage->FloatsValues[1]);
        NEXT_STAGE;
	}
	else if((*pStage->FloatsValues[2])<0 && (*pStage->FloatsValues[0] < *pStage->FloatsValues[1])){
        
		(*pStage->FloatsValues[0]) = (*pStage->FloatsValues[1]);
        NEXT_STAGE;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)InitOffsetTexLoop:(ProcStage_ex *)pStage{
    
    NSString *TmpStr=[NSString stringWithFormat:@"%@%@%@",
                      m_strName,pStage->pParent->m_pNameProcessor,pStage->NameStage];
    
    NSString *NameParam=nil;
    
    //линкуем параметры
    NameParam=[NSString stringWithFormat:@"%@vCurrentOffset",TmpStr];
    pStage->VectorsValues[0]=GET_VECTOR_V(NameParam);
    if(pStage->VectorsValues[0]==0)NSLog(@"Error:Can't link Value:%@",NameParam);
    
    NameParam=[NSString stringWithFormat:@"%@vDirect",TmpStr];
    pStage->VectorsValues[1]=GET_VECTOR_V(NameParam);
    if(pStage->VectorsValues[1]==0)NSLog(@"Error:Can't link Value:%@",NameParam);
    
    NameParam=[NSString stringWithFormat:@"%@vStartOffsetTex",TmpStr];
    pStage->VectorsValues[2]=GET_VECTOR_V(NameParam);
    if(pStage->VectorsValues[2]==0)NSLog(@"Error:Can't link Value:%@",NameParam);
    
    NameParam=[NSString stringWithFormat:@"%@vEndOffsetTex",TmpStr];
    pStage->VectorsValues[3]=GET_VECTOR_V(NameParam);
    if(pStage->VectorsValues[3]==0)NSLog(@"Error:Can't link Value:%@",NameParam);
    
    
    NameParam=[NSString stringWithFormat:@"%@fVelOffset",TmpStr];
    pStage->FloatsValues[0]=GET_FLOAT_V(NameParam);
    if(pStage->FloatsValues[0]==0)NSLog(@"Error:Can't link Value:%@",NameParam);
    
    NameParam=[NSString stringWithFormat:@"%@fMagnitude",TmpStr];
    pStage->FloatsValues[1]=GET_FLOAT_V(NameParam);
    if(pStage->FloatsValues[1]==0)NSLog(@"Error:Can't link Value:%@",NameParam);
}
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
- (void)OffsetTexLoop:(Processor_ex *)pProc{
    
    ProcStage_ex * pStage=pProc->m_CurStage;
    
    Vector3D m_vDeltaOffset;
    
    m_vDeltaOffset.x = (*pStage->VectorsValues[1]).x*(*pStage->FloatsValues[0])*DELTA;
    m_vDeltaOffset.y = (*pStage->VectorsValues[1]).y*(*pStage->FloatsValues[0])*DELTA;
    
    (*pStage->VectorsValues[0]).x += m_vDeltaOffset.x;
    (*pStage->VectorsValues[0]).y += m_vDeltaOffset.y;
    
	Vector3D Dir2=Vector3DMake((*pStage->VectorsValues[0]).x-(*pStage->VectorsValues[2]).x,
                               (*pStage->VectorsValues[0]).y-(*pStage->VectorsValues[2]).y,0);
    
	float Magnitude2 = sqrtf(Dir2.x*Dir2.x+Dir2.y*Dir2.y);
	
	if(Magnitude2>=(*pStage->FloatsValues[1]))
	{        
        Vector3D DirBack=Vector3DMake((*pStage->VectorsValues[2]).x-(*pStage->VectorsValues[3]).x,
                                      (*pStage->VectorsValues[2]).y-(*pStage->VectorsValues[3]).y,0);
        
        (*pStage->VectorsValues[0]).x += DirBack.x;
        (*pStage->VectorsValues[0]).y += DirBack.y;
        
        [self SetOffsetTexture:DirBack];
        [self SetOffsetTexture:m_vDeltaOffset];
	}    
    else [self SetOffsetTexture:m_vDeltaOffset];
}
//------------------------------------------------------------------------------------------------------
- (void)InitMirror2Dvector:(ProcStage_ex *)pStage{
    
    NSString *TmpStr=[NSString stringWithFormat:@"%@%@%@",
                      m_strName,pStage->pParent->m_pNameProcessor,pStage->NameStage];
    
    NSString *NameParam=nil;
    
    //линкуем параметры
    NameParam=[NSString stringWithFormat:@"%@pFinishV",TmpStr];
    pStage->VectorsValues[0]=GET_VECTOR_V(NameParam);
    if(pStage->VectorsValues[0]==0)NSLog(@"Error:Can't link Value:%@",NameParam);
    
    NameParam=[NSString stringWithFormat:@"%@pStartV",TmpStr];
    pStage->VectorsValues[1]=GET_VECTOR_V(NameParam);
    if(pStage->VectorsValues[1]==0)NSLog(@"Error:Can't link Value:%@",NameParam);
    
    NameParam=[NSString stringWithFormat:@"%@pDestV",TmpStr];
    pStage->VectorsValues[2]=GET_VECTOR_V(NameParam);
    if(pStage->VectorsValues[2]==0)NSLog(@"Error:Can't link Value:%@",NameParam);

    NameParam=[NSString stringWithFormat:@"%@pfStartF",TmpStr];
    pStage->FloatsValues[0]=GET_FLOAT_V(NameParam);
    if(pStage->FloatsValues[0]==0)NSLog(@"Error:Can't link Value:%@",NameParam);
    
    NameParam=[NSString stringWithFormat:@"%@pfFinishF",TmpStr];
    pStage->FloatsValues[1]=GET_FLOAT_V(NameParam);
    if(pStage->FloatsValues[1]==0)NSLog(@"Error:Can't link Value:%@",NameParam);
    
    NameParam=[NSString stringWithFormat:@"%@pfSrc",TmpStr];
    pStage->FloatsValues[2]=GET_FLOAT_V(NameParam);
    if(pStage->FloatsValues[2]==0)NSLog(@"Error:Can't link Value:%@",NameParam);    
}
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
- (void)Mirror2Dvector:(Processor_ex *)pProc{

    ProcStage_ex * pStage=pProc->m_CurStage;

    Vector3D Dir=Vector3DMake(pStage->VectorsValues[0]->x-pStage->VectorsValues[1]->x,
                              pStage->VectorsValues[0]->y-pStage->VectorsValues[1]->y,0);
    
    float Magnitude = sqrtf(Dir.x*Dir.x+Dir.y*Dir.y);
    
    if(Magnitude>0)
    {
        Dir.x/=Magnitude;
        Dir.y/=Magnitude;
        
        float K=((*pStage->FloatsValues[2]-*pStage->FloatsValues[0])*
                 (Magnitude/(*pStage->FloatsValues[1]-*pStage->FloatsValues[0])));
        
        pStage->VectorsValues[2]->x=Dir.x*K+pStage->VectorsValues[1]->x;
        pStage->VectorsValues[2]->y=Dir.y*K+pStage->VectorsValues[1]->y;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)InitParabola1:(ProcStage_ex *)pStage{
    
    NSString *TmpStr=[NSString stringWithFormat:@"%@%@%@",
                      m_strName,pStage->pParent->m_pNameProcessor,pStage->NameStage];
    
    NSString *NameParam=nil;
    
    //линкуем параметры
    NameParam=[NSString stringWithFormat:@"%@SrcF",TmpStr];
    pStage->FloatsValues[0]=GET_FLOAT_V(NameParam);
    if(pStage->FloatsValues[0]==0)NSLog(@"Error:Can't link Value:%@",NameParam);
    
    NameParam=[NSString stringWithFormat:@"%@DestF",TmpStr];
    pStage->FloatsValues[1]=GET_FLOAT_V(NameParam);
    if(pStage->FloatsValues[1]==0)NSLog(@"Error:Can't link Value:%@",NameParam);

    NameParam=[NSString stringWithFormat:@"%@PowI",TmpStr];
    pStage->IntsValues[0]=GET_INT_V(NameParam);
    if(pStage->IntsValues[0]==0)NSLog(@"Error:Can't link Value:%@",NameParam);
}
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
- (void)Parabola1:(Processor_ex *)pProc{
    	
    ProcStage_ex * pStage=pProc->m_CurStage;
    *pStage->FloatsValues[1]=1-pow(1-*pStage->FloatsValues[0],*pStage->IntsValues[0]);
}
//------------------------------------------------------------------------------------------------------
- (void)InitAchive1Dvector:(ProcStage_ex *)pStage{
    
    NSString *TmpStr=[NSString stringWithFormat:@"%@%@%@",
                      m_strName,pStage->pParent->m_pNameProcessor,pStage->NameStage];
    
    NSString *NameParam=nil;
    
    //линкуем параметры
    NameParam=[NSString stringWithFormat:@"%@Vel",TmpStr];
    pStage->FloatsValues[0]=GET_FLOAT_V(NameParam);
    if(pStage->FloatsValues[0]==0)NSLog(@"Error:Can't link Value:%@",NameParam);
    
    NameParam=[NSString stringWithFormat:@"%@Start",TmpStr];
    pStage->FloatsValues[1]=GET_FLOAT_V(NameParam);
    if(pStage->FloatsValues[1]==0)NSLog(@"Error:Can't link Value:%@",NameParam);
    
    NameParam=[NSString stringWithFormat:@"%@Finish",TmpStr];
    pStage->FloatsValues[2]=GET_FLOAT_V(NameParam);
    if(pStage->FloatsValues[2]==0)NSLog(@"Error:Can't link Value:%@",NameParam);

    NameParam=[NSString stringWithFormat:@"%@Instance",TmpStr];
    pStage->FloatsValues[3]=GET_FLOAT_V(NameParam);
    if(pStage->FloatsValues[3]==0)NSLog(@"Error:Can't link Value:%@",NameParam);
}
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
- (void)Achive1Dvector:(Processor_ex *)pProc{
	    
    ProcStage_ex * pStage=pProc->m_CurStage;

	float Dir=*pStage->FloatsValues[2]-*pStage->FloatsValues[1];
	float Magnitude = fabsf(Dir);
	
	if(Magnitude>0){Dir/=Magnitude;}
	
	(*pStage->FloatsValues[3])+=Dir*(fabsf(*pStage->FloatsValues[0]))*DELTA;
	
	float Dir2=*pStage->FloatsValues[3]-*pStage->FloatsValues[1];
    float Magnitude2 = fabsf(Dir2);

	if(Magnitude2>=Magnitude)
	{
		*pStage->FloatsValues[3] = *pStage->FloatsValues[2];
		NEXT_STAGE;
	}
}
//------------------------------------------------------------------------------------------------------
- (void)Achive4DColorStatic:(Processor_ex *)pProc{
	
//	float pfCurVel=(float )[RESIVE(@"Vel") floatValue];
//	
//	Color3D *pStart=RESIVE_COLOR(@"Start");
//	Color3D *pFinish=RESIVE_COLOR(@"Finish");
//	
//	Color3D *pfCurInst=(Color3D *)RESIVE(@"Instance");
//	
//	Color3D Dir=Color3DMake(pFinish->red-pStart->red,pFinish->green-pStart->green,
//							pFinish->blue-pStart->blue,pFinish->alpha-pStart->alpha);
//	
//	float Magnitude = sqrtf(Dir.red*Dir.red+Dir.green*Dir.green+Dir.blue*Dir.blue+Dir.alpha*Dir.alpha);
//	
//	if(Magnitude>0){Dir.red/=Magnitude;Dir.green/=Magnitude;Dir.blue/=Magnitude;Dir.alpha/=Magnitude;}
//	
//	pfCurInst->red+=Dir.red*(pfCurVel)*DELTA;
//	pfCurInst->green+=Dir.green*(pfCurVel)*DELTA;
//	pfCurInst->blue+=Dir.blue*(pfCurVel)*DELTA;
//	pfCurInst->alpha+=Dir.alpha*(pfCurVel)*DELTA;
//	
//	Color3D Dir2=Color3DMake(pfCurInst->red-pStart->red,pfCurInst->green-pStart->green,
//							 pfCurInst->blue-pStart->blue,pfCurInst->alpha-pStart->alpha);
//	
//	float Magnitude2 = sqrtf(Dir2.red*Dir2.red+Dir2.green*Dir2.green+Dir2.blue*Dir2.blue+Dir2.alpha*Dir2.alpha);
//	
//	if(Magnitude2>=Magnitude)
//	{
//		pfCurInst->red = pFinish->red;
//		pfCurInst->green = pFinish->green;
//		pfCurInst->blue = pFinish->blue;
//		pfCurInst->alpha = pFinish->alpha;
//		NEXT_STAGE;
//	}
}
//------------------------------------------------------------------------------------------------------
- (void)Achive2DvectorStatic:(Processor_ex *)pProc{
	
//	float pfCurVector=(float )[RESIVE(@"Vel") floatValue];
//	
//	Vector3D *pStart=RESIVE_VECOTOR(@"Start");
//	Vector3D *pFinish=RESIVE_VECOTOR(@"Finish");
//	
//	Vector3D *pfCurInst=(Vector3D *)RESIVE(@"Instance");
//	
//	Vector3D Dir=Vector3DMake(pFinish->x-pStart->x,pFinish->y-pStart->y,0);
//	float Magnitude = sqrtf(Dir.x*Dir.x+Dir.y*Dir.y);
//	
//	if(Magnitude>0){Dir.x/=Magnitude;Dir.y/=Magnitude;}
//	
//	pfCurInst->x+=Dir.x*(pfCurVector)*DELTA;
//	pfCurInst->y+=Dir.y*(pfCurVector)*DELTA;
//	
//	Vector3D Dir2=Vector3DMake(pfCurInst->x-pStart->x,pfCurInst->y-pStart->y,0);
//	float Magnitude2 = sqrtf(Dir2.x*Dir2.x+Dir2.y*Dir2.y);
//	
//	if(Magnitude2>=Magnitude)
//	{
//		pfCurInst->x = pFinish->x;
//		pfCurInst->y = pFinish->y;
//		NEXT_STAGE;
//	}
}
//------------------------------------------------------------------------------------------------------
- (void)Mirror4DColorStatic:(Processor_ex *)pProc{
	
//	float *pfSrc=(float *)RESIVE(@"SrcF");
//	Color3D *pfDest=(Color3D *)RESIVE(@"DestC");
//	
//	float pfStartF=(float )[RESIVE(@"StartF") floatValue];
//	float pfFinishF=(float )[RESIVE(@"FinishF") floatValue];
//	
//	Color3D *pStartV=RESIVE_COLOR(@"StartC");
//	Color3D *pFinishV=RESIVE_COLOR(@"FinishC");
//	
//	Color3D Dir=Color3DMake(pFinishV->red-pStartV->red,pFinishV->green-pStartV->green,
//							pFinishV->blue-pStartV->blue,pFinishV->alpha-pStartV->alpha);
//	
//	float Magnitude = sqrtf(Dir.red*Dir.red+Dir.green*Dir.green+
//							Dir.blue*Dir.blue+Dir.alpha*Dir.alpha);
//	
//	if(Magnitude>0)
//	{
//		Dir.red/=Magnitude;
//		Dir.green/=Magnitude;
//		Dir.blue/=Magnitude;
//		Dir.alpha/=Magnitude;
//		
//		float K=((*pfSrc-pfStartF)*(Magnitude/(pfFinishF-pfStartF)));
//		
//		pfDest->red=Dir.red*K+pStartV->red;
//		pfDest->green=Dir.green*K+pStartV->green;
//		pfDest->blue=Dir.blue*K+pStartV->blue;
//		pfDest->alpha=Dir.alpha*K+pStartV->alpha;
//	}
}
//------------------------------------------------------------------------------------------------------
- (void)Mirror2DvectorDynVector:(Processor_ex *)pProc{
	
//	float *pfSrc=(float *)RESIVE(@"SrcF");
//	Vector3D *pfDest=(Vector3D *)RESIVE(@"DestV");
//	
//	float pfStartF=(float )[RESIVE(@"StartF") floatValue];
//	float pfFinishF=(float )[RESIVE(@"FinishF") floatValue];
//	
//	Vector3D *pStartV=(Vector3D *)RESIVE(@"StartV");
//	Vector3D *pFinishV=(Vector3D *)RESIVE(@"FinishV");
//	
//	Vector3D Dir=Vector3DMake(pFinishV->x-pStartV->x,pFinishV->y-pStartV->y,0);
//	float Magnitude = sqrtf(Dir.x*Dir.x+Dir.y*Dir.y);
//	
//	if(Magnitude>0)
//	{
//		Dir.x/=Magnitude;
//		Dir.y/=Magnitude;
//		
//		float K=((*pfSrc-pfStartF)*(Magnitude/(pfFinishF-pfStartF)));
//		
//		pfDest->x=Dir.x*K+pStartV->x;
//		pfDest->y=Dir.y*K+pStartV->y;
//	}
}
//------------------------------------------------------------------------------------------------------
- (void)Mirror2DvectorStatic:(Processor_ex *)pProc{
	
//	float *pfSrc=(float *)RESIVE(@"SrcF");
//	Vector3D *pfDest=(Vector3D *)RESIVE(@"DestV");
//	
//	float pfStartF=(float )[RESIVE(@"StartF") floatValue];
//	float pfFinishF=(float )[RESIVE(@"FinishF") floatValue];
//	
//	Vector3D *pStartV=RESIVE_VECOTOR(@"StartV");
//	Vector3D *pFinishV=RESIVE_VECOTOR(@"FinishV");
//	
//	Vector3D Dir=Vector3DMake(pFinishV->x-pStartV->x,pFinishV->y-pStartV->y,0);
//	float Magnitude = sqrtf(Dir.x*Dir.x+Dir.y*Dir.y);
//	
//	if(Magnitude>0)
//	{
//		Dir.x/=Magnitude;
//		Dir.y/=Magnitude;
//		
//		float K=((*pfSrc-pfStartF)*(Magnitude/(pfFinishF-pfStartF)));
//		
//		pfDest->x=Dir.x*K+pStartV->x;
//		pfDest->y=Dir.y*K+pStartV->y;
//	}
}
//------------------------------------------------------------------------------------------------------
- (void)Mirror1DFloatStatic:(Processor_ex *)pProc{
	
//	float *pfSrc=(float *)RESIVE(@"SrcF");
//	float *pfDest=(float *)RESIVE(@"DestF");
//	
//	float pfStartF1=[RESIVE(@"StartF1") floatValue];
//	float pfFinishF1=[RESIVE(@"FinishF1") floatValue];
//	
//	float pfStartF2=[RESIVE(@"StartF2") floatValue];
//	float pfinishF2=[RESIVE(@"FinishF2") floatValue];
//	
//	*pfDest=((*pfSrc-pfStartF1)*((pfinishF2-pfStartF2)/(pfFinishF1-pfStartF1)))+pfStartF2;
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateScreen:(Processor_ex *)pProc{UPDATE;NEXT_STAGE;}
//------------------------------------------------------------------------------------------------------
- (void)DestroySelf:(Processor_ex *)pProc{DESTROY_OBJECT(self);}
//------------------------------------------------------------------------------------------------------
- (void)DestroySelfUpdate:(Processor_ex *)pProc{DESTROY_OBJECT(self);UPDATE;NEXT_STAGE;}
//------------------------------------------------------------------------------------------------------
- (void)Reset:(Processor_ex *)pProc{SET_STAGE(m_strName,0);}
//------------------------------------------------------------------------------------------------------
- (void)HideSelf:(Processor_ex *)pProc{
    m_bHiden=YES;
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)ShowSelf:(Processor_ex *)pProc{
    m_bHiden=NO;
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)SelfTimer:(Processor_ex *)pProc{
    pProc->m_CurStage->m_pTime-=DELTA;
    
    if(pProc->m_CurStage->m_pTime<=0){
        
        pProc->m_CurStage->m_selector=pProc->m_CurStage->m_selectorSecond;
        
        NSString *TmpStrSelPrepare=[NSString stringWithFormat:@"Prepare%@",
                                    NSStringFromSelector(pProc->m_CurStage->m_selector)];
        
        SEL InitSel=NSSelectorFromString(TmpStrSelPrepare);
        
        if([self respondsToSelector:InitSel]){
            [self performSelector:InitSel withObject:self];
        }
    }
}
//функции-----------------------------------------------------------------------------------------------
- (void)SetPosWithOffsetOwner{
    
    if(m_pOwner){
		m_pCurPosition.x=m_pOwner->m_pCurPosition.x+m_pOffsetCurPosition.x;
		m_pCurPosition.y=m_pOwner->m_pCurPosition.y+m_pOffsetCurPosition.y;
	}
}
//------------------------------------------------------------------------------------------------------

@end
