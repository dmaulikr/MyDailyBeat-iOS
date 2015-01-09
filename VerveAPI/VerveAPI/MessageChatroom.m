//
//  MessageChatroom.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 12/26/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "MessageChatroom.h"

@implementation MessageChatroom

@synthesize chatroomID, messages, screenNames;

- (id)copyWithZone:(NSZone *)zone {
    MessageChatroom *other = [[MessageChatroom alloc] init];
    other.screenNames = self.screenNames;
    other.chatroomID = self.chatroomID;
    other.messages = self.messages;
    return other;
}

@end
