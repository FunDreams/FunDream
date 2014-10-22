//
//  MainCycle.m
//  FunDreams
//
//  Created by Konstantin on 19.03.13.
//  Copyright (c) 2013 FunDreams. All rights reserved.
//

#import "MainCycle.h"
#import "Ob_ParticleCont_ForStr.h"

@implementation MainCycle
//------------------------------------------------------------------------------------------------------
-(id)init:(id)Parent{
    
    self = [super init];
    
    if(self)
    {
        m_pContainer=Parent;
        ppHelpData=[m_pContainer->m_OperationIndex InitMemory];
        ppTmpData=[m_pContainer->m_OperationIndex InitMemory];

        ppXtouchBegin=[m_pContainer->m_OperationIndex InitMemory];
        ppYtouchBegin=[m_pContainer->m_OperationIndex InitMemory];
        ppNumtouchBegin=[m_pContainer->m_OperationIndex InitMemory];

        ppXtouchMove=[m_pContainer->m_OperationIndex InitMemory];
        ppYtouchMove=[m_pContainer->m_OperationIndex InitMemory];
        ppNumtouchMove=[m_pContainer->m_OperationIndex InitMemory];

        ppXtouchEnd=[m_pContainer->m_OperationIndex InitMemory];
        ppYtouchEnd=[m_pContainer->m_OperationIndex InitMemory];
        ppNumtouchEnd=[m_pContainer->m_OperationIndex InitMemory];
        
        ppLockTouch=[m_pContainer->m_OperationIndex InitMemory];
        [m_pContainer->m_OperationIndex SetCopasity:10 WithData:ppLockTouch];
    }
    return self;
}
//------------------------------------------------------------------------------------------------------
-(void)Update:(FractalString *)StartString Place:(int)iPlaceTmp
{//главный цикл обработки матрицы
    
    float pDeltaTime=(m_pContainer->ArrayPoints->pData)[Ind_DELTATIME];
    FunArrayData *ArrayPoints=m_pContainer->ArrayPoints;
    FunArrayDataIndexes *OperationIndex=m_pContainer->m_OperationIndex;
    Ob_ParticleCont_ForStr *pParContainer=ArrayPoints->pCurrenContPar;

    iTextureName=-1;
//инициализируем стэк---------------------------------------------------------------------
    InfoArrayValue *InfoParMatrix=(InfoArrayValue *)(*m_pContainer->pParMatrixStack);
    InfoArrayValue *InfoCurPlace=(InfoArrayValue *)(*m_pContainer->pCurPlaceStack);
    
    int *StartDataParMatrix=((*m_pContainer->pParMatrixStack)+SIZE_INFO_STRUCT);
    int *StartDataCurPlace=((*m_pContainer->pCurPlaceStack)+SIZE_INFO_STRUCT);
//----------------------------------------------------------------------------------------
    if(StartString==nil)return;
    MATRIXcell *pCurrentMatr=[ArrayPoints GetMatrixAtIndex:StartString->m_iIndex];
    if(pCurrentMatr==nil)return;
    
    MATRIXcell *pParMatrix = [ArrayPoints GetMatrixAtIndex:StartString->pParent->m_iIndex];
    if(pParMatrix==nil)return;

    if(iPlaceTmp!=-1)
        iCurrentPlace=iPlaceTmp;
    else
    {
        iCurrentPlace=*(*pParMatrix->ppStartPlaces+SIZE_INFO_STRUCT);
        if(iCurrentPlace==-1)return;
    }
    
    pQueue=(*pParMatrix->pQueue)+SIZE_INFO_STRUCT;
    pHeart=(HeartMatr *)pQueue[iCurrentPlace];
    if(pHeart==nil)return;
/////////////////////////////////////////////////////////////////////////////////////
LOOP://бесконечный цикл

    switch (pCurrentMatr->TypeInformation)
    {
//операции===========================================================================
        case STR_OPERATION:

        switch (pCurrentMatr->NameInformation)
        {
//операция move---------------------------------------------------------------------
            case NAME_O_PROCEDURE:
                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  );//parametr
                if(iIndexTmp1<RESERV_KERNEL)break;
                
                ppArr1=*(pppData+iIndexTmp1);//parametr
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                
                iIndexTmp4=(*ppArr1+SIZE_INFO_STRUCT)[0];
                F1=pDataLocal+iIndexTmp4;

                [m_pContainer spesProc:(int)*F1];

                break;
//операция find----------------------------------------------------------------------
            case NAME_O_FIND:
                
                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  );//Dest
                iIndexTmp2=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1);//find
                iIndexTmp3=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );//YES
                iIndexTmp4=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1);//NO
                iIndexTmp5=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+2);//PLACE
                
                if(iIndexTmp1<RESERV_KERNEL)break;
                if(iIndexTmp2<RESERV_KERNEL)break;
                if(iIndexTmp5<RESERV_KERNEL)break;
                if(iIndexTmp3<RESERV_KERNEL && iIndexTmp4<RESERV_KERNEL)break;

                ppArr1=*(pppData+iIndexTmp1);//DEST
                ppArr2=*(pppData+iIndexTmp2);//FIND
                ppArr3=*(pppData+iIndexTmp3);//YES
                ppArr4=*(pppData+iIndexTmp4);//NO
                ppArr5=*(pppData+iIndexTmp5);//PLACE
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;//DEST
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;//FIND
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;//YES
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;//NO
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;//PLACE
                
                if(pInfoTmp1->mCount==0)break;
                if(pInfoTmp2->mCount==0)break;
                
                if(iIndexTmp3>RESERV_KERNEL)
                {
                    [OperationIndex SetCopasity:pInfoTmp2->mCount WithData:ppArr3];
                    pInfoTmp3 = (InfoArrayValue *)*ppArr3;//YES
                    pInfoTmp3->mCount=0;
                }

                if(iIndexTmp4>RESERV_KERNEL)
                {
                    [OperationIndex SetCopasity:pInfoTmp2->mCount WithData:ppArr4];
                    pInfoTmp4 = (InfoArrayValue *)*ppArr4;//NO
                    pInfoTmp4->mCount=0;
                }
                
                iCountLoop=pInfoTmp2->mCount;// по find
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
    //            FData5=SData5+pInfoTmp5->mCount-1;

LOOP_FIND_SPACE:;
                if(iCountLoop==0)break;
                iCountLoop--;

                if(iIndexTmp3>RESERV_KERNEL)
                {
                    for (i=0; i<pInfoTmp1->mCount; i++)
                    {
                        if(SData1[i]==*SData2)
                        {
                            iIndexTmp6=SData5[*SData2];
                            F1=(pDataLocal+iIndexTmp6);
                            *F1=i;
                            
                            SData3[pInfoTmp3->mCount]=*SData2;
                            pInfoTmp3->mCount++;
                            
                            goto NEXT_PLACE;
                        }
                    }
                }
                
                if(iIndexTmp4>RESERV_KERNEL)
                {
                    SData4[pInfoTmp4->mCount]=*SData2;
                    pInfoTmp4->mCount++;
                }
NEXT_PLACE:
                if(SData2!=FData2)SData2++;
//                if(SData5!=FData5)SData5++;
                
                goto LOOP_FIND_SPACE;
                break;
//операция size----------------------------------------------------------------------
            case NAME_O_SIZE:
                
                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  );
                iIndexTmp2=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1);
                iIndexTmp3=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );

                if(iIndexTmp3<RESERV_KERNEL)break;
                ppArr3=*(pppData+iIndexTmp3);//R
                iIndexTmp4=(*ppArr3+SIZE_INFO_STRUCT)[0];
                F1=pDataLocal+iIndexTmp4;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;//REZ

                if(iIndexTmp1>RESERV_KERNEL)
                {
                    ppArr1=*(pppData+iIndexTmp1);//1
                    pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                    
                    if(pInfoTmp3->mType==DATA_INT)
                        *F1=(int)pInfoTmp1->mCount;
                    else *F1=pInfoTmp1->mCount;
                }
                else if(iIndexTmp2>RESERV_KERNEL)
                {
                    ppArr2=*(pppData+iIndexTmp2);//2
                    pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                    
                    if(pInfoTmp3->mType==DATA_INT)
                        *F1=(int)pInfoTmp2->mCount;
                    else *F1=pInfoTmp2->mCount;
                }

                break;
//операция summa----------------------------------------------------------------------
            case NAME_O_SUMMA:
                
                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  );
                iIndexTmp2=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1);
                iIndexTmp3=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                
                if(iIndexTmp3<RESERV_KERNEL)break;
                ppArr3=*(pppData+iIndexTmp3);//R
                iIndexTmp4=(*ppArr3+SIZE_INFO_STRUCT)[0];
                F1=pDataLocal+iIndexTmp4;

                ppArr1=*(pppData+iIndexTmp1);//Sum
                ppArr2=*(pppData+iIndexTmp2);//ObSum

                pInfoTmp1 = (InfoArrayValue *)*ppArr1;//S
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;//ObS
                if(pInfoTmp2->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;

                iCountLoop=pInfoTmp2->mCount;
                tmpf=0;
LOOP_SUM:;
                if(iCountLoop==0)
                {
                    *F1=tmpf;
                    break;
                }
                
                iCountLoop--;

                F2=(pDataLocal+SData1[*SData2]);//value
                tmpf+=*F2;
                
                if(SData2!=FData2)SData2++;

                goto LOOP_SUM;
                break;
//операция play sound---------------------------------------------------------------
            case NAME_O_PLAY_SOUND:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//S
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObS
                
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//P
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObP

                ppArr5=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+4));//V
                ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+5));//ObV

                pInfoTmp1 = (InfoArrayValue *)*ppArr1;//S
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;//ObS
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;//P
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;//ObP
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;//V
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;//ObV

                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;

                iMinCount=0;
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;

                iCountLoop=iMinCount;

LOOP_PLAY_SOUND:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                F1=(pDataLocal+SData1[*SData2]);//Sound
                ResourceCell *TmpCell=pParContainer->pSoundRes->pCells+(int)*F1;
                
                F2=(pDataLocal+SData3[*SData4]);//Pitch
                F3=(pDataLocal+SData5[*SData6]);//Volume
                
                [self->m_pContainer->m_pObjMng->m_pParent
                        PlaySoundMatrix:TmpCell->iName pitch:*F2 volume:*F3];
                
                if(SData2!=FData2)SData2++;
                if(SData4!=FData4)SData4++;
                if(SData6!=FData6)SData6++;
                
                goto LOOP_PLAY_SOUND;
                break;
//операция touch begin---------------------------------------------------------------
            case NAME_O_TOUCH_BEG:
                
                pInfoTmp16 = (InfoArrayValue *)*ppNumtouchBegin;//Touch begin
                if(pInfoTmp16->mCount==0)break;
                pInfoTmp17 = (InfoArrayValue *)*ppXtouchBegin;//Touch X
                pInfoTmp18 = (InfoArrayValue *)*ppYtouchBegin;//Touch Y
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//Lock
                
                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1);
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr2=*(pppData+iIndexTmp1);//Source Array
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//X
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObX
                ppArr5=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+4));//Y
                ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+5));//ObY
                ppArr7=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+6));//W
                ppArr8=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+7));//ObW
                ppArr9=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+8));//H
                ppArr10=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+9));//ObH
                ppArr11=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+10));//A
                ppArr12=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+11));//ObA

                pInfoTmp2 = (InfoArrayValue *)*ppArr2;//ObSource
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;//ObX
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;//ObY
                pInfoTmp8 = (InfoArrayValue *)*ppArr8;//ObW
                pInfoTmp10 = (InfoArrayValue *)*ppArr10;//ObH
                pInfoTmp12 = (InfoArrayValue *)*ppArr12;//ObA

                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                if(pInfoTmp8->mCount==0)break;
                if(pInfoTmp10->mCount==0)break;
                if(pInfoTmp12->mCount==0)break;
                
                iIndexTmp2=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                ppArr13=*(pppData+iIndexTmp2);//Yes
                if(iIndexTmp2>RESERV_KERNEL){
                    
                    [OperationIndex SetCopasity:pInfoTmp16->mCount WithData:ppArr13];
                    ppArr13=*(pppData+iIndexTmp2);//ObYES
                    pInfoTmp13 = (InfoArrayValue *)*ppArr13;//ObYES
                    pInfoTmp13->mCount=0;
                }

                iIndexTmp3=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1);
                ppArr14=*(pppData+iIndexTmp3);//Yes
                if(iIndexTmp3>RESERV_KERNEL){
                    
                    [OperationIndex SetCopasity:pInfoTmp16->mCount WithData:ppArr14];
                    ppArr14=*(pppData+iIndexTmp3);//ObNo
                    pInfoTmp14 = (InfoArrayValue *)*ppArr14;//ObNo
                    pInfoTmp14->mCount=0;
                }

                iIndexTmp4=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+2);
                ppArr15=*(pppData+iIndexTmp4);//T
                iIndexTmp5=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+3);
                ppArr16=*(pppData+iIndexTmp5);//X
                iIndexTmp6=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+4);
                ppArr17=*(pppData+iIndexTmp6);//Y
//////////////////////////////////////////////////////////////////////////////////////////////
                iIndexTmp7=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+10);
                if(iIndexTmp7<RESERV_KERNEL)break;
                ppArr21=*(pppData+iIndexTmp7);//ArrayObjects
                pInfoTmp21 = (InfoArrayValue *)*ppArr21;//ArrayObjects

                iIndexTmp8=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+5);
                ppArr22=*(pppData+iIndexTmp8);//YES
                if(iIndexTmp8>RESERV_KERNEL){
                    
                    [OperationIndex SetCopasity:pInfoTmp21->mCount WithData:ppArr22];
                    ppArr22=*(pppData+iIndexTmp8);//ObYES
                    pInfoTmp22 = (InfoArrayValue *)*ppArr22;//ObYES
                    pInfoTmp22->mCount=0;
                }
                
                iIndexTmp9=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+6);
                ppArr23=*(pppData+iIndexTmp9);//Yes
                if(iIndexTmp9>RESERV_KERNEL){
                    
                    [OperationIndex SetCopasity:pInfoTmp21->mCount WithData:ppArr23];
                    ppArr23=*(pppData+iIndexTmp9);//ObNo
                    pInfoTmp23 = (InfoArrayValue *)*ppArr23;//ObNo
                    pInfoTmp23->mCount=0;
                }
                
                iIndexTmp10=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+7);
                ppArr24=*(pppData+iIndexTmp10);//T2
                iIndexTmp11=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+8);
                ppArr25=*(pppData+iIndexTmp11);//X2
                iIndexTmp12=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+9);
                ppArr26=*(pppData+iIndexTmp12);//Y2
                
                pInfoTmp21 = (InfoArrayValue *)*ppArr21;//ObArrayObject
                if(pInfoTmp21->mCount==0)break;
//////////////////////////////////////////////////////////////////////////////////////////////
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                SData7=(*ppArr7+SIZE_INFO_STRUCT);
                SData8=(*ppArr8+SIZE_INFO_STRUCT);
                SData9=(*ppArr9+SIZE_INFO_STRUCT);
                SData10=(*ppArr10+SIZE_INFO_STRUCT);
                SData11=(*ppArr11+SIZE_INFO_STRUCT);
                SData12=(*ppArr12+SIZE_INFO_STRUCT);
                SData13=(*ppArr13+SIZE_INFO_STRUCT);
                SData14=(*ppArr14+SIZE_INFO_STRUCT);
                SData15=(*ppArr15+SIZE_INFO_STRUCT);
                SData16=(*ppNumtouchBegin+SIZE_INFO_STRUCT);
                SData17=(*ppXtouchBegin+SIZE_INFO_STRUCT);
                SData18=(*ppYtouchBegin+SIZE_INFO_STRUCT);
                SData19=(*ppArr16+SIZE_INFO_STRUCT);
                SData20=(*ppArr17+SIZE_INFO_STRUCT);
                SData21=(*ppArr21+SIZE_INFO_STRUCT);//obsource
                SData22=(*ppArr22+SIZE_INFO_STRUCT);//YES
                SData23=(*ppArr23+SIZE_INFO_STRUCT);//NO
                SData24=(*ppArr24+SIZE_INFO_STRUCT);//T2
                SData25=(*ppArr25+SIZE_INFO_STRUCT);//X2
                SData26=(*ppArr26+SIZE_INFO_STRUCT);//Y2
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                FData8=SData8+pInfoTmp8->mCount-1;
                FData10=SData10+pInfoTmp10->mCount-1;
                FData12=SData12+pInfoTmp12->mCount-1;
                FData21=SData21+pInfoTmp21->mCount-1;

                iMinCount=0;
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                if(pInfoTmp8->mCount>iMinCount)
                    iMinCount=pInfoTmp8->mCount;
                if(pInfoTmp10->mCount>iMinCount)
                    iMinCount=pInfoTmp10->mCount;
                if(pInfoTmp12->mCount>iMinCount)
                    iMinCount=pInfoTmp12->mCount;

                iMinCountTmp=iMinCount;
                iValue=*(pDataLocal+*(*ppArr1+SIZE_INFO_STRUCT));//lock
                iCountLoop=pInfoTmp2->mCount;
                
                //ограничение по количеству
             //   if(iCountLoop>pInfoTmp16->mCount)
                iCountLoop=pInfoTmp16->mCount;
                
                for (j=0; j<iCountLoop; j++)//по всем касаниям
                {
                    iMinCount=iMinCountTmp;
                    
                    SData4=(*ppArr4+SIZE_INFO_STRUCT);
                    SData6=(*ppArr6+SIZE_INFO_STRUCT);
                    SData8=(*ppArr8+SIZE_INFO_STRUCT);
                    SData10=(*ppArr10+SIZE_INFO_STRUCT);
                    SData12=(*ppArr12+SIZE_INFO_STRUCT);
                    SData21=(*ppArr21+SIZE_INFO_STRUCT);//obsource
                    
                    CGPoint tmpPointDif;
                    tmpPointDif.x=SData17[j];
                    tmpPointDif.y=SData18[j];
                    float NumTouch=(float)SData16[j];
                    bool TouchYES=NO;
                    
                    if((*ppLockTouch+SIZE_INFO_STRUCT)[(int)(NumTouch)]==1)continue;
LOOP_TOUCH_BEGIN:
                    if(iMinCount==0)goto END_TOUCH_BEG;
                    iMinCount--;

                    F2=(pDataLocal+SData3[*SData4]);//X
                    F3=(pDataLocal+SData5[*SData6]);//Y
                    F4=(pDataLocal+SData7[*SData8]);//W
                    F5=(pDataLocal+SData9[*SData10]);//H
                    F6=(pDataLocal+SData11[*SData12]);//A

                    Vector3D VstartPoint = Vector3DMake(tmpPointDif.x-*F2,tmpPointDif.y-*F3,0);
                    Vector3D TmpRotate=Vector3DRotateZ2D(VstartPoint,(*F6*57.3248f));
                    
                    if(iIndexTmp10>RESERV_KERNEL)
                        *(pDataLocal+SData24[*SData21])=NumTouch;
                    if(iIndexTmp11>RESERV_KERNEL)
                        *(pDataLocal+SData25[*SData21])=tmpPointDif.x;
                    if(iIndexTmp12>RESERV_KERNEL)
                        *(pDataLocal+SData26[*SData21])=tmpPointDif.y;

                    if((TmpRotate.x<=(*F4)*0.5f)&&(TmpRotate.x>=(-(*F4)*0.5f))&&
                       (TmpRotate.y<=(*F5)*0.5f)&&(TmpRotate.y>=(-(*F5)*0.5f)))
                    {
                        if(iIndexTmp8>RESERV_KERNEL)
                        {
                            [OperationIndex OnlyAddData:*SData21 WithData:ppArr22];
                        }

                        TouchYES=YES;
                        
                        if(iValue>0)
                        {
                            (*ppLockTouch+SIZE_INFO_STRUCT)[(int)(NumTouch)]=1;
                            goto END_TOUCH_BEG;
                        }
                    }
                    else
                    {
                        if(iIndexTmp9>RESERV_KERNEL)
                        {
                            [OperationIndex OnlyAddData:*SData21 WithData:ppArr23];
                        }
                    }
                    
                
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    if(SData8!=FData8)SData8++;
                    if(SData10!=FData10)SData10++;
                    if(SData12!=FData12)SData12++;
                    if(SData21!=FData21)SData21++;//source object

                    goto LOOP_TOUCH_BEGIN;
END_TOUCH_BEG:;
                    if(iIndexTmp2>RESERV_KERNEL && TouchYES==YES)
                    {
                        [OperationIndex OnlyAddData:*SData2 WithData:ppArr13];
                    }
                    if(iIndexTmp3>RESERV_KERNEL && TouchYES==NO)
                    {
                        [OperationIndex OnlyAddData:*SData2 WithData:ppArr14];
                    }
                    
                    if(iIndexTmp4>RESERV_KERNEL)
                        *(pDataLocal+SData15[*SData2])=NumTouch;
                    
                    if(iIndexTmp5>RESERV_KERNEL)
                        *(pDataLocal+SData19[*SData2])=tmpPointDif.x;
                    if(iIndexTmp6>RESERV_KERNEL)
                        *(pDataLocal+SData20[*SData2])=tmpPointDif.y;

                    if(SData2!=FData2)SData2++;//source array
                }
                break;
