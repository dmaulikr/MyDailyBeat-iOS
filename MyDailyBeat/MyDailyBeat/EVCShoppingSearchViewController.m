//
//  EVCShoppingSearchViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 1/25/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import "EVCShoppingSearchViewController.h"

@interface EVCShoppingSearchViewController ()

@end

@implementation EVCShoppingSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sBar.delegate = self;
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.tableHeaderView = self.sBar;
    [self.sBar setShowsScopeBar:true];
    [self.sBar setShowsCancelButton:false animated:true];
    [self.sBar sizeToFit];
    self.sBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.sBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    isFiltered = FALSE;
    
    [self loadData];

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
        
        NSDictionary *dic = [[RestAPI getInstance] searchShoppingURLSWithQueryString:@"" withSortOrder:ASCENDING];
        NSDictionary *dic2 = [[RestAPI getInstance] getShoppingFavoritesForUser:[[RestAPI getInstance] getCurrentUser] withSortOrder:ASCENDING];
        NSMutableArray *arr =[dic2 objectForKey:@"items"];
        self.searchResults = [dic objectForKey:@"items"];
        
        for (int i = 0 ; i < [arr count] ; ++i) {
            NSString *url = [arr objectAtIndex:i];
            if ([self.searchResults containsObject:url]) {
                [self.searchResults removeObject:url];
            }
        }
        
        NSLog(@"Count: %lu", (unsigned long)[self.searchResults count]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            [self.mTableView reloadData];
        });
    });

}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    
    cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [self.searchResults count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AHKActionSheet *sheet = [[AHKActionSheet alloc] initWithTitle:@""];
    [sheet addButtonWithTitle:@"Open in Browser" type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet) {
        [self openURLinBrowser: [self.searchResults objectAtIndex:indexPath.row]];
    }];
    [sheet addButtonWithTitle:@"Add to Favorites" type:AHKActionSheetButtonTypeDefault handler:^(AHKActionSheet *actionSheet) {
        [self addToFavs: [self.searchResults objectAtIndex:indexPath.row]];
    }];
    [sheet show];
}

- (void) openURLinBrowser: (NSString *) url {
    NSString *fullURL = [NSString stringWithFormat:@"http://www.%@", url];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fullURL]];
    
}

- (void) addToFavs: (NSString *) url {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        [[RestAPI getInstance] addShoppingFavoriteURL:url ForUser:[[RestAPI getInstance] getCurrentUser]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            [self loadData];
        });
        
    });
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0 && isFiltered) {
        isFiltered = FALSE;
        [self.mTableView reloadData];
    }
    
}

- (void) updateSearch:(NSString *) text {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        NSDictionary *dic = [[RestAPI getInstance] searchShoppingURLSWithQueryString:text withSortOrder:ASCENDING];
        NSDictionary *dic2 = [[RestAPI getInstance] getShoppingFavoritesForUser:[[RestAPI getInstance] getCurrentUser] withSortOrder:ASCENDING];
        NSMutableArray *arr =[dic2 objectForKey:@"items"];
        self.searchResults = [dic objectForKey:@"items"];
        
        for (int i = 0 ; i < [arr count] ; ++i) {
            NSString *url = [arr objectAtIndex:i];
            if ([self.searchResults containsObject:url]) {
                [self.searchResults removeObject:url];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            [self.mTableView reloadData];
        });
        
    });
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
        self.searchResults = [[NSMutableArray alloc] init];
        
        [self updateSearch:text];
        
    }
}


@end
