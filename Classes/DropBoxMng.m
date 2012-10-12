//
//  InfoFile.m
//  FunDreams
//
//  Created by Konstantin on 27.09.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import "DropBoxMng.h"
#import "ObB_DropBox.h"

@implementation DropBoxMng
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        pDataManager=[[CDataManager alloc] InitWithFileFromRes:@"info"];
        pDataManager->m_pParent=self;
        pDropBoxString = [m_pObjMng->pStringContainer GetString:@"DropBox"];

        m_bHiden=YES;
        [self DownLoadInfoFile];
    }

    return self;
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
	[super Start];
}
//------------------------------------------------------------------------------------------------------
- (void)Check{
    
    id pObTmp = GET_ID_V(@"ObCheckInDropBox");
    
    int i=0;
    if(pObTmp!=nil){
        for (GObject *pOb in m_pChildrenbjectsArr) {
            if(pOb==pObTmp){
                m_iCurrentSelect=i;
                continue;
            }
            else{
                OBJECT_PERFORM_SEL(pOb->m_strName, @"SetUnPush");
            }
            i++;
        }
    }
}
//------------------------------------------------------------------------------------------------------
//- (void)SetDefault{}
//- (void)PostSetParams{}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
}
//------------------------------------------------------------------------------------------------------
- (void)Hide{
    
    for (ObB_DropBox *pOb in m_pChildrenbjectsArr) {
        [pOb SetTouch:NO];
        [pOb DeleteFromDraw];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Show{
    
    for (ObB_DropBox *pOb in m_pChildrenbjectsArr) {
        [pOb SetTouch:YES];
        [pOb AddToDraw];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateButt{
    
    for (GObject *pOb in m_pChildrenbjectsArr) {
        DESTROY_OBJECT(pOb);
    }
    [m_pChildrenbjectsArr removeAllObjects];

    int m_iNumButton=[pDropBoxString->aStrings count];

    for(int i=0;i<m_iNumButton;i++){
        
        FractalString *pFrStr = [pDropBoxString->aStrings objectAtIndex:i];
        ObB_DropBox *pOb=UNFROZE_OBJECT(@"ObB_DropBox",@"Ob_DropBox",
                           SET_STRING_V(@"ButtonOb.png",@"m_DOWN"),
                           SET_STRING_V(@"ButtonOb.png",@"m_UP"),
                           SET_FLOAT_V(54,@"mWidth"),
                           SET_FLOAT_V(54*FACTOR_DEC,@"mHeight"),
                           SET_BOOL_V(YES,@"m_bLookTouch"),
                           SET_INT_V(2,@"m_iType"),
                           SET_STRING_V(NAME(self),@"m_strNameObject"),
                           SET_STRING_V(@"Check",@"m_strNameStage"),
                           SET_STRING_V(@"PushButton.wav", @"m_strNameSound"),
                           SET_BOOL_V(YES,@"m_bDrag"),
                           SET_VECTOR_V(Vector3DMake(pFrStr->X,pFrStr->Y,0),@"m_pCurPosition"));
        
        pOb->pString=pFrStr;

        [m_pChildrenbjectsArr addObject:pOb];
    }
    
    if([m_pChildrenbjectsArr count]>0){
        if(m_iCurrentSelect>[m_pChildrenbjectsArr count]-1)
            m_iCurrentSelect=[m_pChildrenbjectsArr count]-1;
        
        ObB_DropBox *pObSel=[m_pChildrenbjectsArr objectAtIndex:m_iCurrentSelect];
        
        OBJECT_PERFORM_SEL(NAME(pObSel), @"SetPush");
    }    
}
//------------------------------------------------------------------------------------------------------
-(void)DownLoadInfoFile{
    [pDataManager DownLoad];
}
//------------------------------------------------------------------------------------------------------
-(void)loadFileFailedWithError{
//    int m=0;
}
//------------------------------------------------------------------------------------------------------
-(void)loadedFile{
    [self Load];
}
//------------------------------------------------------------------------------------------------------
-(void)Load{}
//------------------------------------------------------------------------------------------------------
-(void)Save{}
//------------------------------------------------------------------------------------------------------
-(void)dealloc{
    [pDataManager release];
    [super dealloc];
}

@end
