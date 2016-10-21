//
//  DEMOMenuViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "EVCMenuViewController.h"

@implementation EVCMenuViewController

@synthesize groups, tableView, logoView;

- (id) initWithGroups:(NSMutableArray *) groupsArray andParent:(UIViewController *) parent {
    self = [self initWithNibName:@"EVCMenuViewController" bundle:nil];
    if (self) {
        groups = groupsArray;
        self.parentController = parent;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.contentInset = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    self.view.backgroundColor = [UIColor clearColor];
    options = [NSArray arrayWithObjects:@"Check My Finances", @"Reach Out ...\nI'm Feeling Blue", @"Find a Job", @"Go Shopping", @"Have a Fling", @"Start a Relationship", @"Make Friends", @"Manage My Health", @"Travel", @"Refer a Friend", nil];
    imageNames = [NSArray arrayWithObjects:@"finance2", @"phone2", @"briefcase2", @"cart2", @"hearts2", @"hearts2", @"peeps2", @"health2", @"plane2", @"peeps2", nil];
    self.logoView.image = [UIImage imageNamed:@"Logo.png"];
    self.logoView.backgroundColor = [UIColor whiteColor];
    self.logoView.layer.cornerRadius = 55;
    self.logoView.clipsToBounds = YES;

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        self.groups = [[RestAPI getInstance] getGroupsForCurrentUser];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            [self.tableView reloadData];
            [self.tableView layoutIfNeeded];
        });
    });
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView2 didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView2 deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0: {
                    EVCViewController *controller = [[EVCViewController alloc] initWithNibName:@"EVCViewController_iPhone" bundle:nil];
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:controller] animated:YES];
                }
                    
                    break;
                    
                    
                default:
                    break;
            }
            break;
            
        case 2:
            if (indexPath.row == [groups count]) {
                //create group here
                DLAVAlertView *groupNameAlertView = [[DLAVAlertView alloc] initWithTitle:@"New Group" message:@"Enter the name of the new group." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                groupNameAlertView.alertViewStyle = DLAVAlertViewStylePlainTextInput;
                [groupNameAlertView showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [self.sideMenuViewController hideMenuViewController];
                        [self createGroupWithName:[alertView textFieldTextAtIndex:0]];
                    }
                }];
            } else {
                //add group selection here
                Group *g = [groups objectAtIndex:indexPath.row];
                EVCGroupViewController *controller = [[EVCGroupViewController alloc] initWithGroup:g andParent:self.parentController];
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:controller] animated:YES];
                
            }
            
            break;
        case 1:
            switch (indexPath.row) {
                case 4: {
                    EVCFlingViewController *fling = [[EVCFlingViewController alloc] initWithNibName:@"EVCFlingViewController" bundle:nil andInMode:1];
                    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"REL_MODE"];
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:fling] animated:YES];
                }
                    
                    break;
                case 5: {
                    EVCFlingViewController *fling = [[EVCFlingViewController alloc] initWithNibName:@"EVCFlingViewController" bundle:nil andInMode:2];
                    [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"REL_MODE"];
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:fling] animated:YES];
                }
                    
                    break;
                case 6: {
                    EVCFlingViewController *fling = [[EVCFlingViewController alloc] initWithNibName:@"EVCFlingViewController" bundle:nil andInMode:0];
                    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"REL_MODE"];
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:fling] animated:YES];
                }
                    
                    break;
                case 3:
                {
                    EVCShoppingViewController *shop = [[EVCShoppingViewController alloc] initWithNibName:@"EVCShoppingViewController" bundle:nil];
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:shop] animated:YES];
                }
                    break;
                case 1:
                {
                    EVCFeelingBlueTabViewController *fb = [[EVCFeelingBlueTabViewController alloc] initWithNibName:@"EVCFeelingBlueTabViewController" bundle:nil];
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:fb] animated:YES];
                }
                    break;
                case 0:
                {
                    EVCFinanceViewController *finance = [[EVCFinanceViewController alloc] initWithNibName:@"EVCFinanceViewController" bundle:nil];
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:finance] animated:YES];
                }
                    break;
                case 2: {
                    EVCJobsTabViewController *jobs = [[EVCJobsTabViewController alloc] init];
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:jobs] animated:YES];
                    break;
                }
                    
                case 8: {
                    EVCTravelTabViewController *travel = [[EVCTravelTabViewController alloc] init];
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:travel] animated:YES];
                    break;
                }
                case 7: {
                    EVCHealthViewController *health = [[EVCHealthViewController alloc] initWithNibName:@"EVCHealthViewController" bundle:nil];
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:health] animated:YES];
                }
                    break;
                case 9: {
                    DLAVAlertView *alert = [[DLAVAlertView alloc] initWithTitle:@"Refer a Friend" message:@"Enter the name and email address of the person you wish to invite to join MyDailyBeat." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Invite", nil];
                    [alert addTextFieldWithText:@"" placeholder:@"Name"];
                    [alert addTextFieldWithText:@"" placeholder:@"E-mail Address"];
                    [alert setKeyboardType:UIKeyboardTypeEmailAddress ofTextFieldAtIndex:1];
                    [alert setAutoCapitalizationType:UITextAutocapitalizationTypeNone ofTextFieldAtIndex:1];
                    [alert setAutoCorrectionType:UITextAutocorrectionTypeNo ofTextFieldAtIndex:0];
                    [alert setAutoCorrectionType:UITextAutocorrectionTypeNo ofTextFieldAtIndex:1];
                    [alert showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                        switch (buttonIndex) {
                            case 0:
                                // do nothing
                                break;
                            case 1: {
                                NSString *name = [alertView textFieldTextAtIndex:0];
                                NSString *email = [alertView textFieldTextAtIndex:1];
                                dispatch_queue_t queue = dispatch_queue_create(APP_ID_C_STRING, NULL);
                                dispatch_async(queue, ^{
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.view makeToastActivity];
                                    });
                                    BOOL result = [[RestAPI getInstance] sendReferralFromUser:[[RestAPI getInstance] getCurrentUser] toPersonWithName:name andEmail:email];
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.view hideToastActivity];
                                        if (result) {
                                            [self.view makeToast:@"Referral sent successfully!" duration:3.5 position:@"bottom"];
                                        } else {
                                            [self.view makeToast:@"Could not send referral." duration:3.5 position:@"bottom"];
                                        }
                                        
                                    });
                                });
                            }
                                break;
                                
                            default:
                                break;
                        }
                    }];
                }
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
    
    
    
    
    [self.sideMenuViewController hideMenuViewController];
    
    
}

