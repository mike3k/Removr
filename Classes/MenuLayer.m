//
//  MenuLayer.m
//  Blocks
//
//  Created by Mike Cohen on 5/10/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "MenuLayer.h"
#import "GameManager.h"

@implementation MenuLayer

@synthesize menu = _menu;

- (void) dealloc
{
	[_menu release];
	[super dealloc];
}

- (id) init
{
    if ((self = [super init])) {

        self.background = [[[CCSprite alloc] initWithFile:@"menu.png"] autorelease];
        
        CCMenuItemImage *logo = [CCMenuItemImage itemFromNormalImage:@"logo-menu.png" 
                                                       selectedImage:@"logo-menu.png"];
        
        
        CCMenuItemImage *play = [CCMenuItemImage itemFromNormalImage:@"button-play.png" 
                                                       selectedImage:@"button-play-sel.png" 
                                                              target:_delegate 
                                                            selector:@selector(play:)];

        CCMenuItemImage *score = [CCMenuItemImage itemFromNormalImage:@"button-highscores.png" 
                                                        selectedImage:@"button-highscores-sel.png" 
                                                               target:_delegate 
                                                             selector:@selector(highscores:)];
        
        CCMenuItemImage *opt = [CCMenuItemImage itemFromNormalImage:@"button-options.png" 
                                                       selectedImage:@"button-options-sel.png" 
                                                              target:_delegate 
                                                            selector:@selector(options:)];
        
        CCMenuItemImage *more = [CCMenuItemImage itemFromNormalImage:@"button-more.png" 
                                                       selectedImage:@"button-more-sel.png" 
                                                              target:_delegate 
                                                            selector:@selector(info:)];
        self.menu = [CCMenu menuWithItems: logo, play, score, opt, more, nil];
        [_menu alignItemsVertically];
        [self addChild:_menu];
        
    }
    return self;
}

+ (CCMenuItemFont *) getSpacerItem
{
	[CCMenuItemFont setFontSize:2];
	return [CCMenuItemFont itemFromString:@" " target:self selector:nil];
}

//- (void)play:(id)sender
//{
//    if ([_delegate respondsToSelector:@selector(play:)]) {
//        [_delegate play: sender];
//    }
//}
//
//- (void)highscores:(id)sender
//{
//    if ([_delegate respondsToSelector:@selector(highscores:)]) {
//        [_delegate highscores: sender];
//    }
//}
//
//- (void)options:(id)sender
//{
//    if ([_delegate respondsToSelector:@selector(options:)]) {
//        [_delegate options: sender];
//    }
//}
//
//- (void)info:(id)sender
//{
//    if ([_delegate respondsToSelector:@selector(options:)]) {
//        [_delegate options: sender];
//    }
//}

@end
