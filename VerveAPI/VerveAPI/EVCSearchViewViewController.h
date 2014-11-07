//
//  EVCSearchViewViewController.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 11/2/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVCUserSearchEngine.h"
#import "UIView+Toast.h"
#import "VerveUser.h"
#import "API.h"

@interface EVCSearchViewViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *mTableView;
    IBOutlet UISearchBar *mSearchBar;
    IBOutlet UISegmentedControl *chooser;
    BOOL isFiltered;
    SearchType type;
    EVCUserSearchEngine *currentSearch;
    
}

@property (strong, nonatomic) NSMutableArray* data;

- (id) init;

@end
