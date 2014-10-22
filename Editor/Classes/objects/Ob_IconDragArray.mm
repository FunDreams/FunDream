//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_IconDragArray.h"
#import "ObjectB_Ob.h"
#import "ObB_DropBox.h"
#import "DropBoxMng.h"
#import "Ob_Editor_Interface.h"
#import "ObjectB_Ob_Array.h"

@implementation Ob_IconDragArray
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
}
//- (void)PostSetParams{}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
//====//процессоры для объекта==========================================================================
    [m_pObjMng->pMegaTree SetCell:LINK_INT_V(mTextureId,m_strName,@"mTextureId")];
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

    PLAY_SOUND(@"drop.wav");
    
    int *pMode=GET_INT_V(@"m_iMode");
    Ob_Editor_Interface *Interface=(Ob_Editor_Interface *)
    [m_pObjMng GetObjectByName:@"Ob_Editor_Interface"];
    
    int **ppArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:m_iArrayIndex];
    InfoArrayValue *pInfo = (InfoArrayValue *)(*ppArray);
    int TmpIndexValue=((*ppArray)+SIZE_INFO_STRUCT)[NumInArray];
    
    GObject *pObTash=nil;
    if(Interface!=nil)
        pObTash=Interface->BTash;
    
    CGPoint Point;
    Point.x=m_pCurPosition.x;
    Point.y=m_pCurPosition.y;

    if([pObTash Intersect:Point])
    {
        if((pInfo->mType==DATA_FLOAT || pInfo->mType==DATA_TEXTURE || pInfo->mType==DATA_SOUND
            || pInfo->mType==DATA_SPRITE || pInfo->mType==DATA_INT)
           && pInfo->mCount>1 && pInfo->UnParentMatrix.indexMatrix!=0 && NumInArray!=0)
        {
            
            MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints
                               GetMatrixAtIndex:pInfo->UnParentMatrix.indexMatrix];
            if(pMatr!=0)
            {
                InfoArrayValue *pInfoDataMatr=(InfoArrayValue *)*pMatr->ppDataMartix;
                
                bool bDec=NO;

                for (int i=0; i<pInfoDataMatr->mCount; i++)
                {
                    int iIndexTmp=(*pMatr->ppDataMartix+SIZE_INFO_STRUCT)[i];
                    
                    int **ppTmpArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:iIndexTmp];
                    InfoArrayValue *pInfoTmpArray=(InfoArrayValue *)*ppTmpArray;
                    
                    if(pInfoTmpArray->mType==DATA_U_INT)
                    {
repeate:
                        int iPlace=[m_pObjMng->pStringContainer->m_OperationIndex
                                    FindIndex:NumInArray WithData:ppTmpArray];
                                                
                        while (iPlace!=-1)
                        {
                            [m_pObjMng->pStringContainer->m_OperationIndex
                             OnlyRemoveDataAtPlaceSort:iPlace WithData:ppTmpArray];

                            goto repeate;
                        }
                        
                        pInfoTmpArray=(InfoArrayValue *)*ppTmpArray;
                        for (int j=0; j<pInfoTmpArray->mCount; j++) {
                            
                            int TmpValue=((*ppTmpArray)+SIZE_INFO_STRUCT)[j];
                            
                            if(TmpValue>NumInArray)
                            {
                                ((*ppTmpArray)+SIZE_INFO_STRUCT)[j]-=1;
                            }
                        }
                    }
                    else
                    {
                        if(bDec==NO)
                        {
                            pMatr->iDimMatrix--;
                            bDec=YES;
                        }
                        
                        int TmpIndexValue2=((*ppTmpArray)+SIZE_INFO_STRUCT)[NumInArray];
                        [m_pObjMng->pStringContainer->ArrayPoints DecDataAtIndex:TmpIndexValue2];
                        
                        [m_pObjMng->pStringContainer->m_OperationIndex
                         OnlyRemoveDataAtPlaceSort:NumInArray WithData:ppTmpArray];
                    }
                }                
            }
        }
        else
        {
            if(pInfo->mType==DATA_U_INT && pInfo->mCount>0){
                
                [m_pObjMng->pStringContainer->m_OperationIndex
                 OnlyRemoveDataAtPlaceSort:NumInArray WithData:ppArray];
            }
        }
    }
    else if(*pMode==M_MOVE){
        
        int NumInsert=pInfo->mCount;
        
        for (ObjectB_Ob_Array *pObTmp in Interface->ButtonGroup->m_pChildrenbjectsArr)
        {
            if([pObTmp Intersect:Point])
            {
                NumInsert=pObTmp->m_iNum;
                break;
            }
        }

    //    if(pInfo->mType==DATA_U_INT)
      //  {
            if(pInfo->mType!=DATA_U_INT)
                [m_pObjMng->pStringContainer->ArrayPoints IncDataAtIndex:TmpIndexValue];
            
            [m_pObjMng->pStringContainer->m_OperationIndex
             OnlyInsert:TmpIndexValue index:NumInsert WithData:ppArray];
            
            if(NumInsert<NumInArray)NumInArray+=1;
            
            [m_pObjMng->pStringContainer->m_OperationIndex
             OnlyRemoveDataAtPlaceSort:NumInArray WithData:ppArray];
            
            if(pInfo->mType!=DATA_U_INT)
                [m_pObjMng->pStringContainer->ArrayPoints DecDataAtIndex:TmpIndexValue];
  //      }
//        else
//        {
//            MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints
//                               GetMatrixAtIndex:pInfo->UnParentMatrix.indexMatrix];
//            if(pMatr!=0)
//            {
//                InfoArrayValue *pInfoDataMatr=(InfoArrayValue *)*pMatr->ppDataMartix;
//                
//                for (int i=0; i<pInfoDataMatr->mCount; i++) {
//                    int iIndexTmp=(*pMatr->ppDataMartix+SIZE_INFO_STRUCT)[i];
//                    
//                    int **ppTmpArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:iIndexTmp];
//                    InfoArrayValue *pInfoTmpArray=(InfoArrayValue *)*ppTmpArray;
//                    if(pInfoTmpArray->mType==DATA_U_INT)continue;
//
//                    int TmpIndexValue2=((*ppTmpArray)+SIZE_INFO_STRUCT)[NumInArray];
//                    
//                    [m_pObjMng->pStringContainer->ArrayPoints IncDataAtIndex:TmpIndexValue2];
//                    
//                    [m_pObjMng->pStringContainer->m_OperationIndex
//                     OnlyInsert:TmpIndexValue2 index:NumInsert WithData:ppTmpArray];
//                    
//                    if(NumInsert<NumInArray)NumInArray+=1;
//                    
//                    [m_pObjMng->pStringContainer->m_OperationIndex
//                     OnlyRemoveDataAtPlaceSort:NumInArray WithData:ppTmpArray];
//                    
//                    [m_pObjMng->pStringContainer->ArrayPoints DecDataAtIndex:TmpIndexValue2];
//                }
//            }
//        }
    }
    else
    {
        int NumInsert=pInfo->mCount;
        
        for (ObjectB_Ob_Array *pObTmp in Interface->ButtonGroup->m_pChildrenbjectsArr)
        {
            if([pObTmp Intersect:Point])
            {
                NumInsert=pObTmp->m_iNum;
                goto GOOD;
            }
        }
        goto EXIT;
GOOD:
        
//        if(pInfo->mType==DATA_U_INT)
//        {
//            [m_pObjMng->pStringContainer->m_OperationIndex
//                OnlyInsert:TmpIndexValue index:NumInsert WithData:ppArray];
//        }
//        else
//        {
            MATRIXcell *pMatr=[m_pObjMng->pStringContainer->ArrayPoints
                               GetMatrixAtIndex:pInfo->UnParentMatrix.indexMatrix];
            if(pMatr!=0)
            {
//                InfoArrayValue *pInfoDataMatr=(InfoArrayValue *)*pMatr->ppDataMartix;
//                
//                for (int i=0; i<pInfoDataMatr->mCount; i++) {
           //         int iIndexTmp=(*pMatr->ppDataMartix+SIZE_INFO_STRUCT)[i];
                    
             //       int **ppTmpArray=[m_pObjMng->pStringContainer->ArrayPoints GetArrayAtIndex:iIndexTmp];
         //           if(pInfoTmpArray->mType==DATA_U_INT)continue;

                
                
                
                InfoArrayValue *pInfoTmpArray=(InfoArrayValue *)*ppArray;


                if(pInfoTmpArray->mType==DATA_U_INT)
                {
                    ((*ppArray)+SIZE_INFO_STRUCT)[NumInsert]=TmpIndexValue;
                }
                else
                {
                    int TmpIndexValue2=((*ppArray)+SIZE_INFO_STRUCT)[NumInsert];
                    
                    *(m_pObjMng->pStringContainer->ArrayPoints->pData+TmpIndexValue2)=*(m_pObjMng->pStringContainer->ArrayPoints->pData+TmpIndexValue);
                }

//                int CopyIndex=[m_pObjMng->pStringContainer->ArrayPoints CopyDataAtIndex:TmpIndexValue2];
//                [m_pObjMng->pStringContainer->ArrayPoints IncDataAtIndex:CopyIndex];
//                [m_pObjMng->pStringContainer->m_OperationIndex
//                 OnlyInsert:CopyIndex index:NumInsert WithData:ppArray];

  //              }
            }
 //       }
    }
EXIT:
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