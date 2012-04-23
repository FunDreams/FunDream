
//
//  TestGameObject.h
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Object.h"

@interface Particle_Ex : NSObject {
@public
    Vector3D m_vPos;
    float m_fSize;
    Color3D m_cColor;

    GObject* m_pParticleContainer;    

    int m_iCurrentOffset;
    int m_iCurFrame;
    int m_iStage;
}

-(id)Init:(GObject *)pObParent;

-(void)UpdateParticle;

-(void)UpdateParticleMatr;
-(void)UpdateParticleColor;
    
-(void)SetFrame:(int)iFrame;

-(void)dealloc;

@end

@interface Ob_ParticleCont_Ex : GObject {
@public
    NSMutableArray *m_pParticleInProc;
    NSMutableArray *m_pParticleInFreeze;
    
    Vector3D m_vSize;
    int m_iCountX;
    int m_iCountY;
    int m_ICountFrames;
    int m_INumLoadTextures;
    
    GLuint Xstep;
    GLuint Ystep;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

/** Добавим/удалим частицу **/
-(id)NewParticle;
-(id)CreateParticle;
-(void)RemoveParticle:(Particle_Ex *)pParticle;

-(UInt32)LoadTextureAtlas;
/** заготовки =) **/
-(void)Destroy;
-(void)Start;

- (void)dealloc;

@end