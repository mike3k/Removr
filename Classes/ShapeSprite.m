//
//  ShapeSprite.m
//  Blocks
//
//  Created by Mike Cohen on 4/20/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "ShapeSprite.h"

#define FACETX2 (FACET*2)
#define FACETX3 (FACET*3)
#define FACETX4 (FACET*4)
#define FACETX5 (FACET*5)

#define HBAR3   (BAR_H*3)
#define VBARS   ((FACET*2)+(BAR_H*3))
#define VBARS2  ((FACET*2)+(BAR_H*6))

static SpriteInfo sprites[] = {

    // circle
    { 0,            0,          FACET, FACET,   kCircleSprite | kMustRemove },      // RED
    { FACET,        0,          FACET, FACET,   kCircleSprite | kMustKeep },        // GREEN
    { FACETX2,      0,          FACET, FACET,   kCircleSprite },                    // BLUE
    
    // square
    { 0,            FACET,      FACET, FACET,   kSquareSprite | kMustRemove | kCanRemove | kIsStatic },     // RED
    { FACET,        FACET,      FACET, FACET,   kSquareSprite | kMustKeep | kCanRemove | kIsStatic },       // GREEN
    { FACETX2,      FACET,      FACET, FACET,   kSquareSprite | kCanRemove | kIsStatic },                   // BLUE

    // colorblind circle
    { FACETX3,    0,          FACET, FACET,   kCircleSprite | kMustRemove },        // RED
    { FACETX4,    0,          FACET, FACET,   kCircleSprite | kMustKeep },          // GREEN
    { FACETX5,    0,          FACET, FACET,   kCircleSprite },                      // BLUE

    // colorblind square
    { FACETX3,    FACET,      FACET, FACET,   kSquareSprite | kMustRemove | kCanRemove | kIsStatic },       // RED
    { FACETX4,    FACET,      FACET, FACET,   kSquareSprite | kMustKeep | kCanRemove | kIsStatic },         // GREEN
    { FACETX5,    FACET,      FACET, FACET,   kSquareSprite | kCanRemove | kIsStatic },                     // BLUE

    // horizontal 16*256
    { 0,    FACETX2,              BAR_W, BAR_H,   kHorizBarSprite | kMustRemove | kCanRemove | kIsStatic },     // RED
    { 0,    FACETX2 + BAR_H,      BAR_W, BAR_H,   kHorizBarSprite | kMustKeep | kCanRemove | kIsStatic },       // GREEN
    { 0,    FACETX2 + (BAR_H*2),  BAR_W, BAR_H,   kHorizBarSprite | kCanRemove | kIsStatic },                   // BLUE

    // vertical 16*256
    { 0,        VBARS,  BAR_H, BAR_W,   kVertBarSprite | kMustRemove | kCanRemove | kIsStatic },                // RED
    { BAR_H,    VBARS,  BAR_H, BAR_W,   kVertBarSprite | kMustKeep | kCanRemove | kIsStatic },                  // GREEN
    { BAR_H*2,  VBARS,  BAR_H, BAR_W,   kVertBarSprite | kCanRemove | kIsStatic },                              // BLUE
    
    // horizontal 16x128
    { HBAR3,    VBARS,              BAR_W2, BAR_H, kHorizBarSprite | kMustRemove | kCanRemove | kIsStatic },    // RED
    { HBAR3,    VBARS+BAR_H,        BAR_W2, BAR_H, kHorizBarSprite | kMustKeep | kCanRemove | kIsStatic },      // GREEN
    { HBAR3,    VBARS+(BAR_H*2),    BAR_W2, BAR_H, kVertBarSprite | kCanRemove | kIsStatic },                   // BLUE

    // horizontal 16x64
    { HBAR3+BAR_W2,    VBARS,               BAR_W3, BAR_H, kHorizBarSprite | kMustRemove | kCanRemove | kIsStatic },    // RED
    { HBAR3+BAR_W2,    VBARS+BAR_H,         BAR_W3, BAR_H, kHorizBarSprite | kMustKeep | kCanRemove | kIsStatic },      // GREEN
    { HBAR3+BAR_W2,    VBARS+(BAR_H*2),     BAR_W3, BAR_H, kVertBarSprite | kCanRemove | kIsStatic },                   // BLUE
   
    // vertical 16*128
    { HBAR3,            VBARS2, BAR_H, BAR_W2,  kVertBarSprite | kMustRemove | kCanRemove | kIsStatic },        // RED
    { HBAR3+BAR_H,      VBARS2, BAR_H, BAR_W2,  kVertBarSprite | kMustKeep | kCanRemove | kIsStatic },          // GREEN
    { HBAR3+(BAR_H*2),  VBARS2, BAR_H, BAR_W2,  kVertBarSprite | kCanRemove | kIsStatic },                      // BLUE
    
    // vertical 16*64
    { HBAR3,            VBARS2+BAR_W2, BAR_H, BAR_W3,  kVertBarSprite | kMustRemove | kCanRemove | kIsStatic },     // RED
    { HBAR3+BAR_H,      VBARS2+BAR_W2, BAR_H, BAR_W3,  kVertBarSprite | kMustKeep | kCanRemove | kIsStatic },       // GREEN
    { HBAR3+(BAR_H*2),  VBARS2+BAR_W2, BAR_H, BAR_W3,  kVertBarSprite | kCanRemove | kIsStatic },                   // BLUE

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
#ifndef NDEBUG
    NSLog(@"dealloc sprite %@, shape=%d",self,_shape);
#endif

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
    CGPoint ap;
    int posx, posy;
    int stype;

    SpriteInfo *sp = &sprites[kind-1];
    posx = sp->posx;
    posy = sp->posy;

    stype = (sp->attrib & kSpriteKindMask);

    ShapeSprite *sprite = [ShapeSprite spriteWithSpriteSheet:sheet rect:CGRectMake(posx, posy, sp->width, sp->height)];
//    if (stype == kVertBarSprite) {
//        x -= BAR_H / 2;
//        y -= BAR_W / 2;
//    }
//    else if (stype == kHorizBarSprite) {
//        y -= BAR_H / 2;
//    }
    ap = sprite.anchorPointInPixels;
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
