//
//  EVCGroupSettingsViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/26/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <API.h>
#import <FXForms.h>
#import "GroupPrefs.h"
#import <EVCProfilePicView.h>
#import "UIView+Toast.h"

typedef void (^EVCGroupSettingsViewControllerCompletionHandler)(void);

@interface EVCGroupSettingsViewController : UIViewController <FXFormControllerDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property(nonatomic, retain) API *api;
@property (nonatomic, strong) FXFormController *formController;
@property (nonatomic) Group *g;

@property (nonatomic, copy) EVCGroupSettingsViewControllerCompletionHandler handler;

- (id) initWithGroup:(Group *) group andCompletionBlock:(EVCGroupSettingsViewControllerCompletionHandler) completion;

@end
