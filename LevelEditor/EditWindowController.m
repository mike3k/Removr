//
//  EditWindowController.m
//  LevelEditor
//
//  Created by Mike Cohen on 7/10/10.
//  Copyright 2010 MC Development. All rights reserved.
//

#import "EditWindowController.h"
#import "LevelMap.h"
#import "EditView.h"
#import "Level.h"

@implementation EditWindowController

@synthesize window;
@synthesize theEditView;
@synthesize theLevelMap;
@synthesize title;
@synthesize levels;
@synthesize curLevel;
@synthesize rowid;
@synthesize par;
@synthesize timeLimit;
@synthesize achievement;
@synthesize timeLimitAchievement;
@synthesize moveAchievement;

- (NSNumber*) dbopen { return [NSNumber numberWithBool:(nil != db)]; }

- (NSNumber*) levelSelected { 
    return [NSNumber numberWithBool:((nil != db) && ([theTableView selectedRow] >= 0))]; 
}

- (id) init
{
    self = [super init];
    if (self) {
        self.theLevelMap = [[LevelMap alloc] init];
        self.curLevel = -1;
        self.rowid = -1;
        [self addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"par" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"timeLimit" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"achievement" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"timeLimitAchievement" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"moveAchievement" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc
{
    [self cleanup_database];

    if (nil != select)
        sqlite3_finalize(select);
    
    if (nil != update)
        sqlite3_finalize(update);
    
    if (nil != insert)
        sqlite3_finalize(insert);

    if (nil != delete)
        sqlite3_finalize(delete);
    
    if (nil != vacuum)
        sqlite3_finalize(vacuum);
    
    if (nil != allrecords)
        sqlite3_finalize(allrecords);

    if (nil != db)
        sqlite3_close(db);
    
    [levels release];
    [theLevelMap release];

    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //NSLog(@"value of %@ changed: %@",object,change);
    theLevelMap.dirty = YES;
    if ([keyPath isEqualToString:@"title"]) {
        Level *theLevel = [levels objectAtIndex:[theTableView selectedRow]];
        theLevel.title = self.title;
        [theTableView reloadDataForRowIndexes:[theTableView selectedRowIndexes] columnIndexes:[theTableView selectedColumnIndexes]];
    }
}

- (void) awakeFromNib
{
    theEditView.theLevelMap = self.theLevelMap;
}

- (IBAction) OpenDatabase: (id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"sqlite3", @"db", @"leveldb",nil]];
    if ([openPanel runModal] == NSFileHandlingPanelOKButton) {
        [self willChangeValueForKey:@"dbopen"];
        [self open_database: [[openPanel URL] path] create:NO];
        [self didChangeValueForKey:@"dbopen"];
    }
}

- (IBAction) NewDatabase: (id)sender
{
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"leveldb"]];
    if ([savePanel runModal] == NSFileHandlingPanelOKButton) {
        [self willChangeValueForKey:@"dbopen"];
        [self open_database: [[savePanel URL] path] create:YES];
        [self didChangeValueForKey:@"dbopen"];
    }
}

- (IBAction) PrintLevel: (id)sender
{
}

- (IBAction) SaveLevelImage: (id)sender
{
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"png"]];
    if ([savePanel runModal] == NSFileHandlingPanelOKButton) {
        NSData* theData = [theEditView getImageData];
        [theData writeToURL:[savePanel URL] atomically:YES];
    }
}

- (IBAction) DeleteLevel: (id)sender
{
    int result;
    if (rowid > 0) {
        result = sqlite3_reset(delete);
        result = sqlite3_bind_int(delete, 1, rowid);
        result = sqlite3_step(delete);

        theLevelMap.dirty = NO;
        //[theLevelMap clear];
        [theEditView clearMap:self];
        self.rowid = -1;
        [theTableView deselectAll:self];
        [self cleanup_database];
        [self reloadTable];
    }
}

- (IBAction) NewLevel: (id)sender
{
    if (theLevelMap.dirty) {
        [self SaveLevel:self];
    }
    self.rowid = -1;
    self.curLevel = -1;
    self.title = @"New Level";
    Level *level = [[Level alloc] init];
    level.index = self.rowid;
    level.title = self.title;
    level.achievement = self.achievement;
    level.timeLimit = self.timeLimit;
    level.flags = ((timeLimitAchievement ? TimeLimitAchievement : 0) | (moveAchievement ? MoveNumberAchievement : 0));
    [levels addObject: level];
    [theTableView reloadData];
    [level release];
    [theLevelMap clear];
    [theEditView setNeedsDisplay:YES];
    [self willChangeValueForKey:@"levelSelected"];
    [theTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:[levels count]-1] byExtendingSelection:NO];
    [self didChangeValueForKey:@"levelSelected"];
    [theTableView scrollRowToVisible:[theTableView selectedRow]];
    theLevelMap.dirty = YES;
}

