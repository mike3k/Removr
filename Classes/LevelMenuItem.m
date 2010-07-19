//
//  LevelMenuItem.m
//  Removr
//
//  Created by Mike Cohen on 7/1/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "LevelMenuItem.h"
#import "AppSettings.h"

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
        CGFloat _scale = [[AppSettings shared] scale];
        _labelLevel = [CCLabel labelWithString:[NSString stringWithFormat:@"Level %d", _level]
                                      fontName:@"Marker Felt" 
                                      fontSize:18*_scale];
        _labelLevel.position = ccp(self.anchorPointInPixels.x,self.anchorPointInPixels.y+2);
        [_labelLevel setColor:ccc3(128, 0, 0)];
        [self addChild:_labelLevel z:1 tag:kTagLevelItem];
    }
    else {
        [_labelLevel setString:[NSString stringWithFormat:@"Level %d", _level]];
    }
}

- (void) makeMovesLabel
{
    if (nil == _labelMoves) {
        CGFloat _scale = [[AppSettings shared] scale];
        _labelMoves = [CCLabel labelWithString: [NSString stringWithFormat:@"(%d moves)",_moves]
                                      fontName:@"Helvetica" 
                                      fontSize:14*_scale];
        _labelMoves.position = ccp(self.anchorPointInPixels.x,12*_scale);
        [_labelMoves setColor: ccc3(128, 0, 0)];
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
        _moves = (value > 0) ? value : 0;
        if (0 == value) {
            if (nil != _labelMoves) {
                [_labelMoves setString:@" "];
            }
        }
        else {
            [self makeMovesLabel];
        }
    }
}

- (void)setOpacity: (GLubyte)opacity
{
    if (nil != _labelLevel) {
        [_labelLevel setOpacity:opacity];
    }
    if (nil != _labelMoves) {
        [_labelMoves setOpacity:opacity];
    }
    [super setOpacity:opacity];
}

@end
