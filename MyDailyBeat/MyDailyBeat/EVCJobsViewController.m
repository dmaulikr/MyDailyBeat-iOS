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
        currentQuery = @"";
        currentPage = 0;
        
    }
    return self;
}

- (BOOL) hasMore {
    double pagecount = total / 25.0;
    return (pagecount > currentPage);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage* image2 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"search-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg3 = CGRectMake(0, 0, image2.size.width, image2.size.height);
    UIButton *someButton3 = [[UIButton alloc] initWithFrame:frameimg3];
    [someButton3 setBackgroundImage:image2 forState:UIControlStateNormal];
    [someButton3 addTarget:self action:@selector(showSearchBar)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton3 setShowsTouchWhenHighlighted:YES];
    
    self.navigationItem.title = @"Find a Job";
    
    UIBarButtonItem *searchButton =[[UIBarButtonItem alloc] initWithCustomView:someButton3];
    
    UIImage* image3 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"hamburger-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(showMenu)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *menuButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    NSArray *array = [[NSArray alloc] initWithObjects:menuButton, searchButton, nil];
    
    self.navigationItem.rightBarButtonItems = array;
    
    UIImage* image4 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"profile-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg2 = CGRectMake(0, 0, image4.size.width, image4.size.height);
    UIButton *someButton2 = [[UIButton alloc] initWithFrame:frameimg2];
    [someButton2 setBackgroundImage:image4 forState:UIControlStateNormal];
    [someButton2 addTarget:self action:@selector(showProfile)
          forControlEvents:UIControlEventTouchUpInside];
    [someButton2 setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *profileButton =[[UIBarButtonItem alloc] initWithCustomView:someButton2];
    self.navigationItem.leftBarButtonItem = profileButton;
    
    self.results.dataSource = self;
    self.results.delegate = self;
    self.mBar.delegate = self;
    self.currentSet = [[NSMutableArray alloc] init];
    
    currentZip = [[RestAPI getInstance] getCurrentUser].zipcode;
    
    [self run:currentQuery];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSString *query = [searchBar text];
    currentQuery = query;
    currentPage = 0;
    self.currentSet = [[NSMutableArray alloc] init];
    [searchBar setShowsCancelButton:NO animated:YES];
    [self run:query];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    NSString *query = @"";
    currentQuery = @"";
    currentPage = 0;
    self.currentSet = [[NSMutableArray alloc] init];
    [searchBar setShowsCancelButton:NO animated:YES];
    self.results.tableHeaderView = nil;
    [self run:query];
}

- (void) run: (NSString *) query {
    NSString *baseUrl = @"http://api.indeed.com";
    NSString *path = @"ads/apisearch";
    NSString *parameters =[@"publisher=3873225971566005&q=" stringByAppendingString:query];
    parameters = [parameters stringByAppendingString:@"&l="];
    parameters =[parameters stringByAppendingString:currentZip];
    parameters = [parameters stringByAppendingString:@"&sort=&radius=&st=&jt=&start="];
    NSString *page = [NSString stringWithFormat:@"%d", currentPage];
    parameters = [parameters stringByAppendingString:page];
    parameters = [parameters stringByAppendingString: @"&limit=30000&fromage=&filter=1&latlong=1&co=us&chnl=&userip=1.2.3.4&useragent=Mozilla/%2F4.0%28Firefox%29&v=2"];
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
            
        });
        self.resultsDictionary = [[RestAPI getInstance] makeXMLRequestWithBaseUrl:baseUrl withPath:path withParameters:parameters withRequestType:GET_REQUEST andPostData:nil];
        NSLog(@"Results: %@", self.resultsDictionary);
        NSDictionary *results = [self.resultsDictionary objectForKey:@"results"];
        NSArray *temp = [results objectForKey:@"result"];
        [self.currentSet addObjectsFromArray:temp];
        total = [[self.resultsDictionary objectForKey:@"totalresults"] intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            [self.results reloadData];
            
            
        });
    });
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifiter = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiter];
    
    if (cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifiter];
    }
    
    if (indexPath.row < [self.currentSet count]) {
        NSDictionary *result = [self.currentSet objectAtIndex:indexPath.row];
    
        cell.textLabel.text = [result objectForKey:@"jobtitle"];
        cell.detailTextLabel.text = [result objectForKey:@"company"];
        
    } else {
        cell.textLabel.text = @"More Results...";
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if ([self hasMore]) {
        return [self.currentSet count] + 1;
    } else {
        return [self.currentSet count];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < [self.currentSet count]) {
        NSDictionary *result = [self.currentSet objectAtIndex:indexPath.row];
    
        EVCJobsDetailsViewController *details = [[EVCJobsDetailsViewController alloc] initWithNibName:@"EVCJobsDetailsViewController" bundle:nil andJob:result];
        [self.navigationController pushViewController:details animated:YES];
        
    } else {
        currentPage += 1;
        [self run:currentQuery];
    }
}

- (void) showMenu {
    [self.sideMenuViewController presentRightMenuViewController];
}

- (void) showProfile {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void) showSearchBar {
    self.results.tableHeaderView = self.mBar;
}

@end
