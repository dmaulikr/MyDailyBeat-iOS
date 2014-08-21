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

@synthesize firstName, firstNameField, lastName, lastNameField, zipcode, zipCodeField, birth_month, birth_year, dobField, picker;

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
    
    picker = [[UIPickerView alloc] init];
    picker.dataSource = self;
    picker.delegate = self;
    self.dobField.inputView = picker;
    months = [NSMutableArray arrayWithObjects:@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November",@"December", nil];
    years = [[NSMutableArray alloc] init];
    
    birth_month = @"January";
    birth_year = 2014;
    NSString *dob = [birth_month stringByAppendingString:[NSString stringWithFormat:@" %d", birth_year]];
    self.dobField.text = dob;
    for (int i = [[[NSCalendar currentCalendar]
                   components:NSYearCalendarUnit fromDate:[NSDate date]]
                  year] ; i >= 1900 ; i--) {
        [years addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    zipCodeField.keyboardType = UIKeyboardTypeDecimalPad;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 12;
    } else {
        return [years count];
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [months objectAtIndex:row];
    } else {
        return [years objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *dob = @"";
    if (component == 0) {
        dob = [[self pickerView:picker titleForRow:row forComponent:0] stringByAppendingString:[NSString stringWithFormat:@" %d", birth_year]];
        birth_month = [self pickerView:picker titleForRow:row forComponent:0];
    } else {
        dob = [birth_month stringByAppendingString:[@" " stringByAppendingString:[self pickerView:picker titleForRow:row forComponent:1]]];
        birth_year = [[years objectAtIndex:row] intValue];
    }
    
    self.dobField.text = dob;
    
    
}

@end
