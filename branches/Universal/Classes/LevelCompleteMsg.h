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
    float _time;
    int _level;
    int _blueRemoved;
    float _scale;

    CCLabelTTF *label;
    CCLabelTTF *label2;
    CCLabelTTF *label3;
}

@property (assign,nonatomic) int moves;
@property (assign,nonatomic) int level;
@property (assign,nonatomic) float time;
@property (assign,nonatomic) int blueRemoved;

- (id) initWithMoves: (int)moves level: (int)level time:(float)time blues: (int)blues;
- (id) initWithMoves: (int)moves;

@end
