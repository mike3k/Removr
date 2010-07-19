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
@synthesize lastLevel = _lastLevel;
@synthesize highestLevel = _highestLevel;
@synthesize levelStatus = _levelStatus;
@synthesize version = _version;
@synthesize last_check = _last_check;
@synthesize scale = _scale;

+ (AppSettings*)shared {
    if (nil == theSettings) {
        theSettings = [[AppSettings alloc] init];
    }
    return theSettings;
}

- (id) init {
    if ((self = [super init])) {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        self.version = [def integerForKey:@"version"];
        if (0 == self.version) {
            self.version = 1;
            self.sound = YES;
            self.accelerometer = YES;
            self.lastLevel = 0;
            self.highestLevel = 0;
            _levelStatus = nil;
        }
        else {
            self.sound = [def boolForKey: @"sound"];
            self.accelerometer = [def boolForKey: @"accel"];
            self.lastLevel = [def integerForKey:@"lastLevel"];
            self.levelStatus = [[[def dataForKey:@"levelStatus"] mutableCopy] autorelease];
            self.highestLevel = [def integerForKey:@"highestLevel"];
            self.last_check = [def objectForKey:@"lastUpdate"];
        }
        if (nil == _levelStatus) {
            self.levelStatus = [NSMutableData dataWithLength:(100*sizeof(NSInteger*))];
        }
        self.scale = [[UIScreen mainScreen] scale];
        // 2x scaling only works in iOS4 or newer
        if ((_scale > 1) 
            && ( [[[UIDevice currentDevice] systemVersion] compare:@"4.0" options:NSNumericSearch] == NSOrderedAscending)) {
            self.scale = 1;
        }
    }
    return self;
}

- (void)dealloc
{
    [self save];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super dealloc];
}

- (BOOL) save {
#ifndef NDEBUG
    NSLog(@"saving settings");
#endif
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setInteger:self.version forKey:@"version"];
    [def setBool: self.sound forKey: @"sound"];
    [def setBool: self.accelerometer forKey: @"accel"];
    [def setInteger:self.lastLevel forKey:@"lastLevel"];
    [def setObject:self.levelStatus forKey:@"levelStatus"];
    [def setObject:self.last_check forKey:@"lastUpdate"];
    [def setInteger:self.highestLevel forKey:@"highestLevel"];
    return YES;
}

@end
