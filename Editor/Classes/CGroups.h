//
//  CGroups.h
//  SeaFight
//
//  Created by Konstantin Maximov on 06.03.12.
//  Copyright (c) 2012 __FunDreamsInc__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GObject;

@interface GroupContainer : NSObject {
@public
    
    GObject *pOb;
    NSString *pNameGroup;
}

- (id)InitWithName:(NSString *)pName WithObject:(GObject *)pObject;

@end


@interface CGroups : NSObject{
    
	NSMutableDictionary* m_pGroups;
	NSMutableDictionary* m_pAdd;
	NSMutableDictionary* m_pRem;
    bool m_bSyn;
}

-(id)init;
-(void)AddToGroup:(NSString*)NameGroup Object:(GObject *)pObject;
-(void)RemoveFromGroup:(NSString*)NameGroup Object:(GObject *)pObject;
-(void)RemoveFromGroups:(GObject *)pObject;
-(NSMutableArray *)GetGroup:(NSString*)NameGroup;
-(void)SynhData;

@end

