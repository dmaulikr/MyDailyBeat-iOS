//
//  EVCCallHistoryTableViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 5/14/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "EVCCallHistoryTableViewController.h"

@interface EVCCallHistoryTableViewController ()

@end

@implementation EVCCallHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.callHistory = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:@"callHistory"]];
    if (self.callHistory == nil || [self.callHistory count] == 0) {
        self.callHistory = [[NSMutableArray alloc] init];
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
    return [self.callHistory count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    cell.textLabel.text = [self.callHistory objectAtIndex:indexPath.row];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *number = @"";
    NSString *code = @"";
    if ([cell.textLabel.text isEqualToString:@"Suicide Hotline"]) {
        number = @"1-800-273-8255";
    } else if ([cell.textLabel.text isEqualToString:@"Veterans' Hotline"]) {
        number = @"1-800-273-8255";
        code = @"1";
    } else {
        number = cell.textLabel.text;
    }
    
    if (![code isEqualToString:@""]) {
        [self makeCall:number withAccessCode:code];
    } else {
        [self makeCall:number];
    }
    
}

- (void) makeCall:(NSString *) num {
    NSString *dialstring = [[NSString alloc] initWithFormat:@"tel:%@", num];
    NSURL *url = [NSURL URLWithString:dialstring];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:[[NSDictionary alloc] init] completionHandler:^(BOOL success) {
            if (success) {
                [self saveToCallHistoryNumber:num withAccessCode:@""];
            }
         }];
    } else {
        DLAVAlertView *alView = [[DLAVAlertView alloc] initWithTitle:@"Calling not supported" message:@"This device does not support phone calls." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alView showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
            return;
        }];
    }
}
- (void) makeCall:(NSString *) num withAccessCode: (NSString *) code{
    NSString *dialstring = [[NSString alloc] initWithFormat:@"tel:%@,,%@", num, code];
    NSURL *url = [NSURL URLWithString:dialstring];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:[[NSDictionary alloc] init] completionHandler:^(BOOL success) {
            if (success) {
                [self saveToCallHistoryNumber:num withAccessCode:code];
            }
        }];
    } else {
        DLAVAlertView *alView = [[DLAVAlertView alloc] initWithTitle:@"Calling not supported." message:@"This device does not support phone calls." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alView showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
            return;
        }];
    }
}

- (void) saveToCallHistoryNumber: (NSString *) num withAccessCode: (NSString *) code {
    if (code == nil) {
        if ([num isEqualToString:@"1-800-273-8255"]) {
            // suicide
            NSMutableArray *callHistory = [[NSUserDefaults standardUserDefaults] objectForKey:@"callHistory"];
            if (callHistory == nil) {
                callHistory = [[NSMutableArray alloc] init];
            }
            
            [callHistory insertObject:@"Suicide Hotline" atIndex:0];
            [[NSUserDefaults standardUserDefaults] setObject:callHistory forKey:@"callHistory"];
        } else {
            // save number
            NSMutableArray *callHistory = [[NSUserDefaults standardUserDefaults] objectForKey:@"callHistory"];
            if (callHistory == nil) {
                callHistory = [[NSMutableArray alloc] init];
            }
            
            [callHistory insertObject:num atIndex:0];
            [[NSUserDefaults standardUserDefaults] setObject:callHistory forKey:@"callHistory"];
        }
    } else {
        // veterans
        NSMutableArray *callHistory = [[NSUserDefaults standardUserDefaults] objectForKey:@"callHistory"];
        if (callHistory == nil) {
            callHistory = [[NSMutableArray alloc] init];
        }
        
        [callHistory insertObject:@"Veterans' Hotline" atIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:callHistory forKey:@"callHistory"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
