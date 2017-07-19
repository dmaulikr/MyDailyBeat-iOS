//
//  EVCProfileViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/21/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCProfileViewController.h"

@interface EVCProfileViewController ()

@end

@implementation EVCProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.opaque = NO;
    self.mTableView.backgroundColor = [UIColor clearColor];
    self.mTableView.backgroundView = nil;
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mTableView.bounces = NO;
    self.view.backgroundColor = [UIColor clearColor];
    self.mTableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    self.mScreenNameLabel.text = [[RestAPI getInstance] getCurrentUser].screenName;
    self.mScreenNameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    self.mScreenNameLabel.textColor = [UIColor whiteColor];
    self.profilePicView.layer.cornerRadius = 50;
    self.profilePicView.clipsToBounds = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([[RestAPI getInstance] getCurrentUser] != nil) {
        [self reloadData];
    }
    
}

- (void) reloadData {
    [self refreshUserData];
    [self.mTableView reloadData];
    [self loadProfilePicture];
}

- (void) refreshUserData {
    
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
            [[RestAPI getInstance] refreshCurrentUserData];
            [self.view hideToastActivity];
        });
    });
}


- (void) loadProfilePicture {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        NSURL *imageURL = [[RestAPI getInstance] retrieveProfilePicture];
        if (imageURL == nil) {
            return;
        }
        NSData *imageData = [[RestAPI getInstance] fetchImageAtRemoteURL:imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            self.profilePic = [UIImage imageWithData:imageData];
            self.profilePic = [EVCCommonMethods imageWithImage:self.profilePic scaledToSize:CGSizeMake(100, 100)];
            [self.profilePicView setImage:self.profilePic];
            
        });
    });
    
}

- (void) logout {
    
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
            [[RestAPI getInstance] logout];
            [self.view hideToastActivity];
            EVCLoginViewController *login = [[EVCLoginViewController alloc] initWithNibName:@"EVCLoginViewController_iPhone" bundle:nil];
            self.sideMenuViewController.contentViewController.view.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:login];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:KEY_SCREENNAME];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:KEY_PASSWORD];
            [self.sideMenuViewController.contentViewController.navigationController popToRootViewControllerAnimated:YES];
        });
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [self.sideMenuViewController hideMenuViewController];
        return;
    } else {
        switch (indexPath.row) {
            case 0: {
                EVCUpdateProfileViewController *prefs = [[EVCUpdateProfileViewController alloc] initWithNibName:@"EVCUpdateProfileViewController_iPhone" bundle:nil];
                [self.navigationController pushViewController:prefs animated:YES];
            }
                
                break;
            case 1: {
                EVCPreferencesViewController *prefs = [[EVCPreferencesViewController alloc] initWithNibName:@"EVCPreferencesViewController_iPhone" bundle:nil];
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:prefs] animated:YES];
            }
                [self.sideMenuViewController hideMenuViewController];
                
                break;
            case 2: {
                NSString *mailto = [NSString stringWithFormat:@"mailto:legal@evervecorp.com?subject=%@", [[RestAPI getInstance] urlencode:@"Report a Violation"]];
                NSLog(@"Opening mailto");
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailto]];
                break;
            }
                
            case 3: {
                [self logout];
                break;
            }
                
            default:
                break;
        }
        
    }
    
    
    
    
    
    
    
    
}


- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 5;
        case 1:
            return 4;
        default:
            return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.highlightedTextColor = [UIColor lightGrayColor];
    cell.selectedBackgroundView = [[UIView alloc] init];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Name";
                cell.detailTextLabel.text  = [[RestAPI getInstance] getCurrentUser].name;
                break;
            case 1:
                cell.textLabel.text = @"Email";
                cell.detailTextLabel.text  = [[RestAPI getInstance] getCurrentUser].email;
                break;
            case 2: {
                cell.textLabel.text = @"Mobile";
                NSString *mobile = [[RestAPI getInstance] getCurrentUser].mobile;
                NSString *mobile2 = @"";
                NSString *temp;
                if ([mobile length] == 11) {
                    temp = [mobile substringFromIndex:1];
                    mobile2 = [@"1-(" stringByAppendingString:[temp substringToIndex:3]];
                    temp = [temp substringFromIndex:3];
                    mobile2 = [mobile2 stringByAppendingString:@")-"];
                    mobile2 = [mobile2 stringByAppendingString:[temp substringToIndex:3]];
                    temp = [temp substringFromIndex:3];
                    mobile2 = [mobile2 stringByAppendingString:@"-"];
                    mobile2 = [mobile2 stringByAppendingString:temp];
                    cell.detailTextLabel.text  = mobile2;
                } else if ([mobile length] == 10) {
                    temp = mobile;
                    mobile2 = [@"(" stringByAppendingString:[temp substringToIndex:3]];
                    temp = [temp substringFromIndex:3];
                    mobile2 = [mobile2 stringByAppendingString:@")-"];
                    mobile2 = [mobile2 stringByAppendingString:[temp substringToIndex:3]];
                    temp = [temp substringFromIndex:3];
                    mobile2 = [mobile2 stringByAppendingString:@"-"];
                    mobile2 = [mobile2 stringByAppendingString:temp];
                    cell.detailTextLabel.text  = mobile2;

                } else if ([mobile length] == 12) {
                    mobile2 = [@"(" stringByAppendingString:[mobile substringToIndex:3]];
                    temp = [mobile substringFromIndex:3];
                    mobile2 = [mobile2 stringByAppendingString:@")"];
                    mobile2 = [mobile2 stringByAppendingString:temp];
                    cell.detailTextLabel.text  = mobile2;
                } else if ([mobile length] == 14) {
                    NSMutableString *mutableS = [[NSMutableString alloc] initWithString:mobile];
                    [mutableS insertString:@"(" atIndex:2];
                    [mutableS insertString:@")" atIndex:6];
                    mobile2 = mutableS;
                    cell.detailTextLabel.text  = mobile2;
                }
                
            }
                break;
            case 3: {
                cell.textLabel.text = @"DOB";
                NSString *dob = [[RestAPI getInstance] getCurrentUser].birth_month;
                cell.detailTextLabel.text  = [NSString stringWithFormat:@"%@ %ld", dob,[[RestAPI getInstance] getCurrentUser].birth_year];
                break;
            }
            case 4:
                cell.textLabel.text = @"Zip Code";
                cell.detailTextLabel.text  = [[RestAPI getInstance] getCurrentUser].zipcode;
                break;
                
            default:
                cell.detailTextLabel.text  = @"";
                break;
        }
    } else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Edit Profile";
        } else if (indexPath.row == 1){
            cell.textLabel.text = @"Preferences";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Report Violations";
        } else {
            cell.textLabel.text = @"Logout";
        }
    }
    
    return cell;
}



@end
