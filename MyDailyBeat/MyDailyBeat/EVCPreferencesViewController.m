//
//  EVCPreferencesViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/23/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCPreferencesViewController.h"

@interface EVCPreferencesViewController ()

@end

@implementation EVCPreferencesViewController

@synthesize makeFriends, fling, volunteer, social, api;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    api = [API getInstance];
    UIImage* image3 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"menu-icon"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(showMenu)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *menuButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem = menuButton;
    
    UIImage* image4 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"profile-icon"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg2 = CGRectMake(0, 0, image4.size.width, image4.size.height);
    UIButton *someButton2 = [[UIButton alloc] initWithFrame:frameimg2];
    [someButton2 setBackgroundImage:image4 forState:UIControlStateNormal];
    [someButton2 addTarget:self action:@selector(showProfile)
          forControlEvents:UIControlEventTouchUpInside];
    [someButton2 setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *profileButton =[[UIBarButtonItem alloc] initWithCustomView:someButton2];
    self.navigationItem.leftBarButtonItem = profileButton;

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)makeFriends:(id)sender {
    EVCMakeFriendsPrefsViewController *controller = [[EVCMakeFriendsPrefsViewController alloc] initWithNibName:@"EVCMakeFriendsPrefsViewController_iPhone" bundle:nil];
    [self.navigationController pushViewController: controller animated:YES];
}

- (IBAction)socialActivites:(id)sender {
    EVCSocialPrefsViewController *controller = [[EVCSocialPrefsViewController alloc] initWithNibName:@"EVCSocialPrefsViewController_iPhone" bundle:nil];
    [self.navigationController pushViewController: controller animated:YES];
}
- (IBAction)fling:(id)sender {
    EVCFlingPrefsViewController *controller = [[EVCFlingPrefsViewController alloc] initWithNibName:@"EVCFlingPrefsViewController_iPhone" bundle:nil];
    [self.navigationController pushViewController: controller animated:YES];
}

- (IBAction)volunteer:(id)sender {
    EVCVolunteeringPrefsViewController *controller = [[EVCVolunteeringPrefsViewController alloc] initWithNibName:@"EVCVolunteeringPrefsViewController_iPhone" bundle:nil];
    [self.navigationController pushViewController: controller animated:YES];
}

- (void) showMenu {
    [self.sideMenuViewController presentRightMenuViewController];
}

- (void) showProfile {
    [self.sideMenuViewController presentLeftMenuViewController];
}



@end
