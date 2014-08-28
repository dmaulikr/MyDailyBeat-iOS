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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 5) / 2.0f, self.view.frame.size.width, 54 * 5) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor clearColor];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
        return 1;
    }
     
     - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
    {
        return 2;
    }
     
     - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        static NSString *cellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
            cell.selectedBackgroundView = [[UIView alloc] init];
        }
        
        NSMutableArray *arrElements = [NSMutableArray arrayWithObjects:@"Home", @"Preferences", nil];
        cell.textLabel.text = [arrElements objectAtIndex:indexPath.row];
        return cell;
    }
     
     @end
