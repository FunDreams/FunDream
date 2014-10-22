
//
//  Ob_Templet.h
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Object.h"
#import "ObjectParticle.h"
#import "Ob_NumIndicator.h"

@interface Ob_Editor_Num : GObject {
@public
  //  GObject *pOb;
    GObject *pObBtnClose;
    GObject *pObBtnClear;
    GObject *pObBtnMinus;
    GObject *pObBtnPoint;
    GObject *pObBtnPoint2;
    
    Ob_NumIndicator *pObInd;
    int iIndex;
    int iIndexArray;
    int iType;
    float m_fTmp;
    int m_iTmp;
    int OldInterfaceMode;
    
    Texture2D* TextureIndicatorValue;
    NSString *StrValue;
}

-(id)Init:(id)Parent WithName:(NSString *)strName;

-(void)Destroy;
-(void)Start;
-(void)Update;
-(void)Close;
-(void)ClickMinus;
- (void)AddValue:(int)V;
- (void)UpdateNum;
    
@end
