
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

#define M_MOVE          0
#define M_COPY          1
#define M_LINK          2
#define M_DROP_BOX      3
#define M_EDIT_PROP     4
#define M_CONNECT       5
#define M_EDIT_NUM      6
#define M_EDIT_EN_EX     7

@interface Ob_Editor_Interface : GObject {
@public
    Ob_ResourceMng *pResIcon;
    
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
    
    DropBoxMng *pInfoFile;
    GObject *PrBar;
    int OldCheck;

    GObject *BDropBox;
    GObject *BMove;
    GObject *BCopy;
    GObject *BLink;
    GObject *BConnect;
    GObject *BSetProp;

    GObject *BTash;
    GObject *PrSyn;
    
    GObject *EditorNum;
    GObject *EditorSelect;
    int iIndexForNum;
    FractalString *StringSelect;
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

- (void)CheckMove;
- (void)CheckCopy;
- (void)CheckLink;

- (void)SynhDropBox;
- (void)SetStatusBar;
- (void)DelStatusBar;

- (void)DoubleTouchObject;

- (void)RemButtonEdit;
- (void)SetButtonEdit;

-(void)dealloc;
    
@end
