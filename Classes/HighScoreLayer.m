//
//  HighScoreLayer.m
//  Removr
//
//  Created by Mike Cohen on 5/28/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "HighScoreLayer.h"


@implementation HighScoreLayer

- (id)init
{
    
    if ((self = [super init])) {
        self.background = [[[CCSprite alloc] initWithFile:@"background.png"] autorelease];
        CGSize wins = [[CCDirector sharedDirector] winSize];
        CCMenu *menu = [CCMenu menuWithItems: [CCMenuItemImage itemFromNormalImage:@"back.png" 
                                                                     selectedImage:@"back-sel.png" 
                                                                            target:_delegate 
                                                                          selector:@selector(menu:)], nil];
        [menu alignItemsVertically];
        menu.position = ccp(wins.width-60, 30);
        [self addChild:menu];
    }
    return self;
}


@end
