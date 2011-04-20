//
//  InfoScene.h
//  Removr
//
//  Created by Mike Cohen on 5/28/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "cocos2d.h"
#import "chipmunk.h"

@class InfoLayer;

@interface InfoScene : CCScene {
    InfoLayer *_info;
}

@property (retain,nonatomic) InfoLayer* info;

@end
