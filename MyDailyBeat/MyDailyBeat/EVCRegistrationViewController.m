//
//  EVCRegistrationViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/18/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCRegistrationViewController.h"

@interface EVCRegistrationViewController ()

@end

@implementation EVCRegistrationViewController

@synthesize currentIndex, viewControllers, api, firstName, lastName, birth_month, birth_year, screenName, password, email, mobile, zipcode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    api = [API getInstance];
    currentIndex = 0;
    
    EVCLargeMessageViewController *initialViewController = [[EVCLargeMessageViewController alloc] initWithMessage:WELCOME_MESSAGE_1];
    EVCLargeMessageViewController *secondViewController  = [[EVCLargeMessageViewController alloc] initWithMessage:WELCOME_MESSAGE_2];
    EVCPersonalInfo1ViewController *thirdViewController = [[EVCPersonalInfo1ViewController alloc] initWithNibName:@"EVCPersonalInfo1ViewController_iPhone" bundle:nil andParent:self];
    EVCScreenNameViewController *fourthViewController = [[EVCScreenNameViewController alloc] initWithNibName:@"EVCScreenNameViewController_iPhone" bundle:nil andParent:self];
    EVCEmailMobileViewController *fifthViewController = [[EVCEmailMobileViewController alloc] initWithNibName:@"EVCEmailMobileViewController_iPhone" bundle:nil andParent:self];
    
    
    viewControllers = [NSMutableArray arrayWithObjects:initialViewController, secondViewController, thirdViewController, fourthViewController, fifthViewController, nil];
    
    
    
    
    [self.viewPager reloadData];
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)I {
    
    return [viewControllers objectAtIndex:I];
    
}

- (NSInteger)numberOfPagesInViewPager:(SHViewPager *)viewPager {
    return [viewControllers count];
}

- (UIViewController *)containerControllerForViewPager:(SHViewPager *)viewPager {
    return self;
}

- (UIViewController *)viewPager:(SHViewPager *)viewPager controllerForPageAtIndex:(NSInteger)index {
    return [self viewControllerAtIndex:index];
}

- (NSString *)viewPager:(SHViewPager *)viewPager titleForPageMenuAtIndex:(NSInteger)index {
    return @"";
}

- (UIImage *)indexIndicatorImageForViewPager:(SHViewPager *)viewPager {
    return nil;
}

@end
