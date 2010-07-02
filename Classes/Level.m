// 
//  Level.m
//  Removr
//
//  Created by Mike Cohen on 6/18/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "Level.h"


@implementation Level 
#ifdef USE_CORE_DATA

@dynamic map;
@dynamic background;
@dynamic index;
#else
@synthesize map = _map, background = _background, index = _index, par = _par, title = _title;

- (id)alloc
{
    if ((self = [super init])) {
    }
    return self;
}

- (void)dealloc
{
    self.map = nil;
    self.background = nil;
    self.title = nil;
    [super dealloc];
}

#endif

@end
