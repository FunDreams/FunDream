//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_IconDrag.h"
#import "ObjectB_Ob.h"

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

    [m_pObjMng->pMegaTree SetCell:LINK_INT_V(mTextureId,m_strName,@"mTextureId")];
//====//различные параметры=============================================================================
//   [m_pObjMng->pMegaTree SetCell:(LINK_BOOL_V(m_bDimMirrorY,m_strName,@"m_bDimMirrorY"));
    
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    [m_pObjMng->pMegaTree SetCell:(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"))];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

    int TmpTexture=mTextureId;
	[super Start];
    mTextureId=TmpTexture;

    [self SetTouch:YES];//интерактивность
//    GET_TEXTURE(mTextureId, m_pNameTexture);
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
    
    int *pMode=GET_INT_V(@"m_iMode");
    GObject *pObTash=[m_pObjMng GetObjectByName:@"ButtonTach"];
    
    FractalString *pParent = GET_ID_V(@"ParentString");
    FractalString *pDropBoxStr = [m_pObjMng->pStringContainer GetString:@"DropBox"];
    
    CGPoint Point;
    Point.x=m_pCurPosition.x;
    Point.y=m_pCurPosition.y;
    
    GObject *pObGroup = [m_pObjMng GetObjectByName:@"GroupButtons"];
    
    if([pObTash Intersect:Point]){
        //delete
    }
    else{
        if(pMode!=0 && *pMode==3){
            if(m_pCurPosition.y<202 && pInsideString!=nil){
                if(pParent!=pInsideString){

                    FractalString *pNewString =[[FractalString alloc] initAsCopy:pInsideString
                            WithParent:pDropBoxStr WithContainer:m_pObjMng->pStringContainer];

                    [self SetPos:pNewString];
                    OBJECT_PERFORM_SEL(@"DropBox",@"UpdateButt");
                }
            }
        }
        else
        {
            if(pObGroup!=nil)
            {
                for (ObjectB_Ob *pObob in pObGroup->m_pChildrenbjectsArr)
                {
                    if([pObob Intersect:Point])
                    {
                        pParent=pObob->pString;
                        
                        goto Exit;
                    }
                }
            }
Exit:
            if(m_pCurPosition.y<202 && pInsideString!=nil &&
               ![pInsideString->strName isEqualToString:@"Objects"]){

                if(pParent!=pInsideString){
                    FractalString *pNewString =[[FractalString alloc] initAsCopy:pInsideString
                                           WithParent:pParent WithContainer:m_pObjMng->pStringContainer];

                    [self SetPos:pNewString];
                    OBJECT_PERFORM_SEL(@"GroupButtons",@"UpdateButt");
                }
            }
            else if(m_pCurPosition.y<202){

                FractalString *pNewString =[[FractalString alloc] initWithName:@"EmptyOb" WithParent:pParent
                 WithContainer:m_pObjMng->pStringContainer
                    S:m_pObjMng->pStringContainer->iIndexZero F:m_pObjMng->pStringContainer->iIndexZero];

                [self SetPos:pNewString];
                OBJECT_PERFORM_SEL(@"GroupButtons",@"UpdateButt");
            }
        }
    }
    
    DEL_CELL(@"DragObject");
    DEL_CELL(@"EmptyOb");

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