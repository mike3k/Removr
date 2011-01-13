//
//  HighScoreLayer.h
//  Removr
//
//  Created by Mike Cohen on 5/28/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "MCLayer.h"

@interface HighScoreLayer : MCLayer {
    NSMutableArray *_buttons;
    int _page;
    
    CCMenuItem *bPrev;
    CCMenuItem *bNext;
}

- (void)gotoLevel: (id)sender;
- (void)resetButtons;
- (void)pageNext: (id)sender;
- (void)pageBack: (id)sender;
@end
