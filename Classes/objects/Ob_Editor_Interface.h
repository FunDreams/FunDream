
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

@interface Ob_Editor_Interface : GObject {
    
    NSMutableArray *aProp;
    NSMutableArray *aObjects;
    NSMutableArray *aObSliders;    
    NSMutableArray *aObPoints;    
}

-(id)Init:(id)Parent WithName:(NSString *)strName;

- (void)Save;
- (void)Load;

-(void)Destroy;
-(void)Start;
-(void)Update;
- (void)UpdatePoints;

- (void)CreateNewPoint;
- (void)DelPoint;

- (void)CreateNewObject;
- (void)CheckObject;
- (void)CheckPoint;
- (void)DelObject;

-(void)dealloc;
    
@end
