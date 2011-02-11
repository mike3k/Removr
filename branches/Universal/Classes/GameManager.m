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

#import "GKAchievementHandler.h"

#undef ALLOW_DB_UPDATE
#define DB_VERSION  1

static GameManager *_sharedGameManager = nil;

@implementation GameManager

@synthesize curLevel = _curLevel;
@synthesize theLevel = _theLevel;
@synthesize gs = _gs;
@synthesize ms = _ms;
@synthesize paused = _paused;
@synthesize dbpath = _dbpath;
@synthesize levelStatus = _levelStatus;
@synthesize queryString;
@synthesize countQueryString;

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

		GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
		gkHelper.delegate = self;
		[gkHelper authenticateLocalPlayer];

        [CDAudioManager configure:kAMM_FxPlusMusicIfNoOtherAudio];
    
        [self preloadSounds];

        UInt32 category = kAudioSessionCategory_AmbientSound;
		AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);

    
    }
#ifndef NDEBUG
    NSLog(@"GameManager init");
#endif
    return self;
}

- (void) initLevels
{
    // open the database & prepare the query here the first time we use it instead of init
    if (nil == db) {
#ifndef NDEBUG
    NSLog(@"initLevels");
#endif
        [self opendb];
        sqlite3_prepare_v2(db, [queryString UTF8String], 
                           -1, 
                           &query, 
                           NULL);
    }
}

#pragma mark database management
/*
static BOOL isNewer(NSString *file1, NSString *file2)
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDate *f1date = [[fm attributesOfItemAtPath:file1 error:nil] fileModificationDate];
    NSDate *f2date = [[fm attributesOfItemAtPath:file2 error:nil] fileModificationDate];
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
            if ((aps.version == DB_VERSION) && !isNewer(_dbpath,userdb)) {
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
            //[self clearScores];
        }
        if ([fm copyItemAtPath:self.dbpath toPath:userdb error:NULL]) {
#ifndef NDEBUG
            NSLog(@"copied database to document directory");
#endif
            aps.version = DB_VERSION;
            [aps save];
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
        NSString *version_url = @"http://apps.mc-development.com/removr/version";
        
        // check version matches our database version
        NSInteger version = 0;
        NSString *version_str = [NSString stringWithContentsOfURL:[NSURL URLWithString:version_url]
                                                         encoding:NSUTF8StringEncoding
                                                            error:nil];
        if (nil == version_str)
            return NO;
        
        [[NSScanner scannerWithString:version_str] scanInteger:&version];
        if (version != DB_VERSION)
            return NO;
    
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
                _levelCount = -1;
                aps.last_check = timestamp;
                [aps save];
                return YES;
            }
        }
    }
#endif
    return NO;
}
 */

- (BOOL)attach_user_databases
{
    int dbcount = 0, result;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSDirectoryEnumerator *docs = [fm enumeratorAtPath:documentsDirectory];
    NSString *file;
    while ((file = [docs nextObject])) {
        if ([[file pathExtension] isEqualToString:@"leveldb"]) {
            ++dbcount;
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:file];
            sqlite3_stmt *attach;
            sqlite3_prepare_v2(db,[[NSString stringWithFormat:@"ATTACH DATABASE '%@' AS 'DB%i'",fullPath,dbcount] UTF8String], -1, &attach, NULL);
            result=sqlite3_step(attach);
            sqlite3_finalize(attach);
        }
    }
    if (dbcount == 0) {
        self.queryString = @"SELECT rowid,background,map,name,par,timeLimit,achievement,flags FROM levels WHERE ROWID=?";
        self.countQueryString = @"SELECT count(*) from levels";
        return NO;
    }
    else {
        sqlite3_stmt *cview;
        NSMutableString *createView = [NSMutableString stringWithString:@"CREATE TEMP VIEW LV AS SELECT rowid as x,* FROM levels"];
        for (int i=1;i<=dbcount;++i) {
            [createView appendFormat:@" UNION SELECT (rowid*%i) as x,* FROM DB%i.levels",100*i,i];
        }
        sqlite3_prepare_v2(db, [createView UTF8String], -1, &cview, NULL);
        result=sqlite3_step(cview);
        sqlite3_finalize(cview);
        self.queryString = @"SELECT rowid,background,map,name,par,timeLimit,achievement,flags FROM LV WHERE ROWID=?";
        self.countQueryString = @"SELECT count(*) from LV";
        return YES;
    }
}

