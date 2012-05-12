//
//  CGroups.m
//  SeaFight
//
//  Created by Konstantin Maximov on 06.03.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import "CGroups.h"
#import "Object.h"

@implementation GroupContainer
//--------------------------------------------------------------------------------------------------
- (id)InitWithName:(NSString *)pName WithObject:(GObject *)pObject;
{
    self = [super init];
    if (self)
    {
        pOb=[pObject retain];
        pNameGroup=[[NSString alloc] initWithString:pName];
    }
    return self;
}

- (void)dealloc
{
    [pOb release];
    [pNameGroup release];
    [super dealloc];
}
@end
//--------------------------------------------------------------------------------------------------
@implementation CGroups
-(id) init {
	if (!(self = [super init])) return nil;

    m_pGroups = [[NSMutableDictionary alloc] init];
    m_pAdd = [[NSMutableDictionary alloc] init];
    m_pRem = [[NSMutableDictionary alloc] init];
    m_bSyn=YES;
    return self;
}
//--------------------------------------------------------------------------------------------------
- (void)AddToGroup:(NSString*)NameGroup Object:(GObject *)pObject
{
    if (pObject==nil || NameGroup==nil)
        return;

    GroupContainer *TmpContainerGroup=
    [[GroupContainer alloc] InitWithName:NameGroup WithObject:pObject];

    [m_pAdd setObject:TmpContainerGroup forKey:pObject->m_strName];
//    [TmpContainerGroup release];

    TmpContainerGroup = [m_pRem objectForKey:pObject->m_strName];
    if(TmpContainerGroup!=nil)
        [m_pRem removeObjectForKey:pObject->m_strName];
    
    m_bSyn=NO;
}
//--------------------------------------------------------------------------------------------------
- (void)RemoveFromGroup:(NSString*)NameGroup Object:(GObject *)pObject{
	
    if (pObject==nil || NameGroup==nil)
        return;

    GroupContainer *TmpContainerGroup=
    [[GroupContainer alloc] InitWithName:NameGroup WithObject:pObject];

    [m_pRem setObject:TmpContainerGroup forKey:pObject->m_strName];
//    [TmpContainerGroup release];

    TmpContainerGroup = [m_pAdd objectForKey:pObject->m_strName];
    if(TmpContainerGroup!=nil)
        [m_pAdd removeObjectForKey:pObject->m_strName];

    m_bSyn=NO;
}
//---------------------------------------------------------------------------------------------------
- (void)RemoveFromGroups:(GObject *)pObject{
    
    NSMutableDictionary *NamesGroup=[pObject->m_Groups retain];
    if(pObject==nil)return;
    
	for (NSString *Pname in NamesGroup) {
        
        NSMutableArray *pGroup = [m_pGroups objectForKey:Pname];
        
        if(pGroup)[self RemoveFromGroup:Pname Object:pObject];
    }
}
//--------------------------------------------------------------------------------------------------
- (NSMutableArray *)GetGroup:(NSString*)NameGroup{
	
	if(NameGroup==nil)return nil;
	return [m_pGroups objectForKey:NameGroup];
}
//--------------------------------------------------------------------------------------------------
- (void)SynhData{
    
    if(m_bSyn==NO){
        
        m_bSyn=YES;
        
        NSEnumerator *Key_enumerator = [m_pAdd objectEnumerator];
        GroupContainer *pContainer;
        
        while ((pContainer = [Key_enumerator nextObject])) {
            
            NSMutableArray *pGroup = [m_pGroups objectForKey:pContainer->pNameGroup];
            if (pGroup==nil)
            {
                pGroup = [[NSMutableArray alloc] init];
                [m_pGroups setObject:pGroup forKey:pContainer->pNameGroup];
        //        [pGroup release];
            }
            
            NSString *pNameGroup = [NSString stringWithString:pContainer->pNameGroup];
            [pContainer->pOb->m_Groups setObject:pNameGroup forKey:pNameGroup];
            [pGroup addObject:pContainer->pOb];
        }
        
        [m_pAdd removeAllObjects];
////////////////////////////////////////////////////////////////////////
        Key_enumerator = [m_pRem objectEnumerator];
        
        while ((pContainer = [Key_enumerator nextObject])) {
            
            NSMutableArray *pGroup = [m_pGroups objectForKey:pContainer->pNameGroup];
            
            if(pGroup){
                
                for (int i=0; i<[pGroup count]; i++)
                    if (pContainer->pOb==[pGroup objectAtIndex:i]){
                        
                        [pGroup removeObjectAtIndex:i];
                        [pContainer->pOb->m_Groups removeObjectForKey:pContainer->pNameGroup];
                        
                        goto NEXT;
                    }
            }
NEXT:;
        }

        [m_pRem removeAllObjects];
    }
}
//-------------------------------------------------------------------------------------------------
- (void) dealloc {
    
    [m_pAdd release];
    [m_pRem release];
    [m_pGroups release];
    
    [super dealloc];
}
//-------------------------------------------------------------------------------------------------
@end
