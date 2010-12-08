//
//  MenuLayer.h
//  Blocks
//
//  Created by Mike Cohen on 5/10/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "MCLayer.h"
#import "SpriteDefs.h"


@interface MenuLayer : MCLayer {
    CCMenu *_menu;
}

+ (CCMenuItemFont *) getSpacerItem;

//- (void)play:(id)sender;
//- (void)highscores:(id)sender;
//- (void)options:(id)sender;
//- (void)info:(id)sender;

- (void)showGameCenter: (id)sender;

@property (retain,nonatomic) CCMenu *menu;

@end
