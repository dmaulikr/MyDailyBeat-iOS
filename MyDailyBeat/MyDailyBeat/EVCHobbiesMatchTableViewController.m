//
//  EVCHobbiesMatchTableViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 7/3/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "EVCHobbiesMatchTableViewController.h"

@interface EVCHobbiesMatchTableViewController ()

@end

@implementation EVCHobbiesMatchTableViewController

@synthesize matches;

- (void)viewDidLoad {
    [super viewDidLoad];
    matches = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadMatches {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        NSMutableArray *arr = [[API getInstance] getHobbiesMatchesForUserWithScreenName:[[API getInstance] getCurrentUser].screenName];
        dispatch_async(dispatch_get_main_queue(), ^{
            [matches addObjectsFromArray:arr];
            [self.view hideToastActivity];
            [self.tableView reloadData];
        });
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [matches count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    HobbiesMatchObject *match = [matches objectAtIndex:indexPath.row];
    cell.textLabel.text = match.userObj.screenName;
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
