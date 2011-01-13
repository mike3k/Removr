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
- (void) makeTimeLabel;

@end


@implementation LevelMenuItem

enum {
    kTagBackground = 1,
    kTagLevelItem = 2,
    kTagMovesItem = 3,
    kTagTimeLabel = 4
};


- (void) makeLevelLabel
{
    if (nil == _labelLevel) {
        CGFloat _scale = [[AppSettings shared] scale];
        _labelLevel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level %d", _level]
                                      fontName:@"Marker Felt" 
                                      fontSize:16*_scale];
        //_labelLevel.position = ccp(self.anchorPointInPixels.x,self.anchorPointInPixels.y+2);
        [_labelLevel setColor:ccc3(128, 0, 0)];
        //_labelLevel.position = ccp(0,12*_scale);
        _labelLevel.position = ccp(self.anchorPointInPixels.x,self.anchorPointInPixels.y+(12*_scale));
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
        _labelMoves = [CCLabelTTF labelWithString: [NSString stringWithFormat:@"(%d move%@)",_moves,(_moves>1?@"s":@"")]
                                      fontName:@"Helvetica" 
                                      fontSize:14*_scale];
        //_labelMoves.position = ccp(self.anchorPointInPixels.x,12*_scale);
        [_labelMoves setColor: ccc3(128, 0, 0)];
        //_labelMoves.position = ccp(0,0);
        _labelMoves.position = ccp(self.anchorPointInPixels.x,self.anchorPointInPixels.y);
        [self addChild:_labelMoves z:1 tag:kTagMovesItem];
    }
    else {
        [_labelMoves setString: [NSString stringWithFormat:@"(%d moves)",_moves]];
    }
}

- (void) makeTimeLabel
{
    if (nil == _labelTime) {
        CGFloat _scale = [[AppSettings shared] scale];
        //[NSString stringWithFormat:@"(%.0f seconds)",_time]
        _labelTime = [CCLabelTTF labelWithString: format_time(_time)
                                     fontName:@"Helvetica" 
                                      fontSize:14*_scale];
        //_labelTime.position = ccp(self.anchorPointInPixels.x,24*_scale);
        [_labelTime setColor: ccc3(128, 0, 0)];
        //_labelTime.position = ccp(0,-(12*_scale));
        _labelTime.position = ccp(self.anchorPointInPixels.x,self.anchorPointInPixels.y-(12*_scale));
        [self addChild:_labelTime z:1 tag:kTagTimeLabel];
    }
    else {
        [_labelTime setString: format_time(_time)];
         //[NSString stringWithFormat:@"(%.0f seconds)",_time]];
    }
}

- (void) makeLabels
{
    [self makeLevelLabel];
    [self makeMovesLabel];
    [self makeTimeLabel];
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

- (NSTimeInterval) time
{
    return _time;
}

- (void)setTime:(NSTimeInterval)value
{
    if (value != _time) {
        _time = value;
        if (0 == value) {
            if (nil != _labelTime) {
                [_labelTime setString:@" "];
            }
        }
        else {
            [self makeTimeLabel];
        }
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
