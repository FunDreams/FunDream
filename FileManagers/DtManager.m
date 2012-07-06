//
//  DtManager.m
//  ProgSettingsManager
//
//  Created by svp on 01.04.10.
//  Copyright 2010 FunDreams. All rights reserved.
//

#import "DtManager.h"

@implementation CDataManager
//--------------------------------------------------------
-(CDataManager*) InitWithFileFromRes:(NSString*) sFileName
{
    self = [super init];
    if (self)
    {        
        m_sFullFileNameDropBox=[[NSString alloc] initWithString:sFileName];
        
        m_iCurReadingPos = 0;
        
        NSArray *cacheDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *cacheDirectory = [cacheDirectories objectAtIndex:0];
        NSString* FileName = [cacheDirectory stringByAppendingPathComponent:sFileName];
        m_sFullFileName=[[NSString alloc] initWithString:FileName];
        
        if (m_sFullFileName != nil)
        {
            m_pDataDmp = [[NSMutableData alloc] initWithContentsOfFile:m_sFullFileName];
            if (m_pDataDmp == nil)
            {
                m_pDataDmp = [[NSMutableData alloc] init];
                NSFileManager *fm = [NSFileManager defaultManager];
                
                [fm createFileAtPath:m_sFullFileName contents:nil attributes:nil];
            }
        }
    }
    
    return self;
}
//--------------------------------------------------------
-(CDataManager*) InitWithFileFromCash:(NSString*) sFileName
{
    self = [super init];
    if (self)
    {        
        m_sFullFileNameDropBox=[[NSString alloc] initWithString:sFileName];

        m_iCurReadingPos = 0;
        
        NSArray *cacheDirectories = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cacheDirectory = [cacheDirectories objectAtIndex:0];
        NSString* FileName = [cacheDirectory stringByAppendingPathComponent:sFileName];
        m_sFullFileName=[[NSString alloc] initWithString:FileName];
        
        if (m_sFullFileName != nil)
        {
            m_pDataDmp = [[NSMutableData alloc] initWithContentsOfFile:m_sFullFileName];
            if (m_pDataDmp == nil)
            {
                m_pDataDmp = [[NSMutableData alloc] init];
                NSFileManager *fm = [NSFileManager defaultManager];
                
                [fm createFileAtPath:m_sFullFileName contents:m_pDataDmp attributes:nil];
            }
        }
    }
    
    return self;
}
//--------------------------------------------------------
- (void) initDropBox{
    
    // Set these variables before launching the app
    NSString* appKey = @"4mrgtc1jg1k1gub";
	NSString* appSecret = @"6tyvjyni3p0zpp3";
	NSString *root = kDBRootAppFolder; // Should be set to either kDBRootAppFolder or kDBRootDropbox
	// You can determine if you have App folder access or Full Dropbox along with your consumer key/secret
	// from https://dropbox.com/developers/apps 
	
	// Look below where the DBSession is created to understand how to use DBSession in your app
	
	NSString* errorMsg = nil;
	if ([appKey rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
		errorMsg = @"Make sure you set the app key correctly in DBRouletteAppDelegate.m";
	} else if ([appSecret rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
		errorMsg = @"Make sure you set the app secret correctly in DBRouletteAppDelegate.m";
	} else if ([root length] == 0) {
		errorMsg = @"Set your root to use either App Folder of full Dropbox";
	} else {
		NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
		NSData *plistData = [NSData dataWithContentsOfFile:plistPath];
		NSDictionary *loadedPlist = 
        [NSPropertyListSerialization 
         propertyListFromData:plistData mutabilityOption:0 format:NULL errorDescription:NULL];
		NSString *scheme = [[[[loadedPlist objectForKey:@"CFBundleURLTypes"] objectAtIndex:0]objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
		if ([scheme isEqual:@"db-APP_KEY"]) {
			errorMsg = @"Set your URL scheme correctly in DBRoulette-Info.plist";
		}
	}
	
	DBSession* session = 
    [[DBSession alloc] initWithAppKey:appKey appSecret:appSecret root:root];
	session.delegate = self; // DBSessionDelegate methods allow you to handle re-authenticating
	[DBSession setSharedSession:session];
	    
	if (errorMsg != nil) {
		[[[[UIAlertView alloc]
		   initWithTitle:@"Error Configuring Session" message:errorMsg 
		   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
		  autorelease]
		 show];
	}

  //  return;
    restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    restClient.delegate = self;
    
    [restClient loadMetadata:@"/"];
    [self DownLoad];
}
//--------------------------------------------------------
-(void)Link{
    
    if (![[DBSession sharedSession] isLinked])
    [[DBSession sharedSession] link];
}
//--------------------------------------------------------
-(void)UpLoad
{    
    if(m_pMetaData==nil)return;
    
    NSString *destDir = @"/";
//    [restClient uploadFile:m_sFullFileNameDropBox toPath:destDir
//                  withParentRev:nil fromPath:m_sFullFileName];
    
    for(DBMetadata *child in m_pMetaData.contents)
    {
        NSString *folderName = [[child.path pathComponents] lastObject];
        if ([folderName isEqualToString:m_sFullFileNameDropBox]) {
            [restClient uploadFile:m_sFullFileNameDropBox toPath:destDir
                     withParentRev:child.rev fromPath:m_sFullFileName];
        }
    }
    
    [m_pMetaData release];
    m_pMetaData=nil;
    
//    [restClient moveFrom:fromPath toPath:destDir];  // Rename
//    [restClient deletePath:@"/FractalCode"];
}
//--------------------------------------------------------
-(void)DownLoad
{    
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm createFileAtPath:m_sFullFileName contents:m_pDataDmp attributes:nil];

    NSString *srcDir =[NSString stringWithFormat:@"/%@",m_sFullFileNameDropBox];
    [restClient loadFile:srcDir intoPath:m_sFullFileName];
}
//--------------------------------------------------------
- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath
              from:(NSString*)srcPath metadata:(DBMetadata*)metadata {
    
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
    [restClient loadMetadata:@"/"];
}
//--------------------------------------------------------
- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error {
    NSLog(@"File upload failed with error - %@", error);
}
//--------------------------------------------------------
- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath {
    NSLog(@"File loaded successfully to path: %@", localPath);
}
//--------------------------------------------------------
- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error {
    NSLog(@"There was an error loading the file - %@", error);
}
//--------------------------------------------------------
- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    m_pMetaData=[metadata retain];
    if (metadata.isDirectory) {
        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            NSLog(@"\t%@", file.filename);
        }
    }
}
//--------------------------------------------------------
- (void)restClient:(DBRestClient *)client
            loadMetadataFailedWithError:(NSError *)error {
    
    NSLog(@"Error loading metadata: %@", error);
}
//--------------------------------------------------------
- (void)sessionDidReceiveAuthorizationFailure:(DBSession*)session userId:(NSString *)userId {
	relinkUserId = [userId retain];
    
    [[[[UIAlertView alloc]
       initWithTitle:@"Error Configuring Session" message:@"Autorization Failure" 
       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
      autorelease]
     show];
}
//--------------------------------------------------------
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	if ([[DBSession sharedSession] handleOpenURL:url]) {
		if ([[DBSession sharedSession] isLinked]) {
		}
		return YES;
	}
	
	return NO;
}
//--------------------------------------------------------
-(bool)Save
{
    NSError* error=nil;
    BOOL bResult=[m_pDataDmp writeToFile:m_sFullFileName options:NSDataWritingAtomic error:&error];
    
    if(error != nil)
        NSLog(@"write error %@", error);

	return bResult;
}
//--------------------------------------------------------
-(bool)Load
{
    [m_pDataDmp release];
    m_pDataDmp = [[NSMutableData alloc] initWithContentsOfFile:m_sFullFileName];
    m_iCurReadingPos = 0;

    if(m_pDataDmp!=nil)return YES;
	return NO;
}
//--------------------------------------------------------
-(void) Clear
{
	[m_pDataDmp setLength:0];
	m_iCurReadingPos = 0;
}
//--------------------------------------------------------
-(void) SetPosReading:(int)iPos
{
	m_iCurReadingPos = iPos;
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
	[m_pDataDmp appendBytes:ucBuff length:[sValue length]*sizeof(unichar)];
	
	free(ucBuff);
}
//--------------------------------------------------------
-(NSString*) GetStrValue: (int) iSize;
{
	if( [m_pDataDmp length] < m_iCurReadingPos + iSize*sizeof(unichar))
		return 0;

	NSRange Range = { m_iCurReadingPos, iSize*sizeof(unichar) };
	
	unichar* ucBuff = (unichar*)calloc(iSize, sizeof(unichar));
		
	[m_pDataDmp getBytes:ucBuff range:Range];
	
	m_iCurReadingPos += iSize*sizeof(unichar);
	
	NSString *sValue = [NSString stringWithCharacters:ucBuff length:iSize];

	free(ucBuff);

	return sValue;
}
//--------------------------------------------------------
-(void) AddIntValue:(int) iValue;
{
	[m_pDataDmp appendBytes:&iValue length:sizeof(int)];
}
//--------------------------------------------------------
-(int) GetIntValue;
{
	if( [m_pDataDmp length] < m_iCurReadingPos + sizeof(int))
		return 0;
	NSRange Range = { m_iCurReadingPos, sizeof(int) };
		
	int iValue;
	[m_pDataDmp getBytes:&iValue range:Range];
	
	m_iCurReadingPos += sizeof(int);
	
	return iValue;
}
//--------------------------------------------------------
-(void) AddFloatValue:(float) fValue;
{
	[m_pDataDmp appendBytes:&fValue length:sizeof(float)];
}
//--------------------------------------------------------
-(float) GetFloatValue;
{
	if( [m_pDataDmp length] < m_iCurReadingPos + sizeof(float))
		return 0;

	NSRange Range = { m_iCurReadingPos, sizeof(float) };
	
	float fValue;
	[m_pDataDmp getBytes:&fValue range:Range];
	
	m_iCurReadingPos += sizeof(float);
	
	return fValue;
}
//--------------------------------------------------------
-(void) AddDoubleValue:(double) dValue;
{
	[m_pDataDmp appendBytes:&dValue length:sizeof(double)];
}
//--------------------------------------------------------
-(double) GetDoubleValue;
{
	if( [m_pDataDmp length] < m_iCurReadingPos + sizeof(double))
		return 0;
	
	NSRange Range = { m_iCurReadingPos, sizeof(double) };
	
	double dValue;
	[m_pDataDmp getBytes:&dValue range:Range];
	
	m_iCurReadingPos += sizeof(double);
	
	return dValue;
}
//--------------------------------------------------------
-(void) AddCharValue:(char) cValue;
{
	[m_pDataDmp appendBytes:&cValue length:sizeof(char)];
}
//--------------------------------------------------------
-(char) GetCharValue;
{
	if( [m_pDataDmp length] < m_iCurReadingPos + sizeof(char))
		return 0;
	
	NSRange Range = { m_iCurReadingPos, sizeof(char) };
	
	char cValue;
	[m_pDataDmp getBytes:&cValue range:Range];
	
	m_iCurReadingPos += sizeof(char);
	
	return cValue;
}
//--------------------------------------------------------
-(void) AddBoolValue:(BOOL) bValue;
{
	[m_pDataDmp appendBytes:&bValue length:sizeof(BOOL)];
}
//--------------------------------------------------------
-(BOOL) GetBoolValue;
{
	if([m_pDataDmp length]<m_iCurReadingPos+sizeof(BOOL))
		return FALSE;
	
	NSRange Range = {m_iCurReadingPos,sizeof(BOOL)};
	
	BOOL bValue;
	[m_pDataDmp getBytes:&bValue range:Range];
	
	m_iCurReadingPos += sizeof(BOOL);
	
	return bValue;
}
//--------------------------------------------------------
- (void)dealloc {
    [m_pMetaData release];
    [restClient release];
    
    [m_sFullFileNameDropBox release];

    [m_sFullFileName release];
	[m_pDataDmp release];
    [super dealloc];
}
@end
