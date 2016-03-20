//
//  EVCJobsViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/22/15.
//  Copyright © 2015 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <API.h>
#import "UIView+Toast.h"
#import "Constants.h"
#import <CoreLocation/CoreLocation.h>
#import "EVCJobsDetailsViewController.h"
#import "EVCCommonMethods.h"
#import "RESideMenu.h"

@interface EVCJobsViewController : UIViewController <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
    CLLocationManager *manager;
    CLGeocoder *geocoder;
    NSString *currentZip;
}

@property (nonatomic, retain) IBOutlet UITableView *results;
@property (nonatomic, retain) IBOutlet UISearchBar *mBar;
@property (nonatomic, retain) NSDictionary *resultsDictionary;

@end
