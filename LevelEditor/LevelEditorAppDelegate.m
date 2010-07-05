//
//  LevelEditorAppDelegate.m
//  LevelEditor
//
//  Created by Mike Cohen on 7/4/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "LevelEditorAppDelegate.h"

@implementation LevelEditorAppDelegate

@synthesize window;
@synthesize imageView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
}

- (void)awakeFromNib
{
    [imageView setImage: [NSImage imageNamed:@"LevelTemplate.tiff"]];
}

@end
