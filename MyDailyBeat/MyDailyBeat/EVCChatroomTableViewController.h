//
//  EVCChatroomTableViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/24/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVCChatroomCell.h"
#import "EVCFlingMessagingViewController.h"
#import "API.h"

@interface EVCChatroomTableViewController : UITableViewController

@property (nonatomic, retain) NSMutableArray *chatrooms;
@property (nonatomic, retain) UIBarButtonItem *addChatroom;
@property (nonatomic) REL_MODE mode;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andMode:(REL_MODE) mode;

@end
