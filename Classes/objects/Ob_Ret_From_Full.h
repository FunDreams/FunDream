
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

@interface Ob_Ret_From_Full : GObject {
@public
    
    int EndPoint;
    float Xp,Yp;
}

-(id)Init:(id)Parent WithName:(NSString *)strName;

-(void)Destroy;
-(void)Start;
-(void)Update;
    
@end
