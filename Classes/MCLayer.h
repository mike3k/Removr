//
//  MCLayer.h
//  Removr
//
//  Created by Mike Cohen on 5/29/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "cocos2d.h"
#import "chipmunk.h"

enum {
	kTagAtlasSpriteSheet = 2,
    kTagPauseButton,
    kTagPauseBackground,
    kTagPauseMenu,
    kTagWinScreen,
    kTagCloud1,
    kTagCloud2,
    kTagCloudAction1,
    kTagCloudAction2,
};

#define zCloudLevel         1
#define zMenuLayer          2
#define zSpritesLevel       3
#define zOverlayLevel       4

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
- (NSTimeInterval) timeForLevel: (NSInteger)level;

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
    
//    CCFiniteTimeAction *_move1;
//    CCFiniteTimeAction *_move2;
    
    BOOL    _nightMode;

}

- (void) moveClouds;
- (void) addSun;
- (BOOL) addClouds;

- (void) removeSun;
- (void) removeClouds;
- (void) stopClouds;

- (NSString*)altScaledFile: (NSString*)name;

- (NSString*)scaledFile: (NSString*)name;

@property (retain,nonatomic) CCSprite *background;
@property (assign,nonatomic) id <MCLayerDelegate> delegate;
@property (assign,nonatomic) CGFloat scale;
@property (assign,nonatomic) BOOL nightMode;

@property (readonly) NSString *cloud1;
@property (readonly) NSString *cloud2;
@property (readonly) NSString *sunFileName;
@property (readonly) NSString *bgFileName;

@end

