//
//  EVCSearchViewViewController.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 11/2/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVCSearchEngine.h"
#import "UIView+Toast.h"
#import "VerveUser.h"
#import "API.h"
#import "EVCUserInviteViewController.h"

@interface EVCUserSearchViewViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *mTableView;
    IBOutlet UISearchBar *mSearchBar;
    UIBarButtonItem *cancel;
    BOOL isFiltered;
    UserSearchType type;
    EVCSearchEngine *currentSearch;
    
}

@property (strong, nonatomic) NSMutableArray* data;
@property (nonatomic, strong) Group *groupToInviteTo;

@end
