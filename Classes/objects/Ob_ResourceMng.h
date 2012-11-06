
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

#define R_ICON          1
#define R_TEXTURE       2
#define R_SOUND         3

@interface Ob_ResourceMng : GObject {
    int m_iTypeRes;
    GObject *pObBtnClose;
}

-(id)Init:(id)Parent WithName:(NSString *)strName;

-(void)Destroy;
-(void)Start;
-(void)Update;
- (void) drawText:(NSString*)theString AtX:(float)X Y:(float)Y;
    
@end
