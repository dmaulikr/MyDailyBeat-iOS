//
//  EVCPersonalInfo1ViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/19/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVCPersonalInfo1ViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    NSMutableArray *months, *years;
}

@property (nonatomic, retain) NSString *firstName, *lastName, *birth_month, *zipcode;
@property (nonatomic) int birth_year;
@property (nonatomic, retain) IBOutlet UITextField *firstNameField, *lastNameField, *dobField, *zipCodeField;

@property (nonatomic, retain) UIPickerView *picker;

@end