- (void) createGroupWithName:(NSString *) name {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        BOOL success = [[RestAPI getInstance] createGroupWithName:name];
        self.groups = [[RestAPI getInstance] getGroupsForCurrentUser];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            if (success)
                [self.view makeToast:@"Upload successful!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"check.png"]];
            else {
                [self.view makeToast:@"Upload failed!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"error.png"]];
                return;
            }
            [self.tableView reloadData];
            [self.tableView layoutIfNeeded];
        });
    });
    
}

#pragma mark -
#pragma mark UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && [(NSString *)[options objectAtIndex:indexPath.row] isEqualToString:@"Reach Out ...\nI'm Feeling Blue"]) {
        return 51;
    }
    
    return 42;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    
    switch (sectionIndex) {
        case 0:
            return 1;
        case 2:
            return [groups count] + 1;
        case 1:
            return [options count];
            
        default:
            return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    
    EVCMenuTableViewCell *cell = [[EVCMenuTableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 42)andTag:cellIdentifier];
    
    if (indexPath.section == 1 && [(NSString *)[options objectAtIndex:indexPath.row] isEqualToString:@"Reach Out ...\nI'm Feeling Blue"]) {
        cell = [[EVCMenuTableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 70) andTag:@"feelingBlue"];
    }
        
        
        
    
    cell.backgroundColor = [UIColor clearColor];
    cell.lbl.textColor = [UIColor whiteColor];
    cell.lbl.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    cell.lbl.highlightedTextColor = [UIColor lightGrayColor];
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.lbl.textAlignment = UITextAlignmentRight;
    cell.lbl.lineBreakMode = UILineBreakModeWordWrap;
    cell.lbl.numberOfLines = 0;
    
    switch (indexPath.section) {
        case 0: {
            
            cell.lbl.text = @"Home";
            UIImage *icon = [UIImage imageNamed:@"home2.png"];
            cell.imgView.image = [EVCCommonMethods imageWithImage:icon scaledToSize:CGSizeMake(30, 30)];

        }
            break;
        case 2:
            if (indexPath.row == [groups count]) {
                cell.lbl.text = CREATE_NEW_GROUP;
                UIImage *icon = [UIImage imageNamed:@"newgroup2.png"];
                cell.imgView.image = [EVCCommonMethods imageWithImage:icon scaledToSize:CGSizeMake(30, 30)];
            } else {
                cell.lbl.text = [[groups objectAtIndex:indexPath.row] groupName];
                dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
                dispatch_async(queue, ^{
                    NSURL *imageURL = [[RestAPI getInstance] retrieveGroupPictureForGroup:[groups objectAtIndex:indexPath.row]];
                    if (imageURL == nil) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIImage *icon = [UIImage imageNamed:@"group2.png"];
                            cell.imgView.image = [EVCCommonMethods imageWithImage:icon scaledToSize:CGSizeMake(30, 30)];
                            
                        });
                    } else {
                        NSData *imageData = [[RestAPI getInstance] fetchImageAtRemoteURL:imageURL];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIImage *icon = [UIImage imageWithData:imageData];
                            cell.imgView.image = [EVCCommonMethods imageWithImage:icon scaledToSize:CGSizeMake(30, 30)];
                            
                            
                        });
                    }
                });
                
            }
            break;
        case 1: {
            cell.lbl.text = [options objectAtIndex:indexPath.row];
            UIImage *icon = [UIImage imageNamed:[imageNames objectAtIndex:indexPath.row]];
            cell.imgView.image = [EVCCommonMethods imageWithImage:icon scaledToSize:CGSizeMake(30, 30)];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

@end
