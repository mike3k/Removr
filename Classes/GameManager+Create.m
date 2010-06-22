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
        StuffPiece(1,1,RedSquare),
        StuffPiece(2,1,GreenSquare),
        StuffPiece(3,1,BlueSquare),
        StuffPiece(1,2,RedCircle),
        StuffPiece(2,2,GreenCircle),
        StuffPiece(3,2,BlueCircle),
        
        StuffPiece(4,4,RedHorizBar),
        StuffPiece(4,5,GreenHorizBar),
        StuffPiece(4,6,BlueHorizBar),
        
        StuffPiece(8,6,RedVertBar),
        StuffPiece(7,6,GreenVertBar),
        StuffPiece(5,6,BlueVertBar),
        
        0L
    },
    {
        StuffPiece(1,5,BlueHorizBar),
        StuffPiece(5,5,BlueHorizBar),
        StuffPiece(7,7,RedSquare),
        StuffPiece(8,7,RedSquare),
        StuffPiece(7,8,GreenSquare),
        StuffPiece(8,8,GreenSquare),
        StuffPiece(3,6,RedCircle),
        StuffPiece(5,6,GreenCircle),
        0L
    },

    {
        StuffPiece(2,4,BlueVertBar),
        StuffPiece(3,4,RedSquare),
        StuffPiece(3,5,RedSquare),
        StuffPiece(3,6,RedSquare),
        StuffPiece(3,7,RedSquare),
        StuffPiece(3,8,GreenCircle),
        StuffPiece(3,3,BlueSquare),
        0L
    },

    {
        StuffPiece(5,3,BlueVertBar),
        StuffPiece(7,7,RedSquare),
        StuffPiece(8,7,RedSquare),
        StuffPiece(7,8,GreenSquare),
        StuffPiece(8,8,GreenSquare),
        StuffPiece(3,8,RedCircle),
        StuffPiece(5,8,GreenSquare),
        0L
   },

    {
        //StuffPiece(5,2,OpenBlueSquare),
        StuffPiece(5,3,BlueVertBar),
        //StuffPiece(5,4,OpenBlueSquare),
        //StuffPiece(5,5,OpenBlueSquare),
        //StuffPiece(5,6,OpenBlueSquare),
        StuffPiece(5,7,RedCircle),
        StuffPiece(6,3,GreenCircle),
        StuffPiece(6,2,BlueSquare),
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
