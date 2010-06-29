#include <stdio.h>
#include <sqlite3.h>

typedef unsigned long UInt32;

#include "../Classes/SpriteDefs.h"

#define NUM_LEVELS 4

static char *backgrounds[NUM_LEVELS] = {
    "Lvl1Background.png",
    "Lvl2Background.png",
    "Lvl3Background.png",
    "background.png",
};

static UInt32 levels[NUM_LEVELS][16] = {
    {
        StuffPiece(13,10,RedSquare),             //Red @ 13,10
        StuffPiece(15,10,RedSquare),             //Red @ 15,10
        StuffPiece(17,10,RedSquare),             //Red @ 17,10
        StuffPiece(13,12,GreenSquare),           //Green @ 13,12
        StuffPiece(15,12,GreenSquare),           //Green @ 15,12
        StuffPiece(17,12,GreenSquare),

        
        0L
    },
    {
        StuffPiece(13,10,RedSquare),
        StuffPiece(15,10,RedSquare),
        StuffPiece(17,10,GreenSquare),
        StuffPiece(19,10,GreenSquare),
        
        StuffPiece(13,12,RedCircle),
        StuffPiece(15,12,RedCircle),
        StuffPiece(17,12,GreenCircle),
        StuffPiece(19,12,GreenCircle),

        0L
    },
    {
        StuffPiece(9,10,RedCircle),
        StuffPiece(6,9,BlueHorizBar128),
        StuffPiece(22,8,GreenCircle),
        StuffPiece(6,5,RedCircle),
        StuffPiece(12,5,RedCircle),
        StuffPiece(19,7,BlueHorizBar128),
        StuffPiece(19,5,GreenSquare),
        StuffPiece(3,4,BlueHorizBar256),
        StuffPiece(19,4,BlueHorizBar128),
        
        0L
    },
    {
        StuffPiece(11,13,RedSquare),        // red sq @ 11,13
        StuffPiece(13,13,RedCircle),        // Red ball @ 13,13
        StuffPiece(17,13,GreenCircle),      // gr ball @ 17,13
        StuffPiece(19,13,RedSquare),        // red sq @ 19,13
        StuffPiece(11,11,GreenSquare),      // green sq @ 11,11
        StuffPiece(13,11,BlueSquare),       // blue sq @ 13.11
        StuffPiece(17,11,BlueSquare),       // blue sq @ 17,11
        StuffPiece(19,11,GreenSquare),      // green sq @ 19,11
        StuffPiece(15,9,RedSquare),         // red sq @ 15,9

        0L
    },
};

sqlite3 * db;
sqlite3_stmt * query;

int main (int argc, const char * argv[]) {
    sqlite3_stmt *stmt;
    printf("Creating database...\n");
    sqlite3_open("/tmp/levels.sqlite3" , &db);
    sqlite3_prepare(db, "CREATE TABLE levels (ix integer NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,background text,map blob NOT NULL)", -1, &stmt, NULL);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    sqlite3_prepare(db, "INSERT INTO levels (ix,background,map) VALUES (?,?,?)", -1, &stmt, NULL);
    for (int i=0;i<NUM_LEVELS;++i) {
        int len = sizeof(levels[i]);
        char *bg = backgrounds[i];
        if (0L == bg) {
            bg = "background.png";
        }
        sqlite3_bind_int(stmt, 1, i);
        sqlite3_bind_text(stmt, 2, bg, strlen(bg), SQLITE_STATIC);
        sqlite3_bind_blob(stmt, 3, &levels[i][0], len, SQLITE_STATIC);
        sqlite3_step(stmt);
        printf("Inserted level %d\n",i);
        sqlite3_reset(stmt);
    }
    sqlite3_finalize(stmt);
    sqlite3_close(db);
    printf("finished.\n");

    return 0;
}
