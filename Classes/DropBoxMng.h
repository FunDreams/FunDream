//
//  InfoFile.h
//  FunDreams
//
//  Created by Konstantin on 27.09.12.
//  Copyright (c) 2012 FunDreams. All rights reserved.
//

#import <Foundation/Foundation.h>
    
@interface DropBoxMng : GObject{
@public
    CDataManager *pDataManager;
    bool bBusy;
    
    FractalString *pDropBoxString;
    int m_iCurrentSelect;
    
    bool bMetaDataLoaded;
    bool bInfoLoaded;
}

-(id)Init:(id)Parent WithName:(NSString *)strName;
- (void)UpdateButt;
- (void)Hide;
- (void)Show;
-(void)DownLoadInfoFile;

@end
