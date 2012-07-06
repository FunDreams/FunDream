//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectEvilPar.h"
#import "ConstantsAndMacros.h"
#import "Ob_Shape.h"

@implementation ObjectEvilPar
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
    if(self!=nil)
    {
        m_iLayer = layerOb2;
        iCountPar = 6;
        
        mWidth  = 2;
        mHeight = 2;
        
        ShapesX = [[FunArrayData alloc] initWithCopasity:6 CountByte:sizeof(float)];
        m_iDeep=5;
    }
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{
    m_bHiden=NO;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    
    Processor_ex* pProc = [self START_QUEUE:@"Particle"];
        ASSIGN_STAGE(@"PROC",@"Particle:",nil);
        ASSIGN_STAGE(@"Idle",@"Idle:",nil);
    [self END_QUEUE:pProc];

    pProc = [self START_QUEUE:@"ProcBullet"];
        ASSIGN_STAGE(@"Show",@"Show:",nil);
        ASSIGN_STAGE(@"Placement",@"Placement:",nil);
        ASSIGN_STAGE(@"Idle",@"Idle:",nil);
    [self END_QUEUE:pProc];
    
    SET_CELL(LINK_INT_V(iCountPar,m_strName,@"iCountPar"));
    SET_CELL(LINK_INT_V(iCountParInSin,m_strName,@"iCountParInSin"));
}
//------------------------------------------------------------------------------------------------------
- (void)PostSetParams{
    [super PostSetParams];
}
//------------------------------------------------------------------------------------------------------
-(id)NewParticle{
    PARTICLE *pParticle=[[PARTICLE alloc] Init:self];
    pParticle->m_fSize=15;
    pParticle->m_cColor=Color3DMake(1, 0, 0, 0);
    pParticle->m_iStage=0;
    pParticle->m_fAmpl=4;
    
    return pParticle;
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    [super Start];
    
    mColor.alpha=0;
    [ShapesX Reset];
    
    SET_STAGE_EX(NAME(self), @"ProcBullet", @"Show");
}
//------------------------------------------------------------------------------------------------------
-(void)CreateNewParticle{
    
    float W=500;
    float StartPoint=-W/2;
    float Step=W/iCountPar;

    for (int i=0; i<iCountPar; i++) {
        
        PARTICLE *Par=[self CreateParticle];
        [Par SetFrame:0];
        Par->m_iStage=0;
        Par->vStart=m_pCurPosition;
        Par->m_vPos=m_pCurPosition;
        
        Par->vFinish=Vector3DMake(StartPoint+Step*i+Step*0.5f,RND_I_F(60,30),0);
    }
}
//------------------------------------------------------------------------------------------------------
-(void)GetNear{
    Ob_Shape *Shape=GET_ID_V(@"Shape");
    
    NSMutableArray *pArrNearOb = [[NSMutableArray alloc] init];
    
    int countsds=0;
    for (PARTICLE *pPar in m_pParticleInProc) {
        
        if(pPar->m_iStage!=2)continue;
        
        countsds++;
        float fDist=fabs(pPar->m_vPos.x-Shape->m_pCurPosition.x);
        bool bAdd=NO;
        
        for (int i=0;i<[pArrNearOb count];i++) {
            
            PARTICLE *pObNear = [pArrNearOb objectAtIndex:i];
            float fDistNearsInArr=fabs(pObNear->m_vPos.x-Shape->m_pCurPosition.x);
            
            if(fDist<=fDistNearsInArr){
                
                PARTICLE *pOBInArray=[pArrNearOb objectAtIndex:i];
                
                if(pOBInArray==pPar){
                    [pArrNearOb removeObjectAtIndex:i];
                }
                
                [pArrNearOb insertObject:pPar atIndex:i];
                bAdd=YES;
                break;
            }
        }
        
        if([pArrNearOb count]>Shape->iDiff){
            [pArrNearOb removeLastObject];
        }
        
        if(bAdd==NO && [pArrNearOb count]<Shape->iDiff){
            
            [pArrNearOb addObject:pPar];
        }
    }

    if([pArrNearOb count]>0){
        for (PARTICLE *pPar in pArrNearOb) {
            
            iCountParInSin--;
            pPar->m_iStage=3;
            pPar->vParent=&Shape->m_pCurPosition;
        }
    }   
    [pArrNearOb release];
}
//------------------------------------------------------------------------------------------------------
- (void)Show:(Processor_ex *)pProc{
    
    mColor.alpha+=DELTA*3;
    if(mColor.alpha>1){
        mColor.alpha=1;
        NEXT_STAGE;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)PreparePlacement:(ProcStage_ex *)pStage{
    
    m_fCurPosSlader=0;
}
//------------------------------------------------------------------------------------------------------
- (void)Placement:(Processor_ex *)pProc{
    float V=(m_fCurPosSlader+0.1f)*10;//0.00001f
    
    m_fCurPosSlader+=DELTA*V;
    if(m_fCurPosSlader>1){
        m_fCurPosSlader=1;
        PLAY_SOUND(@"water.wav");
        NEXT_STAGE;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Particle:(Processor_ex *)pProc{
    
    float Vel;
    
    NSMutableArray *pArr= [m_pObjMng GetGroup:@"Shapes"];

    [ShapesX Reset];
    if(pArr!=nil && [pArr count]>0){
        
        for(GObject *pOb in pArr){
            
            if(pOb->m_pCurPosition.y>260)
                [ShapesX AddData:&pOb->m_pCurPosition.x];
        }
    }

    for (PARTICLE *pPar in m_pParticleInProc) {
    
        switch (pPar->m_iStage) {
            case 0://show
                
                pPar->m_vPos.x=(pPar->vFinish.x-pPar->vStart.x)*mColor.alpha+pPar->vStart.x;
                pPar->m_vPos.y=(pPar->vFinish.y-pPar->vStart.y)*mColor.alpha+pPar->vStart.y;
                
                pPar->m_cColor.alpha=mColor.alpha;
                
                [pPar UpdateParticleMatr];
                [pPar UpdateParticleColor];
                
                if(mColor.alpha>=1){
                    pPar->m_iStage=1;
                    pPar->vStart=pPar->m_vPos;
                    
                    pPar->vFinish.x=RND_I_F(pPar->vFinish.x, 30);
                    pPar->vFinish.y=320;
                }

                break;
                
            case 1://Placement
                pPar->m_vPos.x=(pPar->vFinish.x-pPar->vStart.x)*m_fCurPosSlader+pPar->vStart.x;
                pPar->m_vPos.y=(pPar->vFinish.y-pPar->vStart.y)*m_fCurPosSlader+pPar->vStart.y;
                
                [pPar UpdateParticleMatr];
                
                if(m_fCurPosSlader>=1){
                                        
                    pPar->m_iStage=2;
                    iCountParInSin++;
                    pPar->fVelPhase=(RND_I_F(10,20))*0.1f;
                    pPar->fVelMove=(RND_I_F(0,20));
                    if(pPar->fVelMove>0)pPar->fVelMove+=20;
                    if(pPar->fVelMove<=0)pPar->fVelMove-=20;
                    pPar->m_fVelRotate=RND_I_F(0,100);
                }
                
                break;

            case 2://Sin
                
                pPar->fPhase+=DELTA*pPar->fVelPhase;
                pPar->CurrentOffset=pPar->m_fAmpl*sin(pPar->fPhase);
                
                for(int i=0;i<ShapesX->iCountInArray;i++){
                    float fDelta=pPar->m_vPos.x-*((float*)[ShapesX GetDataAtIndex:i]);
                    
                    if(fabs(fDelta)<60){
                        
                        if(fDelta<0 && pPar->fVelMove>0){
                            pPar->fVelMove=-pPar->fVelMove;
                        }
                        
                        if(fDelta>0 && pPar->fVelMove<0){
                            pPar->fVelMove=-pPar->fVelMove;
                        }
                    }
                }

                pPar->m_vPos.x+=pPar->fVelMove*DELTA;
                
                if(pPar->m_vPos.x>300 && pPar->fVelMove>0)pPar->fVelMove=-pPar->fVelMove;
                if(pPar->m_vPos.x<-300 && pPar->fVelMove<0)pPar->fVelMove=-pPar->fVelMove;
                
                [pPar UpdateParticleMatrWihtOffset];
                break;
                
            case 3://Attach

                Vel=(pPar->vParent->x-pPar->m_vPos.x)*3.0f;
                pPar->m_vPos.x+=Vel*DELTA;

                Vel=(pPar->vParent->y-25-pPar->m_vPos.y)*3.0f;
                pPar->m_vPos.y+=Vel*DELTA;

                pPar->m_fAmpl+=10*DELTA;
                if(pPar->m_fAmpl>16)pPar->m_fAmpl=16;

                pPar->fPhase+=DELTA*pPar->fVelPhase;
                pPar->CurrentOffset=pPar->m_fAmpl*sin(pPar->fPhase);

                pPar->m_fAngle+=DELTA*pPar->m_fVelRotate;

                [pPar UpdateParticleMatrWihtOffset];

                if(pPar->vParent->y<200){
                    pPar->m_iStage=4;
                }
                break;
                
            case 4://Hide
                
                pPar->m_cColor.alpha-=4*DELTA;
                
                if(pPar->m_cColor.alpha<0){
                    pPar->m_cColor.alpha=0;
                    [self FrezeParticle:pPar];
                    break;
                }
                
                [pPar UpdateParticleMatrWihtOffset];
                [pPar UpdateParticleColor];

                break;
            default:
                break;
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{

    [self RemoveAllParticles];
    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{
    [ShapesX release];
    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------------------------------
@implementation PARTICLE
-(void)UpdateParticleMatrWihtOffset{
    Vertex3D *m_pVertices=(m_pParticleContainer->vertices+(m_iCurrentOffset)*6);
    
    //////координаты вершин
    float fAngleRadians=m_fAngle*3.14f/180;
    
    float fCos=cosf(fAngleRadians);//1
    float fSin=sinf(fAngleRadians);//0
    
    //cos  -sin
    //sin  cos
    
    float X1=+m_fSize;
    float X2=-m_fSize;
    float Y1=CurrentOffset+m_fSize;
    float Y2=CurrentOffset-m_fSize;
    
    m_pVertices[0]=Vector3DMake(X2*fCos-Y1*fSin+m_vPos.x,X2*fSin+Y1*fCos+m_vPos.y,0.0f);
    m_pVertices[1]=Vector3DMake(X1*fCos-Y1*fSin+m_vPos.x,X1*fSin+Y1*fCos+m_vPos.y,0.0f);
    m_pVertices[2]=Vector3DMake(X2*fCos-Y2*fSin+m_vPos.x,X2*fSin+Y2*fCos+m_vPos.y,0.0f);
    m_pVertices[3]=Vector3DMake(X1*fCos-Y2*fSin+m_vPos.x,X1*fSin+Y2*fCos+m_vPos.y,0.0f);

    m_pVertices[4]=m_pVertices[2];
    m_pVertices[5]=m_pVertices[1]; 
}
//------------------------------------------------------------------------------------------------------
@end