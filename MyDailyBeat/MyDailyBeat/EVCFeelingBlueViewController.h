//
//  EVCFeelingBlueViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 1/9/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVCFeelingBlueTableViewController.h"
#import "EVCCommonMethods.h"
#import "RESideMenu.h"


@interface EVCFeelingBlueViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (IBAction)callSuicideAction:(id)sender;
- (IBAction)callVeteransAction:(id)sender;
- (IBAction)callAnonymousAction:(id)sender;
- (IBAction)callTestAction:(id)sender;

@end
