//
//  EVCChatroomTableViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/24/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EVCChatroomCell.h>
#import <UIView+Toast.h>
#import <API.h>
#import "EVCFlingMessagingViewController.h"
#import <DLAVAlertView.h>

@interface EVCChatroomTableViewController : UITableViewController

@property (nonatomic, retain) NSMutableArray *chatrooms;
@property (nonatomic, retain) UIBarButtonItem *addChatroom;

@end
