//
//  OnOffButton.h
//  Removr
//
//  Created by Mike Cohen on 6/25/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "cocos2d.h"
#import "chipmunk.h"


@interface OnOffButton : CCMenuItemToggle {
}

+ (OnOffButton*) makeButtonWithTarget: (id)t selector: (SEL)s;

@property (assign,nonatomic) BOOL on;

@end
