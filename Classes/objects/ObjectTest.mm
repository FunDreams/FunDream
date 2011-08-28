//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectTest.h"

@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];    
    
    mWidth  = 50;
	mHeight = 80;
    
    m_iLayer = layerTemplet;
	GET_TEXTURE(mTextureId,@"1-02@2x.png");
    
    TestPar=12;
    
    SET_CELL(LINK_INT_V(TestPar,@"1kh",@"2lkh",@"3df"));
    SET_CELL(SET_INT_V(654,@"s5ef",@"rd"));    
    SET_CELL(SET_INT_V(45322,@"1kh",@"2lkh",@"3df"));
 //   TestPar=2222;

    TestFloat=23.34f;

    SET_CELL(LINK_FLOAT_V(TestFloat,@"TestFloat"));
    SET_CELL(SET_FLOAT_V(654,@"TestFloat2"));

    TestFloat=66.34f;

    TestBool=NO;
    
    SET_CELL(LINK_BOOL_V(TestBool,@"TestBool"));
    SET_CELL(SET_BOOL_V(NO,@"TestBool2"));

    TestBool=YES;

    Testvec=Vector3DMake(3,5,9);
    SET_CELL(LINK_VECTOR_V(Testvec,@"TestVector"));
    SET_CELL(SET_VECTOR_V(Vector3DMake(4099, 9, 229423.44),@"TestVector2"));
    Testvec=Vector3DMake(2,8,4);

    TestCol=Color3DMake(1, .3, .2, 0);
    
    SET_CELL(LINK_COLOR_V(TestCol,@"TestColor"));
    SET_CELL(SET_COLOR_V(Color3DMake(.4f, 1, 1,.6f),@"TestColor2"));

    TestCol=Color3DMake(0, 0, 0, 0);

    TestStr=[NSMutableString stringWithString:@"ffffff"];

    SET_CELL(LINK_ID_V(TestStr,@"TestId"));
    SET_CELL(SET_STRING_V(@"string2gg",@"TestString2"));
    
    SET_CELL(LINK_POINT_V(TestPar,@"testPoint"));
    
START_QUEUE(@"test2")
    
    ASSIGN_STAGE(@"TestStage",@"AchiveLineFloat:",
                 LINK_FLOAT_V(m_pCurAngle.z,@"Instance"),
                 SET_FLOAT_V(m_pCurPosition.y-3000000,@"finish_Instance"),
                 SET_FLOAT_V(-100,@"Vel"));
    
    
END_QUEUE(@"test2")

START_QUEUE(@"test")

    ASSIGN_STAGE(@"TestStage",@"AchiveLineFloat:",
                 LINK_FLOAT_V(m_pCurPosition.y,@"Instance"),
                 SET_FLOAT_V(m_pCurPosition.y-300,@"finish_Instance"),
                 SET_FLOAT_V(-40,@"Vel"));
    
  //  PARAMS_STAGE(@"TestStage",SET_FLOAT_V(-400,@"Vel"));

    ASSIGN_STAGE(@"Stage1",@"TestSel:",nil);
    DELAY_STAGE(@"Stage1",3000,1000);

    ASSIGN_STAGE(@"Stage2",@"TestSel2:",nil);

    INSERT_STAGE(@"Stage3",@"TestSel3:",@"Stage2",nil);
    
END_QUEUE(@"test")
    
//START_QUEUE(@"test")
//    REMOVE_STAGE(@"Stage2");//[pProc Remove_Stage:@"Stage2"];
//END_QUEUE(@"test")

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
//------------------------------------------------------------------------------------------------------
- (void)timesel:(Processor_ex *)pProc{

	fabs(8);
	REPEATE
}
//------------------------------------------------------------------------------------------------------
- (void)testAction2:(Processor_ex *)pProc{
	
}
//------------------------------------------------------------------------------------------------------
- (void)testAction:(Processor_ex *)pProc{
}
//------------------------------------------------------------------------------------------------------
- (void)TestSel3:(Processor_ex *)pProc{
  //  int m=0;
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)TestSel2:(Processor_ex *)pProc{
 //   int m=0;
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)TestSel:(Processor_ex *)pProc{
//	int m=0;
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {
	[super dealloc];
}
//------------------------------------------------------------------------------------------------------
- (void)sfMove{}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT