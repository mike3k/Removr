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

@property (assign,nonatomic) BOOL paused;
@property (assign,nonatomic) NSInteger curLevel;

@end


@interface MCLayer : CCLayer {
    id <MCLayerDelegate> _delegate;
    CCSprite *_background;

}

@property (retain,nonatomic) CCSprite *background;
@property (assign,nonatomic) id <MCLayerDelegate> delegate;

@end
