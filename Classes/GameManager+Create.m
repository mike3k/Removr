//
//  GameManager+Create.m
//  Removr
//
//  Created by Mike Cohen on 6/19/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "GameManager.h"
#import "SpriteDefs.h"

@interface GameManager (Create)

- (BOOL) createDatabase;

@end

#define NUM_LEVELS 4

static UInt32 levels[4][16] = {
    {
        StuffPiece(1,5,BlueHBarx4),
        StuffPiece(5,5,BlueHBarx1),
        StuffPiece(7,7,OpenRedSquare),
        StuffPiece(8,7,OpenRedSquare),
        StuffPiece(7,8,OpenGreenSquare),
        StuffPiece(8,8,OpenGreenSquare),
        StuffPiece(3,6,SolidRedCircle),
        StuffPiece(5,6,SolidGreenSquare),
        0L
    },

    {
        StuffPiece(2,4,BlueVBarx4),
        StuffPiece(3,4,OpenRedSquare),
        StuffPiece(3,5,OpenRedSquare),
        StuffPiece(3,6,OpenRedSquare),
        StuffPiece(3,7,OpenRedSquare),
        StuffPiece(3,8,SolidGreenCircle),
        StuffPiece(3,3,OpenBlueSquare),
        0L
    },

    {
        StuffPiece(5,3,BlueVBarx4),
        StuffPiece(7,7,OpenRedSquare),
        StuffPiece(8,7,OpenRedSquare),
        StuffPiece(7,8,OpenGreenSquare),
        StuffPiece(8,8,OpenGreenSquare),
        StuffPiece(3,8,SolidRedCircle),
        StuffPiece(5,8,SolidGreenSquare),
        0L
   },

    {
        //StuffPiece(5,2,OpenBlueSquare),
        StuffPiece(5,3,BlueVBarx4),
        //StuffPiece(5,4,OpenBlueSquare),
        //StuffPiece(5,5,OpenBlueSquare),
        //StuffPiece(5,6,OpenBlueSquare),
        StuffPiece(5,7,SolidRedSquare),
        StuffPiece(6,3,SolidGreenSquare),
        StuffPiece(6,2,OpenBlueSquare),
        0L
    }
};


@implementation GameManager (Create)

- (BOOL) createDatabase
{
    sqlite3_stmt *stmt;
    sqlite3_open([_dbpath UTF8String] , &db);
    sqlite3_prepare(db, "CREATE TABLE levels (ix integer NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,background text,map blob NOT NULL)", -1, &stmt, NULL);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    sqlite3_prepare(db, "INSERT INTO levels (ix,background,map) VALUES (?,?,?)", -1, &stmt, NULL);
    for (int i=0;i<NUM_LEVELS;++i) {
        int len = sizeof(levels[i]);
        sqlite3_bind_int(stmt, 1, i);
        sqlite3_bind_text(stmt, 2, "background.png", strlen("background.png"), SQLITE_STATIC);
        sqlite3_bind_blob(stmt, 3, &levels[i][0], len, SQLITE_STATIC);
        sqlite3_step(stmt);
        sqlite3_reset(stmt);
    }
    sqlite3_finalize(stmt);
    return YES;
}

@end
