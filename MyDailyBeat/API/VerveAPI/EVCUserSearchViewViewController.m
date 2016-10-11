//
//  EVCSearchViewViewController.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 11/2/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCUserSearchViewViewController.h"

@interface EVCUserSearchViewViewController ()

@end

@implementation EVCUserSearchViewViewController

- (id) init {
    
    self = [super initWithNibName:@"EVCUserSearchViewViewController_iPhone" bundle:[NSBundle bundleForClass:[self class]]];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mSearchBar.delegate = self;
    mTableView.delegate = self;
    mTableView.dataSource = self;
    cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelInvite)];
    self.navigationItem.leftBarButtonItem = cancel;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    isFiltered = FALSE;
    mTableView.tableHeaderView = mSearchBar;
    [mSearchBar setShowsScopeBar:true];
    [mSearchBar setShowsCancelButton:false animated:true];
    [mSearchBar sizeToFit];
    self.navigationItem.title = @"Search for Users";
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VerveUser *user = [self.data objectAtIndex:indexPath.row];
    EVCUserInviteViewController *inviteWriter = [[EVCUserInviteViewController alloc] initWithGroup:self.groupToInviteTo andRecipient:user withSender:[[RestAPI getInstance] getCurrentUser]];
    [self.navigationController pushViewController:inviteWriter animated:YES];
}

- (void)cancelInvite {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    switch (selectedScope) {
        case 0:
            type = SearchByScreenName;
            break;
        case 1:
            type = SearchByName;
            break;
        case 2:
            type = SearchByEmail;
            break;
            
    }
    
    NSString *text = searchBar.text;
    [self updateSearch:text];
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
        switch (type) {
            case SearchByScreenName:
                self.data = [currentSearch getUsersWithScreenNameContainingString:text withSortOrder:ASCENDING];
                break;
            case SearchByName:
                self.data = [currentSearch getUsersWithNameContainingString:text withSortOrder:ASCENDING];
                break;
            case SearchByEmail:
                self.data = [currentSearch getUsersWithEmailContainingString:text withSortOrder:ASCENDING];
                break;
        }
        [self removeUsersAlreadyInGroupFromSearchResults];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            [mTableView reloadData];
        });
        
    });
}

- (void) removeUsersAlreadyInGroupFromSearchResults {
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:self.data copyItems:YES];
    self.data = [[NSMutableArray alloc] init];
    for (VerveUser * user in temp) {
        NSMutableArray *groupsForUser = [[RestAPI getInstance] getGroupsForUser:user];
        if (groupsForUser != nil) {
            BOOL member = NO;
            for (Group *g in groupsForUser) {
                if (g.groupID == self.groupToInviteTo.groupID) {
                    member = YES;
                }
            }
            if (!member) {
                [self.data addObject:user];
            }
        } else {
            [self.data addObject:user];
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
        rowCount = (int) self.data.count;
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
        
        VerveUser *user = [self.data objectAtIndex:indexPath.row];
        cell.textLabel.text = user.screenName;
        dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
        dispatch_async(queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToastActivity];
            });
            NSURL *url = [[RestAPI getInstance] retrieveProfilePictureForUserWithScreenName:user.screenName];
            if (url != nil) {
                NSData *imageData = [NSData dataWithContentsOfURL:url];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view hideToastActivity];
                    [cell.imageView setImage:[UIImage imageWithData:imageData]];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view hideToastActivity];
                    [cell.imageView setImage:[UIImage imageNamed:@"default-avatar.png"]];
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
