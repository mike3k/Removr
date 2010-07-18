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

- (NSNumber*) dbopen { return [NSNumber numberWithBool:(nil != db)]; }

- (NSNumber*) levelSelected { return [NSNumber numberWithBool:((nil != db) && ([theTableView selectedRow] >= 0))]; }

- (id) init
{
    self = [super init];
    if (self) {
        self.theLevelMap = [[LevelMap alloc] init];
        self.curLevel = -1;
        self.rowid = -1;
        [self addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
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
}

- (void) awakeFromNib
{
    theEditView.theLevelMap = self.theLevelMap;
}

- (IBAction) OpenDatabase: (id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowedFileTypes:[NSArray arrayWithObject:@"sqlite3"]];
    if ([openPanel runModal] == NSFileHandlingPanelOKButton) {
        [self willChangeValueForKey:@"dbopen"];
        [self open_database: [[openPanel URL] path] create:NO];
        [self didChangeValueForKey:@"dbopen"];
    }
}

- (IBAction) NewDatabase: (id)sender
{
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"sqlite3"]];
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
    [savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"pdf"]];
    if ([savePanel runModal] == NSFileHandlingPanelOKButton) {
        NSRect bounds = [theEditView bounds];
        NSData* theData = [theEditView dataWithPDFInsideRect:bounds];
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
        [self reloadTable];
        [self cleanup_database];
    }
}

- (IBAction) NewLevel: (id)sender
{
    self.rowid = -1;
    self.curLevel = -1;
    self.title = @"New Level";
    Level *level = [[Level alloc] init];
    level.rowid = self.rowid;
    level.name = self.title;
    [levels addObject: level];
    [theTableView reloadData];
    [level release];
    [theLevelMap clear];
    [theEditView setNeedsDisplay:YES];
    [theTableView selectRow:[levels count]-1 byExtendingSelection:NO];
}

- (IBAction) SaveLevel: (id)sender
{
    int result;
    NSData *data = [theLevelMap encode];
    if (rowid <= 0) {
        // insert
        result = sqlite3_reset(insert);
        result = sqlite3_bind_text(insert, 1, [title UTF8String], -1, SQLITE_STATIC);
        result = sqlite3_bind_blob(insert, 2, [data bytes], [data length], SQLITE_STATIC);
        result = sqlite3_step(insert);
        self.rowid = sqlite3_last_insert_rowid(db);
        [self reloadTable];
        [self cleanup_database];
        NSLog(@"inserting new level");
    }
    else {
        // update
        result = sqlite3_reset(update);
        result = sqlite3_bind_text(update, 1, [title UTF8String], -1, SQLITE_STATIC);
        result = sqlite3_bind_blob(update, 2, [data bytes], [data length], SQLITE_STATIC);
        result = sqlite3_bind_int(update, 3, rowid);
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
    [self willChangeValueForKey:@"levelSelected"];
}

// TableViewDelegate
- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    NSInteger newlevel = [theTableView selectedRow];
    Level *theLevel;
    
    if (theLevelMap.dirty) {
        [self SaveLevel:self];
    }
    theLevel = [levels objectAtIndex:newlevel];
    [theLevelMap load:theLevel.map];
    [theEditView setNeedsDisplay:YES];
    self.rowid = theLevel.rowid;
    self.title = theLevel.name;
    self.curLevel = newlevel;
    theLevelMap.dirty = NO;
    [self didChangeValueForKey:@"levelSelected"];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    Level *theLevel = [levels objectAtIndex:rowIndex];
    return theLevel.name;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [levels count];
}

static char * delete_sql = "DELETE FROM levels WHERE rowid=?;";
static char * select_sql = "SELECT rowid,name,map FROM levels WHERE name=?;";
static char * update_sql = "UPDATE levels SET name=?, map=? WHERE rowid=?;";
static char * insert_sql = "INSERT INTO levels (name,map) VALUES (?,?);";
static char * create_sql = "CREATE TABLE levels (background text,map blob NOT NULL,name text,par integer DEFAULT 0);";
static char * allrecords_sql = "SELECT rowid,name,map FROM levels;";
static char * vacuum_sql = "VACUUM;";

- (BOOL) open_database: (NSString *)name create:(BOOL)create
{
    sqlite3_stmt *create_db;

    // close current database, if any
    if (nil != db) {
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
    
    // prepare the SQL statements
    sqlite3_prepare_v2(db, select_sql, -1, &select, nil);
    sqlite3_prepare_v2(db, update_sql, -1, &update, nil);
    sqlite3_prepare_v2(db, insert_sql, -1, &insert, nil);
    sqlite3_prepare_v2(db, allrecords_sql, -1, &allrecords, nil);
    sqlite3_prepare_v2(db, delete_sql, -1, &delete, nil);
    sqlite3_prepare_v2(db, vacuum_sql, -1, &vacuum, nil);

    if (YES == create) {
        self.levels = [NSMutableArray arrayWithCapacity:1];
        sqlite3_prepare_v2(db, create_sql, -1, &create_db, nil);
        sqlite3_step(create_db);
        sqlite3_finalize(create_db);
        [theTableView reloadData];
    }
    else {
        [self reloadTable];
    }
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
        char *cstr = sqlite3_column_text(allrecords, 1);
        level.rowid = sqlite3_column_int(allrecords, 0);
        if (cstr && cstr[0]) {
            level.name = [NSString stringWithCString:cstr encoding:NSUTF8StringEncoding];
        }
        else {
            level.name = nil;
        }
        void *blob = sqlite3_column_blob(allrecords, 2);
        int blobsize = sqlite3_column_bytes(allrecords, 2);
        level.map = [NSData dataWithBytes:blob length:blobsize];
        [levels addObject: level];
        [level release];
    }
    [theTableView reloadData];
}


@end
