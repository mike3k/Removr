//
//  InfoLayer.m
//  Blocks
//
//  Created by Mike Cohen on 5/26/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "InfoLayer.h"


@implementation InfoLayer

- (id)init
{
    
    if ((self = [super init])) {
        CGSize wins = [[CCDirector sharedDirector] winSize];
        self.background = [[[CCSprite alloc] initWithFile:@"info-background.png"] autorelease];
        CCMenu *menu = [CCMenu menuWithItems: [CCMenuItemImage itemFromNormalImage:@"back.png" 
                                                                     selectedImage:@"back-sel.png" 
                                                                            target:_delegate 
                                                                          selector:@selector(menu:)], nil];
        [menu alignItemsVertically];
        menu.position = ccp(wins.width-60, 30);
        [self addChild:menu];
        
        CCMenu *menu2 = [CCMenu menuWithItems: [CCMenuItemImage itemFromNormalImage:@"visit.png" 
                                                                      selectedImage:@"visit-sel.png"
                                                                             target:_delegate
                                                                           selector:@selector(visitweb:)],nil];
        [menu2 alignItemsVertically];
        menu2.position = ccp(wins.width/2,80);
        [self addChild:menu2];
        
    }
    return self;
}

@end
