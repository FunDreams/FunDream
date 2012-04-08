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
    self = [super Init:Parent WithName:strName];
	if (self != nil)
    {

        m_iLayer = layerSystem;
        
        mWidth  = 640;
        mHeight = 960;
        
  //      GET_TEXTURE(mTextureId,m_pNameTexture);
        
    //    [self SelfOffsetVert:Vector3DMake(0,1,0)];//cдвиг
     //   m_iLayerTouch=layerTouch_0;//слой касания
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    
    Processor_ex *pProc = [self START_QUEUE:@"TimeDie"];
        ASSIGN_STAGE(@"Idle",@"Idle:",nil);
        ASSIGN_STAGE(@"TimerDie",@"Proc:",
                     SET_INT_V(200, @""));
    
    [self END_QUEUE:pProc name:@"TimeDie"];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];
    [self SetTouch:YES];//интерактивность
}
//------------------------------------------------------------------------------------------------------
- (float)GetNearDist:(CGPoint)Point{
    TmpLastNearOb=nil;
    
    NSArray *pBullets=[m_pObjMng GetGroup:@"StartBullet"];
    
    float MinDist=1000000;
    for (int i=0;i<[pBullets count];i++) {
        
        GObject *pObt=(GObject *)[pBullets objectAtIndex:i];
        Vector3D V=Vector3DMake(Point.x-pObt->m_pCurPosition.x,Point.y-pObt->m_pCurPosition.y,0);
        float Dist=Vector3DMagnitude(V);
        
        if(Dist<MinDist){
            MinDist=Dist;
            TmpLastNearOb=pObt;
        }
    }
    
    return MinDist;
}
//------------------------------------------------------------------------------------------------------
- (GObject *)GetNear:(CGPoint)Point{
    GObject *TmpOb=nil;
    
    NSArray *pBullets=[m_pObjMng GetGroup:@"StartBullet"];
    
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
- (CGPoint)CoppectPoint:(CGPoint)Point{
//    GObject *TmpOb=nil;
    CGPoint Ret=Point;
    
    Ret.y+=100;
    
//    NSArray *pBullets=[m_pObjMng GetGroup:@"BallDown"];
//    
//    float MinDist=1000000;
//    for (int i=0;i<[pBullets count];i++) {
//        
//        GObject *pObt=(GObject *)[pBullets objectAtIndex:i];
//        Vector3D V=Vector3DMake(Point.x-pObt->m_pCurPosition.x,Point.y-pObt->m_pCurPosition.y,0);
//        float Dist=Vector3DMagnitude(V);
//        
//        if(Dist<MinDist){
//            MinDist=Dist;
//            TmpOb=pObt;
//        }
//    }
    
    return Ret;
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{

    NSArray * pBullets=[m_pObjMng GetGroup:@"MustDie"];
    
    for (int i=0;i<[pBullets count];i++) {
        
        GObject *pObt=(GObject *)[pBullets objectAtIndex:i];
        
        if(pObt!=nil){
            DESTROY_OBJECT(pObt);
        }
    }
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
//    return;
//    if(pOb){
//        DESTROY_OBJECT(pOb);
//        pOb=nil;
//    }

    GObject *pOb=CREATE_NEW_OBJECT(@"Ob_PensilPar", @"Pensil",
                      SET_VECTOR_V(Vector3DMake(Point.x,Point.y+110,0),@"m_pCurPosition"));
    
    [m_pChildrenbjectsArr addObject:pOb];

    m_vLastPos=pOb->m_pCurPosition;
    
//    if([self GetNearDist:Point]>40){
//
//        Point=[self CoppectPoint:Point];
//
//        PLAY_SOUND(@"StartTouch.wav");
//        CREATE_NEW_OBJECT(@"ObjectBullet", @"Bullet",
//                          SET_VECTOR_V(Vector3DMake(Point.x, Point.y, 0),@"m_pCurPosition"));
//    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    float fDist=(Point.x-m_vLastPos.x)*(Point.x-m_vLastPos.x)+(Point.y+110-m_vLastPos.y)*(Point.y+110-m_vLastPos.y);
    
    if(sqrt(fDist)>40){
        GObject *pOb=CREATE_NEW_OBJECT(@"Ob_PensilPar", @"Pensil",
                          SET_VECTOR_V(Vector3DMake(Point.x,Point.y+110,0),@"m_pCurPosition"));
        m_vLastPos=pOb->m_pCurPosition;
        
        [m_pChildrenbjectsArr addObject:pOb];
    }

//    GObject *pObject = [self GetNear:Point];
//
//    if(pObject!=nil){
//
//        Point=[self CoppectPoint:Point];
//        
//        OBJECT_SET_PARAMS(NAME(pObject),
//                          SET_VECTOR_V(Vector3DMake(Point.x, Point.y, 0),@"m_pCurPosition"));
//        
//        [pObject Update];
//    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
        
    int iCount=[m_pChildrenbjectsArr count];
    for (int i=0; i<iCount; i++) {
        GObject *pOb=[m_pChildrenbjectsArr objectAtIndex:i];
        NEXT_STAGE_EX(pOb->m_strName, @"Proc");
    }
    
    [m_pChildrenbjectsArr removeAllObjects];
    
    
//    GObject *pObject = [self GetNear:Point];
//
//    [m_pObjMng RemoveFromGroup:@"StartBullet" Object:pObject];
//
//    if(m_pParent->m_CountTouch==[m_pParent->mpCurtouches count]){
//        
//        if(pObject!=nil){SET_STAGE_EX(NAME(pObject),@"Proc",@"Move");}
//        
//        NSArray * pBullets=[m_pObjMng GetGroup:@"MustDie"];
//
//        int iCount=[pBullets count];
//        for (int i=0;i<iCount;i++) {
//            
//            GObject *pObt=(GObject *)[pBullets objectAtIndex:0];
//            
//            SET_STAGE_EX(NAME(pObt),@"Proc",@"Move");
//            [m_pObjMng RemoveFromGroup:@"MustDie" Object:pObt];
//        }
//    }
//    else
//    {
//        SET_STAGE_EX(NAME(self),@"TimeDie",@"TimerDie");
//        if(pObject!=nil)[m_pObjMng AddToGroup:@"MustDie" Object:pObject];
//    }
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEndedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    int iCount=[m_pChildrenbjectsArr count];
    for (int i=0; i<iCount; i++) {
        GObject *pOb=[m_pChildrenbjectsArr objectAtIndex:i];
        NEXT_STAGE_EX(pOb->m_strName, @"Proc");
    }
    
    [m_pChildrenbjectsArr removeAllObjects];
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
@end