- (IBAction) SaveLevel: (id)sender
{
    int result;
    NSData *data = [theLevelMap encode];
    NSInteger flags = ((timeLimitAchievement ? TimeLimitAchievement : 0) | (moveAchievement ? MoveNumberAchievement : 0));
    if (rowid <= 0) {
        // insert
        result = sqlite3_reset(insert);
        result = sqlite3_bind_text(insert, 1, [title UTF8String], -1, SQLITE_STATIC);
        result = sqlite3_bind_blob(insert, 2, [data bytes], [data length], SQLITE_STATIC);
        result = sqlite3_bind_int(insert, 3, par);
        result = sqlite3_bind_double(insert, 4, timeLimit);
        result = sqlite3_bind_text(insert, 5, [achievement UTF8String], -1, SQLITE_STATIC);
        result = sqlite3_bind_int(insert, 6, flags);
        result = sqlite3_step(insert);
        self.rowid = sqlite3_last_insert_rowid(db);
        [self cleanup_database];
        [self reloadTable];
        NSLog(@"inserting new level");
    }
    else {
        // update
        result = sqlite3_reset(update);
        result = sqlite3_bind_text(update, 1, [title UTF8String], -1, SQLITE_STATIC);
        result = sqlite3_bind_blob(update, 2, [data bytes], [data length], SQLITE_STATIC);
        result = sqlite3_bind_int(update, 3, par);
        result = sqlite3_bind_double(update, 4, timeLimit);
        result = sqlite3_bind_text(update, 5, [achievement UTF8String], -1, SQLITE_STATIC);
        result = sqlite3_bind_int(update, 6, flags);
        result = sqlite3_bind_int(update, 7, rowid);
        result = sqlite3_step(update);
        NSLog(@"saving level %d",rowid);
        [self reloadTable];
    }
    theLevelMap.dirty = NO;
}

- (void) cleanup_database
{
    sqlite3_reset(vacuum);
    sqlite3_step(vacuum);
}


- (IBAction) tableSelect: (id)sender
{
//    NSLog(@"table select");
//    curLevel = [theTableView clickedRow];
//    [self willChangeValueForKey:@"levelSelected"];
}

// TableViewDelegate

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex
{
    [self willChangeValueForKey:@"LevelSelected"];
    
    return YES;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    NSInteger newlevel = [theTableView selectedRow];
    Level *theLevel;
    
    if (theLevelMap.dirty) {
        [self SaveLevel:self];
    }
//    [self willChangeValueForKey:@"LevelSelected"];
    if (newlevel >= 0) {
        theLevel = [levels objectAtIndex:newlevel];
        [theLevelMap load:theLevel.map];
        [theEditView setNeedsDisplay:YES];
        self.rowid = theLevel.index;
        self.title = theLevel.title;
        self.par = theLevel.par;
        self.achievement = theLevel.achievement;
        self.timeLimit = theLevel.timeLimit;
        int flags = theLevel.flags;
        self.timeLimitAchievement = ((flags & TimeLimitAchievement) != 0);
        self.moveAchievement = ((flags & MoveNumberAchievement) != 0);
        self.curLevel = newlevel;
        theLevelMap.dirty = NO;
    }
    [self didChangeValueForKey:@"levelSelected"];
    BOOL shouldEnable = ([theTableView selectedRow] >= 0);
    [deleteButton setEnabled: shouldEnable];
    [exportButton setEnabled: shouldEnable];
    [imageButton setEnabled: shouldEnable];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
//    if (rowIndex == [aTableView selectedRow]) {
//        return self.title;
//    }
    Level *theLevel = [levels objectAtIndex:rowIndex];
    return theLevel.title;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [levels count];
}

#define SQLITE_PREPARE(DB,SQL,X,STMT,Y)   { int result = sqlite3_prepare_v2(DB,SQL,X,STMT,Y); if (result != SQLITE_OK) printf("SQLITE ERROR: %s",sqlite3_errmsg(DB)); }

#define SQLITE_STEP(X)  { int result = sqlite3_step(X); if ((result != SQLITE_OK) && (result != SQLITE_DONE) && (result != SQLITE_ROW)) printf("SQLite Error: %s",sqlite3_errmsg(db)); }


