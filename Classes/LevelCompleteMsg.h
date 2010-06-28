//
//  LevelCompleteMsg.h
//  Removr
//
//  Created by Mike Cohen on 6/27/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "cocos2d.h"

#define USE_LABEL

@interface LevelCompleteMsg : CCSprite {
    int _moves;

#ifdef USE_LABEL
    CCLabel *label;
#else
    CCLabelAtlas *label;
#endif
}

@property (assign,nonatomic) int moves;

- (id) initWithMoves: (int)moves;

@end
