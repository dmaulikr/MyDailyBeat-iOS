//
//  EVCTravelTableViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/31/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import "EVCTravelTableViewController.h"

@interface EVCTravelTableViewController ()

@end

@implementation EVCTravelTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.travelSites = [[NSMutableArray alloc] initWithArray:TRAVEL_SITES copyItems:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    
    cell.textLabel.text = [self.travelSites objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [self.travelSites count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *action = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *open = [UIAlertAction actionWithTitle:@"Open URL in Browser" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self openURLinBrowser: [self.travelSites objectAtIndex:indexPath.row]];
    }];
    UIAlertAction *addFav = [UIAlertAction actionWithTitle:@"Add URL to Favorites" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

    }];
    
    [action addAction:open];
    [action addAction:addFav];
    [self presentViewController:action animated:YES completion:nil];
}

- (void) openURLinBrowser: (NSString *) url {
    NSString *fullURL = [NSString stringWithFormat:@"http://www.%@", url];
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithAddress:fullURL];
    [self presentViewController:webViewController animated:YES completion:NULL];
}



@end
