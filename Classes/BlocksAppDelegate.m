//
//  Game2AppDelegate.m
//  Game2
//
//  Created by Mike Cohen on 4/13/10.
//  Copyright MC Development 2010. All rights reserved.
//

#import "BlocksAppDelegate.h"
#import "cocos2d.h"
//#import "GameLayer.h"
//#import "GameScene.h"
#import "GameManager.h"
#import "MenuScene.h"

@implementation BlocksAppDelegate

@synthesize window;

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
	
	// create an openGL view inside a window
	[[CCDirector sharedDirector] attachInView:window];	
	[window makeKeyAndVisible];		
		
		
	[[CCDirector sharedDirector] runWithScene: [MenuScene node]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"will resign active");
	[[CCDirector sharedDirector] stopAnimation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"app will terminate");
	[[CCDirector sharedDirector] end];
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
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
