//
//  EVCFirstTimeSetupViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 7/12/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "EVCFirstTimeSetupViewController.h"
#import "EVCFirstTimePreferencesViewController.h"

@interface EVCFirstTimeSetupViewController ()

@end

@implementation EVCFirstTimeSetupViewController

@synthesize api;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    api = [RestAPI getInstance];
    [self.message setText:@"Welcome to MyDailyBeat! Before you begin, please set the following preferences."];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)next:(id)sender {
    VervePreferences *prefs = [[VervePreferences alloc] init];
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        prefs.userPreferences = [api getUserPreferencesForUser:[api getCurrentUser]];
        prefs.matchingPreferences = [api getMatchingPreferencesForUser:[api getCurrentUser]];
        prefs.hobbiesPreferences = [api getHobbiesPreferencesForUserWithScreenName:[api getCurrentUser].screenName];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            EVCFirstTimePreferencesViewController *prefsView = [[EVCFirstTimePreferencesViewController alloc] initWithNibName:@"EVCFirstTimePreferencesViewController" bundle:nil];
            [self.navigationController pushViewController:prefsView animated:YES];
        });
    });
    
}

@end
