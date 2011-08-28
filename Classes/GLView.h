//
//  GLView.h
//  Texture
//
//  Created by jeff on 5/23/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainController;
@interface GLView : UIView
{
	Vector3D vector_right;

	// The pixel dimensions of the backbuffer
	GLint backingWidth;
	GLint backingHeight;
	
	EAGLContext *context;
	GLuint viewRenderbuffer, viewFramebuffer;
	GLuint depthRenderbuffer;

	MainController *controller;
}

@property(nonatomic, retain) MainController *controller;

-(void)drawView;

@end
