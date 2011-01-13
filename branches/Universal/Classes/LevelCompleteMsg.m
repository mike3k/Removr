//
//  LevelCompleteMsg.m
//  Removr
//
//  Created by Mike Cohen on 6/27/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "LevelCompleteMsg.h"
#import "AppSettings.h"

@implementation LevelCompleteMsg

- (id) initWithMoves: (int)moves level: (int)level time: (float)time blues: (int)blues
{
    self = [super init];
    if (self) {
        CGFloat _scale = [[AppSettings shared] scale];
//        label = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat: @"Completed Level %d\nin %d moves%s",level,moves,bluemsg] 
        label = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat: @"Completed Level %d",level+1]
                                                                  fontName:@"Marker Felt" 
                                                                  fontSize:34*_scale];
    
        label2 =  [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"in %@ with %d move%s",format_time(time),moves,(moves!=1)?"s":" "] 
                                         fontName:@"Marker Felt" 
                                         fontSize:22*_scale];
        label2.position = ccp(label.position.x,label.position.y-label.contentSize.height + (6*_scale));
        [self addChild:label];
        [self addChild:label2];
        if (0 == blues) {
            label3 = [[CCLabelTTF alloc] initWithString:@"Good work! No blue pieces removed!" 
                                            fontName:@"Marker Felt" 
                                            fontSize:24*_scale];
            label3.position = ccp(label2.position.x,label2.position.y-label2.contentSize.height);
            [self addChild:label3];
        }
        _moves = moves;
        _level = level;
        _time = time;
        _blueRemoved = blues;
    }
    return self;
}

- (id) initWithMoves: (int)moves
{
    self = [super init];
    if (self) {
        CGFloat _scale = [[AppSettings shared] scale];
        CCSprite *msg = [[CCSprite alloc] initWithFile:(_scale>1 ? @"Level-Complete@x2.png": @"Level-Complete.png")];
        [self addChild: msg];
        label = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat: @"%d",moves] fontName:@"Marker Felt" fontSize:36*_scale];
        label.position = ccp((170.0/2.0)*_scale,(170.0/3.0)*_scale);
        [msg addChild: label];
        [label release];
        [msg release];
        _moves = moves;
    }
    return self;
}

- (void) dealloc
{
    [self removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

- (void) setMoves: (int)value
{
    _moves = value;
//    char str[16];
//    sprintf(str,"%d",value);
//    
//    [label setCString:str];
    [label setString:[NSString stringWithFormat:@"%d",value]];
}

- (int) moves
{
    return _moves;
}

-(void) setLevel: (int)value
{
    _level = value;
}

- (int) level
{
    return _level;
}

- (float) time
{
    return _time;
}

- (void) setTime: (float)value
{
    _time = value;
}

- (void)setBlueRemoved: (int)value
{
    _blueRemoved = value;
}

- (int)blueRemoved
{
    return _blueRemoved;
}

@end
