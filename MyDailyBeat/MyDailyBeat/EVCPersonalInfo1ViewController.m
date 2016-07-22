//
//  EVCPersonalInfo1ViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/19/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCPersonalInfo1ViewController.h"

@interface EVCPersonalInfo1ViewController ()

@end

@implementation EVCPersonalInfo1ViewController

@synthesize firstNameField, lastNameField, zipCodeField, birth_month, birth_date, birth_year, dobField, picker, parentController;

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
    
    picker = [[UIDatePicker alloc] init];
    picker.datePickerMode = UIDatePickerModeDate;
    picker.minimumDate = [NSDate dateWithTimeIntervalSince1970:-2207520000];
    self.dobField.inputView = picker;
    [picker addTarget:self action:@selector(dateChanged:)
     forControlEvents:UIControlEventValueChanged];
    zipCodeField.keyboardType = UIKeyboardTypeDecimalPad;
    self.monthFormatter = [[NSDateFormatter alloc] init];
    self.dayFormatter = [[NSDateFormatter alloc] init];
    self.yearFormatter = [[NSDateFormatter alloc] init];
    [self.monthFormatter setDateFormat:@"MMMM"];
    [self.dayFormatter setDateFormat:@"dd"];
    [self.yearFormatter setDateFormat:@"yyyy"];
}

- (void) dateChanged:(id)sender{
    NSDate *date = picker.date;
    birth_month = [self.monthFormatter stringFromDate:date];
    birth_date = [[self.dayFormatter stringFromDate:date] intValue];
    birth_year = [[self.yearFormatter stringFromDate:date] intValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
