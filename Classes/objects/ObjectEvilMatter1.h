
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
@interface ObjectEvilMatter1 : GObject {
    Vector3D m_vCenter;
    Vector3D m_Corner1;
    Vector3D m_Corner2;
    Vector3D m_vPoint;
    
    float StartAngle;
    bool m_bFirstPoint;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

/** заготовки =) **/
-(void)Destroy;
-(void)Start;
-(void)Update;

- (void)CreateNextPoint;
- (void)dealloc;
    
@end
