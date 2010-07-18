//
//  ShapeSprite.h
//  Blocks
//
//  Created by Mike Cohen on 4/20/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "cocos2d.h"

// Importing Chipmunk headers
#import "chipmunk.h"

#import "SpriteDefs.h"

@interface ShapeSprite : CCSprite {
    cpShape *_shape;
    cpSpace *_space;
    
    SpriteInfo _info;

    UInt32  _attributes;

    BOOL    _canRemove;
    BOOL    _isStatic;
    BOOL    _mustKeep;
    BOOL    _mustRemove;
    BOOL    _isCircle;
    
}

+ (ShapeSprite*)Sprite: (int)kind x:(float)x y:(float)y withSheet: (CCSpriteSheet*)sheet;
- (void)addToSpace:(cpSpace*)space;
- (void)makeShapeForSprite;
- (void)removeShape;


@property (assign,nonatomic) cpShape *shape;
@property (assign,nonatomic) cpSpace *space;
@property (assign,nonatomic) UInt32 attributes;
@property (assign,nonatomic) BOOL canRemove;
@property (assign,nonatomic) BOOL isStatic;
@property (assign,nonatomic) BOOL mustRemove;
@property (assign,nonatomic) BOOL mustKeep;
@property (assign,nonatomic) BOOL isCircle;
@property (assign,nonatomic) SpriteInfo info;

@end
