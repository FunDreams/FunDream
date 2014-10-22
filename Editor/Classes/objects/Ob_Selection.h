
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

@interface Ob_Selection : GObject {
@public
    int OldInterfaceMode;
    FractalString *CurrentStr;
    
    GObject *pObBtnClose;
    GObject *pObBtnUp;
    GObject *pObBtnDown;
    
    GObject *pObBtnSetSimple;
    GObject *pObBtnSetEnter;
    GObject *pObBtnSetExit;
}

-(id)Init:(id)Parent WithName:(NSString *)strName;

-(void)Destroy;
-(void)Start;
-(void)UpdateTmp;
    
@end
