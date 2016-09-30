//
//  EVCResourceLinksTableViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/30/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import "EVCResourceLinksTableViewController.h"

@interface EVCResourceLinksTableViewController ()

@end

@implementation EVCResourceLinksTableViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andModuleName: (NSString *) m {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self->module = m;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    path = RES_LINKS;
    resLinks = [NSDictionary dictionaryWithContentsOfFile:path];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [self reloadData];
     
    
}

- (void) reloadData {
    if ([module isEqualToString:@"Finance"]) {
        _dataArr = [resLinks objectForKey:@"Finances"];
    } else if ([module isEqualToString:@"FeelingBlue"]) {
        _dataArr = [resLinks objectForKey:@"FeelingBlue"];
    } else if ([module isEqualToString:@"Relationships"]) {
        _dataArr = [resLinks objectForKey:@"Relationships"];
    } else if ([module isEqualToString:@"Jobs"]) {
        _dataArr = [resLinks objectForKey:@"Jobs"];
    } else if ([module isEqualToString:@"Health"]) {
        _dataArr = [resLinks objectForKey:@"Health"];
    } else if ([module isEqualToString:@"Travel"]) {
        _dataArr = [resLinks objectForKey:@"Travel"];
    } else if ([module isEqualToString:@"Volunteering"]) {
        _dataArr = [resLinks objectForKey:@"Volunteering"];
    } else if ([module isEqualToString:@"Shopping"]) {
        _dataArr = [resLinks objectForKey:@"Shopping"];
    }else {
        _dataArr = [[NSArray alloc] init];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [_dataArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    
    if ([[_dataArr objectAtIndex:indexPath.row] isEqualToString:@""]) {
        cell.textLabel.text = @"No Links Found";
    } else {
        cell.textLabel.text = [_dataArr objectAtIndex:indexPath.row];
    }
    
    
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self openURLinBrowser:[_dataArr objectAtIndex:indexPath.row]];
}

- (void) openURLinBrowser: (NSString *) url {
    NSString *fullURL = [NSString stringWithFormat:@"http://www.%@", url];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fullURL]];
    
}


@end
