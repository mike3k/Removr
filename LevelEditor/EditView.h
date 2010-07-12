//
//  EditView.h
//  LevelEditor
//
//  Created by Mike Cohen on 7/4/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LevelMap.h"

@interface EditView : NSView {
    LevelMap *theLevelMap;
    
    UInt32 currentPiece;
}

@property (assign) UInt32 currentPiece;
@property (assign) LevelMap * theLevelMap;

- (IBAction)clearMap:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)load:(id)sender;

- (IBAction)choose: (id)sender;

//- (NSData*)encodeMap;
//- (void)decodeMap:(NSData*)coded;
//- (NSString*)dumpText;
//
- (void)dumpsql;
- (NSString*)sqlText;


@end
