//
//  FunArrayData.h
//  FunDreams
//
//  Created by Konstantin Maximov on 24.04.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FunArrayDataIndexes : NSObject{
@public
    int *pData;
    int m_iCopasity;
    int iCountInArray;
    int iCoundAdd;
    bool bOrder;
}

-(id) initWithCopasity:(int)iCopasity;

- (void)Extend;
-(void)AddData:(int)iDataValue;
-(void)RemoveDataAtIndex:(int)iIndex;
-(int)GetDataAtIndex:(int)iIndex;
- (void)Reserv:(int)iCount;
- (void)Insert:(int)iDataValue index:(int)iIndex;

-(void)selfSave:(NSMutableData *)m_pData;
-(void)selfLoad:(NSMutableData *)m_pData rpos:(int *)iCurReadingPos;

@end

