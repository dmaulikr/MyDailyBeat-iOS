//
//  EVCRegistrationViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/18/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVCLargeMessageViewController.h"
#import <Constants.h>
#import <API.h>


@interface EVCRegistrationViewController : UIViewController <UIPageViewControllerDataSource>

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSMutableArray *viewControllers;
@property(strong, nonatomic) API *api;

@end
