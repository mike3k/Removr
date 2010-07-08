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
#import "SimpleAudioEngine.h"

#define ALLOW_DB_UPDATE


static GameManager *_sharedGameManager = nil;

@implementation GameManager

@synthesize curLevel = _curLevel, theLevel = _theLevel, gs = _gs, ms = _ms, paused = _paused, dbpath = _dbpath;
@synthesize levelStatus = _levelStatus;

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
        aps = [AppSettings shared];
        self.curLevel = aps.lastLevel;
        _levelCount = -1;

    }
    return self;
}

static BOOL isNewer(NSString *file1, NSString *file2)
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDate *f1date = [[fm attributesOfItemAtPath:file1 error:nil] fileModificationDate];
    NSDate *f2date = [[fm attributesOfItemAtPath:file2 error:nil] fileModificationDate];
    NSLog(@"File 1: %@; File 2: %@",f1date,f2date);
    return ([f1date compare: f2date] == NSOrderedDescending);
}

- (BOOL) copydb
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    // use default database in app bundle
    self.dbpath = [[NSBundle mainBundle] pathForResource:@"levels" ofType:@"sqlite3"];

    if ([paths count] > 0) {
        NSString *docs = [paths objectAtIndex:0];
        NSString *userdb = [docs stringByAppendingPathComponent: @"levels.sqlite3"];
        if ([fm fileExistsAtPath:userdb]) {
            if (!isNewer(_dbpath,userdb)) {
#ifndef NDEBUG
                NSLog(@"opening database in document directory");
#endif
                self.dbpath = userdb;
                dbmod = YES;
                return YES;
            }
#ifndef NDEBUG
            NSLog(@"app db is newer, must be copied");
#endif
            // remove existing userdb
            [fm removeItemAtPath:userdb error:nil];
            [self clearScores];
        }
        if ([fm copyItemAtPath:self.dbpath toPath:userdb error:NULL]) {
#ifndef NDEBUG
            NSLog(@"copied database to document directory");
#endif
            self.dbpath = userdb;
            dbmod = YES;
            return YES;
        }
    }
#ifndef NDEBUG
    NSLog(@"No document directory - this shouldn't happen");
#endif
    return NO;
}

- (BOOL) checkForDbUdate
{
#ifdef ALLOW_DB_UPDATE
    if (dbmod) {
        NSString *timestamp_url = @"http://apps.mc-development.com/removr/timestamp";
        NSString *update_url = @"http://apps.mc-development.com/removr/levels.sql";
        NSString *db_url = @"http://apps.mc-development.com/removr/levels.sqlite3";
    
        NSString *datestring = [NSString stringWithContentsOfURL:[NSURL URLWithString:timestamp_url]
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];
        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"EEE MMM d HH:mm:ss zzz yyyy\n"];

        NSDate *timestamp = [dateFormatter dateFromString:datestring];
#ifndef NDEBUG
        NSLog(@"timestamp = %@",timestamp);
#endif
        if (nil == timestamp)
            return NO;

        if ((nil == aps.last_check) || ([timestamp compare:aps.last_check] == NSOrderedDescending)) {
            NSLog(@"database update requested");
            
            // first try to replace entire sqlite database
            NSData *newdb = [NSData dataWithContentsOfURL:[NSURL URLWithString:db_url]];
            if ((nil != newdb) && ([newdb length] > 1024)) {
                NSLog(@"replacing database");
                sqlite3_close(db);
                [newdb writeToFile:self.dbpath atomically:NO];
                sqlite3_open([self.dbpath UTF8String] , &db);
                [self clearScores];
                aps.last_check = timestamp;
                [aps save];
                return YES;
            }
            // if no new database, execute sql on current database
            NSString *update_sql = [NSString stringWithContentsOfURL:[NSURL URLWithString:update_url] 
                                                            encoding:NSUTF8StringEncoding 
                                                                      error:nil];
            if (update_sql && [update_sql length] > 4) {
                const char *sql = [update_sql UTF8String], *nextsql;
                sqlite3_stmt *upd;
                NSLog(@"running sql on database: %s",sql);
                while (sql && (SQLITE_OK == sqlite3_prepare_v2(db, sql, -1, &upd, &nextsql)) ) {
                    int result = sqlite3_step(upd);
                    if ((result != SQLITE_DONE) && (result != SQLITE_ROW))
                        break;
                    sqlite3_reset(upd);
                    sql = nextsql;
                }
                [self clearScores];
                sqlite3_finalize(upd);
                aps.last_check = timestamp;
                [aps save];
                return YES;
            }
        }
    }
