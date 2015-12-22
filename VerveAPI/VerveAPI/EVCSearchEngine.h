//
//  EVCUserSearchEngine.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 10/31/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "API.h"

@interface EVCSearchEngine : NSObject

- (NSMutableArray *) getUsersWithScreenNameContainingString:(NSString *) searchString withSortOrder:(EVCSearchSortOrder) sort_order;

- (NSMutableArray *) getUsersWithNameContainingString:(NSString *) searchString withSortOrder:(EVCSearchSortOrder) sort_order;

- (NSMutableArray *) getUsersWithEmailContainingString:(NSString *) searchString withSortOrder:(EVCSearchSortOrder) sort_order;

- (NSMutableArray *) getGroupsWithNameContainingString:(NSString *) queryString withSortOrder:(EVCSearchSortOrder) sort_order;

- (NSMutableArray *) getUsersForFeelingBlue;

@end
