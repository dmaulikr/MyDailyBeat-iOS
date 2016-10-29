//
//  EVCFlingMessagingViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/22/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCCommonMethods.h"
#import "API.h"

@class SLKTextViewController;
@interface EVCFlingMessagingViewController : SLKTextViewController

@property (nonatomic, strong) MessageChatroom *chatroom;

- (id) initWithChatroom: (MessageChatroom *) chatroom;

@end
