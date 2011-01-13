    //
//  GameViewController.m
//  Removr
//
//  Created by Mike Cohen on 9/12/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "GameViewController.h"
#import "MenuScene.h"
#import "AppSettings.h"

@implementation GameViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    // Obtain the shared director in order to...
    CCDirector *director = [CCDirector sharedDirector];

    // Sets landscape mode
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];

    [director setContentScaleFactor:[[AppSettings shared] scale]];

    // Turn off display FPS
    [director setDisplayFPS:NO];

    // Turn on multiple touches
    EAGLView *eaglView = [director openGLView];
    [eaglView setMultipleTouchEnabled:YES];

    [self.view addSubview:eaglView];

    // Default texture format for PNG/BMP/TIFF/JPEG/GIF images
    // It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
    // You can change anytime.
    [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];

    [[CCDirector sharedDirector] runWithScene: [MenuScene node]];

}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
