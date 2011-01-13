//
//  OptionScene.h
//  Removr
//
//  Created by Mike Cohen on 5/28/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "cocos2d.h"
#import "chipmunk.h"

@class OptionsLayer;

@interface OptionScene : CCScene {
    OptionsLayer *_options;
}

@property (retain,nonatomic) OptionsLayer *options;

@end
