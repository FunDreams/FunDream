
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

#define R_ICON          1
#define R_TEXTURE       2
#define R_SOUND         3
#define R_ATLAS         4

@interface Ob_ResourceMng : GObject {
@public
    NSString *RootFolder;
    int m_iTypeRes;
    GObject *pObBtnClose;
    
    int NumButtons;
    float m_fCurrentOffset;
    float m_fUpLimmit,m_fDownLimmit;
    float m_fStartOffset;
    
    bool m_bStartPush;
    CGPoint m_pStartPoint;
}

-(id)Init:(id)Parent WithName:(NSString *)strName;

-(void)Destroy;
-(void)Start;
-(void)Update;

- (void)Move:(CGPoint)Point;
    
@end
