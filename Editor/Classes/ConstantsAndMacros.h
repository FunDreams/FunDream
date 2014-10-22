//
// Textureconstants.h
//  Texture
//
//  Created by Konstantin on 02.04.10.
//  Copyright 2010 FunDreams. All rights reserved.
//

//преобразование градусов радианы
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)

#define VERSTION 1
//доступ к имени объекта
#define NAME(OB) OB->m_strName

//Показ/скрытие объекта со сцены
#define SHOW [self ShowObject];
#define HIDE [self HideObject];

//доступ к параметрам приложения
#define PARAMS_APP m_pObjMng->m_pParent.m_pPrSettings
////////////////////////////////////////////////////////////////////////////////////////////////////////
//макрос для создания и управления объектами, создаёт новый объект
#define CREATE_NEW_OBJECT(NAMECLASS,NAMEOBJECT,...) [m_pParent.m_pObjMng CreateNewObject:NAMECLASS WithNameObject:NAMEOBJECT WithParams:[NSArray arrayWithObjects:__VA_ARGS__,nil] ];

//выбирает из списка замороженых/удалённых объектов и выставляет на сцену
#define UNFROZE_OBJECT(NAMECLASS,NAMEOBJECT,...) [m_pParent.m_pObjMng UnfrozeObject:NAMECLASS\
    WithNameObject:NAMEOBJECT WithParams:[NSArray arrayWithObjects:__VA_ARGS__,nil] ];

//устанавливает параметры для объекта
#define OBJECT_SET_PARAMS(OB_NAME,...) [m_pObjMng SetParams:[m_pObjMng GetObjectByName:OB_NAME] WithParams:[NSArray arrayWithObjects:__VA_ARGS__,nil]];

//удаление/заморозка объекта
#define DESTROY_OBJECT(OB) [m_pObjMng DestroyObject:OB];

//установка параметров для процесса
#define PROC_SET_PARAMS(PROC_NAME,STAGE_NAME,...)[[self FindProcByName:PROC_NAME]\
SetParams:STAGE_NAME WithParams:[NSArray arrayWithObjects:__VA_ARGS__,nil]];

//макрос для создания резерва объектов
#define RESERV_NEW_OBJECT(NAMECLASS,NAMEOBJECT,...) m_pParent.m_pObjMng->m_bReserv = YES;\
[m_pParent.m_pObjMng CreateNewObject:NAMECLASS WithNameObject:NAMEOBJECT WithParams:[NSArray arrayWithObjects:__VA_ARGS__,nil] ];\
m_pParent.m_pObjMng->m_bReserv = NO;

//выполнить метод для объекта по имени этого метода
#define OBJECT_PERFORM_SEL(OB_NAME,SEL_NAME) {\
GObject *TmpObject = [m_pObjMng GetObjectByName:OB_NAME];\
SEL TmpSel=NSSelectorFromString(SEL_NAME);\
if ([TmpObject respondsToSelector:TmpSel])[TmpObject performSelector:TmpSel withObject:nil];}

//воспроизведение/остановка звука
#define PLAY_SOUND(PAR) [m_pParent PlaySound: PAR];
#define STOP_SOUND(PAR) [m_pParent StopSound: PAR];
//уставнока эффектов для звуков, скорости воспроизведения и громкости
#define PITCH_SOUND(PAR,PITCH) [m_pParent SetPitchSound:PAR Pithc:PITCH];
#define VOLUME_SOUND(PAR,VOLUME) [m_pParent SetVolumeSound:PAR Volume:VOLUME];

//получить текстуру по идентификатору
#define GET_TEXTURE(INS,NAMETEXTURE) if(NAMETEXTURE!=nil){\
TextureContainer *pNum=[m_pParent->m_pTextureList objectForKey:NAMETEXTURE];\
if(pNum!=nil){INS=pNum->m_iTextureId;}}

//получить атлас текстуры по названию
#define GET_ATLAS_TEXTURE(INS,NAMEATLAS) if(NAMEATLAS!=nil){\
AtlasContainer *pNum=[m_pParent->m_pTextureAtlasList objectForKey:NAMEATLAS];\
if(pNum!=nil){INS=pNum->m_iTextureId;}}

