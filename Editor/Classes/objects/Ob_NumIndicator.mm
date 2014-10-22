//
//  Ob_Templet.mm
//  Engine
//
//  Created by Konstantin on 21.11.10.
//  Copyright 2010 __FunDreamsInc__. All rights reserved.
//

#import "Ob_NumIndicator.h"
#import "Ob_Editor_Num.h"

@implementation Ob_NumIndicator
//------------------------------------------------------------------------------------------------------
- (id)Init:(id)Parent WithName:(NSString *)strName{
	self = [super Init:Parent WithName:strName];
	if (self != nil)
    {
        m_iLayer = layerOb5;
        m_iLayerTouch=layerTouch_0;//слой касания

        m_fScale=1.0f;
    }
    
	return self;
}
//------------------------------------------------------------------------------------------------------
- (void)SetDefault{m_bHiden=YES;}
//- (void)PostSetParams{}
//------------------------------------------------------------------------------------------------------
- (void)LinkValues{
    [super LinkValues];
    
    m_strNameContainer=[NSMutableString stringWithString:@"ParticlesScore"];
    [m_pObjMng->pMegaTree SetCell:LINK_STRING_V(m_strNameContainer,m_strName,@"m_strNameContainer")];

//====//процессоры для объекта==========================================================================

    Processor_ex *pProc = [self START_QUEUE:@"DTouch"];
        ASSIGN_STAGE(@"Idle", @"Idle:",nil)
        ASSIGN_STAGE(@"DoubleTouch", @"DoubleTouch:",SET_INT_V(300,@"TimeBaseDelay"));
    [self END_QUEUE:pProc name:@"DTouch"];
    
    pProc = [self START_QUEUE:@"Move"];
        ASSIGN_STAGE(@"Move", @"Move:", nil);
    [self END_QUEUE:pProc name:@"Move"];

//====//различные параметры=============================================================================
        
   [m_pObjMng->pMegaTree SetCell:
    [UniCell Link_Float:m_fCurValue withKey:m_strName,@"m_fCurValue",nil]];
    
    [m_pObjMng->pMegaTree SetCell:(LINK_FLOAT_V(m_fScale,m_strName,@"m_fScale"))];
    
//    m_strNameObject=[NSMutableString stringWithString:@""];    
//    [m_pObjMng->pMegaTree SetCell:(LINK_STRING_V(m_strNameSound,m_strName,@"m_strNameSound"))];
}
//------------------------------------------------------------------------------------------------------
- (void)Start{
    
    m_pCurPosition.x = 30000;

//    m_bHiden=YES;
    m_fWNumber=26*m_fScale;
    WSym=28*m_fScale;
    HSym=50*m_fScale;
    mColor= Color3DMake(.1f, .1f, .1f, 1);
    
  //  [m_pNameTexture setString:@"Line.png"];

    //   GET_DIM_FROM_TEXTURE(@"");
	mWidth  = 50;
	mHeight = 20;

	[super Start];

    [self SetTouch:YES];//интерактивность
    GET_TEXTURE(mTextureId, m_pNameTexture);
        
    for (int i=0; i<20; i++) {
		
		GObject *Ob = UNFROZE_OBJECT(@"ObjectAlNumber",([NSString stringWithFormat:@"sym%d", i]),
                         SET_INT_V(3,@"m_iCurrentSym"),
                         LINK_ID_V(self,@"m_pOwner"),
                         SET_INT_V(0,@"m_iCurrentSym"),
                         SET_VECTOR_V(Vector3DMake(i*m_fWNumber,0,0),@"m_pOffsetCurPosition"),
                         SET_BOOL_V(YES,@"m_bHiden"),
                         SET_BOOL_V(m_bNoOffset,@"m_bNoOffset"),
                         SET_FLOAT_V(WSym,@"mWidth"),
                         SET_FLOAT_V(HSym,@"mHeight"),
                         SET_BOOL_V(m_bNoOffset, @"m_bNoOffset"),
                         SET_STRING_V(m_strNameContainer,@"m_strNameContainer"),
                         SET_INT_V(m_iLayer+1,@"m_iLayer"));
        
		[m_pChildrenbjectsArr addObject:Ob];
	}
    
    OBJECT_PERFORM_SEL(NAME(self), @"Move:");
    [self UpdateNum];
}
//------------------------------------------------------------------------------------------------------
- (void)UpdateNum{
    
    [self DeleteFromDraw];
    float TmpValue=0.0f;
    if(m_fCurValue!=0)TmpValue = *m_fCurValue;
    else return;
    
    [self AddToDraw];

    NSString *FloatString = [NSString stringWithFormat:@"%1.3f",TmpValue];

    unichar* ucBuff = (unichar*)calloc([FloatString length], sizeof(unichar));

	[FloatString getCharacters:ucBuff];
    int len = [FloatString length];
    
repeate:
    if(len>2 && ucBuff[len-1]=='0' && ucBuff[len-2]!='.')
    {
        ucBuff[len-1]=0;
        len--;
        goto repeate;
    }
	
	NSMutableArray *TmpArr=m_pChildrenbjectsArr;
    
    if([TmpArr count]==0)return;
    
	for (int i=0; i< [TmpArr count]; i++)
    {
        OBJECT_PERFORM_SEL(((GObject *)[TmpArr objectAtIndex:i])->m_strName, @"HideNum");
    }

    float W=WSym*len*0.5f;
    mWidth  = W;
    m_pCurScale.x=W;
    
    int NumText;
    float fStartPos = -W+WSym;
    
    for (int i=0; i< len; i++)
    {
        GObject *pOb=(GObject *)[TmpArr objectAtIndex:i];
        
        switch (ucBuff[i]) {
            case '0':
                NumText=0;
                break;

            case '1':
                NumText=10;
                break;

            case '2':
                NumText=20;
                break;

            case '3':
                NumText=30;
                break;

            case '4':
                NumText=40;
                break;

            case '5':
                NumText=50;
                break;

            case '6':
                NumText=60;
                break;

            case '7':
                NumText=70;
                break;

            case '8':
                NumText=80;
                break;

            case '9':
                NumText=90;
                break;

            case '-':
                NumText=100;
                break;

            case '.':
                NumText=101;
                break;

            default:
                NumText=0;
                break;
        }
        float fW=m_fWNumber;
        
        if(ucBuff[i]=='.' || (ucBuff[i+1]=='.' && (i+1)<len))
            fW*=0.6f;
            
        OBJECT_SET_PARAMS(pOb->m_strName,
                SET_INT_V(NumText,@"m_iCurrentSym"),
                SET_VECTOR_V(Vector3DMake(fStartPos,0,0),@"m_pOffsetCurPosition"));
        
        fStartPos+=fW;
        
 //       OBJECT_PERFORM_SEL(NAME(pOb), @"ShowNum");
        OBJECT_PERFORM_SEL(NAME(pOb), @"Move:");
    }
    
    free(ucBuff);
}
//------------------------------------------------------------------------------------------------------
- (void)Update{}
//------------------------------------------------------------------------------------------------------
- (void)DoubleTouch:(Processor_ex *)pProc{
    
    m_bDoubleTouch=NO;
    NEXT_STAGE;
}
//------------------------------------------------------------------------------------------------------
- (void)Move:(Processor_ex *)pProc{
    
    [self SetPosWithOffsetOwner];
}
//------------------------------------------------------------------------------------------------------
- (void)InitProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)PrepareProc:(ProcStage_ex *)pStage{}
//------------------------------------------------------------------------------------------------------
- (void)Proc:(Processor_ex *)pProc{
    
//    PLAY_SOUND(@"");
//    STOP_SOUND(@"");
}
//------------------------------------------------------------------------------------------------------
- (void)Destroy{
    
    NSMutableArray *TmpArr=m_pChildrenbjectsArr;
    
    int TmpCount=[TmpArr count];
	for (int i=0; i< TmpCount; i++){
        
        DESTROY_OBJECT((GObject *)[TmpArr objectAtIndex:0]);
        [TmpArr removeObjectAtIndex:0];
    }

    [TmpArr removeAllObjects];
    m_fCurValue=0;
    [super Destroy];
}
//------------------------------------------------------------------------------------------------------
- (void)touchesBegan:(UITouch *)CurrentTouch WithPoint:(CGPoint)Point{
    
    if(m_bDoubleTouch==YES){
        
        m_bDoubleTouch=YES;
        
 //       Ob_Editor_Num *EditorNum =  UNFROZE_OBJECT(@"Ob_Editor_Num",@"Editor_Num",nil);
        
//        EditorNum->pObInd->m_fCurValue=m_fCurValue;
//        [EditorNum->pObInd UpdateNum];
    }
    else{
        NEXT_STAGE_EX(NAME(self), @"DTouch")
        m_bDoubleTouch=YES;
    }
}
//------------------------------------------------------------------------------------------------------
@end