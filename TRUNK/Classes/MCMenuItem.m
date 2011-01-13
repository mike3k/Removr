//
//  MCMenuItem.m
//  Removr
//
//  Created by Mike Cohen on 7/2/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "MCMenuItem.h"


@implementation MCMenuItem

-(void) setIsEnabled:(BOOL)enabled
{
    [self setOpacity:enabled ? 255 : 127];
    [super setIsEnabled:enabled];
}

@end
