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

@synthesize date, makeFriends, fling, volunteer, social, api;

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

- (IBAction)relationship:(id)sender {
    EVCRelationshipPrefsViewController *controller = [[EVCRelationshipPrefsViewController alloc] initWithNibName:@"EVCRelationshipPrefsViewController_iPhone" bundle:nil];
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



@end
