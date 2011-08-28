//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectSpaunSlice.h"
#import "ObjectTouchQueue.h"

@implementation NAME_TEMPLETS_OBJECT3
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
    m_bHiden=YES;
	m_iLayer = layerNotShow;

	mWidth  = 50;
	mHeight = 50;

//START_PROC(@"Proc");
//END_PROC(@"Proc");
    
//    LOAD_SOUND(iIdSound,@"knopka.wav",NO);
//    LOAD_TEXTURE(mTextureId,m_pNameTexture);

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)GetParams:(CParams *)Parametrs{[super GetParams:Parametrs];}
//------------------------------------------------------------------------------------------------------
- (void)SetParams:(CParams *)Parametrs{[super SetParams:Parametrs];}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];
    
    [m_pObjMng AddToGroup:@"Staffs" Object:self];
}
//------------------------------------------------------------------------------------------------------
- (void)Move{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor *)pProc{}
//------------------------------------------------------------------------------------------------------
-(void) Intersection{

    NSMutableArray *pPoints=(NSMutableArray *)GET_POINT(@"TouchQueue",@"m_pPoints");
    
    if ([pPoints count]>1) {
        PointQueue *pPoint1T = [pPoints objectAtIndex:[pPoints count]-1];
        PointQueue *pPoint2T = [pPoints objectAtIndex:[pPoints count]-2];
        
        Vector3D pPoint1 = Vector3DMake(pPoint1T->vPoint.x, pPoint1T->vPoint.y, 0);
        Vector3D pPoint2 = Vector3DMake(pPoint2T->vPoint.x, pPoint2T->vPoint.y, 0);
        
        Vector3D vPosition = Vector3DMake((pPoint2.x-pPoint1.x)*0.5f+pPoint1.x,
                                          (pPoint2.y-pPoint1.y)*0.5f+pPoint1.y, 0);

        Vector3D vDir = Vector3DMake((pPoint2.x-pPoint1.x), (pPoint2.y-pPoint1.y), 0);
        float fMagnitude=Vector3DMagnitude(vDir);

        float Angle=acosf(vDir.x/fMagnitude)*180/3.14f+90;
        if(pPoint2.y<pPoint1.y)Angle=-Angle;

        CREATE_NEW_OBJECT(@"ObjectSlice",@"Slice",
                          SET_INT(@"mWidth",20),
                          SET_INT(@"mHeight",fMagnitude*1.8f),
                          SET_VECTOR(@"m_pCurPosition",vPosition),
                          SET_VECTOR(@"m_pCurAngle",(TmpVector1=Vector3DMake(0, 0, Angle))),
                          SET_BOOL(@"m_bNoOffset",YES),
                          nil);
        
        UPDATE;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{[super Destroy];}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT3