//
//  MenuScene.m
//  Removr
//
//  Created by Mike Cohen on 5/28/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "MenuScene.h"
#import "MenuLayer.h"
#import "GameManager.h"

@implementation MenuScene


@synthesize menu = _menu;

- (id) init
{
    if ((self = [super init])) {
        self.menu = [MenuLayer node];
        [self addChild:_menu];
    }
    return self;
}

- (void)dealloc
{
    self.menu = nil;
    [super dealloc];
}

@end
