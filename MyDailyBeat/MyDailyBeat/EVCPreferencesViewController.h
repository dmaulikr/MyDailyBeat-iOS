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
#import "EVCMakeFriendsPrefsViewController.h"
#import "EVCSocialPrefsViewController.h"
#import "EVCRelationshipPrefsViewController.h"
#import "EVCFlingPrefsViewController.h"
#import "EVCVolunteeringPrefsViewController.h"
#import "EVCCommonMethods.h"
#import "RESideMenu.h"

@interface EVCPreferencesViewController : UIViewController

@property(nonatomic, retain) IBOutlet UIButton *makeFriends, *date, *fling, *social, *volunteer;

@property (nonatomic, retain) API *api;

- (IBAction)makeFriends:(id)sender;
- (IBAction)socialActivites:(id)sender;
- (IBAction)relationship:(id)sender;
- (IBAction)fling:(id)sender;
- (IBAction)volunteer:(id)sender;

@end
