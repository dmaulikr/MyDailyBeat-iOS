//
//  EVCSearchViewViewController.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 11/2/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCSearchViewViewController.h"

@interface EVCSearchViewViewController ()

@end

@implementation EVCSearchViewViewController

- (id) init {
    self = [super initWithNibName:@"VerveAPIBundle.bundle/EVCSearchViewViewController" bundle:nil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mSearchBar.delegate = self;
    mTableView.delegate = self;
    isFiltered = FALSE;
    mTableView.tableHeaderView = mSearchBar;
    [mSearchBar setShowsScopeBar:false];
    [mSearchBar setShowsCancelButton:false animated:true];
    [mSearchBar sizeToFit];
    [chooser addTarget:self action:@selector(searchTypeChanged:) forControlEvents:UIControlEventValueChanged];
}

- (IBAction)searchTypeChanged:(id)sender {
    UISegmentedControl * segmentedControl = (UISegmentedControl *)sender;
    switch (segmentedControl.selectedSegmentIndex) {
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
    
    NSString *text = mSearchBar.text;
    [self updateSearch:text];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            [mTableView reloadData];
        });
        
    });
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        isFiltered = FALSE;
    }
    else
    {
        isFiltered = true;
        self.data = [[NSMutableArray alloc] init];
        currentSearch = [[EVCUserSearchEngine alloc] init];
        
        [self updateSearch:text];
        
    }

    [mTableView reloadData];
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
    
    if(isFiltered) {
        VerveUser *user = [self.data objectAtIndex:indexPath.row];
        cell.textLabel.text = user.screenName;
        dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
        dispatch_async(queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToastActivity];
            });
            NSURL *url = [[API getInstance] retrieveProfilePictureForUserWithScreenName:user.screenName];
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view hideToastActivity];
                [cell.imageView setImage:[UIImage imageWithData:imageData]];
                [mTableView reloadData];
            });
            
        });

    } else {
       cell.textLabel.text = @"No Results Found";
    }
    
    return cell;
}

@end
