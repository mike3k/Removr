//
//  AppSettings.h
//  Removr
//
//  Created by Mike Cohen on 6/26/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import <Foundation/Foundation.h>

// utility functions
NSString *format_time(NSTimeInterval tm);

@interface AppSettings : NSObject {
    NSInteger _version;
    NSDate  *_last_check;
    
    BOOL _accelerometer;
    BOOL _sound;
    BOOL _nightmode;

    NSInteger _lastLevel;
    NSInteger _highestLevel;
    
    NSMutableData *_levelStatus;
    NSMutableData *_levelTimes;
    
    CGFloat _scale;
}

@property (assign,nonatomic) BOOL accelerometer;
@property (assign,nonatomic) BOOL sound;
@property (assign,nonatomic) BOOL nightmode;

@property (assign,nonatomic) NSInteger version;

@property (retain,nonatomic) NSDate *last_check;
@property (retain,nonatomic) NSMutableData* levelStatus;
@property (retain,nonatomic) NSMutableData* levelTimes;

@property (assign,nonatomic) NSInteger lastLevel;
@property (assign,nonatomic) NSInteger highestLevel;

// just for convenience
@property (assign,nonatomic) CGFloat scale;

+ (AppSettings*)shared;

- (id)init;
- (BOOL)save;

@end