//операция touch move---------------------------------------------------------------
            case NAME_O_TOUCH_MOVE:
                
                pInfoTmp16 = (InfoArrayValue *)*ppNumtouchMove;//Touch move
                if(pInfoTmp16->mCount==0)break;
                pInfoTmp17 = (InfoArrayValue *)*ppXtouchMove;//Touch X
                pInfoTmp18 = (InfoArrayValue *)*ppYtouchMove;//Touch Y
                                
                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr2=*(pppData+iIndexTmp1);//Source Array
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//X
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//ObX
                ppArr5=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//Y
                ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+4));//ObY
                ppArr7=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+5));//W
                ppArr8=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+6));//ObW
                ppArr9=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+7));//H
                ppArr10=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+8));//ObH
                ppArr11=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+9));//A
                ppArr12=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+10));//ObA
                
                iIndexTmp4=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+11);
                ppArr15=*(pppData+iIndexTmp4);//T
                
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;//ObSource
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;//ObX
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;//ObY
                pInfoTmp8 = (InfoArrayValue *)*ppArr8;//ObW
                pInfoTmp10 = (InfoArrayValue *)*ppArr10;//ObH
                pInfoTmp12 = (InfoArrayValue *)*ppArr12;//ObA
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                if(pInfoTmp8->mCount==0)break;
                if(pInfoTmp10->mCount==0)break;
                if(pInfoTmp12->mCount==0)break;
                
                iIndexTmp2=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                ppArr13=*(pppData+iIndexTmp2);//Yes
                if(iIndexTmp2>RESERV_KERNEL){
                    
                    [OperationIndex SetCopasity:pInfoTmp2->mCount WithData:ppArr13];
                    ppArr13=*(pppData+iIndexTmp2);//ObYES
                    pInfoTmp13 = (InfoArrayValue *)*ppArr13;//ObYES
                    pInfoTmp13->mCount=0;
                }
                
                iIndexTmp3=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1);
                ppArr14=*(pppData+iIndexTmp3);//Yes
                if(iIndexTmp3>RESERV_KERNEL){
                    
                    [OperationIndex SetCopasity:pInfoTmp2->mCount WithData:ppArr14];
                    ppArr14=*(pppData+iIndexTmp3);//ObNo
                    pInfoTmp14 = (InfoArrayValue *)*ppArr14;//ObNo
                    pInfoTmp14->mCount=0;
                }
                
                iIndexTmp5=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+2);
                ppArr16=*(pppData+iIndexTmp5);//X
                iIndexTmp6=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+3);
                ppArr17=*(pppData+iIndexTmp6);//Y
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                SData7=(*ppArr7+SIZE_INFO_STRUCT);
                SData8=(*ppArr8+SIZE_INFO_STRUCT);
                SData9=(*ppArr9+SIZE_INFO_STRUCT);
                SData10=(*ppArr10+SIZE_INFO_STRUCT);
                SData11=(*ppArr11+SIZE_INFO_STRUCT);
                SData12=(*ppArr12+SIZE_INFO_STRUCT);
                SData13=(*ppArr13+SIZE_INFO_STRUCT);
                SData14=(*ppArr14+SIZE_INFO_STRUCT);
                SData15=(*ppArr15+SIZE_INFO_STRUCT);//touch
                SData16=(*ppNumtouchMove+SIZE_INFO_STRUCT);
                SData17=(*ppXtouchMove+SIZE_INFO_STRUCT);
                SData18=(*ppYtouchMove+SIZE_INFO_STRUCT);
                SData19=(*ppArr16+SIZE_INFO_STRUCT);
                SData20=(*ppArr17+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                FData8=SData8+pInfoTmp8->mCount-1;
                FData10=SData10+pInfoTmp10->mCount-1;
                FData12=SData12+pInfoTmp12->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                if(pInfoTmp8->mCount>iMinCount)
                    iMinCount=pInfoTmp8->mCount;
                if(pInfoTmp10->mCount>iMinCount)
                    iMinCount=pInfoTmp10->mCount;
                if(pInfoTmp12->mCount>iMinCount)
                    iMinCount=pInfoTmp12->mCount;
                
                iCountLoop=iMinCount;
                
                for (j=0; j<iCountLoop; j++)//objects
                {
                    F2=(pDataLocal+SData3[*SData4]);//X
                    F3=(pDataLocal+SData5[*SData6]);//Y
                    F4=(pDataLocal+SData7[*SData8]);//W
                    F5=(pDataLocal+SData9[*SData10]);//H
                    F6=(pDataLocal+SData11[*SData12]);//A
                    F7=(pDataLocal+SData15[*SData2]);//Touch

                    CGPoint tmpPointDif;
                    
                    for (i=0; i<pInfoTmp16->mCount; i++)//по всем тачам
                    {
                        tmpPointDif.x=SData17[i];
                        tmpPointDif.y=SData18[i];
                        float NumTouch=(float)SData16[i];
                        
                        if(*F7==NumTouch)
                        {
                            Vector3D VstartPoint = Vector3DMake(tmpPointDif.x-*F2,tmpPointDif.y-*F3,0);
                            Vector3D TmpRotate=Vector3DRotateZ2D(VstartPoint,(*F6*57.3248f));
                            
                            if(iIndexTmp5>RESERV_KERNEL)
                                *(pDataLocal+SData19[*SData2])=tmpPointDif.x;
                            if(iIndexTmp6>RESERV_KERNEL)
                                *(pDataLocal+SData20[*SData2])=tmpPointDif.y;

                            if((TmpRotate.x<=(*F4)*0.5f)&&(TmpRotate.x>=(-(*F4)*0.5f))&&
                               (TmpRotate.y<=(*F5)*0.5f)&&(TmpRotate.y>=(-(*F5)*0.5f)))
                            {
                                if(iIndexTmp2>RESERV_KERNEL)
                                    [OperationIndex OnlyAddData:*SData2 WithData:ppArr13];//yes                                                            
                            }
                            else 
                            {
                                if(iIndexTmp3>RESERV_KERNEL)
                                    [OperationIndex OnlyAddData:*SData2 WithData:ppArr14];
                            }
                            break;
                        }
                    }
                    
                    
                    if(SData2!=FData2)SData2++;//source array
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    if(SData8!=FData8)SData8++;
                    if(SData10!=FData10)SData10++;
                    if(SData12!=FData12)SData12++;
                }
                break;
//операция touch end----------------------------------------------------------------
            case NAME_O_TOUCH_END:
                
                pInfoTmp16 = (InfoArrayValue *)*ppNumtouchEnd;//Touch end
                if(pInfoTmp16->mCount==0)break;
                pInfoTmp17 = (InfoArrayValue *)*ppXtouchEnd;//Touch X
                pInfoTmp18 = (InfoArrayValue *)*ppYtouchEnd;//Touch Y
                
                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr2=*(pppData+iIndexTmp1);//Source Array
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//X
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//ObX
                ppArr5=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//Y
                ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+4));//ObY
                ppArr7=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+5));//W
                ppArr8=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+6));//ObW
                ppArr9=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+7));//H
                ppArr10=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+8));//ObH
                ppArr11=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+9));//A
                ppArr12=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+10));//ObA
                
                iIndexTmp4=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+11);
                ppArr15=*(pppData+iIndexTmp4);//T
                
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;//ObSource
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;//ObX
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;//ObY
                pInfoTmp8 = (InfoArrayValue *)*ppArr8;//ObW
                pInfoTmp10 = (InfoArrayValue *)*ppArr10;//ObH
                pInfoTmp12 = (InfoArrayValue *)*ppArr12;//ObA
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                if(pInfoTmp8->mCount==0)break;
                if(pInfoTmp10->mCount==0)break;
                if(pInfoTmp12->mCount==0)break;
                
                iIndexTmp2=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                ppArr13=*(pppData+iIndexTmp2);//Yes
                if(iIndexTmp2>RESERV_KERNEL){
                    
                    [OperationIndex SetCopasity:pInfoTmp2->mCount WithData:ppArr13];
                    ppArr13=*(pppData+iIndexTmp2);//ObYES
                    pInfoTmp13 = (InfoArrayValue *)*ppArr13;//ObYES
                    pInfoTmp13->mCount=0;
                }
                
                iIndexTmp3=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1);
                ppArr14=*(pppData+iIndexTmp3);//Yes
                if(iIndexTmp3>RESERV_KERNEL){
                    
                    [OperationIndex SetCopasity:pInfoTmp2->mCount WithData:ppArr14];
                    ppArr14=*(pppData+iIndexTmp3);//ObNo
                    pInfoTmp14 = (InfoArrayValue *)*ppArr14;//ObNo
                    pInfoTmp14->mCount=0;
                }
                
                iIndexTmp5=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+2);
                ppArr16=*(pppData+iIndexTmp5);//X
                iIndexTmp6=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+3);
                ppArr17=*(pppData+iIndexTmp6);//Y
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                SData7=(*ppArr7+SIZE_INFO_STRUCT);
                SData8=(*ppArr8+SIZE_INFO_STRUCT);
                SData9=(*ppArr9+SIZE_INFO_STRUCT);
                SData10=(*ppArr10+SIZE_INFO_STRUCT);
                SData11=(*ppArr11+SIZE_INFO_STRUCT);
                SData12=(*ppArr12+SIZE_INFO_STRUCT);
                SData13=(*ppArr13+SIZE_INFO_STRUCT);
                SData14=(*ppArr14+SIZE_INFO_STRUCT);
                SData15=(*ppArr15+SIZE_INFO_STRUCT);//touch
                SData16=(*ppNumtouchEnd+SIZE_INFO_STRUCT);
                SData17=(*ppXtouchEnd+SIZE_INFO_STRUCT);
                SData18=(*ppYtouchEnd+SIZE_INFO_STRUCT);
                SData19=(*ppArr16+SIZE_INFO_STRUCT);
                SData20=(*ppArr17+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                FData8=SData8+pInfoTmp8->mCount-1;
                FData10=SData10+pInfoTmp10->mCount-1;
                FData12=SData12+pInfoTmp12->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                if(pInfoTmp8->mCount>iMinCount)
                    iMinCount=pInfoTmp8->mCount;
                if(pInfoTmp10->mCount>iMinCount)
                    iMinCount=pInfoTmp10->mCount;
                if(pInfoTmp12->mCount>iMinCount)
                    iMinCount=pInfoTmp12->mCount;
                
                iCountLoop=iMinCount;
                
                for (j=0; j<iCountLoop; j++)//objects
                {
                    F2=(pDataLocal+SData3[*SData4]);//X
                    F3=(pDataLocal+SData5[*SData6]);//Y
                    F4=(pDataLocal+SData7[*SData8]);//W
                    F5=(pDataLocal+SData9[*SData10]);//H
                    F6=(pDataLocal+SData11[*SData12]);//A
                    F7=(pDataLocal+SData15[*SData2]);//Touch
                    
              //      bool TouchYES=NO;
                    CGPoint tmpPointDif;
                    
                    for (i=0; i<pInfoTmp16->mCount; i++)//по всем тачам
                    {
                        tmpPointDif.x=SData17[i];
                        tmpPointDif.y=SData18[i];
                        float NumTouch=(float)SData16[i];
                        
                        if(*F7==NumTouch)
                        {
                            Vector3D VstartPoint = Vector3DMake(tmpPointDif.x-*F2,tmpPointDif.y-*F3,0);
                            Vector3D TmpRotate=Vector3DRotateZ2D(VstartPoint,(*F6*57.3248f));
                            
                            if(iIndexTmp4>RESERV_KERNEL)
                                *(pDataLocal+SData15[*SData2])=-1;
                            if(iIndexTmp5>RESERV_KERNEL)
                                *(pDataLocal+SData19[*SData2])=tmpPointDif.x;
                            if(iIndexTmp6>RESERV_KERNEL)
                                *(pDataLocal+SData20[*SData2])=tmpPointDif.y;

                            if((TmpRotate.x<=(*F4)*0.5f)&&(TmpRotate.x>=(-(*F4)*0.5f))&&
                               (TmpRotate.y<=(*F5)*0.5f)&&(TmpRotate.y>=(-(*F5)*0.5f)))
                            {
                                if(iIndexTmp2>RESERV_KERNEL)
                                    [OperationIndex OnlyAddData:*SData2 WithData:ppArr13];//yes
                            }
                            else
                            {
                                if(iIndexTmp3>RESERV_KERNEL)
                                    [OperationIndex OnlyAddData:*SData2 WithData:ppArr14];
                            }
                            break;
                        }
                    }
                                        
                    if(SData2!=FData2)SData2++;//source array
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    if(SData8!=FData8)SData8++;
                    if(SData10!=FData10)SData10++;
                    if(SData12!=FData12)SData12++;
                }
                break;
//операция jmp----------------------------------------------------------------------
            case NAME_O_JMP:
    //            pRegim=((*pHeart->pModes)+SIZE_INFO_STRUCT);//режим операции

                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT);//ObSource
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr1=*(pppData+iIndexTmp1);

                iIndexTmp2=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT);//ObDest
                if(iIndexTmp2<RESERV_KERNEL)break;
                ppArr2=*(pppData+iIndexTmp2);

                pInfoTmp1 = (InfoArrayValue *)*ppArr1;//ObSource
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;//ObDest
//                if((int)pInfoTmp1->mCount>30000)break;
//                if((int)pInfoTmp2->mCount>30000)break;

                if(pInfoTmp1->mCount==0)break;

                [OperationIndex SetCopasity:pInfoTmp1->mCount+pInfoTmp2->mCount WithData:ppArr2];
                ppArr2=*(pppData+iIndexTmp2);
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;//ObDest

                memcpy((*ppArr2+SIZE_INFO_STRUCT)+pInfoTmp2->mCount, (*ppArr1+SIZE_INFO_STRUCT),
                       sizeof(int)*(pInfoTmp1->mCount));

                pInfoTmp2->mCount+=pInfoTmp1->mCount;

      //          if(pRegim[0]==1 && iIndexTmp1>RESERV_KERNEL)
        //            pInfoTmp1->mCount=0;

                break;
//операция jmp----------------------------------------------------------------------
            case NAME_O_JMP_CYCLE:

                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT);//ObSource
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr1=*(pppData+iIndexTmp1);
                
                iIndexTmp2=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT);//ObDest
                if(iIndexTmp2<RESERV_KERNEL)break;
                ppArr2=*(pppData+iIndexTmp2);

                iIndexTmp3=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1);//Count
                if(iIndexTmp3<RESERV_KERNEL)break;
                ppArr3=*(pppData+iIndexTmp3);
                iValue=(int)((*ppArr3+SIZE_INFO_STRUCT)[0]);//count
                F2=(pDataLocal+iValue);//count

                if(*F2==0)break;

                pInfoTmp1 = (InfoArrayValue *)*ppArr1;//ObSource
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;//ObDest
//                if((int)pInfoTmp1->mCount>32000)break;
//                if((int)pInfoTmp2->mCount>32000)break;
                
                if(pInfoTmp1->mCount==0)break;
                
                iCountLoop=(int)*F2;
                
LOOP_JMP_CYCLE:
                if(iCountLoop==0)break;
                iCountLoop--;

                [OperationIndex SetCopasity:pInfoTmp1->mCount+pInfoTmp2->mCount WithData:ppArr2];
                ppArr2=*(pppData+iIndexTmp2);
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;//ObDest
                
                memcpy((*ppArr2+SIZE_INFO_STRUCT)+pInfoTmp2->mCount, (*ppArr1+SIZE_INFO_STRUCT),
                       sizeof(int)*(pInfoTmp1->mCount));
                
                pInfoTmp2->mCount+=pInfoTmp1->mCount;
                if(pInfoTmp2->mCount>0xfff)break;

                goto LOOP_JMP_CYCLE;
                
                break;
//операция jmp ex--------------------------------------------------------------------
            case NAME_O_JMP_EX:

                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT);//ObSource
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr1=*(pppData+iIndexTmp1);
                
                iIndexTmp2=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT);//ObDest
                if(iIndexTmp2<RESERV_KERNEL)break;
                ppArr2=*(pppData+iIndexTmp2);

                iIndexTmp3=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1);//Place
                if(iIndexTmp3<RESERV_KERNEL)break;
                ppArr3=*(pppData+iIndexTmp3);
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));

                iIndexTmp4=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3);//Count
                if(iIndexTmp4<RESERV_KERNEL)break;
                ppArr5=*(pppData+iIndexTmp4);
                ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+4));

                pInfoTmp1 = (InfoArrayValue *)*ppArr1;//ObSource
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;//ObDest
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;//Place
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;//ObPlace
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;//Count
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;//ObCount
                
//                if((int)pInfoTmp1->mCount>32000)break;
//                if((int)pInfoTmp2->mCount>32000)break;
                if(pInfoTmp1->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;

                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                
                if(pInfoTmp4->mCount>pInfoTmp6->mCount)
                    iCountLoop=pInfoTmp4->mCount;
                else iCountLoop=pInfoTmp6->mCount;

LOOP_JMP_EX:
                if(iCountLoop==0)break;
                iCountLoop--;

                F1=(pDataLocal+SData3[*SData4]);//place
                tmpf=*F1;

                if(tmpf<0)tmpf=0;
                if(tmpf>=pInfoTmp1->mCount)tmpf=pInfoTmp1->mCount-1;
                
                F2=(pDataLocal+SData5[*SData6]);//count
                tmpf2=*F2;

                if(tmpf2<1)tmpf2=1;
                if(tmpf+tmpf2>pInfoTmp1->mCount)tmpf2=pInfoTmp1->mCount-tmpf;
                
                [OperationIndex SetCopasity:pInfoTmp2->mCount+tmpf2 WithData:ppArr2];
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;//ObDest
                
                memcpy((*ppArr2+SIZE_INFO_STRUCT)+pInfoTmp2->mCount,
                       (*ppArr1+SIZE_INFO_STRUCT)+(int)tmpf,sizeof(int)*(tmpf2));
                
                pInfoTmp2->mCount+=tmpf2;
                
                if(SData2!=FData2)SData2++;
                if(SData4!=FData4)SData4++;
                
                goto LOOP_JMP_EX;

                break;
//операция less_equal---------------------------------------------------------------
            case NAME_O_MUL_PLACE:
                
                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  );//Array
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr1=*(pppData+iIndexTmp1);

                iIndexTmp2=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1);//Count
                if(iIndexTmp2<RESERV_KERNEL)break;
                ppArr2=*(pppData+iIndexTmp2);

                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                if(pInfoTmp1->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);

                tmpf=*(pDataLocal+SData2[0]);//count
                if(tmpf<=0)break;
                if(tmpf>0xfff)break;

                iTmp=pInfoTmp1->mCount*tmpf;
                [OperationIndex SetCopasity:iTmp WithData:ppHelpData];
                pInfoTmp3 = (InfoArrayValue *)*ppHelpData;
                SData3=(*ppHelpData+SIZE_INFO_STRUCT);

                for (i=0; i<pInfoTmp1->mCount; i++)
                {
                    for(j=0;j<tmpf;j++)
                    {
                        SData3[i*(int)tmpf+j]=SData1[i];
                    }
                }

                [OperationIndex SetCopasity:iTmp WithData:ppArr1];
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp1->mCount=iTmp;
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                
                memcpy(SData1, SData3, iTmp*(4));

                break;
