//
//  EVCPreferencesViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/23/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Constants.h>
#import "UIView+Toast.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "API.h"
#import "EVCProfilePicView.h"
#import "EVCCommonMethods.h"
#import "RESideMenu.h"
#import "FXForms.h"
#import "VervePreferences.h"
#import "EVCViewController.h"

@interface EVCPreferencesViewController : UIViewController <FXFormControllerDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) API *api;
@property (nonatomic, strong) FXFormController *formController;

@end
