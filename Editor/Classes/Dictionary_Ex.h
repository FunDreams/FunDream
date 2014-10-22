//
//  Dictionary_Ex.h
//  sudoku
//
//  Created by Konstantin on 24.04.11.
//  Copyright 2011 __FunDreamsInc__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Dictionary_Ex : NSObject {
@public
    NSMutableDictionary *pDic;
    NSMutableDictionary *pDicTemp;
    
    bool m_bNotSyn;
}

-(id)init;
//-(NSEnumerator *)objectEnumerator;
//-(NSEnumerator *)keyEnumerator;

- (id)removeObjectForKey_Ex:(id)aKey;
- (id)objectForKey:(id)aKey;
- (id)setObject_Ex:(id)anObject forKey:(id)aKey;
- (int)SynhData;
- (void)dealloc;

@end
