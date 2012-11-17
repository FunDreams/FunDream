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
                   //SET_INT_V(bCheckBox,@"m_iType"),
                   //SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                   //SET_STRING_V(@"Save",@"m_strNameStage"),
                   SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                   SET_VECTOR_V(Vector3DMake(-35,-295,0),@"m_pCurPosition"));
    
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
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

    [self Load];
	[super Start];
    
//////////////////подготовка параметров
    FractalString *pStrCheck = [m_pObjMng->pStringContainer GetString:@"CurrentCheck"];
    
    if(pStrCheck!=nil){
         FCheck=[m_pObjMng->pStringContainer->ArrayPoints
                       GetDataAtIndex:pStrCheck->ArrayPoints->pData[0]];
        m_iMode=(int)(*FCheck);
        
        float *FChelf=[m_pObjMng->pStringContainer->ArrayPoints
                       GetDataAtIndex:pStrCheck->ArrayPoints->pData[1]];
        m_iChelf=(int)(*FChelf);
    }
//////////////////
    
    pInfoFile=UNFROZE_OBJECT(@"DropBoxMng",@"DropBox", nil);

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

    Eplace = UNFROZE_OBJECT(@"Ob_GroupEmptyPlace",@"GroupPlaces",
                   SET_INT_V(m_iChelf,@"m_iCurrentSelect"),
                   SET_VECTOR_V(Vector3DMake(-185,235,0),@"m_pCurPosition"));
    
//===================================================================================
    //создаём ресурсы по порядку 
    pResIcon=UNFROZE_OBJECT(@"Ob_ResourceMng",@"IconMng",
                            SET_INT_V(R_ICON,@"m_iTypeRes"),
                            SET_VECTOR_V(Vector3DMake(-240, -60, 0),@"m_pCurPosition"));

