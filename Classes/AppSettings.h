//
//  AppSettings.h
//  Removr
//
//  Created by Mike Cohen on 6/26/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppSettings : NSObject {
    BOOL _accelerometer;
    BOOL _sound;

    NSInteger _lastLevel;
}

@property (assign,nonatomic) BOOL accelerometer;
@property (assign,nonatomic) BOOL sound;

@property (assign,nonatomic) NSInteger lastLevel;

+ (AppSettings*)shared;

- (id)init;
- (BOOL)save;

@end
