//
//  EVCViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/17/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVCViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, retain) IBOutlet UITableView *mTableView;

@end
