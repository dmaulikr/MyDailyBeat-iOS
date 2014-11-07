//
//  EVCUserSearchEngine.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 10/31/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCUserSearchEngine.h"

@implementation EVCUserSearchEngine

- (NSMutableArray *) getUsersWithScreenNameContainingString:(NSString *) searchString withSortOrder:(EVCSearchSortOrder) sort_order {
    NSDictionary *dict = [[API getInstance] searchUsersWithQueryString:searchString andQueryType:SearchByScreenName withSortOrder:sort_order];
    return [self dictToArray:dict];
}

- (NSMutableArray *) getUsersWithNameContainingString:(NSString *) searchString withSortOrder:(EVCSearchSortOrder) sort_order {
    NSDictionary *dict = [[API getInstance] searchUsersWithQueryString:searchString andQueryType:SearchByName withSortOrder:sort_order];
    return [self dictToArray:dict];
}

- (NSMutableArray *) getUsersWithEmailContainingString:(NSString *) searchString withSortOrder:(EVCSearchSortOrder) sort_order {
    NSDictionary *dict = [[API getInstance] searchUsersWithQueryString:searchString andQueryType:SearchByEmail withSortOrder:sort_order];
    return [self dictToArray:dict];
}

- (NSMutableArray *) dictToArray:(NSDictionary *) dict {
    NSArray *jsonArr = [dict objectForKey:@"items"];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [jsonArr count] ; ++i) {
        NSDictionary *resultDic = [jsonArr objectAtIndex:i];
        VerveUser *currentUser = [[VerveUser alloc] init];
        currentUser.name = [resultDic objectForKey:@"name"];
        currentUser.email = [resultDic objectForKey:@"email"];
        currentUser.screenName = [resultDic objectForKey:@"screenName"];;
        currentUser.password = [resultDic objectForKey:@"password"];;
        currentUser.mobile = [resultDic objectForKey:@"mobile"];
        currentUser.zipcode = [resultDic objectForKey:@"zipcode"];
        currentUser.birth_month = [resultDic objectForKey:@"birth_month"];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        currentUser.birth_year = [[f numberFromString:[resultDic objectForKey:@"birth_year"]] longValue];
        [result addObject:currentUser];
    }
    
    return result;
}

@end
