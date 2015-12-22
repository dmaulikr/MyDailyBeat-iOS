//
//  EVCUserSearchEngine.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 10/31/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCSearchEngine.h"

@implementation EVCSearchEngine

- (NSMutableArray *) getUsersWithScreenNameContainingString:(NSString *) searchString withSortOrder:(EVCSearchSortOrder) sort_order {
    NSDictionary *dict = [[API getInstance] searchUsersWithQueryString:searchString andQueryType:SearchByScreenName withSortOrder:sort_order];
    return [self dictofUsersToArray:dict];
}

- (NSMutableArray *) getUsersWithNameContainingString:(NSString *) searchString withSortOrder:(EVCSearchSortOrder) sort_order {
    NSDictionary *dict = [[API getInstance] searchUsersWithQueryString:searchString andQueryType:SearchByName withSortOrder:sort_order];
    return [self dictofUsersToArray:dict];
}

- (NSMutableArray *) getUsersWithEmailContainingString:(NSString *) searchString withSortOrder:(EVCSearchSortOrder) sort_order {
    NSDictionary *dict = [[API getInstance] searchUsersWithQueryString:searchString andQueryType:SearchByEmail withSortOrder:sort_order];
    return [self dictofUsersToArray:dict];
}

- (NSMutableArray *) getGroupsWithNameContainingString:(NSString *) queryString withSortOrder:(EVCSearchSortOrder) sort_order {
    NSDictionary *dict = [[API getInstance] searchGroupsWithQueryString:queryString withSortOrder:sort_order];
    return [self dictofGroupsToArray:dict];
}

- (NSMutableArray *) getUsersForFeelingBlue {
    NSDictionary *dict = [[API getInstance] getUsersForFeelingBlue];
    return [self dictofUsersToArray:dict];
}

- (NSMutableArray *) dictofUsersToArray:(NSDictionary *) dict {
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

- (NSMutableArray *) dictofGroupsToArray:(NSDictionary *) dict {
    NSMutableArray *items = [dict objectForKey:@"items"];
    NSMutableArray *retItems = [[NSMutableArray alloc] init];
    
    for (int i= 0 ; i < [items count] ; ++i) {
        Group *g = [[Group alloc] init];
        NSDictionary *item = [items objectAtIndex:i];
        g.groupName = [item objectForKey:@"groupName"];
        g.adminName = [item objectForKey:@"adminScreenName"];
        g.blobKey = [item objectForKey:@"blobKey"];
        g.servingURL = [item objectForKey:@"servingURL"];
        g.groupID = [[item objectForKey:@"id"] intValue];
        NSMutableArray *postJSON = [item objectForKey:@"posts"];
        NSMutableArray *posts = [[NSMutableArray alloc] init];
        for (int j=0 ; j < [postJSON count] ; ++j) {
            Post *p = [[Post alloc] init];
            NSDictionary *post = [postJSON objectAtIndex:j];
            p.postText = [post objectForKey:@"postText"];
            p.blobKey = [post objectForKey:@"blobKey"];
            p.servingURL = [post objectForKey:@"servingURL"];
            p.post_id = [[post objectForKey:@"id"] intValue];
            p.userScreenName = [post objectForKey:@"userScreenName"];
            p.dateTimeMillis = [[post objectForKey:@"when"] longLongValue];
            [posts addObject:p];
        }
        g.posts = posts;
        [retItems addObject:g];
    }
    
    
    return retItems;

}

@end
