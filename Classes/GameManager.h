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


@class GameScene;
@class MenuScene;

@interface Level : NSObject {
    NSString *_background;
    NSData *map;
}

@property (retain,nonatomic) NSString *background;
@property (retain,nonatomic) NSData *map;

- (id)initWithBackground: (NSString*)bg data: (void*)bytes length: (int)length;
+ (Level*)LevelWithBackground: (NSString*)bg data: (void*)bytes length: (int)length;

@end


@interface GameManager : NSObject <MCLayerDelegate> {
    NSInteger _curLevel;
    NSMutableArray *_levels;
    
    GameScene *_gs;
    MenuScene *_ms;
}

@property (retain,nonatomic) NSMutableArray *levels;
@property (retain,nonatomic) GameScene *gs;
@property (retain,nonatomic) MenuScene *ms;
@property (assign,nonatomic) NSInteger curLevel;

+ (GameManager*)shared;

- (BOOL)LoadLevels;
- (Level*)GetLevel: (int)number;
- (int)levelCount;

- (void) GotoLevel: (Level*)level;

- (void)play:(id)sender;
- (void)highscores:(id)sender;
- (void)options:(id)sender;
- (void)info:(id)sender;

- (void)menu: (id)sender;
- (void)pause: (id)sender;
- (void)resume: (id)sender;

@end
