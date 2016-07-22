//
//  HealthDatabase.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 5/28/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "HealthInfo.h"
#import "PrescripProviderInfo.h"

@interface HealthDatabase : NSObject {
    sqlite3 *_database;
}

+ (HealthDatabase*)database;
- (NSArray *)prescripProviders;
- (NSArray *)healthPortals;
- (void) insertIntoDatabase: (HealthInfo *) healthPortalOrNil orPrescriptionProvider: (PrescripProviderInfo *) prescripProviderOrNil;

@end
