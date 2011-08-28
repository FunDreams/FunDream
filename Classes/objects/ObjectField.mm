//
//  TestGameObject.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "ObjectField.h"

@implementation NAME_TEMPLETS_OBJECT
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	[super Init:Parent WithName:strName];
	
    m_bGhost=NO;

    m_iComplexity=0;
	m_iLayer = layerTemplet;
	m_bHiden=YES;

	[self SetTouch:YES];
    
    LOAD_SOUND(iIdSound,@"Oblako.wav",NO);
    LOAD_SOUND(iIdStoun,@"stoun.wav",NO);
    LOAD_SOUND(iIdShake,@"shake.wav",NO);
    LOAD_SOUND(iIdError,@"error.wav",NO);

START_PROC(@"ProcMove");
    UP_TIMER(0,1,2500, @"timerWaitNextStage:");
    UP_SELECTOR(@"e2",@"MoveEx:");
END_PROC(@"ProcMove");

START_PROC(@"ProcSave");
    UP_TIMER(0,1,100, @"save:");
    UP_SELECTOR(@"e2",@"Idle:");
END_PROC(@"ProcSave");

	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)GetParams:(CParams *)Parametrs{
    [super GetParams:Parametrs];
    
    COPY_OUT_INT(m_iCountError);
    COPY_OUT_BOOL(m_bGhost);

    COPY_OUT_INT(m_iComplexity);
    
    COPY_OUT_BOOL(m_bNewRecord);  
    
    COPY_OUT_POINT(ObAura);
    
    COPY_OUT_FLOAT(m_fPhase);
}
//------------------------------------------------------------------------------------------------------
- (void)SetParams:(CParams *)Parametrs{
	[super SetParams:Parametrs];
	
	COPY_IN_INT(m_iCurIndex);
	COPY_IN_INT(m_iComplexity);
    
    COPY_IN_BOOL(m_bGhost);
    COPY_IN_POINT(ObAura, GObject);
}
//------------------------------------------------------------------------------------------------------
- (void)ReplaceCol:(int)One WithSecond:(int)Two{
    
    for (int i=0; i<9; i++) {
        
        int pNum1= m_ArrayField[One+i*9];
        int pNum2= m_ArrayField[Two+i*9];
        
        m_ArrayField[Two+i*9]=pNum1;
        m_ArrayField[One+i*9]=pNum2;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)ReplaceRow:(int)One WithSecond:(int)Two{
    
    for (int i=0; i<9; i++) {
        
        int pNum1= m_ArrayField[i+One*9];
        int pNum2= m_ArrayField[i+Two*9];
        
        m_ArrayField[i+Two*9]=pNum1;
        m_ArrayField[i+One*9]=pNum2;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)ResetGhost{
    
    SET_STAGE(@"NButtonNO", 4);
    SET_STAGE(@"NButtonYES", 4);
    
    SET_STAGE(@"NButtonGhost", 8);
    
    OBJECT_SET_PARAMS(@"Field", SET_BOOL(@"m_bGhost", NO),nil);
}
//------------------------------------------------------------------------------------------------------
- (void)GhostYES{   

    int Count=0;
    for (GObject *pOb in m_pChildrenbjectsArr){
        int Type=GET_INT(NAME(pOb),@"iType");

        if(Type==3){

            OBJECT_SET_PARAMS(NAME(pOb),SET_INT(@"iType", 0),nil);
            OBJECT_PERFORM_SEL(NAME(pOb), @"SetType");
            
            PARAMS_APP->TypeField[Count]=0;
        }
        
        Count++;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)GhostNO{  
    
    for (int i=0;i<[m_pChildrenbjectsArr count];i++) {
        
        GObject *pOb=[m_pChildrenbjectsArr objectAtIndex:i];
        int Type=GET_INT(NAME(pOb),@"iType");
        int CurSym=GET_INT(NAME(pOb),@"m_iCurrentSym");
        
        if(Type==3 && CurSym!=0){
            
            SET_STAGE(NAME(pOb), 8);
            
            [m_pChildrenbjectsArr removeObjectAtIndex:i];
            
            NSString* pName=[NSString stringWithFormat:@"Number%d",i];
            GObject *Ob = CREATE_NEW_OBJECT(@"ObjectNumSudoku",pName,
                                            SET_POINT(@"m_pOwner",@"id",self),
                                            SET_INT(@"m_iCurrentSym",0),
                    SET_VECTOR(@"m_pOffsetCurPosition",pOb->m_pOffsetCurPosition),
                                            SET_INT(@"m_iCurNum", i),
                                            SET_INT(@"iType", Type),
                                            SET_BOOL(@"m_bHiden",YES),
                                            nil);
            
            [m_pChildrenbjectsArr insertObject:Ob atIndex:i];
            m_ArrayField_Second[i]=0;
            PARAMS_APP->NumShowField[i]=0;
        }
    }
    
    [self Validation];
}
//------------------------------------------------------------------------------------------------------
- (void)Validation{
    
    m_bGame=YES;
    
    if(m_iCurIndex!=-1){
        GObject *pObCell= [m_pChildrenbjectsArr objectAtIndex:m_iCurIndex];
        int iCurSym=GET_INT(NAME(pObCell), @"m_iCurrentSym");
        int iType=GET_INT(NAME(pObCell), @"iType");
        m_ArrayField_Second[m_iCurIndex] = iCurSym;

        PARAMS_APP->NumShowField[m_iCurIndex]=iCurSym;
        PARAMS_APP->TypeField[m_iCurIndex]=iType;
    }
    
    m_iCurIndex=-1;
    
    for (int i=0; i<81; i++) {
        GObject *pOb= [m_pChildrenbjectsArr objectAtIndex:i];

        OBJECT_SET_PARAMS(NAME(pOb),SET_BOOL(@"bError", NO),nil);
        OBJECT_PERFORM_SEL(NAME(pOb), @"Error");
    }
    m_iCountError=0;

    for (int i=0; i<81; i++) {

        if(m_ArrayField_Second[i]==0)continue;
        int iSymOne=m_ArrayField_Second[i];

        int Row=i%9;//X
        int Col=i/9;//Y

        for (int j=Row+1; j<9; j++)
        {
            int iIndex=Col*9+j;

            if(m_ArrayField_Second[iIndex]!=0 && m_ArrayField_Second[iIndex]==iSymOne)
            {
                m_fPhase=0;

                GObject *pOb1= [m_pChildrenbjectsArr objectAtIndex:i];
                GObject *pOb2= [m_pChildrenbjectsArr objectAtIndex:iIndex];

                OBJECT_SET_PARAMS(NAME(pOb1),SET_BOOL(@"bError",YES),nil);
                OBJECT_SET_PARAMS(NAME(pOb2),SET_BOOL(@"bError",YES),nil);

                OBJECT_PERFORM_SEL(NAME(pOb1), @"Error");
                OBJECT_PERFORM_SEL(NAME(pOb2), @"Error");
                
                m_iCountError++;
            }
        }

        for (int j=Col+1; j<9; j++)
        {
            int iIndex=(j)*9+Row;

            if(m_ArrayField_Second[iIndex]!=0 && m_ArrayField_Second[iIndex]==iSymOne)
            {
                m_fPhase=0;
                GObject *pOb1= [m_pChildrenbjectsArr objectAtIndex:i];
                GObject *pOb2= [m_pChildrenbjectsArr objectAtIndex:iIndex];
                
                OBJECT_SET_PARAMS(NAME(pOb1),SET_BOOL(@"bError",YES),nil);
                OBJECT_SET_PARAMS(NAME(pOb2),SET_BOOL(@"bError",YES),nil);
                
                OBJECT_PERFORM_SEL(NAME(pOb1), @"Error");
                OBJECT_PERFORM_SEL(NAME(pOb2), @"Error");
                
                m_iCountError++;
            }
        }

        int TmpX=Row/3;
        int TmpY=Col/3;

        TmpX*=3;
        TmpY*=3;

        for (int j=0; j<3; j++)
        {
            for (int k=0; k<3; k++)
            {
                int iIndex=TmpX+k+(TmpY+j)*9;     //   (Col+j+1)*9+Row;
                
                if(iIndex==i)continue;
                
                if(m_ArrayField_Second[iIndex]!=0 && m_ArrayField_Second[iIndex]==iSymOne)
                {
                    m_fPhase=0;
                    GObject *pOb1= [m_pChildrenbjectsArr objectAtIndex:i];
                    GObject *pOb2= [m_pChildrenbjectsArr objectAtIndex:iIndex];
                    
                    OBJECT_SET_PARAMS(NAME(pOb1),SET_BOOL(@"bError",YES),nil);
                    OBJECT_SET_PARAMS(NAME(pOb2),SET_BOOL(@"bError",YES),nil);
                    
                    OBJECT_PERFORM_SEL(NAME(pOb1), @"Error");
                    OBJECT_PERFORM_SEL(NAME(pOb2), @"Error");
                    
                    m_iCountError++;
                }
            }
        }
    } 
    
    [self Check_Finish];
}
//------------------------------------------------------------------------------------------------------
- (void)StartNewField{

    m_bGame=NO;

    SET_STAGE(@"Fade2", 2);
    SET_STAGE(@"shake", 3);

    OBJECT_PERFORM_SEL(@"Timer", @"ResetTimer")
    OBJECT_PERFORM_SEL(@"Timer", @"ResumeTimer")

    OBJECT_PERFORM_SEL(@"Fade", @"HideFade")
    OBJECT_PERFORM_SEL(@"Field", @"GenerateField");
        
    GObject *pOb = [m_pObjMng GetObjectByName:@"Timer"];
    [pOb SetLayerAndChild:layerInterfaceSpace2];
    
    pOb = [m_pObjMng GetObjectByName:@"ButtonDif1"];
    [pOb SetLayerAndChild:layerInterfaceSpace3];
    
    pOb = [m_pObjMng GetObjectByName:@"ButtonDif2"];
    [pOb SetLayerAndChild:layerInterfaceSpace3];
    
    pOb = [m_pObjMng GetObjectByName:@"ButtonDif3"];
    [pOb SetLayerAndChild:layerInterfaceSpace3];
    
    SET_STAGE_EX(@"ButtonDif1",@"Slider", 4);
    SET_STAGE_EX(@"ButtonDif2",@"Slider", 4);
    SET_STAGE_EX(@"ButtonDif3",@"Slider", 4);
    
    SET_STAGE_EX(@"ButtonDif1",@"Wave", 0);
    SET_STAGE_EX(@"ButtonDif2",@"Wave", 0);
    SET_STAGE_EX(@"ButtonDif3",@"Wave", 0);

    OBJECT_PERFORM_SEL(@"Hint", @"Enable");
    
    SET_STAGE_EX(@"TimerEasy", @"Proc", 4);
    SET_STAGE_EX(@"TimerNormal", @"Proc", 4);
    SET_STAGE_EX(@"TimerHard", @"Proc", 4);
    
    int TmpStage=GET_STAGE_EX(@"Timer",@"Proc");
    
    if(TmpStage<=10 && TmpStage>6){
        SET_STAGE_EX(@"Timer", @"Proc",11);
        SET_STAGE_EX(@"Timer",@"MoveEx",0);
    }
    
    [self Check_Finish];
    
    OBJECT_SET_PARAMS(@"Timer", SET_INT(@"m_iNextStage",2),nil);
    
    m_bNewRecord=NO;
}
//------------------------------------------------------------------------------------------------------
- (void)Check_Finish{
    
    int iCountNil=0;
    
    for (int i=0; i<81; i++) {
        if(m_ArrayField_Second[i]==0){
            iCountNil++;        
        }
    }

    GObject *pOb = [m_pObjMng GetObjectByName:@"Fade"];

    if(iCountNil==0 && m_iCountError==0 && pOb==nil){

        m_bGame=NO;
        [self SetTouch:NO];

        CREATE_NEW_OBJECT(@"PhoneShake",@"shake",
                          SET_INT(@"m_iLayer",layerInterfaceSpace6),
                          SET_STRING(@"m_pNameTexture",@"PhoneShake.png"),
    SET_VECTOR(@"m_pCurPosition",(TmpVector1=Vector3DMake(230*FACTOR_DEC,250,0.0f))),
                          SET_FLOAT(@"mWidth",110*FACTOR_DEC),
                          SET_FLOAT(@"mHeight",110),
                          nil);
        
        Color3D FinishColor;
        
        switch(m_iComplexity){
                case 0:
                    FinishColor=Color3DMake(0.0f, 0.6f, 0, 0.0f);
                break;
                case 1:
                    FinishColor=Color3DMake(0.6f, 0.6f, 0, 0.0f);
                break;
                case 2:
                    FinishColor=Color3DMake(0.6f, 0.0f, 0, 0.0f);
                break;
        }
        
        CREATE_NEW_OBJECT(@"ObjectFade",@"Fade",
                          SET_INT(@"m_iLayer",layerInvisible),
                          SET_COLOR(@"mColor",FinishColor),
                          SET_VECTOR(@"m_pCurPosition",(TmpVector1=Vector3DMake(0,0,0.0f))),
                          SET_FLOAT(@"mWidth",640*FACTOR_INC_INV),
                          SET_FLOAT(@"mHeight",960),
                          SET_INT(@"m_iStartStage", 5),
                          SET_STRING(@"m_pNameTexture",@"FadeTexture.png"),
                          SET_INT(@"m_iLayerTouch", layerNumber),
                          SET_INT(@"m_iLayer",layerInvisible),
                          nil);
        
        PARAMS_APP->bGhost=NO;

        pOb = [m_pObjMng GetObjectByName:@"Timer"];
        [pOb SetLayerAndChild:layerInterfaceSpace5];

        pOb = [m_pObjMng GetObjectByName:@"ButtonDif1"];
        [pOb SetLayerAndChild:layerInterfaceSpace5];

        pOb = [m_pObjMng GetObjectByName:@"ButtonDif2"];
        [pOb SetLayerAndChild:layerInterfaceSpace5];

        pOb = [m_pObjMng GetObjectByName:@"ButtonDif3"];
        [pOb SetLayerAndChild:layerInterfaceSpace5];

        OBJECT_PERFORM_SEL(@"Hint", @"Disable");
        
        [self ResetGhost];
        
        OBJECT_PERFORM_SEL(@"Timer", @"SuspendTimer")
        
        OBJECT_PERFORM_SEL(@"ButtonDif3",@"InitAllButton2");

        NSMutableArray *pArray=[[NSMutableArray alloc] init];
        
        for (int i=0; i<81; i++) {
            int iRnd=RND%2;
            [pArray addObject:[NSNumber numberWithInt:iRnd]];
        }
        
        int iLoop=0;
        for (GObject *pOb in m_pChildrenbjectsArr) {
            
            int iTmp=[[pArray objectAtIndex:iLoop] intValue];
            
            if(iTmp!=0){
                SET_STAGE(NAME(pOb),11);
            }
            else {
                SET_STAGE(NAME(pOb), 8);
            }

            iLoop++;
        }

        
        [pArray release];
        
        Vector3D VEasy=Vector3DMake(80*FACTOR_DEC,180,0);
        Vector3D VNormal=Vector3DMake(80*FACTOR_DEC,50,0);
        Vector3D VHard=Vector3DMake(80*FACTOR_DEC,-80,0);

        switch (m_iComplexity) {
            case 0:
                VEasy.y-=30;
                break;

            case 1:
                VNormal.y-=30;
                break;
                
            case 2:
                VHard.y-=30;
                break;

            default:
                break;
        }

        //timers
        CREATE_NEW_OBJECT(@"ObjectTimer",@"TimerEasy",
                          SET_COLOR(@"m_cNumbers",(TmpColor1=Color3DMake(1, 1, 0, 0.0f))),
                          SET_VECTOR(@"m_pCurPosition",VEasy),
                          SET_INT(@"m_iLayer",layerInterfaceSpace5),
                          SET_FLOAT(@"m_fTimer", PARAMS_APP->TimerEasy),
                          nil);
        
        SET_STAGE_EX(@"TimerEasy", @"Proc", 1);
        OBJECT_PERFORM_SEL(@"TimerEasy", @"SuspendTimer");
        
        CREATE_NEW_OBJECT(@"ObjectTimer",@"TimerNormal",
                          SET_COLOR(@"m_cNumbers",(TmpColor1=Color3DMake(1, 1, 0, 0.0f))),
                          SET_VECTOR(@"m_pCurPosition",VNormal),
                          SET_INT(@"m_iLayer",layerInterfaceSpace5),
                          SET_FLOAT(@"m_fTimer", PARAMS_APP->TimerNormal),
                          nil);
        
        SET_STAGE_EX(@"TimerNormal", @"Proc", 1);
        OBJECT_PERFORM_SEL(@"TimerNormal", @"SuspendTimer");

        CREATE_NEW_OBJECT(@"ObjectTimer",@"TimerHard",
                          SET_COLOR(@"m_cNumbers",(TmpColor1=Color3DMake(1, 1, 0, 0.0f))),
                          SET_VECTOR(@"m_pCurPosition",VHard),
                          SET_INT(@"m_iLayer",layerInterfaceSpace5),
                          SET_FLOAT(@"m_fTimer", PARAMS_APP->TimerHard),
                          nil);
        
        SET_STAGE_EX(@"TimerHard", @"Proc", 1);
        OBJECT_PERFORM_SEL(@"TimerHard", @"SuspendTimer");

        SET_STAGE_EX(@"Timer", @"Proc",7);

        float CurrentTime=GET_INT(@"Timer", @"m_fTimer");
        
        switch (m_iComplexity) {
            case 0:{
                    float TimeEasy=GET_INT(@"TimerEasy", @"m_fTimer");

                    if(CurrentTime<TimeEasy || PARAMS_APP->TimerEasy==0){
                        PARAMS_APP->TimerEasy=CurrentTime;
                        OBJECT_SET_PARAMS(@"Timer", SET_INT(@"m_iNextStage",3),nil);
                        
                        SET_STAGE_EX(@"Timer",@"MoveEx",1);
                        
                        m_bNewRecord=YES;
                    }
                }
                break;

            case 1:{
                    float TimeNormal=GET_INT(@"TimerNormal", @"m_fTimer");
                    
                    if(CurrentTime<TimeNormal || PARAMS_APP->TimerNormal==0){
                        PARAMS_APP->TimerNormal=CurrentTime;
                        OBJECT_SET_PARAMS(@"Timer", SET_INT(@"m_iNextStage",3),nil);
                        SET_STAGE_EX(@"Timer",@"MoveEx",1);
                        
                        m_bNewRecord=YES;
                    }
                }
                break;

            case 2:{
                    float TimeHard=GET_INT(@"TimerHard", @"m_fTimer");
                    
                    if(CurrentTime<TimeHard || PARAMS_APP->TimerHard==0){
                        PARAMS_APP->TimerHard=CurrentTime;
                        OBJECT_SET_PARAMS(@"Timer", SET_INT(@"m_iNextStage",3),nil);
                        SET_STAGE_EX(@"Timer",@"MoveEx",1);
                        
                        m_bNewRecord=YES;
                    }
                }
                break;

            default:
                break;
        }
        //save params
        PARAMS_APP->TimerMain=0;
        
        for (int i=0; i<81; i++) {

            PARAMS_APP->NumHidenField[i]=0;
            PARAMS_APP->NumShowField[i]=0;
            PARAMS_APP->TypeField[i]=0;
        }

    }
//    SAVE
}
//------------------------------------------------------------------------------------------------------
- (void)GrowNumber:(int)Index WithType:(int)iType{
    
    NSMutableArray *pArray=m_pChildrenbjectsArr;
    
    GObject *pOb= [pArray objectAtIndex:Index];
    
    OBJECT_SET_PARAMS(NAME(pOb),
                      SET_INT(@"iType", iType),
                      SET_INT(@"m_iCurrentSym",m_ArrayField[Index]),
                      nil);

    m_ArrayField_Second[Index]=m_ArrayField[Index];
    OBJECT_PERFORM_SEL(NAME(pOb), @"SetType");
    
    SET_STAGE(pOb->m_strName, 1);
}
//------------------------------------------------------------------------------------------------------
- (void)Hint{
    
    NSMutableArray *pArray=[[NSMutableArray alloc] init];
    
//repeate:
    for (int i=0; i<81; i++) {
        if(m_ArrayField_Second[i]==0){
            [pArray addObject:[NSNumber numberWithInt:i]];
        }
    }

    int TmpInt=[pArray count];
    
 //   for (int i=0; i<TmpInt; i++) {
        if(TmpInt>0){

         //   int TmpNum=i;
            int TmpNum=RND%TmpInt;

            int iNum=[(NSNumber *)[pArray objectAtIndex:TmpNum] intValue];

            NSMutableArray *pArray=m_pChildrenbjectsArr;

            GObject *pOb= [pArray objectAtIndex:iNum];

            OBJECT_SET_PARAMS(NAME(pOb),
                              SET_INT(@"iType", 1),
                              SET_INT(@"m_iCurrentSym",m_ArrayField[iNum]),
                              nil);

            m_ArrayField_Second[iNum]=m_ArrayField[iNum];
            PARAMS_APP->NumShowField[iNum]=m_ArrayField[iNum];
            PARAMS_APP->TypeField[iNum]=1;
            OBJECT_PERFORM_SEL(NAME(pOb), @"SetType");

            SET_STAGE(pOb->m_strName, 2);
        }
//    }

    [pArray release];
    [self Validation];
    
    if(m_iCountError>0)PLAY_SOUND(iIdError);
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEndedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    if(ObAura)SET_STAGE(ObAura->m_strName,4);
}
//------------------------------------------------------------------------------------------------------
- (void)touchesEnded:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
	if(ObAura)SET_STAGE(ObAura->m_strName,4);
}
//------------------------------------------------------------------------------------------------------
- (void)ClearField{
    
    for (int i=0; i<81; i++) {
        m_ArrayField[i]=0;
        m_ArrayField_Second[i]=0;

        PARAMS_APP->NumShowField[i]=0;
        PARAMS_APP->NumHidenField[i]=0;
        PARAMS_APP->TypeField[i]=0;
    }

    //окончательное появление.
    for (GObject *pOb in m_pChildrenbjectsArr) {
        
        if(NAME(pOb)!=nil){
            if(pOb->m_bHiden)
            {
                DESTROY_OBJECT(pOb);
            }
            else{
                
                SET_STAGE(NAME(pOb), 8);
            }
        }
    }
    
    for (int i=0; i<9; i++) {
        PARAMS_APP->Numbers2[i]=0;  
    }
    
    [m_pChildrenbjectsArr removeAllObjects];
}
//------------------------------------------------------------------------------------------------------
- (void)logField{

    NSLog(@"//////////////////////////");

    for (int i=0; i<9; i++) {
        NSLog(@"%d%d%d %d%d%d %d%d%d",m_ArrayField[0+i*9],m_ArrayField[1+i*9],m_ArrayField[2+i*9]
              ,m_ArrayField[3+i*9],m_ArrayField[4+i*9],m_ArrayField[5+i*9]
              ,m_ArrayField[6+i*9],m_ArrayField[7+i*9],m_ArrayField[8+i*9]);
    }
    
    NSLog(@"//////////////////////Rows");
        for (int i=0; i<9; i++) {
            
            NSMutableString * result = [[NSMutableString alloc] init];
            for (NSObject * obj in pArrayCol[i])
            {
                [result appendString:[obj description]];
            }
            NSLog(@"%@", result);
        }
    NSLog(@"//////////////////////Columns");
    for (int i=0; i<9; i++) {
        
        NSMutableString * result = [[NSMutableString alloc] init];
        for (NSObject * obj in pArrayRow[i])
        {
            [result appendString:[obj description]];
        }
        NSLog(@"%@", result);
    }

    NSLog(@"//////////////////////Cell");
    for (int i=0; i<9; i++) {
        
        NSMutableString * result = [[NSMutableString alloc] init];
        for (NSObject * obj in pArray9X9[i])
        {
            [result appendString:[obj description]];
        }
        NSLog(@"%@", result);
    }

    NSLog(@"//////////////////////Empty");
    for (int i=0; i<9; i++) {
        
        NSMutableString * result = [[NSMutableString alloc] init];
        for (NSObject * obj in pEmpty[i])
        {
            [result appendString:[obj description]];
        }
        NSLog(@"%@", result);
    }

    
    int iCountRow=0;
    for (int i=0; i<9; i++) {
        iCountRow+=[pArrayRow[i] count];
    }
    
    int iCountCol=0;
    for (int i=0; i<9; i++) {
        iCountCol+=[pArrayCol[i] count];
    }
    
    int iCountEmpty=0;
    for (int i=0; i<9; i++) {
        iCountEmpty+=[pEmpty[i] count];
    }
    
  //  if(iCountEmpty!=iCountRow || iCountEmpty!=iCountCol)
//        int m=0;

}
//------------------------------------------------------------------------------------------------------
- (void)ResolveConflict:(int)j{
    int PosX3x3=j%3;
    int PosY3x3=j/3;
    
    int iSym9x9=(int)[[pArray9X9[j] objectAtIndex:0] intValue];

    [pRNDplase removeAllObjects];
    [pDelEmptyPlace removeAllObjects];
    
    for (NSNumber *pNum in pEmpty[j]) {
        int EmptyPlace=[pNum intValue]-1;
        
        int k=EmptyPlace/3;
        int l=EmptyPlace%3;
        
        int iSymCol=[[pArrayRow[k+PosY3x3*3] objectAtIndex:0] intValue];
        int iSymRow=[[pArrayCol[l+PosX3x3*3] objectAtIndex:0] intValue];
        
        int TmpPlace=(k+PosY3x3*3)*9+(l+PosX3x3*3);
        
        if((iSymCol==iSym9x9 || iSymRow==iSym9x9) && (iSymCol!=iSymRow)){
            [pRNDplase addObject:[NSNumber numberWithInt:TmpPlace]];
            [pDelEmptyPlace addObject:[NSNumber numberWithInt:EmptyPlace]];
        }
    }
    
    int CountRnd=[pRNDplase count];
    
    if(CountRnd==0){

        for (int k=0; k<3; k++) {
            for (int l=0; l<3;l++) {
                
                int iSymCol=[[pArrayRow[k+PosY3x3*3] objectAtIndex:0] intValue];
                int iSymRow=[[pArrayCol[l+PosX3x3*3] objectAtIndex:0] intValue];
                
                int TmpPlace=(k+PosY3x3*3)*9+(l+PosX3x3*3);
                
                if((iSymCol==iSym9x9 || iSymRow==iSym9x9) && (iSymCol!=iSymRow)){
                    
                    [pRNDplase addObject:[NSNumber numberWithInt:TmpPlace]];
                }
            }
        }
        
        int CountRnd=[pRNDplase count];

        if(CountRnd==0){
            
            NSLog(@"Chash2");
            [self logField];
            return;
        }
        int RndItem=RND%(CountRnd);
                
        int iPlace=[[pRNDplase objectAtIndex:RndItem] intValue];
        //                iPlace=iPlace*j;
        int OldSym = m_ArrayField[iPlace];
        
        m_ArrayField[iPlace]=iSym9x9;
        
        [pArray9X9[j] removeObjectAtIndex:0];

        int PosX9x9=iPlace%9;
        int PosY9x9=iPlace/9;
        
        int ItemCount=81;
        int UpSym=0;
        
        int SymCol=[[pArrayCol[PosX9x9] objectAtIndex:0] intValue];
        if(SymCol==iSym9x9){
            [pArrayCol[PosX9x9] removeObjectAtIndex:0];
        }
        else {
            for (int i=0; i<9; i++) {
                int TmpPlace=i*9+PosX9x9;
                
                if(iPlace==TmpPlace)continue;
                
                int tSym=m_ArrayField[TmpPlace];
                
                if(tSym==iSym9x9){
                     m_ArrayField[TmpPlace]=0;

                    ItemCount=TmpPlace;
                    UpSym=tSym;
                    
                    break;
                }
            }
        }
        
        int SymRow=[[pArrayRow[PosY9x9] objectAtIndex:0] intValue];
        if(SymRow==iSym9x9){
            [pArrayRow[PosY9x9] removeObjectAtIndex:0];
        }
        else {
    
            for (int i=0; i<9; i++) {
                int TmpPlace=PosY9x9*9+i;
                
                if(iPlace==TmpPlace)continue;
                
                int tSym=m_ArrayField[TmpPlace];
                
                if(tSym==iSym9x9){
                    m_ArrayField[TmpPlace]=0;
                    
                    ItemCount=TmpPlace;
                    UpSym=tSym;
                    
                    break;                
                }
            }
        }
               
        if(ItemCount!=81){
            
            int PosX3x3=ItemCount%9;
            int PosY3x3=ItemCount/9;
            
            NSNumber *Pnum= [NSNumber numberWithInt:UpSym];
            
            if(SymCol==UpSym){
                
                [pArrayCol[PosX3x3] insertObject:Pnum atIndex:0]; 
            }
            else if(SymRow==UpSym){
                
                [pArrayRow[PosY3x3] insertObject:Pnum atIndex:0];
            }
            
            int MinPosX3x3=PosX3x3/3;
            int MinPosY3x3=PosY3x3/3;
            
            int IndexCell=MinPosY3x3*3+MinPosX3x3;
            
            [pArray9X9[IndexCell] insertObject:Pnum atIndex:0]; //
            
            int EPlaceX3x3=ItemCount%3;
            int EPlaceY3x3=(ItemCount/9)%3;
            
            NSNumber *PnumEmptyPlace= [NSNumber numberWithInt:(EPlaceX3x3+EPlaceY3x3*3+1)];
            [pEmpty[IndexCell] insertObject:PnumEmptyPlace atIndex:0];
            
            if(OldSym!=0){
                
                NSNumber *SecondNum= [NSNumber numberWithInt:OldSym];
                
                [pArray9X9[j] insertObject:SecondNum atIndex:0];
                
                [pArrayCol[PosX9x9] insertObject:SecondNum atIndex:0]; 
                [pArrayRow[PosY9x9] insertObject:SecondNum atIndex:0];
                
                [self setSymbolWithIndex:j];
            }

            [self setSymbolWithIndex:IndexCell];
        }
        
        else if(OldSym!=0){
            NSNumber *SecondNum= [NSNumber numberWithInt:OldSym];
            
            [pArray9X9[j] insertObject:SecondNum atIndex:0];
            
            [pArrayCol[PosX9x9] insertObject:SecondNum atIndex:0]; 
            [pArrayRow[PosY9x9] insertObject:SecondNum atIndex:0];
            
            [self setSymbolWithIndex:j];

   //         [self logField];
            
        }

    }
    else{
        
        int RndItem=RND%(CountRnd);
        
        int iPlace=[[pRNDplase objectAtIndex:RndItem] intValue];
        
        m_ArrayField[iPlace]=iSym9x9;
        
        [pArray9X9[j] removeObjectAtIndex:0];
        
        int DelEmptyPlace=[[pDelEmptyPlace objectAtIndex:RndItem] intValue];
        
        int Inc=0;
        for (NSNumber *pNum in pEmpty[j]) {
            int EmptyPlace=[pNum intValue]-1;
            
            if(EmptyPlace==DelEmptyPlace)
                break;
            
            Inc++;
        }
        [pEmpty[j] removeObjectAtIndex:Inc];
        
        int PosX9x9=iPlace%9;
        int PosY9x9=iPlace/9;
        int ItemCount=81;
        
        int SymCol=[[pArrayCol[PosX9x9] objectAtIndex:0] intValue];
        if(SymCol==iSym9x9){
            [pArrayCol[PosX9x9] removeObjectAtIndex:0];
        }
        else {
            for (int i=0; i<9; i++) {
                int TmpPlace=i*9+PosX9x9;
                
                if(iPlace==TmpPlace)continue;
                
                int tSym=m_ArrayField[TmpPlace];
                
                if(tSym==iSym9x9){
                    m_ArrayField[TmpPlace]=0;
                    ItemCount=TmpPlace;
                    
                    break;
                }
            }
        }
        
        int SymRow=[[pArrayRow[PosY9x9] objectAtIndex:0] intValue];
        if(SymRow==iSym9x9){
            [pArrayRow[PosY9x9] removeObjectAtIndex:0];
        }
        else {
            for (int i=0; i<9; i++) {
                int TmpPlace=PosY9x9*9+i;
                
                if(iPlace==TmpPlace)continue;
                
                int tSym=m_ArrayField[TmpPlace];
                
                if(tSym==iSym9x9){
                    m_ArrayField[TmpPlace]=0;
                    
                    ItemCount=TmpPlace;
                    break;
                }
            }
        }
        
        
        if(ItemCount!=81){
            int PosX3x3=ItemCount%9;
            int PosY3x3=ItemCount/9;
            
            NSNumber *Pnum= [NSNumber numberWithInt:iSym9x9];

            if(SymCol==iSym9x9 && iSym9x9!=0){

                [pArrayCol[PosX3x3] insertObject:Pnum atIndex:0]; 
            }
            else if(SymRow==iSym9x9 && iSym9x9!=0){
                
                [pArrayRow[PosY3x3] insertObject:Pnum atIndex:0];
            }

            int MinPosX3x3=PosX3x3/3;
            int MinPosY3x3=PosY3x3/3;

            int IndexCell=MinPosY3x3*3+MinPosX3x3;
            
            if(iSym9x9!=0)
                [pArray9X9[IndexCell] insertObject:Pnum atIndex:0]; //
            
            int EPlaceX3x3=ItemCount%3;
            int EPlaceY3x3=(ItemCount/9)%3;
            
            NSNumber *PnumEmptyPlace= [NSNumber numberWithInt:(EPlaceX3x3+EPlaceY3x3*3+1)];
            [pEmpty[IndexCell] insertObject:PnumEmptyPlace atIndex:0];
            
      //      [self logField];

            [self setSymbolWithIndex:IndexCell];
        }
    }
}
//------------------------------------------------------------------------------------------------------
- (void)setSymbolWithIndex:(int)j{
    
    int PosX3x3=j%3;
    int PosY3x3=j/3;
    
    if([pArray9X9[j] count]==0)return;
    
    int iSym9x9=(int)[[pArray9X9[j] objectAtIndex:0] intValue];
    
    [pRNDplase removeAllObjects];
    [pDelEmptyPlace removeAllObjects];
    
    for (NSNumber *pNum in pEmpty[j]) {
        int EmptyPlace=[pNum intValue]-1;
        
        int k=EmptyPlace/3;
        int l=EmptyPlace%3;
        
        int iSymCol=[[pArrayRow[k+PosY3x3*3] objectAtIndex:0] intValue];
        int iSymRow=[[pArrayCol[l+PosX3x3*3] objectAtIndex:0] intValue];
        
        int TmpPlace=(k+PosY3x3*3)*9+(l+PosX3x3*3);
        
        if(iSymCol==iSym9x9 && iSymRow==iSym9x9){
            [pRNDplase addObject:[NSNumber numberWithInt:TmpPlace]];
            [pDelEmptyPlace addObject:[NSNumber numberWithInt:EmptyPlace]];
        }
    }
    
    int CountRnd=[pRNDplase count];
    
    if(CountRnd==0){
        
     //   [self logField];
        
        for (int k=0; k<3; k++) {
            for (int l=0; l<3;l++) {
                
                int iSymCol=[[pArrayRow[k+PosY3x3*3] objectAtIndex:0] intValue];
                int iSymRow=[[pArrayCol[l+PosX3x3*3] objectAtIndex:0] intValue];
                
                int TmpPlace=(k+PosY3x3*3)*9+(l+PosX3x3*3);
                
                if(iSymCol==iSym9x9 && iSymRow==iSym9x9){
                    
                    [pRNDplase addObject:[NSNumber numberWithInt:TmpPlace]];
                }
            }
        }
        
        int CountRnd=[pRNDplase count];
        
        if(CountRnd==0){
       //     [self logField];
            
            for (int k=0; k<9; k++) {
                    
                    int Inc=0;
                    for (NSNumber *pNum in pArrayRow[k]) {
                        int TmpInt=[pNum intValue];
                        if(TmpInt==iSym9x9){
                            break;
                        }
                        
                        Inc++;
                    }
                    
                    if(Inc!=0 && [pArrayRow[k] count]>Inc){
                        int iNumTmp=[[pArrayRow[k] objectAtIndex:Inc] intValue];
                        [pArrayRow[k] removeObjectAtIndex:Inc];
                        NSNumber * pTmpNum=[NSNumber numberWithInt:iNumTmp];
                        [pArrayRow[k] insertObject:pTmpNum atIndex:0];
                    }
            }
            
       //     [self logField];

            for (int k=0; k<9; k++) {
                
                int Inc=0;
                for (NSNumber *pNum in pArrayCol[k]) {
                    int TmpInt=[pNum intValue];
                    if(TmpInt==iSym9x9){
                        break;
                    }
                    
                    Inc++;
                }
                
                if(Inc!=0 && [pArrayCol[k] count]>Inc){
                    int iNumTmp=[[pArrayCol[k] objectAtIndex:Inc] intValue];
                    [pArrayCol[k] removeObjectAtIndex:Inc];
                    NSNumber * pTmpNum=[NSNumber numberWithInt:iNumTmp];
                    [pArrayCol[k] insertObject:pTmpNum atIndex:0];
                }
            }
            
            [self setSymbolWithIndex:j];
            return;
        }
        else{
            
            int RndItem=RND%(CountRnd);
            
            int iPlace=[[pRNDplase objectAtIndex:RndItem] intValue];
            
            int CurrentNum=m_ArrayField[iPlace];
            m_ArrayField[iPlace]=iSym9x9;
            
            [pArray9X9[j] removeObjectAtIndex:0];
            
            int PosX9x9=iPlace%9;
            int PosY9x9=iPlace/9;
            
            [pArrayCol[PosX9x9] removeObjectAtIndex:0];
            [pArrayRow[PosY9x9] removeObjectAtIndex:0]; 
            
            if(CurrentNum!=0){
            
                NSNumber *Pnum= [NSNumber numberWithInt:CurrentNum];
                
                [pArrayCol[PosX9x9] insertObject:Pnum atIndex:0]; 
                [pArrayRow[PosY9x9] insertObject:Pnum atIndex:0]; 
                
                [pArray9X9[j] insertObject:Pnum atIndex:0]; 
                
                //          NSLog(@"Conflict");
                //        [self logField];
                
                [self ResolveConflict:j];
                
                //      [self logField];
                
                //    NSLog(@"EndConflict2");

            }
        }
    }
    else{
        
        int RndItem=RND%(CountRnd);
        
        int iPlace=[[pRNDplase objectAtIndex:RndItem] intValue];
        //                iPlace=iPlace*j;
        m_ArrayField[iPlace]=iSym9x9;
        
        [pArray9X9[j] removeObjectAtIndex:0];
        
        int PosX9x9=iPlace%9;
        int PosY9x9=iPlace/9;
        
        [pArrayCol[PosX9x9] removeObjectAtIndex:0];
        [pArrayRow[PosY9x9] removeObjectAtIndex:0];
        
        int DelEmptyPlace=[[pDelEmptyPlace objectAtIndex:RndItem] intValue];
        
        int Inc=0;
        for (NSNumber *pNum in pEmpty[j]) {
            int EmptyPlace=[pNum intValue]-1;
            
            if(EmptyPlace==DelEmptyPlace)
                break;
            
            Inc++;
        }
        [pEmpty[j] removeObjectAtIndex:Inc];
    }     
}
//------------------------------------------------------------------------------------------------------
- (void)ResolveField:(int)i{
    
repeate:
    int MinValue=0;
    for (int k=0; k<9; k++) {
        
        if([pArray9X9[k] count]>0){
            
            MinValue=[[pArray9X9[k] objectAtIndex:0] intValue];
            
            if(MinValue-1<i){
                
         //       [self logField];
                [self setSymbolWithIndex:k];
                goto repeate;
            }
            
        }
    }

}
//------------------------------------------------------------------------------------------------------
- (void)CreateField{

    bool NewMetod=YES;

    if(NewMetod){
        
     //   NSLog(@"///////Start Generate field");
        
        pRNDplase=[[NSMutableArray alloc] init];
        pDelEmptyPlace=[[NSMutableArray alloc] init];

        for (int i=0; i<9; i++) {
            
            pArrayRow[i] = [[NSMutableArray alloc] init];
            pArrayCol[i] = [[NSMutableArray alloc] init];
            pArray9X9[i] = [[NSMutableArray alloc] init];
            pEmpty[i] = [[NSMutableArray alloc] init];
            
            for (int j=0; j<9; j++) {
                NSNumber *Pnum= [NSNumber numberWithInt:j+1];
                [pArrayRow[i] addObject:Pnum];
                [pArrayCol[i] addObject:Pnum];
                [pArray9X9[i] addObject:Pnum];
                [pEmpty[i]  addObject:Pnum];
            }
        }

        for (int i=0; i<9; i++) {
            
            [self ResolveField:i];

            for (int j=0; j<9; j++) {
                
                [self setSymbolWithIndex:j];
            }
        }
        
        for (int i=0; i<9; i++) {
            
            [pArrayRow[i] release];
            [pArrayCol[i] release];
            [pArray9X9[i] release];
            [pEmpty[i] release];
        }
        
        [pRNDplase release];
        [pDelEmptyPlace release];

    }
    else{
    
        NSMutableArray *pArray = [[NSMutableArray alloc] init];
        
        for (int j=0; j<9; j++) {
            NSNumber *Pnum= [NSNumber numberWithInt:j+1];
            [pArray addObject:Pnum];
        }
        
        for (int i=0; i<20; i++) {
            int RndCount=RND%[pArray count];
            NSNumber *Pnum= [pArray objectAtIndex:RndCount];
            [pArray removeObjectAtIndex:RndCount];
            [pArray insertObject:Pnum atIndex:0];
        }
        
        int curNum=0;
        NSNumber *Pnum=nil;
        
        for (int i=0; i<9; i++) {
            
            switch (i) {
                case 0:
                    curNum=0;
                    break;
                    
                case 1:
                    curNum=3;
                    break;
                    
                case 2:
                    curNum=6;
                    break;
                    
                case 3:
                    
                    Pnum= [pArray objectAtIndex:2];
                    [pArray removeObjectAtIndex:2];
                    [pArray insertObject:Pnum atIndex:0];
                    
                    Pnum= [pArray objectAtIndex:5];
                    [pArray removeObjectAtIndex:5];
                    [pArray insertObject:Pnum atIndex:3];
                    
                    Pnum= [pArray objectAtIndex:8];
                    [pArray removeObjectAtIndex:8];
                    [pArray insertObject:Pnum atIndex:6];
                    
                    curNum=0;
                    break;
                    
                case 4:
                    curNum=3;
                    break;
                    
                case 5:
                    curNum=6;
                    break;
                    
                case 6:
                    
                    Pnum= [pArray objectAtIndex:2];
                    [pArray removeObjectAtIndex:2];
                    [pArray insertObject:Pnum atIndex:0];
                    
                    Pnum= [pArray objectAtIndex:5];
                    [pArray removeObjectAtIndex:5];
                    [pArray insertObject:Pnum atIndex:3];
                    
                    Pnum= [pArray objectAtIndex:8];
                    [pArray removeObjectAtIndex:8];
                    [pArray insertObject:Pnum atIndex:6];
                    
                    curNum=0;
                    break;
                    
                case 7:
                    curNum=3;
                    break;
                    
                case 8:
                    curNum=6;
                    break;
                    
                    
                default:
                    break;
            }
            for (int j=0; j<9; j++) {
                
                m_ArrayField[j+i*9]=[[pArray objectAtIndex:curNum] intValue];
                curNum++;
                if(curNum>8)curNum=0;
            }
        }
        
        int One;
        int Two;
        
        for (int k=0; k<3; k++) {
            
            int MaxReplace=RND%3;
            for (int i=0; i<MaxReplace; i++) {
                
                One=(int)(RND%3);
            repeate:
                
                Two=(int)(RND%3);
                
                if(Two==One)goto repeate;
                
                [self ReplaceRow:(One+k*3) WithSecond:(Two+k*3)];
            }
        }
        
        for (int k=0; k<3; k++) {
            
            int MaxReplace=RND%3;
            for (int i=0; i<MaxReplace; i++) {
                
                One=(int)(RND%3);
            repeate2:
                Two=(int)(RND%3);
                
                if(Two==One)goto repeate2;
                
                [self ReplaceCol:(One+k*3) WithSecond:(Two+k*3)];
            }
        }  
    }
    
    //окончательное появление.
    for (int i=0; i<81; i++) {
        
        PARAMS_APP->NumHidenField[i]=m_ArrayField[i];
        PARAMS_APP->NumShowField[i]=0;

		float Xpos=(i%9)*(mWidth*.1095f)-mWidth*0.44f;
		float Ypos=(i/9)*(68.3f)-mHeight*0.5f+36;
        
		NSString* pName=[NSString stringWithFormat:@"Number%d", i];
        
		GObject *Ob = CREATE_NEW_OBJECT(@"ObjectNumSudoku",pName,
                            SET_POINT(@"m_pOwner",@"id",self),
                            SET_INT(@"m_iCurrentSym",m_ArrayField[i]),
                            SET_VECTOR(@"m_pOffsetCurPosition",(TmpVector1=Vector3DMake(Xpos,Ypos,0))),
                            SET_VECTOR(@"m_pCurPosition",(TmpVector2=Vector3DMake(0,-18,0))),
                            SET_INT(@"m_iCurNum", i),
                            SET_BOOL(@"m_bHiden",YES),
                            nil);
        
        [m_pChildrenbjectsArr addObject:Ob];
	}
    
    int CountNum=20+(2-m_iComplexity)*9;
    PARAMS_APP->iCompl=m_iComplexity;
    //появление
    for (int i=0; i<CountNum; i++) {
        
        if(m_ArrayField[i]==0)continue;
        
    repeateRnd:
        int TmpNum=RND%81;
        
        if(m_ArrayField_Second[TmpNum]!=0){goto repeateRnd;}
        
        int iType=1;
        [self GrowNumber:TmpNum WithType:iType];
        PARAMS_APP->TypeField[TmpNum]=iType;
        PARAMS_APP->NumShowField[TmpNum]=m_ArrayField[TmpNum];
        
    }
}
//------------------------------------------------------------------------------------------------------
- (void)LoadField{
        
    //окончательное появление.
    for (int i=0; i<81; i++) {

        m_ArrayField[i]=PARAMS_APP->NumHidenField[i];
        m_ArrayField_Second[i]=PARAMS_APP->NumShowField[i];
        
		float Xpos=(i%9)*(mWidth*.1095f)-mWidth*0.44f;
		float Ypos=(i/9)*(68.3f)-mHeight*0.5f+36;
        
		NSString* pName=[NSString stringWithFormat:@"Number%d", i];
        
		GObject *Ob = CREATE_NEW_OBJECT(@"ObjectNumSudoku",pName,
                            SET_POINT(@"m_pOwner",@"id",self),
                            SET_INT(@"m_iCurrentSym",m_ArrayField[i]),
                            SET_VECTOR(@"m_pOffsetCurPosition",(TmpVector1=Vector3DMake(Xpos,Ypos,0))),
                            SET_VECTOR(@"m_pCurPosition",(TmpVector2=Vector3DMake(0,-18,0))),
                            SET_INT(@"m_iCurNum", i),
                            SET_BOOL(@"m_bHiden",YES),
                            nil);
        
        [m_pChildrenbjectsArr addObject:Ob];
	}
    
    for (int i=0; i<9; i++) {
        PARAMS_APP->Numbers2[i]=0;  
    }

    //появление
    for (int i=0; i<81; i++) {
        
        if(PARAMS_APP->NumShowField[i]!=0){
            
            NSMutableArray *pArray=m_pChildrenbjectsArr;
            
            GObject *pOb= [pArray objectAtIndex:i];
            
            OBJECT_SET_PARAMS(NAME(pOb),
                              SET_INT(@"iType", PARAMS_APP->TypeField[i]),
                              SET_INT(@"m_iCurrentSym",m_ArrayField_Second[i]),
                              nil);
            
            OBJECT_PERFORM_SEL(NAME(pOb), @"SetType");
            
            SET_STAGE(pOb->m_strName, 1);

            
   //         [self GrowNumber:i WithType:PARAMS_APP->TypeField[i]];
        }
    }
    
    m_iCurIndex=-1;
    
    [self Validation];
}
//------------------------------------------------------------------------------------------------------
- (void)GenerateField{

    [self ClearField];
    [self CreateField];
    
    [self SetTouch:YES];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{

	[super Start];
	
    bool bload=NO;
    
    m_fPhase=0.1f;
    
    for (int i=0; i<81; i++){if(PARAMS_APP->TypeField[i]!=0){bload=YES;break;}}
    
    if(bload){
        [self SetTouch:YES];
        [self LoadField];
    }
    else [self GenerateField];
    
START_PROC(@"Proc");
    
	UP_SELECTOR(@"e00",@"Shake:");
    UP_TIMER(1,1,2500,@"timerWaitNextStage:");
    
END_PROC(@"Proc");
    
    SET_STAGE_EX(@"Field", @"ProcSave", 1);
    
    m_bGame=YES;
}
//------------------------------------------------------------------------------------------------------
- (void)save:(Processor *)pProc{
    SAVE;
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)MoveEx:(Processor *)pProc{

 //   if(m_iCountError>0)
 //   {
        m_fPhase+=DELTA*4;
        
        //if(m_fPhase>3.14*2)m_fPhase=0;
 //   }
}
//------------------------------------------------------------------------------------------------------
- (void)Move{}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
	float Xpos=Point.x-(m_pCurPosition.x-mWidth*0.499f);
	float Ypos=Point.y-(m_pCurPosition.y-mHeight*0.5f);
	int X=Xpos/(mWidth/9);
	int Y=Ypos/(mHeight/9);
//	float Bound=60;
	float OffsetX=0;

	NSMutableArray *pArray=m_pChildrenbjectsArr;

    GObject *pOb= [pArray objectAtIndex:(Y*9+X)];
    m_ArrayField_Second[Y*9+X]=0;
	
    int tmpType=GET_INT(NAME(pOb), @"iType");

    if(tmpType==1)
    {
        PLAY_SOUND(iIdStoun);
        return;
    }

	if(X==0)OffsetX=120;
	if(X==8)OffsetX=-120;

	if(X==1)OffsetX=50;
	if(X==7)OffsetX=-50;

	if(ObAura!=nil)SET_STAGE(ObAura->m_strName,4);
    
    float XposTmp=(X%9)*(mWidth*.1095f)-mWidth*0.44f;

    for (int i=0; i<9; i++) {
        PARAMS_APP->Numbers2[i]=0;
    }
    
    for (int i=0; i<81; i++) {
        if(m_ArrayField_Second[i]!=0){
            
            PARAMS_APP->Numbers2[m_ArrayField_Second[i]-1]++;
        }
    }
    
	ObAura =  CREATE_NEW_OBJECT(@"ObjectAura",@"aura",
                    SET_POINT(@"m_pOwner",@"id",self),
                    SET_STRING(@"m_pNameTexture",@"cloud.png"),
                    SET_INT(@"m_iLayer",layerInterfaceSpace4),
                    SET_INT(@"m_iPlace",X),
                    SET_FLOAT(@"m_fStartX",XposTmp),
                    SET_FLOAT(@"m_fCurrentTouchASS", Point.x),
                    SET_POINT(@"m_pCellNum",@"id",pOb),
                    SET_VECTOR(@"m_vOffsetStart",(TmpVector1=Vector3DMake(-OffsetX,0,0))),
                    SET_VECTOR(@"m_pCurPosition",
                (TmpVector2=Vector3DMake(pOb->m_pCurPosition.x+OffsetX,pOb->m_pCurPosition.y,0))),
                    SET_VECTOR(@"m_pCurAngle",(TmpVector3=Vector3DMake(0,0,0))),
                    nil);

    OBJECT_PERFORM_SEL(NAME(ObAura), @"reset");

	OBJECT_SET_PARAMS(pOb->m_strName,
                      SET_COLOR(@"mColor",(TmpColor1=Color3DMake(1.0f,1.0f,1.0f,0.0f))),
                      SET_BOOL(@"m_bHiden",NO),
                      SET_INT(@"m_iCurrentSym",10),
                      SET_BOOL(@"bError",NO),
                      nil);
    
    OBJECT_PERFORM_SEL(NAME(pOb), @"Error");
    
    OBJECT_PERFORM_SEL(NAME(pOb), @"Move");
    
//  PLAY_SOUND(iIdSound);
	
	UPDATE;
}
//------------------------------------------------------------------------------------------------------
- (void)touchesMovedOut:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{}
//------------------------------------------------------------------------------------------------------
- (void)Shake:(Processor *)pProc{
    Vector3D TmpVaccel=Vector3DMake(m_pParent->m_vAccel.x,m_pParent->m_vAccel.y,m_pParent->m_vAccel.z);
    
    float Magnitude = sqrtf(TmpVaccel.x*TmpVaccel.x+TmpVaccel.y*TmpVaccel.y+TmpVaccel.z*TmpVaccel.z);
    
    if(Magnitude>3.0f && m_bGame==NO){
        
        //окончательное появление.
        for (GObject *pOb in m_pChildrenbjectsArr) {
            
            if(NAME(pOb)!=nil){
                if(pOb->m_bHiden)
                {
                    DESTROY_OBJECT(pOb);
                }
                else{
                    
                    float m_fRotateVel=RND%400;
                    float Tmpf=(float)(RND%700)-500;
                    Vector3D m_Vvelosity=TmpVaccel;
                    m_Vvelosity.z=0;
                    
                    Vector3DNormalize(&m_Vvelosity);
                    
                    m_Vvelosity.x*=Tmpf;
                    m_Vvelosity.y*=Tmpf;

                    OBJECT_SET_PARAMS(NAME(pOb),
                                      SET_VECTOR(@"m_Vvelosity", m_Vvelosity),
                                      SET_FLOAT(@"m_fRotateVel", m_fRotateVel),
                                      nil);
                    
                    SET_STAGE(NAME(pOb), 9);
                }
            }
        }
        
        [m_pChildrenbjectsArr removeAllObjects];

        
        [self StartNewField];
        
        PLAY_SOUND(iIdShake);
        NEXT_STAGE;
    }
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc {[super dealloc];}
//------------------------------------------------------------------------------------------------------
@end
#undef NAME_TEMPLETS_OBJECT