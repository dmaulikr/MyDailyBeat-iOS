//
//  EVCJobsViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/22/15.
//  Copyright © 2015 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "EVCVolunteeringDetailsViewController.h"
#import "EVCCommonMethods.h"
#import "API.h"

@interface EVCVolunteeringViewController : UIViewController <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate> {
    CLLocationManager *manager;
    CLGeocoder *geocoder;
    NSString *currentZip, *currentQuery;
    int currentPage;
    int total;
}

@property (nonatomic, retain) IBOutlet UITableView *results;
@property (nonatomic, retain) NSDictionary *resultsDictionary;
@property (nonatomic, retain) NSMutableArray *currentSet;

@end
