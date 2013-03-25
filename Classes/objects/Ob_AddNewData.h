
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

@interface Ob_AddNewData : GObject {
@public
    int OldInterfaceMode;
    
    GObject *pObBtnClose;
    GObject *pObBtnUp;
    
    MATRIXcell *pMatr;
}

-(id)Init:(id)Parent WithName:(NSString *)strName;
- (void)DestroyAllButton;

-(void)Destroy;
-(void)Start;
-(void)UpdateTmp;
    
@end
