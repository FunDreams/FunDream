//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectTest.h"
#import "UniCell.h"

@implementation ObjectTest

//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];    
    if (self != nil)
    {
        mWidth  = 50;
        mHeight = 80;
        
        m_iLayer = layerTemplet;
        mTextureId = [m_pParent GetTextureId:@"1-02@2x.png"];
        
        TestPar=12;
        
        [m_pObjMng->pMegaTree SetCell:LINK_INT_V(TestPar,@"1kh",@"2lkh",@"3df")];
        [m_pObjMng->pMegaTree SetCell:SET_INT_V(654,@"s5ef",@"rd")];
        [m_pObjMng->pMegaTree SetCell:SET_INT_V(45322,@"1kh",@"2lkh",@"3df")];
     //   TestPar=2222;

        TestFloat=23.34f;

        [m_pObjMng->pMegaTree SetCell:LINK_FLOAT_V(TestFloat,@"TestFloat")];
        [m_pObjMng->pMegaTree SetCell:SET_FLOAT_V(654,@"TestFloat2")];

        TestFloat=66.34f;

        TestBool=NO;
        
        [m_pObjMng->pMegaTree SetCell:LINK_BOOL_V(TestBool,@"TestBool")];
        [m_pObjMng->pMegaTree SetCell:SET_BOOL_V(NO,@"TestBool2")];

        TestBool=YES;

        Testvec=Vector3DMake(3,5,9);
        [m_pObjMng->pMegaTree SetCell:LINK_VECTOR_V(Testvec,@"TestVector")];
        [m_pObjMng->pMegaTree SetCell:SET_VECTOR_V(Vector3DMake(4099, 9, 229423.44),@"TestVector2")];
        Testvec=Vector3DMake(2,8,4);

        TestCol=Color3DMake(1, .3, .2, 0);
        
        [m_pObjMng->pMegaTree SetCell:LINK_COLOR_V(TestCol,@"TestColor")];
        [m_pObjMng->pMegaTree SetCell:SET_COLOR_V(Color3DMake(.4f, 1, 1,.6f),@"TestColor2")];

        TestCol=Color3DMake(0, 0, 0, 0);

        TestStr=[NSMutableString stringWithString:@"ffffff"];

        [m_pObjMng->pMegaTree SetCell:LINK_ID_V(TestStr,@"TestId")];
        [m_pObjMng->pMegaTree SetCell:SET_STRING_V(@"string2gg",@"TestString2")];
        
        [m_pObjMng->pMegaTree SetCell:LINK_POINT_V(TestPar,@"testPoint")];
        
//        Processor_ex* pProc = [self START_QUEUE:@"test2"];
//            
//            ASSIGN_STAGE(@"TestStage",@"AchiveLineFloat:",
//                         LINK_FLOAT_V(m_pCurAngle.z,@"Instance"),
//                         SET_FLOAT_V(m_pCurPosition.y-3000000,@"finish_Instance"),
//                         SET_FLOAT_V(-100,@"Vel"));
//
//        [self END_QUEUE:pProc name:@"test2"];

        Processor_ex *pProc = [self START_QUEUE:@"test"];

//            ASSIGN_STAGE(@"TestStage",@"AchiveLineFloat:",
//                         LINK_FLOAT_V(m_pCurPosition.y,@"Instance"),
//                         SET_FLOAT_V(m_pCurPosition.y-300,@"finish_Instance"),
//                         SET_FLOAT_V(-40,@"Vel"));
            
          //  PARAMS_STAGE(@"TestStage",SET_FLOAT_V(-400,@"Vel"));

            ASSIGN_STAGE(@"Stage1",@"TestSel:",
                         SET_INT_V(1, @"TimeRndDelay"),
                         SET_INT_V(5000, @"TimeBaseDelay"),
                         SET_INT_V(1, @"TimeRndTimer"),
                         SET_INT_V(5000, @"TimeBaseTimer"));
        
//            DELAY_STAGE(@"Stage1",3000,1000);

            ASSIGN_STAGE(@"Stage2",@"TestSel2:",nil);

            INSERT_STAGE(@"Stage3",@"TestSel3:",@"Stage2",nil);

        [self END_QUEUE:pProc name:@"test"];
            
        //Processor_ex* pProc = [self START_QUEUE:@"test"];
        //    [pProc Remove_Stage:@"Stage2"];
        //[self END_QUEUE:pProc name:@"test"];
    }
    
    return self;
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];

	TestDword=565;
//	TestBool=NO;
//	TestPar=4;
    
 //   [TestStr ]
//    [TestStr setString:@"Good"];
//    TestStr=[NSMutableString stringWithString:@"asdfg"];
//    int m=0;
}
//------------------------------------------------------------------------------------------------------
- (void)Move:(Processor_ex *)pProc{

//    int *dfdfdf=GET_INT_V(@"1kh",@"2lkh",@"3df");
//    int *ddfdf=GET_INT_V(@"s5ef",@"rd");
//
//    float *tfloat2=GET_FLOAT_V(@"TestFloat");
//    float *tfloat=GET_FLOAT_V(@"TestFloat2");
//
//    bool *tBool2=GET_BOOL_V(@"TestBool");
//    bool *tBool=GET_BOOL_V(@"TestBool2");
//
//    Vector3D *tvector2=GET_VECTOR_V(@"TestVector");    
//    Vector3D *tvector=GET_VECTOR_V(@"TestVector2");
//    Color3D *tColor2=GET_COLOR_V(@"TestColor");
//
//    Color3D *tColor=GET_COLOR_V(@"TestColor2");
//
//    NSMutableString *tStr2=GET_ID_V(@"TestId");
//    NSMutableString *tS3=GET_ID_V(@"TestString2");
//
//    int * pVoid=(int *)GET_POINT_V(@"testPoint");
//
//    NSLog(tStr2);
}

- (void)timesel:(Processor_ex *)pProc{

	fabs(8);
	[pProc SetStage:pProc->m_CurStage->NameStage];
}

- (void)testAction2:(Processor_ex *)pProc{
	
}

- (void)testAction:(Processor_ex *)pProc{
}

- (void)TestSel3:(Processor_ex *)pProc{
  //  int m=0;
 //   [pProc NextStage];
}

- (void)TestSel2:(Processor_ex *)pProc{
 //   int m=0;
    NSLog(@"good");
    [pProc NextStage];
}

- (void)TestSel:(Processor_ex *)pProc{
	NSLog(@"test");
//    [pProc NextStage];
}

- (void)sfMove
{
}

@end
