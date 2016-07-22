//
//  EVCViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/17/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DLAVAlertView.h>
#import <API.h>
#import <UIView+Toast.h>
#import "RESideMenu.h"
#import "EVCProfileViewController.h"
#import "EVCCommonMethods.h"
#import <EVCGroupSearchViewViewController.h>
#import "EVCFlingViewController.h"
#import "EVCShoppingViewController.h"
#import "EVCFeelingBlueTabViewController.h"
#import "EVCFinanceViewController.h"
#import "EVCVolunteeringMapViewController.h"
#import "EVCTravelTableViewController.h"
#import "EVCJobsViewController.h"
#import "EVCHealthViewController.h"
#import "EVCHobbiesViewController.h"
#import "EVCFirstTimeSetupViewController.h"

@interface EVCViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, EVCGroupSearchViewDelegate> {
    NSArray *options, *imageNames;
}

@property(nonatomic, retain) IBOutlet UITableView *mTableView;
@property(strong, nonatomic) API *api;

@end
