//
//  Dictionary_Ex.m
//  sudoku
//
//  Created by Konstantin on 24.04.11.
//  Copyright 2011 FunDreams. All rights reserved.
//

@implementation Dictionary_Ex
//=====================================================================================================
-(id)init
{
    pDic = [[NSMutableDictionary alloc] init];
    pDicTemp = [[NSMutableDictionary alloc] init];
	return self;
}
//=====================================================================================================
-(NSEnumerator *)objectEnumerator
{
    NSEnumerator *pEn= [pDic objectEnumerator];
    return pEn;
}
//=====================================================================================================
- (id)removeObjectForKey_Ex:(id)aKey
{
    id pOb = [pDic objectForKey:aKey];

    [pDicTemp setObject:@"delete" forKey:aKey];
    
    return pOb;
}
//=====================================================================================================
-(id)setObject_Ex:(id)anObject forKey:(id)aKey
{
    id pOb = [pDic objectForKey:aKey];
    [pDicTemp setObject:anObject forKey:aKey];
    
    return pOb;
}
//=====================================================================================================
- (id)objectForKey:(id)aKey
{
    id pOb = [pDicTemp objectForKey:aKey];
    if(pOb==@"delete"){return nil;}
    
    if(pOb==nil){pOb = [pDic objectForKey:aKey];}

    return pOb;
}
//=====================================================================================================
- (void)SynhData
{
    if([pDicTemp count]==0)return;
    
    NSEnumerator *Key_enumerator = [pDicTemp keyEnumerator];
    id aKey;
    
    while ((aKey = [Key_enumerator nextObject])) {
        
        id pObject = [pDicTemp objectForKey:aKey];
        if(pObject==@"delete"){
            [pDic removeObjectForKey:aKey];
        }
        else{
            [pDic setObject:pObject forKey:aKey];
        }
    }
    
    [pDicTemp removeAllObjects];
}
//=====================================================================================================
-(void)dealloc
{
    [pDicTemp release];
    [pDic release];
    [super dealloc];
};
//=====================================================================================================
@end
