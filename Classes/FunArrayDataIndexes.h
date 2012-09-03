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
}

-(id) initWithCopasity:(int)iCopasity;

-(void)AddData:(int)iDataValue;
-(void)RemoveDataAtIndex:(int)iIndex;
-(int)GetDataAtIndex:(int)iIndex;

@end

