//
//  ObjectManager.h
//  Engine
//
//  Created by svp on 17.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Object.h"
#import "GameLogicObject.h"
#import "GLView.h"

@class CPhysics;
@class Mega_tree;

typedef enum tagLayerID {
	layerOpenGL = 0,
    layerSystem,
    layerNotShow,
	layerBackground,	
	layerInterfaceSpace1,	
	layerInterfaceSpace2,
	
	layerOb1,
	layerOb2,
	layerOb3,

	layerNumber,	
	
	layerTouch_0,	
	
	layerInterfaceSpace3,	
	layerInterfaceSpace4,
	
	layerScoreTimer,
	
	layerInvisible,
	
    layerOb4,
	layerOb5,
	layerOb6,

	layerInterfaceSpace5,
	layerInterfaceSpace6,
	layerInterfaceSpace7,

	layerTemplet,
} EGP_LayerID;

/** Класс который управляет другими объектами в зависимости от их состояния**/
@interface CObjectManager : NSObject {
@public

    //угол вращения картинки
    float fCurrentAngleRotateOffset,fAngleRotateOffset;

    //время для апдейта
    float fTimeOneSecondUpdate;
    
	//флаг для апдейта массива отрисовки
	bool m_bNeedUppdate;
	//глобальная пауза
	bool m_bGlobalPause;		
	//родитель-уровень для данного класса
	MainController* m_pParent;

	/**Объект управляющий логикой программы**/
	CGameLogic* m_pAIObj;
	
	//объект считающий физику
	CPhysics* m_pPhysics;

	//динамический массив объектов(здесь будут содержаться все объекты приложения
	//игровый объектры, объекты хранения информации, triggers, actions, events, объекты управления, синхронизации
	//и т.д. другими словами все объекты приложения. Которые будут ответственны за весь процесс)	
	NSMutableArray* m_pObjectList;

	//словарь сгрупированых объектов
	NSMutableDictionary* m_pGroups;

	//словарь для всех объектов
	NSMutableDictionary* m_pAllObjects;

	//список объектов которые учавствуют в касаниях
	NSMutableArray* m_pObjectTouches;
	
	//список объектов которые учавствуют в касаниях
	NSMutableDictionary* m_pObjectAddToTouch;

	//список объектов которые учавствуют в касаниях
	NSMutableDictionary* m_pObjectReserv;

	//параметр для прикешена
	bool m_bReserv;

	//объекты которые должны быть удалены
	NSMutableArray *pMustDelKeys;
	NSMutableArray *pMusAddKeys;

	//слои
	NSMutableArray *pLayers;
	
	//слои
	NSMutableArray *pDrawArray;

    //Mega tree
    Mega_tree *pMegaTree;
    
	float m_fDeltaTime;
}

@property(nonatomic, retain) NSMutableArray *m_pObjectList;
@property(nonatomic) bool m_bReserv;

/** Инициализирует объект**/
- (id)Init:(id)Parent;
/** **/
- (void)dealloc;

/**  обработка **/
- (void)SelfMovePaused:(id)pDeltaTime;
- (void)SelfMoveNormal:(id)pDeltaTime;

//функция коррекции имени объекта.
- (NSString *)GetNameObject:(NSString*) NameObject;

//функции управления объектами (создание/изменение/доступа параметров)
- (id)CreateNewObject:(NSString *)NameClass WithNameObject:(NSString *)NameObject WithParams:(NSArray *)Parametrs;
- (void)SetParams:(GObject *)pTmpOb WithParams:(NSArray *)Parametrs;
- (GObject *)GetFreeObjectByClass:(NSString*)NameClass;
- (GObject *)GetObjectByName:(NSString*)NameObject;
- (NSString *)GetNameObject:(NSString*)NameObject;

- (void)Update;
- (id)DestroyObject:(GObject *)pObject;

- (void)AddToGroup:(NSString*)NameGroup Object:(GObject *)pObject;
- (void)RemoveFromGroup:(NSString*)NameGroup Object:(GObject *)pObject;
- (void)RemoveFromGroups:(Dictionary_Ex *)NamesGroup Object:(GObject *)pObject;
- (NSMutableArray *)GetGroup:(NSString*)NameGroup;
	

/** создаёт объекты игры**/
- (void)CreateObjects;
//прикешн объектов
- (void)UpdateObjects;
//отрисовка
- (void)drawView:(GLView*)view;


@end
