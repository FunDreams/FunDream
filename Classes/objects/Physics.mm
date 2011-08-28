//
//  Parachute.m
//  Engine
//
//  Created by svp on 17.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Physics.h"

@implementation CPhysics
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName {
	[super Init:Parent WithName:strName];
	
	// Define the size of the world. Simulation will still work
	// if bodies reach the end of the world, but it will be slower.
	b2AABB worldAABB;
	worldAABB.lowerBound.Set(-300.0f, -300.0f);
	worldAABB.upperBound.Set(1800.0f, 1600.0f);
	
	// Define the gravity vector.
	b2Vec2 gravity(0.0f, 55.0f);
	
	// Do we want to let bodies sleep?
	bool doSleep = true;
	
	// Construct a world object, which will hold and simulate the rigid bodies.
	m_pWorld = new b2World(worldAABB, gravity, doSleep);
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 500);
	b2Body* groundBody = m_pWorld->CreateBody(&groundBodyDef);
	b2PolygonDef groundShapeDef;
	groundShapeDef.SetAsBox(4000, 10.0f);
	groundBody->CreateShape(&groundShapeDef);
	
//	m_eState = fasWaiting;

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//------------------------------------------------------------------------------------------------------
- (void)Start{}
//------------------------------------------------------------------------------------------------------
- (void)sfWaiting {}
//------------------------------------------------------------------------------------------------------
- (void)sfMove {
	
	// Prepare for simulation. Typically we use a time step of 1/60 of a
	// second (60Hz) and 10 iterations. This provides a high quality simulation
	// in most game scenarios.
	int32 iterations = 5;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	m_pWorld->Step(m_fDeltaTime, iterations);
}

@end
