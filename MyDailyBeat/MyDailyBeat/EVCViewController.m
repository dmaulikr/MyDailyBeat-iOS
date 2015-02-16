//
//  EVCViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/17/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCViewController.h"

@interface EVCViewController ()

@end

@implementation EVCViewController

@synthesize api;

@synthesize mTableView;



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationItem].title = @"Welcome to MyDailyBeat";
    
    options = [NSArray arrayWithObjects:@"My Friends", @"My Fling", @"My Community", @"Health", @"Finance", @"Travel", @"Jobs", @"Volunteering", @"Shopping", nil];
    
    UIImage *image2 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"VerveAPIBundle.bundle/search-icon.png"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg3 = CGRectMake(0, 0, image2.size.width, image2.size.height);
    UIButton *someButton3 = [[UIButton alloc] initWithFrame:frameimg3];
    [someButton3 setBackgroundImage:image2 forState:UIControlStateNormal];
    [someButton3 addTarget:self action:@selector(searchGroups)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton3 setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *searchButton =[[UIBarButtonItem alloc] initWithCustomView:someButton3];

    
    UIImage* image3 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"menu-icon"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(showMenu)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *menuButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    NSArray *rightItems = [NSArray arrayWithObjects:menuButton, searchButton, nil];
    self.navigationItem.rightBarButtonItems = rightItems;
    
    UIImage* image4 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"profile-icon"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg2 = CGRectMake(0, 0, image4.size.width, image4.size.height);
    UIButton *someButton2 = [[UIButton alloc] initWithFrame:frameimg2];
    [someButton2 setBackgroundImage:image4 forState:UIControlStateNormal];
    [someButton2 addTarget:self action:@selector(showProfile)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton2 setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *profileButton =[[UIBarButtonItem alloc] initWithCustomView:someButton2];
    self.navigationItem.leftBarButtonItem = profileButton;
    
    self.mTableView.dataSource = self;
    self.mTableView.delegate = self;
    api = [API getInstance];
    
}

- (void)searchGroups {
    EVCGroupSearchViewViewController *searchController = [[EVCGroupSearchViewViewController alloc] init];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:searchController] animated:YES completion:nil];
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 1:
            switch (indexPath.row) {
                case 1: {
                    EVCFlingViewController *fling = [[EVCFlingViewController alloc] initWithNibName:@"EVCFlingViewController" bundle:nil];
                    [self.navigationController pushViewController:fling animated:YES];
                }
                    
                    break;
                case 8:
                {
                    EVCShoppingViewController *shop = [[EVCShoppingViewController alloc] initWithNibName:@"EVCShoppingViewController" bundle:nil];
                    [self.navigationController pushViewController:shop animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Celler";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"What would you like to do today?";
            break;
        case 1:
            cell.textLabel.text = [options objectAtIndex:indexPath.row];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return [options count];
        default:
            return 1;
    }
}

- (void) showMenu {
    [self.sideMenuViewController presentRightMenuViewController];
}

- (void) showProfile {
    [self.sideMenuViewController presentLeftMenuViewController];
}

@end
