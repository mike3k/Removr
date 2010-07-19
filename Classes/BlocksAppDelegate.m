//
//  Game2AppDelegate.m
//  Game2
//
//  Created by Mike Cohen on 4/13/10.
//  Copyright MC Development 2010. All rights reserved.
//

#import "BlocksAppDelegate.h"
#import "cocos2d.h"
#import "GameManager.h"
#import "AppSettings.h"
#import "MenuScene.h"

@implementation BlocksAppDelegate

@synthesize window;

/* *****
- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// cocos2d will inherit these values
	[window setUserInteractionEnabled:YES];	
	[window setMultipleTouchEnabled:YES];
	
    gm = [GameManager shared];
    
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:CCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:CCDirectorTypeDefault];
	
	// Use RGBA_8888 buffers
	// Default is: RGB_565 buffers
	[[CCDirector sharedDirector] setPixelFormat:kPixelFormatRGBA8888];
	
	// Create a depth buffer of 16 bits
	// Enable it if you are going to use 3D transitions or 3d objects
//	[[CCDirector sharedDirector] setDepthBufferFormat:kDepthBuffer16];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];
	
	// before creating any layer, set the landscape mode
    [[CCDirector sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];

	[[CCDirector sharedDirector] setAnimationInterval:1.0/60];
	[[CCDirector sharedDirector] setDisplayFPS:NO];

	//[[CCDirector sharedDirector] setContentScaleFactor:2];

	// create an openGL view inside a window
	[[CCDirector sharedDirector] attachInView:window];	
	[window makeKeyAndVisible];		
		
		
	[[CCDirector sharedDirector] runWithScene: [MenuScene node]];
}
**** */

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// CC_DIRECTOR_INIT()
	//
	// 1. Initializes an EAGLView with 0-bit depth format, and RGB565 render buffer
	// 2. EAGLView multiple touches: disabled
	// 3. creates a UIWindow, and assign it to the "window" var (it must already be declared)
	// 4. Parents EAGLView to the newly created window
	// 5. Creates Display Link Director
	// 5a. If it fails, it will use an NSTimer director
	// 6. It will try to run at 60 FPS
	// 7. Display FPS: NO
	// 8. Device orientation: Portrait
	// 9. Connects the director to the EAGLView
	//
	CC_DIRECTOR_INIT();
	
	// Obtain the shared director in order to...
	CCDirector *director = [CCDirector sharedDirector];
	
	// Sets landscape mode
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];

    [director setContentScaleFactor:[[AppSettings shared] scale]];

	// Turn on multiple touches
	EAGLView *view = [director openGLView];
	[view setMultipleTouchEnabled:YES];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];	
    //[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA4444];
	
    [GameManager shared];   // create and initialize the manager

	[director runWithScene: [MenuScene node]];
    //NSLog(@"applicationDidFinishLaunching returns");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	[[CCDirector sharedDirector] stopAnimation];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] synchronize];
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
}

- (void)applicationWillTerminate:(UIApplication *)application {
#ifndef NDEBUG
    NSLog(@"app will terminate");
#endif
	[[CCDirector sharedDirector] end];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

// for iOS 4
//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//    NSLog(@"did enter background");
//	[[CCDirector sharedDirector] stopAnimation];
//}
//
//- (void)applicationWillEnterForeground:(UIApplication *)application
//{
//    NSLog(@"will enter foreground");
//	[[CCDirector sharedDirector] startAnimation];
//}

- (void)dealloc {
#ifndef NDEBUG
    NSLog(@"app dealloc");
#endif
    [[AppSettings shared] save];
//	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
