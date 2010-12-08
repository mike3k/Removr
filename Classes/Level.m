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

- (id)init
{
    self = [super init];

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
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_map forKey:@"m"];
    [encoder encodeObject:_background forKey:@"b"];
    [encoder encodeInteger:_index forKey:@"i"];
    [encoder encodeInteger:_par forKey:@"p"];
    [encoder encodeObject:_title forKey:@"t"];
}

- (void)dealloc
{
    self.map = nil;
    self.background = nil;
    self.title = nil;
    [super dealloc];
}

- (NSInteger)pointValue: (int)moves
{
    NSInteger pt;

    if (_par > 0) {
        pt = (2*_par) - moves;
    }
    else {
        pt = 10-(2*moves);
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

#endif

@end
