//
//  LevelEditorAppDelegate.h
//  LevelEditor
//
//  Created by Mike Cohen on 7/4/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LevelEditorAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    NSImageView *imageView;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSImageView *imageView;

@end
