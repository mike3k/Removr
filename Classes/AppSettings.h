//
//  AppSettings.h
//  Removr
//
//  Created by Mike Cohen on 6/26/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppSettings : NSObject {
    NSInteger _version;
    NSDate  *_last_check;
    
    BOOL _accelerometer;
    BOOL _sound;

    NSInteger _lastLevel;
    
    NSMutableData *_levelStatus;
}

@property (assign,nonatomic) BOOL accelerometer;
@property (assign,nonatomic) BOOL sound;

@property (assign,nonatomic) NSInteger version;

@property (retain,nonatomic) NSDate *last_check;

@property (assign,nonatomic) NSInteger lastLevel;
@property (retain,nonatomic) NSMutableData* levelStatus;

+ (AppSettings*)shared;

- (id)init;
- (BOOL)save;

@end
