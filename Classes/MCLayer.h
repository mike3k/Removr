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

- (void)play:(id)sender;
- (void)highscores:(id)sender;
- (void)options:(id)sender;
- (void)info:(id)sender;

- (void)menu: (id)sender;
- (void)pause: (id)sender;
- (void)resume: (id)sender;

@end


@interface MCLayer : CCLayer {
    id <MCLayerDelegate> _delegate;
    CCSprite *_background;

}

@property (retain,nonatomic) CCSprite *background;
@property (assign,nonatomic) id <MCLayerDelegate> delegate;

@end
