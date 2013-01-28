//
//  InfoFile.h
//  FunDreams
//
//  Created by Konstantin on 27.09.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import <Foundation/Foundation.h>
    
#define UPDATE_INFO             1
#define UPLOAD_DATA_STR         2
#define DOWNLOAD_DATA_STR       3
@class InfoFile;
@interface DropBoxMng : GObject{
@public
    InfoFile *pInfofile;
    CDataManager *pDataManager;
    NSMutableDictionary *m_pListAdd;
    
    FractalString *pDropBoxString;
    int m_iCurrentSelect;
    
    bool bNeedUpload;
    bool bDropBoxWork;
    bool bErrorDownLoad;
    bool bErrorMetaData;
    
    int m_iMode;
    
    NSMutableString *NameDownLoadFile;
    int m_iNumDownLoadFiles;
    int m_iDownloadPlace;
}

-(id)Init:(id)Parent WithName:(NSString *)strName;
-(void)UpdateButt;
-(void)Hide;
//-(void)Show;
-(void)DownLoadInfoFile;
-(void)SaveInfoStringToDropBox;
-(void)Synhronization;
- (void)CreateOb:(FractalString *)pFrStr;

-(void)AddToUploadString:(FractalString *)pStr;
-(void)DefFromUploadString:(FractalString *)pStr;
-(void)AddToDelArray:(FractalString *)pStr;
-(void)DownLoadString:(FractalString *)pFsr WithPlace:(int)iPlace;
-(void)loadAndMerge;

@end
