//
//  EVCAppDelegate.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/17/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVCViewController.h"
#import "EVCRegistrationViewController.h"
#import "EVCMenuViewController.h"
#import "EVCProfileViewController.h"
#import "EVCLoginViewController.h"
#import "API.h"

@interface EVCAppDelegate : UIResponder <UIApplicationDelegate, RESideMenuDelegate>

@property (strong, nonatomic) UIWindow *window;

- (BOOL)hasEverBeenLaunched;

@end
