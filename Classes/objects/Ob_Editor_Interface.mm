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
    
    
    UNFROZE_OBJECT(@"StaticObject",@"Sl1",
                   SET_STRING_V(@"Line.png",@"m_pNameTexture"),
                   SET_FLOAT_V(480,@"mWidth"),
                   SET_FLOAT_V(5,@"mHeight"),
                   SET_VECTOR_V(Vector3DMake(-240,0,0),@"m_pCurPosition"),
                   SET_INT_V(layerBackground,@"m_iLayer"));

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
                       SET_STRING_V(@"ButtonCreate.png",@"m_DOWN"),
                       SET_STRING_V(@"ButtonCreate.png",@"m_UP"),
                       SET_FLOAT_V(54,@"mWidth"),
                       SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
                       SET_BOOL_V(YES,@"m_bLookTouch"),
                       SET_STRING_V(@"Ob_Editor_Interface",@"m_strNameObject"),
                       SET_STRING_V(@"DelObject",@"m_strNameStage"),
                       SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                       SET_VECTOR_V(Vector3DMake(-440,40,0),@"m_pCurPosition"));
        
        UNFROZE_OBJECT(@"ObjectButton",@"EmptyOb",
                       //                   SET_STRING_V(@"ButtonCreate.png",@"m_DOWN"),
                       //                   SET_STRING_V(@"ButtonCreate.png",@"m_UP"),
                       SET_FLOAT_V(40,@"mWidth"),
                       SET_FLOAT_V(40*FACTOR_DEC,@"mHeight"),
                       SET_BOOL_V(YES,@"m_bLookTouch"),
                       SET_INT_V(0,@"m_iType"),
                       //            SET_STRING_V(@"World",@"m_strNameObject"),
                       //          SET_STRING_V(@"StartGame",@"m_strNameStage"),
                       SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                       SET_VECTOR_V(Vector3DMake(-370,280,0),@"m_pCurPosition"));

    UNFROZE_OBJECT(@"ObjectButton",@"EmptyOb",
                   //                   SET_STRING_V(@"ButtonCreate.png",@"m_DOWN"),
                   //                   SET_STRING_V(@"ButtonCreate.png",@"m_UP"),
                   SET_FLOAT_V(40,@"mWidth"),
                   SET_FLOAT_V(40*FACTOR_DEC,@"mHeight"),
                   SET_BOOL_V(YES,@"m_bLookTouch"),
                   SET_INT_V(0,@"m_iType"),
                   //            SET_STRING_V(@"World",@"m_strNameObject"),
                   //          SET_STRING_V(@"StartGame",@"m_strNameStage"),
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
    [self UpdateSlider];
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
                       WithContainer:m_pObjMng->pStringContainer];

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
            
            NSString *pName = [NSString stringWithFormat:@"Prop%d",i];
            GObject *pOb=UNFROZE_OBJECT(@"ObjectButton",pName,
                    //SET_STRING_V(@"ButtonCreate.png",@"m_DOWN"),
                    //SET_STRING_V(@"ButtonCreate.png",@"m_UP"),
                    SET_FLOAT_V(34,@"mWidth"),
                    SET_FLOAT_V(34*FACTOR_DEC,@"mHeight"),
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
                           SET_STRING_V(@"ButtonCreate.png",@"m_DOWN"),
                           SET_STRING_V(@"ButtonCreate.png",@"m_UP"),
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
    
    [self UpdateSlider];
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateSlider{
    
    for (GObject *pOb in aObSliders) {
        DESTROY_OBJECT(pOb);
    }

    if([aObjects count]>0){
        
        FractalString *pFStringOb = [m_pObjMng->pStringContainer GetString:@"Object"];
        float fStartPos=300;

        if(pFStringOb!=nil){
            int iStep=0;
            for (ObjectButton *pOb in aObjects) {
                if(pOb->m_bCheck){
                    FractalString *fStrCheck = [pFStringOb->aStrings objectAtIndex:iStep];

                    for (int k=0; k<[fStrCheck->aStrings count]; k++) {

                        FractalString *fStrPropInOb = [fStrCheck->aStrings objectAtIndex:k];

                        if(fStrPropInOb!=nil){

                            for (int j=0; j<[fStrPropInOb->aStrings count]; j++) {
                                GObject *pOb=UNFROZE_OBJECT(@"Ob_Slayder",@"SlayderX",
                                    SET_VECTOR_V(Vector3DMake(-120, fStartPos, 0),@"m_pCurPosition"),
                                    SET_STRING_V(@"Back_Slayder.png",@"m_pNameTexture"));

                                fStartPos-=10;
                                [aObSliders addObject:pOb];
                            }
                        }
                        fStartPos-=20;
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
    [aObSliders release];
    [aObjects release];
    [aProp release];
    [super dealloc];
}

@end