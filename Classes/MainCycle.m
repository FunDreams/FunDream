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
    }
    return self;
}
//------------------------------------------------------------------------------------------------------
-(void)Update:(FractalString *)StartString{
    //главный цикл обработки матрицы
    
    float *pDeltaTime=m_pContainer->pDeltaTime;
    FunArrayData *ArrayPoints=m_pContainer->ArrayPoints;

    short iCurrentPlace;
    int iCurrentIndex;
    int *pQueue;
    HeartMatr *pHeart;
    InfoArrayValue *pInfoTmp;
    NSMutableString *pName;
    
    TextureContainer *pNum;
    int *I1;//,*I2,*I3;
    float *F1,*F2,*F3,*F4,*F5,*F6;
    int iIndexValue,iTextureName=-1;
    
    InfoArrayValue *InfoParMatrix=(InfoArrayValue *)(*m_pContainer->pParMatrixStack);
    InfoArrayValue *InfoCurPlace=(InfoArrayValue *)(*m_pContainer->pCurPlaceStack);
    
    int *StartDataParMatrix=((*m_pContainer->pParMatrixStack)+SIZE_INFO_STRUCT);
    int *StartDataCurPlace=((*m_pContainer->pCurPlaceStack)+SIZE_INFO_STRUCT);
    //------------------------------------------------------------------------------------
    if(StartString==nil)return;
    MATRIXcell *pParMatrix=[ArrayPoints GetMatrixAtIndex:StartString->m_iIndex];
    if(pParMatrix->sStartPlace==-1)return;
    iCurrentPlace=pParMatrix->sStartPlace;
    
    int IndexInside=((*pParMatrix->pValueCopy) + SIZE_INFO_STRUCT)[pParMatrix->sStartPlace];
    MATRIXcell *pCurrentMatr=[ArrayPoints GetMatrixAtIndex:IndexInside];
    if(pCurrentMatr==nil)return;
    
    pQueue=(*pParMatrix->pQueue)+SIZE_INFO_STRUCT;
    pHeart=(HeartMatr *)pQueue[iCurrentPlace];
    
LOOP://бесконечный цикл
    
    switch (pCurrentMatr->TypeInformation)
    {
//операции===========================================================================
        case STR_OPERATION:
            
            switch (pCurrentMatr->NameInformation)
        {
                //операция плюс----------------------------------------------------------------------
            case NAME_O_PLUS:
                
                iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[0];//A
                F1=(ArrayPoints->pData+iIndexValue);
                
                iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[1];//B
                F2=(ArrayPoints->pData+iIndexValue);
                
                iIndexValue=((*pHeart->pExPairPar)+SIZE_INFO_STRUCT)[0];//R
                F3=(ArrayPoints->pData+iIndexValue);
                
                *F3+= *F1+ *F2;//плюсование
                break;
//операция update---------------------------------------------------------------------
            case NAME_O_UPDATE_XY:
                
                iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[0];//X
                F1=(ArrayPoints->pData+iIndexValue);
                
                iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[1];//Y
                F2=(ArrayPoints->pData+iIndexValue);
                
                iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[2];//W
                F3=(ArrayPoints->pData+iIndexValue);
                
                iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[3];//H
                F4=(ArrayPoints->pData+iIndexValue);
                
                iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[4];//Sprite
                I1=((int *)ArrayPoints->pData+iIndexValue);
                
                [ArrayPoints->pCurrenContPar UpdateSpriteVertex:*I1 X:*F1 Y:*F2 W:*F3 H:*F4];
                break;
//операция draw---------------------------------------------------------------------
            case NAME_O_DRAW:
                
                iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[0];//texture
                pName=*((id *)(ArrayPoints->pData+iIndexValue));
                
                pNum=[m_pContainer->m_pObjMng->m_pParent->m_pTextureList objectForKey:pName];
                if(pNum!=nil)iTextureName=pNum->m_iTextureId;
                else iTextureName=-1;
                
                iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[1];//Sprite
                I1=((int *)ArrayPoints->pData+iIndexValue);
                
                [ArrayPoints->pCurrenContPar DrawSprite:*I1 tex:iTextureName];
                break;
//операция move---------------------------------------------------------------------
            case NAME_O_MOVE:
                
                iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[0];//V
                F1=(ArrayPoints->pData+iIndexValue);
                
                iIndexValue=((*pHeart->pExPairPar)+SIZE_INFO_STRUCT)[0];//R
                F2=(ArrayPoints->pData+iIndexValue);
                
                *F2+=*F1*(*pDeltaTime);
                
                break;
//операция движение по окружности---------------------------------------------------
            case NAME_O_MOVE_ORBIT:
                
                iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[0];//X0
                F1=(ArrayPoints->pData+iIndexValue);
                
                iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[1];//Y0
                F2=(ArrayPoints->pData+iIndexValue);
                
                iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[2];//R
                F3=(ArrayPoints->pData+iIndexValue);
                
                iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[3];//A
                F4=(ArrayPoints->pData+iIndexValue);
                
                iIndexValue=((*pHeart->pExPairPar)+SIZE_INFO_STRUCT)[0];//X
                F5=(ArrayPoints->pData+iIndexValue);
                
                iIndexValue=((*pHeart->pExPairPar)+SIZE_INFO_STRUCT)[1];//Y
                F6=(ArrayPoints->pData+iIndexValue);
                
                float fSin=sinf(*F4);
                float fCos=cosf(*F4);
                
                *F5=*F1+*F3*(fCos);
                *F6=*F2+*F3*(fSin);
                
                break;
//операция сложение векторов-------------------------------------------------------
            case NAME_O_PLUS_VECTOR:
                
                iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[0];//X0
                F1=(ArrayPoints->pData+iIndexValue);
                
                iIndexValue=((*pHeart->pEnPairPar)+SIZE_INFO_STRUCT)[1];//Y0
                F2=(ArrayPoints->pData+iIndexValue);
                
                iIndexValue=((*pHeart->pExPairPar)+SIZE_INFO_STRUCT)[0];//X1
                F3=(ArrayPoints->pData+iIndexValue);
                
                iIndexValue=((*pHeart->pExPairPar)+SIZE_INFO_STRUCT)[1];//Y1
                F4=(ArrayPoints->pData+iIndexValue);
                
                *F3=*F3+*F1;//сложение векторов покомпонентно
                *F4=*F4+*F2;
                
                break;
//-----------------------------------------------------------------------------------
            default://имя операции не найдено
                break;
        }
//следующая операция=================================================================
            pInfoTmp=(InfoArrayValue *)(*pHeart->pNextPlaces);
            
            if(pInfoTmp->mCount>0){
                iCurrentPlace=((*pHeart->pNextPlaces)+SIZE_INFO_STRUCT)[0];
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
NEXT_HEART:
                pInfoTmp=(InfoArrayValue *)(*pHeart->pNextPlaces);
                if(pInfoTmp->mCount>0){
                    
                    iCurrentPlace=((*pHeart->pNextPlaces)+SIZE_INFO_STRUCT)[0];
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
            if(pCurrentMatr->sStartPlace==-1)goto NEXT_HEART;
            
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
            
            //копируем данные в стек
            MATRIXcell **TmpLink=(MATRIXcell **)(StartDataParMatrix+InfoParMatrix->mCount);
            *TmpLink=pParMatrix;
            StartDataCurPlace[InfoCurPlace->mCount]=iCurrentPlace;
            
            InfoParMatrix->mCount++;
            InfoCurPlace->mCount++;
            
            pParMatrix=pCurrentMatr;
            iCurrentPlace=pCurrentMatr->sStartPlace;
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
@end
