
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

@interface Ob_Editor_Interface : GObject {
@public
    Ob_ResourceMng *pResIcon;
    
    Ob_GroupButtons *ButtonGroup;
    Ob_GroupEmptyPlace *Eplace;
    float *FCheck;
    
    NSMutableArray *aProp;
    NSMutableArray *aObjects;
    NSMutableArray *aObSliders;    
    NSMutableArray *aObPoints;    
    int IndexCheckPoint;
    int m_iMode;
    int m_iChelf;
    
    DropBoxMng *pInfoFile;
    GObject *PrBar;
    int OldCheck;

    GObject *BDropBox;
    GObject *BMove;
    GObject *BCopy;
    GObject *BLink;
    GObject *BConnect;

    GObject *BTash;
    GObject *PrSyn;
}

-(id)Init:(id)Parent WithName:(NSString *)strName;

- (void)DownLoad;
- (void)UpLoad;
- (void)Save;
- (void)Load;

-(void)Destroy;
-(void)Start;
-(void)UpdatePoints;
- (void)CreateButtons;
- (void)CloseChoseIcon;

- (void)CreateNewPoint;
- (void)DelPoint;

- (void)CreateNewObject;
- (void)CheckObject;
- (void)CheckPoint;
- (void)DelObject;
- (void)SetDropBox;
- (void)ClearInterface;

- (void)CheckMove;
- (void)CheckCopy;
- (void)CheckLink;

- (void)SynhDropBox;
- (void)SetStatusBar;
- (void)DelStatusBar;

- (void)DoubleTouchObject;

-(void)dealloc;
    
@end
