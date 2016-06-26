//
//  BankInfo.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 5/20/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "BankInfo.h"

@implementation BankInfo

@synthesize uniqueId = _uniqueId;
@synthesize appName = _appName;
@synthesize appURL = _appURL;
@synthesize iconURL= _iconURL;

- (id)initWithUniqueId:(int)uniqueId name:(NSString *)appName appURL:(NSString *)appURL
               iconURL:(NSString *)iconURL {
    if ((self = [super init])) {
        self.uniqueId = uniqueId;
        self.appName = appName;
        self.appURL = appURL;
        self.iconURL = iconURL;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:[NSNumber numberWithInt:self.uniqueId] forKey:@"myBankUniqueID"];
    [coder encodeObject:self.appName forKey:@"myBankAppName"];
    [coder encodeObject:self.appURL forKey:@"myBankAppURL"];
    [coder encodeObject:self.iconURL forKey:@"myBankIconURL"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.uniqueId = [(NSNumber *) [coder decodeObjectForKey:@"myBankUniqueID"] intValue];
        self.appName = (NSString *) [coder decodeObjectForKey:@"myBankAppName"];
        self.appURL = (NSString *) [coder decodeObjectForKey:@"myBankAppURL"];
        self.iconURL = (NSString *) [coder decodeObjectForKey:@"myBankIconURL"];
    }
    return self;
}

@end
