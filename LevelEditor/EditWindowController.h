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
    IBOutlet NSView * backgroundView;
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
    
    NSInteger par;
    NSInteger curLevel;
    NSInteger rowid;
    
    double timeLimit;
    
    NSString *achievement;
    
    NSInteger timeLimitAchievement;
    NSInteger moveAchievement;
}

@property (assign) NSWindow * window;
@property (assign) EditView * theEditView;
@property (assign) LevelMap * theLevelMap;
@property (retain,nonatomic) NSMutableArray * levels;
@property (assign) NSInteger curLevel;
@property (assign) NSInteger rowid;
@property (assign) NSInteger par;
@property (assign) double timeLimit;
@property (retain,nonatomic) NSString * achievement;

@property (assign,nonatomic) NSInteger timeLimitAchievement;
@property (assign,nonatomic) NSInteger moveAchievement;

@property (readonly) NSNumber* dbopen;
@property (readonly) NSNumber* levelSelected;

@property (retain,nonatomic) NSString * title;

- (IBAction) OpenDatabase: (id)sender;
- (IBAction) NewDatabase: (id)sender;
- (IBAction) NewLevel: (id)sender;
- (IBAction) SaveLevel: (id)sender;
- (IBAction) DeleteLevel: (id)sender;
- (IBAction) PrintLevel: (id)sender;
- (IBAction) SaveLevelImage: (id)sender;

- (IBAction) ImportLevel: (id)sender;
- (IBAction) ExportLevel: (id)sender;

- (IBAction) tableSelect: (id)sender;

- (BOOL) open_database: (NSString *)name create:(BOOL)create;
- (void) reloadTable;

- (void) cleanup_database;


@end
