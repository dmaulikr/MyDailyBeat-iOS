//
//  EVCChatroomCell.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/24/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageChatroom.h>
#import <RestAPI.h>

@interface EVCChatroomCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *first, *second, *third;
@property (nonatomic, strong) IBOutlet UILabel *chatroomNameLbl, *extraLbl;
@property (nonatomic, strong) MessageChatroom *chatroom;

- (id) changeChatroom:(MessageChatroom *)chatroom;

@end
