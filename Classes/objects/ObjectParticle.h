
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
@interface ObjectParticle : GObject {
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

/** заготовки =) **/
-(void)Destroy;
-(void)Start;
-(void)Update;

- (void)dealloc;

@end