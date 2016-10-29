//
//  EVCProfileViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/21/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVCPreferencesViewController.h"
#import "API.h"
#import <QuartzCore/QuartzCore.h>
#import "EVCUpdateProfileViewController.h"

@interface EVCProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) IBOutlet UIImageView *profilePicView;
@property (nonatomic) UIImage *profilePic;

@property (nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic) IBOutlet UILabel *mScreenNameLabel;

- (void) reloadData;


@end
