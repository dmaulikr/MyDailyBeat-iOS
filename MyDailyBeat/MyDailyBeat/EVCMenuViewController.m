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

- (id) initWithGroups:(NSMutableArray *) groupsArray {
    self = [self init];
    if (self) {
        groups = groupsArray;
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor clearColor];
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
                case 1: {
                    EVCPreferencesViewController *prefs = [[EVCPreferencesViewController alloc] initWithNibName:@"EVCPreferencesViewController_iPhone" bundle:nil];
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:prefs] animated:YES];
                }
                    
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 1:
            if (indexPath.row == [groups count]) {
                //create group here
                DLAVAlertView *groupNameAlertView = [[DLAVAlertView alloc] initWithTitle:@"Enter Name of New Group" message:@"" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            } else {
                //add group selection here
            }
            
            break;
            
        default:
            break;
    }
    
    
    
    
    
    [self.sideMenuViewController hideMenuViewController];
    
    
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"Yet Another method got called");
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    
    NSLog(@"Another method got called");
    switch (sectionIndex) {
        case 0:
            return 2;
            case 1:
             return [groups count] + 1;
            
        default:
            return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    NSLog(@"This method was called: section: %d, row: %d", indexPath.section, indexPath.row);
    
    NSMutableArray *arrElements = [NSMutableArray arrayWithObjects:@"Home", @"Preferences", nil];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
    cell.selectedBackgroundView = [[UIView alloc] init];
    
    switch (indexPath.section) {
        case 0:
            
            cell.textLabel.text = [arrElements objectAtIndex:indexPath.row];
            switch (indexPath.row) {
                case 0:
                    cell.imageView.image = [UIImage imageNamed:@"home-512"];
                    break;
                case 1:
                    cell.imageView.image = [UIImage imageNamed:@"settings-512"];
                    break;
                    
            }
            break;
        case 1:
            if (indexPath.row == [groups count]) {
                cell.textLabel.text = CREATE_NEW_GROUP;
                cell.imageView.image = [UIImage imageNamed:@"plus-512"];
            } else {
                cell.textLabel.text = [[groups objectAtIndex:indexPath.row] groupName];
            }
            break;
            
        default:
            break;
    }
    
    return cell;
}

@end
