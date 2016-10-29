//
//  EVCGroupSettingsHobbiesSelectionTableViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/24/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "EVCGroupSettingsHobbiesSelectionTableViewController.h"

@interface EVCGroupSettingsHobbiesSelectionTableViewController ()

@end

@implementation EVCGroupSettingsHobbiesSelectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.field.optionCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SELECT_HOBBIES_CELL"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SELECT_HOBBIES_CELL"];
    }

    cell.textLabel.text = [self.field optionAtIndex:indexPath.row];
    if ([self.field isOptionSelectedAtIndex:indexPath.row]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    int count = 0;
    for (int i = 0 ; i < [self.field optionCount] ; i++) {
        if ([self.field isOptionSelectedAtIndex:i]) {
            count++;
        }
    }
    
    if (count > 3) {
        [self.view makeToast:@"Cannot select more than 3 hobbies" duration:3.5 position:@"bottom"];
    } else {
        if ([self.field isOptionSelectedAtIndex:indexPath.row]) {
            [self.field setOptionSelected:NO atIndex:indexPath.row];
        } else {
            [self.field setOptionSelected:YES atIndex:indexPath.row];
        }
        [self.tableView reloadData];
    }
}


@end
