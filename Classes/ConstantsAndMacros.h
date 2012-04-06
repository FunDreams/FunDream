//
// Textureconstants.h
//  Texture
//
//  Created by jeff on 5/23/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

// How many times a second to refresh the screen
//#define kRenderingFrequency 60.0

// For setting up perspective, define near, far, and angle of view
//#define kZNear			0.01
//#define kZFar			1000.0
//#define kFieldOfView	45.0

// Macros
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)

#define NAME(OB) OB->m_strName
#define SHOW [self ShowObject];
#define HIDE [self HideObject];
#define PARAMS_APP m_pObjMng->m_pParent.m_pPrSettings
////////////////////////////////////////////////////////////////////////////////////////////////////////
//макрос для создания и управления объектами
#define CREATE_NEW_OBJECT(NAMECLASS,NAMEOBJECT,...) [m_pParent.m_pObjMng CreateNewObject:NAMECLASS WithNameObject:NAMEOBJECT WithParams:[NSArray arrayWithObjects:__VA_ARGS__,nil] ];

#define UNFROZE_OBJECT(NAMECLASS,...) [m_pParent.m_pObjMng UnfrozeObject:NAMECLASS WithParams:[NSArray arrayWithObjects:__VA_ARGS__,nil] ];

#define OBJECT_SET_PARAMS(OB_NAME,...) [m_pObjMng SetParams:[m_pObjMng GetObjectByName:OB_NAME] WithParams:[NSArray arrayWithObjects:__VA_ARGS__,nil]];

#define DESTROY_OBJECT(OB) [m_pObjMng DestroyObject:OB];

#define PROC_SET_PARAMS(PROC_NAME,STAGE_NAME,...)[[self FindProcByName:PROC_NAME]\
SetParams:STAGE_NAME WithParams:[NSArray arrayWithObjects:__VA_ARGS__,nil]];

//макрос для создания резерва объектов
#define RESERV_NEW_OBJECT(NAMECLASS,NAMEOBJECT,...) m_pParent.m_pObjMng->m_bReserv = YES;\
[m_pParent.m_pObjMng CreateNewObject:NAMECLASS WithNameObject:NAMEOBJECT WithParams:[NSArray arrayWithObjects:__VA_ARGS__,nil] ];\
m_pParent.m_pObjMng->m_bReserv = NO;

#define OBJECT_PERFORM_SEL(OB_NAME,SEL_NAME) {\
GObject *TmpObject = [m_pObjMng GetObjectByName:OB_NAME];\
SEL TmpSel=NSSelectorFromString(SEL_NAME);\
if ([TmpObject respondsToSelector:TmpSel])[TmpObject performSelector:TmpSel withObject:nil];}

//sound
#define PLAY_SOUND(PAR) [m_pParent PlaySound: PAR];
#define STOP_SOUND(PAR) [m_pParent StopSound: PAR];

//texture
#define GET_TEXTURE(INS,NAMETEXTURE) if(NAMETEXTURE!=nil){\
TextureContainer *pNum=[m_pParent->m_pTextureList objectForKey:NAMETEXTURE];\
if(pNum!=nil){INS=pNum->m_iTextureId;}}

#define GET_DIM_FROM_TEXTURE(NAMETEXTURE) TextureContainer \
*pNum=[m_pParent->m_pTextureList objectForKey:NAMETEXTURE];\
if(pNum!=nil){\
mWidth=pNum->m_fWidth;\
mHeight=pNum->m_fHeight;}

#define RND arc4random()

#define REPEATE [pProc SetStage:pProc->m_CurStage->NameStage];

#define DWORD unsigned int
#define DELTA m_fDeltaTime

#define VIEWPORT_W 640
#define VIEWPORT_H 960

#define FACTOR_SCALE 1.11f

#define SET_MIRROR(pfsourceX,pfSourceF2,pfSourceF1,pfdestY,pfDestF2,pfDestF1)    \
pfdestY=(((float)pfsourceX-(float)pfSourceF1)*(((float)pfDestF1-(float)pfDestF2)/((float)pfSourceF1-(float)pfSourceF2)))+(float)pfDestF1;

#define LOCK_TOUCH m_pObjMng->m_pParent->m_bTouchGathe=YES;

#define GET_STAGE_EX(OB_NAME,PROC_NAME) [[[m_pObjMng GetObjectByName:OB_NAME] FindProcByName:PROC_NAME]GetNameStage];

#define SAVE [m_pObjMng->m_pParent.m_pPrSettings Save];
#define LOAD [m_pObjMng->m_pParent.m_pPrSettings Load];

