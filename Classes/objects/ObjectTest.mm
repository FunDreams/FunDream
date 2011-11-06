//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectTest.h"

@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];    
    
    mWidth  = 80;
	mHeight = 80;

    m_iLayer = layerTemplet;

    m_bHiden=YES;
    
//START_QUEUE(@"test2")
//    
//    ASSIGN_STAGE(@"TestStage",@"AchiveLineFloat:",
//                 LINK_FLOAT_V(m_pCurAngle.z,@"Instance"),
//                 SET_FLOAT_V(m_pCurPosition.y-3000000,@"finish_Instance"),
//                 SET_FLOAT_V(-100,@"Vel"));
//    
//    
//END_QUEUE(@"test2")

START_QUEUE(@"test")
    ASSIGN_STAGE(@"Stage1",@"TestSel:",nil);
END_QUEUE(@"test")
    
//START_QUEUE(@"test")

//    ASSIGN_STAGE(@"TestStage",@"AchiveLineFloat:",
//                 LINK_FLOAT_V(m_pCurPosition.y,@"Instance"),
//                 SET_FLOAT_V(m_pCurPosition.y-300,@"finish_Instance"),
//                 SET_FLOAT_V(-40,@"Vel"));
    
  //  PARAMS_STAGE(@"TestStage",SET_FLOAT_V(-400,@"Vel"));

//    DELAY_STAGE(@"Stage1",3000,1000);

 //   ASSIGN_STAGE(@"Stage2",@"TestSel2:",nil);

//    INSERT_STAGE(@"Stage3",@"TestSel3:",@"Stage2",nil);
    
    
//START_QUEUE(@"test")
//    REMOVE_STAGE(@"Stage2");//[pProc Remove_Stage:@"Stage2"];
//END_QUEUE(@"test")
//    END_QUEUE(@"test")

    return self;
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];    
        
    int iDegree=RND%360;
    float fDegree=iDegree*4.14f/180;

    Vel=Vector3DMake(cosf(fDegree),sinf(fDegree),0);

    float fVelocity=(float)(RND%30)+10.0f;
    Vel.x*=fVelocity;
    Vel.y*=fVelocity;

    VelRotate=(float)(RND%30);

    m_pCurPosition.x=(float)(RND%640)-320;
    m_pCurPosition.y=(float)(RND%960)-480;
    
    pParticle=[[Particle alloc] Init:self];
    [pParticle AddToContainer:@"SysParticles"];
}
//------------------------------------------------------------------------------------------------------
- (void)Move:(Processor_ex *)pProc{
}
//------------------------------------------------------------------------------------------------------
- (void)timesel:(Processor_ex *)pProc{
}
//------------------------------------------------------------------------------------------------------
- (void)testAction2:(Processor_ex *)pProc{
}
//------------------------------------------------------------------------------------------------------
- (void)testAction:(Processor_ex *)pProc{
}
//------------------------------------------------------------------------------------------------------
- (void)TestSel3:(Processor_ex *)pProc{
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)TestSel2:(Processor_ex *)pProc{
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)TestSel:(Processor_ex *)pProc{
    
    m_pCurPosition.x+=Vel.x*DELTA;
    m_pCurPosition.y+=Vel.y*DELTA;

    m_pCurAngle.z+=VelRotate*DELTA;

    if(m_pCurPosition.x>320 && Vel.x>0){
        Vel.x=-Vel.x;
    }
    
    if(m_pCurPosition.x<-320 && Vel.x<0)
    {
        Vel.x=-Vel.x;
 //       DESTROY_OBJECT(self);
   //     return;
    }

    if(m_pCurPosition.y>480 && Vel.y>0){
        
        Vel.y=-Vel.y;
//        DESTROY_OBJECT(self);
  //      return;

    }
    if(m_pCurPosition.y<-480 && Vel.y<0)Vel.y=-Vel.y;
    
//    m_pCurScale.x+=3*DELTA;

    [pParticle UpdateParticleMatr];
    
//    pParticle->m_cColor3.green=0;
//    pParticle->m_cColor3.blue=0;
//    
//    mColor.red=0;
//    [pParticle UpdateParticleColor];

    
//    pParticle->m_vOffsetTex.x+=DELTA;
//    pParticle->m_vOffsetTex.y+=0.5f*DELTA;
//
//    [pParticle UpdateParticleTex];

//    pParticle->m_vTex1.x=0.5f;
//    pParticle->m_vTex2.y=0.5f;
//    pParticle->m_vTex3.x=0.5f;
//    pParticle->m_vTex4.y=0.5f;
//
//    [pParticle UpdateParticleTex4Vertex];

}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    
    [pParticle RemoveFromContainer];
    [pParticle release];

    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {
	[super dealloc];
}
//------------------------------------------------------------------------------------------------------
- (void)sfMove{}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT