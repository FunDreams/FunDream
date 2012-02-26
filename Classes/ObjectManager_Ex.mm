//
//  ObjectManager.m
//  Engine
//
//  Created by svp on 17.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "Mega_tree.h"

@implementation CObjectManager

@synthesize m_bReserv,m_pObjectList;

//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent
{
    self = [super init];
    if (self)
    {
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
        
        for (int i=0; i<layerTemplet+1; i++) {            
            NSMutableDictionary *pOneLayer = [[NSMutableDictionary alloc] init];
            [pLayers addObject:pOneLayer];
            
        }

        m_pObjectTouches = [[NSMutableArray alloc] init];
        
        for (int i=0; i<layerTouch_3+1; i++) {
                        
            NSMutableDictionary *pOneLayerTouch = [[NSMutableDictionary alloc] init];
            [m_pObjectTouches addObject:pOneLayerTouch];
        }
        
        return self;

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
			
			[self RemoveFromGroups:TmpOb->m_Groups Object:TmpOb];
		}
	}
	
	int iCount2 = [pMusAddKeys count];
	for (int i=0; i<iCount2; i++) {
		
		GObject * TmpOb=[pMusAddKeys objectAtIndex:0];
		[pMusAddKeys removeObjectAtIndex:0];
		
		NSMutableDictionary *Dic = nil;
		
		if ([m_pObjectList count]<TmpOb->m_iDeep+1)
        {
			Dic = [[NSMutableDictionary alloc] init];
			[m_pObjectList addObject:Dic];
    //        [Dic release];
		}
		else
        {
            Dic = [m_pObjectList objectAtIndex:TmpOb->m_iDeep];
		}
        
		if (TmpOb->m_strName!=nil)		
			[Dic setObject:TmpOb forKey:TmpOb->m_strName];
	}	
    
    if (iCount2>0 || iCount>0)
        m_bNeedUppdate=YES;
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
                
                if(pObject->m_pProcessor_ex->m_bNotSyn)[pObject->m_pProcessor_ex SynhData];
                if(pObject->m_Groups->m_bNotSyn)[pObject->m_Groups SynhData];
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
                [pObject performSelector:pProc_ex->m_CurStage->m_selector withObject:pProc_ex];
            
            if(pObject->m_pProcessor_ex->m_bNotSyn)[pObject->m_pProcessor_ex SynhData];
            if(pObject->m_Groups->m_bNotSyn)[pObject->m_Groups SynhData];
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
		
	}
    else if (m_bNeedUppdate==YES) {
        
        fTimeOneSecondUpdate=0;
		m_bNeedUppdate=NO;
		[self Update];
	}

