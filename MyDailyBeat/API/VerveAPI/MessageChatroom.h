//
//  MessageChatroom.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 12/26/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageChatroom : NSObject

@property (nonatomic) int chatroomID;
@property (nonatomic, strong) NSMutableArray *screenNames, *messages;

@end
