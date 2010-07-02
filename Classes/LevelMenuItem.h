//
//  LevelMenuItem.h
//  Removr
//
//  Created by Mike Cohen on 7/1/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "cocos2d.h"


@interface LevelMenuItem : CCMenuItemImage {
    NSInteger _level;
    NSInteger _moves;
    
    CCLabel *_labelMoves;
    CCLabel *_labelLevel;

}

@property (assign,nonatomic) NSInteger level;
@property (assign,nonatomic) NSInteger moves;

- (void) makeLabels;

@end
