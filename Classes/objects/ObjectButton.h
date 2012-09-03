
//
//  TestGameObject.h
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Object.h"

//тип кнопки
typedef enum tagTypeButton {
    bSimple=0,
    bCheckBox,
    bRadioBox,
} EGP_TypeButton;

/** Шаблонный класс для объектов**/
@interface ObjectButton : GObject {
@public

    bool m_bStartPush;
    bool m_bDrag;
    bool m_bDoubleTouch;

    int m_iType;
    bool m_bPush;
    bool m_bCheck;
    NSMutableString *m_strNameSound;
    NSMutableString *m_strNameStage;
    NSMutableString *m_strNameObject;
    NSMutableString *m_strStartStage;
    
    NSMutableString *m_strNameStageDClick;
    NSMutableString *m_strNameObjectDClick;

	NSMutableString *m_DOWN;
	NSMutableString *m_UP;
	
	UInt32 m_TextureDown;
	UInt32 m_TextureUP;	
	
	bool m_Disable;
    
    bool m_bDimFromTexture;
    bool m_bDimMirrorX;
    bool m_bDimMirrorY;
    
    bool m_bLookTouch;
    Color3D mColorBack;
    bool m_bBack;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

-(void)Start;

- (void)Proc:(Processor_ex *)pProc;

- (void)SetUnPush;
- (void)SetPush;

@end
