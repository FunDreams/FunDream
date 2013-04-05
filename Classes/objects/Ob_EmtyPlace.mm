//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_EmtyPlace.h"
#import "UniCell.h"
#import "Ob_IconDrag.h"
#import "ObjectB_Ob.h"
#import "ObB_DropBox.h"
#import "Ob_GroupButtons.h"
#import "DropBoxMng.h"
#import "Ob_Editor_Interface.h"

@implementation Ob_EmtyPlace
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_Disable=false;
        m_iLayer = layerInterfaceSpace4;
        m_iLayerTouch=layerTouch_3N;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{
    mColor.red=1;
    mColor.green=1;
    mColor.blue=1;
    mColor.alpha=1;
    
    m_pOwner=nil;
    
    m_bNotPush=NO;
    m_bHiden=NO;
    m_bPush=NO;
    m_bCheck=NO;

    [m_strNameSound setString:@""];
    [m_strNameStage setString:@""];
    [m_strNameObject setString:@""];

    [m_strNameStageDClick setString:@""];
    [m_strNameObjectDClick setString:@""];
    
    mColorBack = Color3DMake(0, 1, 0, 1);
    
    pStrInside = [m_pObjMng->pStringContainer GetString:@"Objects"];

    m_bBack=NO;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];

    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bIsPush,m_strName,@"m_bIsPush")];

    [m_pObjMng->pMegaTree SetCell:LINK_COLOR_V(mColorBack,m_strName,@"mColorBack")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bBack,m_strName,@"m_bBack")];

    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bNotPush,m_strName,@"m_bNotPush")];

    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimFromTexture,m_strName,@"m_bDimFromTexture")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimMirrorX,m_strName,@"m_bDimMirrorX")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY")];
    
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

    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(m_Disable,m_strName,@"m_Disable")];
    
    [m_pObjMng->pMegaTree SetCell:LINK_INT_V(m_iCurIndex,m_strName,@"m_iCurIndex")];


