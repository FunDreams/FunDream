//
//  UniCell.m
//  SeaFight
//
//  Created by Sergius Bobrovsky on 23.12.11.
//  Copyright (c) 2011 FunDreams. All rights reserved.
//

#import "UniCell.h"

@implementation UniCell
//------------------------------------------------------------------------------------------------------
//@synthesize name = mpName;
//@synthesize type = mpType;
//@synthesize idPoint = mpIdPoint;
//@synthesize local = mbLocal;
//@synthesize size = mSize;
//------------------------------------------------------------------------------------------------------
+ (id) Link_Int:(int *)parPoint withKey:(id)sKey,...
{
    UniCell* cell = [UniCell new];
    if (cell != nil)
    {
        cell->mpType = [NSString stringWithString:@"i"];
        cell->mpIdPoint = (id)parPoint;
        cell->mbLocal = NO;
        cell->mSize = 4;
        
        APPEND_STR
        
        cell->mpName = [NSString stringWithString:RezObject];
    }

    return cell;
//    return [cell autorelease];
}
//------------------------------------------------------------------------------------------------------
+ (id) Set_Int:(int)Value withKey:(id)sKey,...
{
    UniCell* cell = [UniCell new];
    if (cell != nil)
    {
        cell->mpType=[NSString stringWithString:@"i"];
        
        cell->mSize=sizeof(int);
        int *TmpInt=malloc(cell->mSize);
        *TmpInt=Value;
        
        cell->mpIdPoint=(id)TmpInt;
        
        cell->mbLocal=YES;
        
        APPEND_STR
        
        cell->mpName=[NSString stringWithString:RezObject];
    }
    
    return cell;
//    return [cell autorelease];
}
//------------------------------------------------------------------------------------------------------
+ (id) Link_Float:(float *)parPoint withKey:(id)sKey,...
{
    UniCell* cell = [UniCell new];
    if (cell != nil)
    {
        cell->mpType=[NSString stringWithString:@"f"];
        cell->mpIdPoint=(id)parPoint;
        cell->mbLocal=NO;
        cell->mSize=4;

        APPEND_STR

        cell->mpName=[NSString stringWithString:RezObject];
    }
    
    return cell;
//    return [cell autorelease];
}
//------------------------------------------------------------------------------------------------------
+ (id) Set_Float:(float)Value withKey:(id)sKey,...
{
    UniCell* cell = [UniCell new];
    if (cell != nil)
    {
        cell->mpType=[NSString stringWithString:@"f"];
        
        cell->mSize=sizeof(float);
        float *TmpV=malloc(cell->mSize);
        *TmpV=Value;
        
        cell->mpIdPoint=(id)TmpV;
        
        cell->mbLocal=YES;
        
        APPEND_STR
        
        cell->mpName=[NSString stringWithString:RezObject];
    }
    
    return cell;
//    return [cell autorelease];
}
//------------------------------------------------------------------------------------------------------
+ (id) Link_Bool:(bool *)parPoint withKey:(id)sKey,...
{
    UniCell* cell = [UniCell new];
    if (cell != nil)
    {
        cell->mpType=[NSString stringWithString:@"b"];
        cell->mpIdPoint=(id)parPoint;
        cell->mbLocal=NO;
        cell->mSize=sizeof(bool);
        
        APPEND_STR
        
        cell->mpName=[NSString stringWithString:RezObject];
    }
    
    return cell;
//    return [cell autorelease];
}
//------------------------------------------------------------------------------------------------------
+ (id) Set_Bool:(bool)Value withKey:(id)sKey,...
{
    UniCell* cell = [UniCell new];
    if (cell != nil)
    {
        cell->mpType=[NSString stringWithString:@"b"];
        
        cell->mSize=sizeof(bool);
        bool *TmpV=malloc(cell->mSize);
        *TmpV=Value;
        
        cell->mpIdPoint=(id)TmpV;
        
        cell->mbLocal=YES;
        
        APPEND_STR
        
        cell->mpName=[NSString stringWithString:RezObject];
    }
    
    return cell;
//    return [cell autorelease];
}
//------------------------------------------------------------------------------------------------------
+ (id) Link_Vector:(Vector3D *)parPoint withKey:(id)sKey, ...
{
    UniCell* cell = [UniCell new];
    if (cell != nil)
    {
        cell->mpType=[NSString stringWithString:@"v"];
        cell->mpIdPoint=(id)parPoint;
        cell->mbLocal=NO;
        cell->mSize=sizeof(Vector3D);
        
        APPEND_STR
        
        cell->mpName=[NSString stringWithString:RezObject];
    }
    
    return cell;
//    return [cell autorelease];
}
//------------------------------------------------------------------------------------------------------
+ (id) Set_Vector:(Vector3D)Value withKey:(id)sKey, ...
{
    UniCell* cell = [UniCell new];
    if (cell != nil)
    {
        cell->mpType=[NSString stringWithString:@"v"];
        
        cell->mSize=sizeof(Vector3D);
        Vector3D *TmpV=malloc(cell->mSize);
        *TmpV=Value;
        
        cell->mpIdPoint=(id)TmpV;
        
        cell->mbLocal=YES;
        
        APPEND_STR
        
        cell->mpName=[NSString stringWithString:RezObject];
    }
    
    return cell;
//    return [cell autorelease];
}
//------------------------------------------------------------------------------------------------------
+ (id) Link_Color:(Color3D *)parPoint withKey:(id)sKey, ...
{
    UniCell* cell = [UniCell new];
    if (cell != nil)
    {
        cell->mpType=[NSString stringWithString:@"c"];
        cell->mpIdPoint=(id)parPoint;
        cell->mbLocal=NO;
        cell->mSize=sizeof(Color3D);
        
        APPEND_STR
        
        cell->mpName=[NSString stringWithString:RezObject];
    }
    
    return cell;
//    return [cell autorelease];
}
//------------------------------------------------------------------------------------------------------
+ (id) Set_Color:(Color3D)Value withKey:(id)sKey, ...
{
    UniCell* cell = [UniCell new];
    if (cell != nil)
    {
        cell->mpType=[NSString stringWithString:@"c"];
        
        cell->mSize=sizeof(Color3D);
        Color3D *TmpV=malloc(cell->mSize);
        *TmpV=Value;
        
        cell->mpIdPoint=(id)TmpV;
        
        cell->mbLocal=YES;
        
        APPEND_STR
        
        cell->mpName=[NSString stringWithString:RezObject];
    }
    
    return cell;
//    return [cell autorelease];
}
//------------------------------------------------------------------------------------------------------
+ (id) Link_Id:(id *)parPoint withKey:(id)sKey, ...
{
    UniCell* cell = [UniCell new];
    if (cell != nil)
    {
        cell->mpType=[NSString stringWithString:@"id"];
        cell->mpIdPoint=[*parPoint retain];
        cell->mppIdPoint=parPoint;
        cell->mbLocal=NO;
        cell->mSize=sizeof(id);
        
        APPEND_STR
        
        cell->mpName=[NSString stringWithString:RezObject];
    }
    
    return cell;
//    return [cell autorelease];
}
//------------------------------------------------------------------------------------------------------
+ (id) Link_String:(NSMutableString *)parPoint withKey:(id)sKey, ...
{
    UniCell* cell = [UniCell new];
    if (cell != nil)
    {
        cell->mpType=[NSString stringWithString:@"s"];
        cell->mpIdPoint=[parPoint retain];
        cell->mbLocal=NO;
        cell->mSize=sizeof(NSMutableString *);
        
        APPEND_STR
        
        cell->mpName=[NSString stringWithString:RezObject];
    }
    
    return cell;
//    return [cell autorelease];
}
//------------------------------------------------------------------------------------------------------
+ (id) Set_String:(NSString *)Value withKey:(id)sKey, ...
{
    UniCell* cell = [UniCell new];
    if (cell != nil)
    {
        cell->mpType=[NSString stringWithString:@"s"];    
        cell->mpIdPoint=[[NSMutableString alloc] initWithString:Value];
        
        cell->mbLocal=YES;
        
        APPEND_STR
        
        cell->mpName=[NSString stringWithString:RezObject];
    }
    
    return cell;
//    return [cell autorelease];
}
//------------------------------------------------------------------------------------------------------
+ (id) Link_Point:(void *)parPoint withKey:(id)sKey, ...
{
    UniCell* cell = [UniCell new];
    if (cell != nil)
    {
        cell->mpType=[NSString stringWithString:@"p"];
        cell->mpIdPoint=(id)parPoint;
        cell->mbLocal=NO;
        cell->mSize=sizeof(id);
        
        APPEND_STR
        
        cell->mpName=[NSString stringWithString:RezObject];
    }
    
    return cell;
//    return [cell autorelease];
}
//------------------------------------------------------------------------------------------------------
-(void) CrearCell
{
    if ([mpType isEqualToString:@"id"] || [mpType isEqualToString:@"s"])
    {
        [mpIdPoint release];
    }
    else
    {
        if(mbLocal==YES)
            free(mpIdPoint);
    }
    
    mpIdPoint=nil;
}
//------------------------------------------------------------------------------------------------------
-(void) dealloc
{
    [self CrearCell];
    [super dealloc];
}
//------------------------------------------------------------------------------------------------------
@end
