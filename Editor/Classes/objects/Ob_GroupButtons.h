
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

@interface Ob_GroupButtons : GObject {
@public
    int m_iNumButton;
    int m_iCurrentSelect;
    FractalString *pInsideString;
    NSMutableArray* m_pChildrenbjectsArrConn;
    NSMutableArray* m_pChildrenbjectsMinIcon;
    float m_fTimerCheckFlick;
}

-(id)Init:(id)Parent WithName:(NSString *)strName;

-(void)SetString:(FractalString *)Str;
-(void)Destroy;
-(void)Start;

- (void)Hide;
- (void)Show;
- (void)UpdateButt;
- (void)SetButton;

- (void)CreateOb:(FractalString *)pFrStr;
- (void)CreateObArrayUI:(int)pIndexData Index:(int)iCurIndex;

@end
