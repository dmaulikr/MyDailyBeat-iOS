//
//  HealthInfo.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 5/28/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "HealthInfo.h"

@implementation HealthInfo

@synthesize uniqueId = _uniqueId;
@synthesize URL = _URL;
@synthesize logoURL = _logoURL;

- (id)initWithUniqueId:(int)uniqueId URL:(NSString *)URL logoURL:(NSString *)logoURL {
    if ((self = [super init])) {
        self.uniqueId = uniqueId;
        self.URL = URL;
        self.logoURL = logoURL;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:[NSNumber numberWithInt:self.uniqueId] forKey:@"myHealthPortalUniqueID"];
    [coder encodeObject:self.URL forKey:@"myHealthPortalURL"];
    [coder encodeObject:self.logoURL forKey:@"myHealthPortallogoURL"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.uniqueId = [(NSNumber *) [coder decodeObjectForKey:@"myHealthPortalUniqueID"] intValue];
        self.URL = (NSString *) [coder decodeObjectForKey:@"myHealthPortalURL"];
        self.logoURL = (NSString *) [coder decodeObjectForKey:@"myHealthPortallogoURL"];
    }
    return self;
}

@end
