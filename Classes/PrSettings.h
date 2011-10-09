//
//  Object.h
//  Engine
//
//  Created by Konstantin on 02.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "PlManager.h"

//класс родитель для обектов приложения, каждый объект должен наследоваться от него.
@interface CPrSettings : NSObject {
	
@public
	CPlManager *m_pPlManager;
	int m_iCurRecord; 
}
- (id)Init;

- (bool) Load;

- (bool) Save;

- (void)dealloc;

@end
