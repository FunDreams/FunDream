//
//  Dictionary_Ex.m
//  sudoku
//
//  Created by Konstantin on 24.04.11.
//  Copyright 2011 FunDreams. All rights reserved.
//
#import "Object.h"

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
////------------------------------------------------------------------------------------------------------
//-(NSEnumerator *)objectEnumerator
//{
//    return [pDic objectEnumerator];

//    NSEnumerator *pEn= [self->pDic objectEnumerator];
//    
//    GObject *trhvdt = [pEn nextObject];
//    int m=0;
//    
//    return [pEn retait];
//}
////------------------------------------------------------------------------------------------------------
//-(NSEnumerator *)keyEnumerator
//{
//    return [pDic keyEnumerator];
//}
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
- (int)SynhData
{    
    if(m_bNotSyn==YES){
    NSEnumerator *Key_enumerator = [pDicTemp keyEnumerator];
    NSString *aKey;
    
        while ((aKey = [Key_enumerator nextObject])) {
            
            id pObject = [pDicTemp objectForKey:aKey];
            if ([pObject isKindOfClass:[NSString class]] && [(NSString*)pObject isEqualToString:@"delete"])
            {
                [pDic removeObjectForKey:aKey];
            }
            else
            {
                [pDic setObject:pObject forKey:aKey];
            }
        }
        
        [pDicTemp removeAllObjects];
        m_bNotSyn=NO;
        return [pDic count];
    }
    return 0;
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
