//
//  BankDatabase.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 5/20/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "BankDatabase.h"
#import "BankInfo.h"

@interface BankDatabase()

@property (nonatomic, strong) NSString *docDir, *dbFilename;

@end

@implementation BankDatabase

static BankDatabase *_database;

+ (BankDatabase*)database {
    if (_database == nil) {
        _database = [[BankDatabase alloc] init];
    }
    return _database;
}

- (id) init {
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.docDir = [paths objectAtIndex:0];
        self.dbFilename = @"banklist.sql";
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

- (NSArray *)bankInfos {
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    NSString *sqLiteDb = [self.docDir stringByAppendingPathComponent:self.dbFilename];
    
    if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK) {
        NSLog(@"Failed to open database!");
    } else {
        NSString *query = @"SELECT rowid, appName, appURL, iconURL FROM banks ORDER BY appName ASC";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)
            == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int uniqueId = sqlite3_column_int(statement, 0);
                char *nameChars = (char *) sqlite3_column_text(statement, 1);
                char *appChars = (char *) sqlite3_column_text(statement, 2);
                char *iconChars = (char *) sqlite3_column_text(statement, 3);
                NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
                NSString *appURL = [[NSString alloc] initWithUTF8String:appChars];
                NSString *iconURL = [[NSString alloc] initWithUTF8String:iconChars];
                uniqueId = [[appURL stringByReplacingOccurrencesOfString:@"itms-apps://itunes.apple.com/app/id" withString:@""] intValue];
                BankInfo *info = [[BankInfo alloc]
                                  initWithUniqueId:uniqueId name:name appURL:appURL iconURL:iconURL];
                [retval addObject:info];
            }
            sqlite3_finalize(statement);
        }
    }
    
    sqlite3_close(_database);
    
    return retval;
    
}

- (void) insertIntoDatabase: (BankInfo *) bank {
    NSString *sqLiteDb = [self.docDir stringByAppendingPathComponent:self.dbFilename];
    
    if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK) {
        NSLog(@"Failed to open database!");
    } else {
        NSString *query = @"create table if not exists banks(appName text, appURL text, iconURL text)";
        const char * qstring = [query UTF8String];
        char * errMsg;
        int prepareStatementResult = sqlite3_exec(_database, qstring, NULL, NULL, &errMsg);
        if (prepareStatementResult == SQLITE_OK) {
            NSString *query2 = [NSString stringWithFormat:@"insert into banks values('%@', '%@', '%@')", bank.appName, bank.appURL, bank.iconURL];
            
            const char* qstring2 = [query2 UTF8String];
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
    
    sqlite3_close(_database);
    
}

@end
