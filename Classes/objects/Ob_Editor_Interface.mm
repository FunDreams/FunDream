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
    Processor_ex* pProc = [self START_QUEUE:@"Proc"];
        ASSIGN_STAGE(@"UPDATE",@"Proc:",nil);
    [self END_QUEUE:pProc name:@"Proc"];
    
//====//различные параметры=============================================================================
   [m_pObjMng->pMegaTree SetCell:(LINK_INT_V(m_iMode,@"m_iMode"))];
    
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    [m_pObjMng->pMegaTree SetCell:(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"))];
}
//------------------------------------------------------------------------------------------------------
- (void)CreateButtons{
    
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
                   //SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                   //SET_STRING_V(@"Save",@"m_strNameStage"),
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
                  SET_BOOL_V((m_iMode==3)?YES:NO,@"m_bIsPush"),
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
                   SET_BOOL_V((m_iMode==0)?YES:NO,@"m_bIsPush"),
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
                   SET_BOOL_V((m_iMode==1)?YES:NO,@"m_bIsPush"),
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
                   SET_BOOL_V((m_iMode==2)?YES:NO,@"m_bIsPush"),
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
                         SET_BOOL_V((m_iMode==5)?YES:NO,@"m_bIsPush"),
                         SET_INT_V(bRadioBox,@"m_iType"),
                         SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                         SET_STRING_V(@"CheckConnection",@"m_strNameStage"),
                         SET_STRING_V(@"chekbox1.wav", @"m_strNameSound"),
                         SET_VECTOR_V(Vector3DMake(-200,295,0),@"m_pCurPosition"));
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
//===============================режими==============================================

	[super Start];
    
//////////////////подготовка параметров
    FractalString *pStrCheck = [m_pObjMng->pStringContainer GetString:@"CurrentCheck"];
    
    if(pStrCheck!=nil){
        
        iIndexCheck=(*pStrCheck->pValueLink+SIZE_INFO_STRUCT)[0];
        
         int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                       GetDataAtIndex:iIndexCheck];
        
        if(ICheck)
        {
            if(*ICheck==4)*ICheck=0;
            m_iMode=(int)(*ICheck);
        }
        
        iIndexChelf=(*pStrCheck->pValueLink+SIZE_INFO_STRUCT)[1];
    }
//////////////////
    
    UNFROZE_OBJECT(@"StaticObject",@"Sl1",
                   SET_STRING_V(@"Line.png",@"m_pNameTexture"),
                   SET_FLOAT_V(480,@"mWidth"),
                   SET_FLOAT_V(5,@"mHeight"),
                   SET_VECTOR_V(Vector3DMake(-240,202,0),@"m_pCurPosition"),
                   SET_INT_V(layerBackground,@"m_iLayer"));

    UNFROZE_OBJECT(@"StaticObject",@"Sl2",
                   SET_STRING_V(@"Line.png",@"m_pNameTexture"),
                   SET_FLOAT_V(640,@"mWidth"),
                   SET_FLOAT_V(5,@"mHeight"),
                   SET_VECTOR_V(Vector3DMake(0,0,0),@"m_pCurPosition"),
                   SET_VECTOR_V(Vector3DMake(0,0,90),@"m_pCurAngle"),
                   SET_INT_V(layerBackground,@"m_iLayer"));
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
- (void)CheckMove{
    
    OBJECT_PERFORM_SEL(NAME(BCopy),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BLink),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BDropBox),@"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BConnect),@"SetUnPush");
    
    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];

    m_iMode=0;//move
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

    m_iMode=1;//copy
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

    m_iMode=2;//link
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

    m_iMode=3;//DropBox
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

    m_iMode=5;//Connection
    *ICheck=m_iMode;
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)DoubleTouchObject{
    
    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];

    OldCheck=*ICheck;
    *ICheck=4;
    
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
    [m_pObjMng->pStringContainer InitIndex];
    
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
    [pInfoFile Hide];
    [ButtonGroup Hide];
    [Eplace Hide];
    
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
    
    DEL_CELL(@"DropBoxString");
    DEL_CELL(@"DragObject");
    DEL_CELL(@"EmptyOb");
    DEL_CELL(@"StartConnection");
    DEL_CELL(@"DoubleTouchFractalString");
    DEL_CELL(@"ObCheckOb");
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateB{
    
    FractalString *pStrCheck = [m_pObjMng->pStringContainer GetString:@"CurrentCheck"];
            
        int *TmpICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                       GetDataAtIndex:(*pStrCheck->pValueLink+SIZE_INFO_STRUCT)[0]];

    int *ICheck=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                        GetDataAtIndex:iIndexCheck];

    ICheck=TmpICheck;
    
    if(ICheck!=0){
        [self ClearInterface];

        if(*ICheck==4)
        {
            [pResIcon Show];
        }
        else
        {
            [self CreateButtons];
            int *pMode=GET_INT_V(@"m_iMode");

            if(pMode!=0 && *pMode==3)
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
    }
}
//------------------------------------------------------------------------------------------------------
- (void)InitProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)PrepareProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
-(void) dealloc
{
    [pInfoFile release];
    [aObPoints release];
    [aObSliders release];
    [aObjects release];
    [aProp release];
    [super dealloc];
}

@end