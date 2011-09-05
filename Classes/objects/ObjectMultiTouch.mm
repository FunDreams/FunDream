//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectMultiTouch.h"

@implementation ObjectMultiTouch
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
	m_iLayer = layerSystem;
    
	mWidth  = 640;
	mHeight = 960;

//START_QUEUE(@"Proc");
//	ASSIGN_STAGE(@"Idle",@"Idle:",nil);
////	ASSIGN_STAGE(@"Proc",@"Proc:",nil);
//END_QUEUE(@"Proc");
    
    GET_TEXTURE(mTextureId,m_pNameTexture);
    
//    [self SelfOffsetVert:Vector3DMake(0,1,0)];//cдвиг
 //   m_iLayerTouch=layerTouch_0;//слой касания

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];
    [self SetTouch:YES];//интерактивность
}
//------------------------------------------------------------------------------------------------------
- (GObject *)GetNear:(CGPoint)Point{
    GObject *TmpOb=nil;
    
    NSArray *pBullets=[m_pObjMng GetGroup:@"Bullets"];
    
    float MinDist=1000000;
    for (int i=0;i<[pBullets count];i++) {
        
        GObject *pObt=(GObject *)[pBullets objectAtIndex:i];
        Vector3D V=Vector3DMake(Point.x-pObt->m_pCurPosition.x,Point.y-pObt->m_pCurPosition.y,0);
        float Dist=Vector3DMagnitude(V);
        
        if(Dist<MinDist){
            MinDist=Dist;
            TmpOb=pObt;
        }
    }
    
    return TmpOb;
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
//    if(pOb){
//        DESTROY_OBJECT(pOb);
//        pOb=nil;
//    }
    CREATE_NEW_OBJECT(@"ObjectBullet", @"Bullet",
                          SET_VECTOR_V(Vector3DMake(Point.x, Point.y, 0),@"m_pCurPosition"));
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    GObject *pObject = [self GetNear:Point];

    if(pObject!=nil){
        OBJECT_SET_PARAMS(NAME(pObject),
                          SET_VECTOR_V(Vector3DMake(Point.x, Point.y, 0),@"m_pCurPosition"));
    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    GObject *pObject = [self GetNear:Point];
    
    if(pObject!=nil){
        DESTROY_OBJECT(pObject);
    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEndedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    GObject *pObject = [self GetNear:Point];
    
    if(pObject!=nil){
        DESTROY_OBJECT(pObject);
    }
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end