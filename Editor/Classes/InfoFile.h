//
//  InfoFile.h
//  FunDreams
//
//  Created by Konstantin on 23.01.13.
//  Copyright (c) 2013 FunDreams. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Head : NSObject {
@public
    NSString *sNameIcon,*sNameIcon2,*sNameIcon3,*strUID;
    float X,Y;
    int iFlags;
}

-(id)init;
-(id)init:(FractalString *)InsideString;

-(void)SaveFile:(NSMutableData *)pData;
-(void)LoadFile:(NSMutableData *)pData ReadPos:(int *)iCurReadingPos;
- (void)dealloc;
@end

@interface InfoFile : NSObject{
@public
    StringContainer * m_pParent;
    FractalString *InsideString;
    NSMutableArray *pArray;
}

-(id)init:(FractalString *)String WithParent:(StringContainer *)pParent;

-(void)SaveFile:(NSMutableData *)pData;
-(void)LoadFile:(NSMutableData *)pData ReadPos:(int *)iCurReadingPos;

-(void)Clear;
-(void)Update;

@end
