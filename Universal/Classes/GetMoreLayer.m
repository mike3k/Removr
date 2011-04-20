//
//  GetMoreLayer.m
//  Removr
//
//  Created by Mike Cohen on 2/8/11.
//  Copyright 2011 MC Development. All rights reserved.
//

#import "GetMoreLayer.h"


@implementation GetMoreLayer

- (id)init
{
    
    if ((self = [super init])) {
        CGSize wins = [[CCDirector sharedDirector] winSize];
        self.background = [[[CCSprite alloc] initWithFile:[self AltXDFile: @"info-background.png"]] autorelease];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (IBAction)dismiss: (id)sender
{
}

- (IBAction)buyFullVersion: (id)sender
{
}

@end
