//
//  VerveMessage.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 1/4/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import "VerveMessage.h"

@implementation VerveMessage

- (id)copyWithZone:(NSZone *)zone {
    VerveMessage *other = [[VerveMessage alloc] init];
    other.screenName = self.screenName;
    other.message = self.message;
    return other;
}

@end
