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
    UIImage* image3 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"hamburger-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(showMenu)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *menuButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    self.navigationItem.rightBarButtonItem = menuButton;
    
    UIImage* image4 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"profile-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg2 = CGRectMake(0, 0, image4.size.width, image4.size.height);
    UIButton *someButton2 = [[UIButton alloc] initWithFrame:frameimg2];
    [someButton2 setBackgroundImage:image4 forState:UIControlStateNormal];
    [someButton2 addTarget:self action:@selector(showProfile)
          forControlEvents:UIControlEventTouchUpInside];
    [someButton2 setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *profileButton =[[UIBarButtonItem alloc] initWithCustomView:someButton2];
    self.navigationItem.leftBarButtonItem = profileButton;
    
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
        for (int i = 0 ; i < [self.peeps count] ; ) {
            VerveUser *user = [self.peeps objectAtIndex:i];
            if ([user.screenName isEqualToString:[[RestAPI getInstance] getCurrentUser].screenName]) {
                [self.peeps removeObjectAtIndex:i];
            } else {
                i++;
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
    [self makeCall:indexPath.row];

}

- (void) makeCall:(NSInteger) index {
    NSString *dialstring = [[self.peeps objectAtIndex:index] mobile];
    [self makeCall2:dialstring];
}

- (void) makeCall2:(NSString *) num {
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

- (void) showMenu {
    [self.sideMenuViewController presentRightMenuViewController];
}

- (void) showProfile {
    [self.sideMenuViewController presentLeftMenuViewController];
}


@end