//операция less_equal---------------------------------------------------------------
            case NAME_O_LESS_EQUAL:
                
       //         pRegim=((*pHeart->pModes)+SIZE_INFO_STRUCT);//режим операции
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//A
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//B
                
                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2);//ObA
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr3=*(pppData+iIndexTmp1);
                
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObB
                
                iIndexTmp2=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT);
                ppArr5=*(pppData+iIndexTmp2);//ObYES
                iIndexTmp3=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1);
                ppArr6=*(pppData+iIndexTmp3);//ObNO
                if(iIndexTmp2<RESERV_KERNEL && iIndexTmp3<RESERV_KERNEL)break;
                
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;//ObA
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;//ObB
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;//ObYES
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;//ObNO
                
                if(pInfoTmp3->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;

                if(iIndexTmp2>RESERV_KERNEL){
                    
                    [OperationIndex SetCopasity:pInfoTmp3->mCount WithData:ppArr5];
                    ppArr5=*(pppData+iIndexTmp2);//ObYES
                    pInfoTmp5 = (InfoArrayValue *)*ppArr5;//ObYES
                    pInfoTmp5->mCount=0;
                }
                if(iIndexTmp3>RESERV_KERNEL){
                    
                    [OperationIndex SetCopasity:pInfoTmp3->mCount WithData:ppArr6];
                    ppArr6=*(pppData+iIndexTmp3);//ObNO
                    pInfoTmp6 = (InfoArrayValue *)*ppArr6;//ObNO
                    pInfoTmp6->mCount=0;
                }
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);//индексы1
                SData4=(*ppArr4+SIZE_INFO_STRUCT);//индексы2
                
                FData3=SData3+pInfoTmp3->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                
                iCountLoop=pInfoTmp3->mCount;
                
LOOP_LESS_EQUAL:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                if(*(pDataLocal+SData1[*SData3])<=*(pDataLocal+SData2[*SData4]))
                {
                    if(iIndexTmp2>RESERV_KERNEL)
                        [OperationIndex OnlyAddData:*SData3 WithData:ppArr5];
                }
                else if(iIndexTmp3>RESERV_KERNEL)
                    [OperationIndex OnlyAddData:*SData3 WithData:ppArr6];
                
                if(SData3!=FData3)SData3++;
                if(SData4!=FData4)SData4++;
                
                goto LOOP_LESS_EQUAL;

                break;
//операция more_equal---------------------------------------------------------------
            case NAME_O_MORE_EQUAL:
                
       //         pRegim=((*pHeart->pModes)+SIZE_INFO_STRUCT);//режим операции

                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//A
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//B
                
                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2);//ObA
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr3=*(pppData+iIndexTmp1);
                
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObB
                
                iIndexTmp2=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT);
                ppArr5=*(pppData+iIndexTmp2);//ObYES
                iIndexTmp3=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1);
                ppArr6=*(pppData+iIndexTmp3);//ObNO
                if(iIndexTmp2<RESERV_KERNEL && iIndexTmp3<RESERV_KERNEL)break;

                pInfoTmp3 = (InfoArrayValue *)*ppArr3;//ObA
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;//ObB
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;//ObYES
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;//ObNO
                
                if(pInfoTmp3->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;

                if(iIndexTmp2>RESERV_KERNEL){
                    
                    [OperationIndex SetCopasity:pInfoTmp3->mCount WithData:ppArr5];
                    ppArr5=*(pppData+iIndexTmp2);//ObYES
                    pInfoTmp5 = (InfoArrayValue *)*ppArr5;//ObYES
                    pInfoTmp5->mCount=0;
                }
                if(iIndexTmp3>RESERV_KERNEL){
                    
                    [OperationIndex SetCopasity:pInfoTmp3->mCount WithData:ppArr6];
                    ppArr6=*(pppData+iIndexTmp3);//ObNO
                    pInfoTmp6 = (InfoArrayValue *)*ppArr6;//ObNO
                    pInfoTmp6->mCount=0;
                }

                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);//индексы1
                SData4=(*ppArr4+SIZE_INFO_STRUCT);//индексы2
                
                FData3=SData3+pInfoTmp3->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                
                iCountLoop=pInfoTmp3->mCount;

LOOP_MORE_EQUAL:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                if(*(pDataLocal+SData1[*SData3])>=*(pDataLocal+SData2[*SData4]))
                {
                    if(iIndexTmp2>RESERV_KERNEL)
                        [OperationIndex OnlyAddData:*SData3 WithData:ppArr5];
                }
                else if(iIndexTmp3>RESERV_KERNEL)
                        [OperationIndex OnlyAddData:*SData3 WithData:ppArr6];
            
                if(SData3!=FData3)SData3++;
                if(SData4!=FData4)SData4++;
                
                goto LOOP_MORE_EQUAL;
            break;
//операция more---------------------------------------------------------------
            case NAME_O_MORE:
                
      //          pRegim=((*pHeart->pModes)+SIZE_INFO_STRUCT);//режим операции
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//A
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//B
                
                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2);//ObA
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr3=*(pppData+iIndexTmp1);
                
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObB
                
                iIndexTmp2=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT);
                ppArr5=*(pppData+iIndexTmp2);//ObYES
                iIndexTmp3=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1);
                ppArr6=*(pppData+iIndexTmp3);//ObNO
                if(iIndexTmp2<RESERV_KERNEL && iIndexTmp3<RESERV_KERNEL)break;
                
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;//ObA
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;//ObB
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;//ObYES
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;//ObNO
                
                if(pInfoTmp3->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                
                if(iIndexTmp2>RESERV_KERNEL){
                    
                    [OperationIndex SetCopasity:pInfoTmp3->mCount WithData:ppArr5];
                    ppArr5=*(pppData+iIndexTmp2);//ObYES
                    pInfoTmp5 = (InfoArrayValue *)*ppArr5;//ObYES
                    pInfoTmp5->mCount=0;
                }
                if(iIndexTmp3>RESERV_KERNEL){
                    
                    [OperationIndex SetCopasity:pInfoTmp3->mCount WithData:ppArr6];
                    ppArr6=*(pppData+iIndexTmp3);//ObNO
                    pInfoTmp6 = (InfoArrayValue *)*ppArr6;//ObNO
                    pInfoTmp6->mCount=0;
                }
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);//индексы1
                SData4=(*ppArr4+SIZE_INFO_STRUCT);//индексы2
                
                FData3=SData3+pInfoTmp3->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                
                iCountLoop=pInfoTmp3->mCount;
                
LOOP_MORE:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                if(*(pDataLocal+SData1[*SData3])<*(pDataLocal+SData2[*SData4]))
                {
                    if(iIndexTmp2>RESERV_KERNEL)
                        [OperationIndex OnlyAddData:*SData3 WithData:ppArr5];
                }
                else if(iIndexTmp3>RESERV_KERNEL)
                        [OperationIndex OnlyAddData:*SData3 WithData:ppArr6];
            
                if(SData3!=FData3)SData3++;
                if(SData4!=FData4)SData4++;
                
                goto LOOP_MORE;
                break;
//операция less---------------------------------------------------------------
            case NAME_O_LESS:
                
     //           pRegim=((*pHeart->pModes)+SIZE_INFO_STRUCT);//режим операции
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//A
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//B
                
                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2);//ObA
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr3=*(pppData+iIndexTmp1);
                
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObB
                
                iIndexTmp2=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT);
                ppArr5=*(pppData+iIndexTmp2);//ObYES
                iIndexTmp3=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1);
                ppArr6=*(pppData+iIndexTmp3);//ObNO
                if(iIndexTmp2<RESERV_KERNEL && iIndexTmp3<RESERV_KERNEL)break;
                
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;//ObA
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;//ObB
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;//ObYES
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;//ObNO
                
                if(pInfoTmp3->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                
                if(iIndexTmp2>RESERV_KERNEL){
                    
                    [OperationIndex SetCopasity:pInfoTmp3->mCount WithData:ppArr5];
                    ppArr5=*(pppData+iIndexTmp2);//ObYES
                    pInfoTmp5 = (InfoArrayValue *)*ppArr5;//ObYES
                    pInfoTmp5->mCount=0;
                }
                if(iIndexTmp3>RESERV_KERNEL){
                    
                    [OperationIndex SetCopasity:pInfoTmp3->mCount WithData:ppArr6];
                    ppArr6=*(pppData+iIndexTmp3);//ObNO
                    pInfoTmp6 = (InfoArrayValue *)*ppArr6;//ObNO
                    pInfoTmp6->mCount=0;
                }
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);//индексы1
                SData4=(*ppArr4+SIZE_INFO_STRUCT);//индексы2
                
                FData3=SData3+pInfoTmp3->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                
                iCountLoop=pInfoTmp3->mCount;
                
LOOP_LESS:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                if(*(pDataLocal+SData1[*SData3])>*(pDataLocal+SData2[*SData4]))
                {
                    if(iIndexTmp2>RESERV_KERNEL)
                        [OperationIndex OnlyAddData:*SData3 WithData:ppArr5];
                }
                else if(iIndexTmp3>RESERV_KERNEL)
                        [OperationIndex OnlyAddData:*SData3 WithData:ppArr6];

                if(SData3!=FData3)SData3++;
                if(SData4!=FData4)SData4++;
                
                goto LOOP_LESS;
                break;
//операция equal---------------------------------------------------------------
            case NAME_O_EQUAL:
                
      //          pRegim=((*pHeart->pModes)+SIZE_INFO_STRUCT);//режим операции
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//A
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//B
                
                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2);//ObA
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr3=*(pppData+iIndexTmp1);
                
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObB
                
                iIndexTmp2=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT);
                ppArr5=*(pppData+iIndexTmp2);//ObYES
                iIndexTmp3=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1);
                ppArr6=*(pppData+iIndexTmp3);//ObNO
                if(iIndexTmp2<RESERV_KERNEL && iIndexTmp3<RESERV_KERNEL)break;
                
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;//ObA
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;//ObB
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;//ObYES
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;//ObNO
                
                if(pInfoTmp3->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                
                if(iIndexTmp2>RESERV_KERNEL){
                    
                    [OperationIndex SetCopasity:pInfoTmp3->mCount WithData:ppArr5];
                    ppArr5=*(pppData+iIndexTmp2);//ObYES
                    pInfoTmp5 = (InfoArrayValue *)*ppArr5;//ObYES
                    pInfoTmp5->mCount=0;
                }
                if(iIndexTmp3>RESERV_KERNEL){
                    
                    [OperationIndex SetCopasity:pInfoTmp3->mCount WithData:ppArr6];
                    ppArr6=*(pppData+iIndexTmp3);//ObNO
                    pInfoTmp6 = (InfoArrayValue *)*ppArr6;//ObNO
                    pInfoTmp6->mCount=0;
                }
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);//индексы1
                SData4=(*ppArr4+SIZE_INFO_STRUCT);//индексы2
                
                FData3=SData3+pInfoTmp3->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                
                iCountLoop=pInfoTmp3->mCount;
                
LOOP_EQUAL:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                if(*(pDataLocal+SData1[*SData3])==*(pDataLocal+SData2[*SData4]))
                {
                    if(iIndexTmp2>RESERV_KERNEL)
                        [OperationIndex OnlyAddData:*SData3 WithData:ppArr5];
                }
                else if(iIndexTmp3>RESERV_KERNEL)
                        [OperationIndex OnlyAddData:*SData3 WithData:ppArr6];
                
                if(SData3!=FData3)SData3++;
                if(SData4!=FData4)SData4++;
                
                goto LOOP_EQUAL;
                break;
//операция not equal---------------------------------------------------------------
            case NAME_O_NOT_EQUAL:
                
       //         pRegim=((*pHeart->pModes)+SIZE_INFO_STRUCT);//режим операции
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//A
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//B
                
                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2);//ObA
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr3=*(pppData+iIndexTmp1);
                
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObB
                
                iIndexTmp2=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT);
                ppArr5=*(pppData+iIndexTmp2);//ObYES
                iIndexTmp3=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1);
                ppArr6=*(pppData+iIndexTmp3);//ObNO
                if(iIndexTmp2<RESERV_KERNEL && iIndexTmp3<RESERV_KERNEL)break;
                
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;//ObA
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;//ObB
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;//ObYES
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;//ObNO
                
                if(pInfoTmp3->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                
                if(iIndexTmp2>RESERV_KERNEL){
                    
                    [OperationIndex SetCopasity:pInfoTmp3->mCount WithData:ppArr5];
                    ppArr5=*(pppData+iIndexTmp2);//ObYES
                    pInfoTmp5 = (InfoArrayValue *)*ppArr5;//ObYES
                    pInfoTmp5->mCount=0;
                }
                if(iIndexTmp3>RESERV_KERNEL){
                    
                    [OperationIndex SetCopasity:pInfoTmp3->mCount WithData:ppArr6];
                    ppArr6=*(pppData+iIndexTmp3);//ObNO
                    pInfoTmp6 = (InfoArrayValue *)*ppArr6;//ObNO
                    pInfoTmp6->mCount=0;
                }
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);//индексы1
                SData4=(*ppArr4+SIZE_INFO_STRUCT);//индексы2
                
                FData3=SData3+pInfoTmp3->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                
                iCountLoop=pInfoTmp3->mCount;
                
LOOP_NOT_EQUAL:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                if(*(pDataLocal+SData1[*SData3])!=*(pDataLocal+SData2[*SData4]))
                {
                    if(iIndexTmp2>RESERV_KERNEL)
                        [OperationIndex OnlyAddData:*SData3 WithData:ppArr5];
                }
                else if(iIndexTmp3>RESERV_KERNEL)
                        [OperationIndex OnlyAddData:*SData3 WithData:ppArr6];
    
                if(SData3!=FData3)SData3++;
                if(SData4!=FData4)SData4++;
                
                goto LOOP_NOT_EQUAL;
                break;
//операция equal---------------------------------------------------------------
            case NAME_O_SWITCH:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//A
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObA
                pInfoTmp1 = (InfoArrayValue *)*ppArr2;//A
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;//ObA
                if(pInfoTmp2->mCount==0)break;

                for (i=0; i<10; i++) {
                    iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+i);
                    if(iIndexTmp1>RESERV_KERNEL)
                    {
                        ppArr3=*(pppData+iIndexTmp1);//3
                        [OperationIndex SetCopasity:pInfoTmp2->mCount WithData:ppArr3];
                        pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                        pInfoTmp3->mCount=0;
                    }
                }                
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                iCountLoop=pInfoTmp2->mCount;
LOOP_SWITCH:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                F1=(pDataLocal+SData1[*SData2]);
                
                iPlace=0;
                if(*F1<0)
                {
                    iPlace=0;
                }
                else if(*F1>9)
                {
                    iPlace=9;
                }
                else iPlace=(int)(*F1);

                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+iPlace);
                if(iIndexTmp1>RESERV_KERNEL)
                {
                    ppArr3=*(pppData+iIndexTmp1);//1
                    [OperationIndex OnlyAddData:*SData2 WithData:ppArr3];
                }
                
                if(SData2!=FData2)SData2++;
                
                goto LOOP_SWITCH;
                break;
//операция mirror-----------------------------------------------------------------
            case NAME_O_MIRROR:
                
                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr1=*(pppData+iIndexTmp1);//A
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObA
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;//ObA
                                
                if(pInfoTmp2->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                iCountLoop=pInfoTmp2->mCount;
LOOP_MIRROR:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                pfTmp=pDataLocal+SData1[*SData2];
                (*pfTmp)*=-1;
                
                if(SData2!=FData2)SData2++;
                
                goto LOOP_MIRROR;
                
                break;
//операция INC-----------------------------------------------------------------
            case NAME_O_INC:
                
                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr1=*(pppData+iIndexTmp1);//A
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObA
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;//ObA
                
                if(pInfoTmp2->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                iCountLoop=pInfoTmp2->mCount;
LOOP_INC:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                pfTmp=pDataLocal+SData1[*SData2];
                (*pfTmp)++;
                
                if(SData2!=FData2)SData2++;
                
                goto LOOP_INC;
                
                break;
//операция ABS-----------------------------------------------------------------
            case NAME_O_ABS:
                
                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr1=*(pppData+iIndexTmp1);//A
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObA
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;//ObA
                
                if(pInfoTmp2->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                iCountLoop=pInfoTmp2->mCount;
LOOP_ABS:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                F1=pDataLocal+SData1[*SData2];
                if(*F1<0)*F1=-*F1;
                
                if(SData2!=FData2)SData2++;
                
                goto LOOP_ABS;
                
                break;
//операция RND Minus-----------------------------------------------------------------
            case NAME_O_RND_MINUS:
                
                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr1=*(pppData+iIndexTmp1);//A
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObA
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;//ObA
                
                if(pInfoTmp2->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                iCountLoop=pInfoTmp2->mCount;
LOOP_RND_MINUS:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                F1=pDataLocal+SData1[*SData2];
                i=(RND)%2;
                if(i>0)*F1=-*F1;
                
                if(SData2!=FData2)SData2++;
                
                goto LOOP_RND_MINUS;
                
                break;
//операция RND Queue-----------------------------------------------------------------
            case NAME_O_RND_QUEUE:
                
                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1);
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr1=*(pppData+iIndexTmp1);//Source

                iIndexTmp2=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp2<RESERV_KERNEL)break;
                ppArr2=*(pppData+iIndexTmp2);//Dest

                iIndexTmp3=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp3<RESERV_KERNEL)break;
                ppArr3=*(pppData+iIndexTmp3);//Count
                
                F1=pDataLocal+*(*ppArr3+SIZE_INFO_STRUCT);
                if(*F1==0)break;

                pInfoTmp1 = (InfoArrayValue *)*ppArr1;//ObS
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;//ObD

                if(pInfoTmp1->mCount==0)break;
                tmpf=*F1;
                if(tmpf>pInfoTmp1->mCount)tmpf=pInfoTmp1->mCount;

                [OperationIndex SetCopasity:tmpf WithData:ppArr2];
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;//ObD
                pInfoTmp2->mCount=0;
                
                [OperationIndex CopyDataFrom:ppArr1 To:ppHelpData];

                pInfoTmp4 = (InfoArrayValue *)*ppHelpData;
                SData4=(*ppHelpData+SIZE_INFO_STRUCT);

                iCountLoop=tmpf;
LOOP_RND_QUEUE:;
                if(iCountLoop==0)break;
                
                if(pInfoTmp4->mCount==0)iTmp=0;
                else iTmp=RND%pInfoTmp4->mCount;
                
                [OperationIndex OnlyAddData:SData4[iTmp] WithData:ppArr2];
                [OperationIndex OnlyRemoveDataAtPlace:iTmp WithData:ppHelpData];
                SData4=(*ppHelpData+SIZE_INFO_STRUCT);
                pInfoTmp4 = (InfoArrayValue *)*ppHelpData;

                iCountLoop--;
                
                goto LOOP_RND_QUEUE;
                
                break;
//операция Pow--------------------------------------------------------------------
            case NAME_O_POW:
                
                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;

                iIndexTmp2=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp2<RESERV_KERNEL)break;

                ppArr1=*(pppData+iIndexTmp1);//X
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;//X
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObX
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;//ObA

                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//N
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObN
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;//ObN

                ppArr5=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT ));//R
                ppArr6=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObR
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;//ObN

                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                
                iCountLoop=pInfoTmp2->mCount;
                
                if(pInfoTmp4->mCount>iCountLoop)
                    iCountLoop=pInfoTmp4->mCount;
                else if(pInfoTmp6->mCount>iCountLoop)
                    iCountLoop=pInfoTmp6->mCount;
                
                if(pInfoTmp1->mType==DATA_INT)
                {
LOOP_O_POW_INT:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=pDataLocal+SData1[*SData2];
                    F2=pDataLocal+SData3[*SData4];
                    F3=pDataLocal+SData5[*SData6];

                    *F3=(int)powf(*F1, *F2);
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    
                    goto LOOP_O_POW_INT;
                }
                else
                {
LOOP_O_POW:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=pDataLocal+SData1[*SData2];
                    F2=pDataLocal+SData3[*SData4];
                    F3=pDataLocal+SData5[*SData6];
                    
                    *F3=powf(*F1, *F2);
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    
                    goto LOOP_O_POW;
                }
                
                break;
