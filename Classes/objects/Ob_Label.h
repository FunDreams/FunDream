
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

@interface Ob_Label : GObject {
@public
    NSMutableString *pNameLabel;
    float m_fOffsetText;
    bool bTexture;
    bool bStartPush;
}

-(id)Init:(id)Parent WithName:(NSString *)strName;

-(void)Destroy;
-(void)Start;
-(void)UpdateLabel;

- (void)SetPush;
- (void)SetUnPush;

- (void) drawText:(NSString*)theString AtX:(float)X Y:(float)Y;
    
@end
