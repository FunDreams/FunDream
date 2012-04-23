//
//  TestGameObject.m
//  Engine
//
//  Created by Konstantin on 02.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "GameLogicObject.h"
#import "UniCell.h"

#ifdef BLACK_PIG
#import "ObjectStaff.h"
#endif

@implementation CGameLogic
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
    if (self != nil)
    {
        m_bHiden = true;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)Start
{    
    CREATE_NEW_OBJECT(@"StaticObject",@"Fon",
                      SET_STRING_V(@"fon@2x.png",@"m_pNameTexture"),
					  SET_FLOAT_V(640,@"mWidth"),
					  SET_FLOAT_V(960,@"mHeight"),
					  SET_INT_V(layerBackground,@"m_iLayer"));
	
	for (int k=0; k<14; k++) {	
		NSString *NameOb= [[[NSString alloc] initWithFormat:@"ObjectAlNumber%d",k] autorelease];
		RESERV_NEW_OBJECT(@"ObjectAlNumber",NameOb,nil);
	}
    
    CREATE_NEW_OBJECT(@"ObjectScoreFun1",@"Score",
                      SET_COLOR_V(Color3DMake(0, 1, 0, 1), @"mColor"),
                      SET_INT_V(1, @"m_iAlign"),
                      SET_FLOAT_V(45, @"m_fWNumber"),
                      SET_FLOAT_V(50,@"WSym"),
                      SET_FLOAT_V(92,@"HSym"),
                      SET_VECTOR_V(Vector3DMake(-45,430,0),@"m_pCurPosition"),
                      SET_STRING_V(@"First", @"m_strStartStage"),
					  SET_INT_V(layerNumber,@"m_iLayer"));
    
//interface======================================================================
//	CREATE_NEW_OBJECT(@"ObjectButton",@"ButtonPlay",
//					  SET_STRING_V(@"Button_Play_down@2x.png",@"m_DOWN"),
//					  SET_STRING_V(@"Button_Play_up@2x.png",@"m_UP"),
//					  SET_FLOAT_V(280,@"mWidth"),
//					  SET_FLOAT_V(300,@"mHeight"),
//                      SET_STRING_V(@"World",@"m_strNameObject"),
//                      SET_STRING_V(@"StartGame",@"m_strNameStage"),
//                      SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
//					  SET_VECTOR_V(Vector3DMake(180,330,0),@"m_pCurPosition"));
//===============================================================================
//    CREATE_NEW_OBJECT(@"ObjectParticle",@"ParticlesDown",
//                      SET_VECTOR_V(Vector3DMake(128,128,0),@"m_vSize"),
//                      SET_INT_V(1, @"m_iCountX"),
//                      SET_INT_V(1, @"m_iCountY"),
//                      SET_INT_V(1, @"m_INumLoadTextures"),
//                      SET_STRING_V(@"Down_Bullet.png",@"m_pNameTexture"));
//    
//    CREATE_NEW_OBJECT(@"ObjectParticle",@"ParticlesUp",
//                      SET_VECTOR_V(Vector3DMake(128,128,0),@"m_vSize"),
//                      SET_INT_V(1, @"m_iCountX"),
//                      SET_INT_V(1, @"m_iCountY"),
//                      SET_INT_V(1, @"m_INumLoadTextures"),
//                      SET_STRING_V(@"Up_Bullet.png",@"m_pNameTexture"));
    
//    CREATE_NEW_OBJECT(@"ObjectParticle",@"ParticlesMini",
//                      SET_VECTOR_V(Vector3DMake(32,32,0),@"m_vSize"),
//                      SET_INT_V(1, @"m_iCountX"),
//                      SET_INT_V(1, @"m_iCountY"),
//                      SET_INT_V(1, @"m_INumLoadTextures"),
//                      SET_STRING_V(@"Particle_001.png",@"m_pNameTexture"));
    
//    for (int k=0; k<300; k++) {	
//		NSString *NameOb= [[[NSString alloc] initWithFormat:@"MinPar%d",k] autorelease];
//		RESERV_NEW_OBJECT(@"OB_MiniParticle",NameOb,nil);
//	}
    
    CREATE_NEW_OBJECT(@"ObjectParticle",@"ParticlesPensil",
                      SET_VECTOR_V(Vector3DMake(32,32,0),@"m_vSize"),
                      SET_INT_V(1, @"m_iCountX"),
                      SET_INT_V(1, @"m_iCountY"),
                      SET_INT_V(1, @"m_INumLoadTextures"),
                      SET_STRING_V(@"Particle_001.png",@"m_pNameTexture"));

    CREATE_NEW_OBJECT(@"ObjectParticle",@"ParticlesShapes",
                      SET_VECTOR_V(Vector3DMake(32,32,0),@"m_vSize"),
                      SET_INT_V(1, @"m_iCountX"),
                      SET_INT_V(1, @"m_iCountY"),
                      SET_INT_V(1, @"m_INumLoadTextures"),
                      SET_STRING_V(@"Particle_001.png",@"m_pNameTexture"));
//===============================================================================

//	CREATE_NEW_OBJECT(@"ObjectCup",@"Cup",nil);
    CREATE_NEW_OBJECT(@"ObjectWorld",@"World",nil);
    
    
    
    
////////////////////////StartGameTest////////////////////////////////////////////////
    
    CREATE_NEW_OBJECT(@"ObjectMultiTouch",@"OMultiTouch",nil);
    
    for (int i=0; i<10; i++) {
        GObject *ObMatter = CREATE_NEW_OBJECT(@"ObjectEvilMatter1",@"EvilMater1",
                                              SET_VECTOR_V(Vector3DMake(350,540,0),@"m_pCurPosition"));
        
        if(ObMatter!=nil)
            [m_pChildrenbjectsArr addObject:ObMatter];
    }
    
    NEXT_STAGE_EX(@"Cup", @"Proc");
    
    SET_STAGE_EX(self->m_strName,@"GameProgress", @"Delay");
    
    [m_pObjMng->pMegaTree SetCell:SET_BOOL_V(YES,@"FirstSoundParticle")];
    
    OBJECT_PERFORM_SEL(@"Score", @"RezetScore");

//    float W=500;
//    
//    int iCountUp=100;
//    float StartPoint=-W/2;
//    float Step=W/iCountUp;
//    
//    for(int i=0;i<iCountUp;i++){
//        UNFROZE_OBJECT(@"OB_MiniParticle",
//            SET_VECTOR_V(m_pCurPosition,@"m_pCurPosition"),
//            SET_STRING_V(@"Up", @"m_pStrType"),
//            SET_VECTOR_V(Vector3DMake(StartPoint+Step*i+Step*0.5f,RND_I_F(40,10),0),@"End_Vector"));
//    }
//
//    int iCountDown=100;
//    Step=W/iCountDown;
//    
//    for(int i=0;i<iCountDown;i++){
//        UNFROZE_OBJECT(@"OB_MiniParticle",
//            SET_VECTOR_V(m_pCurPosition,@"m_pCurPosition"),
//            SET_STRING_V(@"Down", @"m_pStrType"),
//            SET_VECTOR_V(Vector3DMake(StartPoint+Step*i+Step*0.5f,RND_I_F(-40,10),0),@"End_Vector"));
//    }

    CREATE_NEW_OBJECT(@"ObjectGameSpaun",@"Spaun",nil);
//===============================================================================
    RESERV_NEW_OBJECT(@"ObjectBullets",@"ContainerBullet",
                      SET_VECTOR_V(Vector3DMake(32,32,0),@"m_vSize"),
                      SET_INT_V(1, @"m_iCountX"),
                      SET_INT_V(1, @"m_iCountY"),
                      SET_INT_V(1, @"m_INumLoadTextures"),
                      SET_STRING_V(@"Particle_001.png",@"m_pNameTexture"));
    
    UNFROZE_OBJECT(@"ObjectBullets",nil);

    RESERV_NEW_OBJECT(@"ObjectEvilPar",@"ObjectEvilPar",
                      SET_VECTOR_V(Vector3DMake(32,32,0),@"m_vSize"),
                      SET_INT_V(1, @"m_iCountX"),
                      SET_INT_V(1, @"m_iCountY"),
                      SET_INT_V(1, @"m_INumLoadTextures"),
                      SET_STRING_V(@"Particle_001.png",@"m_pNameTexture"));
    
    UNFROZE_OBJECT(@"ObjectEvilPar",nil);
//===============================================================================
//    CREATE_NEW_OBJECT(@"ObjectTest",@"Test",nil);    
//    for (int i=0; i<100; i++) {
//        CREATE_NEW_OBJECT(@"ObjectTest",@"Test",nil);
//    }
//физика приложения тут///////////////////////////////////////////////////////
//	CREATE_NEW_OBJECT(@"CPhysics",@"Physics",nil);
//	CREATE_NEW_OBJECT(@"CJumper",@"TestJumper",nil);
//    for (int k=0; k<40; k++) {	
//		NSString *NameOb= [[[NSString alloc] initWithFormat:@"ObjectPSimple%d",k] autorelease];
//		RESERV_NEW_OBJECT(@"ObjectPSimple",NameOb,nil);
//	}
    
    PLAY_SOUND(@"papper.wav");
}
@end
