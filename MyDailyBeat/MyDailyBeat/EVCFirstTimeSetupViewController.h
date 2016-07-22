//
//  EVCFirstTimeSetupViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 7/12/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "ViewPagerController.h"
#import "Constants.h"
#import <API.h>
#import "VervePreferences.h"

@interface EVCFirstTimeSetupViewController : ViewPagerController <ViewPagerDataSource, ViewPagerDelegate>

@property (assign, nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (strong, nonatomic) API *api;



@end
