//
//  Post.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 10/1/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "Post.h"

@implementation Post

@synthesize postText, blobKey, servingURL, userScreenName, dateTimeMillis, post_id;

- (id) copyWithZone:(NSZone *)zone {
    
    id copy = [[[self class] alloc] init];
    
    if (copy) {
        [copy setPostText:[self.postText copyWithZone:zone]];
        [copy setBlobKey:[self.blobKey copyWithZone:zone]];
        [copy setServingURL:[self.servingURL copyWithZone:zone]];
        [copy setUserScreenName:[self.userScreenName copyWithZone:zone]];
        [copy setDateTimeMillis:self.dateTimeMillis];
        [copy setPost_id:self.post_id];
    }
    
    return copy;

}

@end