//операция DEC-----------------------------------------------------------------
            case NAME_O_DEC:
                
                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr1=*(pppData+iIndexTmp1);//A
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObA
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;//ObA
                
                if(pInfoTmp2->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                iCountLoop=pInfoTmp2->mCount;
LOOP_DEC:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                pfTmp=pDataLocal+SData1[*SData2];
                (*pfTmp)--;
                
                if(SData2!=FData2)SData2++;
                
                goto LOOP_DEC;
                
                break;
//операция движения данных----------------------------------------------------------
            case NAME_O_ADD_DATA://краеугольный камень
                
                iIndexTmp3=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1);//array source
                if(iIndexTmp3<RESERV_KERNEL)break;

                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );//old
                iIndexTmp2=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1);//new
                
                if(iIndexTmp1<RESERV_KERNEL || iIndexTmp2<RESERV_KERNEL)break;

                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//count
                iValue=*(pDataLocal+*(*ppArr1+SIZE_INFO_STRUCT));//count
                if(iValue<=0)break;//count
//                if(iValue>32000)break;
                
             //   ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//matrix
                ppArr3=*(pppData+iIndexTmp3);//source array (массив неиспользуемых)

                pInfoTmp1=(InfoArrayValue *)*ppArr1;//count
              //  pInfoTmp2=(InfoArrayValue *)*ppArr2;//matrix
                pInfoTmp3=(InfoArrayValue *)*ppArr3;//array source
                
                ppArr4=*(pppData+iIndexTmp1);//old
                pInfoTmp4=(InfoArrayValue *)*ppArr4;

                ppArr5=*(pppData+iIndexTmp2);
                pInfoTmp5=(InfoArrayValue *)*ppArr5;
//                if((int)pInfoTmp4->mCount>=32000)break;
//                if((int)pInfoTmp5->mCount>=32000)break;
                
                int IcounNew=0;
                int IcounOld=0;
                if(iValue>pInfoTmp3->mCount)
                {
                    IcounNew=iValue-pInfoTmp3->mCount;
                    IcounOld=pInfoTmp3->mCount;

                    if(ppArr5==ppArr4)
                    {
                        [OperationIndex SetCopasity:iValue WithData:ppArr5];
                    }
                    else
                    {
                        [OperationIndex SetCopasity:IcounNew WithData:ppArr5];
                        [OperationIndex SetCopasity:pInfoTmp3->mCount WithData:ppArr4];
                    }
                    
                    ppArr4=*(pppData+iIndexTmp1);
                    pInfoTmp4=(InfoArrayValue *)*ppArr4;
                    
                    ppArr5=*(pppData+iIndexTmp2);
                    pInfoTmp5=(InfoArrayValue *)*ppArr5;
                    pInfoTmp5->mCount=0;
                }
                else
                {
                    IcounNew=0;
                    IcounOld=iValue;

                    if(ppArr5==ppArr4)
                    {
                        [OperationIndex SetCopasity:iValue WithData:ppArr5];
                    }
                    else
                    {
                        [OperationIndex SetCopasity:iValue WithData:ppArr4];
                        [OperationIndex SetCopasity:0 WithData:ppArr5];
                    }
                    
                    ppArr4=*(pppData+iIndexTmp1);
                    pInfoTmp4=(InfoArrayValue *)*ppArr4;

                    ppArr5=*(pppData+iIndexTmp2);
                    pInfoTmp5=(InfoArrayValue *)*ppArr5;
                    pInfoTmp5->mCount=0;
                }

                if(IcounOld>0)
                {//копируем резерв
                    memcpy((*ppArr4+SIZE_INFO_STRUCT), (*ppArr3+SIZE_INFO_STRUCT),
                           sizeof(int)*(IcounOld));
                    pInfoTmp4->mCount=IcounOld;
                }
                
                if(pInfoTmp3->mCount>IcounOld)
                {
                    memcpy((*ppArr3+SIZE_INFO_STRUCT), (*ppArr3+SIZE_INFO_STRUCT)+IcounOld,
                           sizeof(int)*(pInfoTmp3->mCount-IcounOld));
                }
                pInfoTmp3->mCount-=IcounOld;

                if(IcounNew>0)
                {
                    if(pInfoTmp3->UnParentMatrix.indexMatrix==0)
                        break;

                    pMatr=*(MATRIXcell **)(ArrayPoints->pData+pInfoTmp3->UnParentMatrix.indexMatrix);

                    pInfoTmp6=(InfoArrayValue *)*pMatr->ppDataMartix;
                    SData6=(*pMatr->ppDataMartix+SIZE_INFO_STRUCT);

                    SData5=(*ppArr5+SIZE_INFO_STRUCT);
                    for (k=0; k<IcounNew; k++)//добавляем новые индексы
                        SData5[k+IcounOld]=pMatr->iDimMatrix+k;
                    
                    pInfoTmp5->mCount+=IcounNew;

                    for (j=0; j<pInfoTmp6->mCount; j++)
                    {
                        ppArr7=*(pppData+SData6[j]);
                        pInfoTmp7=(InfoArrayValue *)*ppArr7;

                        if(pInfoTmp7->mType!=DATA_U_INT)
                        {
                            [OperationIndex SetCopasity:pInfoTmp7->mCount+IcounNew WithData:ppArr7];
                            pInfoTmp7=(InfoArrayValue *)*ppArr7;
                            SData7=(*ppArr7+SIZE_INFO_STRUCT);

                            int iZeroIndex=*SData7;

                            for (k=0; k<IcounNew; k++)
                            {
                                int iNewIndex=[ArrayPoints CopyDataAtIndex:iZeroIndex];
                                [ArrayPoints IncDataAtIndex:iNewIndex];
                                
                                SData7[k+pInfoTmp7->mCount]=iNewIndex;
                            }
                            
                            pInfoTmp7->mCount+=IcounNew;
                        }
                    }
                    
                    pMatr->iDimMatrix+=IcounNew;
                }

                break;
//операция инвертирования Space---------------------------------------------------------
            case NAME_O_INV:
                
                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr1=*(pppData+iIndexTmp1);//массив инвертирования
                pInfoTmp1=(InfoArrayValue *)*ppArr1;
                if(pInfoTmp1->mCount<=1)break;
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                
                //вспомогателный вектор
                [OperationIndex SetCopasity:pInfoTmp1->mCount WithData:ppHelpData];
                pInfoTmp2 = (InfoArrayValue *)*ppHelpData;
                SData2=(*ppHelpData+SIZE_INFO_STRUCT);
                pInfoTmp2->mCount=0;
                
                for (i=0; i<pInfoTmp1->mCount; i++) {
                    SData2[i]=SData1[pInfoTmp1->mCount-1-i];
                }

                for (i=0; i<pInfoTmp1->mCount; i++) {
                    SData1[i]=SData2[i];
                }
                break;
//операция движения данных-------------------------------------------------------------
            case NAME_O_DEL_DATA:
                
                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr1=*(pppData+iIndexTmp1);//массив удаления
                pInfoTmp1=(InfoArrayValue *)*ppArr1;
                if(pInfoTmp1->mCount<=0)break;
                SData4=(*ppArr1+SIZE_INFO_STRUCT);
                
                if(pInfoTmp1->UnParentMatrix.indexMatrix==0)break;
                pMatr=*(MATRIXcell **)(ArrayPoints->pData+pInfoTmp1->UnParentMatrix.indexMatrix);

                pInfoTmp2=(InfoArrayValue *)*pMatr->ppDataMartix;
                SData1=(*pMatr->ppDataMartix+SIZE_INFO_STRUCT);

                //вспомогателный вектор
                [OperationIndex SetCopasity:pMatr->iDimMatrix WithData:ppHelpData];
                pInfoTmp4=(InfoArrayValue *)*ppHelpData;
                SData3=(*ppHelpData+SIZE_INFO_STRUCT);

                memset(*ppHelpData+SIZE_INFO_STRUCT, 0, sizeof(int)*pInfoTmp4->mCopasity);//делаем нули
                for (i=0; i<pInfoTmp1->mCount; i++)//помечаем удаляемые элементы
                    if(SData4[i]!=0)
                        SData3[SData4[i]]=-1;
                
                pInfoTmp4->mCount=pMatr->iDimMatrix;
                
                k=0;//составляем таблицу для переименования
                for (i=0; i<pInfoTmp4->mCount; i++)
                {
                    if(SData3[i]==-1)k++;
                    else SData3[i]+=k;
                }
                
                if(k==pMatr->iDimMatrix)
                {
                    SData3[pInfoTmp4->mCount-1]=-2;
                    k--;
                }
                
                [OperationIndex SetCopasity:pMatr->iDimMatrix WithData:ppTmpData];
                pInfoTmp5=(InfoArrayValue *)*ppTmpData;//временный массив для неудалённых элементов
                SData5=(*ppTmpData+SIZE_INFO_STRUCT);

                for (i=0; i<pInfoTmp2->mCount; i++)//проходим по матрице данных и удаляем строки
                {
                    pInfoTmp5->mCount=0;
                    ppArr5=*(pppData+SData1[i]);
                    pInfoTmp3=(InfoArrayValue *)*ppArr5;
                    SData2=(*ppArr5+SIZE_INFO_STRUCT);

                    if(pInfoTmp3->mType==DATA_U_INT)
                    {
                        for (j=0;j<pInfoTmp3->mCount;j++)
                        {
                            iPlace=SData2[j];
                            if(SData3[iPlace]==-1)
                            {
                                [OperationIndex OnlyRemoveDataAtPlaceSort:j WithData:ppArr5];
                                pInfoTmp3=(InfoArrayValue *)*ppArr5;
                                SData2=(*ppArr5+SIZE_INFO_STRUCT);
                                j--;
                            }
                            else if(SData3[iPlace]==-2)
                            {
                                SData2[j]-=pMatr->iDimMatrix-1;
                            }
                            else SData2[j]-=SData3[iPlace];
                        }
                    }
                    else
                    {
                        for (j=0; j<pInfoTmp4->mCount; j++)
                        {
                            IndexInside=SData2[j];

                            if(SData3[j]==-1)
                                [ArrayPoints DecDataAtIndex:IndexInside];
                            else if(SData3[j]==-2)
                            {
                                [OperationIndex SetCopasity:1 WithData:ppArr5];
                                SData2=(*ppArr5+SIZE_INFO_STRUCT);
                                SData2[0]=IndexInside;

                                break;
                            }
                            else
                            {
                                SData5[pInfoTmp5->mCount]=IndexInside;
                                pInfoTmp5->mCount++;
                            }
                        }
                        
                        if(pInfoTmp5->mCount>0)
                        {
                            [OperationIndex SetCopasity:pInfoTmp5->mCount WithData:ppArr5];
                            SData2=(*ppArr5+SIZE_INFO_STRUCT);
                            memcpy(SData2, SData5, sizeof(int)*pInfoTmp5->mCount);
                        }
                    }
                }
                [OperationIndex SetCopasity:0 WithData:ppArr1];
                pMatr->iDimMatrix-=k;
                
                break;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            case NAME_O_COPY_DATA:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//Source
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObS
                
                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr3=*(pppData+iIndexTmp1);//Destanation
                ppArr4=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObD
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                
                if(pInfoTmp2->mCount>pInfoTmp4->mCount)
                    iCountLoop=pInfoTmp2->mCount;
                else iCountLoop=pInfoTmp4->mCount;
                
                switch(pInfoTmp3->mType)
                {
                    case DATA_INT:
                    {
LOOP_COPY_DATA_INT:;
                        if(iCountLoop==0)break;
                        iCountLoop--;
                        
                        *(pDataLocal+SData3[*SData4])=(int)(*(pDataLocal+SData1[*SData2]));
                        
                        if(SData2!=FData2)SData2++;
                        if(SData4!=FData4)SData4++;
                        
                        goto LOOP_COPY_DATA_INT;
                    }
                    
                    case DATA_FLOAT:
                    {
LOOP_COPY_DATA_FLOAT:;
                        if(iCountLoop==0)break;
                        iCountLoop--;
                        
                        *(pDataLocal+SData3[*SData4])=*(pDataLocal+SData1[*SData2]);
                        
                        if(SData2!=FData2)SData2++;
                        if(SData4!=FData4)SData4++;
                        
                        goto LOOP_COPY_DATA_FLOAT;
                    }

                    case DATA_SPRITE:
                    {
LOOP_COPY_DATA_SPRITE:;
                        if(iCountLoop==0)break;
                        iCountLoop--;

                        I1=(pIDataLocal+SData1[*SData2]);
                        I2=(pIDataLocal+SData3[*SData4]);
                        
                        
                        [ArrayPoints->pCurrenContPar CopySprite:*I2 source:*I1];
                        
//                        *(pDataLocal+SData3[*SData4])=*(pDataLocal+SData1[*SData2]);
                        
                        if(SData2!=FData2)SData2++;
                        if(SData4!=FData4)SData4++;
                        
                        goto LOOP_COPY_DATA_SPRITE;
                    }

                    case DATA_TEXTURE:
                    {
LOOP_COPY_DATA_TEXTURE:;
                        if(iCountLoop==0)break;
                        iCountLoop--;
                        
                        F1=(pDataLocal+SData1[*SData2]);
                        F2=(pDataLocal+SData3[*SData4]);
                        
                        [ArrayPoints->pCurrenContPar->pTexRes CopyRes:(int)*F2 source:(int)*F1];
                        
                        if(SData2!=FData2)SData2++;
                        if(SData4!=FData4)SData4++;
                        
                        goto LOOP_COPY_DATA_TEXTURE;
                    }

                    case DATA_SOUND:
                    {
LOOP_COPY_DATA_SOUND:;
                        if(iCountLoop==0)break;
                        iCountLoop--;
                        
                        F1=(pDataLocal+SData1[*SData2]);
                        F2=(pDataLocal+SData3[*SData4]);
                        
                        [ArrayPoints->pCurrenContPar->pSoundRes CopyRes:(int)*F2 source:(int)*F1];
                        
                        if(SData2!=FData2)SData2++;
                        if(SData4!=FData4)SData4++;
                        
                        goto LOOP_COPY_DATA_SOUND;
                    }
                }

                break;
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            case NAME_O_MOVE_DATA:
                iIndexTmp2=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT);
                if(iIndexTmp2<RESERV_KERNEL)break;
                
                ppArr1=*(pppData+iIndexTmp2);//Source
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObS
                
                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT);
                if(iIndexTmp1<RESERV_KERNEL)break;
                
                ppArr3=*(pppData+iIndexTmp1);//Destanation
                ppArr4=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObDest
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                
                if(pInfoTmp2->mCount>pInfoTmp4->mCount)
                    iCountLoop=pInfoTmp2->mCount;
                else iCountLoop=pInfoTmp4->mCount;
                
LOOP_MOVE_DATA:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                [ArrayPoints DecDataAtIndex:SData3[*SData4]];
                SData3[*SData4]=SData1[*SData2];
                [ArrayPoints IncDataAtIndex:SData3[*SData4]];
                
                if(SData2!=FData2)SData2++;
                if(SData4!=FData4)SData4++;
                
                goto LOOP_MOVE_DATA;
                
                break;
