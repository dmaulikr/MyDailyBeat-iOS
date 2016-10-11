//
//  EVCJobsViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/22/15.
//  Copyright © 2015 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestAPI.h>
#import "UIView+Toast.h"
#import "Constants.h"
#import <CoreLocation/CoreLocation.h>
#import "EVCJobsDetailsViewController.h"
#import "EVCCommonMethods.h"
#import "RESideMenu.h"
#import "EVCJobsFilter.h"
#import "FXBlurView.h"

@interface EVCJobsViewController : UIViewController <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, EVCJobsFilterDelegate> {
    CLLocationManager *manager;
    CLGeocoder *geocoder;
    NSString *currentZip, *currentQuery;
    int currentPage;
    int total;
    JobType jobType;
    JobSearchRadius searchRadius;
    EVCJobsFilter *filterView;
}

@property (nonatomic, retain) IBOutlet UITableView *results;
@property (nonatomic, retain) NSDictionary *resultsDictionary;
@property (nonatomic, retain) NSMutableArray *currentSet;

@end
