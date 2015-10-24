//
//  EVCVolunteeringMapViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/30/15.
//  Copyright © 2015 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Constants.h>
#import "MapPoint.h"
#import "EVCCommonMethods.h"
#import "RESideMenu.h"
#import "DownPicker.h"

@interface EVCVolunteeringMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate> {
    CLLocationCoordinate2D currentCentre;
    int currentDist;
    BOOL firstLaunch;
    
}

@property (nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) IBOutlet UITextField *radiusField;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) DownPicker *downPicker;

@end
