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

@synthesize screenNameField, passField, verifyPassField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [screenNameField setReturnKeyType:UIReturnKeyDone];
    screenNameField.delegate = self;
    [passField setReturnKeyType:UIReturnKeyDone];
    passField.delegate = self;
    passField.secureTextEntry = YES;
    verifyPassField.secureTextEntry = YES;
    [verifyPassField setReturnKeyType:UIReturnKeyDone];
    verifyPassField.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
