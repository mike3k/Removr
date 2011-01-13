//
//  GameManager+RandomLevel.m
//  Removr
//
//  Created by Mike Cohen on 8/14/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "GameManager.h"
#import "SpriteDefs.h"

typedef struct {
    UInt8 width;
    UInt8 height;
    UInt32 pieces[32];
} LevelPart;

static LevelPart parts[] = {
    { 2, 8, { StuffPiece(0,0,GreenSquare), StuffPiece(0,1,GreenSquare), StuffPiece(0,2,GreenSquare), StuffPiece(0,3,GreenSquare), 0L } },
    { 2, 8, { StuffPiece(0,0,RedSquare), StuffPiece(0,1,RedSquare), StuffPiece(0,2,RedSquare), StuffPiece(0,3,RedSquare), 0L, } },
    { 8, 2, { StuffPiece(0,0,GreenSquare), StuffPiece(1,0,GreenSquare), StuffPiece(2,0,GreenSquare), StuffPiece(3,0,GreenSquare), 0L } },
    { 8, 2, { StuffPiece(0,0,RedSquare), StuffPiece(1,0,RedSquare), StuffPiece(2,0,RedSquare), StuffPiece(3,0,RedSquare), 0L } },
};


/*
 
 1. Grab a random part from LevelParts
 2. Offset it by a random x,y position making sure that it's more than 'width' & 'height' from the edges
 3. Add it to the level being built
 4. Repeat 'n' times (random?)
 5. Drop red & green bals near the top
 
 */

@implementation GameManager (RandomLevel)

- (Level*)GetRandomLevel
{
    return nil;
}

@end
