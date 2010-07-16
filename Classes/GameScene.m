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

@implementation GameScene

@synthesize game = _game;   //, curLevel = _curLevel;

- (id) init
{
#ifndef NDEBUG
    NSLog(@"Entering GameScene Init");
#endif
    if ((self = [super init])) {
		self.game = [GameLayer node];
        [self addChild:_game];
    }
#ifndef NDEBUG
    NSLog(@"Leaving GameScene Init");
#endif
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
#ifndef NDEBUG
    NSLog(@"[Gamescene play:]");
#endif
    [_game play];
}

- (void)playLevel:(NSNumber*)level
{
#ifndef NDEBUG
    NSLog(@"[Gamescene playLevel:%@]",level);
#endif
    [_game playLevel:level];
}

@end
