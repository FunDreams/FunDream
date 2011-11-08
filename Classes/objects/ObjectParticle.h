
//
//  TestGameObject.h
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Object.h"

@class ObjectParticle;
@interface Particle : NSObject {
@public
    Vector3D *m_vPos;
    Vector3D *m_vScale;
    float *m_fAngle;
    
    Color3D *m_cColor;

    Color3D m_cColor1;
    Color3D m_cColor2;
    Color3D m_cColor3;
    Color3D m_cColor4;

    Vector3D m_vOffsetTex;

    Vector3D m_vTex1;
    Vector3D m_vTex2;
    Vector3D m_vTex3;
    Vector3D m_vTex4;

    GObject * m_pParent;

    int m_iCurrentOffset;
    NSString *strNameParticle;
    
    GObject* m_pParticleContainer;    
    int m_iNextFrame;
}

-(id)Init:(GObject *)pObParent;

/** Добавим частицу **/
-(void)AddToContainer:(NSString *)strNameContainer;
-(void)UpdateParticle;

-(void)UpdateParticleMatr;

-(void)UpdateParticleTex;
-(void)UpdateParticleTex4Vertex;

-(void)UpdateParticleColor;
-(void)UpdateParticleColor4Vectex;
    
-(void)RemoveFromContainer;
-(void)SetFrame:(int)iFrame;

-(void)dealloc;

@end

/** Шаблонный класс для объектов**/
@interface ObjectParticle : GObject {
@public
    NSMutableDictionary *m_pParticle;
    
    Vector3D m_vSize;
    int m_iCountX;
    int m_iCountY;
    int m_ICountFrames;
    int m_INumLoadTextures;
    
    GLuint Xstep;
    GLuint Ystep;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

-(void)AddParticle;
-(void)RemoveParticle;

-(UInt32)LoadTextureAtlas;
/** заготовки =) **/
-(void)Destroy;
-(void)Start;

- (void)dealloc;

@end
