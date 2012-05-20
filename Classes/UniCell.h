//
//  UniCell.h
//  SeaFight
//
//  Created by Sergius Bobrovsky on 23.12.11.
//  Copyright (c) 2011 FunDreams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UniCell : NSObject
{
@public
    NSString *mpName;
    NSString *mpType;
    id mpIdPoint;
    id *mppIdPoint;
    bool mbLocal;
    int mSize;
}

//@property (nonatomic, retain) NSString* name;
//@property (nonatomic, retain) NSString* type;
//@property (nonatomic, retain) id idPoint;
//
//@property (nonatomic) bool local;
//@property (nonatomic) int size;

//- (id) InitWithName:(NSString *)strName WithType:(NSString *)strType Local:(bool)bLocal WithPoint:(id)parPoint;
//
//- (id) InitWithNameForId:(NSString *)strName WithType:(NSString *)strType
//                  Local:(bool)bLocal WithPoint:(id *)parPPoint;

+ (id) Link_Int:(int *)parPoint withKey:(id)sKey,...;
+ (id) Set_Int:(int)Value withKey:(id)sKey,...;

+ (id) Link_Float:(float *)parPoint withKey:(id)sKey,...;
+ (id) Set_Float:(float)Value withKey:(id)sKey,...;

+ (id) Link_Bool:(bool *)parPoint withKey:(id)sKey,...;
+ (id) Set_Bool:(bool)Value withKey:(id)sKey,...;

+ (id) Link_Vector:(Vector3D *)parPoint withKey:(id)sKey,...;
+ (id) Set_Vector:(Vector3D)Value withKey:(id)sKey,...;

+ (id) Link_Color:(Color3D *)parPoint withKey:(id)sKey,...;
+ (id) Set_Color:(Color3D)Value withKey:(id)sKey,...;

+ (id) Link_Id:(id *)parPoint withKey:(id)sKey,...;

+ (id) Link_String:(NSMutableString *)parPoint withKey:(id)sKey,...;
+ (id) Set_String:(NSString *)Value withKey:(id)sKey,...;

+ (id) Link_Point:(void *)parPoint withKey:(id)sKey,...;

-(void)ClearCell;
-(void)dealloc;

@end