//    pProc = [self START_QUEUE:@"Proc"];
//    
//        ASSIGN_STAGE(@"Idle",@"Proc:",nil);
//    
//    [self END_QUEUE:pProc name:@"Proc"];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

    if(m_bDimFromTexture){GET_DIM_FROM_TEXTURE(m_pNameTexture);}

	[super Start];
    [self SetTouch:YES];

    if(m_bDimMirrorX==YES){m_pCurScale.x=-m_pCurScale.x;}
    if(m_bDimMirrorY==YES){m_pCurScale.y=-m_pCurScale.y;}

	m_vStartPos=m_pCurPosition;

    m_vStartPos=m_pCurPosition;
    m_vEndPos=m_pCurPosition;
    m_vEndPos.y-=1000;

    if(m_bIsPush)
        [self SetPush];

    FractalString *pStrChelf = [m_pObjMng->pStringContainer GetString:@"ChelfStirngs"];
    if(pStrChelf!=nil){

        MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:pStrChelf->m_iIndex];

        int index=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[m_iCurIndex];
        NSMutableString *Name=[m_pObjMng->pStringContainer->ArrayPoints
                               GetIdAtIndex:index];

        FractalString *pCurStr = [m_pObjMng->pStringContainer GetString:Name];
        pStrInside=pCurStr;
    }
    else pStrInside = [m_pObjMng->pStringContainer GetString:@"Objects"];
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
    
    
    Ob_GroupButtons *GrButt = (Ob_GroupButtons *)[m_pObjMng GetObjectByName:@"GroupButtons"];
    
    if(GrButt!=nil)
    {
        [GrButt SetString:pStrInside];
    }
    
    [m_pObjMng->pMegaTree SetCell:LINK_ID_V(self,@"ObPushEmPlace")];
    OBJECT_PERFORM_SEL(m_strNameObject, m_strNameStage);    
}
//------------------------------------------------------------------------------------------------------
- (void)DoubleTouch:(Processor_ex *)pProc{
    
    m_bDoubleTouch=NO;
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    m_bStartPush=YES;    
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{

    int *pMode=GET_INT_V(@"m_iMode");
    
    if(m_bStartMove==NO && m_bStartPush==YES){
        
        Ob_IconDrag *pOb=UNFROZE_OBJECT(@"Ob_IconDrag",@"IconDrag",
                                        SET_FLOAT_V(44,@"mWidth"),
                                        SET_FLOAT_V(44,@"mHeight"),
                                        SET_BOOL_V(YES,@"bFromEmpty"),
                                        SET_VECTOR_V(m_pCurPosition,@"m_pCurPosition"),
                                        SET_STRING_V(pStrInside->sNameIcon,@"m_pNameTexture"));
        
        pOb->pInsideString=pStrInside;
        m_bStartMove=YES;
        
        int TmpIndexTexture=-1;
        GET_TEXTURE(TmpIndexTexture, @"EmptyPlace.png");
        
        if(mTextureId!=TmpIndexTexture && pStrInside!=nil){
            [m_pObjMng->pMegaTree SetCell:(LINK_ID_V(pStrInside,@"DragObject"))];
            [m_pObjMng->pMegaTree SetCell:(SET_BOOL_V(YES,@"FromPlace"))];
            
            
            if(pMode!=0 && *pMode==M_MOVE){
                [self SetEmpty];
            }
        }
        else [m_pObjMng->pMegaTree SetCell:(LINK_ID_V(pOb,@"EmptyOb"))];
    }
}
//------------------------------------------------------------------------------------------------------
//- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
//    [self SetUnPush];
//    m_bStartPush=NO;
//    m_bStartMove=NO;
//}
//------------------------------------------------------------------------------------------------------
- (void)SetNameStr:(FractalString *)StrTmp{

    FractalString *pChelf = [m_pObjMng->pStringContainer GetString:@"ChelfStirngs"];

    if(pChelf!=nil){
        MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:pChelf->m_iIndex];
        
        InfoArrayValue *pInfo=(InfoArrayValue *)(*pMatr->pValueCopy);
        
        for (int i=0; i<pInfo->mCount; i++) {
            
            if(i==m_iCurIndex)continue;
            int index=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[i];
            NSMutableString *pName=[m_pObjMng->pStringContainer->ArrayPoints
                                    GetIdAtIndex:index];
            
            if([pName isEqualToString:StrTmp->strUID])
                [pName setString:@"Objects"];
        }
        
        int index=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[m_iCurIndex];
        NSMutableString *pName=[m_pObjMng->pStringContainer->ArrayPoints
                               GetIdAtIndex:index];

        [pName setString:StrTmp->strUID];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetEmpty{
    FractalString *pChelf = [m_pObjMng->pStringContainer GetString:@"ChelfStirngs"];
    
    if(pChelf!=nil){
        MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:pChelf->m_iIndex];

        int index=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[m_iCurIndex];
        NSMutableString *pName=[m_pObjMng->pStringContainer->ArrayPoints
                                GetIdAtIndex:index];
        [pName setString:@"Objects"];
    }

    pStrInside = [m_pObjMng->pStringContainer GetString:@"Objects"];
    GET_TEXTURE(mTextureId, @"EmptyPlace.png");
}
//------------------------------------------------------------------------------------------------------
- (void)Click{
    if(m_bPush==NO)PLAY_SOUND(@"chekbox1.wav");
    
    FractalString *pStrCheck = [m_pObjMng->pStringContainer GetString:@"CurrentCheck"];
    if(pStrCheck!=nil){
        MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints GetMatrixAtIndex:pStrCheck->m_iIndex];

        int index=(*pMatr->pValueCopy+SIZE_INFO_STRUCT)[1];
        int *FChelf=(int *)[m_pObjMng->pStringContainer->ArrayPoints
                            GetDataAtIndex:index];
        (*FChelf)=(float)m_iCurIndex;
    }
    
    [self SetPush];
    OBJECT_PERFORM_SEL(@"Ob_Editor_Interface",@"UpdateB");
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    FractalString *DragObjectDropBoxStr = GET_ID_V(@"DropBoxString");
    FractalString *pObObTmpStr = GET_ID_V(@"DragObject");

    bool *bFromPlace=GET_BOOL_V(@"FromPlace");
    GObject *pObObE = GET_ID_V(@"EmptyOb");
    int *pMode=GET_INT_V(@"m_iMode");

    if(DragObjectDropBoxStr!=nil)
    {
        switch (DragObjectDropBoxStr->m_iFlags) {
            case ONLY_IN_MEM:
            case SYNH_AND_LOAD:
            {
                [self SetNameStr:DragObjectDropBoxStr];
            }
            break;
                
            case SYNH_AND_HEAD:
            {
                DropBoxMng *pODropBox = (DropBoxMng *)[m_pObjMng GetObjectByName:@"DropBox"];

                if(pODropBox!=nil){
                //    [self SetNameStr:DragObjectDropBoxStr];
                    [pODropBox DownLoadString:DragObjectDropBoxStr WithPlace:m_iCurIndex];
                }
            }
            break;
                
            default:
                break;
        }
        
        DEL_CELL(@"DropBoxString");
        DEL_CELL(@"DragObject");
        OBJECT_PERFORM_SEL(@"Ob_Editor_Interface",@"UpdateB");
    }
    else
    {
        if(pObObE==nil && pObObTmpStr==nil)
        {
            goto FINISH;
        }
        else if(pObObTmpStr!=nil && bFromPlace && *bFromPlace==YES){
            pStrInside = pObObTmpStr;
            GET_TEXTURE(mTextureId, pObObTmpStr->sNameIcon);
            
            [self SetNameStr:pStrInside];
            
            DEL_CELL(@"DragObject");
            DEL_CELL(@"FromPlace");
        }
        else if(pObObTmpStr!=nil && pMode!=0 && (*pMode)!=M_MOVE){

            pStrInside = pObObTmpStr;
            GET_TEXTURE(mTextureId, pObObTmpStr->sNameIcon);
            
            [self SetNameStr:pStrInside];
            
            DEL_CELL(@"DragObject");
        }
        else if(pObObE!=nil){

            [self SetEmpty];
            DEL_CELL(@"EmptyOb");
        }
    }

FINISH:
    if(m_bStartPush==YES)[self Click];
    
    m_bStartPush=NO;
    m_bStartMove=NO;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEndedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    m_bStartPush=NO;
    m_bStartMove=NO;
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    
    [self SetTouch:NO];
    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
@end