//операция kx+c----------------------------------------------------------------------
            case NAME_O_KX_PLUS_C:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//K
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObK
                
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//X
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObX

                ppArr5=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+4));//C
                ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+5));//ObC

                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr7=*(pppData+iIndexTmp1);//Y
                ppArr8=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObY
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;
                pInfoTmp7 = (InfoArrayValue *)*ppArr7;
                pInfoTmp8 = (InfoArrayValue *)*ppArr8;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                if(pInfoTmp8->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                SData7=(*ppArr7+SIZE_INFO_STRUCT);
                SData8=(*ppArr8+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                FData8=SData8+pInfoTmp8->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                if(pInfoTmp8->mCount>iMinCount)
                    iMinCount=pInfoTmp8->mCount;
                
                iCountLoop=iMinCount;
                
                if(pInfoTmp7->mType==DATA_INT)
                {
LOOP_KX_PLUS_C_INT:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    *(pDataLocal+SData7[*SData8])=(int)(*(pDataLocal+SData5[*SData6])+
                            *(pDataLocal+SData1[*SData2])*(*(pDataLocal+SData3[*SData4])));
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    if(SData8!=FData8)SData8++;
                    
                    goto LOOP_KX_PLUS_C_INT;
                }
                else
                {
LOOP_KX_PLUS_C:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    *(pDataLocal+SData7[*SData8])=*(pDataLocal+SData5[*SData6])+
                    (*(pDataLocal+SData1[*SData2]))*(*(pDataLocal+SData3[*SData4]));
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    if(SData8!=FData8)SData8++;
                    
                    goto LOOP_KX_PLUS_C;
                }
                
                break;
//операция плюс----------------------------------------------------------------------
            case NAME_O_PLUS:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//A
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObA

                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//B
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObB

                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr5=*(pppData+iIndexTmp1);//C
                ppArr6=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObC
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                
                iCountLoop=iMinCount;

                if(pInfoTmp5->mType==DATA_INT)
                {
LOOP_PLUS_INT:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    *(pDataLocal+SData5[*SData6])=(int)(*(pDataLocal+SData3[*SData4])+
                                        *(pDataLocal+SData1[*SData2]));
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;

                    goto LOOP_PLUS_INT;
                }
                else
                {
LOOP_PLUS:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    *(pDataLocal+SData5[*SData6])=*(pDataLocal+SData3[*SData4])+
                                    *(pDataLocal+SData1[*SData2]);
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    
                    goto LOOP_PLUS;
                }

            break;
//операция минус----------------------------------------------------------------------
            case NAME_O_MINUS:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//A
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObA
                
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//B
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObB
                
                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr5=*(pppData+iIndexTmp1);//C
                ppArr6=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObC
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                
                iCountLoop=iMinCount;
                
                if(pInfoTmp5->mType==DATA_INT)
                {
LOOP_MINUS_INT:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    *(pDataLocal+SData5[*SData6])=(int)(*(pDataLocal+SData1[*SData2])-
                                                        *(pDataLocal+SData3[*SData4]));
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    
                    goto LOOP_MINUS_INT;
                }
                else
                {
LOOP_MINUS:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    *(pDataLocal+SData5[*SData6])=*(pDataLocal+SData1[*SData2])-
                    *(pDataLocal+SData3[*SData4]);
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    
                    goto LOOP_MINUS;
                }
                
                break;
//операция минус----------------------------------------------------------------------
            case NAME_O_MULL:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//A
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObA
                
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//B
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObB
                
                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr5=*(pppData+iIndexTmp1);//C
                ppArr6=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObC
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                
                iCountLoop=iMinCount;
                
                if(pInfoTmp5->mType==DATA_INT)
                {
LOOP_MUL_INT:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    *(pDataLocal+SData5[*SData6])=(int)(*(pDataLocal+SData3[*SData4])*
                                                        *(pDataLocal+SData1[*SData2]));
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    
                    goto LOOP_MUL_INT;
                }
                else
                {
LOOP_MUL:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    *(pDataLocal+SData5[*SData6])=*(pDataLocal+SData3[*SData4])*
                    *(pDataLocal+SData1[*SData2]);
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    
                    goto LOOP_MUL;
                }
                
                break;
//операция скалярное произведение---------------------------------------------------------------
            case NAME_O_MUL_SCALAR:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//X1S
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObX1S
                
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//Y1S
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObY1S

                ppArr5=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+4));//X1F
                ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+5));//ObX1F
                
                ppArr7=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+6));//Y1F
                ppArr8=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+7));//ObY1F

                ppArr9=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+8));//X2S
                ppArr10=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+9));//ObX2S
                
                ppArr11=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+10));//Y2S
                ppArr12=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+11));//ObY2S
                
                ppArr13=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+12));//X2F
                ppArr14=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+13));//ObX2F
                
                ppArr15=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+14));//Y2F
                ppArr16=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+15));//ObY2F

                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr17=*(pppData+iIndexTmp1);//R
                ppArr18=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObR
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;
                pInfoTmp7 = (InfoArrayValue *)*ppArr7;
                pInfoTmp8 = (InfoArrayValue *)*ppArr8;
                pInfoTmp9 = (InfoArrayValue *)*ppArr9;
                pInfoTmp10 = (InfoArrayValue *)*ppArr10;
                pInfoTmp11 = (InfoArrayValue *)*ppArr11;
                pInfoTmp12 = (InfoArrayValue *)*ppArr12;
                pInfoTmp13 = (InfoArrayValue *)*ppArr13;
                pInfoTmp14 = (InfoArrayValue *)*ppArr14;
                pInfoTmp15 = (InfoArrayValue *)*ppArr15;
                pInfoTmp16 = (InfoArrayValue *)*ppArr16;
                pInfoTmp17 = (InfoArrayValue *)*ppArr17;
                pInfoTmp18 = (InfoArrayValue *)*ppArr18;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                if(pInfoTmp8->mCount==0)break;
                if(pInfoTmp10->mCount==0)break;
                if(pInfoTmp12->mCount==0)break;
                if(pInfoTmp14->mCount==0)break;
                if(pInfoTmp16->mCount==0)break;
                if(pInfoTmp18->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                SData7=(*ppArr7+SIZE_INFO_STRUCT);
                SData8=(*ppArr8+SIZE_INFO_STRUCT);
                SData9=(*ppArr9+SIZE_INFO_STRUCT);
                SData10=(*ppArr10+SIZE_INFO_STRUCT);
                SData11=(*ppArr11+SIZE_INFO_STRUCT);
                SData12=(*ppArr12+SIZE_INFO_STRUCT);
                SData13=(*ppArr13+SIZE_INFO_STRUCT);
                SData14=(*ppArr14+SIZE_INFO_STRUCT);
                SData15=(*ppArr15+SIZE_INFO_STRUCT);
                SData16=(*ppArr16+SIZE_INFO_STRUCT);
                SData17=(*ppArr17+SIZE_INFO_STRUCT);
                SData18=(*ppArr18+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                FData8=SData8+pInfoTmp8->mCount-1;
                FData10=SData10+pInfoTmp10->mCount-1;
                FData12=SData12+pInfoTmp12->mCount-1;
                FData14=SData14+pInfoTmp14->mCount-1;
                FData16=SData16+pInfoTmp16->mCount-1;
                FData18=SData18+pInfoTmp18->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                if(pInfoTmp8->mCount>iMinCount)
                    iMinCount=pInfoTmp8->mCount;
                if(pInfoTmp10->mCount>iMinCount)
                    iMinCount=pInfoTmp10->mCount;
                if(pInfoTmp12->mCount>iMinCount)
                    iMinCount=pInfoTmp12->mCount;
                if(pInfoTmp14->mCount>iMinCount)
                    iMinCount=pInfoTmp14->mCount;
                if(pInfoTmp16->mCount>iMinCount)
                    iMinCount=pInfoTmp16->mCount;
                if(pInfoTmp18->mCount>iMinCount)
                    iMinCount=pInfoTmp18->mCount;
                
                iCountLoop=iMinCount;
                
                if(pInfoTmp17->mType==DATA_INT)
                {
LOOP_MUL_SCALAR_INT:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=(pDataLocal+SData1[*SData2]);//X1S
                    F2=(pDataLocal+SData3[*SData4]);//Y1S
                    F3=(pDataLocal+SData5[*SData6]);//X1F
                    F4=(pDataLocal+SData7[*SData8]);//Y1F

                    F5=(pDataLocal+SData9[*SData10]);//X2S
                    F6=(pDataLocal+SData11[*SData12]);//Y2S
                    F7=(pDataLocal+SData13[*SData14]);//X2F
                    F8=(pDataLocal+SData15[*SData16]);//Y2F

                    F9=(pDataLocal+SData17[*SData18]);//R
                    
                    *F9=(int)(((*F3-*F1)*(*F7-*F5))+((*F4-*F2)*(*F8-*F6)));
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    if(SData8!=FData8)SData8++;
                    if(SData10!=FData10)SData10++;
                    if(SData12!=FData12)SData12++;
                    if(SData14!=FData14)SData14++;
                    if(SData16!=FData16)SData16++;
                    if(SData18!=FData18)SData18++;
                    
                    goto LOOP_MUL_SCALAR_INT;
                }
                else
                {
LOOP_MUL_SCALAR:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=(pDataLocal+SData1[*SData2]);//X1S
                    F2=(pDataLocal+SData3[*SData4]);//Y1S
                    F3=(pDataLocal+SData5[*SData6]);//X1F
                    F4=(pDataLocal+SData7[*SData8]);//Y1F
                    
                    F5=(pDataLocal+SData9[*SData10]);//X2S
                    F6=(pDataLocal+SData11[*SData12]);//Y2S
                    F7=(pDataLocal+SData13[*SData14]);//X2F
                    F8=(pDataLocal+SData15[*SData16]);//Y2F
                    
                    F9=(pDataLocal+SData17[*SData18]);//R
                    
                    *F9=((*F3-*F1)*(*F7-*F5))+((*F4-*F2)*(*F8-*F6));
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    if(SData8!=FData8)SData8++;
                    if(SData10!=FData10)SData10++;
                    if(SData12!=FData12)SData12++;
                    if(SData14!=FData14)SData14++;
                    if(SData16!=FData16)SData16++;
                    if(SData18!=FData18)SData18++;
                    
                    goto LOOP_MUL_SCALAR;
                }
                
                break;
//операция скалярное произведение---------------------------------------------------------------
            case NAME_O_ANGLE:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//X1S
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObX1S
                
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//Y1S
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObY1S
                
                ppArr5=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+4));//X1F
                ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+5));//ObX1F
                
                ppArr7=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+6));//Y1F
                ppArr8=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+7));//ObY1F
                
                ppArr9=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+8));//X2S
                ppArr10=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+9));//ObX2S
                
                ppArr11=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+10));//Y2S
                ppArr12=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+11));//ObY2S
                
                ppArr13=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+12));//X2F
                ppArr14=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+13));//ObX2F
                
                ppArr15=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+14));//Y2F
                ppArr16=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+15));//ObY2F
                
                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr17=*(pppData+iIndexTmp1);//R
                ppArr18=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObR
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;
                pInfoTmp7 = (InfoArrayValue *)*ppArr7;
                pInfoTmp8 = (InfoArrayValue *)*ppArr8;
                pInfoTmp9 = (InfoArrayValue *)*ppArr9;
                pInfoTmp10 = (InfoArrayValue *)*ppArr10;
                pInfoTmp11 = (InfoArrayValue *)*ppArr11;
                pInfoTmp12 = (InfoArrayValue *)*ppArr12;
                pInfoTmp13 = (InfoArrayValue *)*ppArr13;
                pInfoTmp14 = (InfoArrayValue *)*ppArr14;
                pInfoTmp15 = (InfoArrayValue *)*ppArr15;
                pInfoTmp16 = (InfoArrayValue *)*ppArr16;
                pInfoTmp17 = (InfoArrayValue *)*ppArr17;
                pInfoTmp18 = (InfoArrayValue *)*ppArr18;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                if(pInfoTmp8->mCount==0)break;
                if(pInfoTmp10->mCount==0)break;
                if(pInfoTmp12->mCount==0)break;
                if(pInfoTmp14->mCount==0)break;
                if(pInfoTmp16->mCount==0)break;
                if(pInfoTmp18->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                SData7=(*ppArr7+SIZE_INFO_STRUCT);
                SData8=(*ppArr8+SIZE_INFO_STRUCT);
                SData9=(*ppArr9+SIZE_INFO_STRUCT);
                SData10=(*ppArr10+SIZE_INFO_STRUCT);
                SData11=(*ppArr11+SIZE_INFO_STRUCT);
                SData12=(*ppArr12+SIZE_INFO_STRUCT);
                SData13=(*ppArr13+SIZE_INFO_STRUCT);
                SData14=(*ppArr14+SIZE_INFO_STRUCT);
                SData15=(*ppArr15+SIZE_INFO_STRUCT);
                SData16=(*ppArr16+SIZE_INFO_STRUCT);
                SData17=(*ppArr17+SIZE_INFO_STRUCT);
                SData18=(*ppArr18+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                FData8=SData8+pInfoTmp8->mCount-1;
                FData10=SData10+pInfoTmp10->mCount-1;
                FData12=SData12+pInfoTmp12->mCount-1;
                FData14=SData14+pInfoTmp14->mCount-1;
                FData16=SData16+pInfoTmp16->mCount-1;
                FData18=SData18+pInfoTmp18->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                if(pInfoTmp8->mCount>iMinCount)
                    iMinCount=pInfoTmp8->mCount;
                if(pInfoTmp10->mCount>iMinCount)
                    iMinCount=pInfoTmp10->mCount;
                if(pInfoTmp12->mCount>iMinCount)
                    iMinCount=pInfoTmp12->mCount;
                if(pInfoTmp14->mCount>iMinCount)
                    iMinCount=pInfoTmp14->mCount;
                if(pInfoTmp16->mCount>iMinCount)
                    iMinCount=pInfoTmp16->mCount;
                if(pInfoTmp18->mCount>iMinCount)
                    iMinCount=pInfoTmp18->mCount;
                
                iCountLoop=iMinCount;
                
                if(pInfoTmp17->mType==DATA_INT)
                {
LOOP_MUL_ANGLE_INT:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=(pDataLocal+SData1[*SData2]);//X1S
                    F2=(pDataLocal+SData3[*SData4]);//Y1S
                    F3=(pDataLocal+SData5[*SData6]);//X1F
                    F4=(pDataLocal+SData7[*SData8]);//Y1F
                    
                    F5=(pDataLocal+SData9[*SData10]);//X2S
                    F6=(pDataLocal+SData11[*SData12]);//Y2S
                    F7=(pDataLocal+SData13[*SData14]);//X2F
                    F8=(pDataLocal+SData15[*SData16]);//Y2F
                    
                    F9=(pDataLocal+SData17[*SData18]);//R
                    
                    X_1=(*F3-*F1);
                    X_2=(*F7-*F5);
                    
                    Y_1=(*F4-*F2);
                    Y_2=(*F8-*F6);

                    tmpf=(X_1*X_2+Y_1*Y_2);
                    tmpf2=Y_2*X_1-Y_1*X_2;
                    
                    l_A=sqrtf(X_1*X_1+Y_1*Y_1);
                    l_B=sqrtf(X_2*X_2+Y_2*Y_2);
                    
                    if(l_A==0 || l_B==0)
                    {
                        *F9=0;
                    }
                    else
                    {
                        tmpf3=tmpf/(l_A*l_B);
                        if(tmpf3>1)tmpf3=1;
                        else if(tmpf3<-1)tmpf3=-1;

                        if(tmpf2>0)
                            *F9=(int)(acosf(tmpf3));
                        else *F9=-(int)(acosf(tmpf3));

                        //*F7=(int)(((*F3-*F1)*(*F7-*F5))+((*F4-*F2)*(*F8-*F6)));
                    }
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    if(SData8!=FData8)SData8++;
                    if(SData10!=FData10)SData10++;
                    if(SData12!=FData12)SData12++;
                    if(SData14!=FData14)SData14++;
                    if(SData16!=FData16)SData16++;
                    if(SData18!=FData18)SData18++;
                    
                    goto LOOP_MUL_ANGLE_INT;
                }
                else
                {
LOOP_MUL_ANGLE:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=(pDataLocal+SData1[*SData2]);//X1S
                    F2=(pDataLocal+SData3[*SData4]);//Y1S
                    F3=(pDataLocal+SData5[*SData6]);//X1F
                    F4=(pDataLocal+SData7[*SData8]);//Y1F
                    
                    F5=(pDataLocal+SData9[*SData10]);//X2S
                    F6=(pDataLocal+SData11[*SData12]);//Y2S
                    F7=(pDataLocal+SData13[*SData14]);//X2F
                    F8=(pDataLocal+SData15[*SData16]);//Y2F
                    
                    F9=(pDataLocal+SData17[*SData18]);//R
                    
                    X_1=(*F3-*F1);
                    X_2=(*F7-*F5);
                    
                    Y_1=(*F4-*F2);
                    Y_2=(*F8-*F6);
                    
                    tmpf=(X_1*X_2+Y_1*Y_2);
                    tmpf2=Y_2*X_1-Y_1*X_2;
                    
                    l_A=sqrtf(X_1*X_1+Y_1*Y_1);
                    l_B=sqrtf(X_2*X_2+Y_2*Y_2);
                    
                    if(l_A==0 || l_B==0)
                    {
                        *F9=0;
                    }
                    else
                    {
                        tmpf3=tmpf/(l_A*l_B);
                        if(tmpf3>1)tmpf3=1;
                        else if(tmpf3<-1)tmpf3=-1;
                        
                        if(tmpf2>0)
                            *F9=(acosf(tmpf3));
                        else *F9=-(acosf(tmpf3));
                        
                        //*F7=(int)(((*F3-*F1)*(*F7-*F5))+((*F4-*F2)*(*F8-*F6)));
                    }
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    if(SData8!=FData8)SData8++;
                    if(SData10!=FData10)SData10++;
                    if(SData12!=FData12)SData12++;
                    if(SData14!=FData14)SData14++;
                    if(SData16!=FData16)SData16++;
                    if(SData18!=FData18)SData18++;
                    
                    goto LOOP_MUL_ANGLE;
                }
                
                break;
//операция длина вектора----------------------------------------------------------------------
            case NAME_O_DIST:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//XS
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObXS
                
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//YS
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObYS
                
                ppArr5=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+4));//XF
                ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+5));//ObXF
                
                ppArr7=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+6));//YF
                ppArr8=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+7));//ObYF
                
                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr9=*(pppData+iIndexTmp1);//R
                ppArr10=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObR
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;
                pInfoTmp7 = (InfoArrayValue *)*ppArr7;
                pInfoTmp8 = (InfoArrayValue *)*ppArr8;
                pInfoTmp9 = (InfoArrayValue *)*ppArr9;
                pInfoTmp10 = (InfoArrayValue *)*ppArr10;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                if(pInfoTmp8->mCount==0)break;
                if(pInfoTmp10->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                SData7=(*ppArr7+SIZE_INFO_STRUCT);
                SData8=(*ppArr8+SIZE_INFO_STRUCT);
                SData9=(*ppArr9+SIZE_INFO_STRUCT);
                SData10=(*ppArr10+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                FData8=SData8+pInfoTmp8->mCount-1;
                FData10=SData10+pInfoTmp10->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                if(pInfoTmp8->mCount>iMinCount)
                    iMinCount=pInfoTmp8->mCount;
                if(pInfoTmp10->mCount>iMinCount)
                    iMinCount=pInfoTmp10->mCount;
                
                iCountLoop=iMinCount;
                
                if(pInfoTmp9->mType==DATA_INT)
                {
LOOP_DIST_INT:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=(pDataLocal+SData1[*SData2]);//XS
                    F2=(pDataLocal+SData3[*SData4]);//YS
                    F3=(pDataLocal+SData5[*SData6]);//XF
                    F4=(pDataLocal+SData7[*SData8]);//YF
                    
                    F5=(pDataLocal+SData9[*SData10]);//R
                    
                    *F5=(int)sqrtf((((*F3-*F1)*(*F3-*F1))+((*F4-*F2)*(*F4-*F2))));
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    if(SData8!=FData8)SData8++;
                    if(SData10!=FData10)SData10++;
                    
                    goto LOOP_DIST_INT;
                }
                else
                {
LOOP_DIST:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=(pDataLocal+SData1[*SData2]);//XS
                    F2=(pDataLocal+SData3[*SData4]);//YS
                    F3=(pDataLocal+SData5[*SData6]);//XF
                    F4=(pDataLocal+SData7[*SData8]);//YF
                    
                    F5=(pDataLocal+SData9[*SData10]);//R
                    
                    *F5=sqrtf((((*F3-*F1)*(*F3-*F1))+((*F4-*F2)*(*F4-*F2))));
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    if(SData8!=FData8)SData8++;
                    if(SData10!=FData10)SData10++;
                    
                    goto LOOP_DIST;
                }
                
                break;
//операция деления----------------------------------------------------------------------
            case NAME_O_DIV:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//A
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObA
                
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//B
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObB
                
                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr5=*(pppData+iIndexTmp1);//C
                ppArr6=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObC
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                
                iCountLoop=iMinCount;
                
                if(pInfoTmp5->mType==DATA_INT)
                {
LOOP_DIV_INT:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=(pDataLocal+SData3[*SData4]);
                    
                    if(*F1!=0)
                        *(pDataLocal+SData5[*SData6])=(int)(*(pDataLocal+SData1[*SData2])/(*F1));
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    
                    goto LOOP_DIV_INT;
                }
                else
                {
LOOP_DIV:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=(pDataLocal+SData3[*SData4]);
                    
                    if(*F1!=0)
                        *(pDataLocal+SData5[*SData6])=*(pDataLocal+SData1[*SData2])/(*F1);
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    
                    goto LOOP_DIV;
                }
                
                break;
//операция деления с остатком----------------------------------------------------------------------
            case NAME_O_DIV_OST:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//A
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObA
                
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//B
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObB
                
                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr5=*(pppData+iIndexTmp1);//C
                ppArr6=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObC
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                
                iCountLoop=iMinCount;
                
                
LOOP_DIV_OST:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                F1=(pDataLocal+SData3[*SData4]);
                
                if(*F1==0)*(pDataLocal+SData5[*SData6])=0;
                else *(pDataLocal+SData5[*SData6])=(int)(((int)*(pDataLocal+SData1[*SData2]))%(int)(*F1));
                
                if(SData2!=FData2)SData2++;
                if(SData4!=FData4)SData4++;
                if(SData6!=FData6)SData6++;
                
                goto LOOP_DIV_OST;
                
                break;
//операция "+="---------------------------------------------------------------------
            case NAME_O_PLUS_EQUAL:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//A
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObA
                
                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr3=*(pppData+iIndexTmp1);//B
                ppArr4=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObB
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                
                iMinCount=0;

                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                
                iCountLoop=iMinCount;
                
                if(pInfoTmp3->mType==DATA_INT)
                {
LOOP_PLUS_EQUAL_INT:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=(pDataLocal+SData1[*SData2]);
                    F2=(pDataLocal+SData3[*SData4]);
                    
                    *F2=(int)((*F2)+(*F1));
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    
                    goto LOOP_PLUS_EQUAL_INT;
                }
                else
                {
LOOP_PLUS_EQUAL:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    *(pDataLocal+SData3[*SData4])+=*(pDataLocal+SData1[*SData2]);
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    
                    goto LOOP_PLUS_EQUAL;
                }
                
                break;
//операция "-="---------------------------------------------------------------------
            case NAME_O_MINUS_EQUAL:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//A
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObA
                
                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr3=*(pppData+iIndexTmp1);//B
                ppArr4=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObB
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                
                iCountLoop=iMinCount;
                
                if(pInfoTmp3->mType==DATA_INT)
                {
LOOP_MINUS_EQUAL_INT:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=(pDataLocal+SData1[*SData2]);
                    F2=(pDataLocal+SData3[*SData4]);
                    
                    *F2=(int)((*F2)-(*F1));
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    
                    goto LOOP_MINUS_EQUAL_INT;
                }
                else
                {
LOOP_MINUS_EQUAL:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    *(pDataLocal+SData3[*SData4])-=*(pDataLocal+SData1[*SData2]);
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    
                    goto LOOP_MINUS_EQUAL;
                }
                
                break;
//операция "*="---------------------------------------------------------------------
            case NAME_O_MUL_EQUAL:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//A
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObA
                
                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr3=*(pppData+iIndexTmp1);//B
                ppArr4=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObB
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                
                iCountLoop=iMinCount;
                
                if(pInfoTmp3->mType==DATA_INT)
                {
LOOP_MULL_EQUAL_INT:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=(pDataLocal+SData1[*SData2]);
                    F2=(pDataLocal+SData3[*SData4]);
                    
                    *F2=(int)((*F2)*(*F1));
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    
                    goto LOOP_MULL_EQUAL_INT;
                }
                else
                {
LOOP_MULL_EQUAL:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    *(pDataLocal+SData3[*SData4])*=*(pDataLocal+SData1[*SData2]);
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    
                    goto LOOP_MULL_EQUAL;
                }
                
                break;
//операция "/="---------------------------------------------------------------------
            case NAME_O_DIV_EQUAL:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//A
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObA
                
                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr3=*(pppData+iIndexTmp1);//B
                ppArr4=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObB
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                
                iCountLoop=iMinCount;
                
                if(pInfoTmp3->mType==DATA_INT)
                {
LOOP_DIV_EQUAL_INT:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=(pDataLocal+SData1[*SData2]);
                    F2=(pDataLocal+SData3[*SData4]);
                    
                    if(*F1!=0)
                        *F2=(int)((*F2)/(*F1));

                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    
                    goto LOOP_DIV_EQUAL_INT;
                }
                else
                {
LOOP_DIV_EQUAL:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=(pDataLocal+SData1[*SData2]);
                    
                    if(*F1!=0)
                        *(pDataLocal+SData3[*SData4])/=*F1;
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    
                    goto LOOP_DIV_EQUAL;
                }
                
                break;
//операция "%="---------------------------------------------------------------------
            case NAME_O_DIV_OST_EQUAL:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//A
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObA
                
                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr3=*(pppData+iIndexTmp1);//B
                ppArr4=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObB
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                
                iCountLoop=iMinCount;
                
LOOP_DIV_OST_EQUAL:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                F1=(pDataLocal+SData1[*SData2]);
                
                if(*F1!=0)
                {
                    int Oper1=(int)(*(pDataLocal+SData3[*SData4]));
                    int Oper2=(int)(*(pDataLocal+SData1[*SData2]));

                    if(Oper2==0)Oper1=0;
                    else Oper1%=Oper2;
                    
                    *(pDataLocal+SData3[*SData4])=Oper1;
                }
                
                if(SData2!=FData2)SData2++;
                if(SData4!=FData4)SData4++;
                
                goto LOOP_DIV_OST_EQUAL;
                break;
//операция "+="---------------------------------------------------------------------
            case NAME_O_NUMBER:
                
                iIndexTmp1=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr1=*(pppData+iIndexTmp1);//A
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObA
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;//ObA
                
                if(pInfoTmp2->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                iCountLoop=pInfoTmp2->mCount;
                CountI=0;
LOOP_NUMBER:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                F1=pDataLocal+SData1[*SData2];
                *F1=CountI;
                CountI++;
                
                if(SData2!=FData2)SData2++;
                
                goto LOOP_NUMBER;
                
                break;
//операция update DL---------------------------------------------------------------------
            case NAME_O_DL_XY:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//X
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObX
                
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//Y
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObY
                
                ppArr5=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+4));//S
                ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+5));//ObS
                
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                
                iCountLoop=iMinCount;
                
