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
    
    StringContainer *m_pContainer;
    FunArrayData *ArrayPoints;
    FunArrayDataIndexes *m_OperationIndex;
    FractalString *pFStringZero;
}

-(id)init:(id)Parent;

-(void)SetZeroKernel;
-(void)SetKernel;

-(MATRIXcell *)SetOperationMatrix:(int *)pStartDataListMatr nameTex:(NSString*)NameTex
                         listMatr:(int)iType nameOperation:(int)iName
                         withMatr:(MATRIXcell *)pMatrPar withIndIcon:(int *)pIndIcon;

-(void)SetEnter:(int)iIndexPar NameIcon:(NSString *)pName matr:(MATRIXcell *)pMatr
           icon:(int *)pIndIcon iPar:(int *)pIndPar;
-(void)SetExit:(int)iIndexPar NameIcon:(NSString *)pName matr:(MATRIXcell *)pMatr
          icon:(int *)pIndIcon iPar:(int *)pIndPar;


-(int)SetData:(int)iIndexPar withNameIcon:(NSString *)pName
     withMatr:(MATRIXcell *)pMatr withIndIcon:(int *)pIndIcon;



-(int)CreateObByIndex:(int)iIndex withData:(FractalString *)DataValue;
-(int)CreateMatrByIndex:(int)iIndex;
-(int)CreateIntByIndex:(int)iIndex withData:(int)DataValue;
-(int)CreateFloatByIndex:(int)iIndex withData:(float)DataValue;
-(int)CreateSpriteByIndex:(int)iIndex;
-(int)CreateStringByIndex:(int)iIndex withData:(NSMutableString *)DataValue;
-(int)CreateTextureByIndex:(int)iIndex withData:(NSMutableString *)DataValue;


@end
