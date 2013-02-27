
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

@interface Ob_SelectionPar : GObject {
@public
    int OldInterfaceMode;
    GObject *pObBtnClose;
    
    HeartMatr *EndHeart;
    int m_iIndexStart;
    MATRIXcell *pMatr;
    FractalString *pConnString;
    
    NSMutableArray *pArrayEnter;
    NSMutableArray *pArrayExit;

    NSMutableArray *pArrayEnterUse;
    NSMutableArray *pArrayExitUse;
        
    GObject *IconEnters;
    GObject *IconExits;
    GObject *Line;
}

-(id)Init:(id)Parent WithName:(NSString *)strName;

-(void)Destroy;
-(void)Start;
-(void)UpdateTmp;
    
@end
