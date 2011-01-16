//
//  AppSettings.m
//  Removr
//
//  Created by Mike Cohen on 6/26/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "AppSettings.h"

static AppSettings *theSettings = nil;

NSString *format_time(NSTimeInterval tm)
{
    long _time = floor(tm);
    return [NSString stringWithFormat: @"%02d:%02d", /*(_time / 3600),*/ (_time / 60), _time % 60 ];
}

@implementation AppSettings

@synthesize sound = _sound;
@synthesize accelerometer = _accelerometer;
@synthesize nightmode = _nightmode;
@synthesize lastLevel = _lastLevel;
@synthesize highestLevel = _highestLevel;
@synthesize levelStatus = _levelStatus;
@synthesize levelTimes = _levelTimes;
@synthesize version = _version;
@synthesize last_check = _last_check;
//@synthesize scale = _scale;
@synthesize totalPoints = _totalPoints;

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
            self.nightmode = NO;
            self.lastLevel = 0;
            self.highestLevel = 0;
            self.totalPoints = 0;
            _levelStatus = nil;
            _levelTimes = nil;
        }
        else {
            self.sound = [def boolForKey: @"sound"];
            self.accelerometer = [def boolForKey: @"accel"];
            self.nightmode = [def boolForKey: @"nightmode"];
            self.lastLevel = [def integerForKey:@"lastLevel"];
            self.levelStatus = [[[def dataForKey:@"levelStatus"] mutableCopy] autorelease];
            self.levelTimes = [[[def dataForKey:@"levelTimes"] mutableCopy] autorelease];
            self.highestLevel = [def integerForKey:@"highestLevel"];
            self.last_check = [def objectForKey:@"lastUpdate"];
            self.totalPoints = [def integerForKey:@"totalPoints"];
        }
        if (nil == _levelStatus) {
            self.levelStatus = [NSMutableData dataWithLength:(100*sizeof(NSInteger*))];
        }
        if (nil == _levelTimes) {
            self.levelTimes = [NSMutableData dataWithLength:(100*sizeof(NSTimeInterval))];
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
    [def setBool: self.nightmode forKey: @"nightmode"];
    [def setInteger:self.lastLevel forKey:@"lastLevel"];
    [def setObject:self.levelStatus forKey:@"levelStatus"];
    [def setObject:self.levelTimes forKey:@"levelTimes"];
    [def setObject:self.last_check forKey:@"lastUpdate"];
    [def setInteger:self.highestLevel forKey:@"highestLevel"];
    [def setInteger:self.totalPoints forKey:@"totalPoints"];
    return YES;
}

@end
