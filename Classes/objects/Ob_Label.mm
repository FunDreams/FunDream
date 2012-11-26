//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_Label.h"
#import "Ob_ResourceMng.h"
#import "Ob_Icon.h"

@implementation Ob_Label
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_fOffsetText=40;
        m_iLayer = layerInterfaceSpace9;
        m_iLayerTouch=layerTouch_0;//слой касания
        bTexture=NO;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{m_bHiden=NO;}
//- (void)PostSetParams{}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
//====//процессоры для объекта==========================================================================
    Processor_ex* pProc = [self START_QUEUE:@"Proc"];
        ASSIGN_STAGE(@"PROC",@"Proc:",nil);
    [self END_QUEUE:pProc name:@"Proc"];
    
//====//различные параметры=============================================================================
    [m_pObjMng->pMegaTree SetCell:(LINK_FLOAT_V(m_fOffsetText,m_strName,@"m_fOffsetText"))];
    [m_pObjMng->pMegaTree SetCell:(LINK_BOOL_V(bTexture,m_strName,@"bTexture"))];

    pNameLabel=[NSMutableString stringWithString:@""];
    [m_pObjMng->pMegaTree SetCell:(LINK_STRING_V(pNameLabel,m_strName,@"pNameLabel"))];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
    //   GET_DIM_FROM_TEXTURE(@"");
    mColor=Color3DMake(0.8f,0.8f,0.8f,1);

	mWidth  = 226;
	mHeight = 45;

	[super Start];

    GET_TEXTURE(mTextureId, m_pNameTexture);

    [self SetPosWithOffsetOwner];

    [self SetTouch:YES];
    
    //[m_pObjMng AddToGroup:@"NameGroup" Object:self];//группировка
    //[self SelfOffsetVert:Vector3DMake(0,1,0)];//cдвиг
    
    NSString *StrTmp=pNameLabel;
        
    [self Proc:nil];

    if(bTexture==YES)
    {
        m_fOffsetText=26;
        
        Ob_Icon *pOb = UNFROZE_OBJECT(@"Ob_Icon",@"Icon",
                          SET_INT_V(m_iLayer+1,@"m_iLayer"),
                          LINK_ID_V(self,@"m_pOwner"),
                          //SET_FLOAT_V(100,@"m_fOffsetText"),
                          SET_STRING_V(StrTmp,@"m_pNameTexture"),
                          SET_VECTOR_V(Vector3DMake(-90, 0, 0),@"m_pOffsetCurPosition"));
        
        [m_pChildrenbjectsArr addObject:pOb];
        [pOb Proc:nil];
    }
    else m_fOffsetText=-20;
    
    bStartPush=NO;
    
    [self SetUnPush];
    [self UpdateLabel];
    
}
//------------------------------------------------------------------------------------------------------
- (void)UpdatePos{
    [self Proc:nil];
    if(bTexture==YES){
        
        Ob_Icon *pObIcon = [m_pChildrenbjectsArr objectAtIndex:0];
        [pObIcon Proc:nil];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)drawText:(NSString*)theString AtX:(float)X Y:(float)Y {

    glLoadIdentity();
    glRotatef(m_pObjMng->fCurrentAngleRotateOffset, 0, 0, 1);

    int iFontSize=20;
    // Set up texture
    Texture2D* statusTexture = [[Texture2D alloc] initWithString:theString
                dimensions:CGSizeMake(mWidth-55, iFontSize+4) alignment:UITextAlignmentLeft
                fontName:@"Helvetica" fontSize:iFontSize];

    statusTexture->_color=Color3DMake(0, 0, 0, 1);

    // Bind texture
    glBindTexture(GL_TEXTURE_2D, [statusTexture name]);
    // Draw
    [statusTexture drawAtPoint:CGPointMake(X+m_fOffsetText,Y)];

    [statusTexture release];
}
//------------------------------------------------------------------------------------------------------
- (void)SelfDrawOffset{

    [super SelfDrawOffset];
    [self drawText:pNameLabel AtX:m_pCurPosition.x Y:m_pCurPosition.y];
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateLabel{
    
    if(m_pOwner!=nil){

        if(m_pCurPosition.y>(m_pOwner->m_pCurPosition.y+m_pOwner->mHeight*0.45f))
            [self Hide];
        else if(m_pCurPosition.y<(m_pOwner->m_pCurPosition.y-m_pOwner->mHeight*0.45f))
            [self Hide];
        else [self Show];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)InitProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)PrepareProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)Hide{
    [self DeleteFromDraw];
    [self SetTouch:NO];
    
    for (int i=0; i<[m_pChildrenbjectsArr count]; i++) {        
        [[m_pChildrenbjectsArr objectAtIndex:i] DeleteFromDraw];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Show{
    [self AddToDraw];
    [self SetTouch:YES];
    
    for (int i=0; i<[m_pChildrenbjectsArr count]; i++) {
        [[m_pChildrenbjectsArr objectAtIndex:i] AddToDraw];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{
        
    [self SetPosWithOffsetOwner];
    
    if(m_pOwner!=nil){
        Ob_ResourceMng *pMngRes=(Ob_ResourceMng *)m_pOwner;
        m_pCurPosition.y += pMngRes->m_fCurrentOffset;
        
        [self UpdateLabel];
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetPush{
    mColor=Color3DMake(1, 0, 0, 1);
    
    if(m_pOwner!=nil){
        
        SET_CELL(LINK_ID_V(self,@"ObPushLabel"));
        OBJECT_PERFORM_SEL(NAME(m_pOwner), @"SetSelection");
    }
}
//------------------------------------------------------------------------------------------------------
- (void)SetUnPush{
    mColor=Color3DMake(0.8f,0.8f,0.8f,1);
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    
    for (int i=0; i<[m_pChildrenbjectsArr count]; i++) {
        
        DESTROY_OBJECT([m_pChildrenbjectsArr objectAtIndex:i]);
    }
    [m_pChildrenbjectsArr removeAllObjects];

    
    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    bStartPush=YES;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    bStartPush=NO;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMoved:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    bStartPush=NO;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    if(bStartPush==YES){
        
        bStartPush=NO;
        [self SetPush];
    }
}
@end