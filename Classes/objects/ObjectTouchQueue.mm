//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectTouchQueue.h"
//------------------------------------------------------------------------------------------------------
@implementation PointQueue
//------------------------------------------------------------------------------------------------------
-(id)Init:(float)Time WithPoint:(CGPoint)Point{
	
	vPoint.x=Point.x;
	vPoint.y=Point.y;
	vPoint.z=0;
	
	m_fTime=Time;
	
	return self;
}
//------------------------------------------------------------------------------------------------------
-(void)dealloc{[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------------------------------
@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
	m_iLayer = layerTemplet;
	m_bHiden=YES;
	
	[self SetTouch:YES];
	
	m_pPoints = [[NSMutableArray alloc] init];
	
	LOAD_SOUND(iIdSound,@"vzmah.wav",NO);
	
	m_bEnable=NO;

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)GetParams:(CParams *)Parametrs{
	[super GetParams:Parametrs];
	
	COPY_OUT_POINT(m_pPoints);
	COPY_OUT_BOOL(m_bEnable);
}
//------------------------------------------------------------------------------------------------------
- (void)SetParams:(CParams *)Parametrs{
	[super SetParams:Parametrs];
	
	COPY_IN_BOOL(m_bEnable);
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
	[super Start];
	
	START_PROC(@"Proc");
	
	UP_SELECTOR(@"e01",@"Idle:");

	END_PROC(@"Proc");
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateStateObjects{

	for (GObject *pOb in [m_pObjMng->m_pGroups objectForKey:@"Staffs"]){
		OBJECT_PERFORM_SEL(pOb->m_strName,@"Intersection");
	}
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateArray{

repeate:
	if([m_pPoints count]>LIMIT_POINTS){
		[[m_pPoints objectAtIndex:0] release];
		[m_pPoints removeObjectAtIndex:0];
		goto repeate;
	}
}
//------------------------------------------------------------------------------------------------------
- (void)ClearArray{

	for (id Ob in m_pPoints) [Ob release];
	[m_pPoints removeAllObjects];
}
//------------------------------------------------------------------------------------------------------
- (void)Move{
	
	for(int i=0;i<[m_pPoints count];i++){
		PointQueue *pQueue = [m_pPoints objectAtIndex:i];
		
		pQueue->m_fTime-=DELTA;
		
		if(pQueue->m_fTime<0){
			[m_pPoints removeObjectAtIndex:i];
			i--;
		}
	}
}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
	
	if(m_bEnable==YES){

		[self ClearArray];	
		
		PLAY_SOUND(iIdSound);

		PointQueue *pQueue = [[PointQueue alloc] Init:TIME_LIFE WithPoint:Point];
		[m_pPoints addObject:pQueue];
		
		[self UpdateArray];
		[self UpdateStateObjects];
	}
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
	
	if(m_bEnable==YES){

		PointQueue *pQueue = [[PointQueue alloc] Init:TIME_LIFE WithPoint:Point];
		[m_pPoints addObject:pQueue];

		[self UpdateArray];
		[self UpdateStateObjects];
	}
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
	
	if(m_bEnable==YES){

		PointQueue *pQueue = [[PointQueue alloc] Init:TIME_LIFE WithPoint:Point];
		[m_pPoints addObject:pQueue];

		[self UpdateArray];
		[self UpdateStateObjects];
	}
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)touchesBeganOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)touchesEndedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {
	[super dealloc];
	[m_pPoints release];
}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT