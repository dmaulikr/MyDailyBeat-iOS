//
//  VervePreferences.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/17/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import "VervePreferences.h"

@implementation VervePreferences

- (NSDictionary *) userPreferencesField {
    return @{FXFormFieldHeader: @"User Preferences"};
}

- (NSDictionary *) matchingPreferencesField {
    return @{FXFormFieldHeader: @"Matching Preferences"};
}

- (NSArray *)extraFields
{
    return @[
             @{FXFormFieldTitle: @"Save", FXFormFieldHeader: @"", FXFormFieldAction: @"submit:"},
             ];
}

@end
