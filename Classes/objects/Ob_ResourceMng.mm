//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_ResourceMng.h"

@interface Ob_ResourceMng () <DBRestClientDelegate>
@end

@implementation Ob_ResourceMng
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_fCurrentOffset=0;
        m_bHiden=YES;
        m_iLayer = layerTemplet;
        m_iLayerTouch=layerTouch_0;//слой касания
        
        pListNamesRes = [[NSMutableDictionary alloc] init];
        pListNamesUpdateFolder = [[NSMutableDictionary alloc] init];
        pListNamesLocalFolder = [[NSMutableDictionary alloc] init];
        fm = [NSFileManager defaultManager];
        bShow=NO;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
//- (void)SetDefault{}
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
   [m_pObjMng->pMegaTree SetCell:(LINK_INT_V(m_iTypeRes,m_strName,@"m_iTypeRes"))];
    
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    [m_pObjMng->pMegaTree SetCell:(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"))];
    
    [m_pObjMng AddToGroup:@"Res" Object:self];
}
//------------------------------------------------------------------------------------------------------
- (void)Hide{
    
    if(bShow==NO)return;
    bShow=NO;

    DESTROY_OBJECT(pObBtnClose);
    DESTROY_OBJECT(pObBtnSyn);
    pObBtnClose=nil;
    pObBtnSyn=nil;
    
    for (int i=0; i<[m_pChildrenbjectsArr count]; i++) {
        
        DESTROY_OBJECT([m_pChildrenbjectsArr objectAtIndex:i]);
    }
    
    [m_pChildrenbjectsArr removeAllObjects];
    LoadData=NO;
}
//------------------------------------------------------------------------------------------------------
- (void)Show{
    
    if(bShow==YES)return;
    bShow=YES;
    
    pObBtnClose=UNFROZE_OBJECT(@"ObjectButton",@"ButtonClose",
                               SET_STRING_V(@"Close.png",@"m_DOWN"),
                               SET_STRING_V(@"Close.png",@"m_UP"),
                               SET_FLOAT_V(64,@"mWidth"),
                               SET_FLOAT_V(64*FACTOR_DEC,@"mHeight"),
                               SET_BOOL_V(YES,@"m_bLookTouch"),
                               SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                               SET_STRING_V(NAME(self),@"m_strNameObject"),
                               SET_STRING_V(@"Close",@"m_strNameStage"),
                               SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                               SET_VECTOR_V(Vector3DMake(-35,290,0),@"m_pCurPosition"));
//------------------------------------------------------------------------------------------------------
    NSString *NameFoler = @"Objects_1";
    
    Fstring = GET_ID_V(@"DoubleTouchFractalString");
    DEL_CELL(@"DoubleTouchFractalString");

    float StepY=50;
    m_fStartOffset=mWidth*0.55f;
    float OffsetY=m_fStartOffset;
    m_fUpLimmit=OffsetY;

    NSError *Error=nil;
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:bundleRoot error:&Error];
    
    NumButtons=0;
    
    for (NSString *tNameFolder in dirContents) {
        
        if([tNameFolder isEqualToString:NameFoler]){

            NSString *strNameInsideFolder=[bundleRoot stringByAppendingPathComponent:tNameFolder];
            NSArray *dirContentInFolder = [fm contentsOfDirectoryAtPath:strNameInsideFolder error:&Error];
            int i=0;
            
            for (NSString *tNameFile in dirContentInFolder) {
                                    
                float fOffset=0;
                float TmpOff=115;
                
                if(i%2==0){
                    fOffset=-TmpOff;
                    OffsetY-=StepY;
                    m_fDownLimmit=OffsetY-64*FACTOR_DEC;
                }
                else fOffset=TmpOff;
                
                GObject *pOb = UNFROZE_OBJECT(@"Ob_Label",@"Label",
                              LINK_ID_V(self,@"m_pOwner"),
                              SET_STRING_V(tNameFile,@"pNameLabel"),
                              SET_BOOL_V(bTexture,@"bTexture"),
                              SET_VECTOR_V(Vector3DMake(fOffset, OffsetY, 0),@"m_pOffsetCurPosition"));

                [m_pChildrenbjectsArr addObject:pOb];
                
                if(Fstring && [Fstring->sNameIcon isEqualToString:tNameFile]){
                    
                    //pOb set selection
                    //m_fCurrentOffset высчитать
                    [self LimmitOffset];
                }
                i++;
            }
        }
    }
//-----------------------------------------------------------------------------------------------------
    if(LoadData==NO){
        
        bNeedSyn=NO;
        LoadData=YES;
        
        if(restClient!=nil)[restClient release];
        
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;

        NSString *TmpDirInDropBox = @"/_Resource/";
        TmpDirInDropBox = [TmpDirInDropBox stringByAppendingPathComponent:RootFolder];

        [restClient loadMetadata:TmpDirInDropBox];

        m_iMode=M_LOAD_METADATA;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetSelection{
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
    m_fCurrentOffset=0;
    
    mWidth=460;
    mHeight=510;
        
	[super Start];
            
    bTexture=NO;
    switch (m_iTypeRes) {
        case R_TEXTURE:
            RootFolder=@"/Textures";
            [self InitDirectory];
            bTexture=YES;
            [self LoadTextures];
            break;
            
        case R_ICON:
            RootFolder=@"/Icons";
            [self InitDirectory];
            bTexture=YES;
            [self LoadTextures];
            break;
            
        case R_SOUND:
            RootFolder=@"/Sounds";
            [self InitDirectory];
            bTexture=NO;
            [self LoadSounds];
            break;
            
        case R_SOUND_LOOP:
            RootFolder=@"/LoobSounds";
            [self InitDirectory];
            bTexture=NO;
            [self LoadLoopSounds];
            break;

        case R_ATLAS:
            RootFolder=@"/Atlases";
            [self InitDirectory];
            bTexture=YES;
            break;

        default:
            RootFolder=@"/Icons";
            [self InitDirectory];
            bTexture=YES;
            break;
    }
    
    [self SetTouch:YES];
}
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
- (void)InitDirectory{
    NSArray *cacheDirectories = NSSearchPathForDirectoriesInDomains
                                        (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *cacheDirectory = [cacheDirectories objectAtIndex:0];
    bundleRoot = [[cacheDirectory stringByAppendingPathComponent:RootFolder] retain];

    NSError *Error=nil;
    
    [fm createDirectoryAtPath:bundleRoot withIntermediateDirectories:NO attributes:nil error:&Error];
}
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
- (void)LoadRes:(NSString *)Path withName:(NSString *)Name{
    
    NSRange toprange = [Name rangeOfString: @"."];
    
    if(toprange.length==0)return;
    
    NSString *Extention = [Name substringFromIndex:toprange.location+1];
    
    switch (m_iTypeRes) {
        case R_TEXTURE:
            break;
            
        case R_ICON:{
            
            if(![Extention isEqualToString:@"png"] && ![Extention isEqualToString:@"jpg"])return;
                        
            [m_pObjMng->m_pParent loadTexture:Path WithExt:Extention NameFile:Name];

        }
            break;
            
        case R_SOUND:
            break;
            
        case R_SOUND_LOOP:
            break;
            
        case R_ATLAS:
            break;
            
        default:
            break;
    }

}
//------------------------------------------------------------------------------------------------------
- (void)LoadLoopSounds{
}
//------------------------------------------------------------------------------------------------------
- (void)LoadSounds{
}
//------------------------------------------------------------------------------------------------------
- (void)LoadTextures{
        
    NSError *Error=nil;

    NSArray *dirContents = [fm contentsOfDirectoryAtPath:bundleRoot error:&Error];
    
    NumButtons=0;

    for (NSString *tString2 in dirContents) {

        NSString *strNameInsideFolder=[bundleRoot stringByAppendingPathComponent:tString2];
        NSArray *dirContentInFolder = [fm contentsOfDirectoryAtPath:strNameInsideFolder error:&Error];
        
        for (NSString *tString in dirContentInFolder) {
            
            NSRange toprange = [tString rangeOfString: @"."];
            
            if(toprange.length==0)continue;
            
            NSString *Extention = [tString substringFromIndex:toprange.location+1];
            
            if(![Extention isEqualToString:@"png"] && ![Extention isEqualToString:@"jpg"])
                continue;
            
            NSString *REZ=strNameInsideFolder;
            REZ=[REZ stringByAppendingPathComponent:tString];
            
            [m_pObjMng->m_pParent loadTexture:REZ WithExt:Extention NameFile:tString];
            NumButtons++;
            [pListNamesRes setObject:tString forKey:tString];
        }
    }
}
//------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------
- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error{
    
    LoadData=NO;
}
//------------------------------------------------------------------------------------------------------
- (void)UploadResWithName:(NSString *)NameRes{
    
    switch (m_iMode) {
        case R_ICON:
            [m_pObjMng->m_pParent DeleteTexture:NameRes];
            break;
            
        case R_TEXTURE:
            [m_pObjMng->m_pParent DeleteTexture:NameRes];
            break;
            
        case R_SOUND:
            [m_pObjMng->m_pParent DeleteSound:NameRes];
            break;
            
        case R_ATLAS:
            //
            break;
            
        default:
            break;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)UploadRosourceFolder:(NSString *)NameFolder{
    
    NSString *StrFolder= [bundleRoot stringByAppendingPathComponent:NameFolder];
    
    NSError *Error=nil;
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:StrFolder error:&Error];
    
    for (int i=0;i<[dirContents count];i++) {
        
        NSString *tString = [dirContents objectAtIndex:i];
        [self UploadResWithName:tString];
        
        NSString *NameFile = [StrFolder stringByAppendingPathComponent:tString];
        [fm removeItemAtPath:NameFile error:&Error];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SynRes{
    
    LoadData=YES;
    
    if(PrBar==nil)
        PrBar =  CREATE_NEW_OBJECT(@"Ob_ProgressBar",@"Progress",nil);

    for (int i=0;i<[pArrayContent count];i++) {//удаление папок ресурка
        
        NSString *tString = [pArrayContent objectAtIndex:i];
        
        NSString *pPath=[bundleRoot stringByAppendingPathComponent:tString];
        
        [self UploadRosourceFolder:pPath];
        
        NSError *Error=nil;
        [fm removeItemAtPath:pPath error:&Error];
    }
    [pArrayContent release];
    
//удаляем файлы и ресурсы-------------------------------------------------------------------------------
    NSEnumerator *enumerator = [pListNamesLocalFolder keyEnumerator];
    NSString *tString;
    
    while(tString=[enumerator nextObject]){//по всем папкам
        
        //имя папки и список внутренних файлов в DropBox'e
        NSMutableArray *TmpLocalFolder = [pListNamesLocalFolder objectForKey:tString];
        NSString *StrFile= [bundleRoot stringByAppendingPathComponent:tString];
        
        for(int i=0;i<[TmpLocalFolder count];i++){
            
            NSString *NameFile=[TmpLocalFolder objectAtIndex:i];
            
            [self UploadResWithName:NameFile];
            
            NSError *Error=nil;
            [fm removeItemAtPath:StrFile error:&Error];
        }
    }
//------------------------------------------------------------------------------------------------------
    pArrayContent = nil;
    bNeedSyn=NO;
    
    DESTROY_OBJECT(pObBtnSyn);
    pObBtnSyn=nil;
    
    m_iMode=M_SYNH_FOLDERS;

    [self DownLoadFiles];
}
//------------------------------------------------------------------------------------------------------
- (void)DownLoadFiles{
    
    if(restClient!=nil)[restClient release];
    
    restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    restClient.delegate = self;
    bool bLoad=NO;
    
    NSEnumerator *enumerator = [pListNamesUpdateFolder keyEnumerator];
    NSString *tNameFolder;
    
    while(tNameFolder=[enumerator nextObject]){//по всем папкам
        
        //имя папки и список внутренних файлов в DropBox'e
        NSMutableArray *TmpLocalFolder = [pListNamesUpdateFolder objectForKey:tNameFolder];
        NSString *StrFolder= [bundleRoot stringByAppendingPathComponent:tNameFolder];
        
        for(int i=0;i<[TmpLocalFolder count];i++){
            
            NSString *NameFileTmp=[TmpLocalFolder objectAtIndex:i];
            //имя файла локально
            
            NSString *NameFile=[StrFolder stringByAppendingPathComponent:NameFileTmp];
            
            NSString *NameFileInDropBox = @"/_Resource/";
            NameFileInDropBox = [NameFileInDropBox  stringByAppendingPathComponent:RootFolder];
            NameFileInDropBox = [NameFileInDropBox stringByAppendingPathComponent:tNameFolder];
            NameFileInDropBox = [NameFileInDropBox stringByAppendingPathComponent:NameFileTmp];

            [restClient loadFile:NameFileInDropBox intoPath:NameFile];
            bLoad=YES;

            [TmpLocalFolder removeObjectAtIndex:i];
        }
    }

    if(bLoad==NO){
        [self FinishDownLoad];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)FinishDownLoad{
    if(PrBar!=nil)
    {
        DESTROY_OBJECT(PrBar);
        PrBar=nil;
        m_iMode=0;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath{
    
    NSString *NameFile = [localPath lastPathComponent];

    [self LoadRes:localPath withName:NameFile];
    NSLog(@"File loaded successfully to path: %@", localPath);
    [self DownLoadFiles];
}
//------------------------------------------------------------------------------------------------------
- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error{
    
    NSLog(@"There was an error loading the file - %@", error);
    [self FinishDownLoad];
}
//------------------------------------------------------------------------------------------------------
- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata{

    NSEnumerator *enumerator = nil;
    NSString *TmpName = nil;
    
    if(m_iMode==M_LOAD_METADATA){
        
        NSError *Error=nil;
        NSArray *dirContents = [fm contentsOfDirectoryAtPath:bundleRoot error:&Error];

        NSMutableArray *pArrayMetaData=[NSMutableArray arrayWithArray:metadata.contents];
        
        if(pArrayContent!=nil)[pArrayContent release];
        pArrayContent=[[NSMutableArray arrayWithArray:dirContents] retain];

        [pListNamesUpdateFolder removeAllObjects];
repeate:

        for (int i=0;i<[pArrayContent count];i++) {

            NSString *tString = [pArrayContent objectAtIndex:i];

            for (int j=0;j<[pArrayMetaData count];j++) {

                 DBMetadata *file = [pArrayMetaData objectAtIndex:i];

                if([file.filename isEqualToString:tString]){

                    [pArrayContent removeObjectAtIndex:i];
                    [pArrayMetaData removeObjectAtIndex:j];
                    
                    if(file.isDirectory){
                        NSMutableArray *TmpArr =[NSMutableArray array];
                        [pListNamesUpdateFolder setObject:TmpArr forKey:tString];
                    }
                    goto repeate;
                }
            }
        }
        
        for (int i=0;i<[pArrayMetaData count];i++) {
            
            DBMetadata *file = [pArrayMetaData objectAtIndex:i];

            NSString *pPath=[bundleRoot stringByAppendingPathComponent:file.filename];
            
            NSError *Error=nil;
            
            [fm createDirectoryAtPath:pPath withIntermediateDirectories:NO attributes:nil error:&Error];
            
            NSMutableArray *TmpArr =[NSMutableArray array];
            [pListNamesUpdateFolder setObject:TmpArr forKey:file.filename];
            bNeedSyn=YES;
        }
        
        if([pListNamesUpdateFolder count]>0){
            
            iCountInc=1;
            m_iMode=M_LOAD_METADATA_F;
            goto LOAD_FOLDER;
        }
    }
    else if(m_iMode==M_LOAD_METADATA_F){
        
        enumerator = [pListNamesUpdateFolder keyEnumerator];
        
        for(int i=0;i<iCountInc;i++)
            TmpName = [enumerator nextObject];

        if (metadata.isDirectory)
        {
            NSMutableArray *TmpArr=[pListNamesUpdateFolder objectForKey:TmpName];
            
            if(TmpArr!=nil){

                for (DBMetadata *file in metadata.contents) {
                    
                    if(!file.isDirectory)
                        [TmpArr addObject:file.filename];
                }

            }
        }
        iCountInc++;

LOAD_FOLDER:;
        
        if([pListNamesUpdateFolder count]>iCountInc-1){
            
            enumerator = [pListNamesUpdateFolder keyEnumerator];
            
            for(int i=0;i<iCountInc;i++)
                TmpName = [enumerator nextObject];
                        
            NSString *TmpDirInDropBox = @"/_Resource/";
            TmpDirInDropBox = [TmpDirInDropBox stringByAppendingPathComponent:RootFolder];
            TmpDirInDropBox = [TmpDirInDropBox stringByAppendingPathComponent:TmpName];
            
            if(restClient!=nil)[restClient release];
            
            restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
            restClient.delegate = self;

            [restClient loadMetadata:TmpDirInDropBox];
        }
        else
        {
            [pListNamesLocalFolder removeAllObjects];
            enumerator = [pListNamesUpdateFolder keyEnumerator];
            NSString *tString;
            
            while(tString=[enumerator nextObject]){//по всем папкам
                
                //имя папки и список внутренних файлов в DropBox'e
                NSMutableArray *TmpFolder = [pListNamesUpdateFolder objectForKey:tString];
                
                //получаем локальный список файлов в папке
                NSError *Error=nil;
                NSString *TmpDir=[bundleRoot stringByAppendingPathComponent:tString];
                NSArray *dirContentsLocal = [fm contentsOfDirectoryAtPath:TmpDir error:&Error];
                
                NSMutableArray *pArrayContentTmp=[NSMutableArray arrayWithArray:dirContentsLocal];
                [pListNamesLocalFolder setObject:pArrayContentTmp forKey:tString];
rep:
                for(int i=0;i<[TmpFolder count];i++){
                    
                    NSString *pNameFileDropBox = [TmpFolder objectAtIndex:i];
                    
                    for(int j=0;j<[pArrayContentTmp count];j++){
                        
                        NSString *pNameFileLocalContent = [pArrayContentTmp objectAtIndex:j];
                        
                        //находим одинаковые
                        if([pNameFileLocalContent isEqualToString:pNameFileDropBox]){
                            
                            [TmpFolder removeObjectAtIndex:i];
                            [pArrayContentTmp removeObjectAtIndex:j];
                            goto rep;
                        }
                    }
                    
                    if([pArrayContentTmp count]>0)
                        bNeedSyn=YES;
                }

                
                if([TmpFolder count]>0)
                    bNeedSyn=YES;
            }
            
            if(bNeedSyn==YES){
                
                pObBtnSyn=UNFROZE_OBJECT(@"ObjectButton",@"ButtonSyn",
                                           SET_STRING_V(@"Button_Synh.png",@"m_DOWN"),
                                           SET_STRING_V(@"Button_Synh.png",@"m_UP"),
                                           SET_FLOAT_V(64,@"mWidth"),
                                           SET_FLOAT_V(64*FACTOR_DEC,@"mHeight"),
                                           SET_BOOL_V(YES,@"m_bLookTouch"),
                                           SET_INT_V(layerInterfaceSpace8,@"m_iLayer"),
                                           SET_STRING_V(NAME(self),@"m_strNameObject"),
                                           SET_STRING_V(@"SynRes",@"m_strNameStage"),
                                           SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                                           SET_VECTOR_V(Vector3DMake(-35,232,0),@"m_pCurPosition"));
                
            }
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
//------------------------------------------------------------------------------------------------------
- (void)InitProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)PrepareProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{}
//------------------------------------------------------------------------------------------------------
- (void)Close{

    OBJECT_PERFORM_SEL(@"Ob_Editor_Interface", @"CloseChoseIcon");
    DESTROY_OBJECT(self);
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{

    [super Destroy];
    LoadData=NO;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEndedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    m_bStartPush=NO;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    m_bStartPush=NO;
}
//------------------------------------------------------------------------------------------------------
-(void)LimmitOffset{
    if((m_fCurrentOffset+m_fStartOffset)<m_fUpLimmit)
        m_fCurrentOffset=m_fUpLimmit-m_fStartOffset;
    if((m_fCurrentOffset+m_fStartOffset)>-m_fDownLimmit)
        m_fCurrentOffset=-m_fDownLimmit-m_fStartOffset;
}
//------------------------------------------------------------------------------------------------------
- (void)Move:(CGPoint)Point{
    if(m_bStartPush==YES && NumButtons > 18){
        float DeltaF=Point.y-m_pStartPoint.y;
        m_fCurrentOffset+=DeltaF;
        
        [self LimmitOffset];

        m_pStartPoint=Point;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    [self Move:Point];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    [self Move:Point];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    m_bStartPush=YES;
    m_pStartPoint=Point;
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{
    
    [pListNamesLocalFolder release];
    [pListNamesUpdateFolder release];
    [pListNamesRes release];
    
    [restClient release];
    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
@end