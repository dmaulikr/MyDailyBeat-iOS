//
//  EVCShoppingSearchViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 1/25/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <API.h>
#import <SVModalWebViewController.h>
#import "AHKActionSheet.h"

@interface EVCShoppingSearchViewController : UIViewController <UISearchBarDelegate,UITableViewDataSource, UITableViewDelegate> {
    BOOL isFiltered;
}
@property (nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic) IBOutlet UISearchBar *sBar;
@property (nonatomic) NSMutableArray *searchResults;


@end
