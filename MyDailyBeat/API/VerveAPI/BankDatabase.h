//
//  BankDatabase.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 5/20/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BankInfo.h"
#import <sqlite3.h>

@interface BankDatabase : NSObject {
    sqlite3 *_database;
}

+ (BankDatabase*)database;
- (NSArray *)bankInfos;
- (void) insertIntoDatabase: (BankInfo *) bank;

@end
