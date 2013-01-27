//
//  InfoFile.m
//  FunDreams
//
//  Created by Konstantin on 23.01.13.
//  Copyright (c) 2013 FunDreams. All rights reserved.
//

#import "InfoFile.h"
//-----------------------------------------------------------------------------------------------
@implementation Head
-(id)init{
    
    self = [super init];
    
    if(self){}
    return self;
}
//-----------------------------------------------------------------------------------------------
-(id)init:(FractalString *)String{
    
    self = [super init];
    
    if(self){
        sNameIcon=[NSString stringWithString:String->sNameIcon];
        strUID=[NSString stringWithString:String->strUID];
        
        X=String->X;
        Y=String->Y;
        TypeInformation=String->TypeInformation;
        NameInformation=String->NameInformation;
        iFlags=String->m_iFlags;
    }
    return self;
}
//-----------------------------------------------------------------------------------------------
-(void)SaveFile:(NSMutableData *)pData{
    
    unichar* ucBuff = (unichar*)calloc(512, sizeof(unichar));
    
    [strUID getCharacters:ucBuff];
    int Len=[strUID length];
    [pData appendBytes:&Len length:sizeof(int)];
    [pData appendBytes:ucBuff length:Len*sizeof(unichar)];
    
    [sNameIcon getCharacters:ucBuff];
    Len=[sNameIcon length];
    [pData appendBytes:&Len length:sizeof(int)];
    [pData appendBytes:ucBuff length:Len*sizeof(unichar)];
    
    free(ucBuff);
    //------------------------------------------------------------------------------------------------------
    //float value
    [pData appendBytes:&X length:sizeof(float)];
    [pData appendBytes:&Y length:sizeof(float)];
    //флаги
    [pData appendBytes:&iFlags length:sizeof(iFlags)];
    //тип струны.
    [pData appendBytes:&TypeInformation length:sizeof(BYTE)];
    //Имя-число струны.
    [pData appendBytes:&NameInformation length:sizeof(short)];
}
//-----------------------------------------------------------------------------------------------
-(void)LoadFile:(NSMutableData *)pData ReadPos:(int *)iCurReadingPos{
    
    //Name-----------------------------------------------------------------------------
    unichar* ucBuff = (unichar*)calloc(512, sizeof(unichar));
    int iLen;
    //---------------------------------------------------------------------------------
    NSRange Range = { *iCurReadingPos, sizeof(int)};
    [pData getBytes:&iLen range:Range];
    *iCurReadingPos += sizeof(int);
    Range = NSMakeRange( *iCurReadingPos, iLen*sizeof(unichar));
    
    [pData getBytes:ucBuff range:Range];
    
    *iCurReadingPos += iLen*sizeof(unichar);
    
    NSString *sValue = [NSString stringWithCharacters:ucBuff length:iLen];
    strUID = [[NSString alloc] initWithString:sValue];
    //---------------------------------------------------------------------------------
    Range = NSMakeRange( *iCurReadingPos, sizeof(int));
    [pData getBytes:&iLen range:Range];
    *iCurReadingPos += sizeof(int);
    Range = NSMakeRange( *iCurReadingPos, iLen*sizeof(unichar));
    
    [pData getBytes:ucBuff range:Range];
    
    *iCurReadingPos += iLen*sizeof(unichar);
    
    sValue = [NSString stringWithCharacters:ucBuff length:iLen];
    sNameIcon = [[NSString alloc] initWithString:sValue];
    //---------------------------------------------------------------------------------
    free(ucBuff);
    
    //float value
    Range = NSMakeRange( *iCurReadingPos, sizeof(float));
    [pData getBytes:&X range:Range];
    *iCurReadingPos += sizeof(float);
    
    Range = NSMakeRange( *iCurReadingPos, sizeof(float));
    [pData getBytes:&Y range:Range];
    *iCurReadingPos += sizeof(float);
    
    Range = NSMakeRange( *iCurReadingPos, sizeof(int));
    [pData getBytes:&iFlags range:Range];
    *iCurReadingPos += sizeof(int);
    
    //тип струны.
    Range = NSMakeRange( *iCurReadingPos, sizeof(BYTE));
    [pData getBytes:&TypeInformation range:Range];
    *iCurReadingPos += sizeof(BYTE);
    
    //Имя-число струны.
    Range = NSMakeRange( *iCurReadingPos, sizeof(short));
    [pData getBytes:&NameInformation range:Range];
    *iCurReadingPos += sizeof(short);
}
//-----------------------------------------------------------------------------------------------
@end
//-----------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------
@implementation InfoFile
-(id)init:(FractalString *)String WithParent:(StringContainer *)pParent{
    
    self = [super init];
    
    m_pParent=pParent;
    
    if(self){
        
        InsideString=String;
        pArray=[[NSMutableArray alloc] init];
    }
    return self;
}
//-----------------------------------------------------------------------------------------------
-(void)Clear{
    [pArray removeAllObjects];
}
//-----------------------------------------------------------------------------------------------
-(void)Update{
    [self Clear];
    
    int *Data=(*InsideString->pChildString);
    InfoArrayValue *InfoStr=(InfoArrayValue *)(Data);
    
    for(int i=0;i<InfoStr->mCount;i++){
        
        int index=(Data+SIZE_INFO_STRUCT)[i];
        FractalString *pFrStr=[m_pParent->ArrayPoints
                               GetIdAtIndex:index];
        
        Head *pHead = [[Head alloc] init:pFrStr];
        [pArray addObject:pHead];
        [pHead release];        
    }
}
//-----------------------------------------------------------------------------------------------
-(void)SaveFile:(NSMutableData *)pData{
    
    int iCount=[pArray count];
    [pData appendBytes:&iCount length:sizeof(int)];
    
    for(int i=0;i<iCount;i++){
        Head *pHead=[pArray objectAtIndex:i];
        [pHead SaveFile:pData];
    }
}
//-----------------------------------------------------------------------------------------------
-(void)LoadFile:(NSMutableData *)pData ReadPos:(int *)iCurReadingPos{
    
    [self Clear];
    
    int iCount;
    [pData getBytes:&iCount range:NSMakeRange( *iCurReadingPos, sizeof(int))];
    *iCurReadingPos += sizeof(int);
    
    for(int i=0;i<iCount;i++){
        Head *pHead = [[Head alloc] init];
        [pHead LoadFile:pData ReadPos:iCurReadingPos];
        [pArray addObject:pHead];
        [pHead release];
    }
}
//-----------------------------------------------------------------------------------------------
- (void)dealloc
{
    [self Clear];
    [pArray release];
    [super dealloc];
}
@end
