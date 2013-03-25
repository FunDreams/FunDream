//
//  MainCycle.h
//  FunDreams
//
//  Created by Konstantin on 19.03.13.
//  Copyright (c) 2013 FunDreams. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StringContainer;

@interface MainCycle : NSObject
{
    StringContainer *m_pContainer;
}

-(id)init:(id)Parent;
-(void)Update:(FractalString *)StartString;

@end
