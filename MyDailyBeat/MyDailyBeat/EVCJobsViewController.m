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
        jobType = [[NSUserDefaults standardUserDefaults] integerForKey:@"JobTypeFilter"];
        searchRadius = [[NSUserDefaults standardUserDefaults] integerForKey:@"JobSearchRadiusFilter"];
        
    }
    return self;
}

- (void) updateJobType: (JobType) type andRadius: (JobSearchRadius) radius {
    jobType = type;
    searchRadius = radius;
    [[NSUserDefaults standardUserDefaults] setInteger:jobType forKey:@"JobTypeFilter"];
    [[NSUserDefaults standardUserDefaults] setInteger:searchRadius forKey:@"JobSearchRadiusFilter"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    currentPage = 0;
    self.currentSet = [[NSMutableArray alloc] init];
    UIImageView *imgView = (UIImageView *) [self.view viewWithTag:BLUR_VIEW_TAG];
    [UIView animateWithDuration:0.2 animations:^{
        imgView.alpha = 0;
    } completion:^(BOOL finished) {
        [imgView removeFromSuperview];
        [UIView animateWithDuration:0.2 animations:^{
            filterView.alpha = 0;
        } completion:^(BOOL finished) {
            [filterView removeFromSuperview];
            [self run:currentQuery];
        }];
    }];
    
    
}

- (BOOL) hasMore {
    double pagecount = total / 25.0;
    return (pagecount > currentPage);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage* image2 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"filter_icon_white"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg2 = CGRectMake(0, 0, image2.size.width, image2.size.height);
    UIButton *someButton2 = [[UIButton alloc] initWithFrame:frameimg2];
    [someButton2 setBackgroundImage:image2 forState:UIControlStateNormal];
    [someButton2 addTarget:self action:@selector(showFilter)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton2 setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *searchButton =[[UIBarButtonItem alloc] initWithCustomView:someButton2];
    
    UIImage* image3 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"hamburger-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(showMenu)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *menuButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    self.tabBarController.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:menuButton, searchButton, nil];
    
    UIImage* image4 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"profile-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg3 = CGRectMake(0, 0, image4.size.width, image4.size.height);
    UIButton *someButton3 = [[UIButton alloc] initWithFrame:frameimg3];
    [someButton3 setBackgroundImage:image4 forState:UIControlStateNormal];
    [someButton3 addTarget:self action:@selector(showProfile)
          forControlEvents:UIControlEventTouchUpInside];
    [someButton3 setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *profileButton =[[UIBarButtonItem alloc] initWithCustomView:someButton3];
    self.tabBarController.navigationItem.leftBarButtonItem = profileButton;
    
    self.results.dataSource = self;
    self.results.delegate = self;
    self.currentSet = [[NSMutableArray alloc] init];
    jobType = ALL;
    searchRadius = TWENTY_FIVE_MILES;
    
    currentZip = [[RestAPI getInstance] getCurrentUser].zipcode;
    
    [self run:currentQuery];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void) run: (NSString *) query {
    NSString *baseUrl = @"http://api.indeed.com";
    NSString *path = @"ads/apisearch";
    NSString *parameters =[@"publisher=3873225971566005&q=" stringByAppendingString:query];
    parameters = [parameters stringByAppendingString:@"&l="];
    parameters =[parameters stringByAppendingString:currentZip];
    parameters = [parameters stringByAppendingString:@"&sort=&radius="];
    switch (searchRadius) {
        case TWENTY_FIVE_MILES:
            parameters = [parameters stringByAppendingString:@"25"];
            break;
        case FIFTY_MILES:
            parameters = [parameters stringByAppendingString:@"50"];
            break;
        case SEVENTY_FIVE_MILES:
            parameters = [parameters stringByAppendingString:@"75"];
            break;
        case ONE_HUNDRED_MILES:
            parameters = [parameters stringByAppendingString:@"100"];
            break;
        default:
            break;
    }
    parameters = [parameters stringByAppendingString:@"&st=&jt="];
    switch (jobType) {
        case FULL_TIME:
            parameters = [parameters stringByAppendingString:@"fulltime"];
            break;
        case PART_TIME:
            parameters = [parameters stringByAppendingString:@"parttime"];
            break;
        default:
            break;
    }
    NSString *page = [NSString stringWithFormat:@"&start=%d", currentPage];
    parameters = [parameters stringByAppendingString:page];
    parameters = [parameters stringByAppendingString: @"&limit=30000&fromage=&filter=1&latlong=1&co=&chnl=&userip=1.2.3.4&useragent=Mozilla/%2F4.0%28Firefox%29&v=2"];
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
            
        });
        self.resultsDictionary = [[RestAPI getInstance] makeXMLRequestWithBaseUrl:baseUrl withPath:path withParameters:parameters withRequestType:GET_REQUEST andPostData:nil];
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
        
    } else if ([self hasMore]) {
        if (indexPath.row == [self.currentSet count]) {
            cell.textLabel.text = @"More Results...";
            cell.detailTextLabel.text = @"";
        } else {
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
        }
    } else {
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if ([self hasMore]) {
        return [self.currentSet count] + 3;
    } else {
        return [self.currentSet count] + 2;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < [self.currentSet count]) {
        NSDictionary *result = [self.currentSet objectAtIndex:indexPath.row];
    
        EVCJobsDetailsViewController *details = [[EVCJobsDetailsViewController alloc] initWithNibName:@"EVCJobsDetailsViewController" bundle:nil andJob:result];
        [self.navigationController pushViewController:details animated:YES];
        
    } else if (indexPath.row == [self.currentSet count] && [self hasMore]) {
        currentPage += 1;
        [self run:currentQuery];
    } else {
        
    }
}

- (void) showMenu {
    [self.sideMenuViewController presentRightMenuViewController];
}

- (void) showProfile {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void) showFilter {
    filterView = [[EVCJobsFilter alloc] initWithFrame:CGRectMake(10, (self.view.bounds.size.height - 245) / 2, 300, 245)];
    filterView.delegate = self;
    UIImageView *imgView = (UIImageView *) [self.view viewWithTag:BLUR_VIEW_TAG];
    if (!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imgView.tag = BLUR_VIEW_TAG;
        UIImage *screenShot = [EVCCommonMethods imageWithColor:UIColorFromHex(0x0097A4) size:self.view.bounds.size];
        imgView.image = [screenShot blurredImageWithRadius:40 iterations:2 tintColor:[UIColor clearColor]];
        imgView.alpha = 0;
        filterView.alpha = 0;
        [self.view addSubview:imgView];
        [UIView animateWithDuration:0.2 animations:^{
            imgView.alpha = 1;
        } completion:nil];
    }
    [self.view addSubview:filterView];
    [UIView animateWithDuration:0.2 animations:^{
        filterView.alpha = 1;
    } completion:nil];
}

@end
