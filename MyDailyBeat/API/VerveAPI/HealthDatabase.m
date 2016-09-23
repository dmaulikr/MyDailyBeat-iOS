//
//  HealthDatabase.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 5/28/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "HealthDatabase.h"

@interface HealthDatabase()

@property (nonatomic, strong) NSString *docDir, *dbFilename;

@end

@implementation HealthDatabase

static HealthDatabase *_database;

+ (HealthDatabase*)database {
    if (_database == nil) {
        _database = [[HealthDatabase alloc] init];
    }
    return _database;
}

- (id) init {
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.docDir = [paths objectAtIndex:0];
        self.dbFilename = @"healthlist.sql";
        [self copyDatabaseIntoDocDir];
    }
    return self;
}

- (void) copyDatabaseIntoDocDir {
    NSString *dest = [self.docDir stringByAppendingPathComponent:self.dbFilename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dest]) {
        NSString *source = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.dbFilename];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:source toPath:dest error:&error];
        
        if (error != nil ) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

- (NSArray *)prescripProviders {
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    NSString *sqLiteDb = [self.docDir stringByAppendingPathComponent:self.dbFilename];
    
    if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK) {
        NSLog(@"Failed to open database!");
    } else {
        NSString *query = @"SELECT rowid, URL, logoURL FROM prescripProviders ORDER BY rowid ASC";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)
            == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int uniqueId = sqlite3_column_int(statement, 0);
                char *nameChars = (char *) sqlite3_column_text(statement, 1);
                char *appChars = (char *) sqlite3_column_text(statement, 2);
                NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
                NSString *appURL = [[NSString alloc] initWithUTF8String:appChars];
                PrescripProviderInfo *info = [[PrescripProviderInfo alloc] initWithUniqueId:uniqueId URL:name logoURL:appURL];
                [retval addObject:info];
            }
            sqlite3_finalize(statement);
        }
    }
    
    sqlite3_close(_database);
    
    return retval;
    
}

- (NSArray *)healthPortals {
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    NSString *sqLiteDb = [self.docDir stringByAppendingPathComponent:self.dbFilename];
    
    if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK) {
        NSLog(@"Failed to open database!");
    } else {
        NSString *query = @"SELECT rowid, URL, logoURL FROM healthPortals ORDER BY rowid ASC";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)
            == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int uniqueId = sqlite3_column_int(statement, 0);
                char *urlChars = (char *) sqlite3_column_text(statement, 1);
                char *logoChars = (char *) sqlite3_column_text(statement, 2);
                NSString *URL = [[NSString alloc] initWithUTF8String:urlChars];
                NSString *logoURL = [[NSString alloc] initWithUTF8String:logoChars];
                HealthInfo *info = [[HealthInfo alloc] initWithUniqueId:uniqueId URL:URL logoURL:logoURL];
                [retval addObject:info];
            }
            sqlite3_finalize(statement);
        }
    }
    
    sqlite3_close(_database);
    
    return retval;
    
}

- (void) insertIntoDatabase: (HealthInfo *) healthPortalOrNil orPrescriptionProvider: (PrescripProviderInfo *) prescripProviderOrNil{
    NSString *sqLiteDb = [self.docDir stringByAppendingPathComponent:self.dbFilename];
    
    if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK) {
        NSLog(@"Failed to open database!");
    } else {
        if (prescripProviderOrNil != nil) {
            // prescrip providers
            NSString *query = @"create table if not exists prescripProviders(URL text, logoURL text)";
            const char * qstring = [query UTF8String];
            char * errMsg;
            int prepareStatementResult = sqlite3_exec(_database, qstring, NULL, NULL, &errMsg);
            if (prepareStatementResult == SQLITE_OK) {
                NSString *query2 = [NSString stringWithFormat:@"insert into prescripProviders values('%@', '%@')", prescripProviderOrNil.URL, prescripProviderOrNil.logoURL];
                
                const char* qstring2 = [query2 UTF8String];
                NSLog(@"Query: %s", qstring2);
                char * errMsg2;
                
                // Load all data from database to memory.
                int prepareStatementResult2 = sqlite3_exec(_database, qstring2, NULL, NULL, &errMsg2);
                if(prepareStatementResult2 == SQLITE_OK) {
                    
                } else {
                    NSLog(@"Error: %s", errMsg2);
                }
            } else {
                NSLog(@"Error: %s", errMsg);
            }
        } else {
            // health portals
            NSString *query = @"create table if not exists healthPortals(URL text, logoURL text)";
            const char * qstring = [query UTF8String];
            char * errMsg;
            int prepareStatementResult = sqlite3_exec(_database, qstring, NULL, NULL, &errMsg);
            if (prepareStatementResult == SQLITE_OK) {
                NSString *query2 = [NSString stringWithFormat:@"insert into healthPortals values('%@', '%@')", healthPortalOrNil.URL, healthPortalOrNil.logoURL];
                
                const char* qstring2 = [query2 UTF8String];
                NSLog(@"Query: %s", qstring2);
                char * errMsg2;
                
                // Load all data from database to memory.
                int prepareStatementResult2 = sqlite3_exec(_database, qstring2, NULL, NULL, &errMsg2);
                if(prepareStatementResult2 == SQLITE_OK) {
                    
                } else {
                    NSLog(@"Error: %s", errMsg2);
                }
            } else {
                NSLog(@"Error: %s", errMsg);
            }
        }
        
        
    }
    
    sqlite3_close(_database);
    
}


@end
