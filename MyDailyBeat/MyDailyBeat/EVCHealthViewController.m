//
//  EVCHealthViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 3/26/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "EVCHealthViewController.h"
#import "EVCMyHealthViewController.h"
#import "EVCResourceLinksTableViewController.h"

@interface EVCHealthViewController ()

@end

@implementation EVCHealthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSData *data1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"myHealthPortal"];
    HealthInfo * temp1 = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    NSData *data2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"myPrescripProvider"];
    PrescripProviderInfo * temp2 = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
    EVCMyHealthViewController *myHealth = [[EVCMyHealthViewController alloc] initWithNibName:@"EVCMyHealthViewController" bundle:nil andPrescriptionProvider:temp2 andHealthPortal:temp1];
    EVCResourceLinksTableViewController *rl = [[EVCResourceLinksTableViewController alloc] initWithNibName:@"EVCResourceLinksTableViewController" bundle:nil andModuleName:@"Health"];
    
    UINavigationController *third = [[UINavigationController alloc] initWithRootViewController:myHealth];
    
    
    EVCPrescriptionProviderTableViewController *prescrip = [[EVCPrescriptionProviderTableViewController alloc] initWithStyle:UITableViewStylePlain];
    EVCHealthPortalTableViewController *hp = [[EVCHealthPortalTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    UINavigationController *first = [[UINavigationController alloc] initWithRootViewController:prescrip];
    UINavigationController *second = [[UINavigationController alloc] initWithRootViewController:hp];
    
    UINavigationController *fourth = [[UINavigationController alloc] initWithRootViewController:rl];
    
    UITabBar *bar = self.tabBar;
    
    self.navigationItem.title = @"Manage My Health";
    
    self.viewControllers = [NSArray arrayWithObjects:third, first, second, fourth, nil];
    UITabBarItem *firstItem=  [bar.items objectAtIndex:0];
    UITabBarItem *matchItem = [bar.items objectAtIndex:1];
    UITabBarItem *partnersItem = [bar.items objectAtIndex:2];
    UITabBarItem *resItem = [bar.items objectAtIndex:3];
    
    UIImage *firstIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"pill-bottle-white"] scaledToSize:CGSizeMake(30, 30)];
    UIImage *secondIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"pill-bottle-grey"] scaledToSize:CGSizeMake(30, 30)];
    
    matchItem.title = @"Rx";
    [matchItem setFinishedSelectedImage:firstIm withFinishedUnselectedImage:secondIm];
    
    firstIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"cadeucus-white"] scaledToSize:CGSizeMake(30, 30)];
    secondIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"cadeucus-grey"] scaledToSize:CGSizeMake(30, 30)];
    
    partnersItem.title = @"Health Portals";
    [partnersItem setFinishedSelectedImage:firstIm withFinishedUnselectedImage:secondIm];
    
    firstIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"star-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    secondIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"star-icon-gray"] scaledToSize:CGSizeMake(30, 30)];
    
    firstItem.title = @"My Health";
    [firstItem setFinishedSelectedImage:firstIm withFinishedUnselectedImage:secondIm];
    
    firstIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"res-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    secondIm = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"res-icon-gray"] scaledToSize:CGSizeMake(30, 30)];
    
    resItem.title = @"Resources";
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
