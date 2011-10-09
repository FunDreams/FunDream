//
//  Mega_tree.m
//  sudoku
//
//  Created by Konstantin on 22.07.11.
//  Copyright 2011 FunDreams. All rights reserved.
//

#import "Mega_tree.h"

#define APPEND_STR     NSString *currentObject=nil;\
NSString *RezObject=[NSString stringWithString:sKey];\
va_list argList;\
if (sKey)\
{        \
va_start(argList, sKey);\
while ((currentObject = va_arg(argList,id))!=nil){\
RezObject=[RezObject stringByAppendingString:currentObject];\
}\
va_end(argList);\
}

@implementation UniCell
//-----------------------------------------------------------------------------------
- (id)Link_Int:(int *)parPoint withKey:(id)sKey,...{
    
    mpType=[NSString stringWithString:@"i"];
	mpIdPoint=(id)parPoint;
    mbLocal=NO;
    mSize=4;
    
    APPEND_STR
    
    mpName=[NSString stringWithString:RezObject];
    
    return self;
}

- (id)Set_Int:(int)Value withKey:(id)sKey,...{
    
    mpType=[NSString stringWithString:@"i"];
    
    mSize=sizeof(int);
    int *TmpInt=malloc(mSize);
    *TmpInt=Value;

	mpIdPoint=(id)TmpInt;
    
    mbLocal=YES;
    
    APPEND_STR
    
    mpName=[NSString stringWithString:RezObject];
    
    return self;
}
//-----------------------------------------------------------------------------------
- (id)Link_Float:(float *)parPoint withKey:(id)sKey,...{
    
    mpType=[NSString stringWithString:@"f"];
	mpIdPoint=(id)parPoint;
    mbLocal=NO;
    mSize=4;
    
    APPEND_STR
    
    mpName=[NSString stringWithString:RezObject];
    
    return self;
}

- (id)Set_Float:(float)Value withKey:(id)sKey,...{
    
    mpType=[NSString stringWithString:@"f"];
    
    mSize=sizeof(float);
    float *TmpV=malloc(mSize);
    *TmpV=Value;
    
	mpIdPoint=(id)TmpV;
    
    mbLocal=YES;
    
    APPEND_STR
    
    mpName=[NSString stringWithString:RezObject];
    
    return self;
}
//-----------------------------------------------------------------------------------
- (id)Link_Bool:(bool *)parPoint withKey:(id)sKey,...{
    
    mpType=[NSString stringWithString:@"b"];
	mpIdPoint=(id)parPoint;
    mbLocal=NO;
    mSize=sizeof(bool);
    
    APPEND_STR
    
    mpName=[NSString stringWithString:RezObject];
    
    return self;
}

- (id)Set_Bool:(bool)Value withKey:(id)sKey,...{
    
    mpType=[NSString stringWithString:@"b"];
    
    mSize=sizeof(bool);
    bool *TmpV=malloc(mSize);
    *TmpV=Value;
    
	mpIdPoint=(id)TmpV;
    
    mbLocal=YES;
    
    APPEND_STR
    
    mpName=[NSString stringWithString:RezObject];
    
    return self;
}
//-----------------------------------------------------------------------------------
- (id)Link_Vector:(Vector3D *)parPoint withKey:(id)sKey, ...{
    
    mpType=[NSString stringWithString:@"v"];
	mpIdPoint=(id)parPoint;
    mbLocal=NO;
    mSize=sizeof(Vector3D);
    
    APPEND_STR
    
    mpName=[NSString stringWithString:RezObject];
    
    return self;
}

- (id)Set_Vector:(Vector3D)Value withKey:(id)sKey, ...{
    
    mpType=[NSString stringWithString:@"v"];
    
    mSize=sizeof(Vector3D);
    Vector3D *TmpV=malloc(mSize);
    *TmpV=Value;
    
	mpIdPoint=(id)TmpV;
    
    mbLocal=YES;
    
    APPEND_STR
    
    mpName=[NSString stringWithString:RezObject];
    
    return self;
}
//-----------------------------------------------------------------------------------
- (id)Link_Color:(Color3D *)parPoint withKey:(id)sKey, ...{
    
    mpType=[NSString stringWithString:@"c"];
	mpIdPoint=(id)parPoint;
    mbLocal=NO;
    mSize=sizeof(Color3D);
    
    APPEND_STR
    
    mpName=[NSString stringWithString:RezObject];
    
    return self;
}

- (id)Set_Color:(Color3D)Value withKey:(id)sKey, ...{
    
    mpType=[NSString stringWithString:@"c"];
    
    mSize=sizeof(Color3D);
    Color3D *TmpV=malloc(mSize);
    *TmpV=Value;
    
	mpIdPoint=(id)TmpV;
    
    mbLocal=YES;
    
    APPEND_STR
    
    mpName=[NSString stringWithString:RezObject];
    
    return self;
}
//-----------------------------------------------------------------------------------
- (id)Link_Id:(id *)parPoint withKey:(id)sKey, ...{
    
    mpType=[NSString stringWithString:@"id"];
	mpIdPoint=[*parPoint retain];
    mppIdPoint=parPoint;
    mbLocal=NO;
    mSize=sizeof(id);
    
    APPEND_STR
    
    mpName=[NSString stringWithString:RezObject];
    
    return self;
}
//-----------------------------------------------------------------------------------
- (id)Link_String:(NSMutableString *)parPoint withKey:(id)sKey, ...{
    
    mpType=[NSString stringWithString:@"s"];
	mpIdPoint=[parPoint retain];
    mbLocal=NO;
    mSize=sizeof(NSMutableString *);
    
    APPEND_STR
    
    mpName=[NSString stringWithString:RezObject];
    
    return self;
}

