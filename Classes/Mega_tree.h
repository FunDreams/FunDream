//
//  Mega_tree.h
//  sudoku
//
//  Created by Konstantin on 22.07.11.
//  Copyright 2011 FunDreams. All rights reserved.
//

#import <Foundation/Foundation.h>

//-------------------------------------------------------------------------------------------
@interface UniCell:NSObject {
@public
	NSString *mpName;
	NSString *mpType;
	id mpIdPoint;
    bool mbLocal;
    int mSize;
}

- (id)InitWithName:(NSString *)strName WithType:(NSString *)strType Local:(bool)bLocal WithPoint:(id)parPoint;

- (id)InitWithNameForId:(NSString *)strName WithType:(NSString *)strType
                  Local:(bool)bLocal WithPoint:(id *)parPPoint;

- (id)Link_Int:(int *)parPoint withKey:(id)sKey,...;
- (id)Set_Int:(int)Value withKey:(id)sKey,...;

- (id)Link_Float:(float *)parPoint withKey:(id)sKey,...;
- (id)Set_Float:(float)Value withKey:(id)sKey,...;

- (id)Link_Bool:(bool *)parPoint withKey:(id)sKey,...;
- (id)Set_Bool:(bool)Value withKey:(id)sKey,...;

- (id)Link_Vector:(Vector3D *)parPoint withKey:(id)sKey,...;
- (id)Set_Vector:(Vector3D)Value withKey:(id)sKey,...;

- (id)Link_Color:(Color3D *)parPoint withKey:(id)sKey,...;
- (id)Set_Color:(Color3D)Value withKey:(id)sKey,...;

- (id)Link_Id:(id)parPoint withKey:(id)sKey,...;

- (id)Link_String:(NSString *)parPoint withKey:(id)sKey,...;
- (id)Set_String:(NSString *)Value withKey:(id)sKey,...;

- (id)Link_Point:(void *)parPoint withKey:(id)sKey,...;

-(void)CrearCell;
-(void)dealloc;

@end
//-------------------------------------------------------------------------------------------
@interface Mega_tree : Dictionary_Ex {}

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

-(void)RemoveValue:(NSString*)sKey;
-(void)dealloc;

@end
