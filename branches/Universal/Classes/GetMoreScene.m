//
//  GetMoreScene.m
//  Removr
//
//  Created by Mike Cohen on 2/8/11.
//  Copyright 2011 MC Development. All rights reserved.
//

#import "GetMoreScene.h"
#import "GetMoreLayer.h"
#import "GameManager.h"

@implementation GetMoreScene

@synthesize theLayer;

- (id)init
{
    if ((self = [super init])) {
        self.theLayer = [GetMoreLayer node];
        theLayer.delegate = [GameManager shared];
        [self addChild:theLayer];
    }
    return self;
}

- (void)dealloc
{
    self.theLayer = nil;
    [super dealloc];
}

+ (void)ShowPurchaseScreen
{
}

@end
