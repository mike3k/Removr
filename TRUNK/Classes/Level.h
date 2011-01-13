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

@interface Level : NSObject <NSCoding> {
    NSData * _map;
    NSString * _background;
    NSInteger _index;
    NSInteger _par;
    NSString * _title;
}

#endif

@property (nonatomic, retain) NSData * map;
@property (nonatomic, retain) NSString * background;
@property (nonatomic, retain) NSString * title;
@property (assign) NSInteger index;
@property (assign) NSInteger par;

- (id)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)encoder;

- (NSData*)data;

+ (Level*)levelFromData: (NSData*)data;

- (NSInteger)pointValue: (int)moves;

@end



