//
//  EVCFeelingBlueViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 1/9/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import "EVCFeelingBlueViewController.h"

@interface EVCFeelingBlueViewController ()

@end

@implementation EVCFeelingBlueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *TAG = @"TAG";
    
    UITableViewCell *cell = cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TAG];
    
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = @"Call Suicide Hotline";
            UIImage *image = [UIImage imageNamed:@"suicide.png"];
            image = [EVCCommonMethods imageWithImage:image scaledToSize:CGSizeMake(60, 60)];
            cell.imageView.image = image;
        }
            break;
        case 1: {
            cell.textLabel.text = @"Call Veterans Hotline";
            UIImage *image = [UIImage imageNamed:@"veterans.png"];
            image = [EVCCommonMethods imageWithImage:image scaledToSize:CGSizeMake(60, 60)];
            cell.imageView.image = image;
        }
            break;
        case 2: {
            cell.textLabel.text = @"Call Anonymously";
            UIImage *image = [UIImage imageNamed:@"anonymous.png"];
            image = [EVCCommonMethods imageWithImage:image scaledToSize:CGSizeMake(60, 60)];
            cell.imageView.image = image;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            [self makeCall: @"1-800-273-8255"];
            break;
        case 1:
            [self makeCall: @"1-800-273-8255" withAccessCode:@"1"];
            break;
        case 2: {
            EVCFeelingBlueTableViewController *table = [[EVCFeelingBlueTableViewController alloc] initWithNibName:@"EVCFeelingBlueTableViewController" bundle:nil];
            [self.navigationController pushViewController:table animated:YES];
            break;
        }
            
        default:
            break;
    }
}

- (void) makeCall:(NSString *) num {
    NSString *dialstring = [[NSString alloc] initWithFormat:@"tel://%@", num];
    NSURL *url = [NSURL URLWithString:dialstring];
    static UIWebView *webView = nil;
    static dispatch_once_t onceToken;
    [self saveToCallHistoryNumber:num withAccessCode:@""];
    dispatch_once(&onceToken, ^{
        webView = [UIWebView new];
    });
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}
- (void) makeCall:(NSString *) num withAccessCode: (NSString *) code{
    NSString *dialstring = [[NSString alloc] initWithFormat:@"tel://%@,,%@", num, code];
    NSURL *url = [NSURL URLWithString:dialstring];
    static UIWebView *webView = nil;
    static dispatch_once_t onceToken;
    [self saveToCallHistoryNumber:num withAccessCode:code];
    dispatch_once(&onceToken, ^{
        webView = [UIWebView new];
    });
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
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
