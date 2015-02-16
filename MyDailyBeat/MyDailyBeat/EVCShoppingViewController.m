//
//  EVCShoppingViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 1/25/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import "EVCShoppingViewController.h"

@interface EVCShoppingViewController ()

@end

@implementation EVCShoppingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    EVCShoppingSearchViewController *search = [[EVCShoppingSearchViewController alloc] initWithNibName:@"EVCShoppingSearchViewController" bundle:nil];
    EVCShoppingFavoritesTableViewController *favs = [[EVCShoppingFavoritesTableViewController alloc] initWithNibName:@"EVCShoppingFavoritesTableViewController" bundle:nil];
    
    UINavigationController *first = [[UINavigationController alloc] initWithRootViewController:search];
    UINavigationController *second = [[UINavigationController alloc] initWithRootViewController:favs];
    
    UITabBar *bar = self.tabBar;
    
    self.viewControllers = [NSArray arrayWithObjects:first, second, nil];
    
    UITabBarItem *matchItem = [bar.items objectAtIndex:0];
    UITabBarItem *partnersItem = [bar.items objectAtIndex:1];
    
    UIImage *firstIm = [UIImage imageNamed:@"search-green"];
    UIImage *secondIm = [UIImage imageNamed:@"search-yellow"];
    
    matchItem.title = @"Search URLs";
    [matchItem setFinishedSelectedImage:firstIm withFinishedUnselectedImage:secondIm];
    
    firstIm = [UIImage imageNamed:@"favorite-icon-green"];
    secondIm = [UIImage imageNamed:@"favorite-icon-green"];
    
    partnersItem.title = @"View Favorites";
    [partnersItem setFinishedSelectedImage:firstIm withFinishedUnselectedImage:secondIm];


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
