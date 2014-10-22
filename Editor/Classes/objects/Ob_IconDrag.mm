//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_IconDrag.h"
#import "Ob_IconDragArray.h"
#import "ObjectB_Ob.h"
#import "ObB_DropBox.h"
#import "DropBoxMng.h"
#import "Ob_Editor_Interface.h"
#import "ObjectB_Ob_Array.h"

@implementation Ob_IconDrag
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerInterfaceSpace9;
        m_iLayerTouch=layerTouch_2N;//слой касания
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault
{
    m_bHiden=NO;
    bFromEmpty=NO;
}
//- (void)PostSetParams{}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
//====//процессоры для объекта==========================================================================
    [m_pObjMng->pMegaTree SetCell:LINK_INT_V(mTextureId,m_strName,@"mTextureId")];
    [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(bFromEmpty,m_strName,@"bFromEmpty")];
//====//различные параметры=============================================================================
//   [m_pObjMng->pMegaTree SetCell:(LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY"));
    
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    [m_pObjMng->pMegaTree SetCell:(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"))];
    
    Processor_ex* pProc = [self START_QUEUE:@"Proc"];
        //ASSIGN_STAGE(@"IDLE",@"Idle:",nil);
        ASSIGN_STAGE(@"PROC",@"Proc:",nil);
    [self END_QUEUE:pProc name:@"Proc"];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

 //   int TmpTexture=mTextureId;
	[super Start];
//    mTextureId=TmpTexture;

    GET_TEXTURE(mTextureId, m_pNameTexture);
    [self SetTouch:YES];//интерактивность
}
//------------------------------------------------------------------------------------------------------
- (void)SetPos:(FractalString *)pNewString{
    
    pNewString->X=m_pCurPosition.x;
    pNewString->Y=m_pCurPosition.y;
    
    if(pNewString->X<-480)pNewString->X=-480;
    if(pNewString->X>-25)pNewString->X=-25;
    
    if(pNewString->Y<-350)pNewString->Y=-350;
    if(pNewString->Y>258)pNewString->Y=258;
}
//------------------------------------------------------------------------------------------------------
- (void)EndObject{

    CGPoint Point;
    Point.x=m_pCurPosition.x;
    Point.y=m_pCurPosition.y;

    PLAY_SOUND(@"drop.wav");
    Ob_Editor_Interface *Interface=(Ob_Editor_Interface *)
    [m_pObjMng GetObjectByName:@"Ob_Editor_Interface"];
    
    if(pInsideString!=0)
    {
        int iType=[m_pObjMng->pStringContainer->ArrayPoints
                   GetTypeAtIndex:Interface->ButtonGroup->pInsideString->m_iIndex];

        int iType2=[m_pObjMng->pStringContainer->ArrayPoints
                   GetTypeAtIndex:pInsideString->m_iIndex];

        if(iType==DATA_ARRAY)
        {
            if(iType2==DATA_ARRAY)
            {
                int **ppArray1=[m_pObjMng->pStringContainer->ArrayPoints
                                GetArrayAtIndex:Interface->ButtonGroup->pInsideString->m_iIndex];

                int **ppArray2=[m_pObjMng->pStringContainer->ArrayPoints
                                                        GetArrayAtIndex:pInsideString->m_iIndex];

                InfoArrayValue *pInfo1=(InfoArrayValue *)*ppArray1;
                InfoArrayValue *pInfo2=(InfoArrayValue *)*ppArray2;
                if(pInfo1->mType==pInfo2->mType && pInfo1->mType!=DATA_U_INT)
                {
                    for (ObjectB_Ob_Array* pOb in Interface->ButtonGroup->m_pChildrenbjectsArr)
                    {
                        if([pOb Intersect:Point])
                        {
                            int *pTmpIndex=(*ppArray1+SIZE_INFO_STRUCT+pOb->m_iNum);
                            int tmpPlace=pInsideString->m_iCurState;
                            if(pInfo2->mCount<tmpPlace)tmpPlace=pInfo2->mCount;

                            int *pTmpIndex2=(*ppArray2+SIZE_INFO_STRUCT+tmpPlace);
                            [m_pObjMng->pStringContainer->ArrayPoints DecDataAtIndex:*pTmpIndex];
                            [m_pObjMng->pStringContainer->ArrayPoints IncDataAtIndex:*pTmpIndex2];

                            *pTmpIndex=*pTmpIndex2;
                        }
                    }
                }
            }
            
            OBJECT_PERFORM_SEL(@"Ob_Editor_Interface",@"UpdateB");
            DESTROY_OBJECT(self);
            return;
        }
    }
    
    DropBoxMng *pODropBox = (DropBoxMng *)[m_pObjMng GetObjectByName:@"DropBox"];
    
    int *pMode=GET_INT_V(@"m_iMode");
    
    GObject *pObTash=nil;
    if(Interface!=nil)
        pObTash=Interface->BTash;

    FractalString *pParent = GET_ID_V(@"ParentString");
    FractalString *pDropBoxStr = [m_pObjMng->pStringContainer GetString:@"DropBox"];

 //   GObject *pObGroup = [m_pObjMng GetObjectByName:@"GroupButtons"];
    bool *pNeedUpload=GET_BOOL_V(@"bNeedUpload");

    if([pObTash Intersect:Point] &&  pNeedUpload!=0 && pMode!=M_MOVE){

        if(*pMode==M_DROP_BOX){
            switch (pInsideString->m_iFlags){
                case DEAD_STRING:{
                    
                    CDataManager* pDataCurManager =[m_pObjMng->pStringContainer->
                                                    ArrayDumpFiles objectAtIndex:0];
                    
                    [pDataCurManager DelFileFromDropBox:pInsideString->strUID];
                    
                    [m_pObjMng->pStringContainer DelString:pInsideString];
                    pInsideString=0;
                    *pNeedUpload=YES;
                }
                break;

                case SYNH_AND_HEAD:{
                    CDataManager* pDataCurManager =[m_pObjMng->pStringContainer->
                                                    ArrayDumpFiles objectAtIndex:0];

                    [pDataCurManager DelFileFromDropBox:pInsideString->strUID];
                    [m_pObjMng->pStringContainer DelString:pInsideString];
                    *pNeedUpload=YES;
                }
                break;

                case SYNH_AND_LOAD:{
                    //del childs
                    [m_pObjMng->pStringContainer DelChilds:pInsideString];
                    [pInsideString SetFlag:SYNH_AND_HEAD];
                    
                    *pNeedUpload=YES;
                }
                break;

                case ONLY_IN_MEM:{
                    
                    [pODropBox DefFromUploadString:pInsideString];

                    [m_pObjMng->pStringContainer DelString:pInsideString];
                    pInsideString=0;
                    *pNeedUpload=YES;
                }
                break;

                default:
                    break;
            }
        }
    }
    else
    {
        if(pMode!=0 && *pMode==M_DROP_BOX)
        {
            if(m_pCurPosition.y<286 && pInsideString!=nil){

                if(bFromEmpty==YES)
                {
                    int iType=[m_pObjMng->pStringContainer->ArrayPoints
                               GetTypeAtIndex:pInsideString->m_iIndex];

                    if(iType==DATA_MATRIX)
                    {
                        MATRIXcell *pMatrTmp=[m_pObjMng->pStringContainer->ArrayPoints
                                           GetMatrixAtIndex:pInsideString->m_iIndex];
                        
                        if(pMatrTmp->TypeInformation==STR_COMPLEX)
                        {
                            if(pInsideString->m_iFlags & (SYNH_AND_LOAD|ONLY_IN_MEM))
                            {
                                FractalString *pNewString =[[FractalString alloc] initAsCopy:pInsideString
                                        WithParent:pDropBoxStr
                                        WithContainer:m_pObjMng->pStringContainer
                                        WithSourceContainer:m_pObjMng->pStringContainer
                                                            WithLink:NO];
                                
                                [self SetPos:pNewString];
                                
                                bool *pNeedUpload=GET_BOOL_V(@"bNeedUpload");
                                
                                if(pNeedUpload!=0){
                                    *pNeedUpload=YES;
                                }
                                
                                //add to save
                                [pODropBox AddToUploadString:pNewString];
                                [pNewString SetFlag:ONLY_IN_MEM];                        
                            }
                        }
                    }
                }
                else
                {
                    FractalString *DragObjectDropBox = GET_ID_V(@"DropBoxString");

                    if(DragObjectDropBox!=nil){

                        [self SetPos:DragObjectDropBox];
                    }
                    
                    bool *pNeedUpload=GET_BOOL_V(@"bNeedUpload");
                    
                    if(pNeedUpload!=0){
                        *pNeedUpload=YES;
                    }
                }
            }
        }
        else
        {
Exit:
            if(m_pCurPosition.y<285 && pInsideString!=nil &&
               ![pInsideString->strUID isEqualToString:@"Objects"]){

                bool bLink=NO;
                if(*pMode==M_LINK)bLink=YES;
                int iType=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:pInsideString->m_iIndex];

                if(bLink==YES && iType==DATA_ARRAY)
                {
                    InfoArrayValue *pInfoparentChild = (InfoArrayValue *)(*pParent->pChildString);
                    int *sData=(*pParent->pChildString)+SIZE_INFO_STRUCT;
                    bool ThisIs=NO;
                    
                    for(int i=0;i<pInfoparentChild->mCount;i++)
                    {
                        int iIndex=sData[i];
                        
                        FractalString *Fstr=[m_pObjMng->pStringContainer->ArrayPoints GetIdAtIndex:iIndex];
                        if(pInsideString->m_iIndex==Fstr->m_iIndex)
                        {
                            ThisIs=YES;
                            break;
                        }
                    }
                    
                    if(ThisIs==NO)
                    {
                        FractalString *pSourceStr=pInsideString;
                        
                        FractalString *pNewString =[[FractalString alloc] initAsCopy:pSourceStr
                                            WithParent:pParent WithContainer:m_pObjMng->pStringContainer
                                            WithSourceContainer:m_pObjMng->pStringContainer
                                            WithLink:bLink];

                        [self SetPos:pNewString];
                    }
                }
                else
                {
                    FractalString *pSourceStr=pInsideString;

                    FractalString *pNewString =[[FractalString alloc] initAsCopy:pSourceStr
                                        WithParent:pParent WithContainer:m_pObjMng->pStringContainer
                                        WithSourceContainer:m_pObjMng->pStringContainer
                                        WithLink:bLink];

                    [self SetPos:pNewString];
                }
            }
            else if(m_pCurPosition.y<285){

                FractalString *pNewString =[[FractalString alloc]
                        initWithName:@"EmptyOb" WithParent:pParent
                                    WithContainer:m_pObjMng->pStringContainer];

                MATRIXcell *pMatrPar=[m_pObjMng->pStringContainer->ArrayPoints
                                      GetMatrixAtIndex:pParent->m_iIndex];
                
                pNewString->m_iIndex=[m_pObjMng->pStringContainer->ArrayPoints SetMatrix:0];
                [m_pObjMng->pStringContainer->m_OperationIndex AddData:pNewString->m_iIndex
                                            WithData:pMatrPar->pValueCopy];
                
                MATRIXcell *pMatrNew=[m_pObjMng->pStringContainer->ArrayPoints
                                       GetMatrixAtIndex:pNewString->m_iIndex];
                
                pMatrNew->TypeInformation=STR_COMPLEX;
                pMatrNew->NameInformation=STR_SIMPLE;
                pMatrNew->iIndexString=pNewString->m_iIndexSelf;

                [self SetPos:pNewString];
            }
        }
    }
    
    OBJECT_PERFORM_SEL(@"Ob_Editor_Interface",@"UpdateB");
    DESTROY_OBJECT(self);
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
- (void)Destroy{
    pInsideString=nil;
    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    m_pCurPosition.x=Point.x;
    m_pCurPosition.y=Point.y;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    m_pCurPosition.x=Point.x;
    m_pCurPosition.y=Point.y;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    [self EndObject];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEndedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    [self EndObject];
}
//------------------------------------------------------------------------------------------------------
@end