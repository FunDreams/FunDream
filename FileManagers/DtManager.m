//
//  DtManager.m
//  ProgSettingsManager
//
//  Created by svp on 01.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DtManager.h"


@implementation CDataManager


//--------------------------------------------------------
+(CDataManager*) InitWithFileFromRes:(NSString*) sFileName
{
	CDataManager* pTempPlMng = [[CDataManager alloc] init];
	
	NSString* sFileNameWithoutExt = nil;
	NSString* sFileExt = nil;
	NSRange pRangeOfPoint = [sFileName rangeOfString:@"." options:NSBackwardsSearch];

	if( pRangeOfPoint.location != NSNotFound ) {
		NSRange pRangeOfName = {0, pRangeOfPoint.location};
		sFileNameWithoutExt = [NSString stringWithString:[sFileName substringWithRange:pRangeOfName]];
		NSRange pRangeOfExt = {pRangeOfPoint.location+1, [sFileName length]-pRangeOfPoint.location-1};
		sFileExt = [NSString stringWithString:[sFileName substringWithRange:pRangeOfExt]];
	}
	else {
		sFileNameWithoutExt = [NSString stringWithString:sFileName];
	}
	
	NSBundle* pBungle = [NSBundle mainBundle];
	pTempPlMng->m_sFullFileName = (NSMutableString *)[pBungle pathForResource:sFileNameWithoutExt ofType:sFileExt];

	pTempPlMng->m_iCurReadingPos = 0;
	if( pTempPlMng->m_sFullFileName != nil)
		pTempPlMng->m_pData = [NSMutableData dataWithContentsOfFile:pTempPlMng->m_sFullFileName];
	
	[pBungle dealloc];
	
	if( pTempPlMng->m_pData == nil)
	{
		[pTempPlMng dealloc];
		pTempPlMng = nil;
	}	
	return pTempPlMng;
}
//--------------------------------------------------------
-(bool) Save
{
	BOOL bResult = [m_pData writeToFile:m_sFullFileName atomically:true];
	return bResult;
}
//--------------------------------------------------------
-(void) Clear
{
	[m_pData setLength:0];
	m_iCurReadingPos = 0;
}
//--------------------------------------------------------
-(void) ResetReading
{
	m_iCurReadingPos = 0;
}

//--------------------------------------------------------
-(void) AddStrValue: (NSString*) sValue;
{
	unichar* ucBuff = (unichar*)calloc([sValue length], sizeof(unichar));

	[sValue getCharacters:ucBuff];
	[m_pData appendBytes:ucBuff length:[sValue length]*sizeof(unichar)];
	
	free(ucBuff);
}
//--------------------------------------------------------
-(NSString*) GetStrValue: (int) iSize;
{
	if( [m_pData length] < m_iCurReadingPos + iSize*sizeof(unichar))
		return 0;

	NSRange Range = { m_iCurReadingPos, iSize*sizeof(unichar) };
	
	unichar* ucBuff = (unichar*)calloc(iSize, sizeof(unichar));
		
	[m_pData getBytes:ucBuff range:Range];
	
	m_iCurReadingPos += iSize*sizeof(unichar);
	
	NSString *sValue = [NSString stringWithCharacters:ucBuff length:iSize];

	free(ucBuff);

	return sValue;
}
//--------------------------------------------------------
-(void) AddIntValue:(int) iValue;
{
	[m_pData appendBytes:&iValue length:sizeof(int)];
}
//--------------------------------------------------------
-(int) GetIntValue;
{
	if( [m_pData length] < m_iCurReadingPos + sizeof(int))
		return 0;
	NSRange Range = { m_iCurReadingPos, sizeof(int) };
		
	int iValue;
	[m_pData getBytes:&iValue range:Range];
	
	m_iCurReadingPos += sizeof(int);
	
	return iValue;
}
//--------------------------------------------------------
-(void) AddFloatValue:(float) fValue;
{
	[m_pData appendBytes:&fValue length:sizeof(float)];
}
//--------------------------------------------------------
-(float) GetFloatValue;
{
	if( [m_pData length] < m_iCurReadingPos + sizeof(float))
		return 0;

	NSRange Range = { m_iCurReadingPos, sizeof(float) };
	
	float fValue;
	[m_pData getBytes:&fValue range:Range];
	
	m_iCurReadingPos += sizeof(float);
	
	return fValue;
}
//--------------------------------------------------------
-(void) AddDoubleValue:(double) dValue;
{
	[m_pData appendBytes:&dValue length:sizeof(double)];
}
//--------------------------------------------------------
-(double) GetDoubleValue;
{
	if( [m_pData length] < m_iCurReadingPos + sizeof(double))
		return 0;
	
	NSRange Range = { m_iCurReadingPos, sizeof(double) };
	
	double dValue;
	[m_pData getBytes:&dValue range:Range];
	
	m_iCurReadingPos += sizeof(double);
	
	return dValue;
}
//--------------------------------------------------------
-(void) AddCharValue:(char) cValue;
{
	[m_pData appendBytes:&cValue length:sizeof(char)];
}
//--------------------------------------------------------
-(char) GetCharValue;
{
	if( [m_pData length] < m_iCurReadingPos + sizeof(char))
		return 0;
	
	NSRange Range = { m_iCurReadingPos, sizeof(char) };
	
	char cValue;
	[m_pData getBytes:&cValue range:Range];
	
	m_iCurReadingPos += sizeof(char);
	
	return cValue;
}
//--------------------------------------------------------
-(void) AddBoolValue:(BOOL) bValue;
{
	[m_pData appendBytes:&bValue length:sizeof(BOOL)];
}
//--------------------------------------------------------
-(BOOL) GetBoolValue;
{
	if( [m_pData length] < m_iCurReadingPos + sizeof(BOOL))
		return FALSE;
	
	NSRange Range = { m_iCurReadingPos, sizeof(BOOL) };
	
	BOOL bValue;
	[m_pData getBytes:&bValue range:Range];
	
	m_iCurReadingPos += sizeof(BOOL);
	
	return bValue;
}
//--------------------------------------------------------
- (void)dealloc {
    [m_sFullFileName dealloc];
	[m_pData dealloc];
    [super dealloc];
}
@end
