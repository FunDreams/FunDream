//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_SelectionPar.h"
#import "Ob_Editor_Interface.h"

@implementation Ob_SelectionPar
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerTemplet;
        m_iLayerTouch=layerTouch_0;//слой касания
        
        pArrayEnter = [[NSMutableArray alloc] init];
        pArrayExit = [[NSMutableArray alloc] init];
        
        pArrayEnterUse = [[NSMutableArray alloc] init];
        pArrayExitUse = [[NSMutableArray alloc] init];

    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{
    m_bHiden=YES;
}
//------------------------------------------------------------------------------------------------------
//- (void)PostSetParams{}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
//====//процессоры для объекта==========================================================================
//    Processor_ex* pProc = [self START_QUEUE:@"Proc"];
//  //      ASSIGN_STAGE(@"IDLE",@"Idle:",nil);
//        ASSIGN_STAGE(@"PROC",@"Proc:",nil);
//    [self END_QUEUE:pProc name:@"Proc"];
    
//====//различные параметры=============================================================================
//   [m_pObjMng->pMegaTree SetCell:(LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY"))];
    
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    [m_pObjMng->pMegaTree SetCell:(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"))];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
    //GET_DIM_FROM_TEXTURE(@"");
	mWidth  = 50;
	mHeight = 50;

	[super Start];

    //   [self SetTouch:YES];//интерактивность
    GET_TEXTURE(mTextureId, m_pNameTexture);

    //[m_pObjMng AddToGroup:@"NameGroup" Object:self];//группировка
    //[self SelfOffsetVert:Vector3DMake(0,1,0)];//cдвиг
    
    pObBtnClose=UNFROZE_OBJECT(@"ObjectButton",@"ButtonClose",
                               SET_STRING_V(@"Close.png",@"m_DOWN"),
                               SET_STRING_V(@"Close.png",@"m_UP"),
                               SET_FLOAT_V(64,@"mWidth"),
                               SET_FLOAT_V(64*FACTOR_DEC,@"mHeight"),
                               SET_BOOL_V(YES,@"m_bLookTouch"),
                               SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                               SET_INT_V(layerTouch_2N,@"m_iLayerTouch"),
                               SET_STRING_V(NAME(self),@"m_strNameObject"),
                               SET_STRING_V(@"Close",@"m_strNameStage"),
                               SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                               SET_VECTOR_V(Vector3DMake(-40,286,0),@"m_pCurPosition"));
    
    IconEnters=UNFROZE_OBJECT(@"StaticObject",@"Enter",
                               SET_STRING_V(@"In.png",@"m_pNameTexture"),
                               SET_FLOAT_V(64,@"mWidth"),
                               SET_FLOAT_V(64*FACTOR_DEC,@"mHeight"),
                               SET_VECTOR_V(Vector3DMake(-360,170,0),@"m_pCurPosition"),
                               SET_INT_V(layerInterfaceSpace6,@"m_iLayer"));

    IconExits=UNFROZE_OBJECT(@"StaticObject",@"Exit",
                              SET_STRING_V(@"Out.png",@"m_pNameTexture"),
                              SET_FLOAT_V(64,@"mWidth"),
                              SET_FLOAT_V(64*FACTOR_DEC,@"mHeight"),
                              SET_VECTOR_V(Vector3DMake(-120,170,0),@"m_pCurPosition"),
                              SET_INT_V(layerInterfaceSpace6,@"m_iLayer"));
    
    Line=UNFROZE_OBJECT(@"StaticObject",@"Sl2",
                   SET_STRING_V(@"Line.png",@"m_pNameTexture"),
                   SET_FLOAT_V(520,@"mWidth"),
                   SET_FLOAT_V(5,@"mHeight"),
                   SET_VECTOR_V(Vector3DMake(-240,-60,0),@"m_pCurPosition"),
                   SET_VECTOR_V(Vector3DMake(0,0,90),@"m_pCurAngle"),
                   SET_INT_V(layerBackground,@"m_iLayer"));
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateTmp{

    InfoArrayValue *InfoChildString=(InfoArrayValue *)*pConnString->pChildString;
    int *StartChildString=*pConnString->pChildString+SIZE_INFO_STRUCT;

 //   InfoArrayValue *InfoChild=(InfoArrayValue *)*pMatr->pValueCopy;
    int *StartChild=*pMatr->pValueCopy+SIZE_INFO_STRUCT;

    InfoArrayValue *InfoEnter=(InfoArrayValue *)*pMatr->pEnters;
    int *StartEnter=*pMatr->pEnters+SIZE_INFO_STRUCT;
    InfoArrayValue *InfoExit=(InfoArrayValue *)*pMatr->pExits;
    int *StartExit=*pMatr->pExits+SIZE_INFO_STRUCT;
    
    for (int i=0;i<InfoEnter->mCount;i++) {
        int iIndex=StartEnter[i];
        
        NSMutableString *pNameIcon=[NSMutableString stringWithString:@""];
        if(pMatr->TypeInformation==STR_COMPLEX){
            
            for (int j=0; j<InfoChildString->mCount; j++) {
                int iTmpIndex=StartChildString[j];
                FractalString *pString=(FractalString *)[m_pObjMng->pStringContainer->ArrayPoints
                                                GetIdAtIndex:iTmpIndex];
                
                if(pString->m_iIndex==iIndex){
                    [pNameIcon setString:pString->sNameIcon];
                    break;
                }
            }
        }
        else
        {
            int CurretnOffset=i*2+1+1;
            int index=StartChild[CurretnOffset];
            
            NSMutableString *TmpStr=(NSMutableString *)[m_pObjMng->pStringContainer->ArrayPoints
                                                        GetIdAtIndex:index];
            
            [pNameIcon setString:TmpStr];
        }
        
        float X,Y;
        
        X=-440+(i%4)*54;
        Y=100-(i/4)*50;
        
        bool bBack=NO;
        
        InfoArrayValue *InfoPairChild=(InfoArrayValue *)*EndHeart->pEnPairChi;
        int *StartPairChild=*EndHeart->pEnPairChi+SIZE_INFO_STRUCT;
        
        for (int k=0; k<InfoPairChild->mCount; k++) {
            int iIndexPair=StartPairChild[k];
            
            if(iIndex==iIndexPair)
                bBack=YES;
        }


        GObject *pOb = UNFROZE_OBJECT(@"ObjectButton",@"Button",
                                     SET_INT_V(i,@"m_iNum"),
                                     SET_INT_V(bSimple,@"m_iType"),
                                     SET_STRING_V(pNameIcon,@"m_DOWN"),
                                     SET_BOOL_V(bBack,@"m_bBack"),
                                     SET_STRING_V(pNameIcon,@"m_UP"),
                                     SET_FLOAT_V(54,@"mWidth"),
                                     SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
                                     SET_BOOL_V(YES,@"m_bLookTouch"),
                                     SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                                     SET_STRING_V(NAME(self),@"m_strNameObject"),
                                     SET_STRING_V(@"SetPairEnter",@"m_strNameStage"),
                                     SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                                     SET_VECTOR_V(Vector3DMake(X,Y,0),@"m_pCurPosition"));
        
        [pArrayEnter addObject:pOb];
        //pArrayEnterUse
    }

    for (int i=0;i<InfoExit->mCount;i++){
        int iIndex=StartExit[i];
        
        NSMutableString *pNameIcon=[NSMutableString stringWithString:@""];
        if(pMatr->TypeInformation==STR_COMPLEX){
            
            for (int j=0; j<InfoChildString->mCount; j++) {
                int iTmpIndex=StartChildString[j];
                FractalString *pString=(FractalString *)[m_pObjMng->pStringContainer->ArrayPoints
                                                         GetIdAtIndex:iTmpIndex];

                if(pString->m_iIndex==iIndex){
                    [pNameIcon setString:pString->sNameIcon];
                    break;
                }
            }
        }
        else
        {
            int CurretnOffset=i*2+1+1+InfoEnter->mCount*2;
            int index=StartChild[CurretnOffset];
            
            NSMutableString *TmpStr=(NSMutableString *)[m_pObjMng->pStringContainer->ArrayPoints GetIdAtIndex:index];
            
            [pNameIcon setString:TmpStr];
        }

        float X,Y;
        
        X=-200+(i%4)*54;
        Y=100-(i/4)*50;;

        bool bBack=NO;
        
        InfoArrayValue *InfoPairChild=(InfoArrayValue *)*EndHeart->pExPairChi;
        int *StartPairChild=*EndHeart->pExPairChi+SIZE_INFO_STRUCT;
        
        for (int k=0; k<InfoPairChild->mCount; k++) {
            int iIndexPair=StartPairChild[k];
            
            if(iIndex==iIndexPair)
                bBack=YES;
        }

        GObject *pOb = UNFROZE_OBJECT(@"ObjectButton",@"Button",
                                     SET_INT_V(i,@"m_iNum"),
                                     SET_INT_V(bSimple,@"m_iType"),
                                     SET_STRING_V(pNameIcon,@"m_DOWN"),
                                     SET_BOOL_V(bBack,@"m_bBack"),
                                     SET_STRING_V(pNameIcon,@"m_UP"),
                                     SET_FLOAT_V(54,@"mWidth"),
                                     SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
                                     SET_BOOL_V(YES,@"m_bLookTouch"),
                                     SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                                     SET_STRING_V(NAME(self),@"m_strNameObject"),
                                     SET_STRING_V(@"SetPairExit",@"m_strNameStage"),
                                     SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                                     SET_VECTOR_V(Vector3DMake(X,Y,0),@"m_pCurPosition"));
        
        [pArrayEnter addObject:pOb];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetPairEnter{
    
    ObjectButton *pButtonPush=GET_ID_V(@"ButtonPush");
    
    int *StartEnter=*pMatr->pEnters+SIZE_INFO_STRUCT;
    int iIndexPairEx=StartEnter[pButtonPush->m_iNum];
    
    if(pButtonPush->m_bBack==YES){//если уже есть привязка, удаляем её
        
        InfoArrayValue *InfoPairChild=(InfoArrayValue *)(*EndHeart->pEnPairChi);
        int *StartPairChild=*EndHeart->pEnPairChi+SIZE_INFO_STRUCT;
        
        for (int k=0; k<InfoPairChild->mCount; k++){
            int iIndexPair=StartPairChild[k];
            
            if(iIndexPairEx==iIndexPair){
                [m_pObjMng->pStringContainer->m_OperationIndex
                 OnlyRemoveDataAtPlace:k WithData:EndHeart->pEnPairChi];

                [m_pObjMng->pStringContainer->m_OperationIndex
                 OnlyRemoveDataAtPlace:k WithData:EndHeart->pEnPairPar];
            }
        }
    }
    
    //добаляем пару
    [m_pObjMng->pStringContainer->m_OperationIndex
     OnlyAddData:m_iIndexStart WithData:EndHeart->pEnPairPar];
    
    [m_pObjMng->pStringContainer->m_OperationIndex
     OnlyAddData:iIndexPairEx WithData:EndHeart->pEnPairChi];
    
    DESTROY_OBJECT(self);
}
//------------------------------------------------------------------------------------------------------
- (void)SetPairExit{
    
    ObjectButton *pButtonPush=GET_ID_V(@"ButtonPush");
    
    int *StartExits=*pMatr->pExits+SIZE_INFO_STRUCT;
    int iIndexPairEx=StartExits[pButtonPush->m_iNum];
    
    if(pButtonPush->m_bBack==YES){//если уже есть привязка, удаляем её
        
        InfoArrayValue *InfoPairChild=(InfoArrayValue *)(*EndHeart->pExPairChi);
        int *StartPairChild=*EndHeart->pExPairChi+SIZE_INFO_STRUCT;
        
        for (int k=0; k<InfoPairChild->mCount; k++){
            int iIndexPair=StartPairChild[k];
            
            if(iIndexPairEx==iIndexPair){
                [m_pObjMng->pStringContainer->m_OperationIndex
                 OnlyRemoveDataAtPlace:k WithData:EndHeart->pExPairChi];
                
                [m_pObjMng->pStringContainer->m_OperationIndex
                 OnlyRemoveDataAtPlace:k WithData:EndHeart->pExPairPar];
            }
        }
    }
    
    //добаляем пару
    [m_pObjMng->pStringContainer->m_OperationIndex
     OnlyAddData:m_iIndexStart WithData:EndHeart->pExPairPar];
    
    [m_pObjMng->pStringContainer->m_OperationIndex
     OnlyAddData:iIndexPairEx WithData:EndHeart->pExPairChi];
    
    DESTROY_OBJECT(self);
}
//------------------------------------------------------------------------------------------------------
- (void)Close{
    
    OBJECT_PERFORM_SEL(@"Ob_Editor_Interface", @"Update");
    DESTROY_OBJECT(self);
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{
    
    [pArrayEnter release];
    [pArrayExit release];
    
    [pArrayEnterUse release];
    [pArrayExitUse release];

    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    
    for (GObject *pOb in pArrayEnter) {
        DESTROY_OBJECT(pOb);
    }
    [pArrayEnter removeAllObjects];

    for (GObject *pOb in pArrayExit) {
        DESTROY_OBJECT(pOb);
    }
    [pArrayExit removeAllObjects];

    for (GObject *pOb in pArrayEnterUse) {
        DESTROY_OBJECT(pOb);
    }
    [pArrayEnterUse removeAllObjects];

    for (GObject *pOb in pArrayExitUse) {
        DESTROY_OBJECT(pOb);
    }
    [pArrayExitUse removeAllObjects];

    
    DESTROY_OBJECT(pObBtnClose);
    DESTROY_OBJECT(IconEnters);
    DESTROY_OBJECT(IconExits);
    DESTROY_OBJECT(Line);

    
    Ob_Editor_Interface *pInterface = (Ob_Editor_Interface *)[m_pObjMng
                GetObjectByName:@"Ob_Editor_Interface"];
    
    pInterface->EditorSelectPar=nil;
    [pInterface SetMode:OldInterfaceMode];

    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
@end