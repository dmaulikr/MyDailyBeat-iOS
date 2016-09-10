//
//  EVCFirstTimePreferencesViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 7/12/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXForms.h"
#import <API.h>
#import "VerveUserPreferences.h"
#import "VerveMatchingPreferences.h"
#import "HobbiesPreferences.h"

@interface EVCFirstTimePreferencesViewController : UIViewController <FXFormControllerDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) id<FXForm> prefs;
@property (nonatomic, retain) API *api;
@property (nonatomic, strong) FXFormController *formController;

@end
