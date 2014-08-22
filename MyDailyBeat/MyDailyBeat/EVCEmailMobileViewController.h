//
//  EVCEmailMobileViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/20/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVCAppDelegate.h"
#import "EVCRegistrationViewController.h"
#import "EVCPersonalInfo1ViewController.h"
#import "EVCScreenNameViewController.h"
#import <UIView+Toast.h>
#import <Constants.h>

#define PERSONAL_INFO_INDEX 2
#define SCREEN_NAME_INDEX 3

@class EVCRegistrationViewController;

@interface EVCEmailMobileViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *emailField, *mobileField;
@property (nonatomic, retain) IBOutlet UIButton *goButton;
@property (nonatomic, retain) EVCRegistrationViewController *parentController;

- (IBAction)go:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andParent:(EVCRegistrationViewController *) parent;

@end
