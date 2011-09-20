//
//  TestGameObject.h
//  Engine
//
//  Created by Konstantin on 02.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Object.h"


/** Класс реализующий обработку логики игры **/
@interface CGameLogic : GObject {
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

/** **/
-(void)dealloc;
- (void)Start;


@end