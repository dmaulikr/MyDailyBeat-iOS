//
//  EVCLargeMessageViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/18/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCLargeMessageViewController.h"

@interface EVCLargeMessageViewController ()

@end

@implementation EVCLargeMessageViewController

@synthesize messageLabel, message;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithMessage: (NSString *) text {
    self = [super init];
    if (self) {
        self.message = text;
    }
    return self;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [messageLabel setText:message];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
