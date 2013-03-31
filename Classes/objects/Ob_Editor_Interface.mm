//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_Editor_Interface.h"
#import "StringContainer.h"
#import "ObjectButton.h"
#import "Ob_ParticleCont_ForStr.h"
#import "Ob_B_Slayder.h"
#import "Ob_Slayder.h"
#import "ObjectButton.h"
#import "Ob_EmtyPlace.h"
#import "Ob_Editor_Num.h"
#import "Ob_Selection.h"
#import "Ob_SelectionPar.h"
#import "Ob_AddNewData.h"
#import "Ob_BigWheel.h"

@implementation Ob_Editor_Interface
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];        
    
	if (self != nil)
    {
        m_iLayer = layerTemplet;
        m_iLayerTouch=layerTouch_0;//слой касания
        m_bHiden=YES;
        
        aProp = [[NSMutableArray alloc] init];
        aObjects = [[NSMutableArray alloc] init];
        aObSliders = [[NSMutableArray alloc] init];
        aObPoints = [[NSMutableArray alloc] init];
        pArrayToDel = [[NSMutableArray alloc] init];
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
//- (void)SetDefault{}
//- (void)PostSetParams{}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
//====//процессоры для объекта==========================================================================
//    Processor_ex* pProc = [self START_QUEUE:@"Proc"];
//        ASSIGN_STAGE(@"UPDATE",@"Proc:",nil);
//    [self END_QUEUE:pProc name:@"Proc"];
    
//====//различные параметры=============================================================================
   [m_pObjMng->pMegaTree SetCell:(LINK_INT_V(m_iMode,@"m_iMode"))];
    
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    [m_pObjMng->pMegaTree SetCell:(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"))];
}
//------------------------------------------------------------------------------------------------------
- (void)CreateButtons{
    
    if(m_iMode!=M_DROP_BOX){
    BDropPlus = UNFROZE_OBJECT(@"ObjectButton",@"ButtonPlus",
                    SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                    SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                    SET_STRING_V(@"ButtonPlus.png",@"m_DOWN"),
                    SET_STRING_V(@"ButtonPlus.png",@"m_UP"),
                    SET_FLOAT_V(46,@"mWidth"),
                    SET_FLOAT_V(46*FACTOR_DEC,@"mHeight"),
                    SET_BOOL_V(YES,@"m_bLookTouch"),
                    SET_INT_V(bSimple,@"m_iType"),
//                  SET_BOOL_V(YES,@"m_bBack"),
                    SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                    SET_STRING_V(@"AddNewData",@"m_strNameStage"),
                    SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                    SET_VECTOR_V(Vector3DMake(-456,180,0),@"m_pCurPosition"));
    }
    else BDropPlus=0;

    BigWheel = UNFROZE_OBJECT(@"Ob_BigWheel",@"BigWheel",nil);

    BTash=UNFROZE_OBJECT(@"ObjectButton",@"ButtonTach",
                   SET_STRING_V(@"ButtonTash.png",@"m_DOWN"),
                   SET_STRING_V(@"ButtonTash.png",@"m_UP"),
                   SET_FLOAT_V(54,@"mWidth"),
                   SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
                   SET_BOOL_V(YES,@"m_bLookTouch"),
                   SET_BOOL_V(YES,@"m_bNotPush"),
                   SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                   SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                   SET_INT_V(bSimple,@"m_iType"),
                   SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                   SET_VECTOR_V(Vector3DMake(-450,-295,0),@"m_pCurPosition"));
    
    BDropBox = UNFROZE_OBJECT(@"ObjectButton",@"ButtonDropBox",
                  SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                  SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                  SET_STRING_V(@"Button_DropBox.png",@"m_DOWN"),
                  SET_STRING_V(@"Button_DropBox.png",@"m_UP"),
                  SET_FLOAT_V(46,@"mWidth"),
                  SET_FLOAT_V(46*FACTOR_DEC,@"mHeight"),
                  SET_BOOL_V(YES,@"m_bLookTouch"),
                  SET_BOOL_V((m_iMode==M_DROP_BOX)?YES:NO,@"m_bIsPush"),
                  SET_INT_V(bRadioBox,@"m_iType"),
                  SET_BOOL_V(YES,@"m_bBack"),
                  SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                  SET_STRING_V(@"SetDropBox",@"m_strNameStage"),
                  SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                  SET_VECTOR_V(Vector3DMake(-450,295,0),@"m_pCurPosition"));
    
    BMove=UNFROZE_OBJECT(@"ObjectButton",@"ButtonMove",
                   SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                   SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                   SET_STRING_V(@"Button_Move.png",@"m_DOWN"),
                   SET_STRING_V(@"Button_Move.png",@"m_UP"),
                   SET_FLOAT_V(54,@"mWidth"),
                   SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
                   SET_BOOL_V(YES,@"m_bLookTouch"),
                   SET_BOOL_V((m_iMode==M_MOVE)?YES:NO,@"m_bIsPush"),
                   SET_INT_V(bRadioBox,@"m_iType"),
                   SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                   SET_STRING_V(@"CheckMove",@"m_strNameStage"),
                   SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                   SET_VECTOR_V(Vector3DMake(-380,295,0),@"m_pCurPosition"));
    
    BCopy=UNFROZE_OBJECT(@"ObjectButton",@"ButtonCopy",
                   SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                   SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                   SET_STRING_V(@"Button_Copy.png",@"m_DOWN"),
                   SET_STRING_V(@"Button_Copy.png",@"m_UP"),
                   SET_FLOAT_V(54,@"mWidth"),
                   SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
                   SET_BOOL_V(YES,@"m_bLookTouch"),
                   SET_BOOL_V((m_iMode==M_COPY)?YES:NO,@"m_bIsPush"),
                   SET_INT_V(bRadioBox,@"m_iType"),
                   SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                   SET_STRING_V(@"CheckCopy",@"m_strNameStage"),
                   SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                   SET_VECTOR_V(Vector3DMake(-320,295,0),@"m_pCurPosition"));
    
    BLink=UNFROZE_OBJECT(@"ObjectButton",@"ButtonLink",
                   SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                   SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                   SET_STRING_V(@"Button_Link.png",@"m_DOWN"),
                   SET_STRING_V(@"Button_Link.png",@"m_UP"),
                   SET_FLOAT_V(54,@"mWidth"),
                   SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
                   SET_BOOL_V(YES,@"m_bLookTouch"),
                   SET_BOOL_V((m_iMode==M_LINK)?YES:NO,@"m_bIsPush"),
                   SET_INT_V(bRadioBox,@"m_iType"),
                   SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                   SET_STRING_V(@"CheckLink",@"m_strNameStage"),
                   SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                   SET_VECTOR_V(Vector3DMake(-260,295,0),@"m_pCurPosition"));

    BConnect=UNFROZE_OBJECT(@"ObjectButton",@"ButtonConnect",
                     SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                     SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                     SET_STRING_V(@"ButtonConnection.png",@"m_DOWN"),
                     SET_STRING_V(@"ButtonConnection.png",@"m_UP"),
                     SET_FLOAT_V(54,@"mWidth"),
                     SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
                     SET_BOOL_V(YES,@"m_bLookTouch"),
                     SET_BOOL_V((m_iMode==M_CONNECT)?YES:NO,@"m_bIsPush"),
                     SET_INT_V(bRadioBox,@"m_iType"),
                     SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                     SET_STRING_V(@"CheckConnection",@"m_strNameStage"),
                     SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                     SET_VECTOR_V(Vector3DMake(-200,295,0),@"m_pCurPosition"));

    
}
//------------------------------------------------------------------------------------------------------
- (void)RemButtonEdit{
        
    for (int i=0; i<[pArrayToDel count]; i++) {
        GObject *pOb=[pArrayToDel objectAtIndex:i];
        DESTROY_OBJECT(pOb);
    }
    
    [pArrayToDel removeAllObjects];
    
}
//------------------------------------------------------------------------------------------------------
- (void)SetButtonEdit{
        
    if(BSetActivity!=nil){
        [pArrayToDel addObject:BSetActivity];
        BSetActivity=nil;
    }
    
    if(BSetProp!=nil){
        [pArrayToDel addObject:BSetProp];
        BSetProp=nil;
    }
    
    BSetProp=UNFROZE_OBJECT(@"ObjectButton",@"ButtonSetProp",
                            SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                            SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                            SET_STRING_V(@"ButtonTime.png",@"m_DOWN"),
                            SET_STRING_V(@"ButtonTime.png",@"m_UP"),
                            SET_FLOAT_V(54,@"mWidth"),
                            SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
                            SET_INT_V(bSimple,@"m_iType"),
                            SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                            SET_STRING_V(@"CheckSetProp",@"m_strNameStage"),
                            SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                            SET_VECTOR_V(Vector3DMake(-100,295,0),@"m_pCurPosition"));
    
    [self RemButtonEdit];
}
//------------------------------------------------------------------------------------------------------
- (void)SetButtonEnterPoint{

    if(BSetActivity!=nil){
        [pArrayToDel addObject:BSetActivity];
        BSetActivity=nil;
    }

    if(BSetProp!=nil){
        [pArrayToDel addObject:BSetProp];
        BSetProp=nil;
    }

    BSetActivity=UNFROZE_OBJECT(@"ObjectButton",@"ButtonActivity",
                            SET_INT_V(layerInterfaceSpace5,@"m_iLayer"),
                            SET_INT_V(layerTouch_0,@"m_iLayerTouch"),
                            SET_STRING_V(@"StartActivity.png",@"m_DOWN"),
                            SET_STRING_V(@"StartActivity.png",@"m_UP"),
                            SET_FLOAT_V(54,@"mWidth"),
                            SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
                            SET_INT_V(bSimple,@"m_iType"),
                            SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                            SET_STRING_V(@"SetActivFirstOperation",@"m_strNameStage"),
                            SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                            SET_VECTOR_V(Vector3DMake(-100,295,0),@"m_pCurPosition"));

    [self RemButtonEdit];
}
//------------------------------------------------------------------------------------------------------
- (void)SetActivFirstOperation
{
    MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints
                       GetMatrixAtIndex:ButtonGroup->pInsideString->m_iIndex];
    
    if(pMatr!=nil){
        
        if(pMatr->sStartPlace==ButtonGroup->m_iCurrentSelect)
            pMatr->sStartPlace=-1;
        else pMatr->sStartPlace=ButtonGroup->m_iCurrentSelect;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
    [self Load];

    pInfoFile=UNFROZE_OBJECT(@"DropBoxMng",@"DropBox",
                             SET_VECTOR_V(Vector3DMake(-240, -60, 0),@"m_pCurPosition"));
    
    //создаём ресурсы по порядку
    pResIcon=UNFROZE_OBJECT(@"Ob_ResourceMng",@"IconMng",
                            SET_INT_V(R_ICON,@"m_iTypeRes"),
                            SET_VECTOR_V(Vector3DMake(-240, -60, 0),@"m_pCurPosition"));

    pResTexture=UNFROZE_OBJECT(@"Ob_ResourceMng",@"TextureMng",
                            SET_INT_V(R_TEXTURE,@"m_iTypeRes"),
                            SET_VECTOR_V(Vector3DMake(-240, -60, 0),@"m_pCurPosition"));
//===============================режими==============================================

	[super Start];
    
//////////////////подготовка параметров
    FractalString *pStrCheck = [m_pObjMng->pStringContainer GetString:@"CurrentCheck"];
    
    if(pStrCheck!=nil){
        
        MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:pStrCheck->
                           m_iIndex];
        
        iIndexCheck=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[0];
        
         int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                       GetDataAtIndex:iIndexCheck];
        
        if(ICheck)
        {
            if(*ICheck==M_EDIT_PROP || *ICheck==M_EDIT_NUM || *ICheck==M_EDIT_EN_EX
               || *ICheck==M_CONNECT_IND || *ICheck==M_SEL_TEXTURE || *ICheck==M_ADD_NEW_DATA)*ICheck=0;
            m_iMode=(int)(*ICheck);
        }
        
        iIndexChelf=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[1];
    }
//////////////////

    UNFROZE_OBJECT(@"StaticObject",@"Back",
              //     SET_STRING_V(@"Line.png",@"m_pNameTexture"),
                   SET_COLOR_V(Color3DMake(0.2f,0.2f,0.2f,1),@"mColor"),
                   SET_FLOAT_V(480,@"mWidth"),
                   SET_FLOAT_V(640,@"mHeight"),
                   SET_VECTOR_V(Vector3DMake(-240,0,0),@"m_pCurPosition"),
                   SET_INT_V(layerBackground,@"m_iLayer"));

    UNFROZE_OBJECT(@"StaticObject",@"Sl1",
                   SET_STRING_V(@"Line.png",@"m_pNameTexture"),
                   SET_FLOAT_V(480,@"mWidth"),
                   SET_FLOAT_V(5,@"mHeight"),
                   SET_VECTOR_V(Vector3DMake(-240,202,0),@"m_pCurPosition"),
                   SET_INT_V(layerInterfaceSpace1,@"m_iLayer"));

    UNFROZE_OBJECT(@"StaticObject",@"Sl2",
                   SET_STRING_V(@"Line.png",@"m_pNameTexture"),
                   SET_FLOAT_V(640,@"mWidth"),
                   SET_FLOAT_V(5,@"mHeight"),
                   SET_VECTOR_V(Vector3DMake(0,0,0),@"m_pCurPosition"),
                   SET_VECTOR_V(Vector3DMake(0,0,90),@"m_pCurAngle"),
                   SET_INT_V(layerInterfaceSpace1,@"m_iLayer"));
//save/load
    
    ButtonGroup = UNFROZE_OBJECT(@"Ob_GroupButtons",@"GroupButtons",
                   SET_VECTOR_V(Vector3DMake(-450,-60,0),@"m_pCurPosition"),
                   SET_FLOAT_V(520,@"mHeight"));

    int *FChelf=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexChelf];
    
    Eplace = UNFROZE_OBJECT(@"Ob_GroupEmptyPlace",@"GroupPlaces",
                   SET_INT_V(*FChelf,@"m_iCurrentSelect"),
                   SET_VECTOR_V(Vector3DMake(-185,235,0),@"m_pCurPosition"));
    
