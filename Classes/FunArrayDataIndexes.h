//
//  FunArrayDataIndexes.h
//  FunDreams
//
//  Created by Konstantin Maximov on 24.04.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StringContainer.h"

#define F_ORDER 0x01//упорядоченность массива

@interface FunArrayDataIndexes : NSObject {
@public
    StringContainer *m_pParent;
}

-(id)init;
- (int **)InitMemory;
- (void)ReleaseMemory:(int **)pData;
- (void)InitStructure:(int **)pData;

-(void)SetCopasity:(int)icopasity WithData:(int **)pData;
-(void)Extend:(int **)pData;
-(void)AddData:(int)IndexValue WithData:(int **)pData;
-(void)RemoveDataAtIndex:(int)iIndex WithData:(int **)pData;
-(void)Insert:(int)iDataValue index:(int)iIndex WithData:(int **)pData;

-(int)GetDataAtIndex:(int)iIndex WithData:(int **)pData;
-(void)selfSave:(NSMutableData *)m_pData WithData:(int **)pData;
-(void)selfLoad:(NSMutableData *)m_pData rpos:(int *)iCurReadingPos WithData:(int **)pData;
- (void)CopyDataFrom:(int **)pSourceData To:(int **)pDestData;
- (int)FindIndex:(int)IndexValue WithData:(int **)pData;

@end

