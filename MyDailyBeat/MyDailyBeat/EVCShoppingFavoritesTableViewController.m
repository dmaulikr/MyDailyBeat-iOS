//
//  EVCShoppingFavoritesTableViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 1/29/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import "EVCShoppingFavoritesTableViewController.h"

@interface EVCShoppingFavoritesTableViewController ()

@end

@implementation EVCShoppingFavoritesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadData {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        
        NSDictionary *dic2 = [[RestAPI getInstance] getShoppingFavoritesForUser:[[RestAPI getInstance] getCurrentUser] withSortOrder:ASCENDING];
        self.searchResults = [dic2 objectForKey:@"items"];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            [self.tableView reloadData];
        });
    });
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    
    cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AHKActionSheet *sheet = [[AHKActionSheet alloc] initWithTitle:@""];
    [sheet addButtonWithTitle:@"Open in Browser" type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet) {
        [self openURLinBrowser: [self.searchResults objectAtIndex:indexPath.row]];
    }];
    [sheet addButtonWithTitle:@"Add to Favorites" type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet) {
        NSLog(@"%@", [self.searchResults objectAtIndex:indexPath.row]);
        [self addToFavs: [self.searchResults objectAtIndex:indexPath.row]];
    }];
    [sheet show];
}

- (void) openURLinBrowser: (NSString *) url {
    NSString *fullURL = [NSString stringWithFormat:@"http://www.%@", url];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fullURL]];

}

- (void) addToFavs: (NSString *) url {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        [[RestAPI getInstance] addShoppingFavoriteURL:url ForUser:[[RestAPI getInstance] getCurrentUser]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            [self.tableView reloadData];
        });
        
    });
}

- (void) showMenu {
    [self.sideMenuViewController presentRightMenuViewController];
}

- (void) showProfile {
    [self.sideMenuViewController presentLeftMenuViewController];
}
@end
