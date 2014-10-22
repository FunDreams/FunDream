
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
#import "Ob_B_Slayder.h"
#import "Ob_NumIndicator.h"

@interface Ob_Slayder : GObject {
@public
    Ob_B_Slayder *pOb_BSlayder;
    
    Ob_NumIndicator *pObInd1;
    Ob_NumIndicator *pObInd2;
}

-(id)Init:(id)Parent WithName:(NSString *)strName;

-(void)Destroy;
-(void)Start;
-(void)Update;
- (void)SetString;
    
@end
