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
    EVCFlingProfileViewController *prof = [[EVCFlingProfileViewController alloc]initWithNibName:@"EVCFlingProfileViewController" bundle:nil];
    EVCFlingMessagingViewController *messaging = [[EVCFlingMessagingViewController alloc] init];
    
    UITabBar *bar = self.tabBar;

    self.viewControllers = [NSArray arrayWithObjects:partnerMatch, partners, messaging, prof, nil];
    
    UITabBarItem *matchItem = [bar.items objectAtIndex:0];
    UITabBarItem *partnersItem = [bar.items objectAtIndex:1];
    UITabBarItem *messagingItem = [bar.items objectAtIndex:2];
    UITabBarItem *profItem = [bar.items objectAtIndex:3];
    
    matchItem.title = @"Partner Match";
    partnersItem.title = @"View Partners";
    messagingItem.title = @"Messaging";
    profItem.title = @"My Fling Profile";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
