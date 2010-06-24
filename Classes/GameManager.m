//
//  LevelManager.m
//  Blocks
//
//  Created by Mike Cohen on 4/30/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "GameManager.h"
#import "SpriteDefs.h"
#import "GameScene.h"
#import "MenuScene.h"
#import "OptionScene.h"
#import "InfoScene.h"
#import "HighscoreScene.h"



static GameManager *_sharedGameManager = nil;

@implementation GameManager

@synthesize curLevel = _curLevel, theLevel = _theLevel, gs = _gs, ms = _ms, paused = _paused, dbpath = _dbpath;

#ifdef USE_CORE_DATA
@synthesize managedObjectContext = _managedObjectContext;
#endif

+ (GameManager*)shared
{
    if (nil == _sharedGameManager) {
        _sharedGameManager = [[GameManager alloc] init];
    }
    return _sharedGameManager;
}

- (id) init
{
    if ((self = [super init])) {
        self.curLevel = 0;
        db = nil;

        self.dbpath = [[NSBundle mainBundle] pathForResource:@"levels" ofType:@"sqlite3"];

    }
    return self;
}

- (void)dealloc
{
    if (nil != query) {
        sqlite3_finalize(query);
    }
    if (nil != db) {
        sqlite3_close(db);
    }

    self.theLevel = nil;
    self.gs = nil;
    self.ms = nil;
    [super dealloc];
}




- (Level*)GetLevel: (int)number
{
    // if we're restarting the current level, use the saved copy
    if ((number == _curLevel) && (_theLevel != nil)) {
        return _theLevel;
    }
    // open the database & prepare the query here the first time we use it instead of init
    if (nil == db) {
        sqlite3_open([self.dbpath UTF8String] , &db);
        sqlite3_prepare_v2(db, "SELECT * FROM levels WHERE ix=?", -1, &query, NULL);
    }
    Level *lvl = nil;
    self.curLevel = number;
    // request a record for the level
    sqlite3_bind_int(query, 1, number);
    if (sqlite3_step(query) == SQLITE_ROW) {
        void *blob;
        int nbytes;
        lvl = [[Level alloc] init];
        lvl.index = [NSNumber numberWithInt: sqlite3_column_int(query, 0)];
        lvl.background = [NSString stringWithCString:(char*)sqlite3_column_text(query, 1) encoding:NSUTF8StringEncoding];
        blob = (void*)sqlite3_column_blob(query,2);
        nbytes = sqlite3_column_bytes(query,2);
        if (blob && (nbytes > 0)) {
            lvl.map = [NSData dataWithBytes:blob length:nbytes];
        }
        self.theLevel = lvl;
    }
    else self.theLevel = nil;
    sqlite3_reset(query);
    return [lvl autorelease];
}

- (int)levelCount
{
    //return [_levels count];
    // TODO: Count rows in database
    return 100;
}



- (void)play:(id)sender
{
    if (nil == _gs) {
        self.gs = [GameScene node];
    }
    [[CCDirector sharedDirector] replaceScene: _gs];

    [_gs play:self];

}

- (void)highscores:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[HighscoreScene node]];
}

- (void)options:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[OptionScene node]];
}

- (void)info:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[InfoScene node]];
}

- (void)menu: (id)sender
{
    if (nil == _ms) {
        self.ms = [MenuScene node];
    }
    [[CCDirector sharedDirector] replaceScene: _ms];
}

- (void)pause: (id)sender
{
}

- (void)resume: (id)sender
{
}

@end
