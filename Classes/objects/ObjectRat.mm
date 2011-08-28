//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectTouchQueue.h"
#import "ObjectRat.h"

#define MAXVEL 800
#define PRVEL 60
#define STAF_LIMIT_POS 400
#define STAF_SPEEP_SCALE 15
#define LIMIT 10

@implementation NAME_TEMPLETS_OBJECT3
//------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];

	LOAD_SOUND(iIdSound_BRat,@"mouse_dead.wav",NO);	
	LOAD_SOUND(iIdSound_GRat,@"mouse_bad.wav",NO);
	
	m_iLayer = layerOb1;

	mWidth  = 50;
	mHeight = 50;

    for (int i=0; i<7; i++) {
        
        NSString *pstr=[NSString stringWithFormat:@"rat%d.png", i+1];
        CASH_TEXTURE(pstr);
    }

	return self;
}
//------------------------------------------------------------------------------------------------
- (void)GetParams:(CParams *)Parametrs{[super GetParams:Parametrs];}
//------------------------------------------------------------------------------------------------
- (void)SetParams:(CParams *)Parametrs{
	[super SetParams:Parametrs];
	
	COPY_IN_STRING(m_pNameTexture);
	COPY_IN_INT(iType);
}
//------------------------------------------------------------------------------------------------
- (void)Start{
	
	[super Start];
		
	[m_pObjMng AddToGroup:@"Staffs" Object:self];

	[m_pArrayImages removeAllObjects];
    
    for (int i=0; i<7; i++) {
            
        NSString *pstr=[NSString stringWithFormat:@"rat%d.png", i+1];
        
        UInt32 TmpIdTexture=-1;
        LOAD_TEXTURE(TmpIdTexture,pstr);
        
        [m_pArrayImages addObject:[NSNumber numberWithInt:TmpIdTexture]];
    }

	iFrame=0;
	mTextureId = [(NSNumber *)[m_pArrayImages objectAtIndex:iFrame] intValue];

	int Dir=RND%2-1;
	if(Dir==0)Dir=1;

	m_pCurPosition.x=-20000;//((float)(RND%600)-300);
	m_pCurPosition.y=0;//Dir*STAF_LIMIT_POS+Dir*(mWidth*0.5f);
	
	m_fSpeedScale = STAF_SPEEP_SCALE+(RND%8-4);	
	m_fPhase=RND%10;

START_PROC(@"Proc");
	
	UP_SELECTOR(@"a00",@"ChangePar:");

	UP_SELECTOR(@"e02",@"Proc:");
	UP_SELECTOR(@"a02",@"Action:");

	UP_SELECTOR(@"e03",@"ChangePar2:");
	UP_SELECTOR(@"a04",@"Action2:");
	UP_SELECTOR(@"e04",@"Proc:");
	
	UP_SELECTOR(@"t05_0.2",@"timerWaitNextStage:");
//	UP_SELECTOR(@"e05",@"Idle:");

END_PROC(@"Proc");
	
START_PROC(@"Proc2");
	
	UP_SELECTOR(@"e00",@"Idle:");
	UP_SELECTOR(@"t01_0.4",@"UpdateTouch:");

END_PROC(@"Proc2");
    
START_PROC(@"Proc3");
    
    UP_POINT(@"p00_i_Frame",&mTextureId);
	UP_CONST_INT(@"p00_i_Direct",1);
	UP_SELECTOR(@"t00_0.07",@"Animate:");
	
	UP_CONST_INT(@"s00_i_Frame",mTextureId);
	UP_CONST_INT(@"f00_i_Frame",mTextureId+6);

END_PROC(@"Proc3");
}
//------------------------------------------------------------------------------------------------
//- (void)UpdateTouch2:(Processor *)pProc{
//	m_pLastPoint.x=-10000;
//}
//------------------------------------------------------------------------------------------------
- (void)UpdateTouch:(Processor *)pProc{
	[self SetTouch:YES];
	NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------
- (void)Move{}
//------------------------------------------------------------------------------------------------
- (void)ChangePar2:(Processor *)pProc{
	
	int X1=0;
	int Y1=900;
	
	Vector3D vDirection = Vector3DMake(X1-m_pCurPosition.x,Y1-m_pCurPosition.y,0);
	Vector3DNormalize(&vDirection);
	
	m_pDirection = vDirection;

	NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------
- (void)ChangePar:(Processor *)pProc{
	
	iFrame=0;
	mTextureId = [(NSNumber *)[m_pArrayImages objectAtIndex:iFrame] intValue];

	int X1=0;
	int Y1=0;
	
	switch (RND%4) {
		case 0:
			X1=-(STAF_LIMIT_POS-20+VIEWPORT_W*0.5f)-(mWidth*0.5f);
			Y1=(RND%600)-300;
			break;
		case 1:
			X1=(STAF_LIMIT_POS-20+VIEWPORT_W*0.5f)+(mWidth*0.5f);
			Y1=(RND%600)-300;
			break;
		case 2:
			X1=(RND%1000)-500;
			Y1=-(STAF_LIMIT_POS-20+VIEWPORT_H*0.5f)-(mHeight*0.5f);
			break;
		case 3:
			X1=(RND%1000)-500;
			Y1=(STAF_LIMIT_POS-20+VIEWPORT_H*0.5f)+(mHeight*0.5f);
			break;
		default:
			break;
	}

	int X2=RND%100-50;
	int Y2=RND%100-50;

	m_pCurPosition.x=X1;
	m_pCurPosition.y=Y1;

	Vector3D vDirection = Vector3DMake(X2-X1,Y2-Y1,0);
	Vector3DNormalize(&vDirection);

	m_pDirection = vDirection;
	m_fVel=RND%100+200;

    float Angle=acosf(m_pDirection.x/1)*180/3.14f;
    if(Y2<Y1)Angle=-Angle-90;
    else Angle=Angle+90+180;
    
    m_pCurAngle.z=Angle;
//	NSString *NameEx = [[[NSString alloc] initWithFormat:@"t01_%d",RND%8+3] autorelease];
//	UP_SELECTOR(NameEx,@"timerWaitNextStage:");
	[self SetTouch:YES];
	m_bHiden=NO;
//	PLAY_SOUND(iIdSound_ObVisible);

	NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------
- (void)Action2:(Processor *)pProc{
//	float DirveVel=m_pDirection.y*m_fVel;
	
	if(m_pCurPosition.x > STAF_LIMIT_POS+400+mWidth*0.5f)
	{
		DESTROY_OBJECT(self);

//		SET_STAGE(m_strName,0);
	}
}
//------------------------------------------------------------------------------------------------
- (void)Action:(Processor *)pProc{
		
	if((m_pCurPosition.x > VIEWPORT_W*0.5f+STAF_LIMIT_POS+mWidth*0.5f) || m_pCurPosition.x < -(VIEWPORT_W*0.5f+STAF_LIMIT_POS+mWidth*0.5f) ||
	   (m_pCurPosition.y > VIEWPORT_H*0.5f+STAF_LIMIT_POS+mHeight*0.5f) || m_pCurPosition.y < -(VIEWPORT_H*0.5f+STAF_LIMIT_POS+mHeight*0.5f))
	{
		DESTROY_OBJECT(self);
//		SET_STAGE(m_strName,0);
	}
}
//------------------------------------------------------------------------------------------------
- (void)Proc:(Processor *)pProc{
	
	m_pCurPosition.x+=m_pDirection.x*DELTA*m_fVel;
	m_pCurPosition.y+=m_pDirection.y*DELTA*m_fVel;
}
//------------------------------------------------------------------------------------------------
- (void)Update{
	
    int iCurStageTmp=[self FindProcByName:@"Proc"]->m_pICurrentStage;
    if(iCurStageTmp<3)SET_STAGE(m_strName,3);

    NSMutableArray *pArray=[m_pObjMng->m_pGroups objectForKey:@"life"];
	int iCount= [pArray count];
	
	if(iCount>0)
	{
		NSString *pTmpName = [NSString stringWithFormat:@"life%d",iCount];
		
		[m_pObjMng RemoveFromGroup:@"life" Object:[m_pObjMng GetObjectByName:pTmpName]];
		SET_STAGE(pTmpName,2);
		
		if(iCount==1)OBJECT_SET_PARAMS(@"TouchQueue",SET_BOOL(@"m_bEnable",NO),nil);
	}

    PLAY_SOUND(iIdSound_GRat);
    m_fVel=MAXVEL;
    [self SetTouch:NO];    
}
//------------------------------------------------------------------------------------------------
- (void)breakStaff{
	
    int iCurAlk = GET_INT(@"Drunk", @"m_iCurAlk");
    OBJECT_SET_PARAMS(@"Score",SET_INT(@"iScoreAdd",1*(iCurAlk+1)),nil);        
    OBJECT_PERFORM_SEL(@"Score",@"ScoreAdd");

	[self SetTouch:NO];
	
    CREATE_NEW_OBJECT(@"ObjectBreakRat",@"breakRat",
                      SET_FLOAT(@"mWidth",mWidth*FACTOR_INC),
                      SET_FLOAT(@"mHeight",mHeight),
                      SET_VECTOR(@"m_pCurPosition",m_pCurPosition),
                      SET_VECTOR(@"m_pCurAngle", m_pCurAngle),
                      SET_INT(@"m_iLayer",layerInterfaceSpace1),
                      nil);			

	DESTROY_OBJECT(self);
	UPDATE;
}
//------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
	
//	if (m_pLastPoint.x!=-10000 && abs(m_pLastPoint.y-Point.y)>LIMIT) {
//		
//		m_pLastPoint.x=-10000;
//		
//		if(m_pLastPoint.y>Point.y && (iType==Bread || iType==Carrot  || iType==apple))
//			[self Update];
//		else if(m_pLastPoint.y<Point.y && ((iType==Koktel || iType==Tarelka)))
//			[self Update];
//		else [self breakStaff];
//	}
}
//------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{

//	if (m_pLastPoint.x==-10000) {
//		m_pLastPoint=Point;
//	}
//	else if(abs(m_pLastPoint.y-Point.y)>LIMIT){
//
//		if(m_pLastPoint.y>Point.y && (iType==Bread || iType==Carrot  || iType==apple))
//			[self Update];
//		else if(m_pLastPoint.y<Point.y && ((iType==Koktel || iType==Tarelka)))
//			[self Update];
//		else [self breakStaff];
//		
//		m_pLastPoint.x=-10000;
//	}
}
//------------------------------------------------------------------------------------------------
-(void) Intersection{

	if(m_bTouch==YES)
	{
		NSMutableArray *pPoints=(NSMutableArray *)GET_POINT(@"TouchQueue",@"m_pPoints");
		
		if ([pPoints count]>1) {
			for (int i=0; i< [pPoints count]-1; i++) {
				PointQueue *pPoint1T = [pPoints objectAtIndex:i];
				PointQueue *pPoint2T = [pPoints objectAtIndex:i+1];

				Vector3D pPoint1 = Vector3DMake(pPoint1T->vPoint.x, pPoint1T->vPoint.y, 0);
				Vector3D pPoint2 = Vector3DMake(pPoint2T->vPoint.x, pPoint2T->vPoint.y, 0);

				if(pPoint1.y==pPoint2.y)return;

				pPoint1.x-=m_pObjMng->m_pParent->m_vOffset.x;
				pPoint1.y-=m_pObjMng->m_pParent->m_vOffset.y;

				pPoint2.x-=m_pObjMng->m_pParent->m_vOffset.x;
				pPoint2.y-=m_pObjMng->m_pParent->m_vOffset.y;

				Vector3D VstartPoint1 = Vector3DMake(pPoint1.x-m_pCurPosition.x,pPoint1.y-m_pCurPosition.y,0);
				Vector3D TmpRotate1=Vector3DRotateZ2D(VstartPoint1,-m_pCurAngle.z);

				Vector3D VstartPoint2 = Vector3DMake(pPoint2.x-m_pCurPosition.x,pPoint2.y-m_pCurPosition.y,0);
				Vector3D TmpRotate2=Vector3DRotateZ2D(VstartPoint2,-m_pCurAngle.z);

				point2d P1,P2;
				rect2d RectObject;

				P1.x=TmpRotate1.x;
				P1.y=TmpRotate1.y;

				P2.x=TmpRotate2.x;
				P2.y=TmpRotate2.y;

				RectObject.x_max=(1+m_pOffsetVert.x)*mWidth*0.5f;
				RectObject.x_min=(m_pOffsetVert.x-1)*mWidth*0.5f;

				RectObject.y_max=(1+m_pOffsetVert.y)*mHeight*0.5f;
				RectObject.y_min=(m_pOffsetVert.y-1)*mHeight*0.5f;

				if([self cohen_sutherland:&RectObject PointA:&P1 PointB:&P2]==0){

					if(pPoint2.x>pPoint1.x)
					{
						[self Update];
					}
					else{
                        
                        PLAY_SOUND(iIdSound_BRat);
                        [self breakStaff];
                    }
					
					return;
				}			
			}
		}
	}
}
//------------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT3