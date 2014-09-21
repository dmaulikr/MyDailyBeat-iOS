//
//  EVCMenuViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/23/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "EVCPreferencesViewController.h"
#import "EVCViewController.h"
#import <API.h>

@interface EVCMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *groups;

- (id) initWithGroups:(NSMutableArray *) groupsArray;
@end
