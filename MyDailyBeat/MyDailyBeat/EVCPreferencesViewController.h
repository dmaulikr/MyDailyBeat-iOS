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

@interface EVCPreferencesViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic, retain) IBOutlet UIButton *changePic, *makeFriends, *date, *fling, *social, *volunteer;

@property (nonatomic, retain) UIImagePickerController *imgPicker;
@property (nonatomic, retain) API *api;

- (IBAction)changeProfilePic:(id)sender;
- (IBAction)makeFriends:(id)sender;
- (IBAction)socialActivites:(id)sender;
- (IBAction)relationship:(id)sender;
- (IBAction)fling:(id)sender;
- (IBAction)volunteer:(id)sender;

@end
