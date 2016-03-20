//
//  EVCInterestsSelectorTableViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 2/8/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "EVCInterestsSelectorTableViewController.h"

@interface EVCInterestsSelectorTableViewController ()

@end

@implementation EVCInterestsSelectorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *plistFile = [[paths objectAtIndex:0]
                      stringByAppendingPathComponent:@"example.plist"];
    
    self.initialInterests = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFile];
    self.travel = [self.initialInterests objectForKey:@"Travel"];
    self.volunteer = [self.initialInterests objectForKey:@"Volunteer"];
    self.ac = [self.initialInterests objectForKey:@"Arts and Crafts"];
    self.finearts = [self.initialInterests objectForKey:@"Fine Arts"];
    self.clubs = [self.initialInterests objectForKey:@"Clubs and Associations"];
    self.reading = [self.initialInterests objectForKey:@"Reading"];
    self.exercise = [self.initialInterests objectForKey:@"Exercise"];
    self.cooking = [self.initialInterests objectForKey:@"Cooking"];
    self.outdoors = [self.initialInterests objectForKey:@"Outdoors"];
    self.teaching = [self.initialInterests objectForKey:@"Teaching"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.travel.count;
        case 1:
            return self.volunteer.count;
        case 2:
            return self.ac.count;
        case 3:
            return self.finearts.count;
        case 4:
            return self.clubs.count;
        case 5:
            return self.reading.count;
        case 6:
            return self.exercise.count;
        case 7:
            return self.cooking.count;
        case 8:
            return self.outdoors.count;
        case 9:
            return self.teaching.count;
    }
    
    // can't get here
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Travel";
        case 1:
            return @"Volunteer";
        case 2:
            return @"Arts & Crafts";
        case 3:
            return @"Fine Arts";
        case 4:
            return @"Clubs";
        case 5:
            return @"Reading";
        case 6:
            return @"Exercise";
        case 7:
            return @"Cooking";
        case 8:
            return @"Outdoors";
        case 9:
            return @"Teaching";
    }
    
    // can't get here
    return @"";
}


-(UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    static NSString* cellIdentifier = @"switchCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        switch (indexPath.section) {
            case 0:
                cell.textLabel.text = [self.travel objectAtIndex:indexPath.row];
                break;
            case 1:
                cell.textLabel.text = [self.volunteer objectAtIndex:indexPath.row];
                break;
            case 2:
                cell.textLabel.text = [self.ac objectAtIndex:indexPath.row];
                break;
            case 3:
                cell.textLabel.text = [self.finearts objectAtIndex:indexPath.row];
                break;
            case 4:
                cell.textLabel.text = [self.clubs objectAtIndex:indexPath.row];
                break;
            case 5:
                cell.textLabel.text = [self.reading objectAtIndex:indexPath.row];
                break;
            case 6:
                cell.textLabel.text = [self.exercise objectAtIndex:indexPath.row];
                break;
            case 7:
                cell.textLabel.text = [self.cooking objectAtIndex:indexPath.row];
                break;
            case 8:
                cell.textLabel.text = [self.outdoors objectAtIndex:indexPath.row];
                break;
            case 9:
                cell.textLabel.text = [self.teaching objectAtIndex:indexPath.row];
                break;
        }
        if ([self.interests containsObject:cell.textLabel.text]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *selectedText = @"";
    switch (indexPath.section) {
        case 0:
            selectedText = [self.travel objectAtIndex:indexPath.row];
            break;
        case 1:
            selectedText = [self.volunteer objectAtIndex:indexPath.row];
            break;
        case 2:
            selectedText = [self.ac objectAtIndex:indexPath.row];
            break;
        case 3:
            selectedText = [self.finearts objectAtIndex:indexPath.row];
            break;
        case 4:
            selectedText = [self.clubs objectAtIndex:indexPath.row];
            break;
        case 5:
            selectedText = [self.reading objectAtIndex:indexPath.row];
            break;
        case 6:
            selectedText = [self.exercise objectAtIndex:indexPath.row];
            break;
        case 7:
            selectedText = [self.cooking objectAtIndex:indexPath.row];
            break;
        case 8:
            selectedText = [self.outdoors objectAtIndex:indexPath.row];
            break;
        case 9:
            selectedText = [self.teaching objectAtIndex:indexPath.row];
            break;
    }
    if ([self.interests containsObject:selectedText]) {
        // remove it, uncheck it
        [self.interests removeObject:selectedText];
    } else {
        // add it, check it
        [self.interests addObject:selectedText];
    }
    
    [self.tableView reloadData];
}



@end
