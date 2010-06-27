//
//  OptionsLayer.m
//  Blocks
//
//  Created by Mike Cohen on 5/26/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "OptionsLayer.h"

@implementation OptionsLayer

- (id)init
{

    if ((self = [super init])) {
        aps = [AppSettings shared];
        self.background = [[[CCSprite alloc] initWithFile:@"background.png"] autorelease];
        bSound = [OnOffButton makeButtonWithTarget: self selector: @selector(toggleSound:)];
        bAccel = [OnOffButton makeButtonWithTarget: self selector: @selector(toggleAccel:)];

        bSound.on = aps.sound;
        bAccel.on = aps.accelerometer;

        CCMenu *menu = [CCMenu menuWithItems: 
                        [CCMenuItemImage itemFromNormalImage:@"title-options.png" selectedImage:@"title-options.png"],
                        [CCMenuItemImage itemFromNormalImage:@"label-sound.png" selectedImage:@"label-sound.png"],
                        bSound,
                        [CCMenuItemImage itemFromNormalImage:@"label-accellerometer.png" selectedImage:@"label-accellerometer.png"],
                        bAccel,
                        [CCMenuItemImage itemFromNormalImage:@"back.png" 
                                               selectedImage:@"back-sel.png" 
                                                      target:_delegate 
                                                    selector:@selector(menu:)],
                        nil];

        [menu alignItemsInColumns:  [NSNumber numberWithInt:1],
                                    [NSNumber numberWithInt:2],
                                    [NSNumber numberWithInt:2],
                                    [NSNumber numberWithInt:1],
         nil];

        [self addChild:menu];
    }
    return self;
}

- (void)toggleSound:(id)sender
{
    NSLog(@"toggle sound: %@",sender);
    aps.sound = bSound.on;
}

- (void)toggleAccel:(id)sender
{
    NSLog(@"toggle accelerometer: %@",sender);
    aps.accelerometer = bAccel.on;
}

- (void)dealloc
{
    [aps save];
    [super dealloc];
}


@end
