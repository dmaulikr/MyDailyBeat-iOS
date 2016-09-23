//
//  VervePreferences.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/17/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import "VervePreferences.h"

@implementation VervePreferences

- (NSArray *)extraFields
{
    return @[
             @{FXFormFieldTitle: @"Save", FXFormFieldHeader: @"", FXFormFieldAction: @"submit:"},
             ];
}

@end
