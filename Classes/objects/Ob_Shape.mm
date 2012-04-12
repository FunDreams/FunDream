//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_Shape.h"

@implementation Ob_Shape
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerTemplet;
        m_iLayerTouch=layerTouch_0;//слой касания
        
        m_bHiden=YES;
        iDiff=1;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
//- (void)SetDefault{}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
//====//процессоры для объекта==========================================================================
    Processor_ex* pProc = [self START_QUEUE:@"Proc"];
  //      ASSIGN_STAGE(@"IDLE",@"Idle:",nil);
        ASSIGN_STAGE(@"PROC1",@"Move1:",
                     SET_INT_V(4000,@"TimeBaseDelay"));
    
        ASSIGN_STAGE(@"PROC2",@"Move2:",nil);
    [self END_QUEUE:pProc name:@"Proc"];
//====//различные параметры=============================================================================
    SET_CELL(LINK_INT_V(iDiff,m_strName,@"iDiff"));
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
	mWidth  = 50;
	mHeight = 50;

	[super Start];

    [m_pObjMng AddToGroup:@"Shapes" Object:self];
    
    NSMutableArray *pArrNearOb = [[NSMutableArray alloc] init];
    NSMutableArray *pArr=[m_pObjMng GetGroup:@"UpPar"];
 
    int countsds=0;
    for (GObject *pOb in pArr) {

        countsds++;
        float fDist=fabs(pOb->m_pCurPosition.x-m_pCurPosition.x);
        bool bAdd=NO;

        for (int i=0;i<[pArrNearOb count];i++) {
                
            GObject *pObNear = [pArrNearOb objectAtIndex:i];
            float fDistNearsInArr=fabs(pObNear->m_pCurPosition.x-m_pCurPosition.x);
            
            if(fDist<=fDistNearsInArr){
                
                GObject *pOBInArray=[pArrNearOb objectAtIndex:i];
                
                if(pOBInArray==pOb){
                    [pArrNearOb removeObjectAtIndex:i];
                }
                
                [pArrNearOb insertObject:pOb atIndex:i];
                bAdd=YES;
                break;
            }
        }
        
        if([pArrNearOb count]>iDiff){
            [pArrNearOb removeLastObject];
        }
        
        if(bAdd==NO && [pArrNearOb count]<iDiff){
            
            [pArrNearOb addObject:pOb];
        }
    }
    
    if([pArrNearOb count]>0){
        for (GObject *pOb in pArrNearOb) {
            
            SET_STAGE_EX(NAME(pOb),@"Stages",@"Attract");
            OBJECT_SET_PARAMS(NAME(pOb),LINK_ID_V(self,@"m_pOwner"));
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)InitProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)PrepareProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)Move1:(Processor_ex *)pProc{
    m_pCurPosition.y-=80*DELTA;

    if(m_pCurPosition.y<0){
//        for (int i=0; i<10; i++) {
//            UNFROZE_OBJECT(@"Obj_FormPar",
//                    SET_VECTOR_V(Vector3DMake(RND_I_F(0,30),RND_I_F(0,30),0),@"m_pOffsetCurPosition"),
//                    LINK_ID_V(self,@"m_pOwner"));
//        }
        NEXT_STAGE;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)Move2:(Processor_ex *)pProc{
  //  int m=0;
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
@end