//
//  StringContainer.h
//  FunDreams
//
//  Created by Konstantin Maximov on 15.06.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FractalString.h"

@interface StringContainer : NSObject{
@public
    NSMutableArray *ArrayStrings;
    FunArrayData *ArrayPoints;
    NSMutableArray *ArrayActiveStrings;
    NSMutableDictionary *DicStrings;
    
    FractalString *pFStringObjects;
    CObjectManager* m_pObjMng;

    //массив менеджеров данных файла
    int m_iCurFile;
    NSMutableArray *ArrayDumpFiles;
    CDataManager *pDataCurManagerTmp;
    
    float  *fZeroPoint;
}

-(id)init:(id)Parent;
-(void)Update:(float)fDelta;

-(void)SetTemplateString;
-(id)GetString:(NSString *)strName;
-(void)AddString:(FractalString *)pString;
-(void)DelString:(FractalString *)strDel;
-(NSString *)GetRndName;

-(void)LoadContainer;
-(void)SaveContainer;
-(void)Synhronize;

@end
