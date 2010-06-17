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

@class GameManager;

@interface GameLayer : MCLayer {
    CCSpriteSheet *_sheet;
    cpSpace *space;
    int _level;
    
    BOOL    win;
    BOOL    lose;
    
    int             moves;
    NSTimeInterval  time;
    
    CCMenu      *pauseMenu;
}

@property (assign,nonatomic) int level;
@property (retain,nonatomic) CCSpriteSheet *sheet;

//+ (id) scene;
- (void) step: (ccTime) dt;
- (void)removeShape: (cpShape*)shape force: (BOOL)force;

-(void) addNewSprite: (int)kind x:(float)x y:(float)y;
-(void) addSprite: (UInt32)b;

- (void)runWithMap: (UInt32*)map;

-(void) clearBoard;


- (int)testWinOrLose;
- (BOOL)gotoLevel: (int)level;

- (void) reset;

- (void)start;
- (void)stop;

- (void)pause;
- (void)resume;

- (void)showWinScreen;
- (void)showLoseScreen;

@end
