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

@interface Level : NSObject {
    NSData * _map;
    NSString * _background;
    NSNumber * _index;
}

#endif

@property (nonatomic, retain) NSData * map;
@property (nonatomic, retain) NSString * background;
@property (nonatomic, retain) NSNumber * index;

@end



