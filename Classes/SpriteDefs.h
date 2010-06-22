/*
 *  SpriteDefs.h
 *  Blocks
 *
 *  Created by Mike Cohen on 4/18/10.
 *  Copyright 2010 MC Development. All rights reserved.
 *
 */

#define kSquareSprite   0x00000001
#define kCircleSprite   0x00000002
#define kPolySprite     0x00000003
#define kHorizBarSprite 0x00000004
#define kVertBarSprite  0x00000005

#define kRedPiece       0x00000010
#define kGreenPiece     0x00000020
#define kBluePiece      0x00000030

#define kCanRemove      0x00001000
#define kIsStatic       0x00002000

#define kMustRemove     0x00010000
#define kMustKeep       0x00020000

#define kSpriteKindMask     0x0000000f
#define kSpriteColorMask    0x000000f0
#define kSpriteSolidMask    0x00000f00
#define kSpriteActionMask   0x0000f000
#define kSpriteRequireMask  0x000f0000

typedef struct {
    int     posx;
    int     posy;
    int     width;
    int     height;
    UInt32  attrib;
} SpriteInfo;

#define CanRemove(B)    ((B & kCanRemove) != 0)
#define IsStatic(B)     ((B & kIsStatic) != 0)
#define MustRemove(B)   ((B & kMustRemove) != 0)
#define MustKeep(B)     ((B & kMustKeep) != 0)
#define IsCircle(B)     ((B & kSpriteKindMask) == kCircleSprite)

#define kMapPieceMask       0x000000ff
#define kMapYMask           0x0000ff00
#define kMapXMask           0x00ff0000

#define StuffPiece(X,Y,P)   ( (X << 16) | (Y << 8) | P )

#define MapXValue(B)        ( (B&kMapXMask) >> 16 )
#define MapYValue(B)        ( (B&kMapYMask) >> 8 )
#define MapPieceValue(B)    ( B&kMapPieceMask )

#ifdef __IPAD__
#define FACET   64
#else
#define FACET   32
#define BAR_H   16
#define BAR_W   256
#endif

enum    {
    RedCircle    = 0,
    GreenCircle,
    BlueCircle,

    RedSquare,
    GreenSquare,
    BlueSquare,

    RedCircleCB,
    GreenCircleCB,
    BlueCircleCB,

    RedSquareCB,
    GreenSquareCB,
    BlueSquareCB,

    RedHorizBar,
    GreenHorizBar,
    BlueHorizBar,

    RedVertBar,
    GreenVertBar,
    BlueVertBar,
    
};

