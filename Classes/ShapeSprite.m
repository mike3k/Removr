//
//  ShapeSprite.m
//  Blocks
//
//  Created by Mike Cohen on 4/20/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "ShapeSprite.h"
#import "AppSettings.h"

#define FACETX2 (FACET*2)
#define FACETX3 (FACET*3)
#define FACETX4 (FACET*4)
#define FACETX5 (FACET*5)

#define PFACETX2 (F_SPACING+(PFACET*2))
#define PFACETX3 (F_SPACING+(PFACET*3))
#define PFACETX4 (F_SPACING+(PFACET*4))
#define PFACETX5 (F_SPACING+(PFACET*5))

#define PBARH   (F_SPACING+BAR_H)
#define PBARV   (F_SPACING+BAR_V)

#define HBAR3   (F_SPACING+(PBARH*3))
#define VBARS   (F_SPACING+(PFACET*2)+(PBARH*3))
#define VBARS2  (F_SPACING+(PFACET*2)+(PBARH*6))

static SpriteInfo sprites[] = {

    // circle
    { F_SPACING,              F_SPACING,   FACET, FACET,   kCircleSprite | kMustRemove },      // RED
    { F_SPACING+PFACET,       F_SPACING,   FACET, FACET,   kCircleSprite | kMustKeep },        // GREEN
    { PFACETX2,               F_SPACING,   FACET, FACET,   kCircleSprite },                    // BLUE
    
    // square
    { F_SPACING,        F_SPACING+PFACET,      FACET, FACET,   kSquareSprite | kMustRemove | kCanRemove | kIsStatic },     // RED
    { F_SPACING+PFACET, F_SPACING+PFACET,      FACET, FACET,   kSquareSprite | kMustKeep | kCanRemove | kIsStatic },       // GREEN
    { PFACETX2,         F_SPACING+PFACET,      FACET, FACET,   kSquareSprite | kCanRemove | kIsStatic },                   // BLUE

    // colorblind circle
    { PFACETX3,    F_SPACING,          FACET, FACET,   kCircleSprite | kMustRemove },        // RED
    { PFACETX4,    F_SPACING,          FACET, FACET,   kCircleSprite | kMustKeep },          // GREEN
    { PFACETX5,    F_SPACING,          FACET, FACET,   kCircleSprite },                      // BLUE

    // colorblind square
    { PFACETX3,    F_SPACING+PFACET,      FACET, FACET,   kSquareSprite | kMustRemove | kCanRemove | kIsStatic },       // RED
    { PFACETX4,    F_SPACING+PFACET,      FACET, FACET,   kSquareSprite | kMustKeep | kCanRemove | kIsStatic },         // GREEN
    { PFACETX5,    F_SPACING+PFACET,      FACET, FACET,   kSquareSprite | kCanRemove | kIsStatic },                     // BLUE

    // horizontal 16*256
    { F_SPACING,    PFACETX2,              BAR_W, BAR_H,   kHorizBarSprite | kMustRemove | kCanRemove | kIsStatic },     // RED
    { F_SPACING,    PFACETX2 + PBARH,      BAR_W, BAR_H,   kHorizBarSprite | kMustKeep | kCanRemove | kIsStatic },       // GREEN
    { F_SPACING,    PFACETX2 + (PBARH*2),  BAR_W, BAR_H,   kHorizBarSprite | kCanRemove | kIsStatic },                   // BLUE

    // vertical 16*256
    { F_SPACING,            VBARS,  BAR_H, BAR_W,   kVertBarSprite | kMustRemove | kCanRemove | kIsStatic },                // RED
    { F_SPACING+PBARH,      VBARS,  BAR_H, BAR_W,   kVertBarSprite | kMustKeep | kCanRemove | kIsStatic },                  // GREEN
    { F_SPACING+(PBARH*2),  VBARS,  BAR_H, BAR_W,   kVertBarSprite | kCanRemove | kIsStatic },                              // BLUE
    
    // horizontal 16x128
    { HBAR3,    VBARS,              BAR_W2, BAR_H, kHorizBarSprite | kMustRemove | kCanRemove | kIsStatic },    // RED
    { HBAR3,    VBARS+PBARH,        BAR_W2, BAR_H, kHorizBarSprite | kMustKeep | kCanRemove | kIsStatic },      // GREEN
    { HBAR3,    VBARS+(PBARH*2),    BAR_W2, BAR_H, kVertBarSprite | kCanRemove | kIsStatic },                   // BLUE

    // horizontal 16x64
    { F_SPACING+HBAR3+BAR_W2,    VBARS,               BAR_W3, BAR_H, kHorizBarSprite | kMustRemove | kCanRemove | kIsStatic },    // RED
    { F_SPACING+HBAR3+BAR_W2,    VBARS+PBARH,         BAR_W3, BAR_H, kHorizBarSprite | kMustKeep | kCanRemove | kIsStatic },      // GREEN
    { F_SPACING+HBAR3+BAR_W2,    VBARS+(PBARH*2),     BAR_W3, BAR_H, kVertBarSprite | kCanRemove | kIsStatic },                   // BLUE
   
    // vertical 16*128
    { HBAR3,            VBARS2,     BAR_H, BAR_W2,  kVertBarSprite | kMustRemove | kCanRemove | kIsStatic },        // RED
    { HBAR3+PBARH,      VBARS2,     BAR_H, BAR_W2,  kVertBarSprite | kMustKeep | kCanRemove | kIsStatic },          // GREEN
    { HBAR3+(PBARH*2),  VBARS2,     BAR_H, BAR_W2,  kVertBarSprite | kCanRemove | kIsStatic },                      // BLUE
    
    // vertical 16*64
    { HBAR3,            VBARS2+BAR_W2+F_SPACING, BAR_H, BAR_W3,  kVertBarSprite | kMustRemove | kCanRemove | kIsStatic },     // RED
    { HBAR3+PBARH,      VBARS2+BAR_W2+F_SPACING, BAR_H, BAR_W3,  kVertBarSprite | kMustKeep | kCanRemove | kIsStatic },       // GREEN
    { HBAR3+(PBARH*2),  VBARS2+BAR_W2+F_SPACING, BAR_H, BAR_W3,  kVertBarSprite | kCanRemove | kIsStatic },                   // BLUE

};

