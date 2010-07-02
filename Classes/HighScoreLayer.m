//
//  HighScoreLayer.m
//  Removr
//
//  Created by Mike Cohen on 5/28/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "HighScoreLayer.h"
#import "LevelMenuItem.h"

@implementation HighScoreLayer

- (id)init
{
    
    // TODO: Load buttons into an array
    // TODO: add page buttons
    
    if ((self = [super init])) {
        self.background = [[[CCSprite alloc] initWithFile:@"background.png"] autorelease];
        CGSize wins = [[CCDirector sharedDirector] winSize];
        
        CCMenu *menu = [CCMenu menuWithItems: [CCMenuItemImage itemFromNormalImage:@"spacer.png" selectedImage:@"spacer.png"],nil];
        for (int i=0;i<12;++i) {
            LevelMenuItem *itm = [LevelMenuItem itemFromNormalImage:@"levelbutton.png"
                                                        selectedImage:@"levelbutton.png"
                                                               target:self
                                                             selector:@selector(gotoLevel:)];
            itm.level = i+1;
            //itm.moves = [_delegate scoreForLevel: i];
            [menu addChild:itm z:0 tag:0];
        }
        [menu addChild:[CCMenuItemImage itemFromNormalImage:@"spacer.png" selectedImage:@"spacer.png"] z:0 tag:0];
        // this needs to be adjusted for more levels;
        [menu alignItemsInColumns:  [NSNumber numberWithInt:1], 
                                    [NSNumber numberWithInt:4],
                                    [NSNumber numberWithInt:4],
                                    [NSNumber numberWithInt:4],
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

- (void)gotoLevel: (id)sender
{
    if ([sender isKindOfClass:[LevelMenuItem class]]) {
        int level = [sender level];
        [_delegate playLevel:[NSNumber numberWithInt:level - 1]];
    }
}

@end
