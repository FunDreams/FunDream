//
//  Dictionary_Ex.m
//  sudoku
//
//  Created by Konstantin on 24.04.11.
//  Copyright 2011 FunDreams. All rights reserved.
//

@implementation Dictionary_Ex
//------------------------------------------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        pDic = [[NSMutableDictionary alloc] init];
        pDicTemp = [[NSMutableDictionary alloc] init];
    }

    return self;
}
//------------------------------------------------------------------------------------------------------
-(NSEnumerator *)objectEnumerator
{
    NSEnumerator *pEn= [pDic objectEnumerator];
    return pEn;
}
//------------------------------------------------------------------------------------------------------
- (id)removeObjectForKey_Ex:(id)aKey
{
    id pOb = [pDic objectForKey:aKey];
    [pDicTemp setObject:@"delete" forKey:aKey];
    m_bNotSyn=YES;
    
    return pOb;
}
//------------------------------------------------------------------------------------------------------
-(id)setObject_Ex:(id)anObject forKey:(id)aKey
{
    id pOb = [pDic objectForKey:aKey];
    [pDicTemp setObject:anObject forKey:aKey];
    m_bNotSyn=YES;
    
    return pOb;
}
//------------------------------------------------------------------------------------------------------
- (id)objectForKey:(id)aKey
{
    id pOb = [pDicTemp objectForKey:aKey];
    if ([pOb isKindOfClass:[NSString class]])
    {
        if ([(NSString*)pOb isEqualToString:@"delete"])
            return nil;
    }
    
    if(pOb==nil){pOb = [pDic objectForKey:aKey];}

    return pOb;
}
//------------------------------------------------------------------------------------------------------
- (void)SynhData
{    
    NSEnumerator *Key_enumerator = [pDicTemp keyEnumerator];
    id aKey;
    
    while ((aKey = [Key_enumerator nextObject])) {
        
        id pObject = [pDicTemp objectForKey:aKey];
        if ([pObject isKindOfClass:[NSString class]] && [(NSString*)pObject isEqualToString:@"delete"])
        {
            [pDic removeObjectForKey:aKey];
        }
        else
        {
            [pDic removeObjectForKey:aKey];
            [pDic setObject:pObject forKey:aKey];
        }
    }
    
    [pDicTemp removeAllObjects];
    m_bNotSyn=NO;
}
//------------------------------------------------------------------------------------------------------
-(void)dealloc
{
    [pDicTemp release];
    [pDic release];
    [super dealloc];
};
//------------------------------------------------------------------------------------------------------
@end
