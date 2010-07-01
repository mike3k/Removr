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
@synthesize levelStatus = _levelStatus;

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
        self.lastLevel = [def integerForKey:@"lastLevel"];
        self.levelStatus = [[[def dataForKey:@"levelStatus"] mutableCopy] autorelease];
        if (nil == _levelStatus) {
            self.levelStatus = [NSMutableData dataWithLength:(100*sizeof(NSInteger*))];
        }
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
    [def setInteger:self.lastLevel forKey:@"lastLevel"];
    [def setObject:self.levelStatus forKey:@"levelStatus"];
    
    [def synchronize];
    return YES;
}

@end
