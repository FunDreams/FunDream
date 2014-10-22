
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
#import "Ob_GroupEmptyPlace.h"
#import "Ob_GroupButtons.h"
#import "ObjectButton.h"
#import "DropBoxMng.h"
#import "Ob_ResourceMng.h"
#import "Ob_TouchView.h"

#define M_MOVE          0
#define M_COPY          1
#define M_LINK          2
#define M_DROP_BOX      3
#define M_EDIT_PROP     4
#define M_CONNECT       5
#define M_EDIT_NUM      6
#define M_EDIT_EN_EX    7
#define M_CONNECT_IND   8
#define M_SEL_TEXTURE   9
#define M_ADD_NEW_DATA  10
#define M_FULL_SCREEN   11
#define M_DEBUG         12
#define M_SEL_SOUND     13
#define M_TRANSLATE     14

@interface Ob_Editor_Interface : GObject {
@public
    Ob_ResourceMng *pResTexture;
    Ob_ResourceMng *pResSound;
    
    Ob_GroupButtons *ButtonGroup;
    Ob_GroupEmptyPlace *Eplace;
    int iIndexCheck;
    int iIndexChelf;
    
    NSMutableArray *aProp;
    NSMutableArray *aObjects;
    NSMutableArray *aObSliders;    
    NSMutableArray *aObPoints;    
    int IndexCheckPoint;
    
    int m_iMode;
    int OldInterfaceMode;
    
    Ob_TouchView *pTouchV;
    DropBoxMng *pInfoFile;
    GObject *PrBar;
    int OldCheck;

    GObject *Back;

    GObject *Sl1;
    GObject *Sl2;
    GObject *Sl3;
    
    GObject *RectView;
    GObject *BDropPlus;
    GObject *BDropBox;
    GObject *BMove;
    GObject *BCopy;
    GObject *BLink;
    GObject *BConnect;
    GObject *BEnEx;
    GObject *BFullScreen;
    GObject *BDebug;
    GObject *BTranslate;
    GObject *BTIn;
    GObject *BTOut;
    GObject *BTIn2;
    GObject *BTOut2;
    GObject *BTSetZero;
    GObject *BSetProp;
    GObject *BSetActivity;
    GObject *BigWheel;
    GObject *SetMatrix;
    
    GObject *BEn;
    GObject *BEx;
    GObject *BSimple;
    
    GObject *BGroupUp;
    GObject *BGroupDown;

    GObject *BLevelUp;
    GObject *BAssUp;
    GObject *BAssDown;

    GObject *BMoveObUp;
    GObject *BMoveObDown;

    NSMutableArray *pArrayToDel;

    GObject *BTash;
    GObject *PrSyn;
    
    GObject *EditorNum;
    GObject *EditorSelect;
    GObject *EditorSelectPar;
    GObject *EditorAddNewData;
    int iIndexForNum;
    int iTypeArray;
    FractalString *StringSelect;
    int IndexSelect;
    
    MATRIXcell *pMatrTmp;
    HeartMatr *EndHeart;
    FractalString *pConnString;
    int m_iIndexStart;
}

-(id)Init:(id)Parent WithName:(NSString *)strName;

- (void)DownLoad;
- (void)UpLoad;
- (void)Save;
- (void)Load;

-(void)Destroy;
-(void)Start;
- (void)CreateButtons;
- (void)CloseChoseIcon;

- (void)SetMode:(int)iModeTmp;

- (void)SetDropBox;
- (void)ClearInterface;
- (void)SetActivSpace;

- (void)CheckMove;
- (void)CheckCopy;
- (void)CheckLink;

- (void)SynhDropBox;
- (void)SetStatusBar;
- (void)DelStatusBar;

- (void)DoubleTouchObject;
- (void)SelTexture;

- (int)GetMatrixSize:(MATRIXcell *)pMatr;

- (void)RemButtonEdit;
- (void)SetButtonEdit;
- (void)SetButtonInOut;

- (void)removeFundInt;
- (void)CreateFundInt;

- (void)RemoveTmpButton;
- (void)SetCurMatrix;

- (void)UpdateB;

-(void)dealloc;
    
@end
