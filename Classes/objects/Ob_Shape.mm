//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_Shape.h"

@implementation Ob_Shape
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerOb2;

        mWidth  = 2;
        mHeight = 2;

        m_iLayerTouch=layerTouch_0;//слой касания
        iDiff=1;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
//- (void)SetDefault{}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
//====//процессоры для объекта==========================================================================
    Processor_ex* pProc = [self START_QUEUE:@"Particle"];
        ASSIGN_STAGE(@"PROC",@"Particle:",nil);
        ASSIGN_STAGE(@"Idle",@"Idle:",nil);
    [self END_QUEUE:pProc];

    
    pProc = [self START_QUEUE:@"Proc"];
  //      ASSIGN_STAGE(@"IDLE",@"Idle:",nil);
        ASSIGN_STAGE(@"PROC1",@"Move1:",
                     SET_INT_V(4000,@"TimeBaseDelay"));
    
        ASSIGN_STAGE(@"PROC2",@"Birth:",nil);
    
        ASSIGN_STAGE(@"PROC3",@"Move2:",
                     SET_INT_V(4000,@"TimeBaseDelay"));

        ASSIGN_STAGE(@"IDLE",@"Idle:",nil)
    [self END_QUEUE:pProc name:@"Proc"];
//====//различные параметры=============================================================================
    SET_CELL(LINK_INT_V(iDiff,m_strName,@"iDiff"));
}
//------------------------------------------------------------------------------------------------------
-(id)NewParticle{
    Particle_Shape *pParticle=[[Particle_Shape alloc] Init:self];
    pParticle->m_fSize=15;
    pParticle->m_cColor=Color3DMake(1, 0, 0, 0);
    pParticle->m_iStage=0;
    
    return pParticle;
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];

    [m_pObjMng AddToGroup:@"Shapes" Object:self];

    SET_CELL(LINK_ID_V(self,@"Shape"));
    OBJECT_PERFORM_SEL(@"EvilPar",@"GetNear"); 
    
    PITCH_SOUND(@"Attract.wav",((float)(RND%20))*0.1f+0.5f);
    PLAY_SOUND(@"Attract.wav");

    iCountParInShape=iDiff;
    
    pStrings = [[NSMutableArray alloc] init];
}
//------------------------------------------------------------------------------------------------------
- (void)InitProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)PrepareProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)GenerateShape{

    if(iCountParInShape>1){

        FractalString *pStringX1FirstPoint=[[FractalString alloc] init];
        [pStrings addObject:pStringX1FirstPoint];

        FractalString *pStringY1FirstPoint=[[FractalString alloc] init];
        [pStrings addObject:pStringY1FirstPoint];


        FractalString *pStringXNeighbor;
        FractalString *pStringYNeighbor;

        for (int i=0; i<iCountParInShape; i++) {
            
            Particle_Shape *Par=[self CreateParticle];//создаём частицу
            [Par SetFrame:0];
            Par->m_iStage=0;

            if(i==0)
            {
                pStringXNeighbor=pStringX1FirstPoint;
                *pStringXNeighbor->S=0;//RND_I_F(0,10);
                *pStringXNeighbor->F=RND_I_F(0,60);

                pStringYNeighbor=pStringY1FirstPoint;
                *pStringYNeighbor->S=0;//RND_I_F(0,10);
                *pStringYNeighbor->F=RND_I_F(0,60);
            }
            
            Par->X1=pStringXNeighbor->T;
            Par->Y1=pStringYNeighbor->T;

            if(i!=iCountParInShape-1){
                
                //создаём первую струну
                FractalString *pStringX2=[[FractalString alloc] init];
                *pStringX2->S=0;//RND_I_F(0,10);
                Par->X2=pStringX2->T;
                *pStringX2->F=RND_I_F(0,60);
                
                [pStrings addObject:pStringX2];
                pStringXNeighbor=pStringX2;
                
                //создаём вторую струну
                FractalString *pStringY2=[[FractalString alloc] init];
                *pStringY2->S=0;//RND_I_F(0,10);
                Par->Y2=pStringY2->T;
                *pStringY2->F=RND_I_F(0,60);
                
                [pStrings addObject:pStringY2];
                pStringYNeighbor=pStringY2;

            }
            else
            {
                Par->X2=pStringX1FirstPoint->T;
                Par->Y2=pStringY1FirstPoint->T;
            }
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Move1:(Processor_ex *)pProc{
    m_pCurPosition.y-=80*DELTA;

    if(m_pCurPosition.y<199){
        NEXT_STAGE;
        m_fCurPosSlader=0;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Move2:(Processor_ex *)pProc{

    if(m_pCurPosition.y>0){
        m_pCurPosition.y-=80*DELTA;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)PrepareBirth:(ProcStage_ex *)pStage{
    [self GenerateShape];
    PLAY_SOUND(@"form_birth.wav");
}
//------------------------------------------------------------------------------------------------------
- (void)Birth:(Processor_ex *)pProc{
    
    float V=(m_fCurPosSlader+0.01f)*6;
//    m_pCurAngle.z+=200*DELTA;
    
    m_fCurPosSlader+=DELTA*V;
    if(m_fCurPosSlader>1){
        m_fCurPosSlader=1;
        NEXT_STAGE;
    }
    for (FractalString *pString in pStrings) {
        SET_MIRROR(m_fCurPosSlader, 1, 0, *pString->T, *pString->F, *pString->S);
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Particle:(Processor_ex *)pProc{
    
    for (Particle_Shape *pPar in m_pParticleInProc) {

        switch (pPar->m_iStage){
            case 0://show

                pPar->m_cColor.alpha+=5*DELTA;
                
                if(pPar->m_cColor.alpha>1){
                    pPar->m_cColor.alpha=1;
                    pPar->m_iStage=1;
                }
                
                [pPar UpdateParticleColor];

                [pPar UpdateParticleMatrWithDoublePoint];
                break;
                
            case 1://place

                [pPar UpdateParticleMatrWithDoublePoint];

                break;

            default:
                break;
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{

    for (Particle_Shape *pString in pStrings) {
        [pString release];
    }

    [pStrings release];
    
    [self RemoveAllParticles];
    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------------------------------
@implementation Particle_Shape
//------------------------------------------------------------------------------------------------------
-(void)UpdateParticleMatrWithDoublePoint{
    
    float deltaX=*X2-*X1;
    float deltaY=*Y2-*Y1;

    Vertex3D *m_pVertices=(m_pParticleContainer->vertices+(m_iCurrentOffset)*6);
    
    //получаем перпендикулярный вектор
    Vector3D V=Vector3DMake(deltaY,-deltaX,0);
    Vector3DNormalize(&V);

    //координаты вершин
    m_pVertices[0]=Vector3DMake((*X2+m_fSize*V.x),(*Y2+m_fSize*V.y), 0.0f);
    m_pVertices[1]=Vector3DMake((*X2-m_fSize*V.x),(*Y2-m_fSize*V.y), 0.0f);
    m_pVertices[2]=Vector3DMake((*X1+m_fSize*V.x),(*Y1+m_fSize*V.y), 0.0f);
    m_pVertices[3]=Vector3DMake((*X1-m_fSize*V.x),(*Y1-m_fSize*V.y), 0.0f);
    m_pVertices[4]=m_pVertices[2];
    m_pVertices[5]=m_pVertices[1]; 
}
@end
//------------------------------------------------------------------------------------------------------