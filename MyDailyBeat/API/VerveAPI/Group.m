//
//  Group.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 9/2/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "Group.h"

@implementation Group

@synthesize groupName, adminName, groupID, posts, blobKey, servingURL, hobbies;

- (id) copyWithZone:(NSZone *)zone {
    id copy = [[[self class] alloc] init];
    
    if (copy) {
        [copy setGroupName:[self.groupName copyWithZone:zone]];
        [copy setAdminName:[self.adminName copyWithZone:zone]];
        [copy setPosts:[self.posts copyWithZone:zone]];
        [copy setBlobKey:[self.blobKey copyWithZone:zone]];
        [copy setServingURL:[self.servingURL copyWithZone:zone]];
        [copy setGroupID:self.groupID];
        [copy setHobbies:[self.hobbies copyWithZone:zone]];
    }
    
    return copy;

}

@end
