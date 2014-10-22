//
//  Ob_Cont_Res.mm
//  Engine
//
//  Created by Konstantin on 04.09.13.
//  Copyright 2013 __FunDreamsInc__. All rights reserved.
//

#import "Ob_Cont_Res.h"
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
@implementation Ob_Cont_Res//container
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
    self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerGame;

        mWidth  = 2;
        mHeight = 2;
        
        free(vertices);
        free(texCoords);
        free(squareColors);	
        
        vertices=0;
        texCoords=0;
        squareColors=0;

        mTextureId=-1;
        mColor = Color3DMake(1.0f,1.0f,1.0f,1.0f);
        
        m_iCountVertex=0;
        m_bHiden=YES;        
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{m_bHiden=NO;}
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
-(void)CopyData:(int)iPlaceDest source:(int)iPlaceSrc{}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
    pIndexRes=[m_pObjMng->pStringContainer->m_OperationIndex InitMemory];
    pDic = [[NSMutableDictionary alloc] init];

	[super Start];
}
//------------------------------------------------------------------------------------------------------
-(int)CreateResTexture:(NSString *)sName{
    
    InfoArrayValue *pInfoParticles=(InfoArrayValue *)(*pIndexRes);
    int iCount=pInfoParticles->mCount;

    pCells=(ResourceCell *)realloc(pCells,(iCount+1)*sizeof(ResourceCell));

    ResourceCell *pTmpCell=pCells+iCount;
    pTmpCell->iName=-1;
    pTmpCell->sName = [[NSString alloc] initWithString:sName];
    GET_TEXTURE(pTmpCell->iName, pTmpCell->sName);
    return iCount;
}
//------------------------------------------------------------------------------------------------------
-(int)CreateResSound:(NSString *)sName{
    
    InfoArrayValue *pInfoParticles=(InfoArrayValue *)(*pIndexRes);
    int iCount=pInfoParticles->mCount;
    
    pCells=(ResourceCell *)realloc(pCells,(iCount+1)*sizeof(ResourceCell));
    
    ResourceCell *pTmpCell=pCells+iCount;
    pTmpCell->iName=-1;
    pTmpCell->sName = [[NSString alloc] initWithString:sName];
    
    NSNumber *pNum=[m_pParent->m_pSoundList objectForKey:sName];
    
    pTmpCell->iName=[pNum intValue];
    return iCount;
}
//------------------------------------------------------------------------------------------------------
-(void)CopyRes:(int)iPlaceDest source:(int)iPlaceSrc
{
    ResourceCell *pTmpCellDest=pCells+iPlaceDest;
    ResourceCell *pTmpCellSrc=pCells+iPlaceSrc;
    
    [pTmpCellDest->sName release];
    pTmpCellDest->sName=[[NSString alloc] initWithString:pTmpCellSrc->sName];
    pTmpCellDest->iName=pTmpCellSrc->iName;
}
//------------------------------------------------------------------------------------------------------
-(void)RemoveRes:(int)iIndexPar{

    InfoArrayValue *pInfoParticles=(InfoArrayValue *)(*pIndexRes);
    int *pStartData=(*pIndexRes)+SIZE_INFO_STRUCT;//индексы содержащие ресурс
    int iCount=pInfoParticles->mCount-1;
    int iIndexLast=pStartData[iCount];
    int iRetPlace=[m_pObjMng->pStringContainer->m_OperationIndex
                   FindIndex:iIndexPar WithData:pIndexRes];
    if(iRetPlace==-1)
        return;
//------------------------------------------------------------------------------------------------------
    ResourceCell *pTmpCell=pCells+iRetPlace;
    [pTmpCell->sName release];
    ResourceCell *pTmpCell2=pCells+iCount;
    pTmpCell->sName=pTmpCell2->sName;
    pTmpCell->iName=pTmpCell2->iName;

    float *TmpPlace=ArrayPointsParent->pData+iIndexLast;
    *TmpPlace=(float)iRetPlace;

    [m_pObjMng->pStringContainer->m_OperationIndex
        OnlyRemoveDataAtPlace:iRetPlace WithData:pIndexRes];

    pCells=(ResourceCell *)realloc(pCells,iCount*sizeof(ResourceCell));
}
//------------------------------------------------------------------------------------------------------
- (void)RemoveAllRes{
    
    InfoArrayValue *pInfoParticles=(InfoArrayValue *)(*pIndexRes);
    int *pStartData=(*pIndexRes)+SIZE_INFO_STRUCT;
    int iCount=pInfoParticles->mCount;
    
    for (int i=0;i<iCount;i++) {

        pStartData=(*pIndexRes)+SIZE_INFO_STRUCT;
        int TmpIndex=pStartData[0];
        [self RemoveRes:TmpIndex];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    
    InfoArrayValue *pInfoParticles=(InfoArrayValue *)(*pIndexRes);
    int iCount=pInfoParticles->mCount;
    
    for (int i=0;i<iCount;i++) {
        
        ResourceCell *pTmpCell=pCells+i;
        [pTmpCell->sName release];
    }

    free(pCells);
    [pDic release];
    [m_pObjMng->pStringContainer->m_OperationIndex OnlyReleaseMemory:pIndexRes];

    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
-(void)selfSave:(NSMutableData *)m_pData{
    
    unichar* ucBuff = (unichar*)calloc(512, sizeof(unichar));
    int iLen;
    InfoArrayValue *pInfoParticles=(InfoArrayValue *)(*pIndexRes);
    [m_pObjMng->pStringContainer->m_OperationIndex selfSave:m_pData WithData:pIndexRes];

    for (int i=0; i<pInfoParticles->mCount; i++) {
        ResourceCell *pCellTmp=pCells+i;
        
        [pCellTmp->sName getCharacters:ucBuff];
        iLen=[pCellTmp->sName length];
        [m_pData appendBytes:&iLen length:sizeof(int)];
        [m_pData appendBytes:ucBuff length:iLen*sizeof(unichar)];
    }
    
    free(ucBuff);
}
//------------------------------------------------------------------------------------------
-(void)PrepareResTexture{

    InfoArrayValue *pInfoParticles=(InfoArrayValue *)(*pIndexRes);

    for (int i=0; i<pInfoParticles->mCount; i++) {
        
        ResourceCell *pCellTmp=pCells+i;
        GET_TEXTURE(pCellTmp->iName, pCellTmp->sName);
    }
}
//------------------------------------------------------------------------------------------
-(void)PrepareResSound{
    
    InfoArrayValue *pInfoParticles=(InfoArrayValue *)(*pIndexRes);
    
    for (int i=0; i<pInfoParticles->mCount; i++) {
        
        ResourceCell *pCellTmp=pCells+i;
        NSNumber *pNum=[m_pParent->m_pSoundList objectForKey:pCellTmp->sName];
        pCellTmp->iName=[pNum integerValue];
    }
}
//------------------------------------------------------------------------------------------
-(void)selfLoad:(NSMutableData *)m_pData rpos:(int *)iCurReadingPos{

    [self RemoveAllRes];

    unichar* ucBuff = (unichar*)calloc(512, sizeof(unichar));
    int iLen;
    
    //количество ресурсов
    [m_pObjMng->pStringContainer->m_OperationIndex
   selfLoad:m_pData rpos:iCurReadingPos WithData:pIndexRes];
   InfoArrayValue *pInfoParticles=(InfoArrayValue *)(*pIndexRes);
    
    NSRange Range;
    
    if(pCells==0)
        pCells=(ResourceCell *)malloc((pInfoParticles->mCount)*sizeof(ResourceCell));
    else
        pCells=(ResourceCell *)realloc(pCells, (pInfoParticles->mCount)*sizeof(ResourceCell));

    for (int i=0; i<pInfoParticles->mCount; i++) {

        ResourceCell *pCellTmp=pCells+i;
        
        Range = NSMakeRange( *iCurReadingPos, sizeof(int));//длина строки
        [m_pData getBytes:&iLen range:Range];
        *iCurReadingPos += sizeof(int);
        
        Range = NSMakeRange( *iCurReadingPos, iLen*sizeof(unichar));//имя
        [m_pData getBytes:ucBuff range:Range];
        *iCurReadingPos += iLen*sizeof(unichar);
        
        NSString *sValue = [NSString stringWithCharacters:ucBuff length:iLen];
        pCellTmp->sName = [[NSString alloc] initWithString:sValue];
    }    
    
    free(ucBuff);
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{
    
    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
@end