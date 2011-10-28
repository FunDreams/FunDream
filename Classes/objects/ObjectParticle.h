
//
//  TestGameObject.h
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Object.h"

@interface Particle : NSObject {

    Vertex3D *m_pVertices;
    GLfloat *m_pTexCoords;
	GLubyte *m_pSquareColors;

    Vector3D *m_vPos;
    Vector3D *m_vScale;
    float *m_fAngle;
    
    GObject * m_pParent;
}

-(id)Init:(GObject *)pObParent;

/** Добавим частицу **/
-(void)AddToContainer:(NSString *)strNameContainer;
-(void)UpdateParticle;
-(void)RemoveFromContainer;

-(void)dealloc;

@end

/** Шаблонный класс для объектов**/
@interface ObjectParticle : GObject {
    
    //массивы для отображения данных
	Vertex3D *Templatevertices;
    GLfloat *TemplatetexCoords;
	GLubyte *TemplatesquareColors;
    
    int m_iTemplateCountVertex;

    NSMutableDictionary *m_pParticle;
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

-(void)AddParticle;

/** заготовки =) **/
-(void)Destroy;
-(void)Start;
-(void)Update;

- (void)dealloc;

@end
