//
//  VolunteeringPrefs.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/24/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "VolunteeringPrefs.h"

@implementation VolunteeringPrefs

@synthesize spiritual;
@synthesize nonprofit;
@synthesize community;

- (NSMutableArray *) getBoolArray {
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithBool:spiritual], [NSNumber numberWithBool:nonprofit], [NSNumber numberWithBool:community], nil];
    return arr;
}

- (NSArray *)fields
{
    return @[
             @{FXFormFieldKey: @"spritual", FXFormFieldTitle: @"Spiritual", FXFormFieldType: FXFormFieldTypeBoolean},
             @{FXFormFieldKey: @"nonprofit", FXFormFieldTitle: @"Nonprofit", FXFormFieldType: FXFormFieldTypeBoolean},
             @{FXFormFieldKey: @"community", FXFormFieldTitle: @"Community", FXFormFieldType: FXFormFieldTypeBoolean}
             ];
}

- (NSArray *)extraFields
{
    return @[
             @{FXFormFieldTitle: @"OK", FXFormFieldHeader: @"", FXFormFieldAction: @"submit:"},
             ];
}





@end