- (BOOL) opendb
{
    if (nil == db) {
#ifdef LITE_VERSION
        self.dbpath = [[NSBundle mainBundle] pathForResource:@"minilevels" ofType:@"db"];
#else
        self.dbpath = [[NSBundle mainBundle] pathForResource:@"levels" ofType:@"db"];
#endif
        sqlite3_open([self.dbpath UTF8String], &db);
//        self.queryString = [NSMutableString stringWithString: @"SELECT rowid,background,map,name,par,timeLimit,achievement,flags FROM levels "];
        [self attach_user_databases];
//        [self.queryString appendString: @" WHERE ROWID=?"];
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

#pragma mark Scores

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
    if (level == INT16_MAX)
        return;

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
    if (level == INT16_MAX)
        return 0;

    NSInteger *scores = (NSInteger*)[aps.levelStatus bytes];
    return scores[level];
}

- (void) setTime: (NSTimeInterval)tm forLevel: (NSInteger)level
{
    if (level == INT16_MAX)
        return;

    NSMutableData *timeStat = aps.levelTimes;
    if (level > ([timeStat length]/sizeof(NSTimeInterval))) {
        [timeStat setLength:level*sizeof(NSTimeInterval)];
    }
    NSTimeInterval *times = (NSTimeInterval*)[timeStat bytes];
    // only save the score if it's lower than the last saved score
    NSTimeInterval oldTime = times[level];
    if ((0==oldTime) || (tm < oldTime)) {
        times[level] = (tm ? tm : -1);
    }
}

- (NSTimeInterval) timeForLevel: (NSInteger)level
{
    if (level == INT16_MAX)
        return 0;

    NSTimeInterval *times = (NSTimeInterval*)[aps.levelTimes bytes];
    return times[level];
}


#pragma mark Levels

- (Level*)GetLevelFromURL: (NSURL*)url
{
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [Level levelFromData:data];
}

- (Level*)GetLevelFromFile: (NSString*)path
{
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [Level levelFromData:data];
}

- (Level*)GetLevel: (int)number
{
    int result;
    
    if (number == INT16_MAX) {
        return [self GetRandomLevel];
    }
    // if we're restarting the current level, use the saved copy
    if ((number == _curLevel) && (_theLevel != nil)) {
        return _theLevel;
    }
    self.curLevel = number;
    
    // first time this gets called, the database will be opened
    [self initLevels];

    // request a record for the level
    sqlite3_bind_int(query, 1, number+1);

    result=sqlite3_step(query);
    if (result == SQLITE_ROW) {
        self.theLevel = [Level levelFromQueryResult:query];
    }
    else {
        self.theLevel = nil;
    }
    sqlite3_reset(query);
    
    return _theLevel;
}

- (int)levelCount
{

    if (_levelCount <= 0) {
        sqlite3_stmt *scount;
        [self initLevels];
        int result;
//        sqlite3_prepare_v2(db, "SELECT COUNT(*) FROM levels", -1, &scount, NULL);
        sqlite3_prepare_v2(db,[countQueryString UTF8String], -1, &scount, NULL);
        result = sqlite3_step(scount);
        if (result == SQLITE_ROW) {
            _levelCount = sqlite3_column_int(scount, 0);
        }
        else _levelCount = 100; // don't freak out if the query fails
#ifndef NDEBUG
        NSLog(@"Row Count query returned %d, # of levels is %d",result,_levelCount);
#endif
        sqlite3_finalize(scount);
    }

    return _levelCount;
}

#pragma mark Commands & Actions

- (void)visitweb:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://news.removrapp.com/"]];
}

- (void)getMoreLevels:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://removrapp.com/buy"]];
}

- (void)playLevel: (NSNumber*)level
{
    if (nil == _gs) {
#ifndef NDEBUG
        NSLog(@"initializing GameScene");
#endif
        self.gs = [GameScene node];
    }
#ifndef NDEBUG
    NSLog(@"showing game scene: %@",_gs);
#endif
    [[CCDirector sharedDirector] replaceScene: _gs];

    [_gs playLevel:level];
}

- (void)play:(id)sender
{
    if (nil == _gs) {
#ifndef NDEBUG
        NSLog(@"initializing GameScene");
#endif
        self.gs = [GameScene node];
    }
#ifndef NDEBUG
    NSLog(@"showing game scene: %@",_gs);
#endif
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


#pragma mark Sounds


- (void)preloadSounds
{
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"remove.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"fart.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"applause.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"pew.wav"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"intro.wav"];
}

- (void)playExplodeSound
{
    if (aps.sound) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"pew.wav"];
    }
}

- (void)playWinSound
{
    if (aps.sound) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"applause.wav"];
    }
}

- (void)playRemoveSound
{
    if (aps.sound) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"remove.wav"];
    }
}

-( void)playLoseSound
{
    if (aps.sound) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"fart.wav"];
    }
}

- (void)playIntroMusic
{
    if (aps.sound) {
        //NSLog(@"playing bg music");
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"intro.wav" loop:NO];
    }
}

- (void)showLeaderBoard: (id)sender
{
    GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
    [gkHelper showLeaderboard];
}

- (void)showAchievements: (id)sender
{
    GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
    [gkHelper showAchievements];
}

