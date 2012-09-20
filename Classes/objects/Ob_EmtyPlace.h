
//
//  TestGameObject.h
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Object.h"

@class ObjectB_Ob;
/** Шаблонный класс для объектов**/
@interface Ob_EmtyPlace : GObject {
@public

    Vector3D LastPointTouch;
    bool m_bNotPush;
    bool m_bDoubleTouch;

    bool m_bPush;
    bool m_bCheck;
    NSMutableString *m_strNameSound;
    NSMutableString *m_strNameStage;
    NSMutableString *m_strNameObject;
    NSMutableString *m_strStartStage;
    
    NSMutableString *m_strNameStageDClick;
    NSMutableString *m_strNameObjectDClick;
		
	bool m_Disable;
    
    bool m_bDimFromTexture;
    bool m_bDimMirrorX;
    bool m_bDimMirrorY;
    bool m_bIsPush;
    
    bool m_bLookTouch;
    Color3D mColorBack;
    bool m_bBack;
    
    ObjectB_Ob *pObOb;
    FractalString *pStr;
    bool m_bStartMove;
    bool m_bStartPush;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

-(void)Start;

- (void)Proc:(Processor_ex *)pProc;

- (void)SetEmpty;
- (void)SetUnPush;
- (void)SetPush;

@end
