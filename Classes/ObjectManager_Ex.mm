//
//  ObjectManager.m
//  Engine
//
//  Created by svp on 17.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "Box2D.h"
#import "Physics.h"
#import "Mega_tree.h"

@implementation CObjectManager
@synthesize m_bReserv,m_pObjectList;
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent {
		
    fTimeOneSecondUpdate=0;
	m_bGlobalPause=false;

	m_pParent = Parent;
	m_pObjectList = [[NSMutableArray alloc] init];
	m_pObjectReserv = [[NSMutableDictionary alloc] init];
	m_pGroups = [[NSMutableDictionary alloc] init];
	m_pObjectAddToTouch = [[NSMutableDictionary alloc] init];
	m_pAllObjects = [[NSMutableDictionary alloc] init];
	
	pMustDelKeys = [[NSMutableArray alloc] init];
	pMusAddKeys = [[NSMutableArray alloc] init];
    
    pMegaTree = [[Mega_tree alloc] init];
    
	m_pAIObj = nil;

	m_bReserv=NO;
	
	pDrawArray=[[NSMutableArray alloc] init];
	pLayers=[[NSMutableArray alloc] init];
    m_pObjectTouches = [[NSMutableArray alloc] init];

	for (int i=0; i<layerTemplet+1; i++) {
		
		NSMutableDictionary *pOneLayer = [[NSMutableDictionary alloc] init];
		[pLayers addObject:pOneLayer];
        
        NSMutableDictionary *pOneLayerTouch = [[NSMutableDictionary alloc] init];
		[m_pObjectTouches addObject:pOneLayerTouch];
	}

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateObjects{
	
    [pMegaTree SynhData];
    
	if([m_pObjectAddToTouch count])
	{
		NSEnumerator *enumerator = [m_pObjectAddToTouch objectEnumerator];
		GObject *pObject;
		
		while ((pObject = [enumerator nextObject])) {
			
			if(pObject->m_strName!=nil){
				if (pObject->m_bTouch==YES)
					[[m_pObjectTouches objectAtIndex:pObject->m_iLayerTouch] setObject:pObject forKey:pObject->m_strName];
				else [[m_pObjectTouches objectAtIndex:pObject->m_iLayerTouch] removeObjectForKey:pObject->m_strName];
			}
		}
		
		[m_pObjectAddToTouch removeAllObjects];
	}
	
	int iCount = [pMustDelKeys count];
	for (int i=0; i<iCount; i++) {
		
		GObject * TmpOb=[pMustDelKeys objectAtIndex:0];
		[pMustDelKeys removeObjectAtIndex:0];
		
		NSMutableDictionary *Dic = [m_pObjectList objectAtIndex:TmpOb->m_iDeep];
		
		if(TmpOb->m_strName!=nil){
			NSString *NameClass= NSStringFromClass([TmpOb class]);
			NSMutableArray *pArray = [m_pObjectReserv objectForKey:NameClass];
			[pArray addObject:TmpOb];
			
			[Dic removeObjectForKey:TmpOb->m_strName];
			[m_pAllObjects removeObjectForKey:TmpOb->m_strName];
			[TmpOb->m_strName release];
			TmpOb->m_strName = nil;
			
			[self RemoveFromGroup:TmpOb->m_strGroup Object:TmpOb];
		}
	}
	
	int iCount2 = [pMusAddKeys count];
	for (int i=0; i<iCount2; i++) {
		
		GObject * TmpOb=[pMusAddKeys objectAtIndex:0];
		[pMusAddKeys removeObjectAtIndex:0];
		
		NSMutableDictionary *Dic = nil;
		
		if([m_pObjectList count]<TmpOb->m_iDeep+1){
			Dic = [[NSMutableDictionary alloc] init];
			[m_pObjectList addObject:Dic];
		}
		else Dic=[m_pObjectList objectAtIndex:TmpOb->m_iDeep];
		
		if(TmpOb->m_strName!=nil)		
			[Dic setObject:TmpOb forKey:TmpOb->m_strName];
	}	
    
    if(iCount2>0 || iCount>0){m_bNeedUppdate=YES;}
}
//------------------------------------------------------------------------------------------------------
- (void)SelfMovePaused:(id)pDeltaTime{
	
    NSNumber *NumDelta=pDeltaTime;
    m_fDeltaTime=[NumDelta doubleValue];
    
	NSEnumerator *enumeratorProc;
    
	for (int i=0; i<[m_pObjectList count]; i++) {
        
		NSMutableDictionary *Dic = [m_pObjectList objectAtIndex:i];
        
		NSEnumerator *enumeratorObjects = [Dic objectEnumerator];
		GObject *pObject;
        
		while ((pObject = [enumeratorObjects nextObject])) {
            
            if (pObject->m_bNonStop) {

                pObject->m_fDeltaTime = m_fDeltaTime;  
                
                Processor_ex *pProc_ex;
                enumeratorProc = [pObject->m_pProcessor_ex objectEnumerator];
                while ((pProc_ex = [enumeratorProc nextObject]))
                {
                    [pObject performSelector:pProc_ex->m_CurStage->m_selector withObject:pProc_ex];
                }
                
                [pObject->m_pProcessor_ex SynhData];

            }
		}
	}

	[self UpdateObjects];
	
	[m_pParent.glView drawView];
}
//------------------------------------------------------------------------------------------------------
- (void)SelfMoveNormal:(id)pDeltaTime{

    NSNumber *NumDelta=pDeltaTime;
    m_fDeltaTime=[NumDelta doubleValue];

	NSEnumerator *enumeratorProc;

	for (int i=0; i<[m_pObjectList count]; i++) {

		NSMutableDictionary *Dic = [m_pObjectList objectAtIndex:i];

		NSEnumerator *enumeratorObjects = [Dic objectEnumerator];
		GObject *pObject;

		while ((pObject = [enumeratorObjects nextObject])) {
            
			pObject->m_fDeltaTime = m_fDeltaTime;
            
            Processor_ex *pProc_ex;
            enumeratorProc = [pObject->m_pProcessor_ex objectEnumerator];
			while ((pProc_ex = [enumeratorProc nextObject]))
            {
                [pObject performSelector:pProc_ex->m_CurStage->m_selector withObject:pProc_ex];
            }
            
            [pObject->m_pProcessor_ex SynhData];

		}
	}

	[self UpdateObjects];

	[m_pParent.glView drawView];
}
//------------------------------------------------------------------------------------------------------
- (void)Update{
	
	[pDrawArray removeAllObjects];
	
	for (int i=0; i<layerTemplet+1; i++) {
		
		NSMutableDictionary *pOneLayer = [pLayers objectAtIndex:i];
		
		NSEnumerator *enumerator = [pOneLayer objectEnumerator];
		GObject *pObject;
		
		while ((pObject = [enumerator nextObject])) {

			if(pObject->m_bHiden==NO)
				[pDrawArray addObject:pObject];
		}
	}
}
//------------------------------------------------------------------------------------------------------
- (void)drawView:(GLView*)view
{
	glClear(GL_COLOR_BUFFER_BIT);

	fTimeOneSecondUpdate+=m_fDeltaTime;
	
	if(fTimeOneSecondUpdate>=1.0f){
		
		fTimeOneSecondUpdate=0;
		[self Update];
		
	} else if (m_bNeedUppdate==YES) {
		m_bNeedUppdate=NO;
		[self Update];
	}
	
//FPS----------------------------------------------------------------------------
#ifdef FPS
	static int AllFrame=0;
	static float fTimeOneSecond=0;
	static int iNumFrame=0;
	static int AllCount=0; 
	iNumFrame++;
	fTimeOneSecond+=m_fDeltaTime;

	if(fTimeOneSecond>=1){
		
		AllFrame+=iNumFrame;
		AllCount++;
		
		NSLog(@"FPS:%d===%d",iNumFrame,AllFrame/AllCount);

		fTimeOneSecond=0;
		iNumFrame=0;		
	}
#endif
//отрисовка объектов---------------------------------------------------------------

	glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY); 

	int ObjectCountDraw=[pDrawArray count];  
	
	for (int i=0; i<ObjectCountDraw; i++) {
		
		glLoadIdentity();
			
		GObject *pTmpOb=[pDrawArray objectAtIndex:i];
		[[pDrawArray objectAtIndex:i] performSelector:pTmpOb->m_sDraw];
	}
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {
	
	for (int i=0; i<[m_pObjectList count]; i++) {
		
		NSMutableDictionary *Dic = [m_pObjectList objectAtIndex:i];
		NSEnumerator *enumeratorObjects = [Dic objectEnumerator];
		GObject *pObject;
		
		while ((pObject = [enumeratorObjects nextObject]))[pObject release];
		
		[Dic release];
	}
	
	NSEnumerator *enumerator = [m_pObjectReserv objectEnumerator];
	NSMutableArray *pTmpArray;
	while ((pTmpArray = [enumerator nextObject])) {
		
		for (int i=0; i< [pTmpArray count]; i++) {
			GObject *pTmpObject = [pTmpArray objectAtIndex:i];
			
			[pTmpObject release];
		}
		[pTmpArray release];
	}
		
	[m_pObjectList release];
	[m_pObjectReserv release];
	[m_pObjectAddToTouch release];
	
	[m_pAIObj release];
	[pMustDelKeys release];
	[pMusAddKeys release];
	
    for(NSMutableDictionary *pDic in pLayers){[pDic release];}
    for(NSMutableDictionary *pDic in m_pObjectTouches){[pDic release];}
    
    [pLayers release];

	[m_pAllObjects release];
	
	enumerator = [m_pGroups objectEnumerator];
	while ((pTmpArray = [enumerator nextObject]))[pTmpArray release];
	[m_pGroups release];
    
    [pMegaTree release];

	[super dealloc];
}
//------------------------------------------------------------------------------------------------------
- (GObject *)GetFreeObjectByClass:(NSString*)NameClass{
		
	NSEnumerator *enumerator = [m_pObjectList objectEnumerator];
	GObject *pObject;
	
	while ((pObject = [enumerator nextObject])) {			
		
		Class    clstmp     = [pObject class];
		NSString *pNameClass=NSStringFromClass(clstmp);

		if ([NameClass isEqualToString:pNameClass]) {
			return pObject;
		}
	}
	
	return nil;
}
//------------------------------------------------------------------------------------------------------
- (GObject *)GetObjectByName:(NSString*)NameObject{
	
	GObject *pObject = [m_pAllObjects objectForKey:NameObject];
	return pObject;

	for (int i=0; i<[m_pObjectList count]; i++) {
		
		NSMutableDictionary *Dic = [m_pObjectList objectAtIndex:i];
		GObject * TmpOb=[Dic objectForKey:NameObject];
		
		if(TmpOb!=nil)return TmpOb;
	}
	return nil;
}
//------------------------------------------------------------------------------------------------------
- (NSString *)GetNameObject:(NSString*)NameObject{

repeate:
	id pTmpOb=[self GetObjectByName:NameObject];
	
	if(pTmpOb==nil)return NameObject;
	else {
		NameObject=[NSMutableString stringWithFormat:@"%@%d",NameObject,RND%10000];
		goto repeate;
	}

	return nil;
}	
//------------------------------------------------------------------------------------------------------
- (id)DestroyObject:(GObject *)pObject{
		
	[pMustDelKeys addObject:pObject];
	pObject->m_bDeleted=YES;
	
	[pObject DeleteFromDraw];
	
	[pObject Destroy];

	return pObject;
}
//------------------------------------------------------------------------------------------------------
- (id)CreateNewObject:(NSString *)NameClass WithNameObject:(NSString *)NameObjectTmp 
           WithParams:(NSArray *)Parametrs{

	NSString *pNameObject=[self GetNameObject:NameObjectTmp];

	Class  cls = NSClassFromString ( NameClass );

	if(cls!=nil){
		
		GObject *pObject=nil;
		
		NSMutableArray *pArray = [m_pObjectReserv objectForKey:NameClass];
		
		if(pArray==nil){
			pArray=[[NSMutableArray alloc] init];
			[m_pObjectReserv setObject:pArray forKey:NameClass];
		}

		if(m_bReserv==YES) {
			
			pObject = [[cls alloc] Init:m_pParent WithName:pNameObject];
			[pObject->m_strName release];
			pObject->m_strName=nil;
			pObject->m_bDeleted=YES;
			
			[pArray addObject:pObject];
			
		}
		else {
			
			if ([pArray count]>0) {
				pObject = [pArray objectAtIndex:0];
				[pArray removeObjectAtIndex:0];

				pObject->m_strName = [[NSMutableString alloc] initWithString:pNameObject];
			}
			else pObject = [[cls alloc] Init:m_pParent WithName:pNameObject];

			pObject->m_bDeleted=NO;

			[self SetParams:pObject WithParams:Parametrs];

			if(pObject->m_pOwner!=nil)
				pObject->m_iDeep=pObject->m_pOwner->m_iDeep+1;

			[pMusAddKeys addObject:pObject];
			[pObject AddToDraw];
			
			[m_pAllObjects setObject:pObject forKey:pObject->m_strName];
            [pObject Start];
		}
		
		return pObject;
	}
	else return nil;
}
//------------------------------------------------------------------------------------------------------
- (void)SetParams:(GObject *)pTmpOb WithParams:(NSArray *)Parametrs{
	
	for (int i=0; i<[Parametrs count]; i++) {
		
		UniCell* pParams = (UniCell*)[Parametrs objectAtIndex:i];
        
 //       if(pParams->mpName==@"Command"){}
   //     else{
            NSString *TmpStr=[NSString stringWithFormat:@"%@%@",pTmpOb->m_strName,pParams->mpName];
            pParams->mpName=[NSString stringWithString:TmpStr];
            [pMegaTree CopyCell:pParams];
  //      }
	}
    
    [pTmpOb Update];
}
//------------------------------------------------------------------------------------------------------
- (void)AddToGroup:(NSString*)NameGroup Object:(GObject *)pObject{
	
	NSMutableArray *pGroup = [m_pGroups objectForKey:NameGroup];
	
	if(pGroup==nil){
		
		pGroup = [[NSMutableArray alloc] init];
		[m_pGroups setObject:pGroup forKey:NameGroup];
	}
	
	for (int i=0; i<[pGroup count]; i++)
		if (pObject==[pGroup objectAtIndex:i])return;
	
	pObject->m_strGroup= [NSString stringWithString:NameGroup];
	[pGroup addObject:pObject];
}
//------------------------------------------------------------------------------------------------------
- (void)RemoveFromGroup:(NSString*)NameGroup Object:(GObject *)pObject{
	
	if(NameGroup==nil)return;
	
	NSMutableArray *pGroup = [m_pGroups objectForKey:NameGroup];
	
	if(pGroup){
		
		for (int i=0; i<[pGroup count]; i++)
			if (pObject==[pGroup objectAtIndex:i]){
				
				[pGroup removeObjectAtIndex:i];
				pObject->m_strGroup=nil;
				return;
			}
	}
}
//------------------------------------------------------------------------------------------------------
- (NSMutableArray *)GetGroup:(NSString*)NameGroup{
	
	if(NameGroup==nil)return nil;
	return [m_pGroups objectForKey:NameGroup];
}
//------------------------------------------------------------------------------------------------------
- (void)CreateObjects{

	[self CreateNewObject:@"CGameLogic" WithNameObject:@"AIObject" WithParams:nil];
	
	[self Update];
}
//------------------------------------------------------------------------------------------------------
@end