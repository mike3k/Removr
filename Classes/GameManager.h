//
//  LevelManager.h
//  Blocks
//
//  Created by Mike Cohen on 4/30/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "MCLayer.h"
#import "Level.h"
#import "AppSettings.h"

#import <sqlite3.h>

@class GameScene;
@class MenuScene;



@interface GameManager : NSObject <MCLayerDelegate> {
    AppSettings *aps;
    
    NSInteger _curLevel;
    Level *_theLevel;


    NSString *_dbpath;
    BOOL    dbmod;

    sqlite3 * db;
    sqlite3_stmt * query;


    GameScene *_gs;
    MenuScene *_ms;
    
    BOOL _paused;
    
    int _levelCount;
    
}


@property (retain,nonatomic) GameScene *gs;
@property (retain,nonatomic) MenuScene *ms;
@property (retain,nonatomic) Level *theLevel;
@property (assign,nonatomic) NSInteger curLevel;
@property (retain,nonatomic) NSString *dbpath;
@property (readonly) NSMutableData *levelStatus;

+ (GameManager*)shared;

//- (BOOL)LoadLevels;

- (void)initLevels;

- (void)clearScores;

- (BOOL) copydb;
- (BOOL) opendb;
- (BOOL) checkForDbUdate;

- (Level*)GetLevelFromURL: (NSURL*)url;
- (Level*)GetLevelFromFile: (NSString*)path;

- (Level*)GetLevel: (int)number;
- (int)levelCount;

- (void)playIntroMusic;
- (void)playWinSound;
- (void)playLoseSound;
- (void)playRemoveSound;
- (void)preloadSounds;

- (void) setScore: (NSInteger)score forLevel: (NSInteger)level;
- (NSInteger) scoreForLevel: (NSInteger)level;

- (void)playLevel: (NSNumber*)level;

- (void)play:(id)sender;
- (void)highscores:(id)sender;
- (void)options:(id)sender;
- (void)info:(id)sender;

- (void)menu: (id)sender;
- (void)pause: (id)sender;
- (void)resume: (id)sender;

@end
