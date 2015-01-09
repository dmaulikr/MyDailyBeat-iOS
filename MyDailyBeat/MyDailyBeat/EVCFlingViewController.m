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
    
    matchItem.title = @"Partner Match";
    partnersItem.title = @"View Partners";
    messagingItem.title = @"Messaging";
    profItem.title = @"My Fling Profile";
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
