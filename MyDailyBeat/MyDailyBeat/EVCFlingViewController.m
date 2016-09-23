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

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andInMode: (int) inMode {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (inMode == 0) {
            self.mode = FRIENDS_MODE;
        } else if (inMode == 1) {
            self.mode = FLING_MODE;
        } else {
            self.mode = RELATIONSHIP_MODE;
        }
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.mode == FRIENDS_MODE) {
        self.navigationItem.title = @"Make Friends";
    } else if (self.mode == FLING_MODE) {
        self.navigationItem.title = @"Have a Fling";
    } else {
        self.navigationItem.title = @"Start a Relationship";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    EVCPartnerMatchViewController *partnerMatch = [[EVCPartnerMatchViewController alloc]initWithNibName:@"EVCPartnerMatchViewController" bundle:nil andMode:self.mode];
    EVCPartnersTableViewController *partners = [[EVCPartnersTableViewController alloc]initWithNibName:@"EVCPartnersTableViewController" bundle:nil andMode:self.mode];
    EVCFlingProfileViewController *prof = [[EVCFlingProfileViewController alloc]initWithNibName:@"EVCFlingProfileViewController" bundle:nil andUser:[[RestAPI getInstance] getCurrentUser] andMode:self.mode];
    EVCChatroomTableViewController *messaging = [[EVCChatroomTableViewController alloc] initWithNibName:@"EVCChatroomTableViewController" bundle:nil andMode:self.mode];
    
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
    
    UIImage *firstIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"search-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    UIImage *secondIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"search-icon-gray"] scaledToSize:CGSizeMake(30, 30)];
    
    matchItem.title = @"Match";
    [matchItem setFinishedSelectedImage:firstIm withFinishedUnselectedImage:secondIm];
    
    firstIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"view-partners-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    secondIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"view-partners-icon-gray"] scaledToSize:CGSizeMake(30, 30)];
    
    partnersItem.title = @"Favorites";
    [partnersItem setFinishedSelectedImage:firstIm withFinishedUnselectedImage:secondIm];
    
    firstIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"messages-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    secondIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"messages-icon-gray"] scaledToSize:CGSizeMake(30, 30)];
    
    messagingItem.title = @"Messaging";
    [messagingItem setFinishedSelectedImage:firstIm withFinishedUnselectedImage:secondIm];
    
    firstIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"profile-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    secondIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"profile-icon-gray"] scaledToSize:CGSizeMake(30, 30)];
    
    profItem.title = @"My Profile";
    [profItem setFinishedSelectedImage:firstIm withFinishedUnselectedImage:secondIm];
    
    UIImage* image3 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"hamburger-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(showMenu)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *menuButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    self.navigationItem.rightBarButtonItem = menuButton;
    
    UIImage* image2 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"filter_icon_white"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg3 = CGRectMake(0, 0, image2.size.width, image2.size.height);
    UIButton *someButton3 = [[UIButton alloc] initWithFrame:frameimg3];
    [someButton3 setBackgroundImage:image2 forState:UIControlStateNormal];
    [someButton3 addTarget:self action:@selector(filter)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton3 setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *filterButton =[[UIBarButtonItem alloc] initWithCustomView:someButton3];
    
    self.navigationItem.rightBarButtonItems = @[menuButton, filterButton];
    
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

- (void) flingProf {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[RestAPI getInstance] getFlingProfileForUser:[[RestAPI getInstance] getCurrentUser]] != nil)
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

- (void) filter {

}

@end
