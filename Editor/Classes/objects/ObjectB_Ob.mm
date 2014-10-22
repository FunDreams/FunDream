//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectB_Ob.h"
#import "UniCell.h"
#import "Ob_IconDrag.h"
#import "Ob_Editor_Interface.h"
#import "Ob_Arrow.h"
#import "Ob_Editor_Num.h"
#import "MainCycle.h"
#import "Ob_ParticleCont_ForStr.h"

@implementation ObjectB_Ob
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerInterfaceSpace5;
        m_iLayerTouch=layerTouch_1N;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{
    m_fPhase=0;
    mColor.red=1;
    mColor.green=1;
    mColor.blue=1;
    mColor.alpha=1;
    
    m_pOwner=nil;
    
    m_bNotPush=NO;
    m_bHiden=NO;
    m_bPush=NO;
    m_bDrag=YES;
    m_bStartPush=NO;
    m_bStartMove=NO;
    m_bFlicker=NO;
    m_bStartTouch=NO;
    
    [m_DOWN setString:@""];
    [m_UP setString:@""];
    [m_strNameSound setString:@""];
    [m_strNameStage setString:@""];
    [m_strNameObject setString:@""];

    [m_strNameStageDClick setString:@""];
    [m_strNameObjectDClick setString:@""];
    
    mColorBack = Color3DMake(0, 1, 0, 1);
    m_bBack=YES;
    
    [self setUnFlick];
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    
    [m_pObjMng->pMegaTree SetCell:LINK_INT_V(m_iTypeStr,m_strName,@"m_iTypeStr")];

    [m_pObjMng->pMegaTree SetCell:LINK_COLOR_V(mColorBack,m_strName,@"mColorBack")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bBack,m_strName,@"m_bBack")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bFlicker,m_strName,@"m_bFlicker")];

    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bNotPush,m_strName,@"m_bNotPush")];

    [m_pObjMng->pMegaTree SetCell:LINK_INT_V(m_iNum,m_strName,@"m_iNum")];
    
    m_strNameSound=[NSMutableString stringWithString:@""];
    m_strNameStage=[NSMutableString stringWithString:@""];
    m_strNameObject=[NSMutableString stringWithString:@""];

    m_strNameStageDClick=[NSMutableString stringWithString:@""];
    m_strNameObjectDClick=[NSMutableString stringWithString:@""];

    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound")];
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_strNameStage,m_strName,@"m_strNameStage")];
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_strNameObject,m_strName,@"m_strNameObject")];
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_strNameStageDClick,m_strName,@"m_strNameStageDClick")];
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_strNameObjectDClick,m_strName,@"m_strNameObjectDClick")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bLookTouch,m_strName,@"m_bLookTouch")];

    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDrag,m_strName,@"m_bDrag")];
    
    m_DOWN=[NSMutableString stringWithString:@""];
    m_UP=[NSMutableString stringWithString:@""];
    
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_DOWN,m_strName,@"m_DOWN")];
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_UP,m_strName,@"m_UP")];
//////--------------------------------------------------------------------------------------------------
    Processor_ex *pProc = [self START_QUEUE:@"DTouch"];
        ASSIGN_STAGE(@"Idle", @"Idle:",nil)
        ASSIGN_STAGE(@"DoubleTouch",@"DoubleTouch:",SET_INT_V(500,@"TimeBaseDelay"));
    [self END_QUEUE:pProc name:@"DTouch"];

    pProc = [self START_QUEUE:@"Flick"];
        ASSIGN_STAGE(@"Stop", @"Idle:",nil)
        ASSIGN_STAGE(@"ActionFlick",@"ActionFlick:",nil);
    [self END_QUEUE:pProc name:@"Flick"];    

    pProc = [self START_QUEUE:@"Wait"];
        ASSIGN_STAGE(@"Stop", @"Idle:",nil)
        ASSIGN_STAGE(@"Wait",@"Wait:",nil);
    [self END_QUEUE:pProc name:@"Wait"];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
    mbFlick=NO;
	[super Start];
    [self SetTouch:YES];

	m_vStartPos=m_pCurPosition;
	
    m_TextureUP=-1;
    m_TextureDown=-1;
	GET_TEXTURE(m_TextureUP,m_UP);
	GET_TEXTURE(m_TextureDown,m_DOWN);
    
	mTextureId=m_TextureUP;
    
    m_vStartPos=m_pCurPosition;
    m_vEndPos=m_pCurPosition;
    m_vEndPos.y-=1000;
    m_bStartPush=NO;
    SET_STAGE_EX(NAME(self), @"Wait", @"Stop");
    SET_STAGE_EX(NAME(self), @"Flick", @"Stop");
    
    if(m_bFlicker==YES)[self setFlick];
    else [self setUnFlick];
    
    mCountTmp=RND%30+30;
    
    GET_TEXTURE(mTextureIdEn, @"Enter.png");
    GET_TEXTURE(mTextureIdEx, @"Exit.png");
    
    mWidth=74;
    mHeight=74;
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateTextureOnFace{
    
    mCountTmp++;
    
    if(mCountTmp>=10)
    {
        mCountTmp=0;
        
        if(pString==nil)return;
        
        switch (m_iTypeStr)
        {                
            case DATA_ARRAY:
            {
                NSString *pStr=nil;
                
                int **ppArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:pString->m_iIndex];
                InfoArrayValue *pInfo=(InfoArrayValue *)(*ppArray);
                int *pStartData=(*ppArray)+SIZE_INFO_STRUCT;
                
                if(pInfo->mCount>0){

                    switch (pInfo->mType) {
                        case DATA_FLOAT:
                        {
                            float *Tmpf=(float *)[m_pObjMng->pStringContainer->
                                                  ArrayPoints GetDataAtIndex:pStartData[0]];
                            
                            pStr = [NSString stringWithFormat:@"%1.2f",*Tmpf];
                            
                            if(![StrValueOnFace isEqualToString:pStr])
                            {
                                [StrValueOnFace release];
                                StrValueOnFace=[[NSString stringWithString:pStr] retain];
                                
                                int iFontSize=16;
                                TextureIndicatorValue=[self CreateText:StrValueOnFace al:UITextAlignmentCenter
                                    Tex:TextureIndicatorValue fSize:iFontSize
                                    dimensions:CGSizeMake(mWidth+40, iFontSize+4) fontName:@"Gill Sans"];
                            }

                        }
                        break;
                            
                        case DATA_INT:
                        {
                            float *Tmpi=(float *)[m_pObjMng->pStringContainer->
                                              ArrayPoints GetDataAtIndex:pStartData[0]];
                            
                            pStr = [NSString stringWithFormat:@"%d",(int)*Tmpi];
                            
                            if(![StrValueOnFace isEqualToString:pStr])
                            {
                                [StrValueOnFace release];
                                StrValueOnFace=[[NSString stringWithString:pStr] retain];
                                
                                int iFontSize=16;
                                TextureIndicatorValue=[self CreateText:StrValueOnFace al:UITextAlignmentCenter
                                    Tex:TextureIndicatorValue fSize:iFontSize
                                    dimensions:CGSizeMake(mWidth+40, iFontSize+4) fontName:@"Gill Sans"];
                            }

                        }
                        break;
                            
                        case DATA_SPRITE:
                        {
                            NSString *pStr=nil;
                            int *Tmpi=(int *)[m_pObjMng->pStringContainer->
                                              ArrayPoints GetDataAtIndex:pStartData[0]];
                            
                            pStr = [NSString stringWithFormat:@"%d",*Tmpi];
                            
                            if(![StrValueSprite isEqualToString:pStr])
                            {
                                [StrValueSprite release];
                                StrValueSprite=[[NSString stringWithString:pStr] retain];
                                
                                int iFontSize=20;
                                TextureIndicatorSprite=[self CreateText:StrValueSprite al:UITextAlignmentCenter
                                            Tex:TextureIndicatorValue fSize:iFontSize
                                            dimensions:CGSizeMake(mWidth, iFontSize+4)
                                            fontName:@"Helvetica"];
                            }
                        }
                        break;
                            
                        default:
                            break;
                    }
                }
            }

            default:
                break;
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetUnPush{
    
    m_bPush=NO;
    
    mColor.green=1;
    mColor.blue=1;
}
//------------------------------------------------------------------------------------------------------
- (void)SetPush{

    m_bPush=YES;
    
    mColor.green=0;
    mColor.blue=0;
}
//------------------------------------------------------------------------------------------------------
- (void)DoubleTouch:(Processor_ex *)pProc{
    
    m_bDoubleTouch=NO;
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)setFlick{
    
    if(mbFlick==NO)
    {
    //    m_fPhase=0;
    //    mColorBack.alpha=1;
        mbFlick=YES;
        SET_STAGE_EX(NAME(self), @"Flick", @"ActionFlick");
    }
}
//------------------------------------------------------------------------------------------------------
- (void)setUnFlick{
    
    if(mbFlick==YES)
    {
        mbFlick=NO;
    //    mColorBack.alpha=1;
        SET_STAGE_EX(NAME(self), @"Flick", @"Stop");
    }
}
//------------------------------------------------------------------------------------------------------
- (void)PrepareActionFlick:(ProcStage_ex *)pStage{
    m_fPhase=0;
}
//------------------------------------------------------------------------------------------------------
- (void)ActionFlick:(Processor_ex *)pProc{
    
    m_fPhase+=DELTA*3;
    mColorBack.alpha=0.5f*cos(m_fPhase)+0.5f;
}
//------------------------------------------------------------------------------------------------------
- (void)Wait:(Processor_ex *)pProc{
    
    if(pString==0)return;
    m_fWaitTime+=DELTA;
    
    if(m_fWaitTime>1){
        int iType=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:pString->m_iIndex];
        
        if(iType==DATA_ARRAY){
            int **ppArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:pString->m_iIndex];
            InfoArrayValue *pInfo=(InfoArrayValue *)(*ppArray);
            int *pStartData=(*ppArray)+SIZE_INFO_STRUCT;

            switch (pInfo->mType) {
                case DATA_FLOAT:
                case DATA_INT:
                {
                    Ob_Editor_Interface *pInterface = (Ob_Editor_Interface *)[m_pObjMng GetObjectByName:@"Ob_Editor_Interface"];
                    
                    pInterface->iIndexForNum=pStartData[0];
                    [pInterface SetMode:M_EDIT_NUM];
                }
                break;
                    
                case DATA_TEXTURE:
                {
                    m_iIndexPlace=0;
                    SET_CELL(LINK_INT_V(m_iIndexPlace,@"m_iIndexPlace"));
                    SET_CELL(LINK_ID_V(pString,@"DoubleTouchFractalString"));
                    OBJECT_PERFORM_SEL(@"Ob_Editor_Interface", @"SelTexture");
                }
                    break;

                case DATA_SOUND:
                {
                    m_iIndexPlace=0;
                    SET_CELL(LINK_INT_V(m_iIndexPlace,@"m_iIndexPlace"));
                    SET_CELL(LINK_ID_V(pString,@"DoubleTouchFractalString"));
                    OBJECT_PERFORM_SEL(@"Ob_Editor_Interface", @"SelSound");
                }
                    break;

                default:
                    break;
            }
        }
        
        SET_STAGE_EX(NAME(self), @"Wait", @"Stop");
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{
    
//    if(m_bDrag==YES){
//        if(m_pCurPosition.y>250)
//            m_bLookTouch=NO;
//        else m_bLookTouch=YES;
//    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetPlace{
    
//    pObEmptyPlace = GET_ID_V(@"EmptyPlace");
//    if(pObEmptyPlace!=nil){
//        
//    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{

    int *pMode=GET_INT_V(@"m_iMode");
    
    SET_STAGE_EX(NAME(self), @"Wait", @"Wait");
    m_fWaitTime=0;

    LOCK_TOUCH;
    
    m_bStartTouch=YES;

    LastPointTouch.x=Point.x;
    LastPointTouch.y=Point.y;
    
    PLAY_SOUND(@"take.wav");

    if(m_bNotPush==NO)
    {
        if(m_bDrag==YES)
        {
            [m_pObjMng->pMegaTree SetCell:LINK_ID_V(self,@"ObCheckOb")];
            
            if(m_iLayer==layerInterfaceSpace5){
                
                m_bStartPush=YES;
                [self SetLayer:m_iLayer+1];
                [self SetTouch:YES WithLayer:m_iLayerTouch-1];
            }

            if(*pMode==M_CONNECT)
            {
                [m_pObjMng->pMegaTree SetCell:(LINK_ID_V(pString,@"StartConnection"))];
            }
        }
                                    
        if(*pMode==M_TRANSLATE)
        {
            if(m_bPush==YES)
            {
                [self SetUnPush];
            }
            else
            {
                [self SetPush];
            }
        }
        else [self SetPush];
        
        OBJECT_PERFORM_SEL(m_strNameObject, m_strNameStage);

        if(*pMode==M_DEBUG){

            int Place=[m_pObjMng->pStringContainer->m_OperationIndex FindIndex:pString->m_iIndexSelf
                                       WithData:pString->pParent->pChildString];
            
            int iType=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:pString->m_iIndex];
            
            if(iType==DATA_MATRIX && Place!=-1){
                                
                [m_pObjMng->pStringContainer->pMainCycle Update:pString Place:Place];
            }
        }
    }

    if(m_bDoubleTouch==YES)
    {
        m_bDoubleTouch=NO;

        if(*pMode!=M_DEBUG && *pMode!=M_TRANSLATE)
        {
            SET_CELL(LINK_INT_V(m_iIndexPlace,@"m_iIndexPlace"));
            SET_CELL(LINK_ID_V(pString,@"DoubleTouchFractalString"));
            OBJECT_PERFORM_SEL(@"Ob_Editor_Interface", @"DoubleTouchObject");
        }
    }
    else
    {
        NEXT_STAGE_EX(NAME(self), @"DTouch");
        m_bDoubleTouch=YES;
    }
}
//------------------------------------------------------------------------------------------------------
-(void)MoveObject:(CGPoint)Point WithMode:(bool)bMoveIn{
        
    int *pMode=GET_INT_V(@"m_iMode");
    SET_STAGE_EX(NAME(self), @"Wait", @"Stop");

    if(*pMode==M_MOVE){
        
        if(m_bDrag==YES && m_bStartPush==YES){

            m_pCurPosition.x-=LastPointTouch.x-Point.x;
            m_pCurPosition.y-=LastPointTouch.y-Point.y;

            LastPointTouch.x=Point.x;
            LastPointTouch.y=Point.y;

            if(m_pCurPosition.x<-436)m_pCurPosition.x=-436;
            if(m_pCurPosition.x>-25)m_pCurPosition.x=-25;

            if(m_pCurPosition.y<-350)m_pCurPosition.y=-350;
            if(m_pCurPosition.y>258)m_pCurPosition.y=258;

            pString->X=m_pCurPosition.x;
            pString->Y=m_pCurPosition.y;
            m_bStartMove=YES;
        }
    }
    else
    {
        if(*pMode==M_CONNECT){
            
            if(m_bStartMove==NO  && m_bStartTouch==YES){

                UNFROZE_OBJECT(@"Ob_Arrow",@"Arrow",
                                SET_VECTOR_V(m_pCurPosition,@"Start_Vector"));
                m_bStartMove=YES;
            }
        }
        else if(*pMode==M_DEBUG){}
        else if(*pMode==M_TRANSLATE){}
        else if(*pMode==M_EDIT_EN_EX){}
        else
        {
            if(m_bStartMove==NO && m_bStartTouch==YES){

                [m_pObjMng->pMegaTree SetCell:(LINK_ID_V(pString,@"DragObject"))];

                Ob_IconDrag *pOb=UNFROZE_OBJECT(@"Ob_IconDrag",@"IconDrag",
                               SET_FLOAT_V(44,@"mWidth"),
                               SET_FLOAT_V(44,@"mHeight"),
                               SET_BOOL_V(NO,@"bFromEmpty"),
                               SET_VECTOR_V(m_pCurPosition,@"m_pCurPosition"),
                               SET_STRING_V(pString->sNameIcon,@"m_pNameTexture"));

                int iType = [m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:pString->m_iIndex];
                if(iType==DATA_ARRAY)
                    pString->m_iCurState=0;
                
                pOb->pInsideString=pString;
                m_bStartMove=YES;
            }
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{

    [self SetPush];
    [self MoveObject:Point WithMode:YES];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    SET_STAGE_EX(NAME(self), @"Wait", @"Stop");

    int *pMode=GET_INT_V(@"m_iMode");
    if(*pMode!=M_TRANSLATE)
    {
        if(m_bStartPush==NO)[self SetUnPush];
    }
    
    [self MoveObject:Point WithMode:NO];
}
//------------------------------------------------------------------------------------------------------
- (void)EndTouch{
    
    bool bUpdate=NO;
    SET_STAGE_EX(NAME(self), @"Wait", @"Stop");
    
    if(m_bStartPush==YES)
        PLAY_SOUND(@"drop.wav");
    
    int *pMode=GET_INT_V(@"m_iMode");
    
    if(m_iLayer==layerInterfaceSpace6){
     //   m_bLookTouch=YES;
                
        Ob_Editor_Interface *Interface=(Ob_Editor_Interface *)
                    [m_pObjMng GetObjectByName:@"Ob_Editor_Interface"];
        
        GObject *pOb=nil;
        if(Interface!=nil)
            pOb=Interface->BTash;

        CGPoint Point;
        Point.x=m_pCurPosition.x;
        Point.y=m_pCurPosition.y;
        
        if([pOb Intersect:Point])
        {
            Ob_Editor_Interface *pInterface=(Ob_Editor_Interface *)[m_pObjMng
                                                GetObjectByName:@"Ob_Editor_Interface"];
    
            pInterface->StringSelect=0;
                
            [m_pObjMng->pStringContainer DelString:pString];
            pString=0;
            bUpdate=YES;
            goto Exit;
        }
Exit:
        
        [self SetLayer:m_iLayer-1];
        [self SetTouch:YES WithLayer:m_iLayerTouch+1];
        DEL_CELL(@"DragObject");

        if(*pMode!=M_TRANSLATE)
        {
            if(m_bPush==NO || bUpdate==YES)
                OBJECT_PERFORM_SEL(@"Ob_Editor_Interface",@"UpdateB");
        }
    }
    
    m_bStartTouch=NO;
    m_bStartPush=NO;
    m_bStartMove=NO;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    int *pMode=GET_INT_V(@"m_iMode");
    if(pMode!=0 && *pMode==M_CONNECT && m_bStartTouch==NO){
        FractalString *StartStr=GET_ID_V(@"StartConnection");
        
        if(StartStr!=nil)
            [m_pObjMng->pStringContainer ConnectStart:StartStr End:pString];
    }

    [self EndTouch];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEndedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    [self EndTouch];
}
//------------------------------------------------------------------------------------------------------
-(bool)CheckFlick:(FractalString *)str
{
    return YES;
}
//------------------------------------------------------------------------------------------------------
- (void)SelfDrawOffset{

    if(pString==0)return;
        
    switch (m_iTypeStr)
    {
        case DATA_ARRAY:
        {
            int **ppArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:pString->m_iIndex];
            
            if(ppArray!=0){
                InfoArrayValue *pInfo=(InfoArrayValue *)(*ppArray);
                int *pStartData=(*ppArray)+SIZE_INFO_STRUCT;
                
                int iDim=1;
                
                if(pInfo->mType == DATA_U_INT)
                {
                    iDim=pInfo->mCount;
                }
                else
                {
                    if(pInfo->UnParentMatrix.indexMatrix!=0)
                    {
                        MATRIXcell *pMatr = [m_pObjMng->pStringContainer->ArrayPoints
                                             GetMatrixAtIndex:pInfo->UnParentMatrix.indexMatrix];
                        
                        iDim=pMatr->iDimMatrix;
                    }
                }
                
                //рисуем объём массива
                NSString *pStr = [NSString stringWithFormat:@"%d",iDim];
                
                if(![StrTexIndicatroArrayCount isEqualToString:pStr])
                {
                    [StrTexIndicatroArrayCount release];
                    StrTexIndicatroArrayCount=[[NSString stringWithString:pStr] retain];
                    
                    int iFontSize=14;
                    TexIndicatroArrayCount=[self CreateText:StrTexIndicatroArrayCount al:UITextAlignmentCenter
                                Tex:TexIndicatroArrayCount fSize:iFontSize
                                dimensions:CGSizeMake(mWidth-10, iFontSize+4) fontName:@"Gill Sans"];
                }
                
                [self drawTextAtX:m_pCurPosition.x+20 Y:m_pCurPosition.y+27
                            Color:Color3DMake(1,1,1,1) Tex:TexIndicatroArrayCount];

                if(pString->m_iAdditionalType==ADIT_TYPE_ENTER ||
                   pString->m_iAdditionalType==ADIT_TYPE_EXIT)
                {
                    NSString *pStrGroup = [NSString stringWithFormat:@"%d",pInfo->mGroup];
                    
                    if(![StrTexIndicatrGroupEnEx isEqualToString:pStrGroup])
                    {
                        [StrTexIndicatrGroupEnEx release];
                        StrTexIndicatrGroupEnEx=[[NSString stringWithString:pStrGroup] retain];
                        
                        int iFontSize=14;
                        TexIndicatrorGroupEnEx=[self CreateText:StrTexIndicatrGroupEnEx al:UITextAlignmentLeft
                                Tex:TexIndicatrorGroupEnEx fSize:iFontSize
                         dimensions:CGSizeMake(mWidth-10, iFontSize+4) fontName:@"Gill Sans"];
                    }

                    [self drawTextAtX:m_pCurPosition.x+75 Y:m_pCurPosition.y+10
                                Color:Color3DMake(1,1,0,1) Tex:TexIndicatrorGroupEnEx];
                }
                
                switch (pInfo->mType) {
                    case DATA_FLOAT:
                    case DATA_INT:
                    case DATA_U_INT:
                    {
                        glVertexPointer(3, GL_FLOAT, 0, vertices);
                        glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
                        glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
                        
                        glTranslatef(m_pCurPosition.x+m_pObjMng->m_pParent->m_vOffset.x*m_fScaleOffset,
                                     m_pCurPosition.y+m_pObjMng->m_pParent->m_vOffset.y*m_fScaleOffset,
                                     m_pCurPosition.z);
                        
                        glRotatef(m_pCurAngle.z, 0, 0, 1);
                        glScalef(m_pCurScale.x,m_pCurScale.y,m_pCurScale.z);
                        
                        [self SetColor:mColorBack];
                        
                        glBindTexture(GL_TEXTURE_2D, -1);
                        
                        if(m_bBack==YES){
                            glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
                        }
                        
                        [self SetColor:mColor];
                        
                        glBindTexture(GL_TEXTURE_2D, mTextureId);
                        glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
                        
                        break;
                    }
                        
                    case DATA_TEXTURE:
                    {
                        glVertexPointer(3, GL_FLOAT, 0, vertices);
                        glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
                        glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
                        
                        glTranslatef(m_pCurPosition.x+m_pObjMng->m_pParent->m_vOffset.x*m_fScaleOffset,
                                     m_pCurPosition.y+m_pObjMng->m_pParent->m_vOffset.y*m_fScaleOffset,
                                     m_pCurPosition.z);
                        
                        glRotatef(m_pCurAngle.z, 0, 0, 1);
                        glScalef(m_pCurScale.x,m_pCurScale.y,m_pCurScale.z);
                        
                        [self SetColor:mColorBack];
                        
                        if(m_bBack==YES){
                            glBindTexture(GL_TEXTURE_2D, -1);
                            glDrawArrays(GL_TRIANGLE_STRIP,0,m_iCountVertex);
                        }
                        

                        mTextureId=[m_pObjMng->pStringContainer->ArrayPoints
                                                 GetResAtIndex:pStartData[0]];
                        glBindTexture(GL_TEXTURE_2D, mTextureId);
                        
                        glScalef(0.9f,0.9f,m_pCurScale.z);
                        [self SetColor:mColor];
                        
                        glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
                    }
                    break;
                    
                    case DATA_SPRITE:
                    {
                        glVertexPointer(3, GL_FLOAT, 0, vertices);
                        glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
                        glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
                        
                        glTranslatef(m_pCurPosition.x+m_pObjMng->m_pParent->m_vOffset.x*m_fScaleOffset,
                                     m_pCurPosition.y+m_pObjMng->m_pParent->m_vOffset.y*m_fScaleOffset,
                                     m_pCurPosition.z);
                        
                        glRotatef(m_pCurAngle.z, 0, 0, 1);
                        glScalef(m_pCurScale.x,m_pCurScale.y,m_pCurScale.z);
                        
                        [self SetColor:mColorBack];
                        
                        glBindTexture(GL_TEXTURE_2D, -1);
                        glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
                        
                        glBindTexture(GL_TEXTURE_2D, mTextureId);
                        
                        [self SetColor:mColor];
                        
                        glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
                        
                        //номер
//                        [self UpdateTextureOnFace];
//                        
//                        [self drawTextAtX:m_pCurPosition.x-14 Y:m_pCurPosition.y-11
//                                    Color:Color3DMake(0,0,0,1) Tex:TextureIndicatorSprite];
//                        
//                        [self drawTextAtX:m_pCurPosition.x-16 Y:m_pCurPosition.y-12
//                                    Color:Color3DMake(1,1,1,1) Tex:TextureIndicatorSprite];
                    }
                    break;

                    case DATA_SOUND:
                    {
                        glVertexPointer(3, GL_FLOAT, 0, vertices);
                        glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
                        glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
                        
                        glTranslatef(m_pCurPosition.x+m_pObjMng->m_pParent->m_vOffset.x*m_fScaleOffset,
                                     m_pCurPosition.y+m_pObjMng->m_pParent->m_vOffset.y*m_fScaleOffset,
                                     m_pCurPosition.z);
                        
                        glRotatef(m_pCurAngle.z, 0, 0, 1);
                        glScalef(m_pCurScale.x,m_pCurScale.y,m_pCurScale.z);
                        
                        [self SetColor:mColorBack];
                        
                        glBindTexture(GL_TEXTURE_2D, -1);
                        glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
                        
                        glBindTexture(GL_TEXTURE_2D, mTextureId);
                        
                        [self SetColor:mColor];
                        
                        glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);                        
                    }
                    break;

                    default:
                        break;
                }
                
                if(pString->m_iAdditionalType==ADIT_TYPE_ENTER ||
                   pString->m_iAdditionalType==ADIT_TYPE_EXIT)
                {
                    glScalef(0.5f,0.5f,1);
                    glTranslatef(2.9f,1.0f,0);
                    
                    if(pString->m_iAdditionalType==ADIT_TYPE_ENTER)
                        glBindTexture(GL_TEXTURE_2D, mTextureIdEn);
                    else if(pString->m_iAdditionalType==ADIT_TYPE_EXIT)
                        glBindTexture(GL_TEXTURE_2D, mTextureIdEx);
                    else glBindTexture(GL_TEXTURE_2D, -1);
                    
                    glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
                    
                    glTranslatef(-2.9f,-1.0f,0);
                    glScalef(2,2,1);
                }
                
                
                if(pInfo->UnParentMatrix.indexMatrix!=0)
                {
                    MATRIXcell *pMatr = [m_pObjMng->pStringContainer->ArrayPoints
                     GetMatrixAtIndex:pInfo->UnParentMatrix.indexMatrix];
                    
                    if(pMatr!=0)
                    {
                        FractalString *pStringTmp=(FractalString *)
                                [m_pObjMng->pStringContainer->ArrayPoints
                                GetIdAtIndex:pMatr->iIndexString];
                        
                        if(pStringTmp!=0)
                        {
                            int iTextureMatrix;
                            GET_TEXTURE(iTextureMatrix, pStringTmp->sNameIcon);
                            
                            glScalef(0.5f,0.5f,1);
                            glTranslatef(-1.5f,-1.5f,0);
                            
                            glBindTexture(GL_TEXTURE_2D, iTextureMatrix);
                            glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
                        }
                    }
                }
                else
                {
                    glScalef(0.5f,0.5f,1);
                    glTranslatef(-1.5f,-1.5f,0);
                }
                
                if(![pString->sNameIcon2 isEqualToString:@"0.png"])
                {
               //     glScalef(0.5f,0.5f,1);
                    glTranslatef(3.0f,0.1f,0);
                    
                    int iTex=-1;
                    GET_TEXTURE(iTex, pString->sNameIcon2);
                    glBindTexture(GL_TEXTURE_2D, iTex);
                    
                    glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
                    
                    if(![pString->sNameIcon3 isEqualToString:@"0.png"])
                    {
                        glTranslatef(2.0f,0,0);
                        
                        int iTex=-1;
                        GET_TEXTURE(iTex, pString->sNameIcon3);
                        glBindTexture(GL_TEXTURE_2D, iTex);
                        
                        glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
                    }
                    
                }
                else if(![pString->sNameIcon3 isEqualToString:@"0.png"])
                {
            //        glScalef(0.5f,0.5f,1);
                    glTranslatef(3.0f,0.1f,0);
                    
                    int iTex=-1;
                    GET_TEXTURE(iTex, pString->sNameIcon3);
                    glBindTexture(GL_TEXTURE_2D, iTex);
                    
                    glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
                }

                
                [self UpdateTextureOnFace];
                [self drawTextAtX:m_pCurPosition.x Y:m_pCurPosition.y-35
                            Color:Color3DMake(1,1,1,1) Tex:TextureIndicatorValue];
            }
        }
        break;
            

        case DATA_MATRIX:
            
            glVertexPointer(3, GL_FLOAT, 0, vertices);
            glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
            glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
            
            glTranslatef(m_pCurPosition.x+m_pObjMng->m_pParent->m_vOffset.x*m_fScaleOffset,
                         m_pCurPosition.y+m_pObjMng->m_pParent->m_vOffset.y*m_fScaleOffset,
                         m_pCurPosition.z);
            
            glRotatef(m_pCurAngle.z, 0, 0, 1);
            glScalef(m_pCurScale.x,m_pCurScale.y,m_pCurScale.z);
            
            [self SetColor:mColorBack];
            
            if(m_bBack==YES){
                glBindTexture(GL_TEXTURE_2D, -1);
                glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
            }
            
            glBindTexture(GL_TEXTURE_2D, mTextureId);
            
            [self SetColor:mColor];
            
            glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);

            if(![pString->sNameIcon2 isEqualToString:@"0.png"])
            {
                glScalef(0.5f,0.5f,1);
                glTranslatef(1.0f,-1.5f,0);
                
                int iTex=-1;
                GET_TEXTURE(iTex, pString->sNameIcon2);
                glBindTexture(GL_TEXTURE_2D, iTex);
                
                glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
                
                if(![pString->sNameIcon3 isEqualToString:@"0.png"])
                {
                    glTranslatef(2.0f,0,0);
                    
                    int iTex=-1;
                    GET_TEXTURE(iTex, pString->sNameIcon3);
                    glBindTexture(GL_TEXTURE_2D, iTex);
                    
                    glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
                }

            }
            else if(![pString->sNameIcon3 isEqualToString:@"0.png"])
            {
                glScalef(0.5f,0.5f,1);
                glTranslatef(1.0f,-1.5f,0);
                
                int iTex=-1;
                GET_TEXTURE(iTex, pString->sNameIcon3);
                glBindTexture(GL_TEXTURE_2D, iTex);
                
                glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
            }

            break;
            
        default:
            break;
    }
    
    int iCount=[m_pObjMng->pStringContainer->ArrayPoints GetCountAtIndex:pString->m_iIndex];
    //рисуем количество ассоциаций
    if(iCount>1){
        if(m_iTypeStr==DATA_MATRIX)
        {
            MATRIXcell *pMatrTmp = [m_pObjMng->pStringContainer->ArrayPoints
                                 GetMatrixAtIndex:pString->m_iIndex];

            InfoArrayValue *pInfoLink=(InfoArrayValue *)*pMatrTmp->pLinks;
            iCount=pInfoLink->mCount;
        }
        NSString *pStr = [NSString stringWithFormat:@"%d",iCount];
        
        if(![StrValueOnLink isEqualToString:pStr])
        {
            [StrValueOnLink release];
            StrValueOnLink=[[NSString stringWithString:pStr] retain];
            
            int iFontSize=14;
            TextureIndicatorLink=[self CreateText:StrValueOnLink al:UITextAlignmentRight
                                       Tex:TextureIndicatorLink fSize:iFontSize
                                       dimensions:CGSizeMake(mWidth-15, iFontSize+4)
                                       fontName:@"Gill Sans"];
        }
    }
    
    if (TextureIndicatorLink!=nil) {
        [self drawTextAtX:m_pCurPosition.x-58 Y:m_pCurPosition.y-18
                    Color:Color3DMake(0,1,0,1) Tex:TextureIndicatorLink];
    }
    
    if(TexIndicatrorQueue!=nil){
        [self drawTextAtX:m_pCurPosition.x+33 Y:m_pCurPosition.y-18
                    Color:Color3DMake(0,1,0,1) Tex:TexIndicatrorQueue];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    
    [self SetTouch:NO];
    
    [TextureIndicatorLink release];
    TextureIndicatorLink=0;
    [TextureIndicatorValue release];
    TextureIndicatorValue=0;
    [StrValueOnFace release];
    StrValueOnFace=0;
    [StrValueOnLink release];
    StrValueOnLink=0;
    
    [TexIndicatrorQueue release];
    TexIndicatrorQueue=0;
    
    [super Destroy];
}
//------------------------------------------------------------------------------------------------------

@end