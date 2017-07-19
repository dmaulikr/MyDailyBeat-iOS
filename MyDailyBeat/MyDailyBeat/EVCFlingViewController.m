//
//  EVCFlingViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/21/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCFlingViewController.h"
#import "EVCResourceLinksTableViewController.h"

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
    [[NSUserDefaults standardUserDefaults] setInteger:self.mode forKey:@"REL_MODE"];
    NSString *title = @"";
    switch (self.mode) {
        case FRIENDS_MODE:
            title = @"Make Friends";
            break;
        case FLING_MODE:
            title = @"Have a Fling";
            break;
        case RELATIONSHIP_MODE:
            title = @"Start a Relationship";
            break;
    }
    self.navigationItem.title = title;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    EVCPartnerMatchViewController *partnerMatch = [[EVCPartnerMatchViewController alloc]initWithNibName:@"EVCPartnerMatchViewController" bundle:nil];
    EVCPartnersTableViewController *partners = [[EVCPartnersTableViewController alloc]initWithNibName:@"EVCPartnersTableViewController" bundle:nil];
    EVCFlingProfileViewController *prof = [[EVCFlingProfileViewController alloc]initWithNibName:@"EVCFlingProfileViewController" bundle:nil andUser:[[RestAPI getInstance] getCurrentUser]];
    EVCChatroomTableViewController *messaging = [[EVCChatroomTableViewController alloc] initWithNibName:@"EVCChatroomTableViewController" bundle:nil];
    EVCResourceLinksTableViewController *rl = [[EVCResourceLinksTableViewController alloc] initWithNibName:@"EVCResourceLinksTableViewController" bundle:nil andModuleName:@"Relationships"];
    
    UINavigationController *first = [[UINavigationController alloc] initWithRootViewController:partnerMatch];
    UINavigationController *second = [[UINavigationController alloc] initWithRootViewController:partners];
    UINavigationController *third = [[UINavigationController alloc] initWithRootViewController:messaging];
    UINavigationController *fourth = [[UINavigationController alloc] initWithRootViewController:prof];
    
    UITabBar *bar = self.tabBar;

    self.viewControllers = [NSArray arrayWithObjects:first, second, third, fourth, rl, nil];
    
    UITabBarItem *matchItem = [bar.items objectAtIndex:0];
    UITabBarItem *partnersItem = [bar.items objectAtIndex:1];
    UITabBarItem *messagingItem = [bar.items objectAtIndex:2];
    UITabBarItem *profItem = [bar.items objectAtIndex:3];
    UITabBarItem *rlItem = [bar.items objectAtIndex:4];
    
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
    
    profItem.title = @"Profile";
    [profItem setFinishedSelectedImage:firstIm withFinishedUnselectedImage:secondIm];
    
    firstIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"res-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    secondIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"res-icon-gray"] scaledToSize:CGSizeMake(30, 30)];
    
    
    rlItem.title = @"Resources";
    [rlItem setFinishedSelectedImage:firstIm withFinishedUnselectedImage:secondIm];

    
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

- (void) flingProf {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[RestAPI getInstance] getFlingProfileForUser:[[RestAPI getInstance] getCurrentUser]].screenName == nil)
            {
                DLAVAlertView *alert = [[DLAVAlertView alloc] initWithTitle:@"Create your Profile" message:@"To fully enjoy all the features of MyDailyBeat, you need to create a relationship profile. This unified profile is used across the Have a Fling, Start a Relationship, and Make Friends sections of this app." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                    EVCFlingProfileCreatorViewController *edit = [[EVCFlingProfileCreatorViewController alloc] initWithNibName:@"EVCFlingProfileCreatorViewController" bundle:nil];
                    [self.navigationController pushViewController:edit animated:YES];
                }];
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
