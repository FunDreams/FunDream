
//
//  TestGameObject.h
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Object.h"
#import "FractalString.h"

@interface Particle_ForStr : NSObject {
@public
    float m_fSize;
    Color3D m_cColor;

    GObject* m_pParticleContainer;

    int m_iCurrentOffset;
    int m_iCurFrame;
    int m_iStage;
    
    float *X;
    float *Y;
}

-(id)Init:(GObject *)pObParent;

-(void)UpdateParticle;

-(void)UpdateParticleMatr;
-(void)UpdateParticleColor;
    
-(void)SetFrame:(int)iFrame;

-(void)dealloc;

@end

@interface Ob_ParticleCont_ForStr : GObject {
@public
    NSMutableArray *pStrings;//контейнер для управляющих струн
    NSMutableArray *m_pParticleInProc;//контейнер для отображающихся частиц
    NSMutableArray *m_pParticleInFreeze;//контейнер для замороженых частиц.
    
    NSMutableString *m_pNameAtlas;
    AtlasContainer *m_pAtlasContainer;
    int m_ICountFrames;
    GLuint Xstep;
    GLuint Ystep;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

/** Добавим/удалим частицу **/
-(id)NewParticle;
-(id)CreateParticle;
-(void)RemoveParticle:(Particle_ForStr *)pParticle;
-(void)FrezeParticle:(Particle_ForStr *)pParticle;
-(void)RemoveAllParticles;

/** заготовки =) **/
-(void)Destroy;
-(void)Start;

- (void)dealloc;

@end