//===================================================================================
    [self UpdateB];

    if([Eplace->m_pChildrenbjectsArr count]>0){

        int *FChelf=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                            GetDataAtIndex:iIndexChelf];

        Ob_EmtyPlace *pEmtyPlace=[Eplace->m_pChildrenbjectsArr objectAtIndex:*FChelf];

        pEmtyPlace->m_bPush=YES;

        pEmtyPlace->mColor.red=1;
        pEmtyPlace->mColor.green=0;
        pEmtyPlace->mColor.blue=0;

        [ButtonGroup SetString:pEmtyPlace->pStrInside];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetMode:(int)iModeTmp{

    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];
    
    OldInterfaceMode=m_iMode;
    m_iMode=iModeTmp;//move
    *ICheck=m_iMode;
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)CheckMove{
    
    OBJECT_PERFORM_SEL(NAME(BCopy),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BLink),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BDropBox),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BConnect),@"SetUnPush");
    
    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];

    m_iMode=M_MOVE;//move
    *ICheck=m_iMode;
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)CheckCopy{

    OBJECT_PERFORM_SEL(NAME(BMove),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BLink),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BDropBox),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BConnect),@"SetUnPush");
    
    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];

    m_iMode=M_COPY;//copy
    *ICheck=m_iMode;
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)CheckLink{

    OBJECT_PERFORM_SEL(NAME(BMove),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BCopy),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BDropBox),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BConnect),@"SetUnPush");
    
    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];

    m_iMode=M_LINK;//link
    *ICheck=m_iMode;
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)SetDropBox{

    OBJECT_PERFORM_SEL(NAME(BMove),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BCopy),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BLink),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BConnect),@"SetUnPush");

    OBJECT_PERFORM_SEL(@"DropBox",@"DownLoadInfoFile");
    
    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];

    m_iMode=M_DROP_BOX;//DropBox
    *ICheck=m_iMode;
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)CheckConnection{
    
    OBJECT_PERFORM_SEL(NAME(BMove),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BCopy),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BLink),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BDropBox),@"SetUnPush");
    
    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];

    m_iMode=M_CONNECT;//Connection
    *ICheck=m_iMode;
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)SelTexture{
    
    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];
    
    pResTexture->OldInterfaceMode=m_iMode;
    OldInterfaceMode=m_iMode;
    m_iMode=M_SEL_TEXTURE;//sel texture
    OldCheck=*ICheck;
    *ICheck=m_iMode;
    
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)AddNewData{
    
    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];
    
    pResTexture->OldInterfaceMode=m_iMode;
    OldInterfaceMode=m_iMode;
    m_iMode=M_ADD_NEW_DATA;//sel texture
    OldCheck=*ICheck;
    *ICheck=m_iMode;
    
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)DoubleTouchObject{
    
    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];

    pResIcon->OldInterfaceMode=m_iMode;
    OldInterfaceMode=m_iMode;
    m_iMode=M_EDIT_PROP;//prop
    OldCheck=*ICheck;
    *ICheck=m_iMode;
    
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)CheckSetProp{
    
    OBJECT_PERFORM_SEL(NAME(BMove),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BCopy),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BDropBox),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BConnect),@"SetUnPush");
    
    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];
    
    OldInterfaceMode=m_iMode;
    m_iMode=M_EDIT_EN_EX;//prop
    *ICheck=m_iMode;
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)CloseChoseIcon{
    
    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];

    *ICheck=OldCheck;
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)DownLoad{
    [m_pObjMng->pStringContainer->pDataCurManagerTmp DownLoad];
    [self Load];
}
//------------------------------------------------------------------------------------------------------
- (void)UpLoad{
    
    [self Save];
    [m_pObjMng->pStringContainer->pDataCurManagerTmp UpLoad];
}
//------------------------------------------------------------------------------------------------------
- (void)Load{

    bool bLoad = [m_pObjMng->pStringContainer LoadContainer];

    if(bLoad==NO)[m_pObjMng->pStringContainer SetEditor];
    
    OBJECT_PERFORM_SEL(@"GroupPlaces",@"ReLinkEmptyPlace");
    
    [ButtonGroup SetString:[m_pObjMng->pStringContainer GetString:@"Objects"]];
    OBJECT_PERFORM_SEL(@"GroupButtons",@"UpdateButt");
}
//------------------------------------------------------------------------------------------------------
- (void)Save{
//    [m_pObjMng->pStringContainer SaveContainer];
}
//------------------------------------------------------------------------------------------------------
- (void)SetStatusBar{
    if(PrBar==nil)
        PrBar =  CREATE_NEW_OBJECT(@"Ob_ProgressBar",@"Progress",nil);
}
//------------------------------------------------------------------------------------------------------
- (void)DelStatusBar{
    
    if(PrBar!=nil)
    {
        DESTROY_OBJECT(PrBar);
        PrBar=nil;
    }
}                 
//------------------------------------------------------------------------------------------------------
- (void)SynhDropBox{
    
    [pInfoFile Synhronization];
    pInfoFile->bNeedUpload=NO;
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)ClearInterface{
    
    [pResIcon Hide];
    [pResTexture Hide];
    [pInfoFile Hide];
    [ButtonGroup Hide];
    [Eplace Hide];

    DESTROY_OBJECT(BigWheel);
    BigWheel=nil;

    DESTROY_OBJECT(PrSyn);
    PrSyn=nil;

    DESTROY_OBJECT(BTash);
    BTash=nil;
    
    DESTROY_OBJECT(BDropBox);
    BDropBox=nil;
    
    DESTROY_OBJECT(BMove);
    BMove=nil;
    
    DESTROY_OBJECT(BCopy);
    BCopy=nil;
    
    DESTROY_OBJECT(BLink);
    BLink=nil;

    DESTROY_OBJECT(BConnect);
    BConnect=nil;

    DESTROY_OBJECT(BSetProp);
    BSetProp=nil;

    DESTROY_OBJECT(BDropPlus);
    BDropPlus=nil;
    
    DEL_CELL(@"DropBoxString");
    DEL_CELL(@"DragObject");
    DEL_CELL(@"EmptyOb");
    DEL_CELL(@"StartConnection");
 //   DEL_CELL(@"DoubleTouchFractalString");
    DEL_CELL(@"ObCheckOb");
    
    if(BSetActivity!=nil){
        [pArrayToDel addObject:BSetActivity];
        BSetActivity=nil;
    }
    
    if(BSetProp!=nil){
        [pArrayToDel addObject:BSetProp];
        BSetProp=nil;
    }

    [self RemButtonEdit];
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateB{

//    FractalString *pStrOb = [m_pObjMng->pStringContainer GetString:@"Objects"];
//    [m_pObjMng->pStringContainer LogString:pStrOb];
    
    FractalString *pStrCheck = [m_pObjMng->pStringContainer GetString:@"CurrentCheck"];
    
    MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:pStrCheck->m_iIndex];

        int *TmpICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                       GetDataAtIndex:(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[0]];

    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints GetDataAtIndex:iIndexCheck];

    ICheck=TmpICheck;
    
    if(ICheck!=0){
        [self ClearInterface];

        switch (*ICheck) {
            case M_EDIT_PROP:
                [pResIcon Show];
                break;

            case M_SEL_TEXTURE:
                [pResTexture Show];
                break;

            case M_ADD_NEW_DATA:
            {
                if(EditorAddNewData==nil)
                {
                    EditorAddNewData =  UNFROZE_OBJECT(@"Ob_AddNewData",@"EditorAddNewData",
                                            SET_FLOAT_V(54,@"mWidth"),
                                            SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
                                            SET_VECTOR_V(Vector3DMake(-250,-30,0),@"m_pCurPosition"));
                    
                    ((Ob_AddNewData *)EditorAddNewData)->OldInterfaceMode=OldInterfaceMode;
                    OBJECT_PERFORM_SEL(NAME(EditorAddNewData), @"UpdateTmp");
                }
            }
                break;
                
            case M_CONNECT_IND:
            {
                if(EditorSelectPar==nil)
                {
                    EditorSelectPar =  UNFROZE_OBJECT(@"Ob_SelectionPar",@"SelectionPar",
                                            SET_FLOAT_V(54,@"mWidth"),
                                            SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
                                            SET_VECTOR_V(Vector3DMake(-250,-30,0),@"m_pCurPosition"));

                    ((Ob_SelectionPar *)EditorSelectPar)->OldInterfaceMode=OldInterfaceMode;
                    ((Ob_SelectionPar *)EditorSelectPar)->EndHeart=EndHeart;
                    ((Ob_SelectionPar *)EditorSelectPar)->m_iIndexStart=m_iIndexStart;
                    ((Ob_SelectionPar *)EditorSelectPar)->pMatr=pMatrTmp;
                    ((Ob_SelectionPar *)EditorSelectPar)->pConnString=pConnString;

                    OBJECT_PERFORM_SEL(NAME(EditorSelectPar), @"UpdateTmp");
                }
            }
                break;
                
            case M_EDIT_NUM:
            {
                if(iIndexForNum!=0 && EditorNum==nil){
                    EditorNum =  UNFROZE_OBJECT(@"Ob_Editor_Num",@"Editor_Num",
                                                SET_INT_V(iIndexForNum,@"iIndex"));
                    ((Ob_Editor_Num *)EditorNum)->OldInterfaceMode=OldInterfaceMode;
                    OBJECT_PERFORM_SEL(NAME(EditorNum), @"UpdateNum");
                }
            }
            break;

            case M_EDIT_EN_EX:
            {
                if(EditorSelect==nil){

                    EditorSelect =  UNFROZE_OBJECT(@"Ob_Selection",@"Selection",
                                       SET_FLOAT_V(54,@"mWidth"),
                                       SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
                                       SET_VECTOR_V(Vector3DMake(-250,-30,0),@"m_pCurPosition"));
                    
                    ((Ob_Selection *)EditorSelect)->OldInterfaceMode=OldInterfaceMode;
                    ((Ob_Selection *)EditorSelect)->CurrentStr=StringSelect;
                    
                    OBJECT_PERFORM_SEL(NAME(EditorSelect), @"UpdateTmp");
                }
            }
            break;
                
            default:
            {
                [self CreateButtons];
                int *pMode=GET_INT_V(@"m_iMode");
                
                if(pMode!=0 && *pMode==M_DROP_BOX)
                {
                    if(pInfoFile->bNeedUpload==YES && pInfoFile->bDropBoxWork==NO)
                        PrSyn=UNFROZE_OBJECT(@"ObjectButton",@"ButtonSynh",
                                             SET_STRING_V(@"Button_Synh.png",@"m_DOWN"),
                                             SET_STRING_V(@"Button_Synh.png",@"m_UP"),
                                             SET_FLOAT_V(54,@"mWidth"),
                                             SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
                                             SET_BOOL_V(YES,@"m_bLookTouch"),
                                             SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                                             SET_STRING_V(@"SynhDropBox",@"m_strNameStage"),
                                             SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                                             SET_VECTOR_V(Vector3DMake(-100,295,0),@"m_pCurPosition"));
                }
                
                OBJECT_PERFORM_SEL(@"GroupPlaces", @"UpdateButt");
                
                if(((ObjectButton *)BDropBox)->m_bPush==YES){
                    
                    if(pInfoFile->bDropBoxWork==YES){
                        [self SetStatusBar];
                    }
                    else{
                        [self DelStatusBar];
                        [pInfoFile UpdateButt];
                    }
                }
                else
                {
                    [self DelStatusBar];
                    [ButtonGroup UpdateButt];
                }

            }
                break;
        }
    }
}
//----------------------------------------------------------------------------------------------------
//- (void)InitProc:(ProcStage_ex *)pStage{}
////---------------------------------------------------------------------------------------------------
//- (void)PrepareProc:(ProcStage_ex *)pStage{}
////---------------------------------------------------------------------------------------------------
//- (void)Proc:(Processor_ex *)pProc{}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
-(void) dealloc
{
    [pArrayToDel release];
    [pInfoFile release];
    [aObPoints release];
    [aObSliders release];
    [aObjects release];
    [aProp release];
    [super dealloc];
}

@end