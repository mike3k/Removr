//
//  Game2AppDelegate.h
//  Game2
//
//  Created by Mike Cohen on 4/13/10.
//  Copyright MC Development 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameManager;

@interface BlocksAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
    GameManager *gm;
}

@property (nonatomic, retain) UIWindow *window;

@end