//макрос для получения ширины и высоты для спрайта из параметров текстуры
#define GET_DIM_FROM_TEXTURE(NAMETEXTURE) TextureContainer \
*pNum=[m_pParent->m_pTextureList objectForKey:NAMETEXTURE];\
if(pNum!=nil){\
mWidth=pNum->m_fWidth;\
mHeight=pNum->m_fHeight;}

//различные случайные. Простое/случайное по интервалу (float)/случайное по интервалу (int)
#define RND arc4random()
#define RND_I_F(START,RADIUS) (float)(RND%(RADIUS*2))-RADIUS+START
#define RND_I_I(START,RADIUS) RND%(RADIUS*2)-RADIUS+START

//макрос для повторения стадии в процессе. Используется только внутри процесса
#define REPEATE [pProc SetStage:pProc->m_CurStage->NameStage];

//переопределения DWORD и дельты для удобства
#define DWORD unsigned int
#define DELTA m_fDeltaTime

//установка преобразования, для процесса (инвариант преобразования информации)
#define SET_MIRROR(pfsourceX,pfSourceF2,pfSourceF1,pfdestY,pfDestF2,pfDestF1)    \
pfdestY=(((float)pfsourceX-(float)pfSourceF1)*(((float)pfDestF1-(float)pfDestF2)/((float)pfSourceF1-(float)pfSourceF2)))+(float)pfDestF1;

//Макрос для установки Лока для касания, нужно если например нам не надо обрабатывать казания
//объектов, которые находятся ниже чем данный объект
#define LOCK_TOUCH m_pObjMng->m_pParent->m_bTouchGathe=YES;

//получения имени стадии, по имени процесса и объекта
#define GET_STAGE_EX(OB_NAME,PROC_NAME) [[[m_pObjMng GetObjectByName:OB_NAME] FindProcByName:PROC_NAME]GetNameStage];

//сохранение/загрузка данных приложения в инфолист
#define SAVE [m_pObjMng->m_pParent.m_pPrSettings Save];
#define LOAD [m_pObjMng->m_pParent.m_pPrSettings Load];

//Перейти на следующую стадию в данном процессе
#define NEXT_STAGE if(pProc!=nil)[pProc NextStage];

//Перейти на следующую стадию в процессе найденном по имени
#define NEXT_STAGE_EX(NAME_OB,NAME_PROC)[[[m_pObjMng GetObjectByName:NAME_OB] FindProcByName:NAME_PROC] NextStage];

//установить стадию для процесса с именем "Proc"
#define SET_STAGE(NAME_OB,STAGE) [[[m_pObjMng GetObjectByName:NAME_OB] FindProcByName:@"Proc"] SetStage:STAGE];

//установить стадию для процесса со специальным именем
#define SET_STAGE_EX(NAME_OB,NAME_PROC,STAGE)[[[m_pObjMng GetObjectByName:NAME_OB] FindProcByName:NAME_PROC] SetStage:STAGE];

//назначить стадию для процесса
#define ASSIGN_STAGE(NAMESTAGE,NAMESEL,...) [pProc Assign_Stage:NAMESTAGE WithSel:NAMESEL \
WithParams:[NSArray arrayWithObjects:__VA_ARGS__,nil] ];

//вставить стадию во внутрю процесса
#define INSERT_STAGE(NAMESTAGE,NAMESEL,AFTER_SEL,...) [pProc Insert_Stage:NAMESTAGE WithSel:NAMESEL \
afterStage:AFTER_SEL WithParams:[NSArray arrayWithObjects:__VA_ARGS__,nil] ];

//установить параметры для стадии
#define SET_PARAMS_STAGE(NAMESTAGE,...) [pProc SetParams:NAMESTAGE \
WithParams:[NSArray arrayWithObjects:__VA_ARGS__,nil] ];

//удалить стадию
//#define REMOVE_STAGE(NAMESTAGE) [pProc Remove_Stage:NAMESTAGE];

