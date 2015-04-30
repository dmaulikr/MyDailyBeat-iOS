//
//  EVCFlingViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/21/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCFlingViewController.h"

@interface EVCFlingViewController ()

@end

@implementation EVCFlingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EVCPartnerMatchViewController *partnerMatch = [[EVCPartnerMatchViewController alloc]initWithNibName:@"EVCPartnerMatchViewController" bundle:nil];
    EVCPartnersTableViewController *partners = [[EVCPartnersTableViewController alloc]initWithNibName:@"EVCPartnersTableViewController" bundle:nil];
    EVCFlingProfileViewController *prof = [[EVCFlingProfileViewController alloc]initWithNibName:@"EVCFlingProfileViewController" bundle:nil andUser:[[API getInstance] getCurrentUser]];
    EVCChatroomTableViewController *messaging = [[EVCChatroomTableViewController alloc] init];
    
    UINavigationController *first = [[UINavigationController alloc] initWithRootViewController:partnerMatch];
    UINavigationController *second = [[UINavigationController alloc] initWithRootViewController:partners];
    UINavigationController *third = [[UINavigationController alloc] initWithRootViewController:messaging];
    UINavigationController *fourth = [[UINavigationController alloc] initWithRootViewController:prof];
    
    UITabBar *bar = self.tabBar;

    self.viewControllers = [NSArray arrayWithObjects:first, second, third, fourth, nil];
    
    UITabBarItem *matchItem = [bar.items objectAtIndex:0];
    UITabBarItem *partnersItem = [bar.items objectAtIndex:1];
    UITabBarItem *messagingItem = [bar.items objectAtIndex:2];
    UITabBarItem *profItem = [bar.items objectAtIndex:3];
    
    UIImage *firstIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"search-icon-green"] scaledToSize:CGSizeMake(30, 30)];
    UIImage *secondIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"search-icon-gray"] scaledToSize:CGSizeMake(30, 30)];
    
    matchItem.title = @"Partner Match";
    [matchItem setFinishedSelectedImage:firstIm withFinishedUnselectedImage:secondIm];
    
    firstIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"view-partners-icon-green"] scaledToSize:CGSizeMake(30, 30)];
    secondIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"view-partners-icon-gray"] scaledToSize:CGSizeMake(30, 30)];
    
    partnersItem.title = @"Favorite Partners";
    [partnersItem setFinishedSelectedImage:firstIm withFinishedUnselectedImage:secondIm];
    
    firstIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"messages-icon-green"] scaledToSize:CGSizeMake(30, 30)];
    secondIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"messages-icon-gray"] scaledToSize:CGSizeMake(30, 30)];
    
    messagingItem.title = @"Messaging";
    [messagingItem setFinishedSelectedImage:firstIm withFinishedUnselectedImage:secondIm];
    
    firstIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"profile-icon-green"] scaledToSize:CGSizeMake(30, 30)];
    secondIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"profile-icon-gray"] scaledToSize:CGSizeMake(30, 30)];
    
    profItem.title = @"My Fling Profile";
    [profItem setFinishedSelectedImage:firstIm withFinishedUnselectedImage:secondIm];
    
    UIImage* image3 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"hamburger-icon-green"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(showMenu)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *menuButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    self.navigationItem.rightBarButtonItem = menuButton;
    
    UIImage* image4 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"profile-icon-green"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg2 = CGRectMake(0, 0, image4.size.width, image4.size.height);
    UIButton *someButton2 = [[UIButton alloc] initWithFrame:frameimg2];
    [someButton2 setBackgroundImage:image4 forState:UIControlStateNormal];
    [someButton2 addTarget:self action:@selector(showProfile)
          forControlEvents:UIControlEventTouchUpInside];
    [someButton2 setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *profileButton =[[UIBarButtonItem alloc] initWithCustomView:someButton2];
    self.navigationItem.leftBarButtonItem = profileButton;
}

- (void) flingProf {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[API getInstance] getFlingProfileForUser:[[API getInstance] getCurrentUser]] != nil)
            {
                EVCFlingProfileCreatorViewController *creator = [[EVCFlingProfileCreatorViewController alloc] initWithNibName:@"EVCFlingProfileCreatorViewController" bundle:nil];
                [self.navigationController presentViewController:creator animated:YES completion:nil];
            }
        });
    });
}

- (void) showMenu {
    [self.sideMenuViewController presentRightMenuViewController];
}

- (void) showProfile {
    [self.sideMenuViewController presentLeftMenuViewController];
}

@end