LOOP_DL_XY:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                F1=(pDataLocal+SData1[*SData2]);//X
                F2=(pDataLocal+SData3[*SData4]);//Y
                I1=(pIDataLocal+SData5[*SData6]);//Sprite
//=====================================================================================
                m_pVertices=(pParContainer->vertices+(*I1)*6);
                
                m_pVertices[2]=Vector3DMake(*F1,*F2,0);
                m_pVertices[4]=m_pVertices[2];
//=====================================================================================
                if(SData2!=FData2)SData2++;
                if(SData4!=FData4)SData4++;
                if(SData6!=FData6)SData6++;
                
                goto LOOP_DL_XY;
                break;
//операция update DR---------------------------------------------------------------------
            case NAME_O_DR_XY:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//X
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObX
                
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//Y
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObY
                
                ppArr5=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+4));//S
                ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+5));//ObS
                
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                
                iCountLoop=iMinCount;
                
LOOP_DR_XY:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                F1=(pDataLocal+SData1[*SData2]);//X
                F2=(pDataLocal+SData3[*SData4]);//Y
                I1=(pIDataLocal+SData5[*SData6]);//Sprite
//=====================================================================================
                m_pVertices=(pParContainer->vertices+(*I1)*6);
                m_pVertices[3]=Vector3DMake(*F1,*F2,0);
//=====================================================================================
                if(SData2!=FData2)SData2++;
                if(SData4!=FData4)SData4++;
                if(SData6!=FData6)SData6++;
                
                goto LOOP_DR_XY;
                break;
//операция update UL---------------------------------------------------------------------
            case NAME_O_UL_XY:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//X
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObX
                
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//Y
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObY
                
                ppArr5=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+4));//S
                ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+5));//ObS
                
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                
                iCountLoop=iMinCount;
                
LOOP_UL_XY:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                F1=(pDataLocal+SData1[*SData2]);//X
                F2=(pDataLocal+SData3[*SData4]);//Y
                I1=(pIDataLocal+SData5[*SData6]);//Sprite
//=====================================================================================
                m_pVertices=(pParContainer->vertices+(*I1)*6);
                m_pVertices[0]=Vector3DMake(*F1,*F2,0);
//=====================================================================================
                if(SData2!=FData2)SData2++;
                if(SData4!=FData4)SData4++;
                if(SData6!=FData6)SData6++;
                
                goto LOOP_UL_XY;
                break;
//операция update UR---------------------------------------------------------------------
            case NAME_O_UR_XY:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//X
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObX
                
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//Y
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObY
                
                ppArr5=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+4));//S
                ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+5));//ObS
                
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                
                iCountLoop=iMinCount;
                
LOOP_UR_XY:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                F1=(pDataLocal+SData1[*SData2]);//X
                F2=(pDataLocal+SData3[*SData4]);//Y
                I1=(pIDataLocal+SData5[*SData6]);//Sprite
//=====================================================================================
                m_pVertices=(pParContainer->vertices+(*I1)*6);
                m_pVertices[1]=Vector3DMake(*F1,*F2,0);
                m_pVertices[5]=m_pVertices[1];
//=====================================================================================
                if(SData2!=FData2)SData2++;
                if(SData4!=FData4)SData4++;
                if(SData6!=FData6)SData6++;
                
                goto LOOP_UR_XY;
                break;
//операция update DL tex---------------------------------------------------------------------
            case NAME_O_DL_UV_TEX:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//X
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObX
                
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//Y
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObY
                
                ppArr5=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+4));//S
                ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+5));//ObS
                
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                
                iCountLoop=iMinCount;
                
LOOP_DL_XY_TEX:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                F1=(pDataLocal+SData1[*SData2]);//X
                F2=(pDataLocal+SData3[*SData4]);//Y
                I1=(pIDataLocal+SData5[*SData6]);//Sprite
//=====================================================================================
                m_pTexturUV=(pParContainer->texCoords+(*I1)*12);
                
                m_pTexturUV[4]=*F1;
                m_pTexturUV[5]=*F2;
                m_pTexturUV[8]=m_pTexturUV[4];
                m_pTexturUV[9]=m_pTexturUV[5];
//=====================================================================================
                if(SData2!=FData2)SData2++;
                if(SData4!=FData4)SData4++;
                if(SData6!=FData6)SData6++;
                
                goto LOOP_DL_XY_TEX;
                break;
//операция update DR tex---------------------------------------------------------------------
            case NAME_O_DR_UV_TEX:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//X
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObX
                
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//Y
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObY
                
                ppArr5=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+4));//S
                ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+5));//ObS
                
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                
                iCountLoop=iMinCount;
                
LOOP_DR_XY_TEX:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                F1=(pDataLocal+SData1[*SData2]);//X
                F2=(pDataLocal+SData3[*SData4]);//Y
                I1=(pIDataLocal+SData5[*SData6]);//Sprite
//=====================================================================================
                m_pTexturUV=(pParContainer->texCoords+(*I1)*12);
                
                m_pTexturUV[6]=*F1;
                m_pTexturUV[7]=*F2;
//=====================================================================================
                if(SData2!=FData2)SData2++;
                if(SData4!=FData4)SData4++;
                if(SData6!=FData6)SData6++;
                
                goto LOOP_DR_XY_TEX;
                break;
//операция update UL tex---------------------------------------------------------------------
            case NAME_O_UL_UV_TEX:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//X
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObX
                
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//Y
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObY
                
                ppArr5=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+4));//S
                ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+5));//ObS
                
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                
                iCountLoop=iMinCount;
                
LOOP_UL_XY_TEX:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                F1=(pDataLocal+SData1[*SData2]);//X
                F2=(pDataLocal+SData3[*SData4]);//Y
                I1=(pIDataLocal+SData5[*SData6]);//Sprite
//=====================================================================================
                m_pTexturUV=(pParContainer->texCoords+(*I1)*12);
                
                m_pTexturUV[0]=*F1;
                m_pTexturUV[1]=*F2;
//=====================================================================================
                if(SData2!=FData2)SData2++;
                if(SData4!=FData4)SData4++;
                if(SData6!=FData6)SData6++;
                
                goto LOOP_UL_XY_TEX;
                break;
//операция update UR tex---------------------------------------------------------------------
    case NAME_O_UR_UV_TEX:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//X
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObX
                
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//Y
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObY
                
                ppArr5=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+4));//S
                ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+5));//ObS
                
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                
                iCountLoop=iMinCount;
                
LOOP_UR_XY_TEX:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                F1=(pDataLocal+SData1[*SData2]);//X
                F2=(pDataLocal+SData3[*SData4]);//Y
                I1=(pIDataLocal+SData5[*SData6]);//Sprite
//=====================================================================================
                m_pTexturUV=(pParContainer->texCoords+(*I1)*12);
                
                m_pTexturUV[2]=*F1;
                m_pTexturUV[3]=*F2;
                m_pTexturUV[10]=m_pTexturUV[2];
                m_pTexturUV[11]=m_pTexturUV[3];
//=====================================================================================
                if(SData2!=FData2)SData2++;
                if(SData4!=FData4)SData4++;
                if(SData6!=FData6)SData6++;
                
                goto LOOP_UR_XY_TEX;
                break;
//операция update---------------------------------------------------------------------
            case NAME_O_UPDATE_XY:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//X
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObX
                
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//Y
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObY

                ppArr5=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+4));//W
                ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+5));//ObW
                
                ppArr7=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+6));//H
                ppArr8=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+7));//ObH

                ppArr9=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+8));//A
                ppArr10=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+9));//ObA

                ppArr11=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+10));//S
                ppArr12=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+11));//ObS
                

                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;
                pInfoTmp7 = (InfoArrayValue *)*ppArr7;
                pInfoTmp8 = (InfoArrayValue *)*ppArr8;
                pInfoTmp9 = (InfoArrayValue *)*ppArr9;
                pInfoTmp10 = (InfoArrayValue *)*ppArr10;
                pInfoTmp11 = (InfoArrayValue *)*ppArr11;
                pInfoTmp12 = (InfoArrayValue *)*ppArr12;

                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                if(pInfoTmp8->mCount==0)break;
                if(pInfoTmp10->mCount==0)break;
                if(pInfoTmp12->mCount==0)break;

                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                SData7=(*ppArr7+SIZE_INFO_STRUCT);
                SData8=(*ppArr8+SIZE_INFO_STRUCT);
                SData9=(*ppArr9+SIZE_INFO_STRUCT);
                SData10=(*ppArr10+SIZE_INFO_STRUCT);
                SData11=(*ppArr11+SIZE_INFO_STRUCT);
                SData12=(*ppArr12+SIZE_INFO_STRUCT);

                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                FData8=SData8+pInfoTmp8->mCount-1;
                FData10=SData10+pInfoTmp10->mCount-1;
                FData12=SData12+pInfoTmp12->mCount-1;

                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                if(pInfoTmp8->mCount>iMinCount)
                    iMinCount=pInfoTmp8->mCount;
                if(pInfoTmp10->mCount>iMinCount)
                    iMinCount=pInfoTmp10->mCount;
                if(pInfoTmp12->mCount>iMinCount)
                    iMinCount=pInfoTmp12->mCount;
                
                iCountLoop=iMinCount;

LOOP_UPDATE_XY:;
                if(iCountLoop==0)break;
                iCountLoop--;

                F1=(pDataLocal+SData1[*SData2]);//X
                F2=(pDataLocal+SData3[*SData4]);//Y
                F3=(pDataLocal+SData5[*SData6]);//W
                F4=(pDataLocal+SData7[*SData8]);//H
                F5=(pDataLocal+SData9[*SData10]);//A

                I1=(pIDataLocal+SData11[*SData12]);//Sprite
//=====================================================================================                
                m_pVertices=(pParContainer->vertices+(*I1)*6);
                
                float fAngleRadians=-*F5;/**0.01744f;*/
                
                float fCos=cosf(fAngleRadians);//1
                float fSin=sinf(fAngleRadians);//0
                
                float fHalfW=*F3*0.5f;
                float fHalfH=*F4*0.5f;
                
        m_pVertices[0]=Vector3DMake(-fHalfW*fCos-fHalfH*fSin+(*F1),-fHalfW*fSin+fHalfH*fCos+(*F2),0.0f);
        m_pVertices[1]=Vector3DMake(fHalfW*fCos-fHalfH*fSin+(*F1),fHalfW*fSin+fHalfH*fCos+(*F2),0.0f);
        m_pVertices[2]=Vector3DMake(-fHalfW*fCos+fHalfH*fSin+(*F1),-fHalfW*fSin-fHalfH*fCos+(*F2),0.0f);
        m_pVertices[3]=Vector3DMake(fHalfW*fCos+fHalfH*fSin+(*F1),fHalfW*fSin-fHalfH*fCos+(*F2),0.0f);
                
                m_pVertices[4]=m_pVertices[2];
                m_pVertices[5]=m_pVertices[1];
//=====================================================================================
                if(SData2!=FData2)SData2++;
                if(SData4!=FData4)SData4++;
                if(SData6!=FData6)SData6++;
                if(SData8!=FData8)SData8++;
                if(SData10!=FData10)SData10++;
                if(SData12!=FData12)SData12++;
                
                goto LOOP_UPDATE_XY;
                break;
