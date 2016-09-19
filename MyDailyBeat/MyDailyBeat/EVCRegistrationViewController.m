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

@synthesize api, firstName, lastName, birth_month, birth_year, screenName, password, email, mobile, zipcode;

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
    [welcome1 setText:WELCOME_MESSAGE_1];
    [welcome2 setText:WELCOME_MESSAGE_2];
    
    contentView = page1;
    
    
    
    
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
