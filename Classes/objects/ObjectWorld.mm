//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectWorld.h"

@implementation ObjectWorld
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{	
    self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_bHiden=YES;
        m_iLayer = layerSystem;
    }

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    
    Processor_ex *pProc = [self START_QUEUE:@"Proc"];
    
        ASSIGN_STAGE(@"Idle",@"Idle:",nil);
        ASSIGN_STAGE(@"Proc",@"Proc:",nil);
    
    [self END_QUEUE:pProc name:@"Proc"];


    pProc = [self START_QUEUE:@"GameProgress"];
    
        ASSIGN_STAGE(@"Idle",@"Idle:",nil);
        ASSIGN_STAGE(@"Delay",@"Idle:",
                     SET_INT_V(4000, @"TimeBaseTimer"));
        ASSIGN_STAGE(@"SelParticle",@"SelParticle:",nil);
    
    [self END_QUEUE:pProc name:@"GameProgress"];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
	[super Start];
}
//------------------------------------------------------------------------------------------------------
- (void)StartGame{

    CREATE_NEW_OBJECT(@"ObjectMultiTouch",@"OMultiTouch",nil);
    
    for (int i=0; i<10; i++) {
        GObject *ObMatter = CREATE_NEW_OBJECT(@"ObjectEvilMatter1",@"EvilMater1",
                          SET_VECTOR_V(Vector3DMake(350,540,0),@"m_pCurPosition"));
        
        if(ObMatter!=nil)
            [m_pChildrenbjectsArr addObject:ObMatter];
    }

    NEXT_STAGE_EX(@"Cup", @"Proc");

    SET_STAGE_EX(self->m_strName,@"GameProgress", @"Delay");

    [m_pObjMng->pMegaTree SetCell:SET_BOOL_V(YES,@"FirstSoundParticle")];
    
    OBJECT_PERFORM_SEL(@"Score", @"RezetScore");
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
//------------------------------------------------------------------------------------------------------
- (void)SelParticle:(Processor_ex *)pProc{
    
    if([m_pChildrenbjectsArr count]>0){
        GObject *pOb= [m_pChildrenbjectsArr objectAtIndex:0];
        
        if(pOb!=nil)
        {
            [m_pChildrenbjectsArr removeObjectAtIndex:0];
            
            SET_STAGE_EX(pOb->m_strName,@"Mirror",@"AchivePoint");
            SET_STAGE_EX(pOb->m_strName,@"Parabola",@"MoveParabola");
            NEXT_STAGE_EX(pOb->m_strName, @"Proc");
        }
    }
    
    PLAY_SOUND(@"evil.wav");
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{
    
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    
    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
//- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)dealloc{[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end