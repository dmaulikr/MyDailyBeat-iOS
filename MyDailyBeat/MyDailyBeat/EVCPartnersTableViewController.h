//
//  EVCPartnersTableViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/21/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <API.h>
#import "EVCFlingProfileViewController.h"
#import "Constants.h"

@interface EVCPartnersTableViewController : UITableViewController

@property (nonatomic, retain) NSMutableArray *favs;
@property (nonatomic) REL_MODE mode;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andMode:(REL_MODE) mode;

@end
