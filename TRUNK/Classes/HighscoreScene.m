//
//  HighscoreScene.m
//  Removr
//
//  Created by Mike Cohen on 5/28/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "HighscoreScene.h"
#import "HighScoreLayer.h"
#import "GameManager.h"

@implementation HighscoreScene

@synthesize scores = _scores;

- (id)init
{
    if ((self = [super init])) {
        self.scores = [HighScoreLayer node];
        [self addChild:_scores];
    }
    return self;
}

- (void)dealloc
{
    self.scores = nil;
    [super dealloc];
}


@end
