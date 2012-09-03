
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

@interface Ob_NumIndicator : GObject {
@public
    float *m_fCurValue;
    float m_fWNumber;
    float WSym,HSym;
    float m_fScale;
    bool m_bDoubleTouch;
    NSMutableString *m_strNameContainer;
}

-(id)Init:(id)Parent WithName:(NSString *)strName;

-(void)Destroy;
-(void)Start;
-(void)Update;
-(void)UpdateNum;

@end
