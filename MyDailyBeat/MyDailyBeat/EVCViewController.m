//
//  EVCViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/17/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCViewController.h"

@interface EVCViewController ()

@end

@implementation EVCViewController

@synthesize api;

@synthesize mTableView;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    options = [NSArray arrayWithObjects:@"Check My Finances", @"Reach Out ...\nI'm Feeling Blue", @"Find a Job", @"Go Shopping", @"Start a Relationship", @"Make Friends", @"Manage My Health", @"Travel", @"Volunteer", nil];
    imageNames = [NSArray arrayWithObjects:@"finance", @"phone", @"briefcase", @"cart", @"hearts", @"peeps", @"health", @"plane", @"hands", nil];
    
    /*UIImage *image2 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"search-icon-white.png"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg3 = CGRectMake(0, 0, image2.size.width, image2.size.height);
    UIButton *someButton3 = [[UIButton alloc] initWithFrame:frameimg3];
    [someButton3 setBackgroundImage:image2 forState:UIControlStateNormal];
    [someButton3 addTarget:self action:@selector(searchGroups)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton3 setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *searchButton =[[UIBarButtonItem alloc] initWithCustomView:someButton3];*/

    
    UIImage* image3 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"hamburger-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(showMenu)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *menuButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    NSArray *rightItems = [NSArray arrayWithObjects:menuButton, nil];
    self.navigationItem.rightBarButtonItems = rightItems;
    
    UIImage* image4 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"profile-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg2 = CGRectMake(0, 0, image4.size.width, image4.size.height);
    UIButton *someButton2 = [[UIButton alloc] initWithFrame:frameimg2];
    [someButton2 setBackgroundImage:image4 forState:UIControlStateNormal];
    [someButton2 addTarget:self action:@selector(showProfile)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton2 setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *profileButton =[[UIBarButtonItem alloc] initWithCustomView:someButton2];
    self.navigationItem.leftBarButtonItem = profileButton;
    
    self.mTableView.dataSource = self;
    self.mTableView.delegate = self;
    api = [API getInstance];
    NSString *name = [api getCurrentUser].name;
    NSArray *fields = [name componentsSeparatedByString:@" "];
    [self navigationItem].title = [NSString stringWithFormat:@"Welcome %@!", fields[0]];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ UITextAttributeTextColor :[UIColor whiteColor] } forState:UIControlStateSelected];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    
    
}

- (void) dismissGroupSearchViewController: (EVCGroupSearchViewViewController *) controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchGroups {
    /*EVCGroupSearchViewViewController *searchController = [[EVCGroupSearchViewViewController alloc] init];
    searchController.delegate = self;
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:searchController] animated:YES];*/
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 1:
            switch (indexPath.row) {
                case 4: {
                    EVCFlingViewController *fling = [[EVCFlingViewController alloc] initWithNibName:@"EVCFlingViewController" bundle:nil];
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:fling] animated:YES];
                }
                    
                    break;
                case 3:
                {
                    EVCShoppingViewController *shop = [[EVCShoppingViewController alloc] initWithNibName:@"EVCShoppingViewController" bundle:nil];
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:shop] animated:YES];
                }
                    break;
                case 1:
                {
                     EVCFeelingBlueViewController *fb = [[EVCFeelingBlueViewController alloc] initWithNibName:@"EVCFeelingBlueViewController" bundle:nil];
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:fb] animated:YES];
                }
                    break;
                    
                case 0:
                {
                    EVCFinanceViewController *finance = [[EVCFinanceViewController alloc] initWithNibName:@"EVCFinanceViewController" bundle:nil];
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:finance] animated:YES];
                    break;
                }
                    
                case 8: {
                    EVCVolunteeringMapViewController *mapTest = [[EVCVolunteeringMapViewController alloc] initWithNibName:@"EVCVolunteeringMapViewController" bundle:nil];
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:mapTest] animated:YES];
                    break;
                }
                case 7: {
                    EVCTravelTableViewController *travel = [[EVCTravelTableViewController alloc] initWithNibName:@"EVCTravelTableViewController" bundle:nil];
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:travel] animated:YES];
                    break;
                }
                    
                case 2: {
                    EVCJobsViewController *jobs = [[EVCJobsViewController alloc] initWithNibName:@"EVCJobsViewController" bundle:nil];
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:jobs] animated:YES];
                    break;
                }
                    
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Celler";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    
    
    switch (indexPath.section) {
        case 0: {
            cell.textLabel.text = @"What would you like to do?";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case 1: {
            cell.textLabel.text = [options objectAtIndex:indexPath.row];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
            UIImage *icon = [UIImage imageNamed:[imageNames objectAtIndex:indexPath.row]];
            cell.imageView.image = [EVCCommonMethods imageWithImage:icon scaledToSize:CGSizeMake(30, 30)];
        }
            break;
            
        default:
            break;
    }
    
    //cell.contentView.backgroundColor = UIColorFromHex(0xEEE2BE);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 35;
            break;
            
        case 1:
            if ([(NSString *)[options objectAtIndex:indexPath.row] isEqualToString:@"Reach Out ...\nI'm Feeling Blue"]) {
                return 43;
            } else {
                return 42;
            }
            break;
    }
    return 35;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return [options count];
        default:
            return 1;
    }
}

- (void) showMenu {
    [self.sideMenuViewController presentRightMenuViewController];
}

- (void) showProfile {
    [self.sideMenuViewController presentLeftMenuViewController];
}

@end
