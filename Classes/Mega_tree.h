//
//  Mega_tree.h
//  sudoku
//
//  Created by Konstantin on 22.07.11.
//  Copyright 2011 FunDreams. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UniCell;

@interface Mega_tree : Dictionary_Ex {
}

-(id)init;

-(void)SetCell:(UniCell *)pCell;
-(void)CopyCell:(UniCell *)pCell;

-(int *)GetIntValue:(id)sKey,...;
-(float *)GetFloatValue:(id)sKey,...;
-(bool *)GetBoolValue:(id)sKey,...;

-(Vector3D *)GetVectorValue:(id)sKey,...;
-(Color3D *)GetColorValue:(id)sKey,...;

-(id)GetIdValue:(id)sKey,...;
-(void *)GetPointValue:(id)sKey,...;

- (void)RemoveCell:(id)sKey, ...;
-(void)RemoveValue:(NSString*)sKey;
-(void)dealloc;

@end
