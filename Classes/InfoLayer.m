//
//  InfoLayer.m
//  Blocks
//
//  Created by Mike Cohen on 5/26/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "InfoLayer.h"
#import "GameKitHelper.h"

@implementation InfoLayer

- (id)init
{
    
    if ((self = [super init])) {
        CGSize wins = [[CCDirector sharedDirector] winSize];
        self.background = [[[CCSprite alloc] initWithFile:[self altScaledFile: @"info-background.png"]] autorelease];
        CCMenu *menu = [CCMenu menuWithItems: [CCMenuItemImage itemFromNormalImage:[self scaledFile: @"back.png"]
                                                                     selectedImage:[self scaledFile: @"back-sel.png"]
                                                                            target:_delegate 
                                                                          selector:@selector(menu:)], nil];
        [menu alignItemsVertically];
        menu.position = ccp(wins.width-(60*self.scale), 30*self.scale);
        [self addChild:menu z: zMenuLayer];
        
        CCMenu *menu2 = [CCMenu menuWithItems: [CCMenuItemImage itemFromNormalImage:[self scaledFile: @"visit.png"]
                                                                      selectedImage:[self scaledFile: @"visit-sel.png"]
                                                                             target:_delegate
                                                                           selector:@selector(visitweb:)],nil];
        [menu2 alignItemsVertically];
        menu2.position = ccp(wins.width/2,50*self.scale);
        [self addChild:menu2 z:zMenuLayer];
        
        if ([GameKitHelper sharedGameKitHelper].isGameCenterAvailable) {
            CCMenu *menu3 = [CCMenu menuWithItems: [CCMenuItemImage itemFromNormalImage:[self scaledFile:@"best-scores.png"] 
                                                                          selectedImage:[self scaledFile:@"best-scores-selected.png"]
                                                                                 target: _delegate
                                                                               selector: @selector(showLeaderBoard:)],
            
            
                                                    [CCMenuItemImage itemFromNormalImage:[self scaledFile:@"leaderboard.png"] 
                                                                           selectedImage:[self scaledFile:@"leaderboard-selected.png"]
                                                                                  target:_delegate
                                                                                selector:@selector(showAchievements:)],nil];
            [menu3 alignItemsHorizontallyWithPadding:20*self.scale];
            menu3.position = ccp(wins.width/2,92*self.scale);
            [self addChild:menu3 z:zMenuLayer];
        }

        
    }
    return self;
}

@end
