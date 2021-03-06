
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
@interface ObjectMultiTouch : GObject {
    GObject *TmpLastNearOb;
    Vector3D m_vLastPos;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

/** заготовки =) **/
-(void)Destroy;
-(void)Start;
-(void)Update;

- (GObject *)GetNear:(CGPoint)Point;
- (float)GetNearDist:(CGPoint)Point;
- (CGPoint)CoppectPoint:(CGPoint)Point;
    
@end