//операция update color-----------------------------------------------------------------
case NAME_O_UPDATE_COLOR:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//R
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObR
                
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//G
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObG
                
                ppArr5=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+4));//B
                ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+5));//ObB
                
                ppArr7=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+6));//A
                ppArr8=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+7));//ObA
                                
                ppArr9=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+8));//S
                ppArr10=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+9));//ObS
                
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;
                pInfoTmp7 = (InfoArrayValue *)*ppArr7;
                pInfoTmp8 = (InfoArrayValue *)*ppArr8;
                pInfoTmp9 = (InfoArrayValue *)*ppArr9;
                pInfoTmp10 = (InfoArrayValue *)*ppArr10;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                if(pInfoTmp8->mCount==0)break;
                if(pInfoTmp10->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                SData7=(*ppArr7+SIZE_INFO_STRUCT);
                SData8=(*ppArr8+SIZE_INFO_STRUCT);
                SData9=(*ppArr9+SIZE_INFO_STRUCT);
                SData10=(*ppArr10+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                FData8=SData8+pInfoTmp8->mCount-1;
                FData10=SData10+pInfoTmp10->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                if(pInfoTmp8->mCount>iMinCount)
                    iMinCount=pInfoTmp8->mCount;
                if(pInfoTmp10->mCount>iMinCount)
                    iMinCount=pInfoTmp10->mCount;
                
                iCountLoop=iMinCount;
                
LOOP_UPDATE_COLOR:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                F1=(pDataLocal+SData1[*SData2]);//R
                F2=(pDataLocal+SData3[*SData4]);//G
                F3=(pDataLocal+SData5[*SData6]);//B
                F4=(pDataLocal+SData7[*SData8]);//A
                
                I1=(pIDataLocal+SData9[*SData10]);//Sprite
//=====================================================================================
                GLubyte *m_pSquareColors=(pParContainer->squareColors+(*I1)*24);
                
                ////цвет вершин
                m_pSquareColors[0]=(*F1)*255;
                m_pSquareColors[1]=(*F2)*255;
                m_pSquareColors[2]=(*F3)*255;
                m_pSquareColors[3]=(*F4)*255;
                
                m_pSquareColors[4]=(*F1)*255;
                m_pSquareColors[5]=(*F2)*255;
                m_pSquareColors[6]=(*F3)*255;
                m_pSquareColors[7]=(*F4)*255;
                
                m_pSquareColors[8]=(*F1)*255;
                m_pSquareColors[9]=(*F2)*255;
                m_pSquareColors[10]=(*F3)*255;
                m_pSquareColors[11]=(*F4)*255;
                
                m_pSquareColors[12]=(*F1)*255;
                m_pSquareColors[13]=(*F2)*255;
                m_pSquareColors[14]=(*F3)*255;
                m_pSquareColors[15]=(*F4)*255;
                
                m_pSquareColors[16]=m_pSquareColors[8];
                m_pSquareColors[17]=m_pSquareColors[9];
                m_pSquareColors[18]=m_pSquareColors[10];
                m_pSquareColors[19]=m_pSquareColors[11];
                
                m_pSquareColors[20]=m_pSquareColors[4];
                m_pSquareColors[21]=m_pSquareColors[5];
                m_pSquareColors[22]=m_pSquareColors[6];
                m_pSquareColors[23]=m_pSquareColors[7];

//=====================================================================================
                if(SData2!=FData2)SData2++;
                if(SData4!=FData4)SData4++;
                if(SData6!=FData6)SData6++;
                if(SData8!=FData8)SData8++;
                if(SData10!=FData10)SData10++;
                
                goto LOOP_UPDATE_COLOR;
                break;
//операция sin-----------------------------------------------------------------
            case NAME_O_SIN:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//P
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObP

                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//M
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObM

                ppArr5=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+4));//A
                ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+5));//ObA
                
                ppArr7=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+6));//O
                ppArr8=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+7));//ObO
                
                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT);
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr9=*(pppData+iIndexTmp1);//R
                ppArr10=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObR
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;
                pInfoTmp7 = (InfoArrayValue *)*ppArr7;
                pInfoTmp8 = (InfoArrayValue *)*ppArr8;
                pInfoTmp9 = (InfoArrayValue *)*ppArr9;
                pInfoTmp10 = (InfoArrayValue *)*ppArr10;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                if(pInfoTmp8->mCount==0)break;
                if(pInfoTmp10->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                SData7=(*ppArr7+SIZE_INFO_STRUCT);
                SData8=(*ppArr8+SIZE_INFO_STRUCT);
                SData9=(*ppArr9+SIZE_INFO_STRUCT);
                SData10=(*ppArr10+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                FData8=SData8+pInfoTmp8->mCount-1;
                FData10=SData10+pInfoTmp10->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                if(pInfoTmp8->mCount>iMinCount)
                    iMinCount=pInfoTmp8->mCount;
                if(pInfoTmp10->mCount>iMinCount)
                    iMinCount=pInfoTmp10->mCount;
                
                iCountLoop=iMinCount;
                
                if(pInfoTmp9->mType==DATA_INT)
                {
LOOP_SIN_INT:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=(pDataLocal+SData1[*SData2]);//P
                    F2=(pDataLocal+SData3[*SData4]);//M
                    F3=(pDataLocal+SData5[*SData6]);//A
                    F4=(pDataLocal+SData7[*SData8]);//O
                    F5=(pDataLocal+SData9[*SData10]);//R
//=====================================================================================
                    *F5=(int)((*F3)*sinf(*F1*(*F2))+(*F4));
//=====================================================================================
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    if(SData8!=FData8)SData8++;
                    if(SData10!=FData10)SData10++;
                    
                    goto LOOP_SIN_INT;
                }
                else
                {
LOOP_SIN:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=(pDataLocal+SData1[*SData2]);//P
                    F2=(pDataLocal+SData3[*SData4]);//M
                    F3=(pDataLocal+SData5[*SData6]);//A
                    F4=(pDataLocal+SData7[*SData8]);//O
                    F5=(pDataLocal+SData9[*SData10]);//R
//=====================================================================================
                    *F5=(*F3)*sinf(*F1*(*F2))+(*F4);
//=====================================================================================
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    if(SData8!=FData8)SData8++;
                    if(SData10!=FData10)SData10++;
                    
                    goto LOOP_SIN;
                }
                break;
//операция cos-----------------------------------------------------------------
            case NAME_O_COS:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//P
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObP
                
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//M
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObM
                
                ppArr5=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+4));//A
                ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+5));//ObA
                
                ppArr7=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+6));//O
                ppArr8=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+7));//ObO
                
                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT);
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr9=*(pppData+iIndexTmp1);//R
                ppArr10=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObR
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;
                pInfoTmp7 = (InfoArrayValue *)*ppArr7;
                pInfoTmp8 = (InfoArrayValue *)*ppArr8;
                pInfoTmp9 = (InfoArrayValue *)*ppArr9;
                pInfoTmp10 = (InfoArrayValue *)*ppArr10;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                if(pInfoTmp8->mCount==0)break;
                if(pInfoTmp10->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                SData7=(*ppArr7+SIZE_INFO_STRUCT);
                SData8=(*ppArr8+SIZE_INFO_STRUCT);
                SData9=(*ppArr9+SIZE_INFO_STRUCT);
                SData10=(*ppArr10+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                FData8=SData8+pInfoTmp8->mCount-1;
                FData10=SData10+pInfoTmp10->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                if(pInfoTmp8->mCount>iMinCount)
                    iMinCount=pInfoTmp8->mCount;
                if(pInfoTmp10->mCount>iMinCount)
                    iMinCount=pInfoTmp10->mCount;
                
                iCountLoop=iMinCount;
                
                if(pInfoTmp9->mType==DATA_INT)
                {
LOOP_COS_INT:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=(pDataLocal+SData1[*SData2]);//P
                    F2=(pDataLocal+SData3[*SData4]);//M
                    F3=(pDataLocal+SData5[*SData6]);//A
                    F4=(pDataLocal+SData7[*SData8]);//O
                    F5=(pDataLocal+SData9[*SData10]);//R
//=====================================================================================
                    *F5=(int)((*F3)*cosf(*F1*(*F2))+(*F4));
//=====================================================================================
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    if(SData8!=FData8)SData8++;
                    if(SData10!=FData10)SData10++;
                    
                    goto LOOP_COS_INT;
                }
                else
                {
LOOP_COS:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=(pDataLocal+SData1[*SData2]);//P
                    F2=(pDataLocal+SData3[*SData4]);//M
                    F3=(pDataLocal+SData5[*SData6]);//A
                    F4=(pDataLocal+SData7[*SData8]);//O
                    F5=(pDataLocal+SData9[*SData10]);//R
//=====================================================================================
                    *F5=(*F3)*cosf(*F1*(*F2))+(*F4);
//=====================================================================================
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    if(SData8!=FData8)SData8++;
                    if(SData10!=FData10)SData10++;
                    
                    goto LOOP_COS;
                }
                break;
//операция tg-----------------------------------------------------------------
        case NAME_O_TG:
            
            ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//P
            ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObP
            
            ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//M
            ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObM
            
            ppArr5=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+4));//A
            ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+5));//ObA
            
            ppArr7=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+6));//O
            ppArr8=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+7));//ObO
            
            iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT);
            if(iIndexTmp1<RESERV_KERNEL)break;
            ppArr9=*(pppData+iIndexTmp1);//R
            ppArr10=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObR
            
            pInfoTmp1 = (InfoArrayValue *)*ppArr1;
            pInfoTmp2 = (InfoArrayValue *)*ppArr2;
            pInfoTmp3 = (InfoArrayValue *)*ppArr3;
            pInfoTmp4 = (InfoArrayValue *)*ppArr4;
            pInfoTmp5 = (InfoArrayValue *)*ppArr5;
            pInfoTmp6 = (InfoArrayValue *)*ppArr6;
            pInfoTmp7 = (InfoArrayValue *)*ppArr7;
            pInfoTmp8 = (InfoArrayValue *)*ppArr8;
            pInfoTmp9 = (InfoArrayValue *)*ppArr9;
            pInfoTmp10 = (InfoArrayValue *)*ppArr10;
            
            if(pInfoTmp2->mCount==0)break;
            if(pInfoTmp4->mCount==0)break;
            if(pInfoTmp6->mCount==0)break;
            if(pInfoTmp8->mCount==0)break;
            if(pInfoTmp10->mCount==0)break;
            
            SData1=(*ppArr1+SIZE_INFO_STRUCT);
            SData2=(*ppArr2+SIZE_INFO_STRUCT);
            SData3=(*ppArr3+SIZE_INFO_STRUCT);
            SData4=(*ppArr4+SIZE_INFO_STRUCT);
            SData5=(*ppArr5+SIZE_INFO_STRUCT);
            SData6=(*ppArr6+SIZE_INFO_STRUCT);
            SData7=(*ppArr7+SIZE_INFO_STRUCT);
            SData8=(*ppArr8+SIZE_INFO_STRUCT);
            SData9=(*ppArr9+SIZE_INFO_STRUCT);
            SData10=(*ppArr10+SIZE_INFO_STRUCT);
            
            FData2=SData2+pInfoTmp2->mCount-1;
            FData4=SData4+pInfoTmp4->mCount-1;
            FData6=SData6+pInfoTmp6->mCount-1;
            FData8=SData8+pInfoTmp8->mCount-1;
            FData10=SData10+pInfoTmp10->mCount-1;
            
            iMinCount=0;
            
            if(pInfoTmp2->mCount>iMinCount)
                iMinCount=pInfoTmp2->mCount;
            if(pInfoTmp4->mCount>iMinCount)
                iMinCount=pInfoTmp4->mCount;
            if(pInfoTmp6->mCount>iMinCount)
                iMinCount=pInfoTmp6->mCount;
            if(pInfoTmp8->mCount>iMinCount)
                iMinCount=pInfoTmp8->mCount;
            if(pInfoTmp10->mCount>iMinCount)
                iMinCount=pInfoTmp10->mCount;
            
            iCountLoop=iMinCount;
            
            if(pInfoTmp9->mType==DATA_INT)
            {
LOOP_TG_INT:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                F1=(pDataLocal+SData1[*SData2]);//P
                F2=(pDataLocal+SData3[*SData4]);//M
                F3=(pDataLocal+SData5[*SData6]);//A
                F4=(pDataLocal+SData7[*SData8]);//O
                F5=(pDataLocal+SData9[*SData10]);//R
                //=====================================================================================
                *F5=(int)((*F3)*tanf(*F1*(*F2))+(*F4));
                //=====================================================================================
                if(SData2!=FData2)SData2++;
                if(SData4!=FData4)SData4++;
                if(SData6!=FData6)SData6++;
                if(SData8!=FData8)SData8++;
                if(SData10!=FData10)SData10++;
                
                goto LOOP_TG_INT;
            }
            else
            {
LOOP_TG:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                F1=(pDataLocal+SData1[*SData2]);//P
                F2=(pDataLocal+SData3[*SData4]);//M
                F3=(pDataLocal+SData5[*SData6]);//A
                F4=(pDataLocal+SData7[*SData8]);//O
                F5=(pDataLocal+SData9[*SData10]);//R
                //=====================================================================================
                *F5=(*F3)*tanf(*F1*(*F2))+(*F4);
                //=====================================================================================
                if(SData2!=FData2)SData2++;
                if(SData4!=FData4)SData4++;
                if(SData6!=FData6)SData6++;
                if(SData8!=FData8)SData8++;
                if(SData10!=FData10)SData10++;
                
                goto LOOP_TG;
            }
            break;
                
//операция asin-----------------------------------------------------------------
            case NAME_O_ASIN:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//S
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObS
                
                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT);
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr3=*(pppData+iIndexTmp1);//R

                ppArr4=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObR

                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                
                iCountLoop=iMinCount;
                
                if(pInfoTmp3->mType==DATA_INT)
                {
LOOP_A_SIN_INT:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=(pDataLocal+SData1[*SData2]);//S
                    F2=(pDataLocal+SData3[*SData4]);//D
                    
                    tmpf=*F1;
                    if(tmpf>1)tmpf=1;
                    if(tmpf<-1)tmpf=-1;
//=====================================================================================
                    *F2=(int)(asinf(tmpf));
//=====================================================================================
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    
                    goto LOOP_A_SIN_INT;
                }
                else
                {
LOOP_A_SIN:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=(pDataLocal+SData1[*SData2]);//S
                    F2=(pDataLocal+SData3[*SData4]);//D
                    
                    tmpf=*F1;
                    if(tmpf>1)tmpf=1;
                    if(tmpf<-1)tmpf=-1;
//=====================================================================================
                    *F2=(asinf(tmpf));
//=====================================================================================
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    
                    goto LOOP_A_SIN;
                }
                break;
//операция acos-----------------------------------------------------------------
            case NAME_O_ACOS:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//S
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObS
                
                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT);
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr3=*(pppData+iIndexTmp1);//R
                ppArr4=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObR
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                
                iCountLoop=iMinCount;
                
                if(pInfoTmp3->mType==DATA_INT)
                {
LOOP_A_COS_INT:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=(pDataLocal+SData1[*SData2]);//S
                    F2=(pDataLocal+SData3[*SData4]);//D
                    tmpf=*F1;
                    if(tmpf>1)tmpf=1;
                    if(tmpf<-1)tmpf=-1;
//=====================================================================================
                    *F2=(int)(acosf(tmpf));
                    if(tmpf<0)*F2=-*F2;
//=====================================================================================
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    
                    goto LOOP_A_COS_INT;
                }
                else
                {
LOOP_A_COS:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=(pDataLocal+SData1[*SData2]);//S
                    F2=(pDataLocal+SData3[*SData4]);//D
                    
                    tmpf=*F1;
                    if(tmpf>1)tmpf=1;
                    if(tmpf<-1)tmpf=-1;
//=====================================================================================
                    *F2=(acosf(tmpf));
                    if(tmpf<0)*F2=-*F2;
//=====================================================================================
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    
                    goto LOOP_A_COS;
                }
                break;
//операция atan-----------------------------------------------------------------
            case NAME_O_ATAN:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//S
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObS
                
                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT);
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr3=*(pppData+iIndexTmp1);//R
                
                ppArr4=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObR
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                
                iCountLoop=iMinCount;
                
                if(pInfoTmp3->mType==DATA_INT)
                {
LOOP_A_TAN_INT:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=(pDataLocal+SData1[*SData2]);//S
                    F2=(pDataLocal+SData3[*SData4]);//D
                    
                    tmpf=*F1;
                    if(tmpf>1)tmpf=1;
                    if(tmpf<-1)tmpf=-1;
//=====================================================================================
                    *F2=(int)(atanf(tmpf));
//=====================================================================================
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    
                    goto LOOP_A_TAN_INT;
                }
                else
                {
LOOP_A_TAN:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=(pDataLocal+SData1[*SData2]);//S
                    F2=(pDataLocal+SData3[*SData4]);//D
                    
                    tmpf=*F1;
                    if(tmpf>1)tmpf=1;
                    if(tmpf<-1)tmpf=-1;
//=====================================================================================
                    *F2=(atanf(tmpf));
//=====================================================================================
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    
                    goto LOOP_A_TAN;
                }
                break;
//операция draw ex---------------------------------------------------------------------
//            case NAME_O_DRAW_EX:
//                
//                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//T
//           //     ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObT
//                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//S
//                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//ObS
//                
//                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
//           //     pInfoTmp2 = (InfoArrayValue *)*ppArr2;
//                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
//                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
//                
//                if(pInfoTmp2->mCount==0)break;
//                if(pInfoTmp4->mCount==0)break;
//                
//                SData1=(*ppArr1+SIZE_INFO_STRUCT);
//         //       SData2=(*ppArr2+SIZE_INFO_STRUCT);
//                SData3=(*ppArr3+SIZE_INFO_STRUCT);
//                SData4=(*ppArr4+SIZE_INFO_STRUCT);
//                
//         //       FData2=SData2+pInfoTmp2->mCount-1;
//                FData4=SData4+pInfoTmp4->mCount-1;
//                
//                iCountLoop=pInfoTmp4->mCount;
//                
//                [pParContainer DrawSprites_ex:iCountLoop data1:SData1 data2:0 data3:SData3 data4:SData4 fdata2:0 data4:FData4];
//                
//                break;
//операция draw---------------------------------------------------------------------
            case NAME_O_DRAW:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//T
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObT
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//S
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObS
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;

                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;

                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);

                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;

                if(pInfoTmp2->mCount>pInfoTmp4->mCount)
                    iCountLoop=pInfoTmp2->mCount;
                else iCountLoop=pInfoTmp4->mCount;
                
                [pParContainer DrawSprites:iCountLoop data1:SData1 data2:SData2 data3:SData3 data4:SData4 fdata2:FData2 data4:FData4];

                break;
//операция move---------------------------------------------------------------------
            case NAME_O_DELTA_T:

                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//V
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObV

                ppArr5=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//M
                ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObM

                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr3=*(pppData+iIndexTmp1);//R
                ppArr4=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObR

                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                
                iCountLoop=iMinCount;
                
                if(pInfoTmp3->mType==DATA_INT)
                {
LOOP_DELTA_T_INT:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    *(pDataLocal+SData3[*SData4])+=(int)(*(pDataLocal+SData1[*SData2])**(pDataLocal+SData5[*SData6])*(pDeltaTime));
                                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    
                    goto LOOP_DELTA_T_INT;
                }
                else
                {
LOOP_DELTA_T:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    *(pDataLocal+SData3[*SData4])+=*(pDataLocal+SData1[*SData2])**(pDataLocal+SData5[*SData6])*(pDeltaTime);
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;

                    goto LOOP_DELTA_T;
                }
                
                break;
