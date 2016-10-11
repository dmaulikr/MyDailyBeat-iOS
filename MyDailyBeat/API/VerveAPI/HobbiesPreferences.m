//
//  HobbiesPreferences.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 6/14/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "HobbiesPreferences.h"

@implementation HobbiesPreferences

- (NSArray *) fields {
    return @[@{FXFormFieldKey: @"books", FXFormFieldTitle: @"Books/Reading"},
             @{FXFormFieldKey: @"golf", FXFormFieldTitle: @"Golf"},
             @{FXFormFieldKey: @"cars", FXFormFieldTitle: @"Car Enthusiast"},
             @{FXFormFieldKey: @"walking", FXFormFieldTitle: @"Walking"},
             @{FXFormFieldKey: @"hiking", FXFormFieldTitle: @"Hiking"},
             @{FXFormFieldKey: @"wine", FXFormFieldTitle: @"Wine Enthusiast"},
             @{FXFormFieldKey: @"woodworking", FXFormFieldTitle: @"Woodworking"},
             @{FXFormFieldKey: @"cardsonline", FXFormFieldTitle: @"Card Games - Online"},
             @{FXFormFieldKey: @"cards", FXFormFieldTitle: @"Card Games"},
             @{FXFormFieldKey: @"gamesonline", FXFormFieldTitle: @"Online Games"},
             @{FXFormFieldKey: @"arts", FXFormFieldTitle: @"Arts & Crafts"},
             @{FXFormFieldKey: @"prayer", FXFormFieldTitle: @"Prayer Group"},
             @{FXFormFieldKey: @"support", FXFormFieldTitle: @"Support Group"},
             @{FXFormFieldKey: @"shopping", FXFormFieldTitle: @"Shopping"},
             @{FXFormFieldKey: @"travel", FXFormFieldTitle: @"Travel"},
             @{FXFormFieldKey: @"localfieldtrips", FXFormFieldTitle: @"Local Interest Field Trips"},
             @{FXFormFieldKey: @"history", FXFormFieldTitle: @"History"},
             @{FXFormFieldKey: @"sports", FXFormFieldTitle: @"Sports"}];
}

+ (HobbiesPreferences *) fromJSON: (NSMutableArray *) array {
    HobbiesPreferences *prefs = [[HobbiesPreferences alloc] init];
    prefs.books = [[array objectAtIndex:0] boolValue];
    prefs.golf = [[array objectAtIndex:1] boolValue];
    prefs.cars = [[array objectAtIndex:2] boolValue];
    prefs.walking = [[array objectAtIndex:3] boolValue];
    prefs.hiking = [[array objectAtIndex:4] boolValue];
    prefs.wine = [[array objectAtIndex:5] boolValue];
    prefs.woodworking = [[array objectAtIndex:6] boolValue];
    prefs.cardsonline = [[array objectAtIndex:7] boolValue];
    prefs.cards = [[array objectAtIndex:8] boolValue];
    prefs.gamesonline = [[array objectAtIndex:9] boolValue];
    prefs.arts = [[array objectAtIndex:10] boolValue];
    prefs.prayer = [[array objectAtIndex:11] boolValue];
    prefs.support = [[array objectAtIndex:12] boolValue];
    prefs.shopping = [[array objectAtIndex:13] boolValue];
    prefs.travel = [[array objectAtIndex:14] boolValue];
    prefs.localfieldtrips = [[array objectAtIndex:15] boolValue];
    prefs.history = [[array objectAtIndex:16] boolValue];
    prefs.sports = [[array objectAtIndex:17] boolValue];
    
    return prefs;
}

+ (NSMutableArray *) toJSON: (HobbiesPreferences *) prefs {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[NSNumber numberWithBool:prefs.books]];
    [array addObject:[NSNumber numberWithBool:prefs.golf]];
    [array addObject:[NSNumber numberWithBool:prefs.cars]];
    [array addObject:[NSNumber numberWithBool:prefs.walking]];
    [array addObject:[NSNumber numberWithBool:prefs.hiking]];
    [array addObject:[NSNumber numberWithBool:prefs.wine]];
    [array addObject:[NSNumber numberWithBool:prefs.woodworking]];
    [array addObject:[NSNumber numberWithBool:prefs.cardsonline]];
    [array addObject:[NSNumber numberWithBool:prefs.cards]];
    [array addObject:[NSNumber numberWithBool:prefs.gamesonline]];
    [array addObject:[NSNumber numberWithBool:prefs.arts]];
    [array addObject:[NSNumber numberWithBool:prefs.prayer]];
    [array addObject:[NSNumber numberWithBool:prefs.support]];
    [array addObject:[NSNumber numberWithBool:prefs.shopping]];
    [array addObject:[NSNumber numberWithBool:prefs.travel]];
    [array addObject:[NSNumber numberWithBool:prefs.localfieldtrips]];
    [array addObject:[NSNumber numberWithBool:prefs.history]];
    [array addObject:[NSNumber numberWithBool:prefs.sports]];
    return array;
}

@end
