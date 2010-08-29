//
//  LevelMenuItem.h
//  Removr
//
//  Created by Mike Cohen on 7/1/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "cocos2d.h"
#import "MCMenuItem.h"

@interface LevelMenuItem : MCMenuItem {
    NSInteger _level;
    NSTimeInterval _time;
    NSInteger _moves;
    
    CCLabel *_labelMoves;
    CCLabel *_labelLevel;
    CCLabel *_labelTime;

}

@property (assign,nonatomic) NSInteger level;
@property (assign,nonatomic) NSInteger moves;
@property (assign,nonatomic) NSTimeInterval time;
- (void) makeLabels;

@end
