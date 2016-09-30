//
//  EVCHealthPortalTableViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 3/26/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "EVCHealthPortalTableViewController.h"
#import "Constants.h"
#import "HealthDatabase.h"
#import <AHKActionSheet.h>

@interface EVCHealthPortalTableViewController ()

@end

@implementation EVCHealthPortalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.healthPortals = [[NSMutableArray alloc] initWithArray:[[HealthDatabase database] healthPortals]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.healthPortals count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    if (indexPath.row == [self.healthPortals count]) {
        cell.textLabel.text = @"Add Portal";
        cell.imageView.image = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"plus-512.png"] scaledToSize:CGSizeMake(30, 30)];
    } else {
        cell.textLabel.text = ((HealthInfo * )[self.healthPortals objectAtIndex:indexPath.row]).URL;
        cell.imageView.image = nil;
    }
    
    
    
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == [self.healthPortals count]) {
        DLAVAlertView *alert = [[DLAVAlertView alloc] initWithTitle:@"Enter new health portal." message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert addTextFieldWithText:@"" placeholder:@""];
        [alert showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
            switch (buttonIndex) {
                case 0:
                    // cancel
                    break;
                case 1: {
                    // ok
                    NSString *text = [alertView textFieldTextAtIndex:0];
                    HealthInfo *portal = [[HealthInfo alloc] initWithUniqueId:0 URL:text logoURL:@""];
                    [[HealthDatabase database] insertIntoDatabase:portal orPrescriptionProvider:nil];
                    self.healthPortals = [[NSMutableArray alloc] initWithArray:[[HealthDatabase database] healthPortals]];
                    [self.tableView reloadData];
                }
                    
                default:
                    break;
            }
        }];
    } else {
        [self popupActionMenu:indexPath.row];
    }
    
}

- (void) openURLinBrowser: (NSString *) url {
    NSString *fullURL = [NSString stringWithFormat:@"%@", url];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fullURL]];
    
}

- (void) popupActionMenu: (int) row {
    AHKActionSheet *sheet = [[AHKActionSheet alloc] initWithTitle:@""];
    [sheet addButtonWithTitle:@"Open App" type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet) {
        HealthInfo *obj = [self.healthPortals objectAtIndex:row];
        [self openURLinBrowser:obj.URL];
    }];
    [sheet addButtonWithTitle:@"Set as My Health Portal" type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet) {
        HealthInfo *obj = [self.healthPortals objectAtIndex:row];
        NSData *encoded = [NSKeyedArchiver archivedDataWithRootObject:obj];
        [[NSUserDefaults standardUserDefaults] setObject:encoded forKey:@"myHealthPortal"];
    }];
    [sheet show];
}

@end
