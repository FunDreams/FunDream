//
//  InfoFile.m
//  FunDreams
//
//  Created by Konstantin on 27.09.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import "DropBoxMng.h"
#import "ObB_DropBox.h"
#import "Ob_ResourceMng.h"
#import "Ob_Editor_Interface.h"
#import "InfoFile.h"
#import "Ob_EmtyPlace.h"

#define NAME_INFO_FILE @"_info"
@implementation DropBoxMng
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        pDataManager=[[CDataManager alloc] InitWithFileFromRes:NAME_INFO_FILE];
        pDataManager->m_pParent=self;
        
        pDropBoxString = [m_pObjMng->pStringContainer GetString:@"DropBox"];
        pInfofile=[[InfoFile alloc] init:pDropBoxString WithParent:m_pObjMng->pStringContainer];

        m_bHiden=NO;
        mColor= Color3DMake(1, 1, 1, 0);
        bNeedUpload=NO;
        bDropBoxWork=NO;
        
        m_pListAdd = [[NSMutableDictionary alloc] init];
        NameDownLoadFile = [[NSMutableString alloc] init];
    }

    return self;
}
//------------------------------------------------------------------------------------------------------
-(void)ReLinkDataManager{
    
    [pDataManager relinkResClient];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    mWidth=460;
    mHeight=510;

	[super Start];
    
//    [self DownLoadInfoFile];
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

    [m_pObjMng->pMegaTree SetCell:(LINK_BOOL_V(bNeedUpload,@"bNeedUpload"))];
}
//------------------------------------------------------------------------------------------------------
- (void)Hide{
    
    for (ObB_DropBox *pOb in m_pChildrenbjectsArr) {
        DESTROY_OBJECT(pOb);
    }
    [m_pChildrenbjectsArr removeAllObjects];

//    for (ObB_DropBox *pOb in m_pChildrenbjectsArr) {
//        [pOb SetTouch:NO];
//        [pOb DeleteFromDraw];
//    }
    
}
//------------------------------------------------------------------------------------------------------
//- (void)Show{
//    
//    if(bShow==NO){
//        bShow=YES;
//        for (ObB_DropBox *pOb in m_pChildrenbjectsArr) {
//            [pOb SetTouch:YES];
//            [pOb AddToDraw];
//        }
//    }
//}
//------------------------------------------------------------------------------------------------------
- (void)CreateOb:(FractalString *)pFrStr{
    ObB_DropBox *pOb=UNFROZE_OBJECT(@"ObB_DropBox",@"Ob_DropBox",
                                    //SET_COLOR_V(pColorBack,@"mColorBack"),
                                    SET_STRING_V(pFrStr->sNameIcon,@"m_DOWN"),
                                    SET_STRING_V(pFrStr->sNameIcon,@"m_UP"),
                                    SET_FLOAT_V(54,@"mWidth"),
                                    SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
                                    SET_BOOL_V(YES,@"m_bLookTouch"),
                                    SET_INT_V(2,@"m_iType"),
                                    SET_STRING_V(NAME(self),@"m_strNameObject"),
                                    SET_STRING_V(@"Check",@"m_strNameStage"),
                                    SET_STRING_V(@"take.wav", @"m_strNameSound"),
                                    SET_BOOL_V(YES,@"m_bDrag"),
                                    SET_VECTOR_V(Vector3DMake(pFrStr->X,pFrStr->Y,0),@"m_pCurPosition"));
    
    pOb->pString=pFrStr;
    
    [m_pChildrenbjectsArr addObject:pOb];
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateButt{

    if(pDropBoxString==nil)return;
    
    for (GObject *pOb in m_pChildrenbjectsArr) {
        DESTROY_OBJECT(pOb);
    }
    [m_pChildrenbjectsArr removeAllObjects];

////////////////////////////////////////////////////////////////////////////////////////////
    int *Data=(*pDropBoxString->pChildString);
    InfoArrayValue *InfoStr=(InfoArrayValue *)(Data);

    for(int i=0;i<InfoStr->mCount;i++){
        
        int index=(Data+SIZE_INFO_STRUCT)[i];
//        int iType=[m_pObjMng->pStringContainer->ArrayPoints GetTypeAtIndex:index];
        FractalString *pFrStr=[m_pObjMng->pStringContainer->ArrayPoints
                               GetIdAtIndex:index];

        [self CreateOb:pFrStr];
    }
////////////////////////////////////////////////////////////////////////////////////////////
    if([m_pChildrenbjectsArr count]>0){
        if(m_iCurrentSelect>[m_pChildrenbjectsArr count]-1)
            m_iCurrentSelect=[m_pChildrenbjectsArr count]-1;
        
        ObB_DropBox *pObSel=[m_pChildrenbjectsArr objectAtIndex:m_iCurrentSelect];
        
        OBJECT_PERFORM_SEL(NAME(pObSel), @"SetPush");
    }
}
//------------------------------------------------------------------------------------------------------
-(void)DownLoadInfoFile{

    if(bDropBoxWork==NO){
        
        [pDataManager relinkResClient];
        
        m_iMode=UPDATE_INFO;

        [NameDownLoadFile setString:@"INFO"];
        m_iNumDownLoadFiles = 0;

        [pDataManager DownLoad];

        bErrorDownLoad=NO;
        bErrorMetaData=NO;
        bDropBoxWork=YES;
    }
}
//------------------------------------------------------------------------------------------------------
-(void)uploadedFile{
    
    if(m_iMode==UPLOAD_DATA_STR){

        if([pDataManager->m_pTmpLocalMetaData.filename isEqualToString:NAME_INFO_FILE]){
            
            bDropBoxWork=NO;
            OBJECT_PERFORM_SEL(@"Ob_Editor_Interface",@"UpdateB");
        }
        else
        {
            if([m_pListAdd count]>0)
            {
                FractalString *pStr=[m_pListAdd objectForKey:pDataManager->m_pTmpLocalMetaData.filename];
                
                if(pStr!=nil){
                    [pStr SetFlag:SYNH_AND_LOAD];
                }
                
                [m_pListAdd removeObjectForKey:pDataManager->m_pTmpLocalMetaData.filename];
            }
            
            [self Synhronization];
        }
    }
    
    Ob_Editor_Interface *oInterface = (Ob_Editor_Interface *)[m_pObjMng GetObjectByName:@"Ob_Editor_Interface"];
    OBJECT_SET_PARAMS(NAME(oInterface->BDropBox),SET_COLOR_V(Color3DMake(0, 1, 0, 1),@"mColorBack"));
}
//------------------------------------------------------------------------------------------------------
-(void)uploadFileFailedWithError{

    bDropBoxWork=NO;
    OBJECT_PERFORM_SEL(@"Ob_Editor_Interface",@"UpdateB");
    
    Ob_Editor_Interface *oInterface = (Ob_Editor_Interface *)[m_pObjMng GetObjectByName:@"Ob_Editor_Interface"];
    OBJECT_SET_PARAMS(NAME(oInterface->BDropBox),SET_COLOR_V(Color3DMake(1, 0, 0, 1),@"mColorBack"));
}
//------------------------------------------------------------------------------------------------------
-(void)loadFileFailedWithError{
    
    if(m_iMode==UPDATE_INFO){//если в DropBox'е нет INFO файла
        bNeedUpload=YES;
    }

    bDropBoxWork=NO;
    bErrorDownLoad=YES;

    OBJECT_PERFORM_SEL(@"Ob_Editor_Interface",@"UpdateB");

    Ob_Editor_Interface *oInterface = (Ob_Editor_Interface *)[m_pObjMng GetObjectByName:@"Ob_Editor_Interface"];
    OBJECT_SET_PARAMS(NAME(oInterface->BDropBox),SET_COLOR_V(Color3DMake(1, 0, 0, 1),@"mColorBack"));
}
//------------------------------------------------------------------------------------------------------
-(void)loadMetadataFailedWithError{
    
    bDropBoxWork=NO;
    bErrorMetaData=YES;
    OBJECT_PERFORM_SEL(@"Ob_Editor_Interface",@"UpdateB");
    
    Ob_Editor_Interface *oInterface = (Ob_Editor_Interface *)[m_pObjMng GetObjectByName:@"Ob_Editor_Interface"];
    OBJECT_SET_PARAMS(NAME(oInterface->BDropBox),SET_COLOR_V(Color3DMake(1, 0, 0, 1),@"mColorBack"));
}
//------------------------------------------------------------------------------------------------------
-(void)loadedMetadata{

    if(m_iMode==UPLOAD_DATA_STR)
    {
        [self Synhronization];
    }
    else
    {
        [self LoadAndSyns];
        Ob_Editor_Interface *oInterface = (Ob_Editor_Interface *)[m_pObjMng GetObjectByName:@"Ob_Editor_Interface"];
        OBJECT_SET_PARAMS(NAME(oInterface->BDropBox),SET_COLOR_V(Color3DMake(0, 1, 0, 1),@"mColorBack"));
    }
}
//------------------------------------------------------------------------------------------------------
-(void)loadedFile{
    
    if(m_iMode==UPDATE_INFO){
        
        [pDataManager LoadMetadata:@"/"];
    }
    else if(m_iMode==DOWNLOAD_DATA_STR){

        [self loadAndMerge];
        
        //load InFo;
        bDropBoxWork=NO;
        OBJECT_PERFORM_SEL(@"Ob_Editor_Interface",@"UpdateB");
    }
}
//------------------------------------------------------------------------------------------------------
-(void)DefFromUploadString:(FractalString *)pStr{
    
    if(pStr!=nil){
        [m_pListAdd removeObjectForKey:pStr->strUID];
    }
}
//------------------------------------------------------------------------------------------------------
-(void)AddToDelArray:(FractalString *)pStr{
    if(pStr!=nil){
//        [m_pListDel setObject:pStr forKey:pStr->strUID];
    }
}
//------------------------------------------------------------------------------------------------------
-(void)AddToUploadString:(FractalString *)pStr{
    
    if(pStr!=nil){
        [m_pListAdd setObject:pStr forKey:pStr->strUID];
    }
}
//------------------------------------------------------------------------------------------------------
-(void)DownLoadString:(FractalString *)pFsr WithPlace:(int)iPlace{
    
    if(bDropBoxWork==NO){
        m_iDownloadPlace=iPlace;
        [pDataManager relinkResClient];
        
        [NameDownLoadFile setString:pFsr->strUID];
        m_iNumDownLoadFiles = 0;

        bDropBoxWork=YES;
        m_iMode=DOWNLOAD_DATA_STR;

        [pDataManager DownLoadWithName:pFsr->strUID];
        
        [NameDownLoadFile setString:pFsr->sNameIcon];
        m_iNumDownLoadFiles = 1;
        
        OBJECT_PERFORM_SEL(@"Ob_Editor_Interface",@"UpdateB");
    }
}
//------------------------------------------------------------------------------------------------------
-(void)Synhronization{

    if(bDropBoxWork==NO){

        m_iMode=UPLOAD_DATA_STR;
        [pDataManager relinkResClient];
        [NameDownLoadFile setString:@"INFO"];
        m_iNumDownLoadFiles = 0;
        [pDataManager LoadMetadata:@"/"];
        bDropBoxWork=YES;
    }
    else
    {
        NSEnumerator *enumeratorObjects = [m_pListAdd objectEnumerator];
        int iVersion=VERSTION;

        if([m_pListAdd count]>0){
            FractalString *pStr=[enumeratorObjects nextObject];

            if(pStr!=nil && pDataManager->m_pDataDmp!=nil){
                
                [pDataManager Clear];
//////////////////////////////////////////////////////////////////////////////////////////////////
                StringContainer *pStringContainerTmp = [[StringContainer alloc] init:m_pObjMng];
                [pStringContainerTmp SetKernel];
                [pStringContainerTmp CopyStrFrom:m_pObjMng->pStringContainer WithId:pStr];
                
                id pEncodeString = [pStringContainerTmp GetString:pStr->strUID];
                
                [pDataManager->m_pDataDmp appendBytes:&iVersion length:sizeof(int)];
                [pEncodeString selfSave:pDataManager->m_pDataDmp WithVer:iVersion];
                [pStringContainerTmp->ArrayPoints selfSave:pDataManager->m_pDataDmp];
                
                [pStringContainerTmp release];
//////////////////////////////////////////////////////////////////////////////////////////////////
                [pDataManager Save];

                [pDataManager UpLoadWithName:pStr->strUID];
                
                [NameDownLoadFile setString:pStr->sNameIcon];
                m_iNumDownLoadFiles = [m_pListAdd count];
            }
        }
        else [self SaveInfoStringToDropBox];
    }
}
//------------------------------------------------------------------------------------------------------
-(void)loadAndMerge{
    
    CDataManager* pDataCurManager = pDataManager;
    bool Rez=[pDataCurManager Load];
    
    int iLen=[pDataCurManager->m_pDataDmp length];
    if(iLen==0)Rez=false;
    
    if([pDataCurManager->m_pDataDmp length]!=0){
        
        int iLenVersion = [pDataCurManager GetIntValue];
        
        switch (iLenVersion) {
            case 1:
            {
                FractalString *StrDropBox = [m_pObjMng->pStringContainer GetString:@"DropBox"];
                
                if(StrDropBox!=nil)
                {
/////////////////////////////////////////////////////////////////////////////////////////////////////
                    StringContainer *pStringContainerTmp = [[StringContainer alloc] init:m_pObjMng];
                    [pStringContainerTmp SetKernel];

                    FractalString *pNewString = [[FractalString alloc]
                                    initWithData:pDataCurManager->m_pDataDmp
                                    WithCurRead:&pDataCurManager->m_iCurReadingPos
                                    WithParent:nil WithContainer:pStringContainerTmp];

                    [pStringContainerTmp->ArrayPoints selfLoad:pDataCurManager->m_pDataDmp
                                          rpos:&pDataCurManager->m_iCurReadingPos];
                    
                    FractalString *pDelStr=[m_pObjMng->pStringContainer GetString:pNewString->strUID];
                    float fX;
                    float fY;

                    //
                    FractalString *pStrDropBox = [m_pObjMng->pStringContainer GetString:@"DropBox"];
                                        
                    int **DataDropBox=(pStrDropBox->pChildString);
                    InfoArrayValue *InfoStrDropBox=(InfoArrayValue *)(*DataDropBox);
                    
                    if(pStrDropBox!=nil){
                        for (int i=0; i<InfoStrDropBox->mCount; i++){//делаем массив линков из DropBox'a
                            
                        }
                    }
                    //

                    
                    if(pDelStr!=nil){
                        fX=pDelStr->X;
                        fY=pDelStr->Y;
                        
                        [m_pObjMng->pStringContainer DelString:pDelStr];
                    }
                    
                    //копируем струну в основной контейнер
                    [m_pObjMng->pStringContainer CopyStrFrom:pStringContainerTmp WithId:pNewString];
                    FractalString *pNewStr = [m_pObjMng->pStringContainer GetString:pNewString->strUID];
                    
       //             [pNewString->m_pContainer LogString:pNewString];
                    
                    //очищаем индекс и устанавливаем родителя
                    [pNewStr SetParent:StrDropBox];

                    [pStringContainerTmp release];
/////////////////////////////////////////////////////////////////////////////////////////////////////
                    [pNewStr SetFlag:SYNH_AND_LOAD];
                    pNewStr->X=fX;
                    pNewStr->Y=fY;
                    
                    Ob_Editor_Interface *oInterface = (Ob_Editor_Interface *)[m_pObjMng GetObjectByName:@"Ob_Editor_Interface"];

                    Ob_EmtyPlace *pPlace = oInterface->Eplace->m_pChildrenbjectsArr[m_iDownloadPlace];
                    [pPlace SetNameStr:pNewStr];
                    
                    OBJECT_PERFORM_SEL(@"Ob_Editor_Interface",@"UpdateB");

                    OBJECT_SET_PARAMS(NAME(oInterface->BDropBox),
                                    SET_COLOR_V(Color3DMake(0, 1, 0, 1),@"mColorBack"));
                }
            }
            break;
                
            default:
                Rez=NO;
                break;
        }
    }    
}
//------------------------------------------------------------------------------------------------------
-(void)LoadAndSyns{

    bNeedUpload=NO;
    int ReadPos=0;

    NSMutableArray *pFstrRez = [[NSMutableArray alloc] init];
    
    [pDataManager Load];
    [pInfofile LoadFile:pDataManager->m_pDataDmp ReadPos:&ReadPos];
    //meta data to array-------------------------------------------------------------
    NSMutableArray *pArray=[[NSMutableArray alloc] init];
    for(DBMetadata *child in pDataManager->m_pMetaData.contents)
    {//собираем именя из метадаты
        NSString *folderName = [[child.path pathComponents] lastObject];
        if([folderName isEqualToString:NAME_INFO_FILE])continue;
        if([folderName isEqualToString:@"_Resource"])continue;
        if([folderName length]!=20)continue;

        [pArray addObject:folderName];
    }
    //-------------------------------------------------------------------------------
Repeate:;

    int iCount=[pInfofile->pArray count];
    int iCountInMetadata=[pArray count];

    for(int i=0;i<iCountInMetadata;i++){//ищем одинаковые в загруженном Info загаловке
        //одинаковые вычёркиваем

        NSString *folderName = [pArray objectAtIndex:i];

        for(int j=0;j<iCount;j++){

            Head *pTmpHead=[pInfofile->pArray objectAtIndex:j];

            if([pTmpHead->strUID isEqualToString:folderName]){
                
                FractalString *pLoadFstr = [[FractalString alloc] init:m_pObjMng->pStringContainer];
                
                [pLoadFstr->strUID release];
                pLoadFstr->strUID = [[NSString alloc] initWithString:pTmpHead->strUID];
                [pLoadFstr->sNameIcon release];
                pLoadFstr->sNameIcon = [[NSString alloc] initWithString:pTmpHead->sNameIcon];

                pLoadFstr->X=pTmpHead->X;
                pLoadFstr->Y=pTmpHead->Y;
                pLoadFstr->m_iFlags=pTmpHead->iFlags;

                [pFstrRez addObject:pLoadFstr];
                
                [pInfofile->pArray removeObjectAtIndex:j];

                [pArray removeObjectAtIndex:i];
                goto Repeate;
            }
        }
    }
    
    if([pArray count]>0){//если у метадаты остались имена, то создаём пустые струны которые надо загрузить

        bNeedUpload=YES;
        for(int i=0;i<[pArray count];i++){
            NSString *folderName = [pArray objectAtIndex:i];

            FractalString *pLoadFstr = [[FractalString alloc] init:m_pObjMng->pStringContainer];

            [pLoadFstr->strUID release];
            pLoadFstr->strUID = [[NSString alloc] initWithString:folderName];

            [pLoadFstr SetFlag:SYNH_AND_HEAD];//только заголовок
            [pFstrRez addObject:pLoadFstr];
        }
    }
    
    [pArray release];

    FractalString *pStrDropBox = [m_pObjMng->pStringContainer GetString:@"DropBox"];
    
    NSMutableArray * pArrayLink=[[NSMutableArray alloc] init];
    
    int **DataDropBox=(pStrDropBox->pChildString);
    InfoArrayValue *InfoStrDropBox=(InfoArrayValue *)(*DataDropBox);
    
    if(pStrDropBox!=nil){
        for (int i=0; i<InfoStrDropBox->mCount; i++){//делаем массив линков из DropBox'a
            
            int index=(*DataDropBox+SIZE_INFO_STRUCT)[i];
            FractalString *pChild=[m_pObjMng->pStringContainer->ArrayPoints
                                     GetIdAtIndex:index];


            [pArrayLink addObject:pChild];
        }
    }

Repeate2:;//главная синхронизация 
    for(int i=0;i<[pArrayLink count];i++){//синхронизируем со струной копией DropBox'a
        
        FractalString *pFstrTmp=[pArrayLink objectAtIndex:i];

        for(int j=0;j<[pFstrRez count];j++){
            
            FractalString *pFstrTmp2=[pFstrRez objectAtIndex:j];

            if([pFstrTmp->strUID isEqualToString:pFstrTmp2->strUID]){
                
                if(pFstrTmp->X!=pFstrTmp2->X || pFstrTmp->Y!=pFstrTmp2->Y)
                    bNeedUpload=YES;
                
                if(pFstrTmp->m_iFlags & ONLY_IN_MEM){
                    [pFstrTmp SetFlag:SYNH_AND_LOAD];
                    bNeedUpload=YES;
                }

                if(pFstrTmp->m_iFlags & DEAD_STRING){
                    [pFstrTmp SetFlag:SYNH_AND_HEAD];
                    bNeedUpload=YES;
                }

                [pArrayLink removeObjectAtIndex:i];
                [pFstrRez removeObjectAtIndex:j];

                goto Repeate2;
            }
        }
    }
    
    if([pArrayLink count]>0){//после вычитания остались ссылки в DropBox'e
        
        bNeedUpload=YES;

        for(int i=0;i<[pArrayLink count];i++){
            
            FractalString *pFstrTmp=[pArrayLink objectAtIndex:i];

            if(pFstrTmp->m_iFlags & SYNH_AND_HEAD){

                //помечаем струну мёртвой
                [pFstrTmp SetFlag:DEAD_STRING];
            }
            else if(pFstrTmp->m_iFlags & ONLY_IN_MEM){
                
                [self AddToUploadString:pFstrTmp];
            }
            else if(pFstrTmp->m_iFlags & DEAD_STRING){
            }
            else if (pFstrTmp->m_iFlags & SYNH_AND_LOAD){
                [pFstrTmp SetFlag:ONLY_IN_MEM];
                [self AddToUploadString:pFstrTmp];
            }
        }
    }

    if([pFstrRez count]>0){
        //добавляем пустые струны, которые необходимо загрузить
        
        bNeedUpload=YES;
        
        for(int i=0;i<[pFstrRez count];i++){
            
            FractalString *pFstrTmp=[pFstrRez objectAtIndex:i];
            
            int index=[m_pObjMng->pStringContainer->ArrayPoints SetOb:pFstrTmp];
            [m_pObjMng->pStringContainer->m_OperationIndex
                                       AddData:index WithData:DataDropBox];

            pFstrTmp->pParent=pStrDropBox;
            
            if(pFstrTmp->m_iFlags & SYNH_AND_LOAD)
                [pFstrTmp SetFlag:SYNH_AND_HEAD];
        }
    }
    
    [pArrayLink release];
    
    bDropBoxWork=NO;
    OBJECT_PERFORM_SEL(@"Ob_Editor_Interface",@"UpdateB");
}
//------------------------------------------------------------------------------------------------------
-(void)SaveInfoStringToDropBox{
        
    FractalString *Str = [m_pObjMng->pStringContainer GetString:@"DropBox"];
    
    [pInfofile Update];
    
    if(Str!=nil && pDataManager->m_pDataDmp!=nil){
        
        [pDataManager Clear];
        
        [pInfofile SaveFile:pDataManager->m_pDataDmp];
  //      [Str selfSaveOnlyStructure:pDataManager->m_pDataDmp WithVer:1 Deep:0 MaxDeep:1];
        
        [pDataManager Save];
        
        [pDataManager UpLoadWithName:NAME_INFO_FILE];
        
        [NameDownLoadFile setString:@"INFO"];
        m_iNumDownLoadFiles = 0;
        
        [pDataManager CreateFolder:@"_Resource"];
        NSMutableArray *pGroupRes = [m_pObjMng GetGroup:@"Res"];

        for(Ob_ResourceMng *pOb in pGroupRes){
            
            NSString *pTmpPath = [NSString stringWithFormat:@"_Resource%@",pOb->RootFolder];
            [pDataManager CreateFolder:pTmpPath];
        }
    }
}
//------------------------------------------------------------------------------------------------------
-(void)Save{}
//------------------------------------------------------------------------------------------------------
- (void)SelfDrawOffset{
    
    Ob_Editor_Interface *pObInterface = (Ob_Editor_Interface *)
        [m_pObjMng GetObjectByName:@"Ob_Editor_Interface"];
    
    if(bDropBoxWork==YES && pObInterface && pObInterface->PrBar!=nil)
    {
        glLoadIdentity();
        glRotatef(m_pObjMng->fCurrentAngleRotateOffset, 0, 0, 1);
        
        int iFontSize=34;
        // Set up texture
        
        Texture2D* statusTexture=nil;
        ////////////////////////////////////////////////////////////////////////////////////
        if([NameDownLoadFile isEqualToString:@"INFO"]){

            statusTexture = [[Texture2D alloc] initWithString:NameDownLoadFile
                       dimensions:CGSizeMake(mWidth, 40) alignment:UITextAlignmentCenter
                         fontName:@"Helvetica" fontSize:iFontSize];
            
            statusTexture->_color=Color3DMake(1,1,1,1);
            
            // Bind texture
            glBindTexture(GL_TEXTURE_2D, [statusTexture name]);
            // Draw
            [statusTexture drawAtPoint:CGPointMake(m_pCurPosition.x,m_pCurPosition.y-160)];
            
            [statusTexture release];
        }
        else
        {
            statusTexture = [[Texture2D alloc] initWithString:
                             [NSString stringWithFormat:@"%d",m_iNumDownLoadFiles]
                                                   dimensions:CGSizeMake(mWidth, 40) alignment:UITextAlignmentCenter
                                                     fontName:@"Helvetica" fontSize:iFontSize];
            
            statusTexture->_color=Color3DMake(1,1,1,1);
            
            // Bind texture
            glBindTexture(GL_TEXTURE_2D, [statusTexture name]);
            // Draw
            [statusTexture drawAtPoint:CGPointMake(m_pCurPosition.x,m_pCurPosition.y-150)];
            
            [statusTexture release];

            //рисуем иконку
            [self SetColor:Color3DMake(1, 1, 1, 1)];
            
            glVertexPointer(3, GL_FLOAT, 0, vertices);
            glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
            glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
            
            GET_TEXTURE(mTextureId, NameDownLoadFile);
            glBindTexture(GL_TEXTURE_2D, mTextureId);
            
            glTranslatef(m_pCurPosition.x,-270,0);

            //	glRotatef(m_pCurAngle.x, 1, 0, 0);
            //	glRotatef(m_pCurAngle.y, 0, 1, 0);
            glRotatef(m_pCurAngle.z, 0, 0, 1);
            glScalef(30,30,m_pCurScale.z);
            
            glDrawArrays(GL_TRIANGLE_STRIP, 0, m_iCountVertex);
        }
    }
}
//------------------------------------------------------------------------------------------------------
-(void)dealloc{
    [pDataManager release];
    [m_pListAdd release];
    [NameDownLoadFile release];
    [pInfofile release];
    
    [super dealloc];
}

@end
