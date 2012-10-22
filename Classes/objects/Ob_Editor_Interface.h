
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

@interface Ob_Editor_Interface : GObject {
    
    Ob_GroupButtons *ButtonGroup;
    Ob_GroupEmptyPlace *Eplace;
    ObjectButton *pDropBox;
    
    NSMutableArray *aProp;
    NSMutableArray *aObjects;
    NSMutableArray *aObSliders;    
    NSMutableArray *aObPoints;    
    int IndexCheckPoint;
    int m_iMode;
    int m_iChelf;
    
    DropBoxMng *pInfoFile;
}

-(id)Init:(id)Parent WithName:(NSString *)strName;

- (void)DownLoad;
- (void)UpLoad;
- (void)Save;
- (void)Load;

-(void)Destroy;
-(void)Start;
-(void)UpdatePoints;

- (void)CreateNewPoint;
- (void)DelPoint;

- (void)CreateNewObject;
- (void)CheckObject;
- (void)CheckPoint;
- (void)DelObject;
- (void)SetDropBox;

- (void)CheckMove;
- (void)CheckCopy;
- (void)CheckLink;

-(void)dealloc;
    
@end
