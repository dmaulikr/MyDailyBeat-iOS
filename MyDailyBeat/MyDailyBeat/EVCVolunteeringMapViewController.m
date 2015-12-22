//
//  EVCVolunteeringMapViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/30/15.
//  Copyright © 2015 eVerveCorp. All rights reserved.
//

#import "EVCVolunteeringMapViewController.h"

@interface EVCVolunteeringMapViewController ()

@end

@implementation EVCVolunteeringMapViewController

@synthesize mapView, locationManager, downPicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    mapView.delegate = self;
    [mapView setShowsUserLocation:YES];
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    firstLaunch=YES;
    currentKeyword = @"";
    currentType = @"name";
    
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    UIImage *image2 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"search-icon-white.png"] scaledToSize:CGSizeMake(30, 30)];
     CGRect frameimg3 = CGRectMake(0, 0, image2.size.width, image2.size.height);
     UIButton *someButton3 = [[UIButton alloc] initWithFrame:frameimg3];
     [someButton3 setBackgroundImage:image2 forState:UIControlStateNormal];
     [someButton3 addTarget:self action:@selector(view_directory)
     forControlEvents:UIControlEventTouchUpInside];
     [someButton3 setShowsTouchWhenHighlighted:YES];
     UIBarButtonItem *searchButton =[[UIBarButtonItem alloc] initWithCustomView:someButton3];
    
    UIImage* image3 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"hamburger-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(showMenu)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *menuButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    self.navigationItem.rightBarButtonItems = @[menuButton, searchButton];
    
    UIImage* image4 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"profile-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg2 = CGRectMake(0, 0, image4.size.width, image4.size.height);
    UIButton *someButton2 = [[UIButton alloc] initWithFrame:frameimg2];
    [someButton2 setBackgroundImage:image4 forState:UIControlStateNormal];
    [someButton2 addTarget:self action:@selector(showProfile)
          forControlEvents:UIControlEventTouchUpInside];
    [someButton2 setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *profileButton =[[UIBarButtonItem alloc] initWithCustomView:someButton2];
    self.navigationItem.leftBarButtonItem = profileButton;
    
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        self.volList = [[API getInstance] getVolunteeringList];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
        });
    });
    
    
}

- (void) view_directory {
    NSMutableArray *nameList = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.volList count]; i++) {
        VerveVolunteering *v = [self.volList objectAtIndex:i];
        [nameList addObject:v.npName];
    }
    
    AHKActionSheet *sheet = [[AHKActionSheet alloc] initWithTitle:@"Nonprofit Directory"];

    for (NSString *title in nameList) {
        [sheet addButtonWithTitle:title type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet) {
            currentKeyword = title;
            [self getData];
        }];
    }
    
    
    [sheet show];

}

- (void) getData {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        NSMutableArray *results = [[NSMutableArray alloc] init];
        if ([currentType isEqualToString:@"name"]) {
            results = [[API getInstance] getPlacesWithType:currentType withName:currentKeyword andCategory:nil fromLocation:currentCentre];
        } else {
            results = [[API getInstance] getPlacesWithType:currentType withName:nil andCategory:currentKeyword fromLocation:currentCentre];
        }
        
        NSMutableArray *mapPoints = [[NSMutableArray alloc] init];
        for (NSDictionary *entry in results) {
            NSDictionary *geo = [entry objectForKey:@"geometry"];
            NSDictionary *loc = [geo objectForKey:@"location"];
            NSString *placeID = [entry objectForKey:@"place_id"];
            NSDictionary *details = [[API getInstance] getDetailsForPlaceWithID:placeID];
            NSString *name2 = [details objectForKey:@"name"];
            NSString *address = [details objectForKey:@"formatted_address"];
            
            CLLocationCoordinate2D placeCoord;
            
            placeCoord.latitude = [[loc objectForKey:@"lat"] doubleValue];
            placeCoord.longitude = [[loc objectForKey:@"lng"] doubleValue];
            
            MapPoint *placeObject = [[MapPoint alloc] initWithName:name2 address:address coordinate:placeCoord];
            [mapPoints addObject:placeObject];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            [self plotPositions:mapPoints];
        });
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showMenu {
    [self.sideMenuViewController presentRightMenuViewController];
}

- (void) showProfile {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    MKMapRect mRect = self.mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    currentDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    
    currentCentre = self.mapView.centerCoordinate;
}

-(void)plotPositions:(NSArray *)data {
    // 1 - Remove any existing custom annotations but not the user location blue dot.
    for (id<MKAnnotation> annotation in mapView.annotations) {
        if ([annotation isKindOfClass:[MapPoint class]]) {
            [mapView removeAnnotation:annotation];
        }
    }
    NSMutableArray *points = [[NSMutableArray alloc] initWithArray:data copyItems:YES];
    MapPoint *currentLocation = [[MapPoint alloc] initWithName:@"Current Location" address:@"" coordinate:currentCentre];
    [points addObject:currentLocation];
    [mapView showAnnotations:points animated:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    // Define your reuse identifier.
    static NSString *identifier = @"MapPoint";
    
    if ([annotation isKindOfClass:[MapPoint class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.animatesDrop = YES;
        return annotationView;
    }
    return nil;
}

-(void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    //Zoom back to the user location after adding a new set of annotations.
    //Get the center point of the visible map.
    CLLocationCoordinate2D centre = [mv centerCoordinate];
    MKCoordinateRegion region;
    //If this is the first launch of the app, then set the center point of the map to the user's location.
    if (firstLaunch) {
        region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate,1000,1000);
        firstLaunch=NO;
        //Set the visible region of the map.
        [mv setRegion:region animated:YES];
    }else {
        [self zoomToFitMapAnnotations:mv];
    }
    
}

- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    MapPoint *point = (MapPoint *) view.annotation;
    NSString *url = @"http://maps.apple.com?daddr=";
    url = [url stringByAppendingString:[[API getInstance] urlencode:point.address]];
    url = [url stringByAppendingString:@"&zoom=10"];
    [self openURLinBrowser:url];
}

- (void) openURLinBrowser: (NSString *) url {
    NSURL *urlO = [NSURL URLWithString:url];
    [[UIApplication sharedApplication] openURL:urlO];
}

-(void)zoomToFitMapAnnotations:(MKMapView*)mapView
{
    if([mapView.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(MapPoint* annotation in mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}

@end
