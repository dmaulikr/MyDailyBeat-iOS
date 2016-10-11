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
#import "RestAPI.h"
#import "EVCUserInviteViewController.h"

@class EVCUserSearchViewViewController;

@protocol EVCUserSearchViewDelegate <NSObject>

- (void) dismissUserSearchViewController: (EVCUserSearchViewViewController *) controller;

@end

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
@property (nonatomic, weak) id<EVCUserSearchViewDelegate> delegate;

@end
