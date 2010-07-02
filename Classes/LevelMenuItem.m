//
//  LevelMenuItem.m
//  Removr
//
//  Created by Mike Cohen on 7/1/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "LevelMenuItem.h"

@interface LevelMenuItem (private)

- (void) makeLevelLabel;
- (void) makeMovesLabel;

@end


@implementation LevelMenuItem

enum {
    kTagBackground = 1,
    kTagLevelItem = 2,
    kTagMovesItem = 3,
};


- (void) makeLevelLabel
{
    if (nil == _labelLevel) {
        _labelLevel = [CCLabel labelWithString:[NSString stringWithFormat:@"Level %d", _level]
                                      fontName:@"Marker Felt" 
                                      fontSize:18];
        _labelLevel.position = self.anchorPointInPixels;
        [self addChild:_labelLevel z:1 tag:kTagLevelItem];
    }
    else {
        [_labelLevel setString:[NSString stringWithFormat:@"Level %d", _level]];
    }
}

- (void) makeMovesLabel
{
    if (nil == _labelMoves) {
        _labelMoves = [CCLabel labelWithString: [NSString stringWithFormat:@"(%d moves)",_moves]
                                      fontName:@"Helvetica" 
                                      fontSize:14];
        [self addChild:_labelMoves z:1 tag:kTagMovesItem];
    }
    else {
        [_labelMoves setString: [NSString stringWithFormat:@"(%d moves)",_moves]];
    }
}

- (void) makeLabels
{
    [self makeLevelLabel];
    [self makeMovesLabel];
}

- (NSInteger)level
{
    return _level;
}

- (void)setLevel:(NSInteger)value
{
    if (value != _level) {
        _level = value;
        [self makeLevelLabel];
    }
}

- (NSInteger)moves
{
    return _moves;
}

- (void)setMoves:(NSInteger)value
{
    if (value != _moves) {
        _moves = value;
        [self makeMovesLabel];
    }
}

@end
