#include <stdio.h>
#include <sqlite3.h>

typedef unsigned long UInt32;

#include "../Classes/SpriteDefs.h"

/*
#define NUM_LEVELS 5

static char *backgrounds[NUM_LEVELS] = {
    "Lvl1Background.png",
    "Lvl2Background.png",
    "Lvl3Background.png",
    "background.png",
    "background.png"
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
    {
        StuffPiece(4,15,22),
        StuffPiece(4,16,3),
        StuffPiece(5,11,5),
        StuffPiece(5,13,1),
        StuffPiece(6,9,5),
        StuffPiece(7,7,5),
        StuffPiece(8,5,5),
        StuffPiece(9,3,5),
        
        0L
    }

};
 */

#define NUM_LEVELS  14

static UInt32 levels[NUM_LEVELS][16] = {

{       //1
	StuffPiece(11,9,20),
	StuffPiece(11,10,1),
	StuffPiece(14,10,3),
	StuffPiece(17,10,1),
	0L
},

{       //2
	StuffPiece(4,7,26),
	StuffPiece(5,6,20),
	StuffPiece(7,7,1),
	0L
},

{       //3
	StuffPiece(6,8,21),
	StuffPiece(8,9,4),
	StuffPiece(10,9,4),
	StuffPiece(15,8,23),
	StuffPiece(16,9,1),
	StuffPiece(18,8,29),
	0L
},

{       //4
	StuffPiece(4,5,20),
	StuffPiece(8,6,30),
	StuffPiece(8,10,21),
	StuffPiece(9,6,3),
	StuffPiece(10,8,1),
	StuffPiece(11,6,3),
	StuffPiece(12,5,20),
	StuffPiece(12,8,1),
	StuffPiece(13,6,3),
	StuffPiece(15,6,30),
	StuffPiece(16,6,1),
	StuffPiece(19,6,1),
	StuffPiece(20,5,20),
	StuffPiece(22,6,1),
	StuffPiece(25,6,1),
	StuffPiece(27,5,26),
	0L
},

{       //5
	StuffPiece(4,5,5),
	StuffPiece(4,7,6),
	StuffPiece(6,7,6),
	StuffPiece(7,9,2),
	StuffPiece(8,7,6),
	StuffPiece(10,5,5),
	StuffPiece(10,7,6),
	StuffPiece(10,9,1),
	StuffPiece(12,3,5),
	StuffPiece(12,5,6),
	StuffPiece(14,2,5),
	StuffPiece(14,4,6),
	StuffPiece(16,1,5),
	StuffPiece(16,3,6),
	StuffPiece(18,0,5),
	StuffPiece(18,2,6),
	StuffPiece(20,1,6),
	StuffPiece(22,0,5),
	StuffPiece(22,2,6),
	StuffPiece(24,1,5),
	StuffPiece(24,3,6),
	StuffPiece(26,2,5),
	StuffPiece(26,4,6),
	0L
},

{       //6
	StuffPiece(2,3,26),
	StuffPiece(3,3,20),
	StuffPiece(3,4,6),
	StuffPiece(5,4,3),
	StuffPiece(7,4,3),
	StuffPiece(10,4,1),
	StuffPiece(11,3,20),
	StuffPiece(14,4,6),
	StuffPiece(18,4,1),
	StuffPiece(19,3,20),
	StuffPiece(21,4,2),
	StuffPiece(23,4,3),
	StuffPiece(25,4,6),
	StuffPiece(27,3,26),
	0L
},

{       //7
	StuffPiece(1,0,24),
	StuffPiece(1,1,25),
	StuffPiece(1,9,25),
	StuffPiece(1,17,28),
	StuffPiece(3,1,2),
	StuffPiece(12,5,30),
	StuffPiece(13,5,24),
	StuffPiece(17,5,30),
	StuffPiece(25,0,24),
	StuffPiece(28,1,25),
	StuffPiece(28,9,25),
	StuffPiece(28,17,25),
	0L
},

{       //8
	StuffPiece(9,1,24),
	StuffPiece(11,2,24),
	StuffPiece(12,3,28),
	StuffPiece(13,3,23),
	StuffPiece(14,4,1),
	StuffPiece(15,2,24),
	StuffPiece(17,1,24),
	StuffPiece(17,3,28),
	0L
},

{       //9
	StuffPiece(6,2,19),
	StuffPiece(14,2,26),
	StuffPiece(14,10,27),
	StuffPiece(15,2,20),
	0L
},

{       //10
	StuffPiece(5,2,4),
	StuffPiece(7,2,4),
	StuffPiece(9,2,4),
	StuffPiece(11,2,4),
	StuffPiece(13,0,5),
	StuffPiece(13,3,1),
	StuffPiece(13,5,4),
	StuffPiece(15,2,4),
	0L
},

{       //11
	StuffPiece(11,13,1),
	StuffPiece(12,11,1),
	StuffPiece(13,1,3),
	StuffPiece(14,3,3),
	StuffPiece(14,5,3),
	StuffPiece(14,7,3),
	StuffPiece(14,9,3),
	StuffPiece(14,13,1),
	StuffPiece(15,1,3),
	StuffPiece(16,12,1),
	StuffPiece(17,15,1),
	0L
},

{       //12
	StuffPiece(8,0,20),
	StuffPiece(9,1,2),
	StuffPiece(10,3,3),
	StuffPiece(11,1,2),
	StuffPiece(11,5,1),
	StuffPiece(12,3,3),
	StuffPiece(12,7,2),
	StuffPiece(13,1,2),
	StuffPiece(13,5,2),
	StuffPiece(13,9,3),
	StuffPiece(14,3,3),
	StuffPiece(14,7,1),
	StuffPiece(14,11,1),
	StuffPiece(15,1,2),
	StuffPiece(15,5,3),
	StuffPiece(15,9,3),
	StuffPiece(15,13,2),
	StuffPiece(16,0,20),
	StuffPiece(16,3,3),
	StuffPiece(16,7,2),
	StuffPiece(16,11,1),
	StuffPiece(17,1,1),
	StuffPiece(17,5,3),
	StuffPiece(17,9,3),
	StuffPiece(18,3,2),
	StuffPiece(18,7,3),
	StuffPiece(19,1,2),
	StuffPiece(19,5,3),
	StuffPiece(20,3,3),
	StuffPiece(21,1,1),
	0L
},

{       //13
	StuffPiece(0,1,23),
	StuffPiece(0,2,4),
	StuffPiece(1,4,1),
	StuffPiece(2,2,4),
	StuffPiece(4,1,23),
	StuffPiece(4,2,4),
	StuffPiece(6,2,4),
	StuffPiece(8,1,23),
	StuffPiece(8,2,4),
	StuffPiece(9,4,27),
	StuffPiece(9,12,30),
	StuffPiece(10,2,4),
	StuffPiece(10,10,24),
	StuffPiece(10,15,24),
	StuffPiece(12,1,23),
	StuffPiece(12,2,4),
	StuffPiece(13,11,30),
	StuffPiece(14,2,4),
	StuffPiece(16,1,23),
	StuffPiece(16,2,4),
	StuffPiece(16,4,3),
	StuffPiece(18,2,4),
	StuffPiece(20,1,23),
	StuffPiece(20,2,4),
	StuffPiece(22,2,4),
	StuffPiece(24,1,23),
	StuffPiece(24,2,4),
	StuffPiece(26,2,4),
	0L
},
    
{       //14
	StuffPiece(9,4,27),
	StuffPiece(10,7,2),
	StuffPiece(10,11,24),
	StuffPiece(13,7,30),
	StuffPiece(14,9,1),
	StuffPiece(14,11,24),
	StuffPiece(17,4,27),
	0L
}
};


sqlite3 * db;
sqlite3_stmt * query;

int main (int argc, const char * argv[]) {
    sqlite3_stmt *stmt;
    printf("Creating database...\n");
    sqlite3_open("/tmp/leves.db" , &db);
    sqlite3_prepare(db, "CREATE TABLE levels (ix integer NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,background text,map blob NOT NULL,name text,par integer)", -1, &stmt, NULL);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    sqlite3_prepare(db, "INSERT INTO levels (background,map) VALUES (?,?)", -1, &stmt, NULL);
    for (int i=0;i<NUM_LEVELS;++i) {
        int len = sizeof(levels[i]);
//        char *bg = backgrounds[i];
//        if (0L == bg) {
//            bg = "background.png";
//        }
        char *bg = "background.png";
        //sqlite3_bind_int(stmt, 1, i);
        sqlite3_bind_text(stmt, 1, bg, strlen(bg), SQLITE_STATIC);
        sqlite3_bind_blob(stmt, 2, &levels[i][0], len, SQLITE_STATIC);
        sqlite3_step(stmt);
        printf("Inserted level %d\n",i);
        sqlite3_reset(stmt);
    }
    sqlite3_finalize(stmt);
    sqlite3_close(db);
    printf("finished.\n");

    return 0;
}
