//
//  EVCGroupSearchViewViewController.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 11/9/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCGroupSearchViewViewController.h"

@interface EVCGroupSearchViewViewController ()

@end

@implementation EVCGroupSearchViewViewController

@synthesize mSearchBar, mTableView, data;

- (id) init {
    self = [super initWithNibName:@"EVCGroupSearchViewViewController_iPhone" bundle:[NSBundle bundleForClass:[self class]]];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mSearchBar.delegate = self;
    mTableView.delegate = self;
    mTableView.dataSource = self;
    cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSearch)];
    self.navigationItem.leftBarButtonItem = cancel;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    isFiltered = FALSE;
    mTableView.tableHeaderView = mSearchBar;
    [mSearchBar setShowsScopeBar:false];
    [mSearchBar setShowsCancelButton:false animated:true];
    [mSearchBar sizeToFit];
    self.navigationItem.title = @"Search for Groups";

}

- (void) cancelSearch {
    [self.delegate dismissGroupSearchViewController:self];
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Group *selected = [self.data objectAtIndex:indexPath.row];
    
    DLAVAlertView *alert = [[DLAVAlertView alloc] initWithTitle:@"Join Group?" message:[NSString stringWithFormat:@"Would you like to join the group %@?", selected.groupName] delegate:nil cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [alertView dismissWithClickedButtonIndex:1 animated:YES];
            dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
            dispatch_async(queue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view makeToastActivity];
                });
                BOOL success = [[RestAPI getInstance] joinGroupWithName:selected.groupName];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view hideToastActivity];
                    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                    if (success)
                        [self.presentingViewController.view makeToast:@"Successfully joined group!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"check.png"]];
                    else {
                        [self.presentingViewController.view makeToast:@"Failed to join group!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"error.png"]];
                        return;
                    }
                });
                
            });
            
        } else {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }
    }];
    
    
    
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0 && isFiltered) {
        isFiltered = FALSE;
        [mTableView reloadData];
    }
    
}

- (void) updateSearch:(NSString *) text {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        self.data = [currentSearch getGroupsWithNameContainingString:text withSortOrder:ASCENDING];
        [self removeDuplicatesFromSearchResults];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            [mTableView reloadData];
        });
        
    });
}

- (void) removeDuplicatesFromSearchResults {
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.data copyItems:YES];
    self.data = [[NSMutableArray alloc] init];
    for (Group *g in temp) {
        NSMutableArray *groupsForUser = [[RestAPI getInstance] getGroupsForCurrentUser];
        if (groupsForUser != nil) {
            BOOL member = NO;
            for (Group *g2 in groupsForUser) {
                if (g.groupID == g2.groupID) {
                    member = YES;
                }
            }
            if (!member) {
                [self.data addObject:g];
            }
        } else {
            [self.data addObject:g];
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSString *text = [searchBar text];
    if(text.length == 0)
    {
        isFiltered = FALSE;
    }
    else
    {
        isFiltered = true;
        self.data = [[NSMutableArray alloc] init];
        currentSearch = [[EVCSearchEngine alloc] init];
        
        [self updateSearch:text];
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCount;
    if(isFiltered)
        rowCount = self.data.count;
    else
        rowCount = 1;
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    if (self.data.count == 0) {
        cell.textLabel.text = @"No Results Found";
        cell.imageView.image = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    
    if(isFiltered) {
        
        Group *g = [self.data objectAtIndex:indexPath.row];
        cell.textLabel.text = g.groupName;
        dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
        dispatch_async(queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToastActivity];
            });
            NSURL *url = [[RestAPI getInstance] retrieveGroupPictureForGroup:g];
            if (url != nil) {
                NSData *imageData = [NSData dataWithContentsOfURL:url];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view hideToastActivity];
                    [cell.imageView setImage:[UIImage imageWithData:imageData]];
                });
            }
            
        });
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        
    } else {
        cell.textLabel.text = @"No Results Found";
        cell.imageView.image = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


@end