//processor
#define NEXT_STAGE if(pProc!=nil)[pProc NextStage];

#define NEXT_STAGE_EX(NAME_OB,NAME_PROC)[[[m_pObjMng GetObjectByName:NAME_OB] FindProcByName:NAME_PROC] NextStage];

#define SET_STAGE(NAME_OB,STAGE) [[[m_pObjMng GetObjectByName:NAME_OB] FindProcByName:@"Proc"] SetStage:STAGE];
#define SET_STAGE_EX(NAME_OB,NAME_PROC,STAGE)[[[m_pObjMng GetObjectByName:NAME_OB] FindProcByName:NAME_PROC] SetStage:STAGE];

#define ASSIGN_STAGE(NAMESTAGE,NAMESEL,...) [pProc Assign_Stage:NAMESTAGE WithSel:NAMESEL \
WithParams:[NSArray arrayWithObjects:__VA_ARGS__,nil] ];

#define INSERT_STAGE(NAMESTAGE,NAMESEL,AFTER_SEL,...) [pProc Insert_Stage:NAMESTAGE WithSel:NAMESEL \
afterStage:AFTER_SEL WithParams:[NSArray arrayWithObjects:__VA_ARGS__,nil] ];

#define PARAMS_STAGE(NAMESTAGE,...) [pProc SetParams:NAMESTAGE \
WithParams:[NSArray arrayWithObjects:__VA_ARGS__,nil] ];

//#define REMOVE_STAGE(NAMESTAGE) [pProc Remove_Stage:NAMESTAGE];

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

//#define SET_CELL(CELL) [m_pObjMng->pMegaTree SetCell:CELL];
//#define DEL_CELL(...) [m_pObjMng->pMegaTree RemoveCell:__VA_ARGS__,nil];

#define LINK_INT_V(INT_V,...) [UniCell Link_Int:(int *)&INT_V withKey:__VA_ARGS__,nil]
#define SET_INT_V(INT_V,...) [UniCell Set_Int:INT_V withKey:__VA_ARGS__,nil]

#define LINK_FLOAT_V(VALUE,...) [UniCell Link_Float:(float *)&VALUE withKey:__VA_ARGS__,nil]
#define SET_FLOAT_V(VALUE,...) [UniCell Set_Float:VALUE withKey:__VA_ARGS__,nil]

#define LINK_BOOL_V(VALUE,...) [UniCell Link_Bool:(bool *)&VALUE withKey:__VA_ARGS__,nil]
#define SET_BOOL_V(VALUE,...) [UniCell Set_Bool:VALUE withKey:__VA_ARGS__,nil]

#define LINK_VECTOR_V(VALUE,...) [UniCell Link_Vector:(Vector3D *)&VALUE withKey:__VA_ARGS__,nil]
#define SET_VECTOR_V(VALUE,...) [UniCell Set_Vector:VALUE withKey:__VA_ARGS__,nil]

#define LINK_COLOR_V(VALUE,...) [UniCell Link_Color:(Color3D *)&VALUE withKey:__VA_ARGS__,nil]
#define SET_COLOR_V(VALUE,...) [UniCell Set_Color:VALUE withKey:__VA_ARGS__,nil]

#define LINK_ID_V(VALUE,...) [UniCell Link_Id:&VALUE withKey:__VA_ARGS__,nil]
#define LINK_STRING_V(VALUE,...) [UniCell Link_String:VALUE withKey:__VA_ARGS__,nil]
#define SET_STRING_V(VALUE,...) [UniCell Set_String:VALUE withKey:__VA_ARGS__,nil]

#define LINK_POINT_V(VALUE,...) [UniCell Link_Point:&VALUE withKey:__VA_ARGS__,nil]


#define GET_INT_V(...) [m_pObjMng->pMegaTree GetIntValue:__VA_ARGS__,nil];
#define GET_FLOAT_V(...) [m_pObjMng->pMegaTree GetFloatValue:__VA_ARGS__,nil];
#define GET_BOOL_V(...) [m_pObjMng->pMegaTree GetBoolValue:__VA_ARGS__,nil];

#define GET_VECTOR_V(...) [m_pObjMng->pMegaTree GetVectorValue:__VA_ARGS__,nil];
#define GET_COLOR_V(...) [m_pObjMng->pMegaTree GetColorValue:__VA_ARGS__,nil];

#define GET_ID_V(...) [m_pObjMng->pMegaTree GetIdValue:__VA_ARGS__,nil];
#define GET_POINT_V(...) [m_pObjMng->pMegaTree GetPointValue:__VA_ARGS__,nil];