//
//  EVCFeelingBlueTabViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 6/1/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "EVCFeelingBlueTabViewController.h"
#import "EVCFeelingBlueViewController.h"
#import "EVCCallHistoryTableViewController.h"
#import "EVCResourceLinksTableViewController.h"

@interface EVCFeelingBlueTabViewController ()

@end

@implementation EVCFeelingBlueTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EVCFeelingBlueViewController *fb = [[EVCFeelingBlueViewController alloc] initWithStyle:UITableViewStylePlain];
    EVCCallHistoryTableViewController *ch = [[EVCCallHistoryTableViewController alloc] initWithStyle:UITableViewStylePlain];
    EVCResourceLinksTableViewController *rl = [[EVCResourceLinksTableViewController alloc] initWithNibName:@"EVCResourceLinksTableViewController" bundle:nil andModuleName:@"FeelingBlue"];
    UINavigationController *first = [[UINavigationController alloc] initWithRootViewController:fb];
    UINavigationController *second = [[UINavigationController alloc] initWithRootViewController:ch];
    UINavigationController *third = [[UINavigationController alloc] initWithRootViewController:rl];
    
    UITabBar *bar = self.tabBar;
    
    self.viewControllers = [NSArray arrayWithObjects:first, second, third, nil];
    UITabBarItem *firstItem=  [bar.items objectAtIndex:0];
    UITabBarItem *secondItem = [bar.items objectAtIndex:1];
    UITabBarItem *thirdItem = [bar.items objectAtIndex:2];
    
    UIImage *firstIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"phone2"] scaledToSize:CGSizeMake(30, 30)];
    UIImage *secondIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"phone-icon-gray"] scaledToSize:CGSizeMake(30, 30)];
    
    firstItem.title = @"Main Menu";
    [firstItem setFinishedSelectedImage:firstIm withFinishedUnselectedImage:secondIm];
    
    firstIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"star-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    secondIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"star-icon-gray"] scaledToSize:CGSizeMake(30, 30)];
    
    secondItem.title = @"Call History";
    [secondItem setFinishedSelectedImage:firstIm withFinishedUnselectedImage:secondIm];
    
    firstIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"res-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    secondIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"res-icon-gray"] scaledToSize:CGSizeMake(30, 30)];
    
    
    thirdItem.title = @"Resource Links";
    [thirdItem setFinishedSelectedImage:firstIm withFinishedUnselectedImage:secondIm];

    
    UIImage* image3 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"hamburger-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(showMenu)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    self.navigationItem.title = @"Feeling Blue";
    
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
