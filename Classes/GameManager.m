//
//  LevelManager.m
//  Blocks
//
//  Created by Mike Cohen on 4/30/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "GameManager.h"
#import "SpriteDefs.h"
#import "GameScene.h"
#import "MenuScene.h"
#import "OptionScene.h"
#import "InfoScene.h"
#import "HighscoreScene.h"


#define NUM_LEVELS 4

static UInt32 levels[4][16] = {
    {
        StuffPiece(1,5,BlueHBarx4),
        StuffPiece(5,5,BlueHBarx1),
        StuffPiece(7,7,OpenRedSquare),
        StuffPiece(8,7,OpenRedSquare),
        StuffPiece(7,8,OpenGreenSquare),
        StuffPiece(8,8,OpenGreenSquare),
        StuffPiece(3,6,SolidRedCircle),
        StuffPiece(5,6,SolidGreenSquare),
        0L
    },

    {
        StuffPiece(2,4,BlueVBarx4),
        StuffPiece(3,4,OpenRedSquare),
        StuffPiece(3,5,OpenRedSquare),
        StuffPiece(3,6,OpenRedSquare),
        StuffPiece(3,7,OpenRedSquare),
        StuffPiece(3,8,SolidGreenCircle),
        StuffPiece(3,3,OpenBlueSquare),
        0L
    },

    {
        StuffPiece(5,3,BlueVBarx4),
        StuffPiece(7,7,OpenRedSquare),
        StuffPiece(8,7,OpenRedSquare),
        StuffPiece(7,8,OpenGreenSquare),
        StuffPiece(8,8,OpenGreenSquare),
        StuffPiece(3,8,SolidRedCircle),
        StuffPiece(5,8,SolidGreenSquare),
        0L
   },

    {
        //StuffPiece(5,2,OpenBlueSquare),
        StuffPiece(5,3,BlueVBarx4),
        //StuffPiece(5,4,OpenBlueSquare),
        //StuffPiece(5,5,OpenBlueSquare),
        //StuffPiece(5,6,OpenBlueSquare),
        StuffPiece(5,7,SolidRedSquare),
        StuffPiece(6,3,SolidGreenSquare),
        StuffPiece(6,2,OpenBlueSquare),
        0L
    }
};

@implementation Level

@synthesize map = _map, background = _background;

- (id)initWithBackground: (NSString*)bg data: (void*)bytes length: (int)length
{
    if ((self = [super init])) {
        self.background = bg;
        self.map = [NSData dataWithBytes:bytes length:length];
    }
    return self;
}

- (void)dealloc
{
    self.background = nil;
    self.map = nil;
    [super dealloc];
}

+ (Level*)LevelWithBackground: (NSString*)bg data: (void*)bytes length: (int)length
{
    return [[[Level alloc] initWithBackground:bg data:bytes length:length] autorelease];
}

@end


static GameManager *_sharedGameManager = nil;

@implementation GameManager

@synthesize curLevel = _curLevel, levels = _levels, gs = _gs, ms = _ms;

+ (GameManager*)shared
{
    if (nil == _sharedGameManager) {
        _sharedGameManager = [[GameManager alloc] init];
    }
    return _sharedGameManager;
}

- (id) init
{
    if ((self = [super init])) {
        self.levels = [NSMutableArray array];
        self.curLevel = 0;
        [self LoadLevels];
    }
    return self;
}

- (void)dealloc
{
    self.levels = nil;
    self.gs = nil;
    self.ms = nil;
    [super dealloc];
}


- (BOOL)LoadLevels
{
    for (int i=0; i<NUM_LEVELS;++i) {
        int len = sizeof(levels[i]);
        [_levels addObject: [Level LevelWithBackground:@"background.png" data:&levels[i][0] length:len]];
    }
    return YES;
}

- (Level*)GetLevel: (int)number
{
    if (number < [_levels count]) {
        self.curLevel = number;
        return (Level*)[_levels objectAtIndex:number];
    }
    else return nil;
}

- (int)levelCount
{
    return [_levels count];
}


- (void) GotoLevel: (Level*)level
{
}

- (void)play:(id)sender
{
    if (nil == _gs) {
        self.gs = [GameScene node];
    }
    [[CCDirector sharedDirector] replaceScene: _gs];
    [_gs playLevel: [GameManager shared].curLevel];

}

- (void)highscores:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[HighscoreScene node]];
}

- (void)options:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[OptionScene node]];
}

- (void)info:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[InfoScene node]];
}

- (void)menu: (id)sender
{
    if (nil == _ms) {
        self.ms = [MenuScene node];
    }
    [[CCDirector sharedDirector] replaceScene: _ms];
}

- (void)pause: (id)sender
{
}

- (void)resume: (id)sender
{
}

@end
