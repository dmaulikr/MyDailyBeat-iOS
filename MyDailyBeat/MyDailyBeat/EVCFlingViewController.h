//
//  EVCFlingViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/21/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVCPartnerMatchViewController.h"
#import "EVCPartnersTableViewController.h"
#import "EVCFlingProfileViewController.h"
#import "EVCFlingMessagingViewController.h"
#import "EVCChatroomTableViewController.h"
#import <API.h>
#import "EVCFlingProfileCreatorViewController.h"
#import "RESideMenu.h"
#import "EVCCommonMethods.h"

@interface EVCFlingViewController : UITabBarController <UITabBarControllerDelegate>

@property (nonatomic) NSNumber *friendsMode;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andInMode: (NSNumber *) friendsMode;

@end
