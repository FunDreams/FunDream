
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
#define NAME_TEMPLETS_OBJECT ObjectField

/** Шаблонный класс для объектов**/
@interface NAME_TEMPLETS_OBJECT : GObject {
	GObject *ObAura;
	int m_iCurIndex;
    int m_iComplexity;
    int m_iCountError;
    
    int m_ArrayField[81];
    int m_ArrayField_Second[81];
    
    UInt32 iIdStoun;
    UInt32 iIdShake;
    bool m_bGhost;
    
    UInt32 iIdError;
    
    bool m_bNewRecord;
    float  m_fPhase;
    
    NSMutableArray *pArrayRow[9];
    NSMutableArray *pArrayCol[9];
    NSMutableArray *pArray9X9[9];
    NSMutableArray *pEmpty[9];
    
    NSMutableArray *pRNDplase;
    NSMutableArray *pDelEmptyPlace;
    bool m_bGame;    
}

/** Инициализирует объект **/
-(id)Init:(id)Parent WithName:(NSString *)strName;

- (void)GetParams:(CParams *)Parametrs;
- (void)SetParams:(CParams *)Parametrs;

- (void)ClearField;
- (void)setSymbolWithIndex:(int)Index;

- (void)ResolveConflict:(int)j;

/** **/
-(void)dealloc;
-(void)Start;
-(void)Move;

- (void)ResetGhost;

- (void)Validation;
- (void)Check_Finish;
- (void)CreateField;

- (void)StartNewField;
- (void)GhostYES;
- (void)GhostNO;   

- (void)LoadField;

@end
