//
//  Processor.h
//  FunDreams
//
//  Created by Konstantin on 04.12.10.
//  Copyright 2010 FunDreams. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GObject;

//-------------------------------------------------------------------------------------------
@class Processor_ex;
@interface ProcStage_ex : NSObject {
@public
    Processor_ex *pParent;

    ProcStage_ex *StagePrev;
    ProcStage_ex *StageNext;

    NSString *NameStage;
    SEL       m_selector;
    SEL       m_selectorSecond;
    
    float m_pTime;
	int m_pTimeRnd;
	int m_pTimeBase;
    
    int *IntsValues[6];
    float *FloatsValues[6];
    Vector3D *VectorsValues[6];
    Color3D *ColorsValues[6];
}
- (id)InitWithParent_ex:(Processor_ex *)ProcParent;
- (void)Prepare;
- (void)SetDelay;

- (void)dealloc;

@end
//-------------------------------------------------------------------------------------------
@interface Processor_ex : NSObject {
@public
	NSString *m_pNameProcessor;
	GObject *m_pObject;
	float m_pTimeAbs;
	float m_pDeltaTime;
    bool m_bRepeate;

	NSMutableDictionary *pDicStages;
	ProcStage_ex  *m_CurStage;
	ProcStage_ex  *m_FirstStage;
	ProcStage_ex  *m_LastStage;
}

- (id)InitWithName:(NSString *)strName WithParent:(id)pParent;

- (void)NextStage;
- (void)SetStage:(NSString *)Stage;

- (void)Assign_Stage:(NSString *)NameStage WithSel:(NSString *)NameSel  WithParams:(NSArray *)Parametrs;
- (void)Insert_Stage:(NSString *)NameStage WithSel:(NSString *)NameSel 
          afterStage:(NSString *)afretName  WithParams:(NSArray *)Parametrs;

- (void)SetParams:(NSString *)NameStage WithParams:(NSArray *)Parametrs;

- (void)Remove_Stage:(NSString *)NameStage;
- (void)Delay_Stage:(NSString *)NameStage Time:(int)iTime TimeRnd:(int)iTimeRnd;
@end
//-------------------------------------------------------------------------------------------