//
//  InfoScene.m
//  Removr
//
//  Created by Mike Cohen on 5/28/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "InfoScene.h"
#import "InfoLayer.h"
#import "GameManager.h"

@implementation InfoScene

@synthesize info = _info;

- (id)init
{
    if ((self = [super init])) {
        self.info = [InfoLayer node];
        _info.delegate = [GameManager shared];
        [self addChild:_info];
    }
    return self;
}

- (void)dealloc
{
    self.info = nil;
    [super dealloc];
}

@end
