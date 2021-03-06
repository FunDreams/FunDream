
//
//  Ob_Templet.h
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Object.h"
#import "ObjectParticle.h"

#define R_TEXTURE       1
#define R_SOUND         2
#define R_ATLAS         3

#define M_LOAD_METADATA    1
#define M_LOAD_METADATA_F  2
#define M_SYNH_FOLDERS     3

@interface Ob_ResourceMng : GObject {
@public
    
    bool m_bShowing;
    bool m_bIcon;
    NSMutableDictionary *pDicSizeFile;
    int m_iCurrentSelect;
    NSString *NameDownLoadFile;
    int m_iNumDownLoadFiles;
    GObject *PrBar;

    bool LoadData;
    bool bNeedSyn;
    
    int m_iMode;
    bool bShow;
    DBRestClient *restClient;
    NSString* bundleRoot;
    bool bTexture;
    NSString *RootFolder;
    int m_iTypeRes;
    GObject *pObBtnClose;
    GObject *pObBtnSyn;

    GObject *pObBIcon1;
    GObject *pObBIcon2;
    GObject *pObBIcon3;

    int NumButtons;
    float m_fCurrentOffset;
    float m_fUpLimmit,m_fDownLimmit;
    
    bool m_bStartPush;
    CGPoint m_pStartPoint;
    int iNumIcon;
    FractalString *Fstring;
    NSMutableDictionary *pListNamesUpdateFolder;
    NSMutableDictionary *pListNamesLocalFolder;
        
    NSMutableArray *pArrayContent;
    NSMutableArray *m_pFolderButton;
    
    NSFileManager *fm;
    int iCountInc;
    NSMutableString *NameFolerSelect;
    
    int OldInterfaceMode;
}

-(id)Init:(id)Parent WithName:(NSString *)strName;

- (void)UploadRosourceFolder:(NSString *)NameFolder;
- (void)UploadResWithName:(NSString *)NameRes;
-(void)Destroy;
-(void)Start;
-(void)Update;

- (void)Show;
- (void)Hide;

- (void)SynRes;
- (void)Move:(CGPoint)Point;
- (void)SetSelection;
- (void)LimmitOffset;
- (void)InitDirectory;
- (void)FinishDownLoad;
    
- (void)LoadLoopSounds;
- (void)LoadSounds;
- (void)LoadTextures;
- (void)DownLoadFiles;
- (void)LoadRes:(NSString *)Path withName:(NSString *)Name;

@end
