
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
@interface OB_MiniParticle : GObject {
    Particle *pParticle;
    bool bUp;
    
    int iFinishFrame;
    float InstFrameFloat;
    NSMutableString *m_pStrType;
    float m_fPosSin;
    float m_fAmpl;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

/** заготовки =) **/
-(void)Destroy;
-(void)Start;
-(void)Update;
    
@end
