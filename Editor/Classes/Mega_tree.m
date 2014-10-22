//
//  Mega_tree.m
//  sudoku
//
//  Created by Konstantin on 22.07.11.
//  Copyright 2011 FunDreams. All rights reserved.
//

#import "Mega_tree.h"
#import "UniCell.h"

@implementation Mega_tree
//=====================================================================================================
- (id)init {
    self = [super init];
    if (self)
    {
        //
    }
    return self;
}

//=====================================================================================================
//-(id)setObject_Ex:(id)anObject forKey:(id)aKey
//{
//    return nil;
//}

-(void)SetCell:(UniCell *)pCell
{    
    UniCell *existingCell = [self objectForKey:pCell->mpName];
    if (existingCell != nil)
    {
        if (existingCell->mbLocal)
        {
            if ([pCell->mpType isEqualToString:existingCell->mpType] )
            {
                if ([existingCell->mpType isEqualToString:@"s"])
                {
                    NSMutableString * Str=existingCell->mpIdPoint;
                    [Str setString:pCell->mpIdPoint];
                    [pCell release];
                    return;
                }
                else if (![existingCell->mpType isEqualToString:@"id"])
                {
                    memcpy(existingCell->mpIdPoint,pCell->mpIdPoint,existingCell->mSize);
                    [pCell release];
                    return;
                }
            }
        }
        
        [self setObject_Ex:(id)pCell forKey:pCell->mpName];        
        [existingCell release];
    }
    else
    {
        [self setObject_Ex:(id)pCell forKey:pCell->mpName];   
    }
    
    //[pCell release];
}

-(void)CopyCell:(UniCell *)pCell{
    
    UniCell *existingCell = [self objectForKey:pCell->mpName];
    if (existingCell != nil)
    {
        if (pCell->mpType == existingCell->mpType)
        {
            if ([existingCell->mpType isEqualToString:@"s"]){
                NSMutableString *str = existingCell->mpIdPoint;
                [str setString:pCell->mpIdPoint];
            }
            else if ([existingCell->mpType isEqualToString:@"id"]){
                existingCell->mpIdPoint = [pCell->mpIdPoint retain];
                *(existingCell->mppIdPoint) = existingCell->mpIdPoint;
            }
            else {
                memcpy(existingCell->mpIdPoint, pCell->mpIdPoint, existingCell->mSize);
            }
        }
    }
    [pCell release];
}

- (void)RemoveCell:(id)sKey, ...{

    APPEND_STR
    
    UniCell *existingCell = [self objectForKey:RezObject];
    if (existingCell != nil)
    {
        [self removeObjectForKey_Ex:RezObject];
        [existingCell release];
    }
}
//////int
//////
-(int *)GetIntValue:(id)sKey,...{
    
    APPEND_STR
    
    UniCell *pOb=[self objectForKey:RezObject];
    
    if (pOb!=nil && [pOb->mpType isEqualToString:@"i"])
    {
        return (int *)pOb->mpIdPoint;
    }
    else return nil;
}
//////float
//////
-(float *)GetFloatValue:(id)sKey,...{
    
    APPEND_STR

    UniCell *pOb=[self objectForKey:RezObject];
    
    if(pOb!=nil && [pOb->mpType isEqualToString:@"f"])
    {
        return (float *)pOb->mpIdPoint;
    }
    else return nil;
}
//////bool
//////
-(bool *)GetBoolValue:(id)sKey,...{

    APPEND_STR

    UniCell *pOb=[self objectForKey:RezObject];
    
    if(pOb!=nil && [pOb->mpType isEqualToString:@"b"])
    {
        return (bool *)pOb->mpIdPoint;
    }
    else return nil;
}

//////vector
//////
-(Vector3D *)GetVectorValue:(id)sKey, ...
{
    APPEND_STR

    UniCell *pOb=[self objectForKey:RezObject];
    
    if(pOb!=nil && [pOb->mpType isEqualToString:@"v"])
    {
        return (Vector3D *)pOb->mpIdPoint;
    }
    else return nil;
}
//////Color
//////
-(Color3D *)GetColorValue:(id)sKey, ...
{
    APPEND_STR

    UniCell *pOb=[self objectForKey:RezObject];
    
    if(pOb!=nil && [pOb->mpType isEqualToString:@"c"])
    {
        return (Color3D *)pOb->mpIdPoint;
    }
    else return nil;
}
//////Id
//////
-(id)GetIdValue:(id)sKey, ...
{
    APPEND_STR
    UniCell *pOb=[self objectForKey:RezObject];
    
    if(pOb!=nil && ([pOb->mpType isEqualToString:@"id"] || [pOb->mpType isEqualToString:@"s"])){
        return pOb->mpIdPoint;
    }
    else return nil;
}
//////Point
//////
-(void *)GetPointValue:(id)sKey, ...
{
    APPEND_STR
    UniCell *pOb=[self objectForKey:RezObject];
    
    if(pOb!=nil && [pOb->mpType isEqualToString:@"p"]){
        return (void *)pOb->mpIdPoint;
    }
    else return nil;
}
//=====================================================================================================
//-(void)RemoveValue:(id)sKey, ...
//{
//    APPEND_STR
//
//    [self removeObjectForKey_Ex:sKey];
//}
//=====================================================================================================
-(void)dealloc
{
    [self SynhData];

    [super dealloc];
};
//=====================================================================================================
@end
