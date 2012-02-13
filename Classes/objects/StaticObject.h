
//
//  TestGameObject.h
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Object.h"

/** Шаблонный класс для объектов**/
@interface StaticObject : GObject {
    bool m_bDimFromTexture;
    bool m_bDimMirrorX;
    bool m_bDimMirrorY;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

-(void)sfMove;
-(void)Start;

@end
