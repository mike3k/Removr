//
//  Level.h
//  LevelEditor
//
//  Created by Mike Cohen on 7/10/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Level : NSObject {
    NSInteger rowid;
    NSString * name;
    NSData * map;
    NSInteger par;
    
    BOOL    dirty;
}

@property (assign) NSInteger rowid;
@property (retain,nonatomic) NSString * name;
@property (retain,nonatomic) NSData * map;
@property (assign) BOOL dirty;
@property (assign) NSInteger par;

@end