//отрисовка объектов---------------------------------------------------------------
	glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
    
	int ObjectCountDraw=[pDrawArray count];  

    
    if(fCurrentAngleRotateOffset!=fAngleRotateOffset){
        
        fCurrentAngleRotateOffset=fAngleRotateOffset;
        
        if(fCurrentAngleRotateOffset>=fAngleRotateOffset){
            
            fCurrentAngleRotateOffset=fAngleRotateOffset;
        }

        if(fAngleRotateOffset>fCurrentAngleRotateOffset){
            
            fCurrentAngleRotateOffset+=m_fDeltaTime*1000;
            
            if(fCurrentAngleRotateOffset>=fAngleRotateOffset){
                
                fCurrentAngleRotateOffset=fAngleRotateOffset;
            }
        }
        else{
            
            fCurrentAngleRotateOffset-=m_fDeltaTime*1000;
            
            if(fCurrentAngleRotateOffset<=fAngleRotateOffset){
                
                fCurrentAngleRotateOffset=fAngleRotateOffset;
            }
        }
    }
    
   if(m_pParent->previousOrientation==UIInterfaceOrientationLandscapeRight || 
            m_pParent->previousOrientation==UIInterfaceOrientationLandscapeLeft)
   {
        for (int i=0; i<ObjectCountDraw; i++) {

            glLoadIdentity();
            glRotatef(fCurrentAngleRotateOffset, 0, 0, 1);

            GObject *pTmpOb=[pDrawArray objectAtIndex:i];
            [[pDrawArray objectAtIndex:i] performSelector:pTmpOb->m_sDraw];
        }
    }
    else
    {
        for (int i=0; i<ObjectCountDraw; i++) {

            glLoadIdentity();

            GObject *pTmpOb=[pDrawArray objectAtIndex:i];
            [[pDrawArray objectAtIndex:i] performSelector:pTmpOb->m_sDraw];
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc
{		
	[m_pObjectList release];
	[m_pObjectReserv release];
	[m_pObjectAddToTouch release];
	
	[m_pAIObj release];
	[pMustDelKeys release];
	[pMusAddKeys release];
	
    [m_pObjectTouches release];
    
    [pLayers release];

	[m_pAllObjects release];
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

    NSString* NameObjectTmp=[NSString stringWithString:NameObject];
    
    int iStartIndex=0;
repeate:
	id pTmpOb=[self GetObjectByName:NameObjectTmp];
	
	if(pTmpOb==nil)return NameObjectTmp;
	else {
		NameObjectTmp=[NSMutableString stringWithFormat:@"%@%d",NameObject,iStartIndex];
        iStartIndex++;
		goto repeate;
	}

	return nil;
}	
//------------------------------------------------------------------------------------------------------
- (id)DestroyObject:(GObject *)pObject{

    if(pObject->m_bDeleted==NO){
        [pMustDelKeys addObject:pObject];
        pObject->m_bDeleted=YES;

        [pObject DeleteFromDraw];
        [pObject Destroy];
    }
    
	return pObject;
}
//------------------------------------------------------------------------------------------------------
-(void) CreateNewObject:(NSString*)className withName:(NSString*)objectName objects: (id)firstObj, ... 
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    va_list args;
    va_start(args, firstObj);
    for (id arg = firstObj; arg != nil; arg = va_arg(args, id))
    {
        [array addObject:arg];
    }
    va_end(args);
    
    [self CreateNewObject:className WithNameObject:objectName WithParams:array];
    [array release];
}
//------------------------------------------------------------------------------------------------------
- (id)CreateNewObject:(NSString *)NameClass WithNameObject:(NSString *)NameObjectTmp
           WithParams:(NSArray *)Parametrs
{
    NSString *pNameObject=[self GetNameObject:NameObjectTmp];
	Class cls = NSClassFromString(NameClass);
	if (cls != nil)
    {
		NSMutableArray *pArray = [m_pObjectReserv objectForKey:NameClass];
		if (pArray==nil)
        {
            pArray=[[NSMutableArray alloc] init];
//			pArray =[[[NSMutableArray alloc] init] autorelease];
			[m_pObjectReserv setObject:pArray forKey:NameClass];
		}

		if (m_bReserv)
        {
			GObject *pObject = [[cls alloc] Init:m_pParent WithName:pNameObject];
			[pObject->m_strName release];
			pObject->m_strName=nil;
			pObject->m_bDeleted=YES;
            
			[pArray addObject:pObject];
            return pObject;
		}

        GObject *pObject = nil;
        if ([pArray count]>0)
        {
            pObject = [pArray objectAtIndex:0];
            pObject->m_strName = [[NSMutableString alloc] initWithString:pNameObject];
            
       //     [[pObject retain] autorelease];
            [pArray removeObjectAtIndex:0];
        }
        else
        {
            pObject = [[cls alloc] Init:m_pParent WithName:pNameObject];
        }

        pObject->m_bDeleted=NO;
        
        [pObject SetDefault];
        
        [pObject LinkValues];

        [self SetParams:pObject WithParams:Parametrs];
        
        if (pObject->m_pOwner!=nil)
            pObject->m_iDeep=pObject->m_pOwner->m_iDeep+1;

        [pMusAddKeys addObject:pObject];
        [m_pAllObjects setObject:pObject forKey:pObject->m_strName];
        
        [pObject Start];
        
        [pObject AddToDraw];        
        
        return pObject;
	}
	
    return nil;
}
//------------------------------------------------------------------------------------------------------
- (void)SetParams:(GObject *)pTmpOb WithParams:(NSArray *)Parametrs{
	
    if(pTmpOb==nil)return;

	for (int i=0; i<[Parametrs count]; i++) {
		
		UniCell* pParams = (UniCell*)[Parametrs objectAtIndex:i];
        
 //       if([pParams->mpName isEqualToString:@"Command"]){}
   //     else{
            NSString *TmpStr=[NSString stringWithFormat:@"%@%@",pTmpOb->m_strName,pParams->mpName];
            pParams->mpName=[NSString stringWithString:TmpStr];
            [pMegaTree CopyCell:pParams];
  //      }
	}
    
    [pTmpOb Update];
}
//------------------------------------------------------------------------------------------------------
- (void)AddToGroup:(NSString*)NameGroup Object:(GObject *)pObject
{	
    if (pObject==nil)
        return;
    
	NSMutableArray *pGroup = [m_pGroups objectForKey:NameGroup];
	if (pGroup==nil)
    {
		pGroup = [[NSMutableArray alloc] init];
		[m_pGroups setObject:pGroup forKey:NameGroup];
  //      [pGroup release];
	}
	
    NSString *PtmpOb=[pObject->m_Groups objectForKey:NameGroup];
    if (PtmpOb!=nil)return;
	
	NSString *pNameGroup = [NSString stringWithString:NameGroup];
    [pObject->m_Groups setObject_Ex:pNameGroup forKey:pNameGroup];
	[pGroup addObject:pObject];
}
//------------------------------------------------------------------------------------------------------
- (void)RemoveFromGroups:(Dictionary_Ex *)NamesGroup Object:(GObject *)pObject{

    if(pObject==nil)return;

	for (NSString *Pname in NamesGroup->pDic) {
        
        NSMutableArray *pGroup = [m_pGroups objectForKey:Pname];

        if(pGroup){
            
            for (int i=0; i<[pGroup count]; i++)
                if (pObject==[pGroup objectAtIndex:i]){
                    
                    [pGroup removeObjectAtIndex:i];
                    
                    NSString *PtmpOb=[pObject->m_Groups objectForKey:Pname];
                    [pObject->m_Groups removeObjectForKey_Ex:PtmpOb];
                    
                    break;
                }
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)RemoveFromGroup:(NSString*)NameGroup Object:(GObject *)pObject{
	
	if(NameGroup==nil)return;
	
	NSMutableArray *pGroup = [m_pGroups objectForKey:NameGroup];
	
	if(pGroup){
		
		for (int i=0; i<[pGroup count]; i++)
			if (pObject==[pGroup objectAtIndex:i]){
				
				[pGroup removeObjectAtIndex:i];
                
                NSString *PtmpOb=[pObject->m_Groups objectForKey:NameGroup];
                [pObject->m_Groups removeObjectForKey_Ex:PtmpOb];

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