#pragma mark GameKitHelper delegate methods
-(void) onLocalPlayerAuthenticationChanged
{
	GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
	CCLOG(@"LocalPlayer isAuthenticated changed to: %@", localPlayer.authenticated ? @"YES" : @"NO");
	
	if (localPlayer.authenticated)
	{
		GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
		//[gkHelper getLocalPlayerFriends];
		//[gkHelper resetAchievements];
        [gkHelper retrieveScoresForPlayers:[NSArray arrayWithObject: [GKLocalPlayer localPlayer].playerID]
                                  category:nil 
                                     range:NSMakeRange(1, 1)
                               playerScope:GKLeaderboardPlayerScopeGlobal
                                 timeScope:GKLeaderboardTimeScopeAllTime];

	}	
}

-(void) onFriendListReceived:(NSArray*)friends
{
	CCLOG(@"onFriendListReceived: %@", [friends description]);
//	GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
//	[gkHelper getPlayerInfo:friends];
}

-(void) onPlayerInfoReceived:(NSArray*)players
{
	CCLOG(@"onPlayerInfoReceived: %@", [players description]);
//	GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
//	[gkHelper submitScore:1234 category:@"Playtime"];
	
	//[gkHelper showLeaderboard];
	
//	GKMatchRequest* request = [[[GKMatchRequest alloc] init] autorelease];
//	request.minPlayers = 2;
//	request.maxPlayers = 4;
	
	//GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
//	[gkHelper showMatchmakerWithRequest:request];
//	[gkHelper queryMatchmakingActivity];
}

-(void) onScoresSubmitted:(bool)success
{
	CCLOG(@"onScoresSubmitted: %@", success ? @"YES" : @"NO");
}

-(void) onScoresReceived:(NSArray*)scores
{
	CCLOG(@"onScoresReceived: %@", [scores description]);
    NSInteger topScore = 0;
    if ([scores count] > 0) {
        GKScore * theScore = [scores objectAtIndex:0];
        topScore = [theScore value];
        if (topScore > aps.totalPoints) {
            aps.totalPoints = topScore;
            [aps save];
        }
    }
}

-(void) onAchievementReported:(GKAchievement*)achievement
{
	CCLOG(@"onAchievementReported: %@, Complete = %f", achievement,achievement.percentComplete);
    if (achievement.percentComplete == 100.0) {
        CCLOG(@"Completed achievement: %@",achievement.identifier);
        GKAchievementDescription *desc = [[GameKitHelper sharedGameKitHelper] getAchievementDescription: achievement.identifier];
        if (nil != desc) {
            [[CCDirector sharedDirector] pause];
            CCLOG(@"achievement name: %@ description: %@",desc.title,desc.achievedDescription);
            [[GKAchievementHandler defaultHandler] notifyAchievement:desc];
        }
    }
}

-(void) onAchievementDescriptionsLoaded:(NSDictionary*)achievementDescriptions
{
    CCLOG(@"onAchievementDescriptionsLoaded: %@",achievementDescriptions);
}

-(void) onAchievementsLoaded:(NSDictionary*)achievements
{
	CCLOG(@"onLocalPlayerAchievementsLoaded: %@", [achievements description]);
    [[GameKitHelper sharedGameKitHelper] loadAchievementDescriptions];
}

-(void) onResetAchievements:(bool)success
{
	CCLOG(@"onResetAchievements: %@", success ? @"YES" : @"NO");
}

-(void) onLeaderboardViewDismissed
{
	CCLOG(@"onLeaderboardViewDismissed");
	
//	GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
//	[gkHelper retrieveTopTenAllTimeGlobalScores];
}

-(void) onAchievementsViewDismissed
{
	CCLOG(@"onAchievementsViewDismissed");
}

-(void) onReceivedMatchmakingActivity:(NSInteger)activity
{
	CCLOG(@"receivedMatchmakingActivity: %i", activity);
}

-(void) onMatchFound:(GKMatch*)match
{
	CCLOG(@"onMatchFound: %@", match);
}

-(void) onPlayersAddedToMatch:(bool)success
{
	CCLOG(@"onPlayersAddedToMatch: %@", success ? @"YES" : @"NO");
}

-(void) onMatchmakingViewDismissed
{
	CCLOG(@"onMatchmakingViewDismissed");
}
-(void) onMatchmakingViewError
{
	CCLOG(@"onMatchmakingViewError");
}

-(void) onPlayerConnected:(NSString*)playerID
{
	CCLOG(@"onPlayerConnected: %@", playerID);
}

-(void) onPlayerDisconnected:(NSString*)playerID
{
	CCLOG(@"onPlayerDisconnected: %@", playerID);
}

-(void) onStartMatch
{
	CCLOG(@"onStartMatch");
}

-(void) onReceivedData:(NSData*)data fromPlayer:(NSString*)playerID
{
	CCLOG(@"onReceivedData: %@ fromPlayer: %@", data, playerID);
}


@end
