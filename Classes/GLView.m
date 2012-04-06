//
//  GLView.m
//  Texture
//
//  Created by jeff on 5/23/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import "GLView.h"
#import "MainController.h"

@interface GLView (private)

- (void)initGLES;
- (BOOL)createFramebuffer;
- (void)destroyFramebuffer;

@end

@implementation GLView

+ (Class) layerClass
{
	return [CAEAGLLayer class];
}
-(id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if(self != nil)
	{
		[self initGLES];
	}
	return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
	if (self != nil)
	{
		[self initGLES];
	}
    
	return self;
}

-(void)initGLES
{
	CAEAGLLayer *eaglLayer = (CAEAGLLayer*) self.layer;
	
	// Configure it so that it is opaque, does not retain the contents of the backbuffer when displayed, and uses RGBA8888 color.
	eaglLayer.opaque = YES;
	eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
										[NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking,
										kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
										nil];
	
    UIScreen *pMainScreen = [UIScreen mainScreen];
    CGFloat fScale = [pMainScreen scale];

    eaglLayer.contentsScale=fScale;
    self.contentScaleFactor = fScale;
    
	// Create our EAGLContext, and if successful make it current and create our framebuffer.
	context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
	if(!context || ![EAGLContext setCurrentContext:context] || ![self createFramebuffer])
	{
		[self release];
        self = nil;
	}
}

-(MainController *)controller
{
	return controller;
}

-(void)setController:(MainController *)d
{
	controller = d;
}

// If our view is resized, we'll be asked to layout subviews.
// This is the perfect opportunity to also update the framebuffer so that it is
// the same size as our display area.
-(void)layoutSubviews
{
	[EAGLContext setCurrentContext:context];
	[self destroyFramebuffer];
	[self createFramebuffer];
	[self drawView];
}

- (BOOL)createFramebuffer
{
	// Generate IDs for a framebuffer object and a color renderbuffer
	glGenFramebuffersOES(1, &viewFramebuffer);
	glGenRenderbuffersOES(1, &viewRenderbuffer);
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	// This call associates the storage for the current render buffer with the EAGLDrawable (our CAEAGLLayer)
	// allowing us to draw into a buffer that will later be rendered to screen whereever the layer is (which corresponds with our view).
	[context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(id<EAGLDrawable>)self.layer];
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
	
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
	// For this sample, we also need a depth buffer, so we'll create and attach one via another renderbuffer.
    
	glGenRenderbuffersOES(1, &depthRenderbuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
	glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);

	if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
	{
		NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
		return NO;
	}
	
	return YES;
}

// Clean up any buffers we have allocated.
- (void)destroyFramebuffer
{
	glDeleteFramebuffersOES(1, &viewFramebuffer);
	viewFramebuffer = 0;
	glDeleteRenderbuffersOES(1, &viewRenderbuffer);
	viewRenderbuffer = 0;
	
	if(depthRenderbuffer)
	{
		glDeleteRenderbuffersOES(1, &depthRenderbuffer);
		depthRenderbuffer = 0;
	}
}

// Updates the OpenGL view when the timer fires
- (void)drawView
{
//    if(controller->m_bPause==NO){
    
        [controller.m_pObjMng UpdateObjects];

        // Make sure that you are drawing to the current context
        [EAGLContext setCurrentContext:context];
            
        glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);

        [controller.m_pObjMng drawView:self];
        
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
        [context presentRenderbuffer:GL_RENDERBUFFER_OES];
        
        GLenum err = glGetError();
        if(err)
            NSLog(@"%x error", err);
 //   }
}

// Stop animating and release resources when they are no longer needed.
- (void)dealloc
{	
	if([EAGLContext currentContext] == context)
	{
		[EAGLContext setCurrentContext:nil];
	}
	
	[context release];
	context = nil;
	
	[super dealloc];
}

@end
