//
//  GameScene.h
//  Blocks
//
//  Created by Mike Cohen on 5/10/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "cocos2d.h"
#import "chipmunk.h"
#import "SpriteDefs.h"

@class GameLayer;
@class GameManager;
@class OptionsLayer;
@class InfoLayer;

@interface GameScene : CCScene {
    GameLayer *_game;

    int _curLevel;
}

//- (void) playLevel: (int)level;
//- (void) gotoMenu;
//- (void) restartGame;
//- (void) nextLevel;

- (void)play:(id)sender;
- (void)playLevel:(NSNumber*)level;

//- (void)highscores:(id)sender;
//- (void)options:(id)sender;
//- (void)info:(id)sender;



@property (retain,nonatomic) GameLayer *game;
//@property (assign,nonatomic) int curLevel;

@end
