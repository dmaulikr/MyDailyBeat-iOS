//
//  EVCFinanceHomeViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/29/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "VerveBankObject.h"
#import "RestAPI.h"

@interface EVCFinanceHomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *bankList, *iconList;

@end
