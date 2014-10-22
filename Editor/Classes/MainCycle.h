//
//  MainCycle.h
//  FunDreams
//
//  Created by Konstantin on 19.03.13.
//  Copyright (c) 2013 FunDreams. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StringContainer;

@interface MainCycle : NSObject
{
@public
    StringContainer *m_pContainer;
    int **ppHelpData;
    int **ppTmpData;
//for touch======================================
    int **ppXtouchBegin;
    int **ppYtouchBegin;
    int **ppNumtouchBegin;

    int **ppXtouchMove;
    int **ppYtouchMove;
    int **ppNumtouchMove;

    int **ppXtouchEnd;
    int **ppYtouchEnd;
    int **ppNumtouchEnd;

    int **ppLockTouch;
//===============================================
    int ***pppData;
    float *pDataLocal;
    int *pIDataLocal;
    
    int *I1,*I2,*I3,*I4,*I5,*I6,*I7,*I8,*I9,*I10,*I11;
    int iValue,iValue2,i,j,k,iTmp,jTmp;
    int iIndexTmp1,iIndexTmp2,iIndexTmp3,iIndexTmp4,iIndexTmp5,iIndexTmp6,iIndexTmp7,iIndexTmp8,iIndexTmp9,
        iIndexTmp10,iIndexTmp11,iIndexTmp12,iIndexTmp13,iIndexTmp14,iIndexTmp15,iIndexTmp16;
    
    int iCountLoop,CountI,CountJ,CountK;
    unsigned char iType;
    int iPlace;
    float *F1,*F2,*F3,*F4,*F5,*F6,*F7,*F8,*F9,*F10,*F11;
    int iTextureName,iIndexActivSpace;
    int iMinCount,iMinCountTmp;
    
    float *pfTmp,*TmpRx,*TmpRy,tmpf,tmpf2,tmpf3,X_1,X_2,X_3,Y_1,Y_2,Y_3,l_A,l_B;
    
    int IndexInside;
    int  **ppArr1,**ppArr2,**ppArr3,**ppArr4,**ppArr5,**ppArr6,**ppArr7,**ppArr8,**ppArr9,**ppArr10,
            **ppArr11,**ppArr12,**ppArr13,**ppArr14,**ppArr15,**ppArr16,**ppArr17,
            **ppArr18,**ppArr19,**ppArr20,**ppArr21,**ppArr22,**ppArr23,**ppArr24,**ppArr25,**ppArr26;
    
    float **ppfArr1,**ppfArr2;
    int *pRegim;
    
    int *SData1,*SData2,*SData3,*SData4,*SData5,*SData6,*SData7,*SData8,*SData9,*SData10,
            *SData11,*SData12,*SData13,*SData14,*SData15,*SData16,*SData17,*SData18,*SData19,*SData20,
            *SData21,*SData22,*SData23,*SData24,*SData25,*SData26;
    int *FData1,*FData2,*FData3,*FData4,*FData5,*FData6,*FData7,*FData8,*FData9,*FData10,
            *FData11,*FData12,*FData13,*FData14,*FData15,*FData16,*FData17,*FData18,*FData19,*FData20,
            *FData21,*FData22,*FData23,*FData24,*FData25,*FData26;
    
    Vertex3D *m_pVertices;
    float *m_pTexturUV;
    short iCurrentPlace;
    int iCurrentIndex;
    int *pQueue;
    float fTmpValue;
    
    HeartMatr *pHeart;
    MATRIXcell *pMatr;
    InfoArrayValue *pInfoTmp1,*pInfoTmp2,*pInfoTmp3,*pInfoTmp4,*pInfoTmp5,*pInfoTmp6,*pInfoTmp7,
                    *pInfoTmp8,*pInfoTmp9,*pInfoTmp10,*pInfoTmp11,*pInfoTmp12,*pInfoTmp13,*pInfoTmp14,
                    *pInfoTmp15,*pInfoTmp16,*pInfoTmp17,*pInfoTmp18,*pInfoTmp19,*pInfoTmp20,
                    *pInfoTmp21,*pInfoTmp22,*pInfoTmp23,*pInfoTmp24,*pInfoTmp25,*pInfoTmp26;
    
    NSMutableString *pName;
}

-(id)init:(id)Parent;
-(void)Update:(FractalString *)StartString Place:(int)iPlaceTmp;


@end
