
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

//макрос для названия объекта, просто переименуйте его что бы получить новый объект
#define NAME_TEMPLETS_OBJECT ObjectButton

/** Шаблонный класс для объектов**/
@interface NAME_TEMPLETS_OBJECT : GObject {
	
    NSMutableString *m_strNameSound;
    NSMutableString *m_strNameStage;
    NSMutableString *m_strNameObject;

	NSMutableString *m_DOWN;
	NSMutableString *m_UP;
	
	UInt32 m_TextureDown;
	UInt32 m_TextureUP;	
	
	bool m_Disable;
    
    bool m_bDimFromTexture;
    bool m_bDimMirrorX;
    bool m_bDimMirrorY;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

/** **/
-(void)dealloc;
-(void)Start;

- (void)Proc:(Processor_ex *)pProc;

@end
