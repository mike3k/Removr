//
//  MCLayer.h
//  Removr
//
//  Created by Mike Cohen on 5/29/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "cocos2d.h"
#import "chipmunk.h"

@protocol MCLayerDelegate <NSObject>

- (void)playLevel: (NSNumber*)level;

- (void)play:(id)sender;
- (void)highscores:(id)sender;
- (void)options:(id)sender;
- (void)info:(id)sender;

- (void)menu: (id)sender;
- (void)pause: (id)sender;
- (void)resume: (id)sender;
- (void)visitweb: (id)sender;

- (int)levelCount;
- (NSInteger) scoreForLevel: (NSInteger)level;

- (void)playIntroMusic;
- (void)playWinSound;
- (void)playLoseSound;
- (void)playRemoveSound;
- (void)preloadSounds;

@property (assign,nonatomic) BOOL paused;
@property (assign,nonatomic) NSInteger curLevel;

@end

@interface MCLayer : CCLayer {
    id <MCLayerDelegate> _delegate;
    CCSprite *_background;
    
    CGFloat _scale;
    
    CCSprite *_sun;
    CCSprite *_cloud1;
    CCSprite *_cloud2;
    
    CCAction *_move1;
    CCAction *_move2;

}

- (void) moveClouds;
- (void) addSun;
- (void) addClouds;

- (void) removeSun;
- (void) removeClouds;
- (void) stopClouds;


- (NSString*)scaledFile: (NSString*)name;

@property (retain,nonatomic) CCSprite *background;
@property (assign,nonatomic) id <MCLayerDelegate> delegate;
@property (assign,nonatomic) CGFloat scale;

@end
