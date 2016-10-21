//
//  EVCMenuViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/23/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "EVCGroupViewController.h"
#import "EVCViewController.h"
#import <RestAPI.h>
#import "EVCMenuTableViewCell.h"
#import "EVCJobsTabViewController.h"
#import "EVCTravelTabViewController.h"
#import "EVCFeelingBlueTabViewController.h"

@interface EVCMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSArray *options, *imageNames;
}

@property (nonatomic, retain) NSMutableArray *groups;
@property (nonatomic) UIViewController *parentController;
@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) IBOutlet UIImageView *logoView;

- (id) initWithGroups:(NSMutableArray *) groupsArray andParent:(UIViewController *) parent;
@end
