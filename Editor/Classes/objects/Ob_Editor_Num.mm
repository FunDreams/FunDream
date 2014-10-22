//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_Editor_Num.h"
#import "Ob_NumIndicator.h"
#import "Ob_Editor_Interface.h"

@implementation Ob_Editor_Num
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerTemplet;
        m_iLayerTouch=layerTouch_0;//слой касания
        m_bHiden=NO;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{m_bHiden=NO;}
//- (void)PostSetParams{}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
//====//процессоры для объекта==========================================================================
    Processor_ex* pProc = [self START_QUEUE:@"Proc"];
  //      ASSIGN_STAGE(@"IDLE",@"Idle:",nil);
        ASSIGN_STAGE(@"PROC",@"Proc:",nil);
    [self END_QUEUE:pProc name:@"Proc"];
    
//====//различные параметры=============================================================================
   [m_pObjMng->pMegaTree SetCell:(LINK_INT_V(iIndex,m_strName,@"iIndex"))];
   [m_pObjMng->pMegaTree SetCell:(LINK_INT_V(iIndexArray,m_strName,@"iIndexArray"))];
    
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    [m_pObjMng->pMegaTree SetCell:(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"))];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
    //   GET_DIM_FROM_TEXTURE(@"");
	mWidth  = 50;
	mHeight = 50;
    m_bHiden=NO;

	[super Start];
    
    int** ppArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:iIndexArray];
    InfoArrayValue *pInfo = (InfoArrayValue *)*ppArray;

    iType=pInfo->mType;
    
    switch (iType) {
        case DATA_FLOAT:
        {
            float *Tmpf=(float *)[m_pObjMng->pStringContainer->
                                  ArrayPoints GetDataAtIndex:iIndex];
            m_fTmp=*Tmpf;
        }
            break;
            
        case DATA_INT:
        {
            float *Tmpi=(float *)[m_pObjMng->pStringContainer->
                              ArrayPoints GetDataAtIndex:iIndex];
            m_iTmp=(int)*Tmpi;
        }
            break;
            
        case DATA_U_INT:
        {
            unsigned int*Tmpi=(unsigned int *)(*ppArray+SIZE_INFO_STRUCT+iIndex);
            m_iTmp=(int)*Tmpi;
        }
            
        default:
            break;
    }

    
    //   [self SetTouch:YES];//интерактивность
//    GET_TEXTURE(mTextureId, m_pNameTexture);

//    pObInd = UNFROZE_OBJECT(@"Ob_NumIndicator",@"testIndicator1",
//                 SET_STRING_V(@"ParticlesFroIndicator",@"m_strNameContainer"),
//                 SET_VECTOR_V(Vector3DMake(-200,260,0),@"m_pOffsetCurPosition"),
//                 SET_FLOAT_V(1.5f,@"m_fScale"),
//                 LINK_ID_V(self,@"m_pOwner"));

//    pOb = UNFROZE_OBJECT(@"ObjectFade",@"Fade",
//                   SET_FLOAT_V(1024,@"mWidth"),
//                   SET_FLOAT_V(768,@"mHeight"),
//                   SET_INT_V(layerInterfaceSpace7,@"m_iLayer"),
//                   SET_INT_V(layerTouch_1N,@"m_iLayerTouch"),
//                   SET_BOOL_V(YES,@"m_bLookTouch"),
//                   SET_BOOL_V(YES,@"m_bObTouch"),
//                   SET_FLOAT_V(5,@"m_fVelFade"),
//                   SET_COLOR_V(Color3DMake(0.4f, 0.4f, 0.4f, 1),@"mColor"));

    pObBtnClose=UNFROZE_OBJECT(@"ObjectButton",@"ButtonClose",
                   SET_STRING_V(@"Close.png",@"m_DOWN"),
                   SET_STRING_V(@"Close.png",@"m_UP"),
                   SET_FLOAT_V(64,@"mWidth"),
                   SET_FLOAT_V(64,@"mHeight"),
                   SET_BOOL_V(YES,@"m_bLookTouch"),
                   SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                   SET_INT_V(layerTouch_2N,@"m_iLayerTouch"),
                   SET_STRING_V(NAME(self),@"m_strNameObject"),
                   SET_STRING_V(@"Close",@"m_strNameStage"),
                   SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                   SET_VECTOR_V(Vector3DMake(-40,340,0),@"m_pCurPosition"));

    if(iType!=DATA_U_INT){
        pObBtnMinus=UNFROZE_OBJECT(@"ObjectButton",@"ButtonMinus",
                       SET_STRING_V(@"ButtonMinus.png",@"m_DOWN"),
                       SET_STRING_V(@"ButtonMinus.png",@"m_UP"),
                       SET_FLOAT_V(90,@"mWidth"),
                       SET_FLOAT_V(90,@"mHeight"),
                       SET_BOOL_V(YES,@"m_bLookTouch"),
                       SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                       SET_INT_V(layerTouch_2N,@"m_iLayerTouch"),
                       SET_STRING_V(NAME(self),@"m_strNameObject"),
                       SET_STRING_V(@"ClickMinus",@"m_strNameStage"),
                       SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                       SET_VECTOR_V(Vector3DMake(-420,130,0),@"m_pCurPosition"));
    }

    if(iType==DATA_FLOAT){
        pObBtnPoint=UNFROZE_OBJECT(@"ObjectButton",@"ButtonPoint",
                       SET_STRING_V(@"Point.png",@"m_DOWN"),
                       SET_STRING_V(@"Point.png",@"m_UP"),
                       SET_FLOAT_V(90,@"mWidth"),
                       SET_FLOAT_V(90,@"mHeight"),
                       SET_BOOL_V(YES,@"m_bLookTouch"),
                       SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                       SET_INT_V(layerTouch_2N,@"m_iLayerTouch"),
                       SET_STRING_V(NAME(self),@"m_strNameObject"),
                       SET_STRING_V(@"ClickPoint",@"m_strNameStage"),
                       SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                       SET_VECTOR_V(Vector3DMake(-330,130,0),@"m_pCurPosition"));

        pObBtnPoint2=UNFROZE_OBJECT(@"ObjectButton",@"ButtonPoint",
                       SET_STRING_V(@"Point.png",@"m_DOWN"),
                       SET_STRING_V(@"Point.png",@"m_UP"),
                       SET_FLOAT_V(90,@"mWidth"),
                       SET_FLOAT_V(90,@"mHeight"),
                       SET_BOOL_V(YES,@"m_bLookTouch"),
                       SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                       SET_INT_V(layerTouch_2N,@"m_iLayerTouch"),
                       SET_STRING_V(NAME(self),@"m_strNameObject"),
                       SET_STRING_V(@"ClickPoint2",@"m_strNameStage"),
                       SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                       SET_VECTOR_V(Vector3DMake(-240,130,0),@"m_pCurPosition"));
    }

    pObBtnClear=UNFROZE_OBJECT(@"ObjectButton",@"ButtonClear",
                   SET_STRING_V(@"Clear.png",@"m_DOWN"),
                   SET_STRING_V(@"Clear.png",@"m_UP"),
                   SET_FLOAT_V(90,@"mWidth"),
                   SET_FLOAT_V(90,@"mHeight"),
                   SET_BOOL_V(YES,@"m_bLookTouch"),
                   SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                   SET_INT_V(layerTouch_2N,@"m_iLayerTouch"),
                   SET_STRING_V(NAME(self),@"m_strNameObject"),
                   SET_STRING_V(@"Clear",@"m_strNameStage"),
                   SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                   SET_VECTOR_V(Vector3DMake(-150,130,0),@"m_pCurPosition"));

    float Step=90;
    for(int i=0;i<9;i++){
        
        NSString *StrContainer = [NSString stringWithFormat:@"%d.png",i+1];
        NSString *StrSel = [NSString stringWithFormat:@"Click%d",i+1];
        int X=i%3;
        int Y=i/3;
        
        GObject *pObBtnNum=UNFROZE_OBJECT(@"ObjectButton",@"ButtonNum",
                       SET_STRING_V(StrContainer,@"m_DOWN"),
                       SET_STRING_V(StrContainer,@"m_UP"),
                       SET_FLOAT_V(80,@"mWidth"),
                       SET_FLOAT_V(80,@"mHeight"),
                       SET_BOOL_V(YES,@"m_bLookTouch"),
                       SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                       SET_INT_V(layerTouch_2N,@"m_iLayerTouch"),
                       SET_STRING_V(NAME(self),@"m_strNameObject"),
                       SET_STRING_V(StrSel,@"m_strNameStage"),
                       SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                       SET_VECTOR_V(Vector3DMake(-400+X*Step,-Y*Step,0),@"m_pCurPosition"));
        
        [m_pChildrenbjectsArr addObject:pObBtnNum];
    }
    
    GObject *pObBtnNum=UNFROZE_OBJECT(@"ObjectButton",@"ButtonNum",
                                      SET_STRING_V(@"_0.png",@"m_DOWN"),
                                      SET_STRING_V(@"_0.png",@"m_UP"),
                                      SET_FLOAT_V(80,@"mWidth"),
                                      SET_FLOAT_V(80,@"mHeight"),
                                      SET_BOOL_V(YES,@"m_bLookTouch"),
                                      SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                                      SET_INT_V(layerTouch_2N,@"m_iLayerTouch"),
                                      SET_STRING_V(NAME(self),@"m_strNameObject"),
                                      SET_STRING_V(@"Click0",@"m_strNameStage"),
                                      SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                                      SET_VECTOR_V(Vector3DMake(-400+1*Step,-3*Step,0),@"m_pCurPosition"));

    [m_pChildrenbjectsArr addObject:pObBtnNum];

    //[m_pObjMng AddToGroup:@"NameGroup" Object:self];//группировка
    //[self SelfOffsetVert:Vector3DMake(0,1,0)];//cдвиг
}
//------------------------------------------------------------------------------------------------------
- (void)Close{
    
    OBJECT_PERFORM_SEL(@"Ob_Editor_Interface", @"Update");
    DESTROY_OBJECT(self);
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
//------------------------------------------------------------------------------------------------------
- (void)AddValue:(int)V{
    
    if(iType==DATA_FLOAT){
        float TmpFloat=m_fTmp;
        int TmpValue=(int)TmpFloat;
        float TmpFloat2=TmpFloat-TmpValue;
        
        if(fabs(TmpValue)<10000000){
            TmpValue*=10;
            TmpValue+=V;
            
            TmpFloat=TmpValue+TmpFloat2;
        }
    
        m_fTmp=TmpFloat;
    }
    else if(iType==DATA_INT){
        
        int TmpInt=m_iTmp;
        
        TmpInt*=10;
        TmpInt+=V;
        
        m_iTmp=TmpInt;
    }
    else if(iType==DATA_U_INT){
        
        unsigned int TmpInt=m_iTmp;
        
        TmpInt*=10;
        TmpInt+=V;
        
        m_iTmp=TmpInt;
    }
    
    [self UpdateNum];
}
//------------------------------------------------------------------------------------------------------
- (void)Click0{
    [self AddValue:0];
}
//------------------------------------------------------------------------------------------------------
- (void)Click1{
    [self AddValue:1];
}
//------------------------------------------------------------------------------------------------------
- (void)Click2{
    [self AddValue:2];
}
//------------------------------------------------------------------------------------------------------
- (void)Click3{
    [self AddValue:3];
}
//------------------------------------------------------------------------------------------------------
- (void)Click4{
    [self AddValue:4];
}
//------------------------------------------------------------------------------------------------------
- (void)Click5{
    [self AddValue:5];
}
//------------------------------------------------------------------------------------------------------
- (void)Click6{
    [self AddValue:6];
}
//------------------------------------------------------------------------------------------------------
- (void)Click7{
    [self AddValue:7];
}
//------------------------------------------------------------------------------------------------------
- (void)Click8{
    [self AddValue:8];
}
//------------------------------------------------------------------------------------------------------
- (void)Click9{
    [self AddValue:9];
}
//------------------------------------------------------------------------------------------------------
- (void)Clear{
    
    m_fTmp=0;
    m_iTmp=0;
    
    [self UpdateNum];
}
//------------------------------------------------------------------------------------------------------
- (void)ClickPoint{
    
    float TmpFloat=m_fTmp;
    
    if(fabs(TmpFloat)>0.001f)
        TmpFloat/=10;
    
    m_fTmp=TmpFloat;
    
    [self UpdateNum];
}
//------------------------------------------------------------------------------------------------------
- (void)ClickPoint2{
    
    float TmpFloat=m_fTmp;
    
    if(fabs(TmpFloat)<10000000.0f)
        TmpFloat*=10;
    
    m_fTmp=TmpFloat;
    
    [self UpdateNum];
}
//------------------------------------------------------------------------------------------------------
- (void)ClickClear{
    
    m_fTmp=0;
    m_iTmp=0;
    [self UpdateNum];
}
//------------------------------------------------------------------------------------------------------
- (void)ClickMinus{
    m_fTmp=-m_fTmp;
    m_iTmp=-m_iTmp;
    [self UpdateNum];
}
//------------------------------------------------------------------------------------------------------
- (void)InitProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)PrepareProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{
    
//    PLAY_SOUND(@"");
//    STOP_SOUND(@"");
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateNum{
    
    NSString *pStr=nil;
        
    int** ppArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:iIndexArray];
    InfoArrayValue *pInfo = (InfoArrayValue *)*ppArray;
    
    iType=pInfo->mType;

    
    switch (iType) {
        case DATA_FLOAT:
        {
            pStr = [NSString stringWithFormat:@"%1.2f",m_fTmp];
        }
        break;

        case DATA_INT:
        case DATA_U_INT:
        {
            pStr = [NSString stringWithFormat:@"%d",m_iTmp];
        }
        break;

        default:
            break;
    }
    
    if(![StrValue isEqualToString:pStr])
    {
        [StrValue release];
        StrValue=[[NSString stringWithString:pStr] retain];
        
        int iFontSize=60;
        TextureIndicatorValue=[self CreateText:StrValue al:UITextAlignmentCenter
                                    Tex:TextureIndicatorValue fSize:iFontSize
                                    dimensions:CGSizeMake(300, iFontSize+4) fontName:@"Helvetica"];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SelfDrawOffset{
    
    [self UpdateNum];
    [self drawTextAtX:-280 Y:330 Color:Color3DMake(1,0.5f,0.5f,1) Tex:TextureIndicatorValue];
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    
//    DESTROY_OBJECT(pOb);
    DESTROY_OBJECT(pObBtnClose);
    DESTROY_OBJECT(pObBtnClear);
    DESTROY_OBJECT(pObBtnMinus);
    DESTROY_OBJECT(pObBtnPoint);
    DESTROY_OBJECT(pObBtnPoint2);
//    DESTROY_OBJECT(pObInd);
    
    [TextureIndicatorValue release];
    TextureIndicatorValue=0;
    [StrValue release];
    StrValue=0;

    
    for (GObject *pObTmp in m_pChildrenbjectsArr) {
        DESTROY_OBJECT(pObTmp);
    }
    
    Ob_Editor_Interface *pInterface = (Ob_Editor_Interface *)[m_pObjMng GetObjectByName:@"Ob_Editor_Interface"];
    pInterface->EditorNum=nil;
    
    [pInterface SetMode:OldInterfaceMode];

    int** ppArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:iIndexArray];
    InfoArrayValue *pInfo = (InfoArrayValue *)*ppArray;
    
    switch (iType) {
        case DATA_FLOAT:
        {
            float *Tmpf=(float *)[m_pObjMng->pStringContainer->
                                  ArrayPoints GetDataAtIndex:iIndex];
            *Tmpf=m_fTmp;
        }
        break;
            
        case DATA_INT:
        {
            float *Tmpf=(float *)[m_pObjMng->pStringContainer->
                              ArrayPoints GetDataAtIndex:iIndex];
             *Tmpf=(float)m_iTmp;
        }
        break;

        case DATA_U_INT:
        {
            if(pInfo->UnParentMatrix.indexMatrix!=0)
            {
                MATRIXcell *pTmpMatr=[m_pObjMng->pStringContainer->ArrayPoints
                                      GetMatrixAtIndex:pInfo->UnParentMatrix.indexMatrix];
                
                Ob_Editor_Interface *oInterface = (Ob_Editor_Interface *)[m_pObjMng GetObjectByName:@"Ob_Editor_Interface"];
                
                int iSizeMatr=[oInterface GetMatrixSize:pTmpMatr];
                
                if(iSizeMatr>0)
                {
                    if(m_iTmp>iSizeMatr-1)m_iTmp=iSizeMatr-1;
                }
                else m_iTmp=0;
                
                int** ppArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:iIndexArray];
                *(*((unsigned int**)ppArray)+SIZE_INFO_STRUCT+iIndex)=m_iTmp;
            }
            else
            {
                int** ppArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:iIndexArray];
                *(*((unsigned int**)ppArray)+SIZE_INFO_STRUCT+iIndex)=0;
            }
        }
            break;

        default:
            break;
    }

    [super Destroy];
    [pInterface UpdateB];
}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
@end