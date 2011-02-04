// 
//  Level.m
//  Removr
//
//  Created by Mike Cohen on 6/18/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "Level.h"


@implementation Level 
#ifdef USE_CORE_DATA

@dynamic map;
@dynamic background;
@dynamic index;
#else
@synthesize map = _map, background = _background, index = _index, par = _par, title = _title;
@synthesize timeLimit = _timeLimit, achievement = _achievement, flags = _flags;

- (id)init
{
    self = [super init];

    return self;
}

- (id)initWithQueryResult: (sqlite3_stmt*)query
{
    if ((self = [super init])) {
        char *str;
        void *blob;
        int nbytes;

        self.index = sqlite3_column_int(query, 0);
        
        str = (char*)sqlite3_column_text(query, 1);
        if ((nil != str) && str[0]) {
            self.background = [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
        }
        else {
            self.background = nil;
        }
        
        blob = (void*)sqlite3_column_blob(query,2);
        nbytes = sqlite3_column_bytes(query,2);
        if (blob && (nbytes > 0)) {
            self.map = [NSData dataWithBytes:blob length:nbytes];
        }
        
        str = (char*)sqlite3_column_text(query, 3);
        if (nil != str) {
            self.title = [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
        }
        
        self.par = sqlite3_column_int(query, 4);
        
        self.timeLimit = sqlite3_column_double(query, 5);

        str = (char*)sqlite3_column_text(query, 6);
        if (nil != str) {
            self.achievement = [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
        }
        
        self.flags = sqlite3_column_int(query, 7);
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.map = [aDecoder decodeObjectForKey:@"m"];
    self.background = [aDecoder decodeObjectForKey:@"b"];
    self.index = [aDecoder decodeIntegerForKey:@"i"];
    self.par = [aDecoder decodeIntegerForKey:@"p"];
    self.title = [aDecoder decodeObjectForKey:@"t"];
    self.timeLimit = [aDecoder decodeDoubleForKey:@"l"];
    self.achievement = [aDecoder decodeObjectForKey:@"a"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_map forKey:@"m"];
    [encoder encodeObject:_background forKey:@"b"];
    [encoder encodeInteger:_index forKey:@"i"];
    [encoder encodeInteger:_par forKey:@"p"];
    [encoder encodeObject:_title forKey:@"t"];
    [encoder encodeDouble:_timeLimit forKey:@"l"];
    [encoder encodeObject:_achievement forKey:@"a"];
}

- (void)dealloc
{
    self.map = nil;
    self.background = nil;
    self.title = nil;
    self.achievement = nil;
    [super dealloc];
}

- (NSInteger)pointValue: (int)moves
{
    NSInteger pt;

    if (_par > 0) {
        pt = ((_par - moves)+(_par/2)) * 2;
    }
    else {
        pt = 6-(2*moves);
    }
    
    return (pt > 0) ? pt : 1;
}


- (NSData*)data
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

+ (Level*)levelFromData: (NSData*)data
{
    return (Level*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (Level*)levelFromQueryResult: (sqlite3_stmt*)query
{
    return [[[Level alloc] initWithQueryResult:query] autorelease];
}

#endif

@end
