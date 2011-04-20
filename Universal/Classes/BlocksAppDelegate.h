//
//  Game2AppDelegate.h
//  Game2
//
//  Created by Mike Cohen on 4/13/10.
//  Copyright MC Development 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameManager;
@class GameViewController;

@interface BlocksAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
    GameManager *gm;
    GameViewController *controller;
}

@property (nonatomic, retain) UIWindow *window;

@end
