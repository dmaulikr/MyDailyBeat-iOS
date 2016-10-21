//
//  EVCJobsViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/22/15.
//  Copyright © 2015 eVerveCorp. All rights reserved.
//

#import "EVCVolunteeringViewController.h"

@interface EVCVolunteeringViewController ()

@end

@implementation EVCVolunteeringViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        currentQuery = @"";
        currentPage = 0;
        
    }
    return self;
}

- (BOOL) hasMore {
    double pagecount = total / 10;
    return (pagecount > currentPage);
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
    
    self.tabBarController.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:menuButton, nil];
    
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
    
    currentZip = [[RestAPI getInstance] getCurrentUser].zipcode;
    currentPage = 1;
    [self run:currentQuery];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void) run: (NSString *) query {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
            
        });
        self.resultsDictionary = [[RestAPI getInstance] getOpportunitiesInLocation:currentZip onPage:currentPage];
        NSArray *temp = [self.resultsDictionary objectForKey:@"opportunities"];
        [self.currentSet addObjectsFromArray:temp];
        total = [[self.resultsDictionary objectForKey:@"resultsSize"] intValue];
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
    
        cell.textLabel.text = [result objectForKey:@"title"];
        cell.detailTextLabel.text = [result objectForKey:@"plaintextDescription"];
        
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
    
        EVCVolunteeringDetailsViewController *details = [[EVCVolunteeringDetailsViewController alloc] initWithNibName:@"EVCVolunteeringDetailsViewController" bundle:nil andOpportunity:result];
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

@end
