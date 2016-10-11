//
//  RegisterForm3.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 9/18/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "RegisterForm3.h"


@implementation RegisterForm3

- (id) init {
    self = [super init];
    if (self) {
        self.text1 = @"You are one click away from becoming an official member!";
        self.text2 = @"So we can verify your membership, please provide the following.";
        self.text3 = @"(Additional text charges may apply based on your calling plan.)";
    }
    return self;
}

- (NSArray *)extraFields
{
    return @[
             @{FXFormFieldTitle: @"Create User", FXFormFieldAction: @"submit:"},
             ];
}

- (NSDictionary *) text1Field {
    return @{FXFormFieldCell: @"FXFormTextCell"};
}
- (NSDictionary *) text2Field {
    return @{FXFormFieldCell: @"FXFormTextCell"};
}

- (NSDictionary *) text3Field {
    return @{FXFormFieldCell: @"FXFormTextCell"};
}

- (NSDictionary *) mobileField {
    return @{FXFormFieldType: FXFormFieldTypePhone};
}

@end
