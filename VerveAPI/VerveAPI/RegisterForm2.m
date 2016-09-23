//
//  RegisterForm2.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 9/18/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "RegisterForm2.h"
#import "FXFormTextCell.h"

@implementation RegisterForm2

- (id) init {
    self = [super init];
    if (self) {
        self.text1 = @"Please note, only your screen name will be visible when you are engaging in the social sections.";
        self.text2 = @"Password must be a minimum of 6 characters long with at least one letter and one number. Maximum length 20 characters.";
    }
    return self;
}

- (NSDictionary *)part3Field
{
    return @{FXFormFieldTitle: @"Next >>>"};
}

- (NSDictionary *) text1Field {
    return @{FXFormFieldCell: @"FXFormTextCell"};
}
- (NSDictionary *) text2Field {
    return @{FXFormFieldCell: @"FXFormTextCell"};
}

- (NSDictionary *) screenNameField {
    return @{FXFormFieldCell: @"FXFormScreenNameCell"};
}

@end