//макрос для сшивки строки
#define APPEND_STR     NSString *currentObject=nil;\
    NSString *RezObject=[NSString stringWithString:sKey];\
    va_list argList;\
    if (sKey)\
    {        \
        va_start(argList, sKey);\
        while ((currentObject = va_arg(argList,id))!=nil){\
        RezObject=[RezObject stringByAppendingString:currentObject];\
    }\
    va_end(argList);\
}

//беззнаковый однобайтовый тип
#define BYTE unsigned char

//установка/удаление ячейки в MegaTree
#define COPY_CELL(CELL) [m_pObjMng->pMegaTree CopyCell:CELL];
#define SET_CELL(CELL) [m_pObjMng->pMegaTree SetCell:CELL];
#define DEL_CELL(...) [m_pObjMng->pMegaTree RemoveCell:__VA_ARGS__,nil];

//линковка/копирование параметра INT в MegaTree
#define LINK_INT_V(INT_V,...) [UniCell Link_Int:(int *)&INT_V withKey:__VA_ARGS__,nil]
#define SET_INT_V(INT_V,...) [UniCell Set_Int:INT_V withKey:__VA_ARGS__,nil]

//линковка/копирование параметра FLOAT в MegaTree
#define LINK_FLOAT_V(VALUE,...) [UniCell Link_Float:(float *)&VALUE withKey:__VA_ARGS__,nil]
#define SET_FLOAT_V(VALUE,...) [UniCell Set_Float:VALUE withKey:__VA_ARGS__,nil]

//линковка/копирование параметра BOOL в MegaTree
#define LINK_BOOL_V(VALUE,...) [UniCell Link_Bool:(bool *)&VALUE withKey:__VA_ARGS__,nil]
#define SET_BOOL_V(VALUE,...) [UniCell Set_Bool:VALUE withKey:__VA_ARGS__,nil]

//линковка/копирование параметра VECTOR в MegaTree
#define LINK_VECTOR_V(VALUE,...) [UniCell Link_Vector:(Vector3D *)&VALUE withKey:__VA_ARGS__,nil]
#define SET_VECTOR_V(VALUE,...) [UniCell Set_Vector:VALUE withKey:__VA_ARGS__,nil]

//линковка/копирование параметра COLOR в MegaTree
#define LINK_COLOR_V(VALUE,...) [UniCell Link_Color:(Color3D *)&VALUE withKey:__VA_ARGS__,nil]
#define SET_COLOR_V(VALUE,...) [UniCell Set_Color:VALUE withKey:__VA_ARGS__,nil]

//линковка параметра ID в MegaTree
#define LINK_ID_V(VALUE,...) [UniCell Link_Id:&VALUE withKey:__VA_ARGS__,nil]

//линковка/копирования параметра STRING в MegaTree
#define LINK_STRING_V(VALUE,...) [UniCell Link_String:VALUE withKey:__VA_ARGS__,nil]
#define SET_STRING_V(VALUE,...) [UniCell Set_String:VALUE withKey:__VA_ARGS__,nil]

//линковка указателя в MegaTree
#define LINK_POINT_V(VALUE,...) [UniCell Link_Point:&VALUE withKey:__VA_ARGS__,nil]

//доступ к параметраи из MegaTree INT/FLOAT/BOOL
#define GET_INT_V(...) [m_pObjMng->pMegaTree GetIntValue:__VA_ARGS__,nil];
#define GET_FLOAT_V(...) [m_pObjMng->pMegaTree GetFloatValue:__VA_ARGS__,nil];
#define GET_BOOL_V(...) [m_pObjMng->pMegaTree GetBoolValue:__VA_ARGS__,nil];

//доступ к параметраи из MegaTree VECTOR/COLOR
#define GET_VECTOR_V(...) [m_pObjMng->pMegaTree GetVectorValue:__VA_ARGS__,nil];
#define GET_COLOR_V(...) [m_pObjMng->pMegaTree GetColorValue:__VA_ARGS__,nil];

//доступ к параметраи из MegaTree ID/POINT (указатель)
#define GET_ID_V(...) [m_pObjMng->pMegaTree GetIdValue:__VA_ARGS__,nil];
#define GET_POINT_V(...) [m_pObjMng->pMegaTree GetPointValue:__VA_ARGS__,nil];