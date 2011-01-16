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
        self.background = [[[CCSprite alloc] initWithFile:[self XDFile: self.bgFileName]] autorelease];
        bSound = [OnOffButton makeButtonWithTarget: self selector: @selector(toggleSound:)];
//        bAccel = [OnOffButton makeButtonWithTarget: self selector: @selector(toggleAccel:)];
        bNight = [OnOffButton makeButtonWithTarget: self selector: @selector(toggleNight:)];

        bSound.on = aps.sound;
//        bAccel.on = aps.accelerometer;
        bNight.on = aps.nightmode;

        NSString *spacer = [self scaledFile:@"spacer.png"];
        
        CCMenu *menu = [CCMenu menuWithItems: 
                        [CCMenuItemImage itemFromNormalImage:[self scaledFile: @"title-options.png"]
                                               selectedImage:[self scaledFile: @"title-options.png"]],
                        [CCMenuItemImage itemFromNormalImage:[self scaledFile: @"label-sound.png"]
                                               selectedImage:[self scaledFile: @"label-sound.png"]],
                        bSound,
//                        [CCMenuItemImage itemFromNormalImage:[self scaledFile: @"label-accellerometer.png"]
//                                               selectedImage:[self scaledFile: @"label-accellerometer.png"]],
//                        bAccel,
                        [CCMenuItemImage itemFromNormalImage:[self scaledFile:@"label-nightmode.png"]
                                               selectedImage:[self scaledFile:@"label-nightmode.png"]],
                        bNight,
                        [CCMenuItemImage itemFromNormalImage:spacer selectedImage:spacer],
//                        [CCMenuItemImage itemFromNormalImage:@"spacer.png" selectedImage:@"spacer.png"],
//                        [CCMenuItemImage itemFromNormalImage:@"back.png" 
//                                               selectedImage:@"back-sel.png" 
//                                                      target:self 
//                                                    selector:@selector(done)],
                        nil];

        [menu alignItemsInColumns:  [NSNumber numberWithInt:1],
                                    [NSNumber numberWithInt:2],
//                                    [NSNumber numberWithInt:2],
                                    [NSNumber numberWithInt:2],
                                    [NSNumber numberWithInt:1],
//                                    [NSNumber numberWithInt:1],
         nil];

        [self addChild:menu z: zMenuLayer];

        CGSize wins = [[CCDirector sharedDirector] winSize];
        CCMenu *menu2 = [CCMenu menuWithItems: [CCMenuItemImage itemFromNormalImage:[self scaledFile: @"back.png"] 
                                                                     selectedImage:[self scaledFile: @"back-sel.png"]
                                                                            target:self 
                                                                          selector:@selector(done)], nil];
        [menu2 alignItemsVertically];
        menu2.position = ccp(wins.width-(60*_scale), 30*_scale);
        [self addChild:menu2 z: zMenuLayer];
        if ([self addClouds]) {
            [self moveClouds];
        }

    }
    return self;
}

- (void)toggleSound:(id)sender
{
    //NSLog(@"toggle sound: %@",sender);
    aps.sound = bSound.on;
}

- (void)toggleNight:(id)sender
{
    aps.nightmode = bNight.on;
}

- (void)toggleAccel:(id)sender
{
    //NSLog(@"toggle accelerometer: %@",sender);
//    aps.accelerometer = bAccel.on;
}

- (void)done
{
    [aps save];
    [_delegate menu:self];
}

- (void)dealloc
{
//    [aps save];
    [super dealloc];
}


@end
