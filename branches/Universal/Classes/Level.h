//
//  Level.h
//  Removr
//
//  Created by Mike Cohen on 6/18/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#ifdef USE_CORE_DATA

#import <CoreData/CoreData.h>

@interface Level :  NSManagedObject  
{
}

#else

#import <sqlite3.h>

@interface Level : NSObject <NSCoding> {
    NSData * _map;
    NSString * _background;
    NSInteger _index;
    NSInteger _par;
    NSString * _title;
    double _timeLimit;
    NSString *_achievement;
    NSInteger _flags;
}

#endif

@property (nonatomic, retain) NSData * map;
@property (nonatomic, retain) NSString * background;
@property (nonatomic, retain) NSString * title;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSInteger par;
@property (assign, nonatomic) double timeLimit;
@property (retain, nonatomic) NSString *achievement;
@property (assign, nonatomic) NSInteger flags;

- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)encoder;

- (NSData*)data;

+ (Level*)levelFromData: (NSData*)data;

- (NSInteger)pointValue: (int)moves;

- (id)initWithQueryResult: (sqlite3_stmt*)query;

+ (Level*)levelFromQueryResult: (sqlite3_stmt*)query;

// Level Flags

#define TimeLimitAchievement    0x0001
#define MoveNumberAchievement   0x0002
#define NoRetriesAchievement    0x0004

@end



