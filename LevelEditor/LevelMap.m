//
//  LevelMap.m
//  LevelEditor
//
//  Created by Mike Cohen on 7/9/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "LevelMap.h"
#import "SpriteDefs.h"

@implementation LevelMap

// Properties

@synthesize dirty;

- (UInt32)MapWidth  { return MAPWIDTH; }
- (UInt32)MapHeight { return MAPHEIGHT; }

// Access

- (void)setPiece: (UInt32)piece X: (int)x Y: (int)y
{
    map[x][y] = piece;
    dirty = YES;
}

- (UInt32)getPieceX: (int)x Y: (int)y
{
    return map[x][y];
}

// load & save

- (void)clear
{
    memset(&map[0][0],0,MAPWIDTH*MAPHEIGHT*sizeof(UInt32));
    dirty = NO;
}

- (void)loadblob: (UInt32*)blob count: (int)count
{
    UInt32 piece;
    [self clear];
    for (int i=0;i<count;++i) {
        if (0 != (piece = blob[i])) {
            int x = MapXValue(piece), y = MapYValue(piece);
            map[x][y] = MapPieceValue(piece);
        }
    }
}

- (void)load: (NSData*)data
{
    [self loadblob:(UInt32*)[data bytes] count:  [data length] / sizeof(UInt32)];
}

- (NSData*)encode
{
    UInt32 word,piece;
    NSMutableData *coded = [NSMutableData data];

    for (int i=0;i<MAPWIDTH;++i) {
        for (int j=0;j<MAPHEIGHT;++j) {
            if (0 != (piece = map[i][j])) {
                word = StuffPiece(i,j,piece);
                [coded appendBytes:&word length:sizeof(word)];
            }
        }
    }

    word = 0L;  // make sure we terminate it with a null word!
    [coded appendBytes:&word length:sizeof(word)];
    
    return coded;
}

- (NSString*)generateSource
{
    NSMutableString *result = [NSMutableString string];
    
    [result appendString:@"\n{\n"];
    for (int i=0;i<MAPWIDTH;++i) {
        for (int j=0;j<MAPHEIGHT;++j) {
            int piece = map[i][j];
            if (0 != piece) {
                [result appendFormat:@"\tStuffPiece(%d,%d,%d),\n",i,j,piece];
            }
        }
    }
    
    [result appendString:@"\t0L\n}\n"];
    
    return result;
}


- (NSString*)generateHex
{
    NSMutableString *result = [NSMutableString stringWithFormat:@"X'"];
    NSData *encoded = [self encode];
    char *bytes = (char*)[encoded bytes];
    int len = [encoded length];
    for (int i=0;i<len;++i) {
        [result appendFormat:@"%02X",bytes[i]];
    }
    [result appendFormat:@"');"];
    return result;
}

@end
