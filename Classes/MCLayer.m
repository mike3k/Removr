//
//  MCLayer.m
//  Removr
//
//  Created by Mike Cohen on 5/29/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "MCLayer.h"
#import "GameManager.h"
#import "AppSettings.h"

@implementation MCLayer

@synthesize delegate = _delegate;
@synthesize scale = _scale;

static CCAction *_cloud1Action = nil;
static CCAction *_cloud2Action = nil;
static CCFiniteTimeAction *_move1;
static CCFiniteTimeAction *_move2;

- (id)init
{
    if ((self = [super init])) {
        self.delegate = [GameManager shared];
        self.scale = [[AppSettings shared] scale];
    }
#ifndef NDEBUG
    NSLog(@"MCLayer: [%@ init] - scale=%f",self,self.scale);
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

#define CLOUDPOSH   20
#define CLOUDPOSV   50

- (void)addSun
{
    CGSize wins = [[CCDirector sharedDirector] winSize];

    _sun = [[[CCSprite alloc] initWithFile:[self scaledFile:@"sun-menu.png"]] autorelease];
    _sun.anchorPoint = ccp(1.0,1.0);
    _sun.position = ccp(wins.width, wins.height);
    [self addChild:_sun];
}

- (BOOL)addClouds
{
    CGSize wins = [[CCDirector sharedDirector] winSize];

    if ([self getChildByTag:kTagCloud1]) {
        [_cloud1 stopAllActions];
        [_cloud2 stopAllActions];
        _cloud1.position = ccp(0, wins.height);
        _cloud2.position = ccp(wins.width - (CLOUDPOSV*_scale),wins.height-(CLOUDPOSH*_scale));
        return NO;
    }
    
    _cloud1 = [[[CCSprite alloc] initWithFile:[self scaledFile:@"cloud-1.png"]] autorelease];
    _cloud1.anchorPoint = ccp(0.0,1.0);
    _cloud1.position = ccp(0, wins.height);
    [self addChild:_cloud1 z:zCloudLevel tag:kTagCloud1];
    
    _cloud2 = [[[CCSprite alloc] initWithFile:[self scaledFile:@"cloud-2.png"]] autorelease];
    _cloud2.anchorPoint = ccp(1.0,1.0);
    _cloud2.position = ccp(wins.width - (CLOUDPOSV*_scale),wins.height-(CLOUDPOSH*_scale));
    [self addChild:_cloud2 z:zCloudLevel tag:kTagCloud1];
    return YES;
}

- (void) moveClouds
{
    CGSize wins = [[CCDirector sharedDirector] winSize];

    // reset position
    _cloud1.position = ccp(0, wins.height);
    _cloud2.position = ccp(wins.width - (CLOUDPOSV*_scale),wins.height-(CLOUDPOSH*_scale));
    
    // MEC 07-13-2010 - reuse actions instead of re-creating them
    if (nil == _cloud1Action) {
        _move1 = [CCMoveBy actionWithDuration:40 position:ccp(wins.width / 2, 0.0)];
        _move2 = [CCMoveBy actionWithDuration:40 position:ccp(-(wins.width / 2), 0.0)];
        
        _cloud1Action = [[CCRepeatForever actionWithAction: [CCSequence actions: _move1, [_move1 reverse], nil]] retain];
        _cloud2Action = [[CCRepeatForever actionWithAction: [CCSequence actions:  _move2, [_move2 reverse], nil]] retain];
    }

    [_cloud1 runAction: _cloud1Action];

    [_cloud2 runAction: _cloud2Action];

//    _move1 = [CCMoveBy actionWithDuration:40 position:ccp(wins.width / 2, 0.0)];
//    _move2 = [CCMoveBy actionWithDuration:40 position:ccp(-(wins.width / 2), 0.0)];
//    
//    [_cloud1 runAction: [CCRepeatForever actionWithAction: 
//                         [CCSequence actions: _move1, [_move1 reverse], nil]]];
//    [_cloud2 runAction: [CCRepeatForever actionWithAction: 
//                         [CCSequence actions:  _move2, [_move2 reverse], nil]]];

}

- (void) removeSun
{
    if (nil != _sun) {
        [self removeChild:_sun cleanup:YES];
        _sun = nil;
    }
}

- (void) removeClouds
{
    if (nil != _cloud1) {
        [self removeChild:_cloud1 cleanup:YES];
        _cloud1 = nil;
    }
    if (nil != _cloud2) {
        [self removeChild:_cloud2 cleanup:YES];
        _cloud2 = nil;
    }
}

- (void) stopClouds
{
    CGSize wins = [[CCDirector sharedDirector] winSize];
    if (nil != _cloud1) {
        [_cloud1 stopAllActions];
        _cloud1.position = ccp(0, wins.height);
    }
    if (nil != _cloud2) {
        [_cloud2 stopAllActions];
        _cloud2.position = ccp(wins.width - (CLOUDPOSV*_scale),wins.height-(CLOUDPOSH*_scale));
    }
}


@end
