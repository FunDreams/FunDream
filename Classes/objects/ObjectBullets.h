
//
//  TestGameObject.h
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Object.h"
#import "Ob_ParticleCont_Ex.h"


/** Шаблонный класс для объектов**/
@interface ObjectBullets : Ob_ParticleCont_Ex {
    int iCountPar;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;
-(void)CreateNewParticle;
/** заготовки =) **/
-(void)Destroy;
-(void)Start;
    
@end

#define PARTICLE Particle_Bullet
@interface PARTICLE : Particle_Ex {
@public
    
    Vector3D vStart;
    Vector3D vFinish;
    float CurrentOffset;
    float fPhase;
    float fVelPhase;
    float fVelMove;
    GObject *Owner;
}
-(void)UpdateParticleMatrWihtOffset;
@end
