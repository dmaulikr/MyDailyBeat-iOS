//
//  PrescripProviderInfo.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 5/30/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "PrescripProviderInfo.h"

@implementation PrescripProviderInfo

@synthesize uniqueId = _uniqueId;
@synthesize URL = _URL;
@synthesize logoURL = _logoURL;


- (id)initWithUniqueId:(int)uniqueId URL: (NSString *) URL logoURL:(NSString *)logoURL {
    if ((self = [super init])) {
        self.uniqueId = uniqueId;
        self.URL = URL;
        self.logoURL = logoURL;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:[NSNumber numberWithInt:self.uniqueId] forKey:@"myPrescripProviderUniqueID"];
    [coder encodeObject:self.URL forKey:@"myPrescripProviderURL"];
    [coder encodeObject:self.logoURL forKey:@"myPrescripProviderlogoURL"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.uniqueId = [(NSNumber *) [coder decodeObjectForKey:@"myPrescripProviderUniqueID"] intValue];
        self.URL = (NSString *) [coder decodeObjectForKey:@"myPrescripProviderURL"];
        self.logoURL = (NSString *) [coder decodeObjectForKey:@"myPrescripProviderlogoURL"];
    }
    return self;
}

@end