//===============================режими==============================================
    [self UpdateB];

    if([Eplace->m_pChildrenbjectsArr count]>0){

        Ob_EmtyPlace *pEmtyPlace=[Eplace->m_pChildrenbjectsArr objectAtIndex:m_iChelf];

        pEmtyPlace->m_bPush=YES;

        pEmtyPlace->mColor.red=1;
        pEmtyPlace->mColor.green=0;
        pEmtyPlace->mColor.blue=0;

        [ButtonGroup SetString:pEmtyPlace->pStrInside];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)CheckMove{
    
    *FCheck=0;
    
    OBJECT_PERFORM_SEL(NAME(BCopy),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BLink),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BDropBox),@"SetUnPush");
    
    m_iMode=0;//move
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)CheckCopy{

    *FCheck=1;

    OBJECT_PERFORM_SEL(NAME(BMove),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BLink),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BDropBox),@"SetUnPush");
    
    m_iMode=1;//copy
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)CheckLink{
    
    *FCheck=2;

    OBJECT_PERFORM_SEL(NAME(BMove),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BCopy),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BDropBox),@"SetUnPush");
    
    m_iMode=2;//link
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)SetDropBox{
            
    *FCheck=3;

    OBJECT_PERFORM_SEL(NAME(BMove),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BCopy),   @"SetUnPush");
    OBJECT_PERFORM_SEL(NAME(BLink),   @"SetUnPush");

    m_iMode=3;//DropBox
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)DoubleTouchObject{
    
    OldCheck=*FCheck;
    *FCheck=4;
    
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)CloseChoseIcon{
    
    *FCheck=OldCheck;
    [self UpdateB];
}
//------------------------------------------------------------------------------------------------------
- (void)CheckObject{
    id pObTmp = GET_ID_V(@"ObCheck");

    if(pObTmp!=nil){
        for (GObject *pOb in aObjects) {
            if(pOb==pObTmp){
                continue;
            }
            else{
                OBJECT_PERFORM_SEL(pOb->m_strName, @"SetUnCheck");
           }
        }
    }

    [self UpdatePoints];
    [self UpdateSlider];
}
//------------------------------------------------------------------------------------------------------
- (void)CheckPoint{
    
    id pObTmp = GET_ID_V(@"ObCheck");
    int Index=0;
    
    if(pObTmp!=nil){
        for (ObjectButton *pOb in aObPoints) {
            if(pOb==pObTmp){
                if(pOb->m_bCheck==YES)
                    IndexCheckPoint=Index;
                else IndexCheckPoint=-1; 
                continue;
            }
            else{
                OBJECT_PERFORM_SEL(pOb->m_strName, @"SetUnCheck");
            }
            Index++;
        }
    }
    [self UpdateSlider];
}
//------------------------------------------------------------------------------------------------------
- (void)CreateNewPoint{
    FractalString *pFStringObjects = [m_pObjMng->pStringContainer GetString:@"Object"];
    
    if(pFStringObjects!=nil){
        int Step=0;

        for (ObjectButton *pOb in aObjects)
        {
            if(pOb->m_bCheck)
            {
                FractalString *CurObject=[pFStringObjects->aStrings objectAtIndex:Step];
                
                for (int i=0; i<[CurObject->aStrings count]; i++) {
                    
                    FractalString *CurSringTmp=[CurObject->aStrings objectAtIndex:i];

                    if([CurSringTmp->strName isEqual:@"XY"]){
                            
                        //Получаем объкт для создания манеьких частиц
                        Ob_ParticleCont_ForStr *pObParCont=(Ob_ParticleCont_ForStr *)
                                    [m_pObjMng GetObjectByName:@"SpriteContainer"];
//////////////////////////////////////
                        Particle_ForStr *Par=[pObParCont CreateParticle];

                        [Par SetFrame:0];
                        Par->m_iStage=0;

                        Par->m_fSize=20;
//////////////////////////////////////
                        int iCount = [CurSringTmp->aStrings count];
                        for (int j=0; j<iCount; j++){
                            
                //            FractalString *CurSringInProp=[CurSringTmp->aStrings objectAtIndex:j];
                            
                            //float fTmpValue=0;
                            switch (j)
                            {
                                case 0:{
//                                    float X=RND_I_F(240,240);
//                                    
//                                    float *pX=(float *)[m_pObjMng->pStringContainer->
//                                                        ArrayPoints AddData:&X];
//                                    
//                                    [CurSringInProp->ArrayPoints AddData:pX];
//                                    Par->X=pX;
                                }
                                break;
                                    
                                case 1:{
                                    
//                                    float Y=RND_I_F(0,320);
//                                    
//                                    float *pY=(float *)[m_pObjMng->pStringContainer->
//                                                        ArrayPoints AddData:&Y];
//                                    
//                                    [CurSringInProp->ArrayPoints AddData:pY];
//                                    Par->Y=pY;

//                                    float *Y=(float *)malloc(sizeof(float));
//                                    *Y=RND_I_F(0,320);
//                                    
//                                    [m_pObjMng->pStringContainer->ArrayPoints AddData:Y];
//                                    
//                                    [CurSringInProp->ArrayPoints AddData:&Y];
//                                    Par->Y=Y;
                                }
                                break;
                                    
                                default:
                                    break;
                            }
                        }
                        
                        [Par UpdateParticle];
                        
//                        static int Step=0;
//                        Step++;
//                        NSLog(@"%d",Step);
                    }
                }
            }
            Step++;
        }
    }
    
    [self UpdatePoints];
}
//------------------------------------------------------------------------------------------------------
- (void)DelPoint{
    
    int StepOb=0;
    int Step=0;

    FractalString *pFStringObjects = [m_pObjMng->pStringContainer GetString:@"Object"];
    
    if(pFStringObjects!=nil){
        
        for (ObjectButton *pOb in aObjects){
            if(pOb->m_bCheck){
                
                FractalString *CurObject=[pFStringObjects->aStrings objectAtIndex:StepOb];

                for (ObjectButton *pObPoint in aObPoints)
                {
                    if(pObPoint->m_bCheck){
                    for (int i=0; i<[CurObject->aStrings count]; i++) {
                        
                            FractalString *CurSringTmpProp=[CurObject->aStrings objectAtIndex:i];
                            
                            if([CurSringTmpProp->strName isEqual:@"XY"]){
                                
                                //Получаем объкт для создания манеьких частиц
                                Ob_ParticleCont_ForStr *pObParCont=(Ob_ParticleCont_ForStr *)
                                [m_pObjMng GetObjectByName:@"SpriteContainer"];
                                //////////////////////////////////////
                                Particle_ForStr *Par=[pObParCont->m_pParticleInProc objectAtIndex:Step];
                                [pObParCont RemoveParticle:Par];
                                //////////////////////////////////////
                                int iCount = [CurSringTmpProp->aStrings count];
                                for (int j=0; j<iCount; j++){
                                    
                 //                   FractalString *CurSringInProp=[CurSringTmpProp->
                 //                                       aStrings objectAtIndex:j];

                                    switch (j)
                                    {
                                        case 0:{

                             //       [m_pObjMng->pStringContainer->ArrayPoints RemoveDataAtIndex:Step*2];
                              //      [CurSringInProp->ArrayPoints RemoveDataAtIndex:Step];
                                            
                                        }
                                        break;
                                            
                                        case 1:{
                                            
                            //        [m_pObjMng->pStringContainer->ArrayPoints RemoveDataAtIndex:Step*2];
                             //       [CurSringInProp->ArrayPoints RemoveDataAtIndex:Step];
                                            
                                        }
                                        break;
                                            
                                        default:
                                            break;
                                    }
                                }
                                goto EXIT;
                            }
                            Step++;
                        }
                    }
                }
            }
            StepOb++;
        }
    }
    
EXIT:
    
    [self UpdatePoints];
}
//------------------------------------------------------------------------------------------------------
- (void)CreateNewObject{
    
    FractalString *pFStringProp = [m_pObjMng->pStringContainer GetString:@"Prop"];
    FractalString *pFStringObjects = [m_pObjMng->pStringContainer GetString:@"Object"];

    int iCheck=0;
    for (ObjectButton *pOb in aProp)
    {
        if(pOb->m_bCheck)
        {iCheck++;}
    }
    
    if(pFStringProp!=nil && pFStringObjects!=nil && [aProp count]>0 && iCheck>0){
        
        FractalString *pFStringCurObj=[[FractalString alloc]
                       initWithName:[m_pObjMng->pStringContainer GetRndName]
                       WithParent:pFStringObjects
                        WithContainer:m_pObjMng->pStringContainer
                                       S:m_pObjMng->pStringContainer->iIndexZero
                                       F:m_pObjMng->pStringContainer->iIndexZero];

        int Step=0;
        for (ObjectButton *pOb in aProp)
        {
            if(pOb->m_bCheck)
            {
                FractalString * TmpStrProp=[pFStringProp->aStrings objectAtIndex:Step];
                
                [[FractalString alloc] initAsCopy:TmpStrProp 
                    WithParent:pFStringCurObj WithContainer:m_pObjMng->pStringContainer];
            }

            Step++;
        }
    }
    [self Update];
}
//------------------------------------------------------------------------------------------------------
- (void)DelObject{
        
    FractalString *pFStringOb = [m_pObjMng->pStringContainer GetString:@"Object"];

    int i=0;
    if(pFStringOb!=nil){
        for (ObjectButton *pOb in aObjects) {

            if(pOb->m_bCheck==YES){
                DESTROY_OBJECT(pOb);
                [aObjects removeObjectAtIndex:i];
                
                FractalString *pFStrButton = [pFStringOb->aStrings objectAtIndex:i];
                [m_pObjMng->pStringContainer DelString:pFStrButton];
                break;
            }
            i++;
        }
        
        [self Update];
    }
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

    if(bLoad==NO)[m_pObjMng->pStringContainer SetTemplateString];

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
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateB{
    
    [self ClearInterface];

    if(*FCheck==4){[pResIcon Show];}
    else
    {
        [self CreateButtons];
        int *pMode=GET_INT_V(@"m_iMode");

        if(pMode!=0 && *pMode==3){

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
                       SET_VECTOR_V(Vector3DMake(-160,295,0),@"m_pCurPosition"));
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
//------------------------------------------------------------------------------------------------------
- (void)UpdatePoints{
    
    for (GObject *pOb in aObPoints) {
        DESTROY_OBJECT(pOb);
    }
    [aObPoints removeAllObjects];
    
    if([aObjects count]>0){
        
        FractalString *pFStringOb = [m_pObjMng->pStringContainer GetString:@"Object"];
   //     float fStartPos=280;
        
        if(pFStringOb!=nil){
            int iStep=0;
            for (ObjectButton *pOb in aObjects) {
                if(pOb->m_bCheck){
             //       FractalString *fStrCheck = [pFStringOb->aStrings objectAtIndex:iStep];
           //         FractalString *fStrFirst = [fStrCheck->aStrings objectAtIndex:0];
          //          FractalString *fStrPoints = [fStrFirst->aStrings objectAtIndex:0];
                    
//                    for (int k=0; k<fStrPoints->ArrayPoints->iCountInArray; k++) {
//    
//                        NSString *pName = [NSString stringWithFormat:@"Prop%d",k];
//                        
//                        GObject *pOb=UNFROZE_OBJECT(@"ObjectButton",pName,
//                            SET_STRING_V(@"ButtonPoint.png",@"m_DOWN"),
//                            SET_STRING_V(@"ButtonPoint.png",@"m_UP"),
//                            SET_FLOAT_V(54,@"mWidth"),
//                            SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
//                            SET_BOOL_V(YES,@"m_bLookTouch"),
//                            SET_INT_V(bRadioBox,@"m_iType"),
//                            SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
//                            SET_STRING_V(@"CheckPoint",@"m_strNameStage"),
//                            SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
//                            SET_VECTOR_V(Vector3DMake(-320,210-k*55,0),@"m_pCurPosition"));
//                        
//                        fStartPos-=40;
//                        [aObPoints addObject:pOb];
//                    }
                    
                    break;
                }
                iStep++;
            }
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateSlider{
    
    for (GObject *pOb in aObSliders) {
        DESTROY_OBJECT(pOb);
    }
    [aObSliders removeAllObjects];
    
    if([aObjects count]>0){
        
        FractalString *pFStringOb = [m_pObjMng->pStringContainer GetString:@"Object"];
        float fStartPos=280;

        if(pFStringOb!=nil){
            int iStep=0;
            for (ObjectButton *pOb in aObjects) {
                if(pOb->m_bCheck){
                    FractalString *fStrCheck = [pFStringOb->aStrings objectAtIndex:iStep];

                    for (int k=0; k<[fStrCheck->aStrings count]; k++) {

                        FractalString *fStrPropInOb = [fStrCheck->aStrings objectAtIndex:k];

                        if(fStrPropInOb!=nil){

                            for (int j=0; j<[fStrPropInOb->aStrings count]; j++) {
                                
                                Ob_Slayder *pObSl=UNFROZE_OBJECT(@"Ob_Slayder",@"SlayderX",
                                    SET_VECTOR_V(Vector3DMake(-140, fStartPos, 0),@"m_pCurPosition"),
                                    SET_STRING_V(@"Back_Slayder.png",@"m_pNameTexture"));
                                
                  //              FractalString *fStrPropInProp = [fStrPropInOb->aStrings objectAtIndex:j];
                                
//                                if(fStrPropInProp->ArrayPoints->iCountInArray>0 && IndexCheckPoint!=-1){
//                                    float *fLinkTmp = (float *)[fStrPropInProp->ArrayPoints
//                                                       GetDataAtIndex:IndexCheckPoint];
//                                    
//                                    pObSl->pOb_BSlayder->m_fLink=fLinkTmp;
//                                    pObSl->pOb_BSlayder->pInsideString=fStrPropInProp;
//                                    
//                                    OBJECT_PERFORM_SEL(NAME(pObSl), @"SetString");
//                                }
//                                else
//                                {
//                                    pObSl->pOb_BSlayder->pInsideString=0;
//                                    pObSl->pOb_BSlayder->m_fLink=0;
//                                }

                                OBJECT_PERFORM_SEL(NAME(pObSl->pOb_BSlayder), @"Show");

                                fStartPos-=40;
                                [aObSliders addObject:pObSl];
                            }
                        }
                        fStartPos-=40;
                    }
                    break;
                }
                iStep++;
            }
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)InitProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)PrepareProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{
    
  //  [self Update];
//    int m=0;
}
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