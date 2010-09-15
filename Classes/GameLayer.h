//
//  GameScreen.h
//  Blocks
//
//  Created by Mike Cohen on 4/17/10.
//  Copyright 2010 MC Development. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// Importing Chipmunk headers
#import "MCLayer.h"

#import "SpriteDefs.h"
#import "AppSettings.h"

@class GameManager;
@class ShapeSprite;

@interface GameLayer : MCLayer {
    CCSpriteBatchNode *_sheet;
    cpSpace *space;
    int _level;
    
    BOOL    win;
    BOOL    lose;
    BOOL    moved;
    
    int             moves;
    int             blueRemoved;

    NSTimeInterval  elapsedtime;
    NSTimeInterval  startTime;
    
    CCMenu      *pauseMenu;
    
    AppSettings *aps;
    
    //CCLabelAtlas *timeLabel;
    CCLabelTTF  *timeLabel;
    int _facet;
}

@property (assign,nonatomic) int level;
@property (retain,nonatomic) CCSpriteBatchNode *sheet;
@property (assign,nonatomic) BOOL moved;

- (void)setAccellerometer;
- (void)setDefaultBackground;

//+ (id) scene;
- (void) updateTime: (ccTime) dt;
- (void) step: (ccTime) dt;
- (void)removeShape: (cpShape*)shape force: (BOOL)force;
- (void)removeSprite: (ShapeSprite*)sprite force: (BOOL)force;

-(void) addNewSprite: (int)kind x:(float)x y:(float)y;
-(void) addSprite: (UInt32)b;

- (void)runWithMap: (UInt32*)map;

-(void) clearBoard;

- (void) showPauseMenu: (BOOL)canResume;
- (void) hidePauseMenu;

- (void)dimScreen;
- (void)undimScreen;

- (int)testWinOrLose;
- (BOOL)gotoLevel: (int)level;

- (void) resetScore;

- (void)start;
- (void)stop;

- (void)playLevel: (NSNumber*)num;

- (void) handleTouch: (CGPoint)touch;


- (void)play;
- (void)pause;
- (void)resume;
- (void)quit;

- (BOOL)hasBluePieces;

- (void)showWinScreen;
- (void)showLoseScreen;

@end
