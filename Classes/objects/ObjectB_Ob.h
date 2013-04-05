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
@interface ObjectB_Ob : GObject {
@public

    Vector3D LastPointTouch;
    bool m_bNotPush;
    bool m_bStartPush;
    bool m_bStartMove;
    bool m_bDrag;
    bool m_bDoubleTouch;
    bool m_bStartTouch;
    bool m_bFlicker;

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
    bool m_bBack;
    
    FractalString *pString;
    GObject *pObEmptyPlace;
    
    int m_iTypeStr;
    
    float m_fWaitTime;
    
    Texture2D* TextureIndicatorValue;
    NSString *StrValueOnFace;
    
    Texture2D* TextureIndicatorLink;
    NSString *StrValueOnLink;
    int mCountTmp;

    Texture2D* TextureIndicatorSprite;
    NSString *StrValueSprite;
    
    int mTextureIdEn;
    int mTextureIdEx;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

-(void)Start;

- (void)UpdateTextureOnFace;

-(void)Proc:(Processor_ex *)pProc;
-(void)MoveObject:(CGPoint)Point WithMode:(bool)bMoveIn;

- (void)SetUnPush;
- (void)SetPush;
- (void)EndTouch;

- (void)setFlick;
- (void)setUnFlick;

@end