static char * delete_sql = "DELETE FROM levels WHERE rowid=?;";
//SELECT rowid,background,map,name,par,timeLimit,achievement FROM levels WHERE ROWID=?
static char * select_sql = "SELECT rowid,name,map,par,timeLimit,achievement,flags FROM levels WHERE name=?;";
static char * update_sql = "UPDATE levels SET name=?, map=?, par=?, timeLimit=?, achievement=?, flags=? WHERE rowid=?;";
static char * insert_sql = "INSERT INTO levels (name,map,par,timeLimit,achievement,flags) VALUES (?,?,?,?,?,?);";
static char * create_sql = "CREATE TABLE levels (background text,map blob NOT NULL,name text,par integer DEFAULT 0,tutorial boolean DEFAULT NO,timeLimit double DEFAULT 0,achievement text,flags integer DEFAULT 0,idx integer DEFAULT 0);";
static char * allrecords_sql = "SELECT rowid,name,map,par,timeLimit,achievement,flags FROM levels;";
static char * vacuum_sql = "VACUUM;";

- (BOOL) open_database: (NSString *)name create:(BOOL)create
{
    sqlite3_stmt *create_db;

    // close current database, if any
    if (nil != db) {
        if (theLevelMap.dirty) {
            [self SaveLevel:self];
        }
        [self cleanup_database];
        sqlite3_finalize(select);
        sqlite3_finalize(update);
        sqlite3_finalize(insert);
        sqlite3_finalize(delete);
        sqlite3_finalize(vacuum);
        sqlite3_finalize(allrecords);
        sqlite3_close(db);
        select = update = insert = delete = allrecords = nil;
        db = nil;
    }

    sqlite3_open([name UTF8String], &db);
    
    if (YES == create) {
        self.levels = [NSMutableArray arrayWithCapacity:1];
        SQLITE_PREPARE(db, create_sql, -1, &create_db, nil);
        SQLITE_STEP(create_db);
        sqlite3_finalize(create_db);
    }

    
    // prepare the SQL statements
    SQLITE_PREPARE(db, select_sql, -1, &select, nil);
    SQLITE_PREPARE(db, update_sql, -1, &update, nil);
    SQLITE_PREPARE(db, insert_sql, -1, &insert, nil);
    SQLITE_PREPARE(db, allrecords_sql, -1, &allrecords, nil);
    SQLITE_PREPARE(db, delete_sql, -1, &delete, nil);
    SQLITE_PREPARE(db, vacuum_sql, -1, &vacuum, nil);

    [theEditView clearMap:self];

    [self reloadTable];

    curLevel = -1;
    
    return YES;
}

- (IBAction) ImportLevel: (id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"sql", @"txt", nil]];
    if ([openPanel runModal] == NSFileHandlingPanelOKButton) {
        NSString *sql = [NSString stringWithContentsOfURL:[openPanel URL] encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"read SQL: %@",sql);
        const char *sqlstr = [sql UTF8String], *nextsql;
        sqlite3_stmt *import;
        while (sql && (SQLITE_OK == sqlite3_prepare_v2(db, sqlstr, -1, &import, &nextsql)) ) {
            int result = sqlite3_step(import);
            if ((result != SQLITE_DONE) && (result != SQLITE_ROW))
                break;
            sqlite3_reset(import);
            sqlstr = nextsql;
        }
        sqlite3_finalize(import);
    }
    [self reloadTable];
}

- (IBAction) ExportLevel: (id)sender
{
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setAllowedFileTypes:[NSArray arrayWithObjects:@"sql", @"txt", nil]];
    if ([savePanel runModal] == NSFileHandlingPanelOKButton) {
        NSString *sql = [theEditView sqlText];
        NSLog(@"Exporting SQL: %@",sql);
        [sql writeToURL:[savePanel URL] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

- (void)reloadTable
{
    NSLog(@"reloading data");
    self.levels = [NSMutableArray arrayWithCapacity:1];
    sqlite3_reset(allrecords);
    while (sqlite3_step(allrecords) == SQLITE_ROW) {
        Level *level = [[Level alloc] init];
        char *cstr = (char*)sqlite3_column_text(allrecords, 1);
        level.index = sqlite3_column_int(allrecords, 0);
        if (cstr && cstr[0]) {
            level.title = [NSString stringWithCString:cstr encoding:NSUTF8StringEncoding];
        }
        else {
            level.title = nil;
        }
        void *blob = (void*)sqlite3_column_blob(allrecords, 2);
        int blobsize = sqlite3_column_bytes(allrecords, 2);
        level.map = [NSData dataWithBytes:blob length:blobsize];
        level.par = sqlite3_column_int(allrecords, 3);
        level.timeLimit = sqlite3_column_double(allrecords, 4);
        cstr = (char*)sqlite3_column_text(allrecords, 5);
        if (cstr && cstr[0]) {
            level.achievement = [NSString stringWithCString:cstr encoding:NSUTF8StringEncoding];
        }
        else {
            level.achievement = nil;
        }
        [levels addObject: level];
        [level release];
    }
    [theTableView reloadData];
}


@end
