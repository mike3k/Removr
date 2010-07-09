//
//  LevelCompleteMsg.m
//  Removr
//
//  Created by Mike Cohen on 6/27/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "LevelCompleteMsg.h"


@implementation LevelCompleteMsg

- (id) initWithMoves: (int)moves
{
    self = [super init];
    if (self) {
        CGFloat _scale = [[UIScreen mainScreen] scale];
        CCSprite *msg = [[CCSprite alloc] initWithFile:(_scale>1 ? @"Level-Complete@x2.png": @"Level-Complete.png")];
        [self addChild: msg];
//#ifdef USE_LABEL
        label = [[CCLabel alloc] initWithString:[NSString stringWithFormat: @"%d",moves] fontName:@"Marker Felt" fontSize:36*_scale];
        label.position = ccp((170.0/2.0)*_scale,(170.0/3.0)*_scale);
//#else
//        label = [[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat: @"%d",moves] 
//                                         charMapFile:@"Score-images.png"
//                                           itemWidth:20 
//                                          itemHeight:26
//                                        startCharMap:'0'];
//        label.position = ccp(170.0/2.0,170.0/3.0);
//#endif
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

@end
