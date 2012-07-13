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
//   [m_pObjMng->pMegaTree SetCell:(LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY"));
    
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    [m_pObjMng->pMegaTree SetCell:(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"))];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];
        
//    UNFROZE_OBJECT(@"StaticObject",@"Sl1",
//                   SET_STRING_V(@"Line.png",@"m_pNameTexture"),
//                   SET_FLOAT_V(480,@"mWidth"),
//                   SET_FLOAT_V(5,@"mHeight"),
//                   SET_VECTOR_V(Vector3DMake(-240,0,0),@"m_pCurPosition"),
//                   SET_INT_V(layerBackground,@"m_iLayer"));

    UNFROZE_OBJECT(@"StaticObject",@"Sl2",
                   SET_STRING_V(@"Line.png",@"m_pNameTexture"),
                   SET_FLOAT_V(640,@"mWidth"),
                   SET_FLOAT_V(5,@"mHeight"),
                   SET_VECTOR_V(Vector3DMake(0,0,0),@"m_pCurPosition"),
                   SET_VECTOR_V(Vector3DMake(0,0,90),@"m_pCurAngle"),
                   SET_INT_V(layerBackground,@"m_iLayer"));

//save/load
//    UNFROZE_OBJECT(@"ObjectButton",@"ButtonSaveToDropBox",
//                   SET_STRING_V(@"Button_To_box_Down.png",@"m_DOWN"),
//                   SET_STRING_V(@"Button_To_box_Up.png",@"m_UP"),
//                   SET_FLOAT_V(64,@"mWidth"),
//                   SET_FLOAT_V(64*FACTOR_DEC,@"mHeight"),
//                   SET_BOOL_V(YES,@"m_bLookTouch"),
//                   SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
//                   SET_STRING_V(@"Save",@"m_strNameStage"),
//                   SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
//                   SET_VECTOR_V(Vector3DMake(-100,-285,0),@"m_pCurPosition"));
//    
//    UNFROZE_OBJECT(@"ObjectButton",@"ButtonDownLoadDropBox",
//                   SET_STRING_V(@"Button_From_box_Down.png",@"m_DOWN"),
//                   SET_STRING_V(@"Button_From_box_Up.png",@"m_UP"),
//                   SET_FLOAT_V(64,@"mWidth"),
//                   SET_FLOAT_V(64*FACTOR_DEC,@"mHeight"),
//                   SET_BOOL_V(YES,@"m_bLookTouch"),
//                   SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
//                   SET_STRING_V(@"Load",@"m_strNameStage"),
//                   SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
//                   SET_VECTOR_V(Vector3DMake(-440,-285,0),@"m_pCurPosition"));

        UNFROZE_OBJECT(@"ObjectButton",@"ButtonCreateOb",
                       SET_STRING_V(@"ButtonCreate.png",@"m_DOWN"),
                       SET_STRING_V(@"ButtonCreate.png",@"m_UP"),
                       SET_FLOAT_V(64,@"mWidth"),
                       SET_FLOAT_V(64*FACTOR_DEC,@"mHeight"),
                       SET_BOOL_V(YES,@"m_bLookTouch"),
                       SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                       SET_STRING_V(@"CreateNewObject",@"m_strNameStage"),
                       SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                       SET_VECTOR_V(Vector3DMake(-440,280,0),@"m_pCurPosition"));
        
        UNFROZE_OBJECT(@"ObjectButton",@"ButtonTash",
                       SET_STRING_V(@"ButtonTash.png",@"m_DOWN"),
                       SET_STRING_V(@"ButtonTash.png",@"m_UP"),
                       SET_FLOAT_V(54,@"mWidth"),
                       SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
                       SET_BOOL_V(YES,@"m_bLookTouch"),
                       SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                       SET_STRING_V(@"DelObject",@"m_strNameStage"),
                       SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                       SET_VECTOR_V(Vector3DMake(-440,40,0),@"m_pCurPosition"));
        
        UNFROZE_OBJECT(@"ObjectButton",@"ArLeft",
                       SET_STRING_V(@"ButtonMinus.png",@"m_DOWN"),
                       SET_STRING_V(@"ButtonMinus.png",@"m_UP"),
                       SET_FLOAT_V(40,@"mWidth"),
                       SET_FLOAT_V(40*FACTOR_DEC,@"mHeight"),
                       SET_BOOL_V(YES,@"m_bLookTouch"),
                       SET_INT_V(0,@"m_iType"),
                       SET_STRING_V(NAME(self),@"m_strNameObject"),
                       SET_STRING_V(@"DelPoint",@"m_strNameStage"),
                       SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                       SET_VECTOR_V(Vector3DMake(-370,280,0),@"m_pCurPosition"));

    UNFROZE_OBJECT(@"ObjectButton",@"ArRight",
                   SET_STRING_V(@"ButtonPlus.png",@"m_DOWN"),
                   SET_STRING_V(@"ButtonPlus.png",@"m_UP"),
                   SET_FLOAT_V(40,@"mWidth"),
                   SET_FLOAT_V(40*FACTOR_DEC,@"mHeight"),
                   SET_BOOL_V(YES,@"m_bLookTouch"),
                   SET_INT_V(0,@"m_iType"),
                   SET_STRING_V(NAME(self),@"m_strNameObject"),
                   SET_STRING_V(@"CreateNewPoint",@"m_strNameStage"),
                   SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                   SET_VECTOR_V(Vector3DMake(-320,280,0),@"m_pCurPosition"));

    [self Update];
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
                            
                            FractalString *CurSringInProp=[CurSringTmp->aStrings objectAtIndex:j];
                            
                            //float fTmpValue=0;
                            switch (j)
                            {
                                case 0:{
                                    float X=RND_I_F(240,240);
                                    
                                    float *pX=(float *)[m_pObjMng->pStringContainer->
                                                        ArrayPoints AddData:&X];
                                    
                                    [CurSringInProp->ArrayPoints AddData:pX];
                                    Par->X=pX;
                                    
//                                    fTmpValue=RND_I_F(240,240);
//                                    
//                                    float *ppValue = (float *)[m_pObjMng->pStringContainer->
//                                                    ArrayPoints AddData:&fTmpValue];
//                                    
//                                    [CurSringInProp->ArrayPoints AddData:&ppValue];
//                                    Par->X=ppValue;
                                }
                                break;
                                    
                                case 1:{
                                    
                                    float Y=RND_I_F(0,320);
                                    
                                    float *pY=(float *)[m_pObjMng->pStringContainer->
                                                        ArrayPoints AddData:&Y];
                                    
                                    [CurSringInProp->ArrayPoints AddData:pY];
                                    Par->Y=pY;

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
                                    
                                    FractalString *CurSringInProp=[CurSringTmpProp->
                                                        aStrings objectAtIndex:j];

                                    switch (j)
                                    {
                                        case 0:{

                             //       [m_pObjMng->pStringContainer->ArrayPoints RemoveDataAtIndex:Step*2];
                                    [CurSringInProp->ArrayPoints RemoveDataAtIndex:Step];
                                            
                                        }
                                        break;
                                            
                                        case 1:{
                                            
                            //        [m_pObjMng->pStringContainer->ArrayPoints RemoveDataAtIndex:Step*2];
                                    [CurSringInProp->ArrayPoints RemoveDataAtIndex:Step];
                                            
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
                                       S:m_pObjMng->pStringContainer->fZeroPoint 
                                       F:m_pObjMng->pStringContainer->fZeroPoint];

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
- (void)Save{
    [m_pObjMng->pStringContainer SaveContainer];
}
//------------------------------------------------------------------------------------------------------
- (void)Load{
    [m_pObjMng->pStringContainer LoadContainer];
    [self Update];
}
//------------------------------------------------------------------------------------------------------
- (void)Update{

    FractalString *pFStringProp = [m_pObjMng->pStringContainer GetString:@"Prop"];
    
    if(pFStringProp!=nil){
        
        for (GObject *pOb in aProp) {
            DESTROY_OBJECT(pOb);
        }
        
        [aProp removeAllObjects];
        
        int iCount=[pFStringProp->aStrings count];
        for (int i=0; i<iCount; i++) {
            
            NSString *StrNamePropTex;
            switch (i) {
                case 0:
                    StrNamePropTex=[NSString stringWithString:@"ButtonXY.png"];
                    break;

                case 1:
                    StrNamePropTex=[NSString stringWithString:@"ButtonColor.png"];
                    break;

                case 2:
                    StrNamePropTex=[NSString stringWithString:@"ButtonTime.png"];
                    break;

                default:
                    break;
            }
            NSString *pName = [NSString stringWithFormat:@"Prop%d",i];
            GObject *pOb=UNFROZE_OBJECT(@"ObjectButton",pName,
                    SET_STRING_V(StrNamePropTex,@"m_DOWN"),
                    SET_STRING_V(StrNamePropTex,@"m_UP"),
                    SET_FLOAT_V(44,@"mWidth"),
                    SET_FLOAT_V(44*FACTOR_DEC,@"mHeight"),
                    SET_BOOL_V(YES,@"m_bLookTouch"),
                    SET_INT_V(bCheckBox,@"m_iType"),
                    //SET_STRING_V(@"World",@"m_strNameObject"),
                    //SET_STRING_V(@"StartGame",@"m_strNameStage"),
                    SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                    SET_VECTOR_V(Vector3DMake(-440,110+i*45,0),@"m_pCurPosition"));
            
            [aProp addObject:pOb];
        }
    }

    FractalString *pFStringOb = [m_pObjMng->pStringContainer GetString:@"Object"];
    
    if(pFStringOb!=nil){
        
        for (GObject *pOb in aObjects) {
            DESTROY_OBJECT(pOb);
        }
        
        [aObjects removeAllObjects];

        int iCount=[pFStringOb->aStrings count];
        for (int i=0; i<iCount; i++) {
            
            NSString *pName = [NSString stringWithFormat:@"Prop%d",i];
            GObject *pOb=UNFROZE_OBJECT(@"ObjectButton",pName,
                           SET_STRING_V(@"ButtonOb.png",@"m_DOWN"),
                           SET_STRING_V(@"ButtonOb.png",@"m_UP"),
                           SET_FLOAT_V(54,@"mWidth"),
                           SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
                           SET_BOOL_V(YES,@"m_bLookTouch"),
                           SET_INT_V(bRadioBox,@"m_iType"),
                           SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                           SET_STRING_V(@"CheckObject",@"m_strNameStage"),
                           SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                           SET_VECTOR_V(Vector3DMake(-370,210-i*55,0),@"m_pCurPosition"));

            [aObjects addObject:pOb];
        }
    }    

    [self UpdatePoints];
    [self UpdateSlider];
}
//------------------------------------------------------------------------------------------------------
- (void)UpdatePoints{
    
    for (GObject *pOb in aObPoints) {
        DESTROY_OBJECT(pOb);
    }
    [aObPoints removeAllObjects];
    
    if([aObjects count]>0){
        
        FractalString *pFStringOb = [m_pObjMng->pStringContainer GetString:@"Object"];
        float fStartPos=280;
        
        if(pFStringOb!=nil){
            int iStep=0;
            for (ObjectButton *pOb in aObjects) {
                if(pOb->m_bCheck){
                    FractalString *fStrCheck = [pFStringOb->aStrings objectAtIndex:iStep];
                    FractalString *fStrFirst = [fStrCheck->aStrings objectAtIndex:0];
                    FractalString *fStrPoints = [fStrFirst->aStrings objectAtIndex:0];
                    
                    for (int k=0; k<fStrPoints->ArrayPoints->iCountInArray; k++) {
    
                        NSString *pName = [NSString stringWithFormat:@"Prop%d",k];
                        
                        GObject *pOb=UNFROZE_OBJECT(@"ObjectButton",pName,
                            SET_STRING_V(@"ButtonPoint.png",@"m_DOWN"),
                            SET_STRING_V(@"ButtonPoint.png",@"m_UP"),
                            SET_FLOAT_V(54,@"mWidth"),
                            SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
                            SET_BOOL_V(YES,@"m_bLookTouch"),
                            SET_INT_V(bRadioBox,@"m_iType"),
                            SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                            SET_STRING_V(@"CheckPoint",@"m_strNameStage"),
                            SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                            SET_VECTOR_V(Vector3DMake(-320,210-k*55,0),@"m_pCurPosition"));
                        
                        fStartPos-=40;
                        [aObPoints addObject:pOb];
                    }
                    
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
                                    SET_VECTOR_V(Vector3DMake(-120, fStartPos, 0),@"m_pCurPosition"),
                                    SET_STRING_V(@"Back_Slayder.png",@"m_pNameTexture"));
                                
                                FractalString *fStrPropInProp = [fStrPropInOb->aStrings objectAtIndex:j];
                                
                                if(fStrPropInProp->ArrayPoints->iCountInArray>0 && IndexCheckPoint!=-1){
                                    float *fLinkTmp = (float *)[fStrPropInProp->ArrayPoints
                                                       GetDataAtIndex:IndexCheckPoint];
                                    
                                    pObSl->pOb_BSlayder->m_fLink=fLinkTmp;
                                    pObSl->pOb_BSlayder->pInsideString=fStrPropInProp;
                                }
                                else
                                {
                                    pObSl->pOb_BSlayder->pInsideString=0;
                                    pObSl->pOb_BSlayder->m_fLink=0;
                                }

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
    [aObPoints release];
    [aObSliders release];
    [aObjects release];
    [aProp release];
    [super dealloc];
}

@end