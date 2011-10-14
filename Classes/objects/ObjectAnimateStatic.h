
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
@interface ObjectAnimateStatic : GObject {
    float m_fStartDelay;
    int m_iOffsetFrame;
    float m_fVelFrame;
    bool m_bDimFromTexture;

    NSMutableString *m_strStartStage;
    
    float InstFrameFloat;

    int m_iStartFrame;
    int m_iFinishFrame;


    Vector3D m_vDirect;
    float m_fVelOffset;
    float m_fMagnitude;

    Vector3D m_vStartOffsetTex;
    Vector3D m_vCurrentOffset;
    Vector3D m_vEndOffsetTex;

    Vector3D m_vStartTex;
    Vector3D m_vEndTex;
    
    bool m_bDimMirrorX;
    bool m_bDimMirrorY;
    
    NSMutableString *m_strGroup;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

/** заготовки =) **/
-(void)Destroy;
-(void)Start;
-(void)Update;

- (void)dealloc;
    
@end
