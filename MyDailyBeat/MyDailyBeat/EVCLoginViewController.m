//
//  EVCLoginViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/18/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCLoginViewController.h"
#import "EVCRegistrationMessageViewController.h"

@interface EVCLoginViewController ()

@end

@implementation EVCLoginViewController

@synthesize userNameFeild,passWordFeild;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    header.image = [UIImage imageNamed:@"Logo.png"];

    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadLoginData];
}

- (void) loadLoginData {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        NSString *defScreenName = [[NSUserDefaults standardUserDefaults] stringForKey:KEY_SCREENNAME];
        NSString *defPass = [[NSUserDefaults standardUserDefaults] stringForKey:KEY_PASSWORD];
        NSMutableArray *groups = [[NSMutableArray alloc] init];
        if (defScreenName != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToastActivity];
            });
            [[RestAPI getInstance] loginWithScreenName:defScreenName andPassword:defPass];
            groups = [[RestAPI getInstance] getGroupsForCurrentUser];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                RESideMenu *sideMenuViewController;
                
                EVCProfileViewController *profile = [[EVCProfileViewController alloc] initWithNibName:@"EVCProfileViewController_iPhone" bundle:nil];
                EVCViewController *controller = [[EVCViewController alloc] initWithNibName:@"EVCViewController_iPhone" bundle:nil];
                UINavigationController *root = [[UINavigationController alloc] initWithRootViewController:controller];
                EVCMenuViewController *menu = [[EVCMenuViewController alloc] initWithGroups:groups andParent:root];
                
                sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:root
                                                                    leftMenuViewController:[[UINavigationController alloc] initWithRootViewController:profile]
                                                                   rightMenuViewController:menu];
                sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
                sideMenuViewController.delegate = (EVCAppDelegate *)[[UIApplication sharedApplication] delegate];
                UIColor *bgcolor = UIColorFromHex(0x0097A4);
                CGSize bgsize = CGSizeMake(640, 1136);
                sideMenuViewController.backgroundImage = [EVCCommonMethods imageWithColor:bgcolor size:bgsize];
                sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
                sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
                sideMenuViewController.contentViewShadowOpacity = 0.6;
                sideMenuViewController.contentViewShadowRadius = 12;
                sideMenuViewController.contentViewShadowEnabled = YES;
                self.view.window.rootViewController = sideMenuViewController;
                [self.view hideToastActivity];
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }
        
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(id)sender {
    NSString *username = userNameFeild.text;
    NSString *pass = passWordFeild.text;
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        NSMutableArray *groups = [[NSMutableArray alloc] init];
        BOOL success = [[RestAPI getInstance] loginWithScreenName:username andPassword:pass];
        if (success) {
            groups = [[RestAPI getInstance] getGroupsForCurrentUser];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSUserDefaults standardUserDefaults] setObject:username forKey:KEY_SCREENNAME];
                [[NSUserDefaults standardUserDefaults] setObject:pass forKey:KEY_PASSWORD];
                RESideMenu *sideMenuViewController;
                EVCProfileViewController *profile = [[EVCProfileViewController alloc] initWithNibName:@"EVCProfileViewController_iPhone" bundle:nil];
                EVCViewController *controller = [[EVCViewController alloc] initWithNibName:@"EVCViewController_iPhone" bundle:nil];
                UINavigationController *root = [[UINavigationController alloc] initWithRootViewController:controller];
                EVCMenuViewController *menu = [[EVCMenuViewController alloc] initWithGroups:groups andParent:root];
                
                sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:root
                                                                    leftMenuViewController:[[UINavigationController alloc] initWithRootViewController:profile]
                                                                   rightMenuViewController:menu];
                sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
                sideMenuViewController.delegate = (EVCAppDelegate *)[[UIApplication sharedApplication] delegate];
                UIColor *bgcolor = UIColorFromHex(0x0097A4);
                CGSize bgsize = CGSizeMake(640, 1136);
                sideMenuViewController.backgroundImage = [EVCCommonMethods imageWithColor:bgcolor size:bgsize];
                sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
                sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
                sideMenuViewController.contentViewShadowOpacity = 0.6;
                sideMenuViewController.contentViewShadowRadius = 12;
                sideMenuViewController.contentViewShadowEnabled = YES;
                self.view.window.rootViewController = sideMenuViewController;
                [self.view hideToastActivity];
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view hideToastActivity];
                [self.view makeToast:@"Username and password do not match." duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"error.png"]];
            });
        }
        
    });
    
    
}



@end
