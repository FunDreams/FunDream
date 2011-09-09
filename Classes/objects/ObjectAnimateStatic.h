
//
//  TestGameObject.h
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "Object.h"

/** Шаблонный класс для объектов**/
@interface ObjectAnimateStatic : GObject {
    int m_iOffsetFrame;
    float m_fVelFrame;
    bool m_bDimFromTexture;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

/** заготовки =) **/
-(void)Destroy;
-(void)Start;
-(void)Update;

- (void)dealloc;
    
@end
