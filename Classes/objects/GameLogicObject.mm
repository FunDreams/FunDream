//
//  TestGameObject.m
//  Engine
//
//  Created by Konstantin on 02.04.10.
//  Copyright 2010 FunDreams. All rights reserved.
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
        m_bImmortal=YES;
        m_bHiden = YES;
        [self LoadTextureAtlases];
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)LoadTextureAtlases
{
    AtlasContainer *tmpAtlas=[[AtlasContainer alloc] InitWithName:@"NumbersAtl"
                    NameStartTexture:@"0-01@2x.png" CountX:10 CountY:10 NumLoadTextures:100 SizeAtlas:Vector3DMake(512,1024,0)];
    
    [m_pParent LoadTextureAtlas:tmpAtlas];
    

     tmpAtlas=[[AtlasContainer alloc] InitWithName:@"PensilAtl"
                     NameStartTexture:@"Particle_001.png" CountX:1 CountY:1 NumLoadTextures:1 SizeAtlas:Vector3DMake(32,32,0)];
    
    [m_pParent LoadTextureAtlas:tmpAtlas];
}
//------------------------------------------------------------------------------------------------------
- (void)Start
{
    PLAY_SOUND(@"papper.wav");
    
#ifdef DEBUG
    [self CreateObject_Editor];
#else
    [self RestartGame];
#endif
}
//------------------------------------------------------------------------------------------------------
- (void)ClearAllObjects{[m_pObjMng DestroyAllObjects];}
//------------------------------------------------------------------------------------------------------
- (void)LoadRedactor{}
//------------------------------------------------------------------------------------------------------
- (void)RestartGame{
    [self ClearAllObjects];
#ifdef DEBUG
    [self CreateObject_Debug];
#else
    [self CreateObject_Release];
#endif
}
//------------------------------------------------------------------------------------------------------
- (void)CreateObject_Editor{
    
    [self ClearAllObjects];

    UNFROZE_OBJECT(@"Ob_Editor_Interface",@"Ob_Editor_Interface",nil);

    CREATE_NEW_OBJECT(@"Ob_ParticleCont_ForStr",@"SpriteContainer",
                      SET_STRING_V(@"PensilAtl",@"m_pNameAtlas"),
                      SET_VECTOR_V(Vector3DMake(0, 0, 0),@"m_pCurPosition"));

//    UNFROZE_OBJECT(@"ObjectButton",@"ButtonRestart",
//                   SET_STRING_V(@"ButtonRestart_Down.png",@"m_DOWN"),
//                   SET_STRING_V(@"ButtonRestart_Up.png",@"m_UP"),
//                   SET_FLOAT_V(64*FACTOR_DEC,@"mWidth"),
//                   SET_FLOAT_V(64,@"mHeight"),
//                   SET_BOOL_V(YES,@"m_bLookTouch"),
//                   SET_STRING_V(@"AIObject",@"m_strNameObject"),
//                   SET_STRING_V(@"RestartGame",@"m_strNameStage"),
//                   SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
//                   SET_VECTOR_V(Vector3DMake(-280,-440,0),@"m_pCurPosition"));
    
//    UNFROZE_OBJECT(@"Ob_Options",@"Options",nil);
    
//    UNFROZE_OBJECT(@"Ob_EditorPoint",@"Points",
//                   SET_STRING_V(@"PensilAtl",@"m_pNameAtlas"),
//                   SET_INT_V(6,@"iCountPar"));
    
    
//    UNFROZE_OBJECT(@"Ob_Slayder",@"SlayderX",
//                   SET_VECTOR_V(Vector3DMake(-250, -100, 0),@"m_pCurPosition"),
//                   SET_STRING_V(@"Back_Slayder.png",@"m_pNameTexture"));
//
//    UNFROZE_OBJECT(@"Ob_Slayder",@"SlayderY",
//                   SET_VECTOR_V(Vector3DMake(-250, -170, 0),@"m_pCurPosition"),
//                   SET_STRING_V(@"Back_Slayder.png",@"m_pNameTexture"));

//    UNFROZE_OBJECT(@"ObjectButton",@"ButtonPoint",
//                   SET_STRING_V(@"ButtonPoint_Down.png",@"m_DOWN"),
//                   SET_STRING_V(@"ButtonPoint_Up.png",@"m_UP"),
//                   SET_FLOAT_V(64*FACTOR_DEC,@"mWidth"),
//                   SET_FLOAT_V(64,@"mHeight"),
//                   SET_BOOL_V(YES,@"m_bLookTouch"),
//                   //            SET_STRING_V(@"Worl d",@"m_strNameObject"),
//                   //          SET_STRING_V(@"StartGame",@"m_strNameStage"),
//                   SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
//                   SET_VECTOR_V(Vector3DMake(-34*FACTOR_DEC,-440,0),@"m_pCurPosition"));
//
//    UNFROZE_OBJECT(@"ObjectButton",@"ButtonLine",
//                   SET_STRING_V(@"ButtonString_Down.png",@"m_DOWN"),
//                   SET_STRING_V(@"ButtonString_Up.png",@"m_UP"),
//                   SET_FLOAT_V(64*FACTOR_DEC,@"mWidth"),
//                   SET_FLOAT_V(64,@"mHeight"),
//                   SET_BOOL_V(YES,@"m_bLookTouch"),
//                   //            SET_STRING_V(@"World",@"m_strNameObject"),
//                   //          SET_STRING_V(@"StartGame",@"m_strNameStage"),
//                   SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
//                   SET_VECTOR_V(Vector3DMake(-102*FACTOR_DEC,-440,0),@"m_pCurPosition"));
}
//------------------------------------------------------------------------------------------------------
- (void)CreateObject_Debug
{
//particle containers============================================================
    UNFROZE_OBJECT(@"ObjectParticle",@"ParticlesPensil",
                   SET_STRING_V(@"PensilAtl",@"m_pNameAtlas"));
    
    UNFROZE_OBJECT(@"ObjectParticle",@"ParticlesScore",
                   SET_STRING_V(@"NumbersAtl",@"m_pNameAtlas"));
//===============================================================================
    UNFROZE_OBJECT(@"StaticObject",@"Fon",
                      SET_STRING_V(@"fon@2x.png",@"m_pNameTexture"),
					  SET_FLOAT_V(640,@"mWidth"),
					  SET_FLOAT_V(960,@"mHeight"),
					  SET_INT_V(layerBackground,@"m_iLayer"));
	    
    UNFROZE_OBJECT(@"ObjectScoreFun1",@"Score",
                      SET_COLOR_V(Color3DMake(0, 1, 0, 1), @"mColor"),
                      SET_INT_V(1, @"m_iAlign"),
                      SET_FLOAT_V(45, @"m_fWNumber"),
                      SET_FLOAT_V(50,@"WSym"),
                      SET_FLOAT_V(92,@"HSym"),
                      SET_VECTOR_V(Vector3DMake(-45,430,0),@"m_pCurPosition"),
                      SET_STRING_V(@"First", @"m_strStartStage"),
					  SET_INT_V(layerNumber,@"m_iLayer"));
//interface======================================================================
    UNFROZE_OBJECT(@"ObjectButton",@"ButtonRestart",
                      SET_STRING_V(@"ButtonRestart_Down.png",@"m_DOWN"),
                      SET_STRING_V(@"ButtonRestart_Up.png",@"m_UP"),
                      SET_FLOAT_V(64*FACTOR_DEC,@"mWidth"),
                      SET_FLOAT_V(64,@"mHeight"),
                      SET_BOOL_V(YES,@"m_bLookTouch"),
                      SET_STRING_V(@"AIObject",@"m_strNameObject"),
                      SET_STRING_V(@"RestartGame",@"m_strNameStage"),
                      SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                      SET_VECTOR_V(Vector3DMake(120*FACTOR_DEC,440,0),@"m_pCurPosition"));

    UNFROZE_OBJECT(@"ObjectButton",@"ButtonEditor",
                      SET_STRING_V(@"ButtonEditor_Down.png",@"m_DOWN"),
                      SET_STRING_V(@"ButtonEditor_Up.png",@"m_UP"),
                      SET_FLOAT_V(64*FACTOR_DEC,@"mWidth"),
                      SET_FLOAT_V(64,@"mHeight"),
                      SET_BOOL_V(YES,@"m_bLookTouch"),
                      SET_STRING_V(@"AIObject",@"m_strNameObject"),
                      SET_STRING_V(@"CreateObject_Editor",@"m_strNameStage"),
                      SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                      SET_VECTOR_V(Vector3DMake(52*FACTOR_DEC,440,0),@"m_pCurPosition"));

    UNFROZE_OBJECT(@"ObjectGameSpaun",@"Spaun",nil);
    UNFROZE_OBJECT(@"ObjectWorld",@"World",nil);
    UNFROZE_OBJECT(@"ObjectMultiTouch",@"OMultiTouch",nil);
    
    for (int i=0; i<10; i++) {
        GObject *ObMatter = UNFROZE_OBJECT(@"ObjectEvilMatter1",@"EvilMater1",
                                              SET_VECTOR_V(Vector3DMake(350,540,0),@"m_pCurPosition"));
        
        if(ObMatter!=nil)
            [m_pChildrenbjectsArr addObject:ObMatter];
    }

    SET_STAGE_EX(self->m_strName,@"GameProgress", @"Delay");
    [m_pObjMng->pMegaTree SetCell:SET_BOOL_V(YES,@"FirstSoundParticle")];
    
    OBJECT_PERFORM_SEL(@"Score", @"RezetScore");

    
    GObject* PobBullet=UNFROZE_OBJECT(@"ObjectBullets",@"ContainerBullet",
                      SET_STRING_V(@"PensilAtl",@"m_pNameAtlas"),
                      SET_INT_V(60,@"iCountPar"));
    
    GObject* PobEvil=UNFROZE_OBJECT(@"ObjectEvilPar",@"EvilPar",
                      SET_STRING_V(@"PensilAtl",@"m_pNameAtlas"),
                      SET_INT_V(100,@"iCountPar"));

    OBJECT_PERFORM_SEL(NAME(PobBullet), @"CreateNewParticle");
    OBJECT_PERFORM_SEL(NAME(PobEvil), @"CreateNewParticle");

    return;
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
    //===============================================================================
    
//    CREATE_NEW_OBJECT(@"ObjectCup",@"Cup",nil);
//    NEXT_STAGE_EX(@"Cup", @"Proc");
    
    
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
    //           SET_VECTOR_V(Vector3DMake(StartPoint+Step*i+Step*0.5f,RND_I_F(-40,10),0),@"End_Vector"));
    //    }
    
    //===============================================================================
//    RESERV_NEW_OBJECT(@"ObjectBullets",@"ContainerBullet",
//                      SET_VECTOR_V(Vector3DMake(32,32,0),@"m_vSize"),
//                      SET_INT_V(1, @"m_iCountX"),
//                      SET_INT_V(1, @"m_iCountY"),
//                      SET_INT_V(1, @"m_INumLoadTextures"),
//                      SET_STRING_V(@"Particle_001.png",@"m_pNameTexture"));
//    
//    RESERV_NEW_OBJECT(@"ObjectEvilPar",@"EvilPar",
//                      SET_VECTOR_V(Vector3DMake(32,32,0),@"m_vSize"),
//                      SET_INT_V(1, @"m_iCountX"),
//                      SET_INT_V(1, @"m_iCountY"),
//                      SET_INT_V(1, @"m_INumLoadTextures"),
//                      SET_STRING_V(@"Particle_001.png",@"m_pNameTexture"));
//
//
//    GObject* PobBullet=UNFROZE_OBJECT(@"ObjectBullets",@"ContainerBullet",SET_INT_V(100,@"iCountPar"));
//    OBJECT_PERFORM_SEL(NAME(PobBullet), @"CreateNewParticle");
//
//    GObject* PobEvil=UNFROZE_OBJECT(@"ObjectEvilPar",@"EvilPar",SET_INT_V(60,@"iCountPar"));
//    OBJECT_PERFORM_SEL(NAME(PobEvil), @"CreateNewParticle");
    //===============================================================================
    //    CREATE_NEW_OBJECT(@"ObjectTest",@"Test",nil);
    //    for (int i=0; i<100; i++) {
    //        CREATE_NEW_OBJECT(@"ObjectTest",@"Test",nil);
    //    }
}
//------------------------------------------------------------------------------------------------------
- (void)CreateObject_Release{
    CREATE_NEW_OBJECT(@"StaticObject",@"Fon",
                      SET_STRING_V(@"fon@2x.png",@"m_pNameTexture"),
                      SET_FLOAT_V(640,@"mWidth"),
                      SET_FLOAT_V(960,@"mHeight"),
                      SET_INT_V(layerBackground,@"m_iLayer"));
}
//------------------------------------------------------------------------------------------------------
@end
