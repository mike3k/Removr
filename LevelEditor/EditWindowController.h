//
//  EditWindowController.h
//  LevelEditor
//
//  Created by Mike Cohen on 7/10/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <sqlite3.h>

@class EditView;
@class LevelMap;

@interface EditWindowController : NSObject <NSTableViewDelegate, NSTableViewDataSource> {
    IBOutlet NSWindow * window;
    IBOutlet EditView * theEditView;
    IBOutlet NSTableView * theTableView;
    LevelMap * theLevelMap;

    NSString * title;
    sqlite3 * db;
    sqlite3_stmt * select;
    sqlite3_stmt * update;
    sqlite3_stmt * insert;
    sqlite3_stmt * delete;
    sqlite3_stmt * vacuum;
    sqlite3_stmt * allrecords;
    
    NSMutableArray * levels;
    
    NSInteger curLevel;
    NSInteger rowid;
}

@property (assign) NSWindow * window;
@property (assign) EditView * theEditView;
@property (assign) LevelMap * theLevelMap;
@property (retain,nonatomic) NSMutableArray * levels;
@property (assign) NSInteger curLevel;
@property (assign) NSInteger rowid;

@property (retain,nonatomic) NSString * title;

- (IBAction) OpenDatabase: (id)sender;
- (IBAction) NewDatabase: (id)sender;
- (IBAction) NewLevel: (id)sender;
- (IBAction) SaveLevel: (id)sender;
- (IBAction) DeleteLevel: (id)sender;

- (IBAction) tableSelect: (id)sender;

- (BOOL) open_database: (NSString *)name create:(BOOL)create;
- (void) reloadTable;

- (void) cleanup_database;


@end
