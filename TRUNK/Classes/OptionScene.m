//
//  OptionScene.m
//  Removr
//
//  Created by Mike Cohen on 5/28/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "OptionScene.h"
#import "OptionsLayer.h"
#import "GameManager.h"

@implementation OptionScene

@synthesize options = _options;

- (id)init
{
    if ((self = [super init])) {
        self.options = [OptionsLayer node];
        [self addChild:_options];
    }
    return self;
}

- (void)dealloc
{
    self.options = nil;
    [super dealloc];
}


@end
