//
//  OnOffButton.m
//  Removr
//
//  Created by Mike Cohen on 6/25/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "OnOffButton.h"


@implementation OnOffButton

+ (OnOffButton*) makeButtonWithTarget: (id)t selector: (SEL)s
{
    CCMenuItemImage *onButton;
    CCMenuItemImage *offButton;
    
    CGFloat _scale = [[UIScreen mainScreen] scale];
    if (_scale > 1) {
        onButton = [CCMenuItemImage itemFromNormalImage:@"on@x2.png" selectedImage:@"on-sel@x2.png"];
        offButton = [CCMenuItemImage itemFromNormalImage:@"off@x2.png" selectedImage:@"off-sel@x2.png"];
    }
    else {
        onButton = [CCMenuItemImage itemFromNormalImage:@"on.png" selectedImage:@"on-sel.png"];
        offButton = [CCMenuItemImage itemFromNormalImage:@"off.png" selectedImage:@"off-sel.png"];
    }
    OnOffButton *b = [OnOffButton itemWithTarget:t selector:s items: offButton, onButton, nil];
    return b;
}

- (BOOL) on
{
    return (self.selectedIndex == 1);
}

- (void) setOn: (BOOL)value
{
    self.selectedIndex = value ? 1 : 0;
}

//- (NSString*)title
//{
//}
//
//- (void)setTitle: (NSString*)value
//{
//    if (nil != m) {
//        m = [CCMenu menuWithItems: [CCMenuItemImage itemFromNormalImage:value selectedImage:value], self, nil];
//        [m alignItemsHorizontallyWithPadding: 0.5];
//    }
//    else {
//    }
//}

@end
