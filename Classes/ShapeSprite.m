//
//  ShapeSprite.m
//  Blocks
//
//  Created by Mike Cohen on 4/20/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "ShapeSprite.h"


static SpriteInfo sprites[] = {

    { 0,          0,          FACET, FACET,   kSquareSprite | kOpenPiece | kGreenPiece | kMustKeep | kCanRemove | kIsStatic  },
    { FACET,      0,          FACET, FACET,   kSquareSprite | kSolidPiece | kGreenPiece | kMustKeep },
    { FACET * 2,  0,          FACET, FACET,   kCircleSprite | kOpenPiece | kGreenPiece | kMustKeep | kCanRemove | kIsStatic },
    { FACET * 3,  0,          FACET, FACET,   kCircleSprite | kSolidPiece | kGreenPiece | kMustKeep },

    { 0,          FACET,      FACET, FACET,   kSquareSprite | kOpenPiece | kRedPiece | kMustRemove | kCanRemove | kIsStatic },
    { FACET,      FACET,      FACET, FACET,   kSquareSprite | kSolidPiece | kRedPiece | kMustRemove },
    { FACET * 2,  FACET,      FACET, FACET,   kCircleSprite | kOpenPiece | kRedPiece | kMustRemove | kCanRemove | kIsStatic },
    { FACET * 3,  FACET,      FACET, FACET,   kCircleSprite | kSolidPiece | kRedPiece | kMustRemove },

    { 0,          FACET * 2,  FACET, FACET,   kSquareSprite | kOpenPiece | kBluePiece | kCanRemove | kIsStatic },
    { FACET,      FACET * 2,  FACET, FACET,   kSquareSprite | kSolidPiece | kBluePiece },
    { FACET * 2,  FACET * 2,  FACET, FACET,   kCircleSprite | kOpenPiece | kBluePiece | kCanRemove | kIsStatic },
    { FACET * 3,  FACET * 2,  FACET, FACET,   kCircleSprite | kSolidPiece | kBluePiece },
    
    { 0,            FACET * 3,      FACET * 4,  FACET,   kPlankSprite | kOpenPiece | kBluePiece | kCanRemove | kIsStatic },
    { 0,            (FACET * 4),  FACET * 3,  FACET, kPlankSprite | kOpenPiece | kBluePiece | kCanRemove | kIsStatic },
    { FACET * 3,    (FACET * 4),  FACET * 2,      FACET,  kPlankSprite | kOpenPiece | kBluePiece | kCanRemove | kIsStatic },
    
    { FACET * 4,    0,              FACET, FACET * 4, kPlankSprite | kOpenPiece | kBluePiece | kCanRemove | kIsStatic },
    { FACET * 5,  0,              FACET, FACET * 3,  kPlankSprite | kOpenPiece | kBluePiece | kCanRemove | kIsStatic },
    { FACET * 5,  FACET * 3,      FACET, FACET * 2,  kPlankSprite | kOpenPiece | kBluePiece | kCanRemove | kIsStatic },

};

#define kUniqueSprites  (sizeof(sprites) / sizeof(SpriteInfo))

@implementation ShapeSprite

@synthesize shape = _shape, space = _space;
@synthesize canRemove = _canRemove, isStatic = _isStatic, isCircle = _isCircle;
@synthesize mustRemove = _mustRemove, mustKeep = _mustKeep;
@synthesize info = _info;

// override designated initializer
-(id)init
{
    if ((self = [super init])) {
        self.shape = nil;
        self.space = nil;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc sprite %@, shape=%d",self,_shape);

    if (_shape != nil) {
        [self removeShape];
        cpBodyFree(_shape->body);
        cpShapeFree(_shape);
        self.shape = nil;
    }
    [super dealloc];
}

- (void)setAttributes: (UInt32)value
{
    _attributes = value;
    _isStatic = IsStatic(value);
    _canRemove = CanRemove(value);
    _mustKeep = MustKeep(value);
    _mustRemove = MustRemove(value);
    _isCircle = IsCircle(value);
}

- (UInt32)attributes
{
    return _attributes;
}

//#define VECSIZE ((FACET/2) - (FACET/16))

#define VECSIZE(X)  (X/2)

- (void)makeShapeForSprite
{

    int num = 4;
    CGPoint verts[4];

    verts[0] = ccp(-VECSIZE(_info.width),-VECSIZE(_info.height));
    verts[1] = ccp(-VECSIZE(_info.width), VECSIZE(_info.height));
    verts[2] = ccp( VECSIZE(_info.width), VECSIZE(_info.height));
    verts[3] = ccp( VECSIZE(_info.width),-VECSIZE(_info.height));

    cpBody *body;
    if (_isStatic) {
        body = cpBodyNew(INFINITY, INFINITY);
    }
    else {
        if (_isCircle) {
            body = cpBodyNew(1.0f, cpMomentForPoly(1.0f, num, verts, CGPointZero));
        }
        else {
            body = cpBodyNew(1.0f, cpMomentForPoly(1.0f, num, verts, CGPointZero));
        }
    }
    body->p = self.position;

	cpShape* shape;
    if (_isCircle) {
        shape = cpCircleShapeNew(body, (_info.width/2.0), ccp(0,0));
        shape->e = 0.75f; shape->u = 0.45f;
    }
    else {
        shape = cpPolyShapeNew(body, num, verts, CGPointZero);
        shape->e = 0.5f; shape->u = 0.5f;
    }
	shape->data = self;
    self.shape = shape;
}

+ (ShapeSprite*)NewSprite: (int)kind x:(float)x y:(float)y withSheet: (CCSpriteSheet*)sheet
{
    int posx, posy;

    SpriteInfo *sp = &sprites[kind];
    posx = sp->posx;
    posy = sp->posy;

    ShapeSprite *sprite = [ShapeSprite spriteWithSpriteSheet:sheet rect:CGRectMake(posx, posy, sp->width, sp->height)];
    CGPoint ap = sprite.anchorPointInPixels;
    [sheet addChild: sprite];
    
    sprite.info = *sp;
    sprite.attributes = sp->attrib;
    sprite.position = ccp(x+ap.x,y+ap.y);
    [sprite makeShapeForSprite];


    return sprite;
}

- (void)addToSpace:(cpSpace*)space
{
    self.space = space;
    if (_isStatic) {
        cpSpaceAddStaticShape(_space, _shape);
    }
    else {
        cpSpaceAddBody(_space, _shape->body);
        cpSpaceAddShape(_space, _shape);
    }
}

- (void)removeShape
{
    if (_space != nil) {
        if (_isStatic) {
            cpSpaceRemoveStaticShape(_space, _shape);
        }
        else {
            cpSpaceRemoveBody(_space, _shape->body);
            cpSpaceRemoveShape(_space, _shape);
        }
    }
}

@end
