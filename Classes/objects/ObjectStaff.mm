//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectTouchQueue.h"
#import "ObjectStaff.h"

#define MAXVEL 800
#define PRVEL 60
#define STAF_LIMIT_POS 400
#define STAF_SPEEP_SCALE 15
#define LIMIT 10

@implementation NAME_TEMPLETS_OBJECT1
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];

	LOAD_SOUND(iIdSound_Gtesto,@"vzbivanie_testa.wav",NO);
	LOAD_SOUND(iIdSound_Gapple,@"rezka_yabloka.wav",NO);
	LOAD_SOUND(iIdSound_Gcarrot,@"rezka_morkovki.wav",NO);
	LOAD_SOUND(iIdSound_GBread,@"rezka_hleba.wav",NO);
	LOAD_SOUND(iIdSound_GKoktel,@"glotok.wav",NO);
	
	LOAD_SOUND(iIdSound_Btesto,@"perevorachivanie_testa.wav",NO);
	LOAD_SOUND(iIdSound_Bapple,@"porcha_yabloka.wav",NO);
	LOAD_SOUND(iIdSound_Bcarrot,@"porcha_morkovki.wav",NO);
	LOAD_SOUND(iIdSound_BBread,@"porcha_hleba.wav",NO);
	LOAD_SOUND(iIdSound_BKoktel,@"razlivanie.wav",NO);
	
	LOAD_SOUND(iIdSound_ObVisible,@"poiavlenie_predmeta.wav",NO);
	
	m_iLayer = layerOb1;

	mWidth  = 50;
	mHeight = 50;
			
    for (int i=0; i<1; i++) {
        
        NSString *pstr=[NSString stringWithString:@"koktel.png"];				
        CASH_TEXTURE(pstr);
    }
    
    for (int i=0; i<3; i++) {
        
        NSString *pstr=[NSString stringWithFormat:@"bread_%d.png", i+1];				
        CASH_TEXTURE(pstr);
    }
    
    for (int i=0; i<3; i++) {
        
        NSString *pstr=[NSString stringWithFormat:@"carrot_%d.png", i+1];
        CASH_TEXTURE(pstr);
    }
    
    for (int i=0; i<3; i++) {
        
        NSString *pstr=[NSString stringWithFormat:@"apple_%d.png", i+1];
        CASH_TEXTURE(pstr);
    }
    for (int i=0; i<2; i++) {
        
        NSString *pstr=[NSString stringWithFormat:@"Tarelka_%d.png", i+1];
        CASH_TEXTURE(pstr);
    }

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)GetParams:(CParams *)Parametrs{[super GetParams:Parametrs];}
//------------------------------------------------------------------------------------------------------
- (void)SetParams:(CParams *)Parametrs{
	[super SetParams:Parametrs];
	
	COPY_IN_STRING(m_pNameTexture);
	COPY_IN_INT(iType);
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
	
	[super Start];
		
	[m_pObjMng AddToGroup:@"Staffs" Object:self];

	[m_pArrayImages removeAllObjects];
	switch (iType) {
		case Koktel:{
			
			[self SetLayer:layerOb3];
			
			for (int i=0; i<1; i++) {

				NSString *pstr=[NSString stringWithString:@"koktel.png"];
				
				UInt32 TmpIdTexture=-1;
				LOAD_TEXTURE(TmpIdTexture,pstr);
				
				[m_pArrayImages addObject:[NSNumber numberWithInt:TmpIdTexture]];
			}
		}
			break;
		case Bread:{
			
			[self SetLayer:layerOb2];

			for (int i=0; i<3; i++) {
				
				NSString *pstr=[NSString stringWithFormat:@"bread_%d.png", i+1];
				
				UInt32 TmpIdTexture=-1;
				LOAD_TEXTURE(TmpIdTexture,pstr);
				
				[m_pArrayImages addObject:[NSNumber numberWithInt:TmpIdTexture]];
			}
		}
			break;

		case Carrot:{
			
			[self SetLayer:layerOb3];

			for (int i=0; i<3; i++) {
				
				NSString *pstr=[NSString stringWithFormat:@"carrot_%d.png", i+1];
				
				UInt32 TmpIdTexture=-1;
				LOAD_TEXTURE(TmpIdTexture,pstr);
				
				[m_pArrayImages addObject:[NSNumber numberWithInt:TmpIdTexture]];
			}
			
		}
			break;
		case apple:{
			
			[self SetLayer:layerOb3];

			for (int i=0; i<3; i++) {
				
				NSString *pstr=[NSString stringWithFormat:@"apple_%d.png", i+1];
				
				UInt32 TmpIdTexture=-1;
				LOAD_TEXTURE(TmpIdTexture,pstr);
				
				[m_pArrayImages addObject:[NSNumber numberWithInt:TmpIdTexture]];
			}
		}
			break;
		case Tarelka:{
			for (int i=0; i<2; i++) {
				
				NSString *pstr=[NSString stringWithFormat:@"Tarelka_%d.png", i+1];
				
				UInt32 TmpIdTexture=-1;
				LOAD_TEXTURE(TmpIdTexture,pstr);
				
				[m_pArrayImages addObject:[NSNumber numberWithInt:TmpIdTexture]];
			}
		}
			break;
		default:
			break;
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

//	START_PROC(@"Proc3");
	
//	UP_SELECTOR(@"e00",@"Idle:");
//	UP_SELECTOR(@"t01_0.3",@"UpdateTouch2:");
	
//	END_PROC(@"Proc3");
	
}
//------------------------------------------------------------------------------------------------------
//- (void)UpdateTouch2:(Processor *)pProc{
//	m_pLastPoint.x=-10000;
//}
//------------------------------------------------------------------------------------------------------
- (void)UpdateTouch:(Processor *)pProc{
	[self SetTouch:YES];
	NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)Move{
	m_fPhase+=DELTA*m_fSpeedScale;
	
	float OffsetScale=10*cos(m_fPhase);
	
	m_pCurScale.x=mWidth*0.5f+OffsetScale;
	m_pCurScale.y=mHeight*0.5f-OffsetScale;
	
}
//------------------------------------------------------------------------------------------------------
- (void)ChangePar2:(Processor *)pProc{

	int X1=900;
	int Y1=0;//Dir*STAF_LIMIT_POS+Dir*(mWidth*0.5f);
    
    if(iType==Koktel){
        X1=0;
        Y1=900;//Dir*STAF_LIMIT_POS+Dir*(mWidth*0.5f);
    }
	
	Vector3D vDirection = Vector3DMake(X1-m_pCurPosition.x,Y1-m_pCurPosition.y,0);
	Vector3DNormalize(&vDirection);
	
	m_pDirection = vDirection;
    
	NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
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

//	NSString *NameEx = [[[NSString alloc] initWithFormat:@"t01_%d",RND%8+3] autorelease];
//	UP_SELECTOR(NameEx,@"timerWaitNextStage:");
	[self SetTouch:YES];
	m_bHiden=NO;
//	PLAY_SOUND(iIdSound_ObVisible);

	NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)Action2:(Processor *)pProc{
//	float DirveVel=m_pDirection.y*m_fVel;
	
	if(m_pCurPosition.x > STAF_LIMIT_POS+400+mWidth*0.5f)
	{
		DESTROY_OBJECT(self);

//		SET_STAGE(m_strName,0);
	}
}
//------------------------------------------------------------------------------------------------------
- (void)Action:(Processor *)pProc{
		
	if((m_pCurPosition.x > VIEWPORT_W*0.5f+STAF_LIMIT_POS+mWidth*0.5f) || m_pCurPosition.x < -(VIEWPORT_W*0.5f+STAF_LIMIT_POS+mWidth*0.5f) ||
	   (m_pCurPosition.y > VIEWPORT_H*0.5f+STAF_LIMIT_POS+mHeight*0.5f) || m_pCurPosition.y < -(VIEWPORT_H*0.5f+STAF_LIMIT_POS+mHeight*0.5f))
	{
		DESTROY_OBJECT(self);
//		SET_STAGE(m_strName,0);
	}
}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor *)pProc{
	
	m_pCurPosition.x+=m_pDirection.x*DELTA*m_fVel;
	m_pCurPosition.y+=m_pDirection.y*DELTA*m_fVel;
}
//------------------------------------------------------------------------------------------------------
- (void)Update{
    
    int iCurAlk = GET_INT(@"Drunk", @"m_iCurAlk");
    OBJECT_SET_PARAMS(@"Score",SET_INT(@"iScoreAdd",1*(iCurAlk+1)),nil);        
    OBJECT_PERFORM_SEL(@"Score",@"ScoreAdd");

	int iCurStageTmp=[self FindProcByName:@"Proc"]->m_pICurrentStage;
	
	if(iCurStageTmp<3)SET_STAGE(m_strName,3);
	
	if([m_pArrayImages count]>1 && ((iCurStageTmp==2) || (iCurStageTmp==3) || (iCurStageTmp==4)))
	{
		if([m_pArrayImages count]>iFrame+1){
			
			iFrame++;
            
			mTextureId = [(NSNumber *)[m_pArrayImages objectAtIndex:iFrame] intValue];
	//		m_fVel=PRVEL;
			
			if([m_pArrayImages count]==iFrame+1)
			{
				m_fVel=MAXVEL;
				[self SetTouch:NO];
			}
			else 
			{
				[self SetTouch:NO];
				[[self FindProcByName:@"Proc2"] NextStage];
			}
		}
	}
	
	if(iType==Koktel)
	{
		m_fVel=MAXVEL;
		[self SetTouch:NO];
		
		[[[m_pObjMng GetObjectByName:@"Drunk"] FindProcByName:@"Proc3"] SetStage:1];
	}
}
//------------------------------------------------------------------------------------------------------
- (void)breakStaff{
	
	[self SetTouch:NO];
//	SET_STAGE(m_strName,5);

//	m_bHiden=YES;
	
	switch (iType) {

		case Koktel:
			CREATE_NEW_OBJECT(@"ObjectBreakShaff",@"break",SET_INT(@"iType",iType),
							  SET_FLOAT(@"mWidth",155*FACTOR_INC),
							  SET_FLOAT(@"mHeight",154),
							  SET_VECTOR(@"m_pCurPosition",m_pCurPosition),
							  SET_INT(@"m_iLayer",layerInterfaceSpace1),
	//						  SET_BOOL(@"m_bNoOffset",YES),
							  nil);			

			PLAY_SOUND(iIdSound_BKoktel);

			break;
		case Carrot:
			
			CREATE_NEW_OBJECT(@"ObjectBreakShaff",@"break",SET_INT(@"iType",iType),
							  SET_FLOAT(@"mWidth",685*FACTOR_INC),
							  SET_FLOAT(@"mHeight",182),
							  SET_VECTOR(@"m_pCurPosition",m_pCurPosition),
							  SET_INT(@"m_iLayer",layerInterfaceSpace1),
	//						  SET_BOOL(@"m_bNoOffset",YES),
							  nil);	
			
			PLAY_SOUND(iIdSound_Bcarrot);

			break;

		case Bread:
			CREATE_NEW_OBJECT(@"ObjectBreakShaff",@"break",SET_INT(@"iType",iType),
							  SET_FLOAT(@"mWidth",694*FACTOR_INC),
							  SET_FLOAT(@"mHeight",344),
							  SET_VECTOR(@"m_pCurPosition",m_pCurPosition),
							  SET_INT(@"m_iLayer",layerInterfaceSpace1),
		//					  SET_BOOL(@"m_bNoOffset",YES),
							  nil);
			
			PLAY_SOUND(iIdSound_BBread);

			break;
		case apple:
			
			CREATE_NEW_OBJECT(@"ObjectBreakShaff",@"break",SET_INT(@"iType",iType),
							  SET_FLOAT(@"mWidth",274*FACTOR_INC),
							  SET_FLOAT(@"mHeight",224),
							  SET_VECTOR(@"m_pCurPosition",m_pCurPosition),
							  SET_INT(@"m_iLayer",layerInterfaceSpace1),
		//					  SET_BOOL(@"m_bNoOffset",YES),
							  nil);
			
			PLAY_SOUND(iIdSound_Bapple);

			break;
			
		case Tarelka:

			CREATE_NEW_OBJECT(@"ObjectBreakShaff",@"break",SET_INT(@"iType",iType),
							  SET_FLOAT(@"mWidth",560*FACTOR_INC),
							  SET_FLOAT(@"mHeight",450),
							  SET_VECTOR(@"m_pCurPosition",m_pCurPosition),
							  SET_INT(@"m_iLayer",layerInterfaceSpace1),
		//					  SET_BOOL(@"m_bNoOffset",YES),
							  nil);
			PLAY_SOUND(iIdSound_Btesto);

			break;
			
	}

	DESTROY_OBJECT(self);
	
	NSMutableArray *pArray=[m_pObjMng->m_pGroups objectForKey:@"life"];
	int iCount= [pArray count];
	
	if(iCount>0)
	{
		NSString *pTmpName = [NSString stringWithFormat:@"life%d",iCount];
		
		[m_pObjMng RemoveFromGroup:@"life" Object:[m_pObjMng GetObjectByName:pTmpName]];
		SET_STAGE(pTmpName,2);
		
		if(iCount==1)OBJECT_SET_PARAMS(@"TouchQueue",SET_BOOL(@"m_bEnable",NO),nil);
	}
	
	UPDATE;
}
//------------------------------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------------------------------
-(void) Intersection{
	
//	int iCurStageTmp=[self FindProcByName:@"Proc2"]->m_pICurrentStage;

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

				if(iType==Bread || iType==Tarelka || iType==apple || iType==Carrot){
					RectObject.x_max*=0.8f;
					RectObject.x_min*=0.8f;
					
					RectObject.y_max*=0.8f;
					RectObject.y_min*=0.8f;
				}
				
				if([self cohen_sutherland:&RectObject PointA:&P1 PointB:&P2]==0){
					
					if(P1.y>P2.y && (iType==Bread || iType==Carrot  || iType==apple))
					{
						if(iType==Bread)PLAY_SOUND(iIdSound_GBread);
						if(iType==Carrot)PLAY_SOUND(iIdSound_Gcarrot);
						if(iType==apple)PLAY_SOUND(iIdSound_Gapple);
						[self Update];
					}
					else if(P2.y>P1.y && ((iType==Koktel || iType==Tarelka)))
					{
						if(iType==Tarelka)PLAY_SOUND(iIdSound_Gtesto);
						if(iType==Koktel)PLAY_SOUND(iIdSound_GKoktel);
						
						[self Update];
					}
					else [self breakStaff];
					
					return;
				}			
			}
		}
	}
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT1