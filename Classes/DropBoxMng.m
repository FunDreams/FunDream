//
//  InfoFile.m
//  FunDreams
//
//  Created by Konstantin on 27.09.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import "DropBoxMng.h"
#import "ObB_DropBox.h"

@implementation DropBoxMng
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        pDataManager=[[CDataManager alloc] InitWithFileFromRes:@"info"];
        pDataManager->m_pParent=self;
        pDropBoxString = [m_pObjMng->pStringContainer GetString:@"DropBox"];

        m_bHiden=YES;
        bBusy=NO;
   //     [self DownLoadInfoFile];
    }

    return self;
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
	[super Start];
}
//------------------------------------------------------------------------------------------------------
- (void)Check{
    
    id pObTmp = GET_ID_V(@"ObCheckInDropBox");
    
    int i=0;
    if(pObTmp!=nil){
        for (GObject *pOb in m_pChildrenbjectsArr) {
            if(pOb==pObTmp){
                m_iCurrentSelect=i;
                continue;
            }
            else{
                OBJECT_PERFORM_SEL(pOb->m_strName, @"SetUnPush");
            }
            i++;
        }
    }
}
//------------------------------------------------------------------------------------------------------
//- (void)SetDefault{}
//- (void)PostSetParams{}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    
    Processor_ex *pProc = [self START_QUEUE:@"Pause"];
        ASSIGN_STAGE(@"Idle", @"Idle:",nil)
        ASSIGN_STAGE(@"Pause",@"Pause:",SET_INT_V(1000,@"TimeBaseDelay"));
    [self END_QUEUE:pProc name:@"Pause"];

}
//------------------------------------------------------------------------------------------------------
- (void)Hide{
    
    for (ObB_DropBox *pOb in m_pChildrenbjectsArr) {
        [pOb SetTouch:NO];
        [pOb DeleteFromDraw];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Show{
    
    for (ObB_DropBox *pOb in m_pChildrenbjectsArr) {
        [pOb SetTouch:YES];
        [pOb AddToDraw];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateButt{
    
    if(pDropBoxString==nil)return;
    
    for (GObject *pOb in m_pChildrenbjectsArr) {
        DESTROY_OBJECT(pOb);
    }
    [m_pChildrenbjectsArr removeAllObjects];

    int m_iNumButton=[pDropBoxString->aStrings count];

    for(int i=0;i<m_iNumButton;i++){
        
        Color3D pColorBack;

        FractalString *pFstr=[pDropBoxString->aStrings objectAtIndex:i];
        
        if([pFstr->aStrings count]>0)
            pColorBack=Color3DMake(0,1,0,1);
        else pColorBack=Color3DMake(1,0,0,1);
    
        FractalString *pFrStr = [pDropBoxString->aStrings objectAtIndex:i];
        ObB_DropBox *pOb=UNFROZE_OBJECT(@"ObB_DropBox",@"Ob_DropBox",
                           SET_COLOR_V(pColorBack,@"mColorBack"),
                           SET_STRING_V(@"ButtonOb.png",@"m_DOWN"),
                           SET_STRING_V(@"ButtonOb.png",@"m_UP"),
                           SET_FLOAT_V(54,@"mWidth"),
                           SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
                           SET_BOOL_V(YES,@"m_bLookTouch"),
                           SET_INT_V(2,@"m_iType"),
                           SET_STRING_V(NAME(self),@"m_strNameObject"),
                           SET_STRING_V(@"Check",@"m_strNameStage"),
                           SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                           SET_BOOL_V(YES,@"m_bDrag"),
                           SET_VECTOR_V(Vector3DMake(pFrStr->X,pFrStr->Y,0),@"m_pCurPosition"));
        
        pOb->pString=pFrStr;

        [m_pChildrenbjectsArr addObject:pOb];
    }
    
    if([m_pChildrenbjectsArr count]>0){
        if(m_iCurrentSelect>[m_pChildrenbjectsArr count]-1)
            m_iCurrentSelect=[m_pChildrenbjectsArr count]-1;
        
        ObB_DropBox *pObSel=[m_pChildrenbjectsArr objectAtIndex:m_iCurrentSelect];
        
        OBJECT_PERFORM_SEL(NAME(pObSel), @"SetPush");
    }    
}
//------------------------------------------------------------------------------------------------------
-(void)DownLoadInfoFile{
    
    [pDataManager DownLoad];
    
    bMetaDataLoaded=NO;
    bInfoLoaded=NO;
}
//------------------------------------------------------------------------------------------------------
-(void)loadFileFailedWithError{}
//------------------------------------------------------------------------------------------------------
-(void)uploadedFile{
    
    SET_STAGE_EX(NAME(self), @"Pause", @"Pause");
}
//------------------------------------------------------------------------------------------------------
-(void)uploadFileFailedWithError{
    SET_STAGE_EX(NAME(self), @"Pause", @"Pause");
}
//------------------------------------------------------------------------------------------------------
-(void)loadMetadataFailedWithError{}
//------------------------------------------------------------------------------------------------------
-(void)loadedMetadata{
    bMetaDataLoaded=YES;
    
    if(bInfoLoaded==YES && bMetaDataLoaded==YES)
        [self LoadAndSyns];
}
//------------------------------------------------------------------------------------------------------
-(void)loadedFile{
    bInfoLoaded=YES;
    
    if(bInfoLoaded==YES && bMetaDataLoaded==YES)
        [self LoadAndSyns];
}
//------------------------------------------------------------------------------------------------------
-(void)LoadAndSyns{
    
    bInfoLoaded=NO;
    bMetaDataLoaded=NO;
    
    int ReadPos=0;
    bool bNeedUpload;

    FractalString *pFstrRez = [[FractalString alloc] init];
    FractalString *pFstr = [[FractalString alloc] init];
    
    [pFstr selfLoadOnlyStructure:pDataManager->m_pDataDmp ReadPos:&ReadPos];
    //meta data to array-------------------------------------------------------------
    NSMutableArray *pArray=[[NSMutableArray alloc] init];
    for(DBMetadata *child in pDataManager->m_pMetaData.contents)
    {
        NSString *folderName = [[child.path pathComponents] lastObject];
        if([folderName isEqualToString:@"Info"])continue;

        [pArray addObject:folderName];
    }
    //-------------------------------------------------------------------------------
Repeate:;
    int iCount=[pFstr->aStrings count];
    int iCountInMetadata=[pArray count];

    for(int i=0;i<iCountInMetadata;i++){

        NSString *folderName = [pArray objectAtIndex:i];

        for(int j=0;j<iCount;j++){

            FractalString *pFstrTmp=[pFstr->aStrings objectAtIndex:j];

            if([pFstrTmp->strUID isEqualToString:folderName]){

                [pFstrRez->aStrings addObject:pFstrTmp];
                [pFstr->aStrings removeObjectAtIndex:j];
                [pArray removeObjectAtIndex:i];
                goto Repeate;
            }
        }
    }

    if([pArray count]>0){

        bNeedUpload=YES;
        for(int i=0;i<[pArray count];i++){
            NSString *folderName = [pArray objectAtIndex:i];

            FractalString *pLoadFstr = [[FractalString alloc] init];

            [pLoadFstr->strName release];
            [pLoadFstr->strUID release];

            pLoadFstr->strName = [[NSString alloc] initWithString:folderName];
            pLoadFstr->strUID = [[NSString alloc] initWithString:folderName];

            pLoadFstr->iIndexIcon=0;
            pLoadFstr->m_iFlags &=0x80000000;
            [pFstrRez->aStrings addObject:pLoadFstr];
        }
    }
    
    [pArray release];

    FractalString *pStrDropBox = [m_pObjMng->pStringContainer GetString:@"DropBox"];
    
    NSMutableArray * pArrayLink=[[NSMutableArray alloc] init];
    
    if(pStrDropBox!=nil){
        for (int i=0; i<[pStrDropBox->aStrings count]; i++) {
            
            FractalString *pChild=[pStrDropBox->aStrings objectAtIndex:i];
            [pArrayLink addObject:pChild];
        }
    }

Repeate2:;
    for(int i=0;i<[pArrayLink count];i++){
        
        FractalString *pFstrTmp=[pArrayLink objectAtIndex:i];

        for(int j=0;j<[pFstrRez->aStrings count];j++){
            
            FractalString *pFstrTmp2=[pFstrRez->aStrings objectAtIndex:j];

            if([pFstrTmp->strUID isEqualToString:pFstrTmp2->strUID]){

                [pArrayLink removeObjectAtIndex:i];
                [pFstrRez->aStrings removeObjectAtIndex:j];
                goto Repeate2;
            }

        }
    }
    
    if([pArrayLink count]>0){
        
        bNeedUpload=YES;

        for(int i=0;i<[pArrayLink count];i++){
            
            FractalString *pFstrTmp=[pArrayLink objectAtIndex:i];

            if([pFstrTmp->aStrings count]==0){
                
                [m_pObjMng->pStringContainer DelString:pFstrTmp];
            }
            else{//элемент не пуст
                
                [m_pObjMng->pStringContainer SaveStringToDropBox:pFstrTmp Version:1];
            }
        }
    }
    
    if([pFstrRez->aStrings count]>0){
        
        bNeedUpload=YES;
        
        for(int i=0;i<[pFstrRez->aStrings count];i++){
            
            FractalString *pFstrTmp=[pFstrRez->aStrings objectAtIndex:i];
            
            [pStrDropBox->aStrings addObject:pFstrTmp];
            pFstrTmp->pParent=pStrDropBox;
        }
    }
    
    [pArrayLink release];
    if(bNeedUpload==YES)[m_pObjMng->pStringContainer SaveInfoStringToDropBox];
    
    int *pMode=GET_INT_V(@"m_iMode");

    if(pMode!=0 && *pMode==3){
        [self UpdateButt];
    }
}
//------------------------------------------------------------------------------------------------------
-(void)Save{}
//------------------------------------------------------------------------------------------------------
- (void)Pause:(Processor_ex *)pProc{
    
    bBusy=NO;
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
-(void)dealloc{
    [pDataManager release];
    [super dealloc];
}

@end
