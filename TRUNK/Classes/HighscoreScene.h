//
//  HighscoreScene.h
//  Removr
//
//  Created by Mike Cohen on 5/28/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "cocos2d.h"
#import "chipmunk.h"

@class HighScoreLayer;

@interface HighscoreScene : CCScene {
    HighScoreLayer *_scores;
}

@property (retain,nonatomic) HighScoreLayer *scores;

@end
