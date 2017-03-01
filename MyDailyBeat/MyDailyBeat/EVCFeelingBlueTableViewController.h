//
//  EVCFeelingBlueTableViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 2/6/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVCCommonMethods.h"
#import "API.h"

@import API;
@interface EVCFeelingBlueTableViewController : UITableViewController {
    EVCSearchEngine *search;
}

@property (nonatomic, retain) NSMutableArray *peeps;

@end
