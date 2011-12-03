//
//  Object.h
//  Engine
//
//  Created by Konstantin on 02.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Processor_ex.h"
#import "Dictionary_Ex.h"

/* точка */
typedef struct {float x, y;}point2d;
/* прямоугольник */
typedef struct{float x_min, y_min, x_max, y_max;}rect2d;

@class CObjectManager;

//класс родитель для обектов приложения, каждый объект должен наследоваться от него.
@interface GObject : NSObject {
@public

    //временные цвета
    Color3D Start_Color,End_Color,Current_Color;

    //временные вектора
    Vector3D Start_Vector,End_Vector,Current_Vector;

	//различные скорости
    float m_fStart,m_fFinish,m_fCurrent;
	float m_fVelMove,m_fVelFade,m_fPhase,m_fVelPhase,m_fVelRotate;

	//стартовая позиция и финифная
	Vector3D m_vStartPos,m_vEndPos;
	float m_fStartAngle,m_fEndAngle;
    float m_fCurPosSlader,m_fCurPosSlader2;
    float m_fStartScale,m_fEndScale;

	//селектор для отрисовки
	SEL m_sDraw;
	
	//без смещения
	bool m_bNoOffset;
    float m_fScaleOffset;
    
	//флаг удаления
	bool m_bDeleted;

	//флаг взаимодействия
	bool m_bTouch;
	
	//глубина иерархии
	int m_iDeep;

	//текущий слой отрисовки
	int m_iLayer;
	//текущий слой для обработки сообщений
	int m_iLayerTouch;
	
	//менеджер обхъектов
	CObjectManager* m_pObjMng;
	
	//родитель-уровень для данного класса
	MainController* m_pParent;
	
	//текущая позиция, масштаб и угол поворота
	Vector3D m_pCurPosition;
	Vector3D m_pCurScale;
	Vector3D m_pCurAngle;

	//смещение позиции, масштаба и угола поворота (для иерархии)
	Vector3D m_pOffsetCurPosition;
	Vector3D m_pOffsetCurScale;
	Vector3D m_pOffsetCurAngle;

	//смещение точки отчёта для сетки.
	Vector3D m_pOffsetVert;
	
	//текущая точка прикосновения объекта
	Vector3D m_pCurrentTouch;

	//имя объекта
	NSMutableString *m_strName;

	//имена групп
	Dictionary_Ex *m_Groups;

	//флаг. указвает что на объект не действует глобальная пауза
	bool m_bNonStop;
	
	//флаг отображения объекта.
	bool m_bHiden;
	
	//объект хозяин.
	GObject *m_pOwner;

	//массивы дочерних объектов
	NSMutableDictionary* m_pChildrenbjectsDic;
	NSMutableArray* m_pChildrenbjectsArr;

	//массивы для отображения данных
	Vertex3D *vertices;
    GLfloat *texCoords;
	GLubyte *squareColors;
	
	//идентификатор текстур
	UInt32 mTextureId;
	UInt32 m_iCountVertex;
	
	//цвет объекта
	Color3D mColor;
	
	//ширина и высота спрайта
	float mWidth;
	float mHeight;
    
    //радиус взаимодействия
    float mRadius;

	//текущий идентификатор для звука
	UInt32 iIdSound;
	
	//список изображений	
	NSMutableArray *m_pArrayImages;	

    //процессоры для объекта
	Dictionary_Ex* m_pProcessor_ex;

	//имя текстуры
	NSMutableString *m_pNameTexture;
}

//desc: инициализация объекта
//par: имя объекта
- (id)Init:(id)Parent WithName:(NSString *)strName;

//нахождение процесса по имени
- (Processor_ex *)FindProcByName:(NSString *)Name;

//функция старта объекта
- (void)Start;

//desc: функция самообработки для объекта.
//par: промежуток времени.
- (void)Update;

//функция установки цвета
- (void)SetColor:(Color3D)color;

//установить сдвиг по текстуре
- (void)SetOffsetTexture:(Vector3D)vOffset;

//установить масштаб текстуры
- (void)SetScaleTexture:(Vector3D)vStartScale SecondVector:(Vector3D)vEndScale;

//установление функции отрисовки
- (void)SetDrawSelector:(NSString *)pNameSel;

//функция самоотрисовки
- (void)SelfDraw;

//функция самоотрисовки со смещинием
- (void)SelfDrawOffset;

//функция установки взаимодействия объекта
- (void)SetTouch:(bool)bTouch;

//удаление из словаря взаимодействий
- (void)RomoveFromTouch;

//деструктор
- (void)dealloc;

//функции для обработки касаний
- (bool)Intersect:(CGPoint)Point;
- (bool)IntersectSphereWithOb:(GObject *)pOb;

- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point;
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point;
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point;
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)pPoint;
- (void)touchesBeganOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point;
- (void)touchesEndedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point;

-(int)cohen_sutherland:(rect2d *)r PointA:(point2d *)a PointB:(point2d*)b;
- (void)SetPosWithOffsetOwner;

- (void)AddToDraw;
- (void)DeleteFromDraw;
- (void)SetLayer:(int)iLayer;
- (void)SetLayerAndChild:(int)iLayer;
- (void)SelfOffsetVert:(Vertex3D)VOffset;
- (void)LinkValues;
- (void)Destroy;
//processors--------------------------------------------------------------------------------------------
- (void)timerWaitNextStage:(Processor_ex *)pProc;

- (void)InitAchiveLineFloat:(ProcStage_ex *)pStage;//изменение float значения с параметнами
- (void)AchiveLineFloat:(Processor_ex *)pProc;

- (void)InitAnimate:(ProcStage_ex *)pStage;//линейная анимация (до фиксированого кадра)
- (void)Animate:(Processor_ex *)pProc;

- (void)InitAnimateLoop:(ProcStage_ex *)pStage;//замкнутая анимация
- (void)AnimateLoop:(Processor_ex *)pProc;

- (void)InitOffsetTexLoop:(ProcStage_ex *)pStage;//замкнутая анимация сдвига текстуры
- (void)OffsetTexLoop:(Processor_ex *)pProc;

- (void)InitMirror2Dvector:(ProcStage_ex *)pStage;//отражение вектора (2д)/числа
- (void)Mirror2Dvector:(Processor_ex *)pProc;

- (void)InitParabola1:(ProcStage_ex *)pStage;//Преобразование по кривой параболы
- (void)Parabola1:(Processor_ex *)pProc;

- (void)InitAchive1Dvector:(ProcStage_ex *)pStage;//изменение float как вектора.
- (void)Achive1Dvector:(Processor_ex *)pProc;

    
- (void)Idle:(Processor_ex *)pProc;

- (void)DestroySelfUpdate:(Processor_ex *)pProc;
- (void)DestroySelf:(Processor_ex *)pProc;
- (void)UpdateScreen:(Processor_ex *)pProc;
- (void)HideSelf:(Processor_ex *)pProc;
- (void)ShowSelf:(Processor_ex *)pProc;
- (void)TouchYes:(Processor_ex *)pProc;
- (void)TouchNo:(Processor_ex *)pProc;

- (void)SelfTimer:(Processor_ex *)pProc;
//utils------------------------------------------------------------------------------------------------
- (void)ParseTime:(float)fTime OutSec:(int *)fSec OutMin:(int *)fMin OutHour:(int *)fHour;
- (NSMutableArray *)ParseIntValue:(int)iValue;

@end
