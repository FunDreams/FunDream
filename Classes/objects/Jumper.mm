//
//  Parachute.m
//  Engine
//
//  Created by svp on 17.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Jumper.h"

@implementation CJumper
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName {
	[super Init:Parent WithName:strName];
	
//	m_iLayer = layerNumber;
//
////	int iImageNum = 0;
//
//	UIImageView *imageView = [ [ UIImageView alloc ] initWithFrame:CGRectMake(-20, -23, 40, 45)];
//	imageView.image = [UIImage imageNamed:@"3-01@2x.png"];
//	imageView.hidden = YES;
//	[m_pParent AddSubview:imageView withLayer: m_iLayer];
//	[self AddUIObject: imageView];	
//	
//	imageView = [ [ UIImageView alloc ] initWithFrame:CGRectMake(-20, -23, 40, 45)];
//	imageView.image = [UIImage imageNamed:@"2-01@2x.png"];
//	imageView.animationDuration = 0.5;
//	imageView.animationRepeatCount = 1;
//	imageView.hidden = YES;
//	[m_pParent AddSubview:imageView withLayer: m_iLayer];
//	[self AddUIObject: imageView];	
//	
//	imageView = [ [ UIImageView alloc ] initWithFrame:CGRectMake(-40, -40, 80, 80)];
//	imageView.animationDuration = 0.5;
//	imageView.animationRepeatCount = 1;
//	imageView.hidden = YES;
//	[m_pParent AddSubview:imageView withLayer: m_iLayer];
//	[self AddUIObject: imageView];	
//	
//	m_pWorld = (b2World *)GET_POINT(@"Physics",@"m_pWorld");
	
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//------------------------------------------------------------------------------------------------------
- (void)Start
{
//	CGPoint pPos;
//	pPos.x=300; pPos.y=0;
//
//	CGAffineTransform final_transform = CGAffineTransformMakeTranslation(pPos.x, pPos.y);
//	final_transform = CGAffineTransformRotate( final_transform, 0.7 / 180.0 * 3.14 );
//
//	UIImageView* pImageView = (UIImageView*)[m_pUIObjects objectAtIndex:0];
//	pImageView.hidden = NO;
//	[pImageView setTransform:final_transform];	 
//
//	pImageView = (UIImageView*)[m_pUIObjects objectAtIndex:	1];
//	pImageView.hidden = YES;
//	pImageView.alpha = 1;
//	[pImageView setTransform:final_transform];	 
//
//	pImageView = (UIImageView*)[m_pUIObjects objectAtIndex:2];
//	pImageView.hidden = YES;
//	[pImageView setTransform:final_transform];	 
//
//	if(m_pWorld){
//	
//		// Define the dynamic body. We set its position and call the body factory.
//		b2BodyDef bodyDef;
//		bodyDef.position.Set(pPos.x, pPos.y);
//		bodyDef.angle = 0.7f;
//		
//		m_pBody = m_pWorld->CreateBody(&bodyDef);
//		
//		// Define another box shape for our dynamic body.
//		b2PolygonDef shapeDef;
//		shapeDef.SetAsBox(20.0f, 20.0f);
//		
//		// Set the box density to be non-zero, so it will be dynamic.
//		shapeDef.density = 10.2f;
//		shapeDef.restitution = 0.2;	
//		// Override the default friction.
//		shapeDef.friction = 0.8f;
//		
//		// Add the shape to the body.
//		m_pBody->CreateShape(&shapeDef);
//		
//		// Now tell the dynamic body to compute it's mass properties base
//		// on its shape.
//		m_pBody->SetMassFromShapes();
//	}
	
/*	if( bValue ) {
		[self OpenParachute];
	}
	else {
		[m_pParent PlaySound: sound_jumper_jump];
	}
*/
	
}
//------------------------------------------------------------------------------------------------------
- (void)sfWaiting {}
//------------------------------------------------------------------------------------------------------
- (void)sfMove {
	
	// Now print the position and angle of the body.
//	b2Vec2 position = m_pBody->GetPosition();
//	float32 angle = m_pBody->GetAngle();
	
	
//	UIImageView* pImageView = (UIImageView*)[m_pUIObjects objectAtIndex:0];
//
//	CGAffineTransform final_transform = CGAffineTransformMakeTranslation(position.x, position.y);
//	final_transform = CGAffineTransformRotate( final_transform, angle );
//	[pImageView setTransform:final_transform];
}
//------------------------------------------------------------------------------------------------------
@end
