//
//  EVCViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/17/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVCProfileViewController.h"
#import "EVCCommonMethods.h"
#import "EVCFlingViewController.h"
#import "EVCShoppingViewController.h"
#import "EVCFeelingBlueTabViewController.h"
#import "EVCFinanceViewController.h"
#import "EVCTravelTabViewController.h"
#import "EVCJobsTabViewController.h"
#import "EVCHealthViewController.h"
#import "EVCHobbiesViewController.h"
#import "EVCFirstTimeSetupViewController.h"
#import "API.h"
#import "EVCVolunteeringTabViewController.h"

@interface EVCViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, EVCGroupSearchViewDelegate> {
    NSArray *options, *imageNames;
}

@property(nonatomic, retain) IBOutlet UITableView *mTableView;
@property(strong, nonatomic) RestAPI *api;

@end
