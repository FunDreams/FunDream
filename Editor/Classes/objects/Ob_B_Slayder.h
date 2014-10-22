
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
#import "Ob_NumIndicator.h"

@interface Ob_B_Slayder : GObject {
@public
    Vector3D m_vStartTouchPoint;
    Vector3D m_vCurrentTouchPoint;
    Vector3D m_vCurrentOffsetPos;
    bool m_bTouchButton;
    float *m_fLink;
    
    FractalString *pInsideString;
    Ob_NumIndicator *pObIndicator;
}

-(id)Init:(id)Parent WithName:(NSString *)strName;

-(void)Show;
-(void)Destroy;
-(void)Start;
-(void)Update;
-(void)ProcMove:(CGPoint)Point;
-(void)setStartPos;
    
@end
