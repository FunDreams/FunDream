//
//  Ob_ParticleCont_Ex.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_ParticleCont_ForStr.h"
#import "Ob_Cont_Res.h"
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
    [self SetWindow];

    pIndexParticles=[m_pObjMng->pStringContainer->m_OperationIndex InitMemory];
    pDrawPar=[m_pObjMng->pStringContainer->m_OperationIndex InitMemory];
    pCounts=[m_pObjMng->pStringContainer->m_OperationIndex InitMemory];
    pDrawText2=[m_pObjMng->pStringContainer->m_OperationIndex InitMemory];

    pTexRes=CREATE_NEW_OBJECT(@"Ob_Cont_Res", @"texture_Cont_Res",nil);
    pSoundRes=CREATE_NEW_OBJECT(@"Ob_Cont_Res", @"Sound_Cont_Res",nil);
}
//------------------------------------------------------------------------------------------------------
- (void)SetFullScreen{
    int Mode=*((int *)[ArrayPointsParent GetDataAtIndex:Ind_MODE_EMULATOR]);

    fOffset=0;
    
    switch (Mode) {
        case 0:
            [m_pObjMng->m_pParent SetInterfaceRotation:UIInterfaceOrientationPortrait];
            break;
            
        default:
            [m_pObjMng->m_pParent SetInterfaceRotation:UIInterfaceOrientationLandscapeRight];
            break;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;

    CurW=screenRect.size.width;
    CurH=screenRect.size.height;

    iMode=MODE_APP;
}
//------------------------------------------------------------------------------------------------------
- (void)SetWindow{
    fOffset=256;
    fOffsetAngle=0;

    CGRect screenRect = [UIScreen mainScreen].bounds;

    CurW=screenRect.size.height/2;
    CurH=screenRect.size.width;

    iMode=MODE_EDITOR;
    
}
//------------------------------------------------------------------------------------------------------
- (void)SetOrientation{
    [m_pObjMng->m_pParent SetInterfaceRotation:UIInterfaceOrientationLandscapeRight];
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateMatrixViewer{
    float DeltaX=*(ArrayPointsParent->pData+Ind_dX_EMULATOR);
    float DeltaY=*(ArrayPointsParent->pData+Ind_dY_EMULATOR);
    float Angle=*(ArrayPointsParent->pData+Ind_ANG_EMULATOR);
    float ScaleAdd=*(ArrayPointsParent->pData+Ind_SCALE_EMULATOR);
    float ScaleX=*(ArrayPointsParent->pData+Ind_SCALE_X_EMULATOR);
    float ScaleY=*(ArrayPointsParent->pData+Ind_SCALE_Y_EMULATOR);
    float W=*(ArrayPointsParent->pData+Ind_W_EMULATOR);
    float H=*(ArrayPointsParent->pData+Ind_H_EMULATOR);

    float *UpX=(ArrayPointsParent->pData+Ind_TOP_X);
    float *UpY=(ArrayPointsParent->pData+Ind_TOP_Y);

    float *Mode=ArrayPointsParent->pData+Ind_MODE_EMULATOR;

    float Tmpf=H/W;
    float fScale=1;
    
    if(Tmpf>=CurH/CurW)
    {
        fScale=CurH/H;
        *UpX=(CurW/fScale)*0.5;
        *UpY=0.5*H;
    }
    else
    {
        fScale=CurW/W;
        *UpX=0.5*W;
        *UpY=(CurH/fScale)*0.5;
    }
    
    if(iMode==MODE_EDITOR){
        fScale*=ScaleAdd*0.01f;
    }

    m_pCurPosition.x=DeltaX;
    m_pCurPosition.y=DeltaY;
    
    if(iMode==MODE_APP){
        m_pCurAngle.x=Angle;
    }
    else if(iMode==MODE_EDITOR){
        
        if(*Mode>0)
            m_pCurAngle.x=Angle+90;
        else m_pCurAngle.x=Angle;
    }
    
    m_pCurScale.x=((fScale*ScaleX)*0.01f);
    m_pCurScale.y=((fScale*ScaleY)*0.01f);
    
    if(pTouchOb!=0)
    {
        pTouchOb->mWidth=CurW;
        pTouchOb->mHeight=CurH;
        pTouchOb->m_pCurScale.x=CurW*0.5f;
        pTouchOb->m_pCurScale.y=CurH*0.5f;
        
        if(iMode==MODE_EDITOR)
        {
            pTouchOb->m_pCurPosition.x=fOffset;
            pTouchOb->m_pCurAngle.z=0;
        }
        else
        {
            pTouchOb->m_pCurPosition.x=0;
            if(*Mode>0)
                pTouchOb->m_pCurAngle.z=90;
            else pTouchOb->m_pCurAngle.z=0;
        }
    }
    
//make data
}
//------------------------------------------------------------------------------------------------------
static int Cycle=1;
- (void)UpdateTimeData{

    Cycle--;

    if(Cycle<=0)
    {
        Cycle=15;
        iCountTexture=0;
        float *MYear=(ArrayPointsParent->pData+Ind_DATA_Y);
        float *MMonth=(ArrayPointsParent->pData+Ind_DATA_M);
        float *MDay=(ArrayPointsParent->pData+Ind_DATA_DAY);
        float *MHour=(ArrayPointsParent->pData+Ind_DATA_H);
        float *MMin=(ArrayPointsParent->pData+Ind_DATA_MIN);
        float *MSec=(ArrayPointsParent->pData+Ind_DATA_S);
        
        //Get current time
        NSDate* now = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *dateComponents = [gregorian components:(NSHourCalendarUnit |
                NSMinuteCalendarUnit | NSSecondCalendarUnit | NSMonthCalendarUnit
                    |NSYearCalendarUnit | NSDayCalendarUnit) fromDate:now];

        *MHour = [dateComponents hour];
        *MMin = [dateComponents minute];
        *MSec = [dateComponents second];

        *MYear = [dateComponents year];
        *MMonth = [dateComponents month];
        *MDay = [dateComponents day];

        [gregorian release];
    }
}
//------------------------------------------------------------------------------------------------------
-(void)DrawSprites_ex:(int)iCountLoop data1:(int *)SData1 data2:(int *)S2 data3:(int *)SData3
             data4:(int *)SData4 fdata2:(int *)FD2 data4:(int *)FData4{
    
//    InfoArrayValue *pInfoPar=(InfoArrayValue *)*pDrawPar;
//    InfoArrayValue *pInfoTex=(InfoArrayValue *)*pDrawText;
//    InfoArrayValue *pInfoCount=(InfoArrayValue *)*pDrawCount;
//    int iOldCount=pInfoPar->mCount;
//    pInfoPar->mCount+=iCountLoop;
//    pInfoTex->mCount=pInfoPar->mCount;
//    pInfoCount->mCount=pInfoPar->mCount;
//    
//    if(pInfoTex->mCount>pInfoTex->mCopasity)
//    {
//        [m_pObjMng->pStringContainer->m_OperationIndex SetCopasity:pInfoPar->mCount WithData:pDrawPar];
//        [m_pObjMng->pStringContainer->m_OperationIndex SetCopasity:pInfoTex->mCount WithData:pDrawText];
//        [m_pObjMng->pStringContainer->m_OperationIndex SetCopasity:pInfoCount->mCount WithData:pDrawCount];
//    }
//    
//    unsigned int *SDataPar=(*((unsigned int**)pDrawPar)+SIZE_INFO_STRUCT);
//    int *SDataTex=(*pDrawText+SIZE_INFO_STRUCT);
//    int *SDataCount=(*pDrawCount+SIZE_INFO_STRUCT);
//    
//    float *pDataLocal=ArrayPointsParent->pData;
//    SDataCount[iOldCount]=iCountLoop;
//    
//    float *I1=(pDataLocal+SData1[0]);//Texture
//    ResourceCell *TmpCell=pTexRes->pCells+(int)*I1;
//    SDataTex[iOldCount]=TmpCell->iName;
//
//LOOP_DRAW:;
//    if(iCountLoop==0)return;
//    iCountLoop--;
//    
//    int *I2=((int *)pDataLocal+SData3[*SData4]);//Sprite
//    
//    SDataPar[iOldCount]=(unsigned int)*I2;
//    
//    if(SData4!=FData4)SData4++;
//    
//    iOldCount++;
//    goto LOOP_DRAW;
}
//------------------------------------------------------------------------------------------------------
-(void)DrawSprites:(int)iCountLoop data1:(int *)SData1 data2:(int *)SData2 data3:(int *)SData3
             data4:(int *)SData4 fdata2:(int *)FData2 data4:(int *)FData4{
    
    InfoArrayValue *pInfoPar=(InfoArrayValue *)*pDrawPar;
    
    InfoArrayValue *pInfoCount=(InfoArrayValue *)*pCounts;
    InfoArrayValue *pInfoTex2=(InfoArrayValue *)*pDrawText2;

    int iOldCount=pInfoPar->mCount;
    int iOldCountPar=pInfoPar->mCount*6;
    pInfoPar->mCount+=iCountLoop;
    pInfoPar->mCount=pInfoPar->mCount;
    
    if(pInfoPar->mCount*6>pInfoPar->mCopasity)
    {
        [m_pObjMng->pStringContainer->m_OperationIndex SetCopasity:pInfoPar->mCount*6 WithData:pDrawPar];
        pInfoPar=(InfoArrayValue *)*pDrawPar;
    }
    
    unsigned int *SDataPar=(*((unsigned int**)pDrawPar)+SIZE_INFO_STRUCT);
    unsigned int *SDataCount=(*((unsigned int**)pCounts)+SIZE_INFO_STRUCT);
    unsigned int *SDataTexture2=(*((unsigned int**)pDrawText2)+SIZE_INFO_STRUCT);
    
    float *pDataLocal=ArrayPointsParent->pData;
    
    if(pInfoCount->mCount>=pInfoCount->mCopasity)
    {
        pInfoCount->mCopasity+=10;
        [m_pObjMng->pStringContainer->m_OperationIndex
         SetCopasity:pInfoCount->mCopasity WithData:pCounts];
        pInfoCount=(InfoArrayValue *)*pCounts;
        SDataCount=(*((unsigned int**)pCounts)+SIZE_INFO_STRUCT);
        
        [m_pObjMng->pStringContainer->m_OperationIndex
         SetCopasity:pInfoCount->mCopasity WithData:pDrawText2];
        
        pInfoTex2=(InfoArrayValue *)*pDrawText2;
        SDataTexture2=(*((unsigned int**)pDrawText2)+SIZE_INFO_STRUCT);
    }
    pInfoCount->mCount++;
    pInfoTex2->mCount++;

    float *I1old=(pDataLocal+SData1[*SData2]);//Texture
    ResourceCell *TmpCellOld=pTexRes->pCells+(int)*I1old;
    ResourceCell *TmpCell=TmpCellOld;
    SDataCount[iCountTexture]=0;
    SDataTexture2[iCountTexture]=(unsigned int)TmpCellOld->iName;
    int tmpIndex=0;
    
LOOP_DRAW:;
    if(iCountLoop==0)
    {
        iCountTexture++;
        return;
    }
    iCountLoop--;
    
    float *I1=(pDataLocal+SData1[*SData2]);//Texture
    TmpCell=pTexRes->pCells+(int)*I1;
    
    if(TmpCell->iName!=TmpCellOld->iName)
    {
        iCountTexture++;
        
        pInfoCount->mCount++;
        pInfoTex2->mCount++;

        if(pInfoCount->mCount>=pInfoCount->mCopasity)
        {
            pInfoCount->mCopasity+=10;
            
            [m_pObjMng->pStringContainer->m_OperationIndex
             SetCopasity:pInfoCount->mCopasity WithData:pDrawText2];
            
            pInfoTex2=(InfoArrayValue *)*pDrawText2;
            SDataTexture2=(*((unsigned int**)pDrawText2)+SIZE_INFO_STRUCT);

             [m_pObjMng->pStringContainer->m_OperationIndex
                        SetCopasity:pInfoCount->mCopasity WithData:pCounts];

            pInfoCount=(InfoArrayValue *)*pCounts;
            SDataCount=(*((unsigned int**)pCounts)+SIZE_INFO_STRUCT);
        }
        
        SDataTexture2[iCountTexture]=TmpCell->iName;
        TmpCellOld=TmpCell;
        SDataCount[iCountTexture]=0;
    }
    
    tmpIndex=6*(*((int *)pDataLocal+SData3[*SData4]));
    SDataPar[iOldCountPar]=tmpIndex;
    SDataPar[iOldCountPar+1]=tmpIndex+1;
    SDataPar[iOldCountPar+2]=tmpIndex+2;
    SDataPar[iOldCountPar+3]=tmpIndex+3;
    SDataPar[iOldCountPar+4]=tmpIndex+4;
    SDataPar[iOldCountPar+5]=tmpIndex+5;
    
    if(SData2!=FData2)SData2++;
    if(SData4!=FData4)SData4++;
    
    SDataCount[iCountTexture]+=6;

    iOldCount++;
    iOldCountPar=iOldCount*6;
    goto LOOP_DRAW;
}
//------------------------------------------------------------------------------------------------------
- (void)SelfDrawOffset{

//    [self UpdateMatrixViewer];
//    [self UpdateTimeData];
//
//    glTranslatef(fOffset,0,0);
//    glRotatef(m_pCurAngle.x, 0, 0, 1);
//    glScalef(m_pCurScale.x,m_pCurScale.y,1);
//    glTranslatef(m_pCurPosition.x,m_pCurPosition.y,0);
//
//    InfoArrayValue *pInfoDraw=(InfoArrayValue *)(*pDrawPar);
//    int *StartData=(*pDrawPar)+SIZE_INFO_STRUCT;
//
//    InfoArrayValue *pInfoTex=(InfoArrayValue *)(*pDrawText);
//    int *StartDataTex=(*pDrawText)+SIZE_INFO_STRUCT;
//
//    InfoArrayValue *pInfopCounts=(InfoArrayValue *)(*pCounts);
//    int *StartDataCount=(*pCounts)+SIZE_INFO_STRUCT;
//
//    for (int i=0; i<pInfoTex->mCount; i++) {
//        
//        int iPlace=StartData[i];
//        int iTex=StartDataTex[i];
//        
//        glBindTexture(GL_TEXTURE_2D, iTex);
//        
//        glVertexPointer(3,GL_FLOAT,0,vertices+(iPlace)*6);
//        glTexCoordPointer(2,GL_FLOAT,0,texCoords+(iPlace)*12);
//        glColorPointer(4,GL_UNSIGNED_BYTE,0,squareColors+(iPlace)*24);
//
//        glDrawArrays(GL_TRIANGLES, 0, 6);
//    }
//    
////    glDrawElements(GL_TRIANGLES, <#GLsizei count#>, <#GLenum type#>, <#const GLvoid *indices#>)
//    pInfoDraw->mCount=0;
//    pInfoTex->mCount=0;
//    pInfopCounts->mCount=0;
////    CountIndex=0;
    

    [self UpdateMatrixViewer];
    [self UpdateTimeData];
    
    glTranslatef(fOffset,0,0);
    glRotatef(m_pCurAngle.x, 0, 0, 1);
    glScalef(m_pCurScale.x,m_pCurScale.y,1);
    glTranslatef(m_pCurPosition.x,m_pCurPosition.y,0);
    
    InfoArrayValue *pInfoDraw=(InfoArrayValue *)(*pDrawPar);
    int *StartData=(*pDrawPar)+SIZE_INFO_STRUCT;
    
    InfoArrayValue *pInfoTex2=(InfoArrayValue *)(*pDrawText2);
    int *StartDataTex=(*pDrawText2)+SIZE_INFO_STRUCT;
    
    InfoArrayValue *pInfopCounts=(InfoArrayValue *)(*pCounts);
    int *StartDataCount=(*pCounts)+SIZE_INFO_STRUCT;
    
    glVertexPointer(3,GL_FLOAT,0,vertices);
    glTexCoordPointer(2,GL_FLOAT,0,texCoords);
    glColorPointer(4,GL_UNSIGNED_BYTE,0,squareColors);

    unsigned int startInt=0;
    for (int i=0; i<pInfopCounts->mCount; i++) {
        
        int iTex=StartDataTex[i];
        int iCount=StartDataCount[i];

        glBindTexture(GL_TEXTURE_2D, iTex);
        glDrawElements(GL_TRIANGLES, iCount, GL_UNSIGNED_INT, StartData+startInt);
        
        startInt+=iCount;
    }

    pInfoDraw->mCount=0;
    pInfoTex2->mCount=0;
    pInfopCounts->mCount=0;
    iCountTexture=0;
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
    
    int *TmpPlace=(int *)[ArrayPointsParent GetDataAtIndex:iIndexLast];
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
    int iCount=pInfoParticles->mCount;
    
    for (int i=0;i<iCount;i++) {
        pStartData=(*pIndexParticles)+SIZE_INFO_STRUCT;
        int TmpIndex=pStartData[0];
        [self RemoveParticle:TmpIndex];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
   // [self RemoveAllParticles];

    [m_pObjMng->pStringContainer->m_OperationIndex OnlyReleaseMemory:pIndexParticles];
    [m_pObjMng->pStringContainer->m_OperationIndex OnlyReleaseMemory:pDrawPar];
    [m_pObjMng->pStringContainer->m_OperationIndex OnlyReleaseMemory:pCounts];
    [m_pObjMng->pStringContainer->m_OperationIndex OnlyReleaseMemory:pDrawText2];
    
    DESTROY_OBJECT(pTexRes);
    DESTROY_OBJECT(pSoundRes);

    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
-(void)selfSave:(NSMutableData *)m_pData{
    
    [m_pObjMng->pStringContainer->m_OperationIndex selfSave:m_pData WithData:pIndexParticles];
    
    int Size=m_iCountVertex*sizeof(Vertex3D);
    [m_pData appendBytes:&Size length:sizeof(int)];
    [m_pData appendBytes:vertices length:Size];

    Size=m_iCountVertex*2*sizeof(GLfloat);
    [m_pData appendBytes:&Size length:sizeof(int)];
    [m_pData appendBytes:texCoords length:Size];

    Size=m_iCountVertex*4*sizeof(GLubyte);
    [m_pData appendBytes:&Size length:sizeof(int)];
    [m_pData appendBytes:squareColors length:Size];
    
    [pTexRes selfSave:m_pData];
    [pSoundRes selfSave:m_pData];
}
//------------------------------------------------------------------------------------------
-(void)selfLoad:(NSMutableData *)m_pData rpos:(int *)iCurReadingPos{

  //  [self RemoveAllParticles];
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
    
    [pTexRes selfLoad:m_pData rpos:iCurReadingPos];
    [pSoundRes selfLoad:m_pData rpos:iCurReadingPos];
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{
    
    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
@end