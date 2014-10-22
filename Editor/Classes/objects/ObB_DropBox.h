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
@interface ObB_DropBox : GObject {
@public

    bool m_bStartPush;
    bool m_bDrag;
    bool m_bDoubleTouch;
    bool m_bStartMove;

    bool m_bPush;
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

    bool m_bLookTouch;

    Color3D mColorBack;
    Color3D mColorBackCorn;
    
    bool m_bBack;
    
    FractalString *pString;
    GObject *pObEmptyPlace;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

-(void)Start;

-(void)Proc:(Processor_ex *)pProc;
-(void)MoveObject:(CGPoint)Point WithMode:(bool)bMoveIn;

- (void)SetUnPush;
- (void)SetPush;
- (void)EndTouch;
@end
