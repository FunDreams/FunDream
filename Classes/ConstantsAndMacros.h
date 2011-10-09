//
// Textureconstants.h
//  Texture
//
//  Created by jeff on 5/23/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

// How many times a second to refresh the screen
#define kRenderingFrequency 60.0

// For setting up perspective, define near, far, and angle of view
#define kZNear			0.01
#define kZFar			1000.0
#define kFieldOfView	45.0

// Macros
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)

#define ACCEL m_pParent->m_vAccel
#define OFFSET m_pParent->m_vOffset
////////////////////////////////////////////////////////////////////////////////////////////////////////
//макрос для создания и управления объектами
#define CREATE_NEW_OBJECT(NAMECLASS,NAMEOBJECT,...) [m_pParent.m_pObjMng CreateNewObject:NAMECLASS WithNameObject:NAMEOBJECT WithParams:[NSArray arrayWithObjects:__VA_ARGS__,nil] ];

#define OBJECT_SET_PARAMS(OB_NAME,...) [m_pObjMng SetParams:[m_pObjMng GetObjectByName:OB_NAME] WithParams:[NSArray arrayWithObjects:__VA_ARGS__,nil]];

#define OBJECT_PERFORM_SEL(OB_NAME,SEL_NAME) {\
GObject *TmpObject = [m_pObjMng GetObjectByName:OB_NAME];\
SEL TmpSel=NSSelectorFromString(SEL_NAME);\
if ([TmpObject respondsToSelector:TmpSel])[TmpObject performSelector:TmpSel withObject:nil];}

//макрос для создания резерва объектов
#define RESERV_NEW_OBJECT(NAMECLASS,NAMEOBJECT,...) m_pParent.m_pObjMng->m_bReserv = YES;\
[m_pParent.m_pObjMng CreateNewObject:NAMECLASS WithNameObject:NAMEOBJECT WithParams:[NSArray arrayWithObjects:__VA_ARGS__,nil] ];\
m_pParent.m_pObjMng->m_bReserv = NO;

#define DESTROY_OBJECT(OB) [m_pObjMng DestroyObject:OB];

//sound
#define PLAY_SOUND(PAR) [m_pParent PlaySound: PAR];
#define STOP_SOUND(PAR) [m_pParent StopSound: PAR];

//прикешн текстур
#define CASH_TEXTURE(NAMETEXTURE) if(NAMETEXTURE!=nil){\
NSRange toprange = [NAMETEXTURE rangeOfString: @"."];\
NSString *SubStr = [NAMETEXTURE substringToIndex:toprange.location];\
NSString *SubStr1 = [NAMETEXTURE substringFromIndex:toprange.location+1];\
[m_pParent loadTexture:SubStr WithExt:SubStr1];}

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

#define FACTOR_INC    m_pParent->fFactorInc
#define FACTOR_DEC    m_pParent->fFactorDec
#define FACTOR_INC_INV    m_pParent->fFactorIncInv
#define FACTOR_DEC_INV    m_pParent->fFactorDecInv

#define UPDATE m_pObjMng->m_bNeedUppdate=YES;
#define INTERVAL(INST,FIRST,SECOND) (INST>FIRST && INST<SECOND)

#define PARAMS_APP m_pObjMng->m_pParent.m_pPrSettings
#define MAIN_CONTROLLER m_pObjMng->m_pParent

#define SET_MIRROR(pfsourceX,pfSourceF2,pfSourceF1,pfdestY,pfDestF2,pfDestF1)    \
pfdestY=(((float)pfsourceX-(float)pfSourceF1)*(((float)pfDestF1-(float)pfDestF2)/((float)pfSourceF1-(float)pfSourceF2)))+(float)pfDestF1;

#define LOCK_TOUCH m_pObjMng->m_pParent->m_bTouchGathe=YES;

#define NAME(OB) OB->m_strName

#define GET_STAGE_EX(OB_NAME,PROC_NAME) [[m_pObjMng GetObjectByName:OB_NAME] FindProcByName:PROC_NAME]->m_CurStage->NameStage;

#define SAVE [m_pObjMng->m_pParent.m_pPrSettings Save];
#define LOAD [m_pObjMng->m_pParent.m_pPrSettings Load];

//processor
#define NEXT_STAGE if(pProc!=nil)[pProc NextStage];

#define NEXT_STAGE_EX(NAME_OB,NAME_PROC)[[[m_pObjMng GetObjectByName:NAME_OB] FindProcByName:NAME_PROC] NextStage];

#define SET_STAGE(NAME_OB,STAGE) [[[m_pObjMng GetObjectByName:NAME_OB] FindProcByName:@"Proc"] SetStage:STAGE];
#define SET_STAGE_EX(NAME_OB,NAME_PROC,STAGE)[[[m_pObjMng GetObjectByName:NAME_OB] FindProcByName:NAME_PROC] SetStage:STAGE];

