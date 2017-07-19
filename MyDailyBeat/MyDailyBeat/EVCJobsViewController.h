//
//  EVCJobsViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/22/15.
//  Copyright © 2015 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "EVCJobsDetailsViewController.h"
#import "EVCCommonMethods.h"
#import "API.h"
#import "EVCJobsFilter.h"

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
