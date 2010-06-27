//
//  AppSettings.m
//  Removr
//
//  Created by Mike Cohen on 6/26/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "AppSettings.h"

static AppSettings *theSettings = nil;

@implementation AppSettings

@synthesize sound = _sound;
@synthesize accelerometer = _accelerometer;

+ (AppSettings*)shared {
    if (nil == theSettings) {
        theSettings = [[AppSettings alloc] init];
    }
    return theSettings;
}

- (id) init {
    if ((self = [super init])) {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        self.sound = [def boolForKey: @"sound"];
        self.accelerometer = [def boolForKey: @"accel"];
    }
    return self;
}

- (void)dealloc
{
    [self save];
    [super dealloc];
}

- (BOOL) save {
    NSLog(@"saving settings");
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setBool: self.sound forKey: @"sound"];
    [def setBool: self.accelerometer forKey: @"accel"];
    [def synchronize];
}

@end
