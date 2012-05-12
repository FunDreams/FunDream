//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectBullets.h"
#import "ConstantsAndMacros.h"

@implementation ObjectBullets
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
    if(self!=nil)
    {
        m_iLayer = layerOb2;
        iCountPar = 100;
        
        mWidth  = 2;
        mHeight = 2;
    }
	return self;
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
}
//------------------------------------------------------------------------------------------------------
- (void)PostSetParams{
    [super PostSetParams];
}
//------------------------------------------------------------------------------------------------------
-(id)NewParticle{
    PARTICLE *pParticle=[[PARTICLE alloc] Init:self];
    pParticle->m_fSize=15;
    pParticle->m_cColor=Color3DMake(0, 1, 0, 0);

    return pParticle;
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    [super Start];
    
    mColor.alpha=0;
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
        
        Par->vFinish=Vector3DMake(StartPoint+Step*i+Step*0.5f,RND_I_F(-120,30),0);
    }
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
    float V=(m_fCurPosSlader+0.00001f)*6;
    
    m_fCurPosSlader+=DELTA*V;
    if(m_fCurPosSlader>1){
        m_fCurPosSlader=1;
        NEXT_STAGE;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Particle:(Processor_ex *)pProc{

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
                    pPar->vFinish.y=-460;
                }

                break;
                
            case 1://Placement
                pPar->m_vPos.x=(pPar->vFinish.x-pPar->vStart.x)*m_fCurPosSlader+pPar->vStart.x;
                pPar->m_vPos.y=(pPar->vFinish.y-pPar->vStart.y)*m_fCurPosSlader+pPar->vStart.y;
                
                [pPar UpdateParticleMatr];
                
                if(m_fCurPosSlader>=1){
                    
                    pPar->m_iStage=2;
                    
                    pPar->fVelPhase=(RND_I_F(10,20))*0.1f;
                    pPar->fVelMove=(RND_I_F(0,20));
                    if(pPar->fVelMove>0)pPar->fVelMove+=20;
                    if(pPar->fVelMove<=0)pPar->fVelMove-=20;
                }

                break;
                
            case 2://Sin
                
                pPar->fPhase+=DELTA*pPar->fVelPhase;
                pPar->CurrentOffset=8*sin(pPar->fPhase);

                [pPar UpdateParticleMatrWihtOffset];
                
                pPar->m_vPos.x+=pPar->fVelMove*DELTA;
                
                if(pPar->m_vPos.x>300 && pPar->fVelMove>0)pPar->fVelMove=-pPar->fVelMove;
                if(pPar->m_vPos.x<-300 && pPar->fVelMove<0)pPar->fVelMove=-pPar->fVelMove;
                break;
            default:
                break;
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{

    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------------------------------
@implementation PARTICLE
-(void)UpdateParticleMatrWihtOffset{
    Vertex3D *m_pVertices=(m_pParticleContainer->vertices+(m_iCurrentOffset)*6);
    
    //координаты вершин
    m_pVertices[0]=Vector3DMake(-m_fSize+m_vPos.x,  m_fSize+m_vPos.y+CurrentOffset, 0.0f);
    m_pVertices[1]=Vector3DMake( m_fSize+m_vPos.x,  m_fSize+m_vPos.y+CurrentOffset, 0.0f);
    m_pVertices[2]=Vector3DMake(-m_fSize+m_vPos.x, -m_fSize+m_vPos.y+CurrentOffset, 0.0f);
    m_pVertices[3]=Vector3DMake( m_fSize+m_vPos.x, -m_fSize+m_vPos.y+CurrentOffset, 0.0f);
    m_pVertices[4]=m_pVertices[2];
    m_pVertices[5]=m_pVertices[1]; 
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{
    [Owner release];
    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
@end