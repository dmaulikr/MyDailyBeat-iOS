//
//  EVCJobsViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/22/15.
//  Copyright © 2015 eVerveCorp. All rights reserved.
//

#import "EVCJobsViewController.h"

@interface EVCJobsViewController ()

@end

@implementation EVCJobsViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        manager = [[CLLocationManager alloc] init];
        manager.delegate = self;
        manager.distanceFilter = kCLDistanceFilterNone;
        manager.desiredAccuracy = kCLLocationAccuracyBest;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            [manager requestWhenInUseAuthorization];
        geocoder = [[CLGeocoder alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage* image3 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"hamburger-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(showMenu)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *menuButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    self.navigationItem.rightBarButtonItem = menuButton;
    
    UIImage* image4 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"profile-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg2 = CGRectMake(0, 0, image4.size.width, image4.size.height);
    UIButton *someButton2 = [[UIButton alloc] initWithFrame:frameimg2];
    [someButton2 setBackgroundImage:image4 forState:UIControlStateNormal];
    [someButton2 addTarget:self action:@selector(showProfile)
          forControlEvents:UIControlEventTouchUpInside];
    [someButton2 setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *profileButton =[[UIBarButtonItem alloc] initWithCustomView:someButton2];
    self.navigationItem.leftBarButtonItem = profileButton;
    [manager startUpdatingLocation];
    self.results.dataSource = self;
    self.results.delegate = self;
    self.mBar.delegate = self;
    self.mBar.showsCancelButton = TRUE;
    self.results.tableHeaderView = self.mBar;
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [manager startUpdatingLocation];
    NSString *query = [searchBar text];
    [self run:query];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [manager startUpdatingLocation];
    NSString *query = @"";
    [self run:query];
}

- (void) run: (NSString *) query {
    NSString *baseUrl = @"http://api.indeed.com";
    NSString *path = @"ads/apisearch";
    NSString *parameters =[@"publisher=3873225971566005&q=" stringByAppendingString:query];
    parameters = [parameters stringByAppendingString:@"&l="];
    parameters =[parameters stringByAppendingString:currentZip];
    parameters = [parameters stringByAppendingString:@"&sort=&radius=&st=&jt=&start=&limit=3000&fromage=&filter=&latlong=1&co=us&chnl=&userip=1.2.3.4&useragent=Mozilla/%2F4.0%28Firefox%29&v=2"];
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
            [manager stopUpdatingLocation];
        });
        self.resultsDictionary = [[API getInstance] makeXMLRequestWithBaseUrl:baseUrl withPath:path withParameters:parameters withRequestType:GET_REQUEST andPostData:nil];
        NSLog(@"Results: %@", self.resultsDictionary);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            [self.results reloadData];
            
            
        });
    });
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *loc = [locations lastObject];
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *mark = placemarks[0];
        NSLog(@"%@", placemarks);
        currentZip = mark.postalCode;
        [self run:@""];
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifiter = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiter];
    
    if (cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifiter];
    }
    NSDictionary *results = [self.resultsDictionary objectForKey:@"results"];
    NSArray *temp = [results objectForKey:@"result"];
    NSDictionary *result = [temp objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [result objectForKey:@"jobtitle"];
    cell.detailTextLabel.text = [result objectForKey:@"company"];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSDictionary *results = [self.resultsDictionary objectForKey:@"results"];
    NSArray *temp = [results objectForKey:@"result"];
    return [temp count];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *results = [self.resultsDictionary objectForKey:@"results"];
    NSArray *temp = [results objectForKey:@"result"];
    NSDictionary *result = [temp objectAtIndex:indexPath.row];
    
    EVCJobsDetailsViewController *details = [[EVCJobsDetailsViewController alloc] initWithNibName:@"EVCJobsDetailsViewController" bundle:nil andJob:result];
    [self.navigationController pushViewController:details animated:YES];
}

- (void) showMenu {
    [self.sideMenuViewController presentRightMenuViewController];
}

- (void) showProfile {
    [self.sideMenuViewController presentLeftMenuViewController];
}

@end
