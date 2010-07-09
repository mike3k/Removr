//
//  MCLayer.m
//  Removr
//
//  Created by Mike Cohen on 5/29/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "MCLayer.h"
#import "GameManager.h"

@implementation MCLayer

@synthesize delegate = _delegate;
@synthesize scale = _scale;

- (id)init
{
    if ((self = [super init])) {
        self.delegate = [GameManager shared];
        self.scale = [[UIScreen mainScreen] scale];
    }
#ifndef NDEBUG
    NSLog(@"[%@ init]",self);
#endif
    return self;
}

- (void)dealloc
{
#ifndef NDEBUG
    NSLog(@"[%@ dealloc]",self);
#endif
    [super dealloc];
}

- (CCSprite*)background
{
    return _background;
}

- (void)setBackground: (CCSprite*)value
{
    if (value != _background) {
        [self removeChild:_background cleanup:NO];
        _background = value;
        CGPoint ap = _background.anchorPointInPixels;
        _background.position = ccp(ap.x,ap.y);
        [self addChild:_background];
    }
}

- (NSString*)scaledFile: (NSString*)name
{
    if (_scale > 1) {
        //return [name stringByAppendingString:@"@x2"];
        return [name stringByReplacingOccurrencesOfString:@".png" withString:@"@x2.png"];
    }
    return name;
}

@end
