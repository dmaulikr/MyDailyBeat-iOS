//
//  EVCFeelingBlueTableViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 2/6/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import "EVCFeelingBlueTableViewController.h"

@interface EVCFeelingBlueTableViewController ()

@end

@implementation EVCFeelingBlueTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    search = [[EVCSearchEngine alloc] init];
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
        
        self.peeps = [[NSMutableArray alloc] initWithArray:[search getUsersForFeelingBlue]];
        NSLog(@"Partners: %d", [self.peeps count]);
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
    return [self.peeps count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }

    
    VerveUser *user = [self.peeps objectAtIndex:indexPath.row];
    cell.textLabel.text = user.screenName;
    
    return cell;
}



#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *action = [UIAlertController alertControllerWithTitle:@"Call User?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self makeCall: indexPath.row];
    }];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //none
    }];
    
    [action addAction:no];
    [action addAction:yes];
    [self presentViewController:action animated:YES completion:nil];

}

- (void) makeCall:(NSInteger) index {
    NSString *dialstring = [[NSString alloc] initWithFormat:@"telprompt://*671%@", [[self.peeps objectAtIndex:index] mobile]];
    NSURL *url = [NSURL URLWithString:dialstring];
    [[UIApplication sharedApplication] openURL:url];
}


@end
