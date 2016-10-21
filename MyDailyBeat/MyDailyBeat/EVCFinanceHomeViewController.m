//
//  EVCFinanceHomeViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/29/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import "EVCFinanceHomeViewController.h"
#import "BankDatabase.h"
#import "DLAVAlertView.h"
#import "EVCCommonMethods.h"
#import "AHKActionSheet.h"

@interface EVCFinanceHomeViewController ()

@end

@implementation EVCFinanceHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bankList=  [[NSMutableArray alloc] init];
    self.iconList = [[NSMutableArray alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
    self.edgesForExtendedLayout = UIRectEdgeAll;
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
        BankDatabase *db = [BankDatabase database];
        self.bankList = [[NSMutableArray alloc] initWithArray:[db bankInfos]];
        for (int i = 0 ; i < [self.bankList count] ; i++) {
            BOOL load = [[NSUserDefaults standardUserDefaults] boolForKey:@"LOAD_BANK_IMAGES"];
            if (load) {
                NSURL *imgurl = [NSURL URLWithString:((BankInfo *)[self.bankList objectAtIndex:i]).iconURL];
                NSData *data = [[RestAPI getInstance] fetchImageAtRemoteURL:imgurl];
                UIImage *img = [[UIImage alloc] initWithData:data];
                [self.iconList addObject:img];
            } else {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LOAD_BANK_IMAGES"];
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
    return ([self.bankList count] >= 1) ? [self.bankList count] + 3 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    
    if ([self.bankList count] >= 1) {
        if (indexPath.row < [self.bankList count]) {
            cell.textLabel.text = ((BankInfo *)[self.bankList objectAtIndex:indexPath.row]).appName;
            if (!([self.iconList count] == 0)) {
                cell.imageView.image = [self.iconList objectAtIndex:indexPath.row];
            } else {
                cell.imageView.image = nil;
            }
        } else if (indexPath.row == [self.bankList count]) {
            cell.textLabel.text = @"Add Bank";
            cell.imageView.image = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"plus-512.png"] scaledToSize:CGSizeMake(30, 30)];
        } else {
            cell.textLabel.text = @"";
            cell.imageView.image = nil;
        }
    } else {
        cell.textLabel.text = @"Add Bank";
        cell.imageView.image = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"plus-512.png"] scaledToSize:CGSizeMake(30, 30)];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.bankList count] >= 1) {
        if (indexPath.row < [self.bankList count]) {
            [self popupActionMenu:indexPath.row];
        } else if (indexPath.row == [self.bankList count]){
            // add new bank
            [self addBank];
        } else {
            // do nothing
        }
        
    } else {
        // add new bank
        [self addBank];
    }
    
}

- (void) popupActionMenu: (int) row {
    AHKActionSheet *sheet = [[AHKActionSheet alloc] initWithTitle:@""];
    [sheet addButtonWithTitle:@"Open App" type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet) {
        BankInfo *obj = [self.bankList objectAtIndex:row];
        
        NSString *appURL = obj.appURL;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appURL]];
    }];
    [sheet addButtonWithTitle:@"Set as My Bank" type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet) {
        BankInfo *obj = [self.bankList objectAtIndex:row];
        NSData *bankEncoded = [NSKeyedArchiver archivedDataWithRootObject:obj];
        [[NSUserDefaults standardUserDefaults] setObject:bankEncoded forKey:@"myBank"];
    }];
    [sheet show];
}

- (void) addBank {
    DLAVAlertView *alert = [[DLAVAlertView alloc] initWithTitle:@"Add new bank" message:@"Enter the name of the bank you wish to add." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Bank", nil];
    [alert addTextFieldWithText:@"" placeholder:@"Bank name"];
    [alert showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        NSString *text = [alert textFieldTextAtIndex:0] ;
        dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
        dispatch_async(queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToastActivity];
            });
            if ([[RestAPI getInstance] doesAppExistWithTerm:text andCountry:@"US"]) {
                VerveBankObject *bank = [[RestAPI getInstance] getBankInfoForBankWithName:text inCountry:@"US"];
                BankInfo *info = [[BankInfo alloc] initWithUniqueId:0 name:bank.appName appURL:bank.appStoreListing iconURL:bank.appIconURL];
                BankDatabase *db = [BankDatabase database];
                [db insertIntoDatabase:info];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view hideToastActivity];
                [self retrieveBanksData];
            });
        });
    }];
}

- (BOOL) isAppInstalled: (NSString *) name {
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[name stringByAppendingString:@"://"]]];
}

- (BOOL) doesAppExist: (NSString *) name {
    __block BOOL val = false;
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        val = [[RestAPI getInstance] doesAppExistWithTerm:name andCountry:@"US"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
        });
    });
    
    return val;
    
}



@end
