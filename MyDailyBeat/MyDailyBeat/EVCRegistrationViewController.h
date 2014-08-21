//
//  EVCRegistrationViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/18/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVCLargeMessageViewController.h"
#import "EVCPersonalInfo1ViewController.h"
#import "EVCScreenNameViewController.h"
#import <Constants.h>
#import <API.h>
#import <SHViewPagerController.h>


@interface EVCRegistrationViewController : SHViewPagerController

@property (assign, nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) NSMutableArray *viewControllers;
@property(strong, nonatomic) API *api;

@end
