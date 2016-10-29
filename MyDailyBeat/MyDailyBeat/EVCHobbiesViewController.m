//
//  EVCHobbiesViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 7/3/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "EVCHobbiesViewController.h"
#import "EVCHobbiesMatchTableViewController.h"
#import "EVCResourceLinksTableViewController.h"
#import "EVCCommonMethods.h"

@interface EVCHobbiesViewController ()

@end

@implementation EVCHobbiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    EVCHobbiesMatchTableViewController *hobbies = [[EVCHobbiesMatchTableViewController alloc] initWithNibName:@"EVCHobbiesMatchTableViewController" bundle:nil];
    EVCResourceLinksTableViewController *reso = [[EVCResourceLinksTableViewController alloc] initWithNibName:@"EVCResourceLinksTableViewController" bundle:nil];
    
    UINavigationController *first = [[UINavigationController alloc] initWithRootViewController:hobbies];
    UINavigationController *second = [[UINavigationController alloc] initWithRootViewController:reso];
    
    UITabBar *bar = self.tabBar;
    
    self.navigationItem.title = @"My Hobbies";
    
    self.viewControllers = [NSArray arrayWithObjects:first, second, nil];
    UITabBarItem *firstItem=  [bar.items objectAtIndex:0];
    UITabBarItem *matchItem = [bar.items objectAtIndex:1];
    
    UIImage *firstIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"pill-bottle-white"] scaledToSize:CGSizeMake(30, 30)];
    UIImage *secondIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"pill-bottle-grey"] scaledToSize:CGSizeMake(30, 30)];
    
    matchItem.title = @"Resource Links";
    [matchItem setFinishedSelectedImage:firstIm withFinishedUnselectedImage:secondIm];
    
    firstIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"star-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    secondIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"star-icon-gray"] scaledToSize:CGSizeMake(30, 30)];
    
    firstItem.title = @"My Hobbies";
    [firstItem setFinishedSelectedImage:firstIm withFinishedUnselectedImage:secondIm];
    
    
    
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
