
//
//  TestGameObject.h
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Object.h"
#import "ObjectParticle.h"

/** Шаблонный класс для объектов**/
@interface ObjectPSimple : GObject {
    Particle *pParticle;
    float VelRotate;
    float m_fVelMovePos;
    float m_fVelMoveTmp;
    float m_iDir;
    float m_fPosSin;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

/** заготовки =) **/
-(void)Destroy;
-(void)Start;
-(void)Update;

    
@end
