//
//  FractalString.m
//  FunDreams
//
//  Created by Konstantin Maximov on 28.04.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import "FractalString.h"

@implementation FractalString

- (id)init{
	self = [super init];
	if (self != nil)
    {
        S=(float *)malloc(4);
        T=(float *)malloc(4);
        F=(float *)malloc(4);
    }
    
    return self;
}

- (void)dealloc
{
    free(S);
    free(T);
    free(F);
    [super dealloc];
}
@end
