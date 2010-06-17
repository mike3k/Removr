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
        self.background = [[[CCSprite alloc] initWithFile:@"background.png"] autorelease];
        CCMenu *menu = [CCMenu menuWithItems: [CCMenuItemImage itemFromNormalImage:@"back.png" 
                                                                     selectedImage:@"back-sel.png" 
                                                                            target:_delegate 
                                                                          selector:@selector(menu:)], nil];
        [menu alignItemsVertically];
        [self addChild:menu];
    }
    return self;
}

@end
