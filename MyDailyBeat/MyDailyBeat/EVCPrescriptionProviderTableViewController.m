//
//  EVCPrescriptionProviderTableViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 3/26/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "EVCPrescriptionProviderTableViewController.h"
#import "Constants.h"
#import "HealthDatabase.h"
#import <DLAVAlertView.h>
#import "API.h"
#import "EVCCommonMethods.h"
#import <AHKActionSheet.h>

@interface EVCPrescriptionProviderTableViewController ()

@end

@implementation EVCPrescriptionProviderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.pharmacyProviders = [[NSMutableArray alloc] initWithArray:[[HealthDatabase database] prescripProviders]];
    for (int i = 0 ; i < [self.pharmacyProviders count] ; i++) {
        NSLog(@"%@", ((PrescripProviderInfo *)[self.pharmacyProviders objectAtIndex:i]).URL);
    }
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
    return [self.pharmacyProviders count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    
    
    if (indexPath.row == [self.pharmacyProviders count]) {
        cell.textLabel.text = @"Add Provider";
        cell.imageView.image = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"plus-512.png"] scaledToSize:CGSizeMake(30, 30)];
    } else {
        cell.textLabel.text = ((PrescripProviderInfo *)[self.pharmacyProviders objectAtIndex:indexPath.row]).URL;
    }
    
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == [self.pharmacyProviders count]) {
        DLAVAlertView *alert = [[DLAVAlertView alloc] initWithTitle:@"Enter new prescription provider" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert addTextFieldWithText:@"" placeholder:@""];
        [alert showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
            switch (buttonIndex) {
                case 0:
                    // cancel
                    break;
                case 1: {
                    // ok
                    NSString *text = [alertView textFieldTextAtIndex:0];
                    PrescripProviderInfo *prov = [[PrescripProviderInfo alloc] initWithUniqueId:0 URL:text logoURL:@""];
                    [[HealthDatabase database] insertIntoDatabase:nil orPrescriptionProvider:prov];
                    self.pharmacyProviders = [[NSMutableArray alloc] initWithArray:[[HealthDatabase database] prescripProviders]];
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
        PrescripProviderInfo *obj = [self.pharmacyProviders objectAtIndex:row];
        [self openURLinBrowser:obj.URL];
    }];
    [sheet addButtonWithTitle:@"Set as My Prescription Provider" type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet) {
        PrescripProviderInfo *obj = [self.pharmacyProviders objectAtIndex:row];
        NSData *encoded = [NSKeyedArchiver archivedDataWithRootObject:obj];
        [[NSUserDefaults standardUserDefaults] setObject:encoded forKey:@"myPrescripProvider"];
    }];
    [sheet show];
}


@end
