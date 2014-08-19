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

@synthesize index, pageController, viewControllers, api;

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
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    EVCLargeMessageViewController *initialViewController = [[EVCLargeMessageViewController alloc] initWithMessage:WELCOME_MESSAGE_1];
    EVCLargeMessageViewController *secondViewController  = [[EVCLargeMessageViewController alloc] initWithMessage:WELCOME_MESSAGE_2];

    
    viewControllers = [NSMutableArray arrayWithObjects:initialViewController, secondViewController, nil];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    
    index++;
    
    if (index == 5) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)I {
    
    return [viewControllers objectAtIndex:I];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 5;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

@end
