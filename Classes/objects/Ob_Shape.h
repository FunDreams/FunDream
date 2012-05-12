
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
@interface Ob_Shape : Ob_ParticleCont_Ex {
@public 
    int iDiff;
    int iCountParInShape;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;
-(void)GenerateShape;

-(void)Destroy;
-(void)Start;
    
@end

@interface Particle_Shape : Particle_Ex {
@public
    float *X1;
    float *X2;
    float *Y1;
    float *Y2;
}

-(void)UpdateParticleMatrWithDoublePoint;
@end
