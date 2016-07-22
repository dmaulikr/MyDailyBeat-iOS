//
//  EVCFirstTimeSetupViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 7/12/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "EVCFirstTimeSetupViewController.h"
#import "EVCLargeMessageViewController.h"
#import "EVCFirstTimePreferencesViewController.h"

@interface EVCFirstTimeSetupViewController ()

@end

@implementation EVCFirstTimeSetupViewController

@synthesize viewControllers, currentIndex, api;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = self;
    self.delegate = self;
    api = [API getInstance];
    EVCLargeMessageViewController *first = [[EVCLargeMessageViewController alloc] initWithMessage:@"Welcome to MyDailyBeat! Before you begin, please take the time to answer a few questions."];
    VervePreferences *prefs = [self retrievePrefs];
    EVCFirstTimePreferencesViewController *user = [[EVCFirstTimePreferencesViewController alloc] initWithPrefs:prefs.userPreferences];
    EVCFirstTimePreferencesViewController *matching = [[EVCFirstTimePreferencesViewController alloc] initWithPrefs:prefs.matchingPreferences];
    EVCFirstTimePreferencesViewController *hobbies = [[EVCFirstTimePreferencesViewController alloc] initWithPrefs:prefs.hobbiesPreferences];
    viewControllers = [[NSMutableArray alloc] initWithObjects:first, user, matching, hobbies, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (VervePreferences *) retrievePrefs {
    VervePreferences *prefs = [[VervePreferences alloc] init];
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        prefs.userPreferences = [api getUserPreferencesForUser:[api getCurrentUser]];
        prefs.matchingPreferences = [api getMatchingPreferencesForUser:[api getCurrentUser]];
        prefs.hobbiesPreferences = [api getHobbiesPreferencesForUserWithScreenName:[api getCurrentUser].screenName];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
        });
    });
    
    return prefs;
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return [self.viewControllers count];
}

#pragma mark - ViewPagerDataSource
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.text = [NSString stringWithFormat:@"Step %lu", (long) index + 1];
    if (index == 1) {
        label.text = @"     User Preferences     ";
    } else if (index == 2) {
        label.text = @"     Matching Preferences     ";
    } else if (index == 3) {
        label.text = @"     Hobbies Preferences     ";
    }
    [label sizeToFit];
    
    return label;
}

#pragma mark - ViewPagerDataSource
- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    return [self.viewControllers objectAtIndex:index];
}

- (UIColor *) viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    switch (component) {
        case ViewPagerIndicator:
            return UIColorFromHex(0x0097A4);
            break;
            
        default:
            return color;
            break;
    }
}


@end