#endif
    return NO;
}

- (BOOL) opendb
{
    if (nil == db) {
        [self copydb];
        sqlite3_open([self.dbpath UTF8String] , &db);
        [self checkForDbUdate];
    }
    return (nil != db);
}

- (void)dealloc
{
    if (nil != query) {
        sqlite3_finalize(query);
    }
    if (nil != db) {
        sqlite3_close(db);
    }

    aps.lastLevel = self.curLevel;
    [aps save];

    self.theLevel = nil;
    self.gs = nil;
    self.ms = nil;
    [super dealloc];
}

- (NSMutableData*)levelStatus
{
    return aps.levelStatus;
}

- (void)clearScores
{
    NSMutableData *levelstat = aps.levelStatus;
    char *mbytes = [levelstat mutableBytes];
    int len = [levelstat length];
    
    if ((len > 0) && mbytes) {
        memset(mbytes,0,len);
    }
}


- (void) setScore: (NSInteger)score forLevel: (NSInteger)level
{
#ifndef NDEBUG
    NSLog(@"setScore:%d forLevel:%d",score,level);
#endif
    NSMutableData *levelstat = aps.levelStatus;
    if (level > ([levelstat length]/sizeof(NSInteger))) {
        [levelstat setLength:level*sizeof(NSInteger)];
    }
    NSInteger *scores = (NSInteger*)[levelstat bytes];
    // only save the score if it's lower than the last saved score
    NSInteger oldScore = scores[level];
    if ((0==oldScore) || (score < oldScore)) {
        scores[level] = (score ? score : -1);
    }
}

- (NSInteger) scoreForLevel: (NSInteger)level
{
    NSInteger *scores = (NSInteger*)[aps.levelStatus bytes];
    return scores[level];
}

- (Level*)GetLevel: (int)number
{
    // if we're restarting the current level, use the saved copy
    if ((number == _curLevel) && (_theLevel != nil)) {
        return _theLevel;
    }
    // open the database & prepare the query here the first time we use it instead of init
    if (nil == query) {
        [self opendb];
        sqlite3_prepare_v2(db, "SELECT rowid,background,map,name,par FROM levels WHERE ROWID=?", -1, &query, NULL);
    }
    Level *lvl = nil;
    self.curLevel = number;
    // request a record for the level
    sqlite3_bind_int(query, 1, number+1);
    if (sqlite3_step(query) == SQLITE_ROW) {
        char *str;
        void *blob;
        int nbytes;

        lvl = [[Level alloc] init];
        lvl.index = sqlite3_column_int(query, 0);
        
        str = (char*)sqlite3_column_text(query, 1);
        if (nil != str) {
            lvl.background = [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
        }
        
        blob = (void*)sqlite3_column_blob(query,2);
        nbytes = sqlite3_column_bytes(query,2);
        if (blob && (nbytes > 0)) {
            lvl.map = [NSData dataWithBytes:blob length:nbytes];
        }
        
        str = (char*)sqlite3_column_text(query, 3);
        if (nil != str) {
            lvl.title = [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
        }
        
        lvl.par = sqlite3_column_int(query, 4);

        self.theLevel = lvl;
    }
    else self.theLevel = nil;
    sqlite3_reset(query);
    return [lvl autorelease];
}

- (int)levelCount
{

    if (_levelCount <= 0) {
        sqlite3_stmt *scount;
        [self opendb];
        int result = sqlite3_prepare_v2(db, "SELECT COUNT(*) FROM levels", -1, &scount, NULL);
        result = sqlite3_step(scount);
        if (result == SQLITE_ROW) {
            _levelCount = sqlite3_column_int(scount, 0);
        }
        else _levelCount = 100; // don't freak out if the query fails
        sqlite3_finalize(scount);
    }

    return _levelCount;
}

- (void)visitweb:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.mcdevzone.com/software"]];
}

- (void)playLevel: (NSNumber*)level
{
    if (nil == _gs) {
        self.gs = [GameScene node];
    }
    [[CCDirector sharedDirector] replaceScene: _gs];

    [_gs playLevel:level];
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
