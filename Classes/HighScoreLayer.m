//
//  HighScoreLayer.m
//  Removr
//
//  Created by Mike Cohen on 5/28/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "HighScoreLayer.h"
#import "LevelMenuItem.h"
#import "MCMenuItem.h"

@interface HighScoreLayer (private)

- (void)updateItem: (LevelMenuItem*)itm forLevel: (int)theLevel;

@end


@implementation HighScoreLayer

- (void)updateItem: (LevelMenuItem*)itm forLevel: (int)theLevel
{
    int theScore = [_delegate scoreForLevel: theLevel];
    itm.level = theLevel+1;
    if (theLevel < [_delegate levelCount] && (theScore != 0)) {
        itm.moves = theScore;
        //[itm setOpacity:255];
        [itm setIsEnabled:YES];
    }
    else {
        itm.moves = 0;
        //[itm setOpacity: 64];
        [itm setIsEnabled: NO];
    }
}

- (id)init
{
    
    
    if ((self = [super init])) {
        _buttons = [[NSMutableArray alloc] init];
        self.background = [[[CCSprite alloc] initWithFile:@"background.png"] autorelease];
        CGSize wins = [[CCDirector sharedDirector] winSize];
        
        CCMenu *menu = [CCMenu menuWithItems: [CCMenuItemImage itemFromNormalImage:@"spacer.png" selectedImage:@"spacer.png"],nil];
        for (int i=0;i<12;++i) {
            int theLevel = _page + i;
            LevelMenuItem *itm = [LevelMenuItem itemFromNormalImage:@"levelbutton.png"
                                                        selectedImage:@"levelbutton-sel.png"
                                                               target:self
                                                             selector:@selector(gotoLevel:)];
//            itm.level = theLevel+1;
//            if (theLevel < [_delegate levelCount]) {
//                itm.moves = [_delegate scoreForLevel: theLevel];
//            }
//            else {
//                [itm setOpacity: 64];
//                [itm setIsEnabled: NO];
//            }
            [_buttons addObject:itm];
            [menu addChild:itm z:0 tag:0];
            [self updateItem:itm forLevel:theLevel];
        }

        [menu addChild:[CCMenuItemImage itemFromNormalImage:@"spacer.png" selectedImage:@"spacer.png"] z:0 tag:0];

        bPrev = [MCMenuItem itemFromNormalImage:@"button-prev.png"
                                  selectedImage:@"button-prev-sel.png" 
                                         target:self 
                                       selector:@selector(pageBack:)];
        [bPrev setIsEnabled:NO];
        [menu addChild:bPrev z:0 tag:0];
    
        bNext = [MCMenuItem itemFromNormalImage:@"button-next.png" 
                                  selectedImage:@"button-next-sel.png" 
                                         target:self selector:@selector(pageNext:)];
        [bNext setIsEnabled:([_delegate levelCount] > 12)];
        [menu addChild:bNext z:0 tag:0];
        
        [menu addChild:[CCMenuItemImage itemFromNormalImage:@"spacer.png" selectedImage:@"spacer.png"] z:0 tag:0];
      
        [menu alignItemsInColumns:  [NSNumber numberWithInt:1], 
                                    [NSNumber numberWithInt:4],
                                    [NSNumber numberWithInt:4],
                                    [NSNumber numberWithInt:4],
                                    [NSNumber numberWithInt:1], 
                                    [NSNumber numberWithInt:2],
                                    [NSNumber numberWithInt:1], 
                                    nil];
        [self addChild:menu];
        
        CCMenu *menu2 = [CCMenu menuWithItems: [CCMenuItemImage itemFromNormalImage:@"back.png" 
                                                                     selectedImage:@"back-sel.png" 
                                                                            target:_delegate 
                                                                          selector:@selector(menu:)], nil];
        [menu2 alignItemsVertically];
        menu2.position = ccp(wins.width-60, 30);
        [self addChild:menu2];
    }
    return self;
}

- (void)resetButtons
{
    for (int i=0;i<12;++i) {
        int theLevel = _page + i;
        LevelMenuItem *itm = [_buttons objectAtIndex:i];
        [self updateItem:itm forLevel:theLevel];
    }
    [bPrev setIsEnabled: (_page > 0)];
    [bNext setIsEnabled: ((_page+12) < [_delegate levelCount])];
}

- (void)pageNext: (id)sender
{
    _page += 12;
    [self resetButtons];
}

- (void)pageBack: (id)sender
{
    if (_page > 0) {
        _page -= 12;
        [self resetButtons];
    }
}


- (void)gotoLevel: (id)sender
{
    if ([sender isKindOfClass:[LevelMenuItem class]]) {
        int level = [sender level];
        [_delegate playLevel:[NSNumber numberWithInt:level - 1]];
    }
}

- (void)dealloc
{
    [_buttons release];
    [super dealloc];
}

@end
