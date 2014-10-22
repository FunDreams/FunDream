//
//  PlManager.m
//  ProgSettingsManager
//
//  Created by svp on 01.04.10.
//  Copyright 2010 FunDreams. All rights reserved.
//

#import "PlManager.h"

@implementation CPlManager
//--------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self)
    {
        m_pDictionary = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}
//--------------------------------------------------------
-(void)SetKeyStrValue: (NSString*)sKey withValue:(NSString*) sValue;
{
	[m_pDictionary setObject:sValue forKey:sKey];
}
//--------------------------------------------------------
-(NSString*) GetKeyStrValue: (NSString*) sKey;
{
	NSString* pNumber = [m_pDictionary objectForKey:sKey];
	return pNumber;
}
//--------------------------------------------------------
-(void) SetKeyIntValue: (NSString*)sKey withValue:(int) iValue;
{
	[m_pDictionary setInteger:iValue forKey:sKey];
}
//--------------------------------------------------------
-(int) GetKeyIntValue: (NSString*) sKey;
{
	int pNumber = [m_pDictionary integerForKey:sKey];
	return pNumber;
}
//--------------------------------------------------------
-(void) SetKeyFloatValue: (NSString*)sKey withValue:(float) fValue;
{
	[m_pDictionary setFloat: fValue forKey:sKey];
}
//--------------------------------------------------------
-(float) GetKeyFloatValue: (NSString*) sKey;
{
	float pNumber = [m_pDictionary floatForKey:sKey];
	return pNumber;
}
//--------------------------------------------------------
-(void) SetKeyDoubleValue: (NSString*)sKey withValue:(double) dValue;
{
	[m_pDictionary setDouble:dValue forKey:sKey];
}
//--------------------------------------------------------
-(double) GetKeyDoubleValue: (NSString*) sKey;
{
	float pNumber = [m_pDictionary doubleForKey:sKey];
	return pNumber;
}
//--------------------------------------------------------
-(void) SetKeyBoolValue: (NSString*)sKey withValue:(BOOL) bValue;
{
	[m_pDictionary setBool:bValue forKey:sKey];
}
//--------------------------------------------------------
-(BOOL) GetKeyBoolValue: (NSString*) sKey;
{
	bool pNumber = [m_pDictionary boolForKey:sKey];
	return pNumber;
}
//--------------------------------------------------------
- (void)dealloc
{ 
    [m_pDictionary release];
    [super dealloc];
}

@end
