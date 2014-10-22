//
//  TestGameObject.m
//  Engine
//
//  Created by Konstantin on 02.04.10.
//  Copyright 2010 FunDreams. All rights reserved.
//
#import "GameLogicObject.h"
#import "UniCell.h"
#import "Ob_ParticleCont_ForStr.h"
#import "Ob_ResourceMng.h"

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
    
     AtlasContainer *tmpAtlas=[[AtlasContainer alloc] InitWithName:@"PensilAtl"
                     NameStartTexture:@"Particle_001.png"
                     CountX:1 CountY:1 NumLoadTextures:1
                     SizeAtlas:Vector3DMake(32,32,0)];
    
    [m_pParent LoadTextureAtlas:tmpAtlas];
}
//------------------------------------------------------------------------------------------------------
- (void)Start
{
    PLAY_SOUND(@"papper.wav");
    [self ClearAllObjects];
    
#ifdef __EDITOR
    [self CreateObject_Editor];
#else

    [self CreateObject_Release];
#endif
}
//------------------------------------------------------------------------------------------------------
- (void)ClearAllObjects{[m_pObjMng DestroyAllObjects];}
//------------------------------------------------------------------------------------------------------
- (void)LoadRedactor{}
//------------------------------------------------------------------------------------------------------
- (void)RestartGame{}
//------------------------------------------------------------------------------------------------------
- (void)CreateObject_Editor{
    
    [m_pObjMng->pStringContainer SetParCont];
    UNFROZE_OBJECT(@"Ob_Editor_Interface",@"Ob_Editor_Interface",nil);
}
//------------------------------------------------------------------------------------------------------
- (void)CreateObject_Release{
    
    [m_pObjMng->pStringContainer SetParCont];

    bool bLoad = [m_pObjMng->pStringContainer LoadContainer];
    
    if(bLoad==NO)[m_pObjMng->pStringContainer SetEditor];
    
    UNFROZE_OBJECT(@"Ob_TouchView",@"TouchView",
                           SET_VECTOR_V(Vector3DMake(256,0,0),@"m_pCurPosition"));

    //создаём ресурсы по порядку
    UNFROZE_OBJECT(@"Ob_ResourceMng",@"TextureMng",
                               SET_INT_V(R_TEXTURE,@"m_iTypeRes"),
                               SET_VECTOR_V(Vector3DMake(-256, -49.9f, 0),@"m_pCurPosition"));
    
    UNFROZE_OBJECT(@"Ob_ResourceMng",@"SoundMng",
                             SET_INT_V(R_SOUND,@"m_iTypeRes"),
                             SET_VECTOR_V(Vector3DMake(-256, -49.9f, 0),@"m_pCurPosition"));
    
    [m_pObjMng->pStringContainer->ArrayPoints->pCurrenContPar->pTexRes PrepareResTexture];
    [m_pObjMng->pStringContainer->ArrayPoints->pCurrenContPar->pSoundRes PrepareResSound];

    [m_pObjMng->pStringContainer->ArrayPoints->pCurrenContPar SetFullScreen];

}
//------------------------------------------------------------------------------------------------------
@end
