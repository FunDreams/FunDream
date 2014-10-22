//
//  Kernel.h
//  FunDreams
//
//  Created by Konstantin on 19.03.13.
//  Copyright (c) 2013 FunDreams. All rights reserved.
//

#import <Foundation/Foundation.h>
@class StringContainer;

#define GM_DEFAULT              0

@interface Kernel : NSObject{
@public
    StringContainer *m_pContainer;
    FunArrayData *ArrayPoints;
    FunArrayDataIndexes *m_OperationIndex;
    FractalString *pFStringZero;
    
    int iCurrentIndMode;
    int iCurrentIndArrayMode;
    int iCurrentIndMatrix;
}

-(id)init:(id)Parent;

-(void)SetZeroKernel;
-(void)SetKernel;

-(MATRIXcell *)SetOperationMatrix:(int *)pStartDataListMatr nameTex:(NSString*)NameTex
                         listMatr:(int)iType nameOperation:(int)iName
                         withMatr:(MATRIXcell *)pMatrPar withIndIcon:(int *)pIndIcon;

-(int)SetEnter:(int)iIndexPar NameIcon:(NSString *)pName matr:(MATRIXcell *)pMatr
           icon:(int *)pIndIcon iPar:(int *)pIndPar;
-(int)SetExit:(int)iIndexPar NameIcon:(NSString *)pName matr:(MATRIXcell *)pMatr
          icon:(int *)pIndIcon iPar:(int *)pIndPar;


-(int)SetData:(int)iIndexPar withNameIcon:(NSString *)pName
     withMatr:(MATRIXcell *)pMatr withIndIcon:(int *)pIndIcon;

-(void)setPairParOb:(MATRIXcell *)pMatr arrayEn:(NSArray *)pArrayEn arrayEx:(NSArray *)pArrayEx;

-(int)CreateObByIndex:(int)iIndex withData:(FractalString *)DataValue;
-(int)CreateMatrByIndex:(int)iIndex;
-(int)CreateIntByIndex:(int)iIndex withData:(int)DataValue;
-(int)CreateUIntByIndex:(int)iIndex withData:(unsigned int)DataValue;
-(int)CreateFloatByIndex:(int)iIndex withData:(float)DataValue;
-(int)CreateSpriteByIndex:(int)iIndex;
-(int)CreateStringByIndex:(int)iIndex withData:(NSMutableString *)DataValue;
-(int)CreateTextureByIndex:(int)iIndex withData:(NSMutableString *)DataValue;
-(int)CreateSoundByIndex:(int)iIndex withData:(NSMutableString *)DataValue;

-(void)CreateModeIcons:(MATRIXcell *)pMatrPar withIndIcon:(int *)pIndIcon array:(NSArray *)pArray;

@end
