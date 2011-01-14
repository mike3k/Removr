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
#import "GameViewController.h"
#import "FlurryAPI.h"

@implementation BlocksAppDelegate

@synthesize window;

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    window = [[UIWindow alloc] initWithFrame:frame];
    if(![CCDirector setDirectorType:kCCDirectorTypeDisplayLink])
        [CCDirector setDirectorType:kCCDirectorTypeNSTimer];

    CCDirector *director = [CCDirector sharedDirector];

    [director setAnimationInterval:1.0/60];

    EAGLView *glView = [EAGLView viewWithFrame:[window bounds] 
                                   pixelFormat:kEAGLColorFormatRGB565 
                                   depthFormat:0 preserveBackbuffer:NO
                                    sharegroup:nil
                                 multiSampling:NO
                               numberOfSamples:0
                        ];
    
    [director setOpenGLView:glView];
    [glView setMultipleTouchEnabled:YES];
    
    if( ! [director enableRetinaDisplay:YES] )
        CCLOG(@"Retina Display Not supported");
    
    controller = [[GameViewController alloc] init];
    if ([window respondsToSelector:@selector(setRootViewController:)]) {
        window.rootViewController = controller;
    }
    [window addSubview:controller.view];

    [FlurryAPI startSession:@"C8ZTGV4IBD33BR5FTXF7"];
    [GameManager shared];   // create and initialize the manager

    [window makeKeyAndVisible];
}

/*
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
	
    [FlurryAPI startSession:@"C8ZTGV4IBD33BR5FTXF7"];

    [GameManager shared];   // create and initialize the manager

	[director runWithScene: [MenuScene node]];
    //NSLog(@"applicationDidFinishLaunching returns");
}
*/

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
