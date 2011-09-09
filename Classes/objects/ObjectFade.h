
//
//  TestGameObject.h
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Object.h"

//макрос для названия объекта, просто переименуйте его что бы получить новый объект
#define NAME_TEMPLETS_OBJECT ObjectFade

/** Шаблонный класс для объектов**/
@interface NAME_TEMPLETS_OBJECT : GObject {
    NSMutableString *m_strNameSound;
    NSMutableString *m_strNameStage;
    NSMutableString *m_strNameObject;
    
    bool m_bObTouch;
    bool m_bLookTouch;
    
    bool m_bDimFromTexture;
    bool m_bDimMirrorX;
    bool m_bDimMirrorY;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

/** **/
-(void)dealloc;
-(void)Start;
-(void)Move;

@end
