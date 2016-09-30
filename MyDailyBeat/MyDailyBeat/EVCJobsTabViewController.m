//
//  EVCJobsTabViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/27/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "EVCJobsTabViewController.h"

@interface EVCJobsTabViewController ()

@end

@implementation EVCJobsTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    EVCJobsViewController *jobs = [[EVCJobsViewController alloc] initWithNibName:@"EVCJobsViewController" bundle:nil];
    EVCResourceLinksTableViewController *rl = [[EVCResourceLinksTableViewController alloc] initWithNibName:@"EVCResourceLinksTableViewController" bundle:nil andModuleName:@"Jobs"];
    UINavigationController *first = [[UINavigationController alloc] initWithRootViewController:jobs];
    UINavigationController *second = [[UINavigationController alloc] initWithRootViewController:rl];
    
    UITabBar *bar = self.tabBar;
    
    self.navigationItem.title = @"Find a Job";
    
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
