//
//  BackgroundView.m
//  LevelEditor
//
//  Created by Mike Cohen on 7/4/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "BackgroundView.h"


@implementation BackgroundView

@synthesize image;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        self.image = [NSImage imageNamed:@"LevelTemplate.png"];
    }
    return self;
}

- (void)dealloc
{
    [image release];
    image = nil;
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
    [image drawInRect:[self bounds] fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
}

@end
