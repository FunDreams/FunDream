//
//  FunArrayData.h
//  FunDreams
//
//  Created by Konstantin Maximov on 24.04.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FunArrayData : NSObject{
@public
    void *pData;
    int iCount;
    int iCountInArray;
    int iCoundAdd;
    int iType;
}

-(id) initWithCopasity:(int)iCopasity CountByte:(int)i_Type;

-(void)Reserv:(int)NewSize;
-(void)AddData:(void *)pDataValue;
-(void)RemoveDataAtIndex:(int)iIndex;
-(void *)GetDataAtIndex:(int)iIndex;
-(void)Reset;

@end
