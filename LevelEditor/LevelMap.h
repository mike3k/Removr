//
//  LevelMap.h
//  LevelEditor
//
//  Created by Mike Cohen on 7/9/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define MAPWIDTH    30
#define MAPHEIGHT   19

@interface LevelMap : NSObject {
    UInt32 map[MAPWIDTH][MAPHEIGHT];
    
    BOOL dirty;

}

- (void)setPiece: (UInt32)piece X: (int)x Y: (int)y;
- (UInt32)getPieceX: (int)x Y: (int)y;

- (void)clear;
- (void)loadblob: (UInt32*)blob count: (int)count;
- (void)load: (NSData*)data;
- (NSData*)encode;

- (NSString*)generateSource;
- (NSString*)generateHex;

@property (readonly) NSInteger MapWidth;
@property (readonly) NSInteger MapHeight;
@property (assign) BOOL dirty;

@end
