//
//  EVCJobsTabViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/27/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "EVCVolunteeringTabViewController.h"

@interface EVCVolunteeringTabViewController ()

@end

@implementation EVCVolunteeringTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    EVCVolunteeringViewController *volunteer = [[EVCVolunteeringViewController alloc] initWithNibName:@"EVCVolunteeringViewController" bundle:nil];
    EVCResourceLinksTableViewController *rl = [[EVCResourceLinksTableViewController alloc] initWithNibName:@"EVCResourceLinksTableViewController" bundle:nil andModuleName:@"Volunteering"];
    UINavigationController *first = [[UINavigationController alloc] initWithRootViewController:volunteer];
    UINavigationController *second = [[UINavigationController alloc] initWithRootViewController:rl];
    
    UITabBar *bar = self.tabBar;
    
    self.navigationItem.title = @"Search Opportunities";
    
    self.viewControllers = [NSArray arrayWithObjects:first, second, nil];
    
    UITabBarItem *favItem = [bar.items objectAtIndex:0];
    UITabBarItem *resItem = [bar.items objectAtIndex:1];
    
    UIImage *firstIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"search-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    UIImage *secondIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"search-icon-gray"] scaledToSize:CGSizeMake(30, 30)];
    
    favItem.title = @"Search Jobs";
    [favItem setFinishedSelectedImage:firstIm withFinishedUnselectedImage:secondIm];
    
    firstIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"res-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    secondIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"res-icon-gray"] scaledToSize:CGSizeMake(30, 30)];
    
    resItem.title = @"Resource Links";
    [resItem setFinishedSelectedImage:firstIm withFinishedUnselectedImage:secondIm];
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

@end