#define START_QUEUE(NAME) {Processor_ex* pProc= [m_pProcessor_ex objectForKey:NAME]; \
if(pProc==nil){pProc=[[Processor_ex alloc] InitWithName:NAME WithParent:self];};

#define END_QUEUE(NAME)[m_pProcessor_ex setObject_Ex:pProc forKey:NAME];\
if(pProc->m_FirstStage!=nil){[pProc SetStage:pProc->m_FirstStage->NameStage];}}

#define ASSIGN_STAGE(NAMESTAGE,NAMESEL,...) [pProc Assign_Stage:NAMESTAGE WithSel:NAMESEL \
WithParams:[NSArray arrayWithObjects:__VA_ARGS__,nil] ];

#define INSERT_STAGE(NAMESTAGE,NAMESEL,AFTER_SEL,...) [pProc Insert_Stage:NAMESTAGE WithSel:NAMESEL \
afterStage:AFTER_SEL WithParams:[NSArray arrayWithObjects:__VA_ARGS__,nil] ];

#define PARAMS_STAGE(NAMESTAGE,...) [pProc SetParams:NAMESTAGE \
WithParams:[NSArray arrayWithObjects:__VA_ARGS__,nil] ];

#define DELAY_STAGE(NAMESTAGE,TIME,RND_TIME) [pProc Delay_Stage:NAMESTAGE Time:TIME TimeRnd:RND_TIME];

#define REMOVE_STAGE(NAMESTAGE) [pProc Remove_Stage:NAMESTAGE];


#define COPY_CELL(CELL) [m_pObjMng->pMegaTree CopyCell:CELL];
#define SET_CELL(CELL) [m_pObjMng->pMegaTree SetCell:CELL];

#define LINK_INT_V(INT_V,...) [[UniCell alloc] Link_Int:(int *)&INT_V withKey:__VA_ARGS__,nil]
#define SET_INT_V(INT_V,...) [[UniCell alloc] Set_Int:INT_V withKey:__VA_ARGS__,nil]

#define LINK_FLOAT_V(VALUE,...) [[UniCell alloc] Link_Float:(float *)&VALUE withKey:__VA_ARGS__,nil]
#define SET_FLOAT_V(VALUE,...) [[UniCell alloc] Set_Float:VALUE withKey:__VA_ARGS__,nil]

#define LINK_BOOL_V(VALUE,...) [[UniCell alloc] Link_Bool:(bool *)&VALUE withKey:__VA_ARGS__,nil]
#define SET_BOOL_V(VALUE,...) [[UniCell alloc] Set_Bool:VALUE withKey:__VA_ARGS__,nil]

#define LINK_VECTOR_V(VALUE,...) [[UniCell alloc] Link_Vector:(Vector3D *)&VALUE withKey:__VA_ARGS__,nil]
#define SET_VECTOR_V(VALUE,...) [[UniCell alloc] Set_Vector:VALUE withKey:__VA_ARGS__,nil]

#define LINK_COLOR_V(VALUE,...) [[UniCell alloc] Link_Color:(Color3D *)&VALUE withKey:__VA_ARGS__,nil]
#define SET_COLOR_V(VALUE,...) [[UniCell alloc] Set_Color:VALUE withKey:__VA_ARGS__,nil]

#define LINK_ID_V(VALUE,...) [[UniCell alloc] Link_Id:&VALUE withKey:__VA_ARGS__,nil]
#define LINK_STRING_V(VALUE,...) [[UniCell alloc] Link_String:VALUE withKey:__VA_ARGS__,nil]
#define SET_STRING_V(VALUE,...) [[UniCell alloc] Set_String:VALUE withKey:__VA_ARGS__,nil]

#define LINK_POINT_V(VALUE,...) [[UniCell alloc] Link_Point:&VALUE withKey:__VA_ARGS__,nil]


#define GET_INT_V(...) [m_pObjMng->pMegaTree GetIntValue:__VA_ARGS__,nil];
#define GET_FLOAT_V(...) [m_pObjMng->pMegaTree GetFloatValue:__VA_ARGS__,nil];
#define GET_BOOL_V(...) [m_pObjMng->pMegaTree GetBoolValue:__VA_ARGS__,nil];

#define GET_VECTOR_V(...) [m_pObjMng->pMegaTree GetVectorValue:__VA_ARGS__,nil];
#define GET_COLOR_V(...) [m_pObjMng->pMegaTree GetColorValue:__VA_ARGS__,nil];

#define GET_ID_V(...) [m_pObjMng->pMegaTree GetIdValue:__VA_ARGS__,nil];
#define GET_POINT_V(...) [m_pObjMng->pMegaTree GetPointValue:__VA_ARGS__,nil];