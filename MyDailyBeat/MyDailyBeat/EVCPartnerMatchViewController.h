//
//  EVCPartnerMatchViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/21/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVCFlingProfileViewController.h"
#import "API.h"

@interface EVCPartnerMatchViewController : UITableViewController

@property (nonatomic, retain) NSMutableArray *partners;
@property (nonatomic) REL_MODE mode;

@end
