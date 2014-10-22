//
//  FunArrayDataIndexes.h
//  FunDreams
//
//  Created by Konstantin Maximov on 24.04.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "StringContainer.h"

@interface FunArrayDataIndexes : NSObject {
@public
    StringContainer *m_pParent;
}

-(id)init;
- (int **)InitMemory;
- (void)ReleaseMemory:(int **)pData;
- (void)OnlyReleaseMemory:(int **)pData;
- (void)InitStructure:(int **)pData;

-(void)SetCopasity:(int)icopasity WithData:(int **)pData;
-(void)Extend:(int **)pData;
-(void)AddData:(int)IndexValue WithData:(int **)pData;
- (void)RemoveDataAtPlace:(int)iPlace WithData:(int **)pData;
//-(void)Insert:(int)iDataValue index:(int)iIndex WithData:(int **)pData;

-(int)GetDataAtIndex:(int)iIndex WithData:(int **)pData;
-(void)selfSave:(NSMutableData *)m_pData WithData:(int **)pData;
-(void)selfLoad:(NSMutableData *)m_pData rpos:(int *)iCurReadingPos WithData:(int **)pData;
- (void)CopyDataFrom:(int **)pSourceData To:(int **)pDestData;
- (int)FindIndex:(int)IndexValue WithData:(int **)pData;
- (void)OnlyRemoveDataAtIndex:(int)iIndex WithData:(int **)pData;

- (bool)CheckHierarhy:(NSMutableDictionary *)DataLoops
             RootMatr:(MATRIXcell *)pRootMatr SearchCurIndex:(int)iIndex;

- (void)SetParentMatrix:(int)IndexValue WithData:(int **)pData;
- (void)OnlyAddData:(int)IndexValue WithData:(int **)pData;
- (void)OnlyRemoveDataAtPlace:(int)iPlace WithData:(int **)pData;

- (void)OnlyRemoveDataAtPlace:(int)iPlace WithData:(int **)pData;
- (void)OnlyInsert:(int)iDataValue index:(int)iIndex WithData:(int **)pData;
- (void)OnlyRemoveDataAtPlaceSort:(int)iPlace WithData:(int **)pData;

- (void)EditEnterPoint:(int)iPlace matr:(MATRIXcell *)pMatr;

- (void)RemoveAllConnections:(NSMutableDictionary *)DataLoops
                    RootMatr:(MATRIXcell *)pRootMatr SearchCurIndex:(int)iIndex;

- (void)ClearArray:(int **)pData;

@end

