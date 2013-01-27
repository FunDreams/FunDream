
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

@interface Ob_GroupEmptyPlace : GObject {
    int m_iNumButton;
    FractalString *pChelf;
    int *m_iChelf;
}

-(id)Init:(id)Parent WithName:(NSString *)strName;

-(void)Destroy;
-(void)Start;

- (void)Hide;
- (void)Show;

- (void)ReLinkEmptyPlace;
    
@end