- (id)Set_String:(NSString *)Value withKey:(id)sKey, ...{
    
    mpType=[NSString stringWithString:@"s"];
	mpIdPoint=[[NSMutableString alloc] initWithString:Value];
    
    mbLocal=YES;
    
    APPEND_STR
    
    mpName=[NSString stringWithString:RezObject];
    
    return self;
}

- (id)Link_Point:(void *)parPoint withKey:(id)sKey, ...{
    
    mpType=[NSString stringWithString:@"p"];
	mpIdPoint=(id)parPoint;
    mbLocal=NO;
    mSize=sizeof(id);
    
    APPEND_STR
    
    mpName=[NSString stringWithString:RezObject];
    
    return self;
}
//---------------------------------------------------------------------------------
- (id)InitWithName:(NSString *)strName WithType:(NSString *)strType
             Local:(bool)bLocal WithPoint:(id)parPoint{

    mpName=[NSString stringWithString:strName];
    mpType=[NSString stringWithString:strType];
	mpIdPoint=parPoint;
    mbLocal=bLocal;

    return self;
}

- (id)InitWithNameForId:(NSString *)strName WithType:(NSString *)strType
             Local:(bool)bLocal WithPoint:(id *)parPPoint{
    
    mpName=[NSString stringWithString:strName];
    mpType=[NSString stringWithString:strType];
    mpIdPoint=[*parPPoint retain];
    mbLocal=bLocal;
    
    return self;
}

-(void)CrearCell{
    
    if(mpType==@"id" || mpType==@"s"){
        [mpIdPoint release];
    }
    else{
        
        if(mbLocal==YES)free(mpIdPoint);
    }
    
    mpIdPoint=nil;
}
-(void)dealloc{
    
    [self CrearCell];
    [super dealloc];
}
@end

@implementation Mega_tree
//=====================================================================================================
-(id)init
{
    pDic = [[NSMutableDictionary alloc] init];
    pDicTemp = [[NSMutableDictionary alloc] init];
    return self;
}
//=====================================================================================================
//-(id)setObject_Ex:(id)anObject forKey:(id)aKey
//{
//    return nil;
//}

-(void)SetCell:(UniCell *)pCell{
    
    UniCell *pCellTmp = [self objectForKey:pCell->mpName];
    
    if(pCellTmp!=nil){
        
        if(pCellTmp->mbLocal==YES){
                if(pCell->mpType==pCellTmp->mpType){
                    
                    if(pCellTmp->mpType==@"s"){
                        NSMutableString * Str=pCellTmp->mpIdPoint;
                        [Str setString:pCell->mpIdPoint];
                        [pCell release];
                        return;
                    }
                    else if(pCellTmp->mpType!=@"id"){
                        memcpy(pCellTmp->mpIdPoint,pCell->mpIdPoint,pCellTmp->mSize);
                        [pCell release];
                        return;
                }
            }
        }
        
        [pCellTmp release];
        [self setObject_Ex:(id)pCell forKey:pCell->mpName];
    }
    else [self setObject_Ex:(id)pCell forKey:pCell->mpName];
}

-(void)CopyCell:(UniCell *)pCell{
    
    UniCell *pCellTmp = [self objectForKey:pCell->mpName];
    
    if(pCellTmp!=nil){
        
        if(pCell->mpType==pCellTmp->mpType){
            
            if(pCellTmp->mpType==@"s"){
                NSMutableString * Str=pCellTmp->mpIdPoint;
                [Str setString:pCell->mpIdPoint];
            }
            else if(pCellTmp->mpType==@"id"){
                pCellTmp->mpIdPoint=[pCell->mpIdPoint retain];
                *(pCellTmp->mppIdPoint)=pCellTmp->mpIdPoint;
            }
            else {
                memcpy(pCellTmp->mpIdPoint, pCell->mpIdPoint, pCellTmp->mSize);
            }
        }
    }
    
    [pCell release];
}
//////int
//////
-(int *)GetIntValue:(id)sKey,...{
    
    APPEND_STR
    
    UniCell *pOb=[self objectForKey:RezObject];
    
    if(pOb!=nil && pOb->mpType==@"i"){
        return (int *)pOb->mpIdPoint;
    }
    else return nil;
}
//////float
//////
-(float *)GetFloatValue:(id)sKey,...{
    
    APPEND_STR

    UniCell *pOb=[self objectForKey:RezObject];
    
    if(pOb!=nil && pOb->mpType==@"f"){
        return (float *)pOb->mpIdPoint;
    }
    else return nil;
}
//////bool
//////
-(bool *)GetBoolValue:(id)sKey,...{

    APPEND_STR

    UniCell *pOb=[self objectForKey:RezObject];
    
    if(pOb!=nil && pOb->mpType==@"b"){
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
    
    if(pOb!=nil && pOb->mpType==@"v"){
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
    
    if(pOb!=nil && pOb->mpType==@"c"){
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
    
    if(pOb!=nil && (pOb->mpType==@"id" || pOb->mpType==@"s")){
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
    
    if(pOb!=nil && pOb->mpType==@"p"){
        return (void *)pOb->mpIdPoint;
    }
    else return nil;
}
//=====================================================================================================
-(void)RemoveValue:(NSString*)sKey
{
    UniCell *pOb = [self objectForKey:sKey];
    [self removeObjectForKey_Ex:sKey];
    [pOb release];
}
//=====================================================================================================
-(void)dealloc
{
    [self SynhData];
    
    NSEnumerator *enumeratorInst = [pDic objectEnumerator];
    UniCell *pInst;

    while ((pInst = [enumeratorInst nextObject])) {
        [pInst release];
    }

    [super dealloc];
};
//=====================================================================================================
@end