//операция отражения по струне----------------------------------------------------------------
            case NAME_O_SPLINE:
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//Ax
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObAx

                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//Ay
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObAy

                ppArr5=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+4));//Bx
                ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+5));//ObBx

                ppArr7=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+6));//By
                ppArr8=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+7));//ObBy

                ppArr9=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+8));//Cx
                ppArr10=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+9));//ObCx

                ppArr11=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+10));//Cy
                ppArr12=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+11));//ObCy

                ppArr13=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+12));//Dx
                ppArr14=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+13));//ObDx

                ppArr15=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+14));//Dy
                ppArr16=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+15));//ObDy

                ppArr17=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+16));//t
                ppArr18=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+17));//Obt

                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );//Rx
                iIndexTmp2=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+2);//Ry

                if(iIndexTmp1<RESERV_KERNEL && iIndexTmp2<RESERV_KERNEL)break;//RxRy
                
                ppArr19=*(pppData+iIndexTmp1);//Rx
                ppArr20=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObRx
                
                ppArr21=*(pppData+iIndexTmp2);//Ry
                ppArr22=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+3));//ObRy
                
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;
                pInfoTmp7 = (InfoArrayValue *)*ppArr7;
                pInfoTmp8 = (InfoArrayValue *)*ppArr8;
                pInfoTmp9 = (InfoArrayValue *)*ppArr9;
                pInfoTmp10 = (InfoArrayValue *)*ppArr10;
                pInfoTmp11 = (InfoArrayValue *)*ppArr11;
                pInfoTmp12 = (InfoArrayValue *)*ppArr12;
                pInfoTmp13 = (InfoArrayValue *)*ppArr13;
                pInfoTmp14 = (InfoArrayValue *)*ppArr14;
                pInfoTmp15 = (InfoArrayValue *)*ppArr15;
                pInfoTmp16 = (InfoArrayValue *)*ppArr16;
                pInfoTmp17 = (InfoArrayValue *)*ppArr17;
                pInfoTmp18 = (InfoArrayValue *)*ppArr18;
                pInfoTmp19 = (InfoArrayValue *)*ppArr19;
                pInfoTmp20 = (InfoArrayValue *)*ppArr20;
                pInfoTmp21 = (InfoArrayValue *)*ppArr21;
                pInfoTmp22 = (InfoArrayValue *)*ppArr22;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                if(pInfoTmp8->mCount==0)break;
                if(pInfoTmp10->mCount==0)break;
                if(pInfoTmp12->mCount==0)break;
                if(pInfoTmp14->mCount==0)break;
                if(pInfoTmp16->mCount==0)break;
                if(pInfoTmp18->mCount==0)break;
                if(pInfoTmp20->mCount==0)break;
                if(pInfoTmp22->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                SData7=(*ppArr7+SIZE_INFO_STRUCT);
                SData8=(*ppArr8+SIZE_INFO_STRUCT);
                SData9=(*ppArr9+SIZE_INFO_STRUCT);
                SData10=(*ppArr10+SIZE_INFO_STRUCT);
                SData11=(*ppArr11+SIZE_INFO_STRUCT);
                SData12=(*ppArr12+SIZE_INFO_STRUCT);
                SData13=(*ppArr13+SIZE_INFO_STRUCT);
                SData14=(*ppArr14+SIZE_INFO_STRUCT);
                SData15=(*ppArr15+SIZE_INFO_STRUCT);
                SData16=(*ppArr16+SIZE_INFO_STRUCT);
                SData17=(*ppArr17+SIZE_INFO_STRUCT);
                SData18=(*ppArr18+SIZE_INFO_STRUCT);
                SData19=(*ppArr19+SIZE_INFO_STRUCT);
                SData20=(*ppArr20+SIZE_INFO_STRUCT);
                SData21=(*ppArr21+SIZE_INFO_STRUCT);
                SData22=(*ppArr22+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                FData8=SData8+pInfoTmp8->mCount-1;
                FData10=SData10+pInfoTmp10->mCount-1;
                FData12=SData12+pInfoTmp12->mCount-1;
                FData14=SData14+pInfoTmp14->mCount-1;
                FData16=SData16+pInfoTmp16->mCount-1;
                FData18=SData18+pInfoTmp18->mCount-1;
                FData20=SData20+pInfoTmp20->mCount-1;
                FData22=SData22+pInfoTmp22->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                if(pInfoTmp8->mCount>iMinCount)
                    iMinCount=pInfoTmp8->mCount;
                if(pInfoTmp10->mCount>iMinCount)
                    iMinCount=pInfoTmp10->mCount;
                if(pInfoTmp12->mCount>iMinCount)
                    iMinCount=pInfoTmp12->mCount;
                if(pInfoTmp14->mCount>iMinCount)
                    iMinCount=pInfoTmp14->mCount;
                if(pInfoTmp16->mCount>iMinCount)
                    iMinCount=pInfoTmp16->mCount;
                if(pInfoTmp18->mCount>iMinCount)
                    iMinCount=pInfoTmp18->mCount;
                if(pInfoTmp20->mCount>iMinCount)
                    iMinCount=pInfoTmp20->mCount;
                if(pInfoTmp22->mCount>iMinCount)
                    iMinCount=pInfoTmp22->mCount;
                
                iCountLoop=iMinCount;

//                if(pInfoTmp19->mType==DATA_INT)
//                if(pInfoTmp21->mType==DATA_INT)
                
LOOP_SPLINE:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                F1=(pDataLocal+SData1[*SData2]);  //Ax
                F2=(pDataLocal+SData3[*SData4]);  //Ay
                F3=(pDataLocal+SData5[*SData6]);  //Bx
                F4=(pDataLocal+SData7[*SData8]);  //By
                F5=(pDataLocal+SData9[*SData10]); //Cx
                F6=(pDataLocal+SData11[*SData12]);//Cy
                F7=(pDataLocal+SData13[*SData14]);//Dx
                F8=(pDataLocal+SData15[*SData16]);//Dy
                F9=(pDataLocal+SData17[*SData18]);//T

                TmpRx=(pDataLocal+SData19[*SData20]);//Rx
                TmpRy=(pDataLocal+SData21[*SData22]);//Ry
//===================================================================================================
                tmpf=(1-(*F9));
                
                if(iIndexTmp1>RESERV_KERNEL)
                {
    *TmpRx=tmpf*tmpf*tmpf*(*F1)+3*(*F9)*tmpf*tmpf*(*F3)+3*(*F9)*(*F9)*tmpf*(*F5)+(*F9)*(*F9)*(*F9)*(*F7);
                    if(pInfoTmp19->mType==DATA_INT)*TmpRx=(int)*TmpRx;
                }
                
                if(iIndexTmp2>RESERV_KERNEL)
                {

    *TmpRy=tmpf*tmpf*tmpf*(*F2)+3*(*F9)*tmpf*tmpf*(*F4)+3*(*F9)*(*F9)*tmpf*(*F6)+(*F9)*(*F9)*(*F9)*(*F8);
                    if(pInfoTmp21->mType==DATA_INT)*TmpRy=(int)*TmpRy;
                }
//===================================================================================================
                
                if(SData2!=FData2)SData2++;
                if(SData4!=FData4)SData4++;
                if(SData6!=FData6)SData6++;
                if(SData8!=FData8)SData8++;
                if(SData10!=FData10)SData10++;
                if(SData12!=FData12)SData12++;
                if(SData14!=FData14)SData14++;
                if(SData16!=FData16)SData16++;
                if(SData18!=FData18)SData18++;
                if(SData20!=FData20)SData20++;
                if(SData22!=FData22)SData22++;
                
                goto LOOP_SPLINE;
                
                break;
//операция отражения по струне----------------------------------------------------------------
            case NAME_O_STRING:
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//A
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObA
                
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//B
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObB
                
                ppArr5=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+4));//C
                ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+5));//ObC

                ppArr7=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+6));//D
                ppArr8=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+7));//ObD

                ppArr9=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+8));//X
                ppArr10=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+9));//ObX

                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr11=*(pppData+iIndexTmp1);//Y
                ppArr12=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObY
                
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;
                pInfoTmp7 = (InfoArrayValue *)*ppArr7;
                pInfoTmp8 = (InfoArrayValue *)*ppArr8;
                pInfoTmp9 = (InfoArrayValue *)*ppArr9;
                pInfoTmp10 = (InfoArrayValue *)*ppArr10;
                pInfoTmp11 = (InfoArrayValue *)*ppArr11;
                pInfoTmp12 = (InfoArrayValue *)*ppArr12;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                if(pInfoTmp8->mCount==0)break;
                if(pInfoTmp10->mCount==0)break;
                if(pInfoTmp12->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                SData7=(*ppArr7+SIZE_INFO_STRUCT);
                SData8=(*ppArr8+SIZE_INFO_STRUCT);
                SData9=(*ppArr9+SIZE_INFO_STRUCT);
                SData10=(*ppArr10+SIZE_INFO_STRUCT);
                SData11=(*ppArr11+SIZE_INFO_STRUCT);
                SData12=(*ppArr12+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                FData8=SData8+pInfoTmp8->mCount-1;
                FData10=SData10+pInfoTmp10->mCount-1;
                FData12=SData12+pInfoTmp12->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                if(pInfoTmp8->mCount>iMinCount)
                    iMinCount=pInfoTmp8->mCount;
                if(pInfoTmp10->mCount>iMinCount)
                    iMinCount=pInfoTmp10->mCount;
                if(pInfoTmp12->mCount>iMinCount)
                    iMinCount=pInfoTmp12->mCount;
                
                iCountLoop=iMinCount;
                
                if(pInfoTmp11->mType==DATA_INT)
                {
LOOP_STRING_MIRROR_INT:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=(pDataLocal+SData1[*SData2]);//A
                    F2=(pDataLocal+SData3[*SData4]);//B
                    F3=(pDataLocal+SData5[*SData6]);//C
                    F4=(pDataLocal+SData7[*SData8]);//D

                    F5=(pDataLocal+SData9[*SData10]);//X
                    F6=(pDataLocal+SData11[*SData12]);//Y

                    float fTmp=*F1-*F2;
                    
                    if(fTmp!=0)
                        *F6=(int)(((*F3-*F4)/(fTmp))*(*F5-(*F1))+(*F3));
                                        
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    if(SData8!=FData8)SData8++;
                    if(SData10!=FData10)SData10++;
                    if(SData12!=FData12)SData12++;

                    goto LOOP_STRING_MIRROR_INT;
                }
                else
                {
LOOP_STRING_MIRROR:;
                    if(iCountLoop==0)break;
                    iCountLoop--;
                    
                    F1=(pDataLocal+SData1[*SData2]);//A
                    F2=(pDataLocal+SData3[*SData4]);//B
                    F3=(pDataLocal+SData5[*SData6]);//C
                    F4=(pDataLocal+SData7[*SData8]);//D
                    
                    F5=(pDataLocal+SData9[*SData10]);//X
                    F6=(pDataLocal+SData11[*SData12]);//Y
                    
                    float fTmp=*F1-*F2;
                    
                    if(fTmp!=0)
                        *F6=((*F3-*F4)/(fTmp))*(*F5-(*F1))+(*F3);
                    
                    if(SData2!=FData2)SData2++;
                    if(SData4!=FData4)SData4++;
                    if(SData6!=FData6)SData6++;
                    if(SData8!=FData8)SData8++;
                    if(SData10!=FData10)SData10++;
                    if(SData12!=FData12)SData12++;
                    
                    goto LOOP_STRING_MIRROR;
                }
                break;
//операция преобразования clear space--------------------------------------------------------
            case NAME_CLEAR_SPACE:
                
                iIndexTmp2=*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT);
                ppArr1=*(pppData+iIndexTmp2);//ObA
                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT);
                ppArr2=*(pppData+iIndexTmp1);//ObB
                
                if(iIndexTmp1<RESERV_KERNEL || iIndexTmp2<RESERV_KERNEL)
                {
                    if(iIndexTmp2>RESERV_KERNEL)
                        [OperationIndex SetCopasity:0 WithData:ppArr1];
                    else if(iIndexTmp1>RESERV_KERNEL)
                        [OperationIndex SetCopasity:0 WithData:ppArr2];
                }
                else
                {
                    
                    pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                    pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                    
                    if(pInfoTmp1->mCount==0)break;
                    if(pInfoTmp2->mCount==0)break;
                    
                    SData1=(*ppArr1+SIZE_INFO_STRUCT);
                    SData2=(*ppArr2+SIZE_INFO_STRUCT);

                    //вспомогателный вектор
                    [OperationIndex SetCopasity:pInfoTmp2->mCount WithData:ppHelpData];
                    pInfoTmp3 = (InfoArrayValue *)*ppHelpData;
                    SData3=(*ppHelpData+SIZE_INFO_STRUCT);
                    pInfoTmp3->mCount=0;

                    for (i=0; i<pInfoTmp2->mCount; i++){
                        iIndexTmp1=SData2[i];
                        for (j=0; j<pInfoTmp1->mCount; j++){
                            
                            iIndexTmp2=SData1[j];
                            if(iIndexTmp1==iIndexTmp2)
                                goto NEXT_CLEAR;
                        }
                        
                        SData3[pInfoTmp3->mCount]=iIndexTmp1;
                        pInfoTmp3->mCount++;
NEXT_CLEAR:;
                    }
                    
                    if(iIndexTmp1<RESERV_KERNEL)
                        [OperationIndex SetCopasity:pInfoTmp3->mCount WithData:ppArr2];
                    
                    pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                    SData2=(*ppArr2+SIZE_INFO_STRUCT);

                    if(pInfoTmp3->mCount>0)
                        memcpy(SData2, SData3, sizeof(int)*pInfoTmp3->mCount);
                    pInfoTmp2->mCount=pInfoTmp3->mCount;
                    
                    if(iIndexTmp2<RESERV_KERNEL)
                        [OperationIndex SetCopasity:0 WithData:ppArr1];
                    pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                    pInfoTmp1->mCount=0;
                }
                break;
//операция преобразования I в space--------------------------------------------------------
            case NAME_O_I_TO_PL:
                
                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr3=*(pppData+iIndexTmp1);//ObB
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//A
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObA
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                [OperationIndex SetCopasity:0 WithData:ppArr3];
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                
                if(pInfoTmp2->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                                
                FData2=SData2+pInfoTmp2->mCount-1;
                iCountLoop=pInfoTmp2->mCount;
                
                if(pInfoTmp3->UnParentMatrix.indexMatrix==0)
                    pMatr=*(MATRIXcell **)(ArrayPoints->pData+1);
                else pMatr=*(MATRIXcell **)(ArrayPoints->pData+pInfoTmp3->UnParentMatrix.indexMatrix);
                
LOOP_I_TO_SPACE:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                fTmpValue=*(pDataLocal+SData1[*SData2]);
                if(fTmpValue<0)fTmpValue=0;
                if(fTmpValue>pMatr->iDimMatrix-1)fTmpValue=pMatr->iDimMatrix-1;
                
                [OperationIndex OnlyAddData:(int)fTmpValue WithData:ppArr3];
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                                
                if(SData2!=FData2)SData2++;
                
                goto LOOP_I_TO_SPACE;
                break;
//операция преобразования space в I--------------------------------------------------------
            case NAME_O_PL_TO_I:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//ObA
                
                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr2=*(pppData+iIndexTmp1);//B
                ppArr3=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObB

                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                
                if(pInfoTmp1->mCount==0)break;
                if(pInfoTmp3->mCount==0)break;

                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);

                FData1=SData1+pInfoTmp1->mCount-1;
                FData3=SData3+pInfoTmp3->mCount-1;

                iCountLoop=pInfoTmp3->mCount;
                
LOOP_SPACE_TO_I:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                fTmpValue=*SData1;
                *(pDataLocal+SData2[*SData3])=fTmpValue;

                if(SData1!=FData1)SData1++;
                if(SData3!=FData3)SData3++;
                
                goto LOOP_SPACE_TO_I;
                break;
//операция получения случайного числа---------------------------------------------------------
            case NAME_O_RND:
                
                ppArr1=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT  ));//Start
                ppArr2=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+1));//ObS
                
                ppArr3=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+2));//Finish
                ppArr4=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+3));//ObF
                
                ppArr5=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+4));//Scale
                ppArr6=*(pppData+*((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT+5));//ObScale
                
                iIndexTmp1=*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT  );
                if(iIndexTmp1<RESERV_KERNEL)break;
                ppArr7=*(pppData+iIndexTmp1);//Rez
                ppArr8=*(pppData+*((*pHeart->pExPairPar)+SIZE_INFO_STRUCT+1));//ObRez
                
                pInfoTmp1 = (InfoArrayValue *)*ppArr1;
                pInfoTmp2 = (InfoArrayValue *)*ppArr2;
                pInfoTmp3 = (InfoArrayValue *)*ppArr3;
                pInfoTmp4 = (InfoArrayValue *)*ppArr4;
                pInfoTmp5 = (InfoArrayValue *)*ppArr5;
                pInfoTmp6 = (InfoArrayValue *)*ppArr6;
                pInfoTmp7 = (InfoArrayValue *)*ppArr7;
                pInfoTmp8 = (InfoArrayValue *)*ppArr8;
                
                if(pInfoTmp2->mCount==0)break;
                if(pInfoTmp4->mCount==0)break;
                if(pInfoTmp6->mCount==0)break;
                if(pInfoTmp8->mCount==0)break;
                
                SData1=(*ppArr1+SIZE_INFO_STRUCT);
                SData2=(*ppArr2+SIZE_INFO_STRUCT);
                SData3=(*ppArr3+SIZE_INFO_STRUCT);
                SData4=(*ppArr4+SIZE_INFO_STRUCT);
                SData5=(*ppArr5+SIZE_INFO_STRUCT);
                SData6=(*ppArr6+SIZE_INFO_STRUCT);
                SData7=(*ppArr7+SIZE_INFO_STRUCT);
                SData8=(*ppArr8+SIZE_INFO_STRUCT);
                
                FData2=SData2+pInfoTmp2->mCount-1;
                FData4=SData4+pInfoTmp4->mCount-1;
                FData6=SData6+pInfoTmp6->mCount-1;
                FData8=SData8+pInfoTmp8->mCount-1;
                
                iMinCount=0;
                
                if(pInfoTmp2->mCount>iMinCount)
                    iMinCount=pInfoTmp2->mCount;
                if(pInfoTmp4->mCount>iMinCount)
                    iMinCount=pInfoTmp4->mCount;
                if(pInfoTmp6->mCount>iMinCount)
                    iMinCount=pInfoTmp6->mCount;
                if(pInfoTmp8->mCount>iMinCount)
                    iMinCount=pInfoTmp8->mCount;
                
                iCountLoop=iMinCount;
                
LOOP_RND:;
                if(iCountLoop==0)break;
                iCountLoop--;
                
                F1=(pDataLocal+SData1[*SData2]);//Start
                F2=(pDataLocal+SData3[*SData4]);//Finish
                F3=(pDataLocal+SData5[*SData6]);//Scale
                F4=(pDataLocal+SData7[*SData8]);//Rez
                
            //    *F4=0;
                
                tmpf2=abs(*F2-*F1);
                if(tmpf2==0)tmpf2=1;
                
                *F4=((arc4random()%(int)(tmpf2)+(*F1))*(*F3));
                if(pInfoTmp7->mType==DATA_INT)*F4=(int)*F4;
                
                if(SData2!=FData2)SData2++;
                if(SData4!=FData4)SData4++;
                if(SData6!=FData6)SData6++;
                if(SData8!=FData8)SData8++;
                
                goto LOOP_RND;
                break;
//-----------------------------------------------------------------------------------
            default://имя операции не найдено
                break;
        }
//следующая операция=================================================================
            
            if(pHeart->pNextPlace>=0){
                iCurrentPlace=pHeart->pNextPlace;
                IndexInside=((*pParMatrix->pValueCopy) + SIZE_INFO_STRUCT)[iCurrentPlace];
                
                pCurrentMatr=*((MATRIXcell **)(ArrayPoints->pData+IndexInside));
                pHeart=(HeartMatr *)pQueue[iCurrentPlace];
            }
            else
            {
LEVEL_UP:
                if(InfoParMatrix->mCount==0)return;//выходим из обработки если стек пуст
                
                //достаём данные из стека
                InfoParMatrix->mCount--;
                InfoCurPlace->mCount--;
                
                pParMatrix=*((MATRIXcell **)(StartDataParMatrix+InfoParMatrix->mCount));
                iCurrentPlace=StartDataCurPlace[InfoCurPlace->mCount];
                pQueue=(*pParMatrix->pQueue)+SIZE_INFO_STRUCT;
                pHeart=(HeartMatr *)pQueue[iCurrentPlace];
                
//                //возвращаемые параметры
//                InfoArrayValue *InfoPar=(InfoArrayValue *)(*pHeart->pExPairPar);
//                for (int k=0; k<InfoPar->mCount; k++) {
//                    int Index1=((*pHeart->pExPairPar)+SIZE_INFO_STRUCT)[k];
//                    int Index2=((*pHeart->pExPairChi)+SIZE_INFO_STRUCT)[k];
//                    
//                    ArrayPoints->pData[Index2]=ArrayPoints->pData[Index1];
//                }
NEXT_HEART:
                if(pHeart->pNextPlace>=0){
                    
                    iCurrentPlace=pHeart->pNextPlace;
                    iCurrentIndex=((*pParMatrix->pValueCopy)+SIZE_INFO_STRUCT)[iCurrentPlace];
                    
                    pCurrentMatr=*((MATRIXcell **)(ArrayPoints->pData+iCurrentIndex));
                    pHeart=(HeartMatr *)pQueue[iCurrentPlace];
                }
                else goto LEVEL_UP;//переходим ещё на уровень выше
            }
            goto LOOP;
            break;
//составная матрица==================================================================
        case STR_COMPLEX:

            if(*(*pCurrentMatr->ppStartPlaces+SIZE_INFO_STRUCT)==-1)goto NEXT_HEART;
            if((iIndexActivSpace=*(*pCurrentMatr->ppActivitySpace+SIZE_INFO_STRUCT))!=-1)
            {
                int **pArraySpace=*(pppData+iIndexActivSpace);
                pInfoTmp1=(InfoArrayValue *)*pArraySpace;
                if(pInfoTmp1->mCount==0)
                    goto NEXT_HEART;
            }

            //расширяем стек
            if(InfoParMatrix->mCount==InfoParMatrix->mCopasity)
            {
                InfoParMatrix->mCopasity+=100;
                InfoCurPlace->mCopasity+=100;

                int FullSize=InfoParMatrix->mCopasity*sizeof(int)+sizeof(InfoArrayValue);
                *m_pContainer->pParMatrixStack = (int *)realloc(*m_pContainer->pParMatrixStack,FullSize);
                *m_pContainer->pCurPlaceStack = (int *)realloc(*m_pContainer->pCurPlaceStack,FullSize);

                InfoParMatrix=(InfoArrayValue *)(*m_pContainer->pParMatrixStack);
                InfoCurPlace=(InfoArrayValue *)(*m_pContainer->pCurPlaceStack);

                StartDataParMatrix=((*m_pContainer->pParMatrixStack)+SIZE_INFO_STRUCT);
                StartDataCurPlace=((*m_pContainer->pCurPlaceStack)+SIZE_INFO_STRUCT);
            }

//            //входные параметры
//            InfoArrayValue *InfoPar=(InfoArrayValue *)(*pHeart->pEnPairPar);
//            for (int k=0; k<InfoPar->mCount; k++) {
//                int Index1=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[k];
//                int Index2=((*pHeart->pEnPairChi)+SIZE_INFO_STRUCT)[k];
//                
//                ArrayPoints->pData[Index2]=ArrayPoints->pData[Index1];
//            }

            //копируем данные в стек
            MATRIXcell **TmpLink=(MATRIXcell **)(StartDataParMatrix+InfoParMatrix->mCount);
            *TmpLink=pParMatrix;
            StartDataCurPlace[InfoCurPlace->mCount]=iCurrentPlace;
            
            InfoParMatrix->mCount++;
            InfoCurPlace->mCount++;

            pParMatrix=pCurrentMatr;
            
            iCurrentPlace=*(*pCurrentMatr->ppStartPlaces+SIZE_INFO_STRUCT);
            
            iCurrentIndex=((*pCurrentMatr->pValueCopy)+SIZE_INFO_STRUCT)[iCurrentPlace];
            pCurrentMatr=*((MATRIXcell **)(ArrayPoints->pData+iCurrentIndex));
            pQueue=(*pParMatrix->pQueue)+SIZE_INFO_STRUCT;
            pHeart=(HeartMatr *)pQueue[iCurrentPlace];
            
            goto LOOP;//входим в матрицу
            break;
//===================================================================================
        default://тип не найден
            break;
    }
    
}
//------------------------------------------------------------------------------------------------------
- (void)dealloc
{
    [m_pContainer->m_OperationIndex OnlyReleaseMemory:ppHelpData];
    [m_pContainer->m_OperationIndex OnlyReleaseMemory:ppTmpData];
    
    [m_pContainer->m_OperationIndex OnlyReleaseMemory:ppXtouchBegin];
    [m_pContainer->m_OperationIndex OnlyReleaseMemory:ppYtouchBegin];
    [m_pContainer->m_OperationIndex OnlyReleaseMemory:ppNumtouchBegin];
    [m_pContainer->m_OperationIndex OnlyReleaseMemory:ppXtouchMove];
    [m_pContainer->m_OperationIndex OnlyReleaseMemory:ppYtouchMove];
    [m_pContainer->m_OperationIndex OnlyReleaseMemory:ppNumtouchMove];
    [m_pContainer->m_OperationIndex OnlyReleaseMemory:ppXtouchEnd];
    [m_pContainer->m_OperationIndex OnlyReleaseMemory:ppYtouchEnd];
    [m_pContainer->m_OperationIndex OnlyReleaseMemory:ppNumtouchEnd];

    [m_pContainer->m_OperationIndex OnlyReleaseMemory:ppLockTouch];
    [super dealloc];
}
@end
