//
//  GetMoreScene.h
//  Removr
//
//  Created by Mike Cohen on 2/8/11.
//  Copyright 2011 MC Development. All rights reserved.
//

#import "cocos2d.h"
#import "chipmunk.h"

@class GetMoreLayer;

@interface GetMoreScene : CCScene {
    GetMoreLayer *theLayer;
}

@property (retain,nonatomic) GetMoreLayer* theLayer;

+ (void)ShowPurchaseScreen;

@end
