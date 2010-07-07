//
//  EditView.m
//  LevelEditor
//
//  Created by Mike Cohen on 7/4/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "EditView.h"
#import "SpriteDefs.h"
#include <stdio.h>
#include <sqlite3.h>

@implementation EditView

@synthesize currentPiece;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        currentPiece = RedCircle;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
    NSGraphicsContext* aContext = [NSGraphicsContext currentContext];
    [aContext saveGraphicsState];
    NSRect box;
    
//    [[NSColor redColor] setFill];
//    NSFrameRect([self bounds]);

    for (int i=0;i<MAPWIDTH;++i) {
        for (int j=0;j<MAPHEIGHT;++j) {
            int piece = map[i][j];
            if (0 != piece) {
                switch (piece) {
                    case RedCircle:
                    case RedSquare:
                    case RedHorizBar64:
                    case RedVertBar64:
                    case RedHorizBar128:
                    case RedVertBar128:
                        [[NSColor redColor] setFill];
                        break;
                    case GreenCircle:
                    case GreenSquare:
                    case GreenHorizBar64:
                    case GreenHorizBar128:
                    case GreenVertBar64:
                    case GreenVertBar128:
                        [[NSColor greenColor] setFill];
                        break;
                    case BlueCircle:
                    case BlueSquare:
                    case BlueHorizBar64:
                    case BlueVertBar64:
                    case BlueHorizBar128:
                    case BlueVertBar128:
                        [[NSColor blueColor] setFill];
                        break;
                };
                switch (piece) {
                    case RedSquare:
                    case BlueSquare:
                    case GreenSquare:
                        box = NSMakeRect(i*16, j*16, 32.0, 32.0);
                        NSRectFill(box);
                        [NSBezierPath strokeRect:box];
                        break;
                    case RedCircle:
                    case BlueCircle:
                    case GreenCircle:
                        box = NSMakeRect(i*16, j*16, 32.0, 32.0);
                        NSBezierPath *circle = [NSBezierPath bezierPath];
                        [circle appendBezierPathWithOvalInRect:box];
                        [circle fill];
                        [circle stroke];
                        break;
                    case RedHorizBar64:
                    case GreenHorizBar64:
                    case BlueHorizBar64:
                        box = NSMakeRect(i*16, j*16, 64.0, 16.0);
                        NSRectFill(box);
                        [NSBezierPath strokeRect:box];
                        break;
                    case RedVertBar64:
                    case GreenVertBar64:
                    case BlueVertBar64:
                        box = NSMakeRect(i*16, j*16, 16.0, 64.0);
                        NSRectFill(box);
                        [NSBezierPath strokeRect:box];
                        break;
                    case RedHorizBar128:
                    case GreenHorizBar128:
                    case BlueHorizBar128:
                        box = NSMakeRect(i*16, j*16, 128.0, 16.0);
                        NSRectFill(box);
                        [NSBezierPath strokeRect:box];
                        break;
                    case RedVertBar128:
                    case GreenVertBar128:
                    case BlueVertBar128:
                        box = NSMakeRect(i*16, j*16, 16.0, 128.0);
                        NSRectFill(box);
                        [NSBezierPath strokeRect:box];
                        break;
                    default:
                        break;
                }
            }
        }
    }
    [aContext restoreGraphicsState];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    NSPoint eventLocation = [theEvent locationInWindow];
    NSPoint pt = [self convertPoint:eventLocation fromView:nil];

//    NSLog(@"mouseDown @(%f,%f)",pt.x, pt.y);
    
    int X = pt.x / 16;   //([self bounds].size.width - eventLocation.x) / 16;
    int Y = pt.y / 16;   //([self bounds].size.height - eventLocation.y) / 16;
    
    NSLog(@"Point: %d, %d",X,Y);
    if ([theEvent modifierFlags] & NSAlternateKeyMask) {
        map[X][Y] = 0;
    }
    else {
        map[X][Y] = currentPiece;
    }
    [self setNeedsDisplay:YES];
}

- (IBAction)clearMap:(id)sender
{
    memset(&map[0][0],0,MAPWIDTH*MAPHEIGHT*sizeof(UInt32));
    [self setNeedsDisplay:YES];
}

- (NSData*)encodeMap
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
    word = 0L;
    [coded appendBytes:&word length:sizeof(word)];
    
    return coded;
}

- (void)decodeMap:(NSData*)coded
{
    UInt32* bytes = (UInt32*)[coded bytes];
    UInt32 piece;
    int count = [coded length] / sizeof(UInt32);

    [self clearMap:self];
    for (int i=0;i<count;++i) {
        if (0 != (piece = bytes[i])) {
            int x = MapXValue(piece), y = MapYValue(piece);
            map[x][y] = MapPieceValue(piece);
        }
    }
}

- (IBAction)choose: (id)sender
{
    self.currentPiece = [sender tag];
    NSLog(@"selected %d",currentPiece);
}

- (IBAction)save:(id)sender
{
    NSString *txt = [self dumpText];
    NSLog(txt);

    NSString *sql = [self sqlText];
    
    NSString *home = NSHomeDirectory();
    NSString *dbpath = [[home stringByAppendingPathComponent: @"Desktop"] stringByAppendingPathComponent:@"levels.sql"];
    FILE *out = fopen([dbpath fileSystemRepresentation], "a");
    fprintf(out, [sql UTF8String]);
    fprintf(out, "\n");
    fclose(out);
}

- (IBAction)load:(id)sender
{
}

- (NSString*)sqlText
{
    NSMutableString *result = [NSMutableString stringWithFormat:@"INSERT INTO levels (background,map) VALUES ('background.png',X'"];
    NSData *encoded = [self encodeMap];
    char *bytes = (char*)[encoded bytes];
    int len = [encoded length];
    for (int i=0;i<len;++i) {
        [result appendFormat:@"%02X",bytes[i]];
    }
    [result appendFormat:@"');"];
    return result;
}


- (NSString*)dumpText
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

static sqlite3 * db;
static sqlite3_stmt * stmt;


- (void)dumpsql
{
    int result;
    if (nil == db) {
        NSString *home = NSHomeDirectory();
        NSString *dbpath = [[home stringByAppendingPathComponent: @"Desktop"] stringByAppendingPathComponent:@"maps.db"];
        printf("Creating database...\n");
        result = sqlite3_open([dbpath fileSystemRepresentation] , &db);
        result = sqlite3_prepare(db, "CREATE TABLE levels (ix integer NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,background text,map blob NOT NULL,name text,par integer)", -1, &stmt, NULL);
        result = sqlite3_step(stmt);
        result = sqlite3_finalize(stmt);
        result = sqlite3_prepare(db, "INSERT INTO levels (background,map,par) VALUES ('background.png',?,0)", -1, &stmt, NULL);
    }
    NSData *coded = [self encodeMap];
    printf("writing to database\n");
    result = sqlite3_bind_blob(stmt, 1, [coded bytes], [coded length], SQLITE_STATIC);
    result = sqlite3_step(stmt);
    result = sqlite3_reset(stmt);
}

- (void)dealloc
{
    printf("dealloc\n");
    if (nil != db) {
        printf("closing database\n");
        sqlite3_finalize(stmt);
        sqlite3_close(db);
    }
    [super dealloc];
}

@end
