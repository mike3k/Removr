//
//  GameScene.m
//  Blocks
//
//  Created by Mike Cohen on 5/10/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "GameScene.h"
#import "GameLayer.h"
#import "MenuLayer.h"
#import "GameManager.h"
#import "SimpleAudioEngine.h"

@implementation GameScene

@synthesize game = _game;   //, curLevel = _curLevel;

- (id) init
{
    if ((self = [super init])) {
		self.game = [GameLayer node];
        [self addChild:_game];
    }
    return self;
}

- (void)dealloc
{
    self.game = nil;
    [super dealloc];
}

//- (void) playLevel: (int)level
//{
//    [_game gotoLevel:level];
//}
//
//
//- (void) restartGame
//{
//    [self playLevel: _curLevel];
//}

//- (void) nextLevel
//{
//}

- (void)play:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"intro.wav"];
    [_game play];
}



@end
