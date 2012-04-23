//
//  ObjectManager.m
//  Engine
//
//  Created by svp on 17.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "Mega_tree.h"
#import "ObjectManager_Ex.h"
#import "Dictionary_Ex.h"

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
        m_pGroups = [[CGroups alloc] init];
        m_pObjectAddToTouch = [[NSMutableDictionary alloc] init];
        m_pAllObjects = [[NSMutableDictionary alloc] init];
        
        pMustDelKeys = [[NSMutableArray alloc] init];
        pMusAddKeys = [[NSMutableArray alloc] init];
        
        pMegaTree = [[Mega_tree alloc] init];
        
        m_pAIObj = nil;
        
        m_bReserv=NO;
        
        pLayers=[[NSMutableArray alloc] init];
        
        for (int i=0; i<layerTemplet+1; i++) {            
            Dictionary_Ex *pOneLayer = [[Dictionary_Ex alloc] init];
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
	    
	if([m_pObjectAddToTouch count])
	{
		NSEnumerator *enumerator = [m_pObjectAddToTouch objectEnumerator];
		GObject *pObject;
		
		while ((pObject = [enumerator nextObject])) {
			
			if(pObject->m_strName!=nil){
				if (pObject->m_bTouch==YES)
					[[m_pObjectTouches objectAtIndex:pObject->m_iLayerTouch] 
                     setObject:pObject forKey:pObject->m_strName];
                
				else [[m_pObjectTouches objectAtIndex:pObject->m_iLayerTouch] 
                      removeObjectForKey:pObject->m_strName];
			}
		}

		[m_pObjectAddToTouch removeAllObjects];
	}
	
	int iCount = [pMustDelKeys count];//удаление объктов
	for (int i=0; i<iCount; i++) {

		GObject * TmpOb=[pMustDelKeys objectAtIndex:0];
		[pMustDelKeys removeObjectAtIndex:0];

        [TmpOb DeleteFromProc];
        [self RemoveFromGroups:TmpOb];
	}
	
	int iCount2 = [pMusAddKeys count];//добавление объектов
	for (int i=0; i<iCount2; i++) {
		
		GObject * TmpOb=[pMusAddKeys objectAtIndex:0];
		[pMusAddKeys removeObjectAtIndex:0];
		
        [TmpOb AddToProc];
	}    
/////синхронизация======================================================================================   
    
    int CountLayer=[pLayers count];
    for (int i=0; i<CountLayer; i++) {
        
        Dictionary_Ex *pDic_ex=[pLayers objectAtIndex:i];
        [pDic_ex SynhData];
    }
    
    [pMegaTree SynhData];
    [m_pGroups SynhData];
    
    for (int i=0; i<[m_pObjectList count]; i++) {
        
		Dictionary_Ex *Dic = [m_pObjectList objectAtIndex:i];
        [Dic SynhData];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SelfMovePaused:(id)pDeltaTime{
    
    NSNumber *NumDelta=pDeltaTime;
    m_fDeltaTime=[NumDelta doubleValue];
    
	NSEnumerator *enumeratorProc;
    
	for (int i=0; i<[m_pObjectList count]; i++) {
        
		Dictionary_Ex *Dic = [m_pObjectList objectAtIndex:i];
        
		NSEnumerator *enumeratorObjects = [Dic->pDic objectEnumerator];
		GObject *pObject;
        
		while ((pObject = [enumeratorObjects nextObject])) {
            
            if (pObject->m_bNonStop) {

                pObject->m_fDeltaTime = m_fDeltaTime;  
                
                Processor_ex *pProc_ex;
                enumeratorProc = [pObject->m_pProcessor_ex->pDic objectEnumerator];
                while ((pProc_ex = [enumeratorProc nextObject]))
                {
                    [pObject performSelector:pProc_ex->m_CurStage->m_selector withObject:pProc_ex];
                }                
            }
		}
	}
	
	[m_pParent.glView drawView];
}
//------------------------------------------------------------------------------------------------------
- (void)SelfMoveNormal:(id)pDeltaTime{

    NSNumber *NumDelta=pDeltaTime;
    m_fDeltaTime=[NumDelta doubleValue];

	NSEnumerator *enumeratorProc;

	for (int i=0; i<[m_pObjectList count]; i++) {

		Dictionary_Ex *Dic = [m_pObjectList objectAtIndex:i];

		NSEnumerator *enumeratorObjects = [Dic->pDic objectEnumerator];
		GObject *pObject;

		while ((pObject = [enumeratorObjects nextObject])) {
            
			pObject->m_fDeltaTime = m_fDeltaTime;
            
            Processor_ex *pProc_ex;
            enumeratorProc = [pObject->m_pProcessor_ex->pDic objectEnumerator];
			while ((pProc_ex = [enumeratorProc nextObject]))
                [pObject performSelector:pProc_ex->m_CurStage->m_selector withObject:pProc_ex];
		}
	}

	[m_pParent.glView drawView];
}
//------------------------------------------------------------------------------------------------------
- (void)drawView:(GLView*)view
{
	glClear(GL_COLOR_BUFFER_BIT);

//отрисовка объектов---------------------------------------------------------------
	glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
    
	int CountLayer=[pLayers count];
    
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
    
    for (int i=0; i<CountLayer; i++) {
       
       Dictionary_Ex *pDic_Ex=[pLayers objectAtIndex:i];
       NSEnumerator *pEnumerator=[pDic_Ex->pDic objectEnumerator];
       
       GObject *pObject;
       
       while ((pObject = [pEnumerator nextObject])) {
           
           glLoadIdentity();
           glRotatef(fCurrentAngleRotateOffset, 0, 0, 1);

           [pObject performSelector:pObject->m_sDraw];
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
- (GObject *)GetObjectByName:(NSString*)NameObject{
	
	GObject *pObject = [m_pAllObjects objectForKey:NameObject];
	return pObject;
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
- (id)UnfrozeObject:(NSString *)NameClass WithParams:(NSArray *)Parametrs
{
    GObject *pObject = nil;

    NSString *pNameObject=[self GetNameObject:NameClass];
	Class cls = NSClassFromString(NameClass);
	if (cls != nil)
    {
		NSMutableArray *pArray = [m_pObjectReserv objectForKey:NameClass];
		if (pArray==nil)
        {
            pArray=[[NSMutableArray alloc] init];
			[m_pObjectReserv setObject:pArray forKey:NameClass];
		}

        if ([pArray count]>0)
        {
            pObject = [pArray objectAtIndex:0];
            [pArray removeObjectAtIndex:0];
            
            pObject->m_bDeleted=NO;
            
            [m_pAllObjects setObject:pObject forKey:pObject->m_strName];
            
            if([Parametrs count]>0){
                [pObject SetDefault];        
                [self SetParams:pObject WithParams:Parametrs];
                [pObject PostSetParams];
            }
            
            if (pObject->m_pOwner!=nil)
                pObject->m_iDeep=pObject->m_pOwner->m_iDeep+1;
            
            [pMusAddKeys addObject:pObject];
            
            [pObject Start];
            
            if(pObject->m_bHiden==NO)
                [pObject AddToDraw];        
        }
        else
        {
            pObject = [self CreateNewObject:NameClass 
                             WithNameObject:pNameObject WithParams:Parametrs];
        }        
	}
	
    return pObject;
}
//------------------------------------------------------------------------------------------------------
- (id)CreateNewObject:(NSString *)NameClass WithNameObject:(NSString *)NameObjectTmp
           WithParams:(NSArray *)Parametrs
{
    GObject *pObject=nil;
    NSString *pNameObject=[self GetNameObject:NameObjectTmp];
	Class cls = NSClassFromString(NameClass);
	if (cls != nil)
    {
		NSMutableArray *pArray = [m_pObjectReserv objectForKey:NameClass];
		if (pArray==nil)
        {
            pArray=[[NSMutableArray alloc] init];
			[m_pObjectReserv setObject:pArray forKey:NameClass];
		}

        pObject = [[cls alloc] Init:m_pParent WithName:pNameObject];
        [pObject LinkValues];

        if([Parametrs count]>0){
            [pObject SetDefault];
            [self SetParams:pObject WithParams:Parametrs];
            [pObject PostSetParams];
        }

		if (m_bReserv)
        {
			pObject->m_bDeleted=YES;
            
			[pArray addObject:pObject];
            return pObject;
		}
        else{
            
            pObject->m_bDeleted=NO;
        }

        [m_pAllObjects setObject:pObject forKey:pObject->m_strName];

        if (pObject->m_pOwner!=nil)
            pObject->m_iDeep=pObject->m_pOwner->m_iDeep+1;

        [pMusAddKeys addObject:pObject];
        
        [pObject Start];
        
        if(pObject->m_bHiden==NO)
            [pObject AddToDraw];        
	}
	
    return pObject;
}
//------------------------------------------------------------------------------------------------------
- (void)SetParams:(GObject *)pTmpOb WithParams:(NSArray *)Parametrs{
	
    if(pTmpOb==nil)return;

    int iCount=[Parametrs count];
	for (int i=0; i<iCount; i++) {
		
		UniCell* pParams = (UniCell*)[Parametrs objectAtIndex:i];
        
        NSString *TmpStr=[NSString stringWithFormat:@"%@%@",pTmpOb->m_strName,pParams->mpName];
        pParams->mpName=[NSString stringWithString:TmpStr];
        [pMegaTree CopyCell:pParams];
	}
    
    [pTmpOb Update];
}
//------------------------------------------------------------------------------------------------------
- (void)AddToGroup:(NSString*)NameGroup Object:(GObject *)pObject
{	
    [m_pGroups AddToGroup:NameGroup Object:pObject];    
}
//------------------------------------------------------------------------------------------------------
- (void)RemoveFromGroups:(GObject *)pObject{
    
    [m_pGroups RemoveFromGroups:pObject]; 
}
//------------------------------------------------------------------------------------------------------
- (void)RemoveFromGroup:(NSString*)NameGroup Object:(GObject *)pObject{
	
    [m_pGroups RemoveFromGroup:NameGroup Object:pObject];
}
//------------------------------------------------------------------------------------------------------
- (NSMutableArray *)GetGroup:(NSString*)NameGroup{
	
    return [m_pGroups GetGroup:NameGroup];
}
//------------------------------------------------------------------------------------------------------
- (void)CreateObjects{

	[self CreateNewObject:@"CGameLogic" WithNameObject:@"AIObject" WithParams:nil];
}
//------------------------------------------------------------------------------------------------------
@end