#define kUniqueSprites  (sizeof(sprites) / sizeof(SpriteInfo))

@implementation ShapeSprite

@synthesize shape = _shape, space = _space;
@synthesize canRemove = _canRemove, isStatic = _isStatic, isCircle = _isCircle;
@synthesize mustRemove = _mustRemove, mustKeep = _mustKeep;
@synthesize info = _info;

static CGFloat _scale = 0;

//#define _scale ([[UIScreen mainScreen] scale])

// override designated initializer
-(id)init
{
    if ((self = [super init])) {
        self.shape = nil;
        self.space = nil;
        if (0 == _scale) {
            _scale = [[AppSettings shared] scale];
        }
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

#define VECSIZE(X)  ((X/2)*_scale)

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
        shape = cpCircleShapeNew(body, (_info.width/2.0)*_scale, ccp(0,0));
        shape->e = 0.80f; shape->u = 0.30;
    }
    else {
        shape = cpPolyShapeNew(body, num, verts, CGPointZero);
//        if (IsBar(_attributes)) {
//            shape->e = 0.55f; shape->u = 0.45f;
//        }
//        else {
            shape->e = 0.5f; shape->u = 0.35f;
//        }
    }
	shape->data = self;
    self.shape = shape;
}

+ (ShapeSprite*)Sprite: (int)kind x:(float)x y:(float)y withSheet: (CCSpriteSheet*)sheet
{
    CGPoint ap;
    int posx, posy;
//    int stype;

    if (0 == _scale) {
        _scale = [[AppSettings shared] scale];
    }

    SpriteInfo *sp = &sprites[kind-1];
    posx = sp->posx * _scale;
    posy = sp->posy * _scale;

//    stype = (sp->attrib & kSpriteKindMask);

    ShapeSprite *sprite = [ShapeSprite spriteWithSpriteSheet:sheet rect:CGRectMake(posx, 
                                                                                   posy, 
                                                                                   sp->width*_scale, 
                                                                                   sp->height*_scale)];
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
