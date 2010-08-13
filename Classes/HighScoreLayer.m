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
#import "AppSettings.h"

@interface HighScoreLayer (private)

- (void)updateItem: (LevelMenuItem*)itm forLevel: (int)theLevel;

@end

#undef FORCE_ALL_LEVELS

@implementation HighScoreLayer

- (void)updateItem: (LevelMenuItem*)itm forLevel: (int)theLevel
{
    int theScore = [_delegate scoreForLevel: theLevel];
    itm.level = theLevel+1;
#ifdef FORCE_ALL_LEVELS
    if (theLevel < [_delegate levelCount])
#else
    if (theLevel <= MIN([[AppSettings shared] highestLevel],[_delegate levelCount]-1))
#endif
    {
        itm.moves = theScore;
        //[itm setOpacity:255];
        [itm setIsEnabled:YES];
    }
    else {
        itm.moves = 0;
        //[itm setOpacity: 64];
        [itm setIsEnabled: NO];
    }
    itm.visible = (theLevel < [_delegate levelCount]);
}

- (id)init
{
    
    if ((self = [super init])) {
        NSString *spacer = [self scaledFile:@"spacer.png"];
        _buttons = [[NSMutableArray alloc] init];
        self.background = [[[CCSprite alloc] initWithFile:[self scaledFile: @"background.png"]] autorelease];
        CGSize wins = [[CCDirector sharedDirector] winSize];
        
        CCMenu *menu = [CCMenu menuWithItems: [CCMenuItemImage itemFromNormalImage:spacer selectedImage:spacer],nil];
        for (int i=0;i<12;++i) {
            int theLevel = _page + i;
            LevelMenuItem *itm = [LevelMenuItem itemFromNormalImage:[self scaledFile: @"levelbutton.png"]
                                                      selectedImage:[self scaledFile: @"levelbutton-sel.png"]
                                                               target:self
                                                             selector:@selector(gotoLevel:)];
            [_buttons addObject:itm];
            [menu addChild:itm z:1 tag:0];
            [self updateItem:itm forLevel:theLevel];
        }

        [menu addChild:[CCMenuItemImage itemFromNormalImage:spacer selectedImage:spacer] z:1 tag:0];

        bPrev = [MCMenuItem itemFromNormalImage:[self scaledFile: @"button-prev.png"]
                                  selectedImage:[self scaledFile: @"button-prev-sel.png"]
                                         target:self 
                                       selector:@selector(pageBack:)];
        [bPrev setIsEnabled:NO];
        [menu addChild:bPrev z:1 tag:0];
    
        bNext = [MCMenuItem itemFromNormalImage:[self scaledFile: @"button-next.png"]
                                  selectedImage:[self scaledFile: @"button-next-sel.png"] 
                                         target:self selector:@selector(pageNext:)];
        [bNext setIsEnabled:([_delegate levelCount] > 12)];
        [menu addChild:bNext z:1 tag:0];
        
        [menu addChild:[CCMenuItemImage itemFromNormalImage:spacer selectedImage:spacer] z:1 tag:0];
      
        [menu alignItemsInColumns:  [NSNumber numberWithInt:1], 
                                    [NSNumber numberWithInt:4],
                                    [NSNumber numberWithInt:4],
                                    [NSNumber numberWithInt:4],
                                    [NSNumber numberWithInt:1], 
                                    [NSNumber numberWithInt:2],
                                    [NSNumber numberWithInt:1], 
                                    nil];
        [self addChild:menu z: zMenuLayer];
        
        CCMenu *menu2 = [CCMenu menuWithItems: [CCMenuItemImage itemFromNormalImage:[self scaledFile: @"back.png"]
                                                                     selectedImage:[self scaledFile: @"back-sel.png"] 
                                                                            target:_delegate 
                                                                          selector:@selector(menu:)], nil];
        [menu2 alignItemsVertically];
        menu2.position = ccp(wins.width-(60*_scale), 30*_scale);
        [self addChild:menu2 z: zMenuLayer];
        if ([self addClouds]) {
            [self moveClouds];
        }
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
