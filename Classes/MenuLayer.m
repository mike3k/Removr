//
//  MenuLayer.m
//  Blocks
//
//  Created by Mike Cohen on 5/10/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "MenuLayer.h"
#import "GameManager.h"
#import "AppSettings.h"

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
        NSString *tmp;

        self.background = [[[CCSprite alloc] initWithFile:[self scaledFile:@"menu.png"]] autorelease];
        
        tmp = [self scaledFile:@"logo-menu.png"];
        
        CCMenuItemImage *logo = [CCMenuItemImage itemFromNormalImage:tmp
                                                       selectedImage:tmp];
        
        
        CCMenuItemImage *play = [CCMenuItemImage itemFromNormalImage:[self scaledFile: @"button-play.png"]
                                                       selectedImage:[self scaledFile: @"button-play-sel.png"]
                                                              target:_delegate 
                                                            selector:@selector(play:)];

        CCMenuItemImage *score = [CCMenuItemImage itemFromNormalImage:[self scaledFile: @"button-highscores.png"]
                                                        selectedImage:[self scaledFile: @"button-highscores-sel.png"] 
                                                               target:_delegate 
                                                             selector:@selector(highscores:)];
        
        CCMenuItemImage *opt = [CCMenuItemImage itemFromNormalImage:[self scaledFile: @"button-options.png"] 
                                                       selectedImage:[self scaledFile: @"button-options-sel.png"]
                                                              target:_delegate 
                                                            selector:@selector(options:)];
        
        CCMenuItemImage *more = [CCMenuItemImage itemFromNormalImage:[self scaledFile: @"button-more.png"]
                                                       selectedImage:[self scaledFile: @"button-more-sel.png"] 
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
