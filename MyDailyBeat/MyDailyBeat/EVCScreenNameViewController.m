//
//  EVCScreenNameViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/19/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCScreenNameViewController.h"

@interface EVCScreenNameViewController ()

@end

@implementation EVCScreenNameViewController

@synthesize screenNameField, passField, verifyPassField, parentController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andParent:(EVCRegistrationViewController *) parent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parentController = parent;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    passField.secureTextEntry = YES;
    verifyPassField.secureTextEntry = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
