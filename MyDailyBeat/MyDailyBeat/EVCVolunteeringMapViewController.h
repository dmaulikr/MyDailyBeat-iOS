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
#import <RestAPI.h>
#import "VerveVolunteering.h"
#import "AHKActionSheet.h"

@interface EVCVolunteeringMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
    CLLocationCoordinate2D currentCentre;
    int currentDist;
    NSString *currentKeyword, *currentType;
    BOOL firstLaunch;
    
}

@property (nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) DownPicker *downPicker;
@property (nonatomic) NSArray *volList;

@end
