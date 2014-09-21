//
//  EVCAppDelegate.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/17/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCAppDelegate.h"

@implementation EVCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        NSString *defScreenName = [[NSUserDefaults standardUserDefaults] stringForKey:KEY_SCREENNAME];
        NSString *defPass = [[NSUserDefaults standardUserDefaults] stringForKey:KEY_PASSWORD];
        if (defScreenName != nil)
            [[API getInstance] loginWithScreenName:defScreenName andPassword:defPass];
        NSMutableArray *groups = [[NSMutableArray alloc] init];
        //NSMutableArray *groups = [[API getInstance] getGroupsForCurrentUser];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            RESideMenu *sideMenuViewController;
            EVCMenuViewController *menu = [[EVCMenuViewController alloc] initWithGroups:groups];
            
            
            if ([self hasEverBeenLaunched]) {
                EVCViewController *controller = [[EVCViewController alloc] initWithNibName:@"EVCViewController_iPhone" bundle:nil];
                sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:[[UINavigationController alloc] initWithRootViewController:controller]
                                                                    leftMenuViewController:menu
                                                                   rightMenuViewController:nil];
                sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
                sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
                sideMenuViewController.delegate = self;
                sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
                sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
                sideMenuViewController.contentViewShadowOpacity = 0.6;
                sideMenuViewController.contentViewShadowRadius = 12;
                sideMenuViewController.contentViewShadowEnabled = YES;
                self.window.rootViewController = sideMenuViewController;
            } else {
                EVCRegistrationViewController *controller = [[EVCRegistrationViewController alloc] initWithNibName:@"EVCRegistrationViewController_iPhone" bundle:nil];
                self.window.rootViewController = controller;
            }
            
            [self.window makeKeyAndVisible];
            
        });
    });
    

    return YES;
}

- (BOOL)hasEverBeenLaunched
{
    // A boolean which determines if app has eer been launched
    BOOL hasBeenLaunched;
    
    // Testig if application has launched before and if it has to show the home-login screen        to login
    // to social networks (facebook, Twitter)
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasAlreadyLaunched"]) {
        // Setting variable to YES because app has been launched before
        hasBeenLaunched = YES;
        NSLog(@"App has been already launched");
    } else {
        // Setting variable to NO because app hasn't been launched before
        hasBeenLaunched = NO;
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasAlreadyLaunched"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"This is the first run ever...");
    }
    
    return hasBeenLaunched;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
