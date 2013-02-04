//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_IconDrag.h"
#import "ObjectB_Ob.h"
#import "ObB_DropBox.h"
#import "DropBoxMng.h"
#import "Ob_Editor_Interface.h"

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
    
    if(pNewString->X<-440)pNewString->X=-440;
    if(pNewString->X>-40)pNewString->X=-40;
    
    if(pNewString->Y<-280)pNewString->Y=-280;
    if(pNewString->Y>170)pNewString->Y=170;
}
//------------------------------------------------------------------------------------------------------
- (void)EndObject{

    PLAY_SOUND(@"drop.wav");
    
    DropBoxMng *pODropBox = (DropBoxMng *)[m_pObjMng GetObjectByName:@"DropBox"];
    
    int *pMode=GET_INT_V(@"m_iMode");
    Ob_Editor_Interface *Interface=(Ob_Editor_Interface *)
                [m_pObjMng GetObjectByName:@"Ob_Editor_Interface"];
    
    GObject *pObTash=nil;
    if(Interface!=nil)
        pObTash=Interface->BTash;

    FractalString *pParent = GET_ID_V(@"ParentString");
    FractalString *pDropBoxStr = [m_pObjMng->pStringContainer GetString:@"DropBox"];

    CGPoint Point;
    Point.x=m_pCurPosition.x;
    Point.y=m_pCurPosition.y;

    GObject *pObGroup = [m_pObjMng GetObjectByName:@"GroupButtons"];
    bool *pNeedUpload=GET_BOOL_V(@"bNeedUpload");

    if([pObTash Intersect:Point] &&  pNeedUpload!=0 && pMode!=0){

        if(*pMode==3){
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
        if(pMode!=0 && *pMode==3){
            if(m_pCurPosition.y<202 && pInsideString!=nil){
         //       if(pParent!=pInsideString){//сохранение в DropBox

                    if(bFromEmpty==YES)
                    {                        
                        if(pInsideString->m_iFlags & (SYNH_AND_LOAD|ONLY_IN_MEM)){
                            FractalString *pNewString =[[FractalString alloc] initAsCopy:pInsideString
                                    WithParent:pDropBoxStr WithContainer:m_pObjMng->pStringContainer
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
             //       }
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
        }
        else
        {
            bool bInside=NO;
            if(pObGroup!=nil)//копирование струны в пространстве
            {
                for (ObjectB_Ob *pObob in pObGroup->m_pChildrenbjectsArr)
                {
                    if([pObob Intersect:Point])
                    {
                        pParent=pObob->pString;
                        bInside=YES;
                        
                        goto Exit;
                    }
                }
            }
Exit:
            if(m_pCurPosition.y<202 && pInsideString!=nil &&
               ![pInsideString->strUID isEqualToString:@"Objects"]){

                if(pParent!=pInsideString){
                    FractalString *pNewString =[[FractalString alloc] initAsCopy:pInsideString
                                WithParent:pParent WithContainer:m_pObjMng->pStringContainer
                                                WithLink:NO];

                    if(bInside==YES){
                        
                        pNewString->X=-440;
                        pNewString->Y=170;
                    }
                    else [self SetPos:pNewString];
                }
            }
            else if(m_pCurPosition.y<202){

                FractalString *pNewString =[[FractalString alloc]
                        initWithName:@"EmptyOb" WithParent:pParent
                                    WithContainer:m_pObjMng->pStringContainer];

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