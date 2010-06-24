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

#define NUM_LEVELS 5

static UInt32 levels[NUM_LEVELS][16] = {
    {
       StuffPiece(13,10,RedSquare),             //Red @ 13,10
       StuffPiece(15,10,RedSquare),             //Red @ 15,10
       StuffPiece(17,10,RedSquare),             //Red @ 17,10
       StuffPiece(15,12,GreenSquare),           //Green @ 15,12
       StuffPiece(15,14,GreenSquare),           //Green @ 15,12

       StuffPiece(3,18,BlueHorizBar256),        //BHBar256 @ 3,18
       StuffPiece(3,16,BlueHorizBar128),        //BHBar128 @ 3,16
       StuffPiece(29,3,BlueVertBar256),         //BVBar256 @ 29,18
       StuffPiece(27,11,BlueVertBar128),        //BVBar128 @ 27,18
        
        0L
    },
    {
        StuffPiece(2,10,BlueHorizBar64),
        StuffPiece(12,10,BlueHorizBar256),
        StuffPiece(14,14,RedSquare),
        StuffPiece(16,14,RedSquare),
        StuffPiece(14,16,GreenSquare),
        StuffPiece(16,16,GreenSquare),
        StuffPiece(6,12,RedCircle),
        StuffPiece(10,12,GreenCircle),
        0L
    },

    {
        StuffPiece(2,4,BlueVertBar64),
        StuffPiece(3,4,RedSquare),
        StuffPiece(3,6,RedSquare),
        StuffPiece(3,8,RedSquare),
        StuffPiece(3,10,RedSquare),
        StuffPiece(3,12,GreenCircle),
        StuffPiece(3,2,BlueSquare),
        0L
    },

    {
        StuffPiece(5,3,BlueVertBar64),
        StuffPiece(7,7,RedSquare),
        StuffPiece(9,7,RedSquare),
        StuffPiece(7,9,GreenSquare),
        StuffPiece(9,9,GreenSquare),
        StuffPiece(3,8,RedCircle),
        StuffPiece(5,8,GreenSquare),
        0L
   },

    {
        StuffPiece(5,3,BlueVertBar64),
        StuffPiece(5,7,RedCircle),
        StuffPiece(7,3,GreenCircle),
        StuffPiece(7,1,BlueSquare),
        0L
    }
};


@implementation GameManager (Create)

- (BOOL) createDatabase
{
    sqlite3_stmt *stmt;
    sqlite3_open("/tmp/levels.sqlite3" , &db);
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
    sqlite3_close(db);
    return YES;
}

@end
