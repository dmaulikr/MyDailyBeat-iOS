//
//  EVCFinanceHomeViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/29/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import "EVCFinanceHomeViewController.h"

@interface EVCFinanceHomeViewController ()

@end

@implementation EVCFinanceHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bankList=  [[NSMutableArray alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self retrieveBanksData];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) retrieveBanksData {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        NSArray *temp = TOP_TEN_BANKS;
        for (int i = 0; i < [temp count]; ++i) {
            NSString *tempString = [temp objectAtIndex: i];
            if ([[API getInstance] doesAppExistWithTerm:tempString andCountry:@"US"]) {
                [self.bankList addObject:[[API getInstance] getBankInfoForBankWithName:tempString inCountry:@"US"]];
            }
        }
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
    return ([self.bankList count] >= 1) ? [self.bankList count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    
    if ([self.bankList count] >= 1) {
        cell.textLabel.text = ((VerveBankObject *)[self.bankList objectAtIndex:indexPath.row]).appName;
        dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
        dispatch_async(queue, ^{
            VerveBankObject *obj = [self.bankList objectAtIndex:indexPath.row];
            NSString *urlS = obj.appIconURL;
            NSURL *url = [NSURL URLWithString:urlS];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageView.image = img;
            });
        });
    }
    
    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Inside this method");
    VerveBankObject *obj = [self.bankList objectAtIndex:indexPath.row];
    if ([self isAppInstalled:obj.appName]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[obj.appName stringByAppendingString:@":"]]];
    } else {

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:obj.appStoreListing]];
    }
}

- (BOOL) isAppInstalled: (NSString *) name {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[name stringByAppendingString:@":"]]];
}

- (BOOL) doesAppExist: (NSString *) name {
    __block BOOL val = false;
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        val = [[API getInstance] doesAppExistWithTerm:name andCountry:@"US"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
        });
    });
    
    return val;
    
}



@end
