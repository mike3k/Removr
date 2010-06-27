//
//  OptionsLayer.h
//  Blocks
//
//  Created by Mike Cohen on 5/26/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "MCLayer.h"
#import "SpriteDefs.h"
#import "OnOffButton.h"
#import "AppSettings.h"

@interface OptionsLayer : MCLayer {
    OnOffButton *bSound;
    OnOffButton *bAccel;
    
    AppSettings *aps;
}

- (void)toggleSound:(id)sender;
- (void)toggleAccel:(id)sender;

@end
