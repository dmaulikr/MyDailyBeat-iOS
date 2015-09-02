//
//  DEMOMenuViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "EVCMenuViewController.h"

@interface EVCMenuViewController ()

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation EVCMenuViewController

@synthesize groups;

- (id) initWithGroups:(NSMutableArray *) groupsArray andParent:(UIViewController *) parent {
    self = [self init];
    if (self) {
        groups = groupsArray;
        self.parentController = parent;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 5) / 2.0f, self.view.frame.size.width, 54 * 5) style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.contentInset = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor clearColor];
    options = [NSArray arrayWithObjects:@"Check My Finances", @"Feeling Blue", @"Find a Job", @"Go Shopping", @"Have a Fling", @"Make Friends", @"Manage My Health", @"Travel", @"Volunteer", nil];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        self.groups = [[API getInstance] getGroupsForCurrentUser];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            [self.tableView reloadData];
            [self.tableView layoutIfNeeded];
        });
    });
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
                DLAVAlertView *groupNameAlertView = [[DLAVAlertView alloc] initWithTitle:@"Enter Name of New Group" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                groupNameAlertView.alertViewStyle = DLAVAlertViewStylePlainTextInput;
                [groupNameAlertView showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
                    [self.sideMenuViewController hideMenuViewController];
                    [self createGroupWithName:[alertView textFieldTextAtIndex:0]];
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
                    EVCFlingViewController *fling = [[EVCFlingViewController alloc] initWithNibName:@"EVCFlingViewController" bundle:nil];
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
                    EVCFeelingBlueViewController *fb = [[EVCFeelingBlueViewController alloc] initWithNibName:@"EVCFeelingBlueViewController" bundle:nil];
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:fb] animated:YES];
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
        BOOL success = [[API getInstance] createGroupWithName:name];
        self.groups = [[API getInstance] getGroupsForCurrentUser];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            if (success)
                [self.view makeToast:@"Upload successful!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"VerveAPIBundle.bundle/check.png"]];
            else {
                [self.view makeToast:@"Upload failed!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"VerveAPIBundle.bundle/error.png"]];
                return;
            }
            [self.tableView reloadData];
            [self.tableView layoutIfNeeded];
        });
    });
    
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.textLabel.textAlignment = UITextAlignmentRight;
    
    switch (indexPath.section) {
        case 0:
            
            cell.textLabel.text = @"Home";
            
            break;
        case 2:
            if (indexPath.row == [groups count]) {
                cell.textLabel.text = CREATE_NEW_GROUP;
            } else {
                cell.textLabel.text = [[groups objectAtIndex:indexPath.row] groupName];
            }
            break;
        case 1:
            cell.textLabel.text = [options objectAtIndex:indexPath.row];
            break;
            
        default:
            break;
    }
    
    return cell;
}

@end
